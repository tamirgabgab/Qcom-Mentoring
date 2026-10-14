#!/usr/bin/env python3
"""Project code-style pass for the SystemVerilog sources.

    python3 scripts/sv_style.py --fix     rewrite files in place
    python3 scripts/sv_style.py --check   exit 1 and list the files that are not in style (CI)
    python3 scripts/sv_style.py --fix path/to/file.sv ...

Rules (text based; `make lint` with slang is the safety net):

1. Locals of a function are declared at its top: the configuration block that reads
   uvm_config_db ("begin  uvm_bitstream_t cfg_x; if (uvm_config_int::get(...)) ...  end")
   is unwrapped -- declarations first, then super.build_phase(), then the get() calls.
2. The body of if / else / for / foreach / while / repeat is always a begin ... end
   block, also when it is a single statement: `if (x) y = 1;` and
   `foreach (p[i]) s += p[i];` are first split over two lines, then wrapped.
   Constraint and `with {...}` blocks are left alone (begin/end is not legal there).
3. Out-of-class method bodies are separated by a blank line and a //----- delimiter.
4. `extern // comment` glued prototypes are repaired to `extern virtual ...`.

Rules 5-11 concern the classes and packages (interfaces, modules and the RTL are not touched;
the Lab 11A register model keeps the register names). Rule 5 is fixed in place, the others are
reported as `path:line: R<n> message` and exit 1:

5. Packed widths without a space: `bit[7:0]`, `logic[15:0]`.
6. Every class property starts with `m_` (rand fields, knobs, sub-component handles, ports, vif);
   arguments and locals of a method never do. Static/const members and parameters are exempt.
   The UVM runtime names stay plain: create("monitor"), new("item_collected_port"), config_db keys.
7. Constraints are `extern constraint c_x;` in the class and `constraint cls::c_x { ... }` after
   endclass (same pattern as the methods).
8. Order: properties, utils macro, covergroups, extern constraints, extern methods; after
   endclass the constraint bodies, then the method bodies.
9. typedefs and enums live in the package's <pkg>_defines.sv (included first by the package),
   not in the class files; a typedef inside a class or a function is fine.
10. Enum types end with `_e`; their values are UPPER_CASE, carry the type name as prefix and start
   with <NAME>_UNDEFINED: `typedef enum { PARITY_TYPE_UNDEFINED, PARITY_TYPE_GOOD, ... } parity_type_e;`
11. A constraint body is laid out like a method body: the `//---` delimiter line right above it,
   `constraint cls::c_x {` on its own line, one statement per line, `}` alone (no one-line bodies).
"""
from __future__ import annotations

import argparse
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
TREES = ("yapp_project", "labs", "common", "test_install")
DELIM = "//" + "-" * 78
INDENT = "  "

CTRL_RX = re.compile(r"^(?:end\s+)?(?:else\s+)?(?:if|for|foreach|while|repeat)\s*\(")
ELSE_RX = re.compile(r"^(?:end\s+)?else$")
IF_RX = re.compile(r"^(?:end\s+)?(?:else\s+)?if\s*\(")
BODY_RX = re.compile(r"^(\s*)(function|task)\b[^;\n]*\b\w+::\w+\s*\(")
CFG_RX = re.compile(
    r"^([ \t]*)// configuration formerly applied by the field automation\n"
    r"\1begin\n((?:\1[ \t]+[^\n]*\n)+?)\1end\n", re.M)
EXTERN_RX = re.compile(r"^([ \t]*)extern[ \t]*//[^\n]*\n[ \t]*(?=(?:virtual|static|protected|local)\b)", re.M)


# --------------------------------------------------------------------------- helpers
def code_of(line: str) -> str:
    """The code part of a line: strings blanked, // comment removed, stripped."""
    out = []
    i, n = 0, len(line)
    in_str = False
    while i < n:
        c = line[i]
        if in_str:
            if c == "\\":
                i += 2
                continue
            if c == '"':
                in_str = False
            i += 1
            continue
        if c == '"':
            in_str = True
            out.append('""')
        elif line.startswith("//", i):
            break
        else:
            out.append(c)
        i += 1
    return "".join(out).strip()


def split_comment(line: str) -> tuple[str, str]:
    """('code part incl. trailing spaces removed', '// comment' or '')"""
    in_str = False
    i = 0
    while i < len(line):
        c = line[i]
        if in_str:
            if c == "\\":
                i += 2
                continue
            if c == '"':
                in_str = False
        elif c == '"':
            in_str = True
        elif line.startswith("//", i):
            return line[:i].rstrip(), line[i:]
        i += 1
    return line.rstrip(), ""


def indent_of(line: str) -> str:
    return re.match(r"[ \t]*", line).group(0)


def is_blank(line: str) -> bool:
    return line.strip() == ""


def is_comment(line: str) -> bool:
    return line.lstrip().startswith("//")


# --------------------------------------------------------------------------- rule 4
def fix_extern(text: str) -> str:
    return EXTERN_RX.sub(r"\1extern ", text)


# --------------------------------------------------------------------------- rule 1
def hoist_config(text: str) -> str:
    def repl(m: re.Match) -> str:
        ind = m.group(1)
        inner = [l for l in m.group(2).splitlines()]
        decls = [l.strip() for l in inner if not l.strip().startswith("if ")]
        gets = [l.strip() for l in inner if l.strip().startswith("if ")]
        repl.pending.append((m.start(), ind, decls))
        lines = [f"{ind}// overrides set with uvm_config_int::set(...)"] + [f"{ind}{g}" for g in gets]
        return "\n".join(lines) + "\n"

    repl.pending = []
    new = CFG_RX.sub(repl, text)
    if not repl.pending:
        return text
    # insert the declarations right after the enclosing function header
    for start, ind, decls in sorted(repl.pending, reverse=True):
        head = new.rfind("\nfunction ", 0, start)
        head = new.rfind("function ", 0, start) if head < 0 else head + 1
        eol = new.index("\n", head)
        hdr = new[head:eol]
        # multi-line headers end at the first ');'
        while not hdr.rstrip().endswith(";"):
            eol = new.index("\n", eol + 1)
            hdr = new[head:eol]
        ins = "".join(f"{ind}{d}\n" for d in decls)
        new = new[:eol + 1] + ins + new[eol + 1:]
    return new


# --------------------------------------------------------------------------- rule 2
class Wrapper:
    """Wrap single-statement control bodies that sit on their own line in begin/end."""

    def __init__(self, lines: list[str]):
        self.lines = lines
        self.depth = 0          # {} depth -- constraints, with-blocks, concatenations

    def run(self) -> list[str]:
        i = 0
        while i < len(self.lines):
            i = self.step(i)
        return self.lines

    def brace_delta(self, code: str) -> int:
        return code.count("{") - code.count("}")

    def header_end(self, i: int) -> int | None:
        """i is a control header line: return the index of the line where its '(...)' closes
        and nothing but the header remains; None if this is not a wrap candidate."""
        code = code_of(self.lines[i])
        if ELSE_RX.match(code):
            return i
        if not CTRL_RX.match(code):
            return None
        bal = code.count("(") - code.count(")")
        j = i
        while bal > 0 and j + 1 < len(self.lines):
            j += 1
            c = code_of(self.lines[j])
            bal += c.count("(") - c.count(")")
            code = code + " " + c
        if bal != 0:
            return None
        if not code.rstrip().endswith(")"):
            return None             # same-line body or 'begin' -> leave alone
        return j

    def next_code(self, i: int) -> int:
        j = i
        while j < len(self.lines) and (is_blank(self.lines[j]) or is_comment(self.lines[j])):
            j += 1
        return j

    def stmt_end(self, i: int) -> int:
        """Index of the last line of the statement starting at line i (no wrapping done)."""
        code = code_of(self.lines[i])
        first = code.split()[0] if code else ""
        if first == "begin" or first.startswith("begin:") or code.startswith("begin "):
            return self.block_end(i, "begin", "end")
        if first == "case" or first in ("unique", "priority") and " case" in code:
            return self.block_end(i, "case", "endcase")
        if first == "fork":
            return self.block_end(i, "fork", ("join", "join_any", "join_none"))
        if code.startswith("`"):
            # macro call: runs until the parentheses balance
            bal = code.count("(") - code.count(")")
            j = i
            while bal > 0 and j + 1 < len(self.lines):
                j += 1
                c = code_of(self.lines[j])
                bal += c.count("(") - c.count(")")
            return j
        j = i
        while j < len(self.lines):
            c = code_of(self.lines[j])
            if c.endswith(";"):
                return j
            j += 1
        return i

    def block_end(self, i: int, open_kw, close_kw) -> int:
        closes = (close_kw,) if isinstance(close_kw, str) else tuple(close_kw)
        depth = 0
        j = i
        while j < len(self.lines):
            toks = re.findall(r"[A-Za-z_]\w*", code_of(self.lines[j]))
            for t in toks:
                if t == open_kw:
                    depth += 1
                elif t in closes:
                    depth -= 1
                    if depth == 0:
                        return j
            j += 1
        return i

    def step(self, i: int) -> int:
        """Process line i (and whatever it opens); return the next line index to look at."""
        line = self.lines[i]
        code = code_of(line)
        if self.depth > 0 or not code:
            self.depth += self.brace_delta(code)
            return i + 1
        hend = self.header_end(i)
        if hend is None:
            self.depth += self.brace_delta(code)
            return i + 1
        # header spans i..hend; is the body already a block?
        b = self.next_code(hend + 1)
        if b >= len(self.lines):
            return i + 1
        bcode = code_of(self.lines[b])
        if bcode.startswith("begin") and (len(bcode) == 5 or not bcode[5].isalnum() and bcode[5] != "_"):
            # 'begin' on its own line under the header: pull it up onto the header line
            ind = indent_of(line)
            if b == hend + 1 and bcode == "begin" and indent_of(self.lines[b]) != ind:
                e = self.block_end(b, "begin", "end")
                bind = indent_of(self.lines[b])
                hcode, hcmt = split_comment(self.lines[hend])
                _, bcmt = split_comment(self.lines[b])
                cmts = "  ".join(c for c in (hcmt, bcmt) if c)
                self.lines[hend] = hcode + " begin" + (("  " + cmts) if cmts else "")
                shift = len(bind) - len(ind)
                for k in range(b + 1, e + 1):
                    l = self.lines[k]
                    if not is_blank(l) and l.startswith(" " * shift):
                        self.lines[k] = l[shift:]
                del self.lines[b]
            return hend + 1
        # multi-line headers that contain braces (randomize() with {...}): keep depth in sync -> 0
        # ---- wrap: begin on the header line
        ind = indent_of(line)
        hcode, hcmt = split_comment(self.lines[hend])
        self.lines[hend] = hcode + " begin" + (("  " + hcmt) if hcmt else "")
        # body: lines b0..e, re-indented to ind + INDENT
        b0 = hend + 1
        e = self.body_end(b)
        target = ind + INDENT
        cur = indent_of(self.lines[b])
        if cur != target:
            for k in range(b0, e + 1):
                l = self.lines[k]
                if is_blank(l):
                    continue
                if l.startswith(cur):
                    self.lines[k] = target + l[len(cur):]
                else:
                    self.lines[k] = target + l.lstrip()
        # closing end (merged with a following else)
        nxt = self.next_code(e + 1)
        if nxt < len(self.lines) and IF_RX.match(code):
            ncode = code_of(self.lines[nxt])
            if ncode == "else" or ncode.startswith("else ") or ncode.startswith("else\t"):
                ncode_full, ncmt = split_comment(self.lines[nxt])
                stripped = ncode_full.lstrip()
                self.lines[nxt] = ind + "end " + stripped + (("  " + ncmt) if ncmt else "")
                # drop blank/comment lines between body end and else? keep comments, drop blanks
                k = e + 1
                while k < nxt:
                    if is_blank(self.lines[k]):
                        del self.lines[k]
                        nxt -= 1
                    else:
                        k += 1
                return b0      # re-scan the body (nested headers) and then the else line
        self.lines.insert(e + 1, ind + "end")
        return b0

    def body_end(self, b: int) -> int:
        """Last line of the single statement that starts at line b (nested control headers
        are followed through, but not wrapped here -- the main loop re-scans them)."""
        code = code_of(self.lines[b])
        hend = self.header_end(b)
        if hend is not None:
            nb = self.next_code(hend + 1)
            if nb >= len(self.lines):
                return hend
            nbcode = code_of(self.lines[nb])
            if nbcode.startswith("begin"):
                e = self.block_end(nb, "begin", "end")
            else:
                e = self.body_end(nb)
            # an else-chain belongs to the same statement (if-headers only)
            while IF_RX.match(code):
                nxt = self.next_code(e + 1)
                if nxt >= len(self.lines):
                    return e
                ncode = code_of(self.lines[nxt])
                if not (ncode == "else" or ncode.startswith("else ")):
                    return e
                if ncode.endswith("begin"):
                    e = self.block_end(nxt, "begin", "end")
                    continue
                eh = self.header_end(nxt)
                if eh is None:
                    # 'else stmt;' on one line
                    e = self.stmt_end(nxt)
                    continue
                nb2 = self.next_code(eh + 1)
                e = self.block_end(nb2, "begin", "end") if code_of(self.lines[nb2]).startswith("begin") else self.body_end(nb2)
            return e
        # same-line control with a body: 'if (x) y;' or 'foreach (p[i]) if (...) z;'
        return self.stmt_end(b)


ONE_ELSE_RX = re.compile(r"^(\s*(?:end\s+)?else)\s+(?!if\b)(?!begin\b)(\S.*)$")
CTRL_KW_RX = re.compile(r"^(?:if|for|foreach|while|repeat)\s*\(")


def scan(code: str, start: int, stop_at_semi: bool = False, depth: int = 0) -> tuple[int, int]:
    """Walk code from start, skipping strings and nested (), {}, [].
    stop_at_semi: return (index of the first top-level ';', 0).
    Otherwise return (index of the bracket that brings the depth back to 0, 0).
    Not found on this line: (-1, depth reached at the end of the line)."""
    i, n = start, len(code)
    while i < n:
        c = code[i]
        if c == '"':
            i += 1
            while i < n and code[i] != '"':
                i += 2 if code[i] == "\\" else 1
        elif c in "({[":
            depth += 1
        elif c in ")}]":
            depth -= 1
            if not stop_at_semi and depth == 0:
                return i, 0
        elif c == ";" and stop_at_semi and depth == 0:
            return i, 0
        i += 1
    return -1, depth


def split_one_liners(lines: list[str]) -> list[str]:
    """Move the body of a control statement that shares a line with its header to a line
    of its own, so that the Wrapper puts it in begin/end:
        if (x) y = 1;              ->  if (x)  /  y = 1;
        if (a) x; else y;          ->  if (a)  /  x;  /  else  /  y;
    Multi-line headers and multi-line bodies (a case, a macro call) are followed."""
    depth = 0           # {} depth: constraints and with-blocks are skipped
    i = 0
    while i < len(lines):
        line = lines[i]
        code, cmt = split_comment(line)
        stripped = code.strip()
        in_macro = code.endswith("\\") or (i > 0 and lines[i - 1].rstrip().endswith("\\"))
        if depth != 0 or not stripped or in_macro:
            depth += code_of(line).count("{") - code_of(line).count("}")
            i += 1
            continue
        ind = indent_of(line)
        m = CTRL_RX.match(stripped)
        if m:
            # find the ')' closing the header, possibly some lines further down
            j, col = i, len(ind) + m.end() - 1
            close, bal = scan(code, col)
            while close < 0 and bal > 0 and j + 1 < len(lines):
                j += 1
                close, bal = scan(split_comment(lines[j])[0], 0, depth=bal)
            if close < 0:
                i += 1
                continue
            hcode, hcmt = split_comment(lines[j])
            rest = hcode[close + 1:].strip()
            if not rest or rest == ";" or re.match(r"begin\b", rest):
                i = j + 1
                continue
            body, tail = rest, ""
            if IF_RX.match(stripped) and not CTRL_KW_RX.match(rest):
                semi, _ = scan(rest, 0, stop_at_semi=True)
                if semi >= 0 and re.match(r"\s*else\b", rest[semi + 1:]):
                    body, tail = rest[:semi + 1], rest[semi + 1:].strip()
            new = [hcode[:close + 1].rstrip(),
                   ind + INDENT + body + (("  " + hcmt) if hcmt and not tail else "")]
            if tail:
                new.append(ind + tail + (("  " + hcmt) if hcmt else ""))
            lines[j:j + 1] = new
            if not tail:
                indent_continuation(lines, j + 1)
            i += 1                  # the header lines i..j stay; the body is re-scanned
            continue
        m = ONE_ELSE_RX.match(code)
        if m:
            lines[i:i + 1] = [m.group(1), ind + INDENT + m.group(2).strip() + (("  " + cmt) if cmt else "")]
            indent_continuation(lines, i + 1)
            i += 1
            continue
        depth += code_of(line).count("{") - code_of(line).count("}")
        i += 1
    return lines


def indent_continuation(lines: list[str], b: int) -> None:
    """The body that now starts on line b may run over more lines (a case, a macro call):
    indent its other lines one level too."""
    e = Wrapper(lines).stmt_end(b)
    for k in range(b + 1, e + 1):
        if not is_blank(lines[k]):
            lines[k] = INDENT + lines[k]


def wrap_bodies(text: str) -> str:
    lines = text.split("\n")
    lines = split_one_liners(lines)
    lines = Wrapper(lines).run()
    return "\n".join(lines)


# --------------------------------------------------------------------------- rule 3
def delimit_bodies(text: str) -> str:
    lines = text.split("\n")
    out: list[str] = []
    for idx, line in enumerate(lines):
        m = BODY_RX.match(line)
        if m and (idx == 0 or not lines[idx - 1].rstrip().endswith(("extern", ","))):
            ind = m.group(1)
            # leading comment block directly above the body belongs to it
            k = len(out)
            while k > 0 and is_comment(out[k - 1]) and not re.match(r"^\s*//-{10,}\s*$", out[k - 1]):
                k -= 1
            # previous non-blank line
            p = k - 1
            while p >= 0 and is_blank(out[p]):
                p -= 1
            if p >= 0 and not re.match(r"^\s*//-{10,}\s*$", out[p]):
                head = out[:p + 1]
                tail = out[k:]
                out = head + ["", ind + DELIM] + tail
        out.append(line)
    return "\n".join(out)


# --------------------------------------------------------------------------- rules 5-11
# These rules concern the classes and packages only: interfaces, modules and the RTL are skipped.
CLASS_FILE_RX = re.compile(r"^\s*(?:virtual\s+)?class\s+\w+", re.M)
PKG_FILE_RX = re.compile(r"^\s*package\s+\w+", re.M)
WIDTH_RX = re.compile(r"\b(bit|logic|byte|int|integer|reg)\s+\[")
CLASS_RX = re.compile(r"^\s*(?:virtual\s+)?class\s+(\w+)")
# a declaration: [qualifiers] type[#(...)][ranges] name[ranges][= init](, name...)?;
DECL_RX = re.compile(
    r"^\s*((?:(?:rand|randc|protected|local|static|const|virtual|automatic)\s+)*)"
    r"([A-Za-z_][\w:$]*(?:\s*#\s*\([^;]*?\))?(?:\s*\[[^\]]*\])*)\s+"
    r"([A-Za-z_]\w*(?:\s*\[[^\]]*\])*(?:\s*=\s*[^,;]+)?(?:\s*,\s*[A-Za-z_]\w*(?:\s*\[[^\]]*\])*(?:\s*=\s*[^,;]+)?)*)\s*;")
NOT_DECL = {"return", "extern", "typedef", "parameter", "localparam", "import", "export", "function", "task",
            "constraint", "covergroup", "endclass", "endfunction", "endtask", "endgroup", "begin", "end", "if",
            "else", "for", "foreach", "while", "repeat", "case", "default", "super", "this", "assert", "wait",
            "fork", "join", "join_any", "join_none", "disable", "void", "input", "output", "inout", "ref"}
EXT_FN_RX = re.compile(r"^\s*extern\b.*\b(?:function|task)\b")
EXT_CONS_RX = re.compile(r"^\s*extern\s+constraint\s+(\w+)")
IN_CONS_RX = re.compile(r"^\s*constraint\s+(\w+)\s*\{")
OUT_CONS_RX = re.compile(r"^\s*constraint\s+(\w+)::(\w+)")
OUT_FN_RX = re.compile(r"^\s*(?:(?:virtual|static|protected|local)\s+)*(?:function|task)\b[^;]*\b(\w+)::(\w+)\s*\(")
ENUM_RX = re.compile(r"typedef\s+enum\b[^{]*\{([^}]*)\}\s*(\w+)\s*;", re.S)
TYPEDEF_RX = re.compile(r"^\s*typedef\b")
SAMPLE_RX = re.compile(r"with\s+function\s+sample\s*\(([^)]*)\)")
REG_MODEL_RX = re.compile(r"/reg/|lab11a_rm_gen/|yapp_router_reg_pkg\.sv$")   # Lab 11A register model (generator layout)


def is_class_file(text: str) -> bool:
    return bool(CLASS_FILE_RX.search(text))


def fix_width_spacing(text: str) -> str:
    """Rule 5: `bit [7:0]` -> `bit[7:0]` in the class files (comments included, so they match the code)."""
    if not is_class_file(text):
        return text
    return WIDTH_RX.sub(r"\1[", text)


def decl_names(code: str):
    """Names declared by a declaration line (code part), or [] when the line is not one."""
    m = DECL_RX.match(code)
    if not m:
        return [], ""
    quals, typ = m.group(1), m.group(2)
    head = typ.split()[0].split("#")[0].split("[")[0]
    if head in NOT_DECL or "(" in typ.split("#")[0] or "." in head or "::" in head and head.endswith("::"):
        return [], quals
    names = []
    for part in re.split(r",(?![^(]*\))", m.group(3)):
        nm = part.strip().split("=")[0].split("[")[0].strip()
        if nm:
            names.append(nm)
    return names, quals


def check_rules(path: pathlib.Path, text: str) -> list[tuple[int, str, str]]:
    """Rules 6-11 report (line, rule, message); nothing is rewritten."""
    out: list[tuple[int, str, str]] = []
    lines = text.split("\n")
    code = [code_of(l) for l in lines]
    klass = is_class_file(text)
    pkg = bool(PKG_FILE_RX.search(text))
    if not (klass or pkg or path.name.endswith("_defines.sv")):
        return out
    if REG_MODEL_RX.search(path.as_posix()):
        return out      # the register model mirrors the register map: its classes keep the register names
    # ---- rule 9/10: typedefs live in <pkg>_defines.sv; enums are NAME_UNDEFINED, NAME_X, ...
    depth_cls = depth_fn = depth_cg = 0
    for i, c in enumerate(code):
        if CLASS_RX.match(c):
            depth_cls += 1
        elif re.match(r"^endclass\b", c):
            depth_cls -= 1
        elif re.match(r"^(?:extern\s+)?(?:(?:virtual|static|protected|local|pure)\s+)*(?:function|task)\b", c) and not c.startswith("extern") \
                and not re.match(r"^(?:(?:virtual|static|protected|local|pure)\s+)*(?:function|task)\b.*;\s*$", c) and "sample" not in c:
            depth_fn += 1
        elif re.match(r"^end(?:function|task)\b", c):
            depth_fn -= 1
        elif re.match(r"^covergroup\b", c):
            depth_cg += 1
        elif re.match(r"^endgroup\b", c):
            depth_cg -= 1
        if TYPEDEF_RX.match(c) and depth_cls == 0 and depth_fn == 0 and depth_cg == 0 \
                and not path.name.endswith("_defines.sv"):
            out.append((i + 1, "R9", "typedef outside a <pkg>_defines.sv file (move it there)"))
    for m in ENUM_RX.finditer(text):
        ln = text.count("\n", 0, m.start()) + 1
        name = m.group(2)
        if not name.endswith("_e"):
            out.append((ln, "R10", f"enum type '{name}' must end with _e"))
            continue
        prefix = name[:-2].upper() + "_"
        vals = [re.sub(r"//[^\n]*", "", v).strip().split("=")[0].strip() for v in m.group(1).split(",")]
        vals = [v for v in vals if v]
        if not vals or vals[0] != prefix + "UNDEFINED":
            out.append((ln, "R10", f"enum '{name}': first value must be {prefix}UNDEFINED"))
        for v in vals:
            if not re.fullmatch(r"[A-Z0-9_]+", v):
                out.append((ln, "R10", f"enum '{name}': value '{v}' must be upper case letters, digits and _"))
            elif not v.startswith(prefix):
                out.append((ln, "R10", f"enum '{name}': value '{v}' must start with {prefix}"))
    if not klass:
        return out
    # ---- rules 6, 7, 8 per class
    i = 0
    while i < len(code):
        m = CLASS_RX.match(code[i])
        if not m:
            i += 1
            continue
        cls = m.group(1)
        e = next((k for k in range(i, len(code)) if re.match(r"^endclass\b", code[k])), len(code) - 1)
        parameterized = "#" in code[i]      # rnd_array #(N): its methods stay inline (out-of-class bodies need #(N))
        first_fn = None
        depth_fn = depth_cg = 0
        for k in range(i + 1, e):
            c = code[k]
            if not c:
                continue
            if re.match(r"^covergroup\b", c):
                depth_cg += 1
                continue
            if re.match(r"^endgroup\b", c):
                depth_cg -= 1
                continue
            if depth_cg:
                continue
            if re.match(r"^(?:(?:virtual|static|protected|local)\s+)*(?:function|task)\b", c):
                depth_fn += 1
                if not parameterized:
                    out.append((k + 1, "R3", f"{cls}: method body inside the class (declare it extern)"))
                continue
            if re.match(r"^end(?:function|task)\b", c):
                depth_fn -= 1
                continue
            if depth_fn:
                continue
            if IN_CONS_RX.match(c):
                out.append((k + 1, "R7", f"{cls}: constraint body inside the class (extern constraint {IN_CONS_RX.match(c).group(1)}; "
                                          f"and constraint {cls}::{IN_CONS_RX.match(c).group(1)} after endclass)"))
                continue
            if EXT_FN_RX.match(c):
                first_fn = first_fn if first_fn is not None else k
                continue
            if EXT_CONS_RX.match(c):
                if first_fn is not None:
                    out.append((k + 1, "R8", f"{cls}: extern constraint after the extern methods (constraints first)"))
                continue
            names, quals = decl_names(c)
            if "static" in quals or "const" in quals:
                continue
            for nm in names:
                if not nm.startswith("m_"):
                    out.append((k + 1, "R6", f"{cls}: property '{nm}' must start with m_"))
        # after endclass: constraint bodies before the method bodies, no m_ on arguments and locals
        first_body = None
        k = e + 1
        while k < len(code) and not CLASS_RX.match(code[k]):
            c = code[k]
            oc = OUT_CONS_RX.match(c)
            if oc and oc.group(1) == cls:
                if first_body is not None:
                    out.append((k + 1, "R8", f"{cls}: constraint {oc.group(2)} body after a method body (constraints first)"))
                if not c.rstrip().endswith("{"):
                    out.append((k + 1, "R11", f"{cls}: constraint {oc.group(2)} on one line (open with '{{', one statement per line)"))
                j = k - 1
                while j >= 0 and lines[j].strip() == "":
                    j -= 1
                if j < 0 or lines[j].strip() != DELIM:
                    out.append((k + 1, "R11", f"{cls}: constraint {oc.group(2)} needs the {DELIM[:6]}... delimiter line above it"))
            fm = OUT_FN_RX.match(c)
            if fm and fm.group(1) == cls:
                first_body = first_body if first_body is not None else k
                args = re.findall(r"\bm_\w+", c.split("(", 1)[1] if "(" in c else "")
                for a in args:
                    out.append((k + 1, "R6", f"{cls}::{fm.group(2)}: argument '{a}' must not start with m_ (m_ is for properties)"))
                # locals at the top of the body
                j = k + 1
                while j < len(code) and not re.match(r"^end(?:function|task)\b", code[j]):
                    if code[j] == "":
                        j += 1
                        continue
                    names, quals = decl_names(code[j])
                    if not names:
                        break
                    for nm in names:
                        if nm.startswith("m_"):
                            out.append((j + 1, "R6", f"{cls}::{fm.group(2)}: local '{nm}' must not start with m_ (m_ is for properties)"))
                    j += 1
            k += 1
        i = e + 1
    for m in SAMPLE_RX.finditer(text):
        for a in re.findall(r"\bm_\w+", m.group(1)):
            out.append((text.count("\n", 0, m.start()) + 1, "R6", f"sample() argument '{a}' must not start with m_"))
    return out


# --------------------------------------------------------------------------- driver
def restyle(text: str) -> str:
    new = fix_extern(text)
    new = hoist_config(new)
    new = wrap_bodies(new)
    new = delimit_bodies(new)
    new = fix_width_spacing(new)
    new = re.sub(r"\n{3,}", "\n\n", new)
    return new.rstrip("\n") + "\n"


def iter_files(paths: list[str]) -> list[pathlib.Path]:
    if paths:
        return [pathlib.Path(p) for p in paths]
    files: list[pathlib.Path] = []
    for tree in TREES:
        files += sorted((ROOT / tree).rglob("*.sv"))
        files += sorted((ROOT / tree).rglob("*.svh"))
    return files


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--fix", action="store_true", help="rewrite files in place")
    g.add_argument("--check", action="store_true", help="report files that would change")
    ap.add_argument("--diff", action="store_true", help="with --check: print a unified diff")
    ap.add_argument("files", nargs="*")
    args = ap.parse_args()

    changed = []
    violations: list[tuple[pathlib.Path, int, str, str]] = []
    for f in iter_files(args.files):
        text = f.read_text(encoding="utf-8")
        new = restyle(text)
        for ln, rule, msg in check_rules(f, new):
            violations.append((f, ln, rule, msg))
        if new == text:
            continue
        changed.append(f)
        if args.fix:
            f.write_text(new, encoding="utf-8")
        elif args.diff:
            import difflib
            sys.stdout.writelines(difflib.unified_diff(
                text.splitlines(True), new.splitlines(True), str(f), str(f) + " (styled)"))
    def rel(p: pathlib.Path) -> str:
        return str(p.relative_to(ROOT)) if p.is_absolute() and ROOT in p.parents else str(p)
    for f, ln, rule, msg in violations:
        print(f"{rel(f)}:{ln}: {rule} {msg}")
    if args.fix:
        print(f"sv_style: {len(changed)} file(s) rewritten" + (f", {len(violations)} violation(s) to fix by hand" if violations else ""))
        return 0
    if changed:
        print("sv_style: files not in style (run: python3 scripts/sv_style.py --fix):")
        for p in changed:
            print("  " + rel(p))
    if changed or violations:
        print(f"sv_style: {len(violations)} violation(s)" if violations else "")
        return 1
    print("sv_style: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
