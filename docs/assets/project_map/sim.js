/* sim.js -- two small interactive models of the YAPP router for teaching:
 *
 *   RouterModel      the HBUS register file + what a packet does to it, exactly as the RTL
 *                    (yapp_project/rtl/yapp_hbus_regs.sv, yapp_input_fsm.sv): RW/RO policy,
 *                    unmapped addresses, counters gated by en_reg, yapp_pkt_mem, mem_size_reg,
 *                    the drop rules (router_en, maxpktsize, address 3) and the error pulse.
 *   packet helpers   encode / parse / check a YAPP packet (header, payload, even parity).
 *
 *   YappSim.mount(host, "regs" | "packet", model)   builds a widget inside `host`
 *   <div class="yapp-sim" data-sim="regs"></div>   auto-mounted on the docs pages
 *
 * The register map comes from regmap.js (generated from scripts/project_map/regmap.yaml), so
 * the picture, the simulator and the checks against the RTL share one table.
 * No dependencies; used by the project map (inlined) and by the MkDocs site.
 */
(function () {
  "use strict";

  // ------------------------------------------------------------------ helpers
  const hex = (v, w) => "0x" + (v >>> 0).toString(16).padStart(w || 2, "0");
  const bin8 = v => (v & 0xff).toString(2).padStart(8, "0");
  function parseNum(s) {
    s = String(s == null ? "" : s).trim().replace(/_/g, "");
    if (!s) return NaN;
    let m;
    if ((m = s.match(/^(?:\d+)?'[hH]([0-9a-fA-F]+)$/))) return parseInt(m[1], 16);
    if ((m = s.match(/^(?:\d+)?'[dD](\d+)$/))) return parseInt(m[1], 10);
    if ((m = s.match(/^(?:\d+)?'[bB]([01]+)$/))) return parseInt(m[1], 2);
    if (/^0x[0-9a-f]+$/i.test(s)) return parseInt(s, 16);
    if (/^[0-9a-f]+h$/i.test(s)) return parseInt(s.slice(0, -1), 16);
    if (/^\d+$/.test(s)) return parseInt(s, 10);
    if (/^[0-9a-f]+$/i.test(s)) return parseInt(s, 16);
    return NaN;
  }
  function parseBytes(text) {
    // "1d 11 22 33 2f", "0x1d,0x11", "1d112233", one per line ...
    const t = String(text || "").replace(/0x/gi, " ").replace(/[,;]/g, " ").trim();
    if (!t) return [];
    const toks = t.split(/\s+/);
    const out = [];
    for (const tok of toks) {
      if (!/^[0-9a-f]+$/i.test(tok)) return null;
      if (tok.length > 2 && tok.length % 2 === 0 && toks.length === 1) {
        for (let i = 0; i < tok.length; i += 2) out.push(parseInt(tok.slice(i, i + 2), 16));
      } else {
        const v = parseInt(tok, 16);
        if (v > 255) return null;
        out.push(v);
      }
    }
    return out;
  }
  const fmtBytes = bytes => Array.from(bytes, b => b.toString(16).padStart(2, "0")).join(" ");
  function el(tag, attrs, children) {
    const e = document.createElement(tag);
    if (attrs) for (const k in attrs) {
      if (k === "class") e.className = attrs[k];
      else if (k === "html") e.innerHTML = attrs[k];
      else if (k === "text") e.textContent = attrs[k];
      else if (k === "value") e.value = attrs[k];
      else if (k.startsWith("on")) e.addEventListener(k.slice(2), attrs[k]);
      else if (attrs[k] !== null && attrs[k] !== undefined && attrs[k] !== false) e.setAttribute(k, attrs[k] === true ? "" : attrs[k]);
    }
    (children || []).forEach(c => { if (c !== null && c !== undefined && c !== false) e.append(c); });
    return e;
  }
  const field = (label, input) => el("label", { class: "ys-f" }, [el("span", { text: label }), input]);
  function radio(options, value, onchange) {
    const box = el("div", { class: "ys-radio" });
    const draw = () => { box.innerHTML = ""; options.forEach(([v, l]) => box.append(el("button", { type: "button", class: v === value ? "on" : "", onclick: () => { value = v; draw(); onchange(v); } }, [l]))); };
    draw();
    return box;
  }
  const evenParity = bytes => bytes.reduce((p, b) => p ^ b, 0) & 0xff;
  function randomBytes(n) {
    const a = new Uint8Array(n);
    if (window.crypto && crypto.getRandomValues) crypto.getRandomValues(a); else for (let i = 0; i < n; i++) a[i] = Math.floor(Math.random() * 256);
    return Array.from(a);
  }

  // ------------------------------------------------------------------ the register file + router effects
  class RouterModel {
    constructor(regmap) {
      this.rm = regmap || window.YAPP_REGMAP;
      if (!this.rm) throw new Error("YAPP_REGMAP missing (regmap.js not loaded)");
      this.regs = new Map();                     // addr -> value
      this.byName = {};
      this.counter = {};                         // counter key -> addr
      this.rm.registers.forEach(r => { this.byName[r.name] = r; if (r.counter) this.counter[r.counter] = r.addr; });
      this.mems = this.rm.memories.map(m => ({ ...m, data: new Uint8Array(m.size) }));
      this.listeners = [];
      this.log = [];
      this.lastAddr = null;
      this.changed = new Set();                  // addresses changed by the last operation
      this.memNew = {};                          // mem name -> Set(indexes written by the last packet)
      this.packets = 0;
      this.reset(true);
    }
    // -- observers (widgets); listeners whose element left the page are dropped
    on(fn, host) { this.listeners.push({ fn, host }); }
    emit() {
      this.listeners = this.listeners.filter(l => !l.host || l.host.isConnected);
      this.listeners.forEach(l => { try { l.fn(); } catch (e) { console.error(e); } });
    }
    addLog(cls, text) { this.log.push({ cls, text }); if (this.log.length > 200) this.log.shift(); }

    reset(cold) {
      this.rm.registers.forEach(r => this.regs.set(r.addr, r.reset & 0xff));
      if (cold) this.mems.forEach(m => m.data.fill(0));
      this.changed = new Set(this.regs.keys());
      this.memNew = {};
      this.lastAddr = null;
      this.addLog("warn", cold ? "power-up: registers at reset values, memories cleared" : "reset: registers back to their reset values (memories keep their contents, as in the RTL)");
      this.emit();
    }
    describe(addr) {
      const r = this.rm.registers.find(x => x.addr === addr);
      if (r) return { kind: "reg", reg: r, name: r.name, policy: r.policy };
      const m = this.mems.find(x => addr >= x.base && addr < x.base + x.size);
      if (m) return { kind: "mem", mem: m, index: addr - m.base, name: `${m.name}[${addr - m.base}]`, policy: m.policy };
      return { kind: "unmapped", name: "unmapped", policy: "none" };
    }
    peek(addr) {
      const d = this.describe(addr);
      if (d.kind === "reg") return this.regs.get(addr);
      if (d.kind === "mem") return d.mem.data[d.index];
      return 0x00;                               // rd_mux default
    }
    poke(addr, v) {                              // backdoor: no policy, no log
      const d = this.describe(addr);
      if (d.kind === "reg") this.regs.set(addr, v & 0xff);
      else if (d.kind === "mem") d.mem.data[d.index] = v & 0xff;
    }
    read(addr) {
      const d = this.describe(addr);
      const value = this.peek(addr);
      this.lastAddr = addr; this.changed = new Set();
      const text = `RD ${hex(addr, 4)} => ${hex(value)}   ${d.name}${d.kind === "unmapped" ? " (reads as 0x00)" : ""}`;
      this.addLog(d.kind === "unmapped" ? "warn" : "ok", text);
      this.emit();
      return { ok: true, value, info: d, text };
    }
    write(addr, data) {
      const d = this.describe(addr);
      data &= 0xff;
      this.lastAddr = addr; this.changed = new Set();
      let ok = false, why = "";
      if (d.kind === "reg" && d.policy === "RW") { this.regs.set(addr, data); ok = true; this.changed.add(addr); }
      else if (d.kind === "mem" && d.policy === "RW") { d.mem.data[d.index] = data; ok = true; }
      else if (d.kind === "unmapped") why = "unmapped address: the write is ignored";
      else why = `${d.name} is read-only (${d.kind === "mem" ? "the router fills it" : "the router counts into it"}): the write is ignored`;
      const text = `WR ${hex(addr, 4)} <= ${hex(data)}   ${d.name}` + (ok ? "" : `   -- ${why}`);
      this.addLog(ok ? "ok" : "bad", text);
      this.emit();
      return { ok, info: d, text, why };
    }
    // -- decoded fields
    get ctrl() { return this.regs.get(this.byName.ctrl_reg.addr); }
    get en() { return this.regs.get(this.byName.en_reg.addr); }
    get maxpktsize() { return this.ctrl & 0x3f; }
    enBit(i) { return (this.en >> i) & 1; }
    counterValue(key) { return this.regs.get(this.counter[key]); }
    fieldsOf(r) {                                // [{name, bits, value}]
      const v = this.regs.get(r.addr);
      return (r.fields || []).map(f => {
        const m = String(f.bits).match(/^(\d+)(?::(\d+))?$/);
        const hi = +m[1], lo = m[2] === undefined ? hi : +m[2];
        return { ...f, value: (v >> lo) & ((1 << (hi - lo + 1)) - 1), hi, lo };
      });
    }

    // -- a packet arrives on the YAPP input (yapp_input_fsm.sv + yapp_hbus_regs.sv)
    send(bytes) {
      bytes = Array.from(bytes || []);
      const rep = { bytes, notes: [], counters: [], memWritten: 0, error: false, forwarded: null, dropped: false, done: false };
      this.changed = new Set(); this.memNew = {}; this.lastAddr = null;
      if (!bytes.length) { rep.notes.push("no bytes: nothing happens"); this.emit(); return rep; }
      const hdr = bytes[0], len = hdr >> 2, addr = hdr & 3;
      rep.addr = addr; rep.len = len;
      const routerEn = this.enBit(0), maxp = this.maxpktsize;
      const oversized = len > maxp, illegal = addr === 3;
      const drop = !routerEn || oversized || illegal;
      rep.dropped = drop;
      rep.reason = !routerEn ? "router disabled (en_reg[0] = 0)" : illegal ? "illegal address 3" : oversized ? `length ${len} > maxpktsize ${maxp}` : "";
      if (len === 0) rep.notes.push("length 0: the FSM counts 64 payload bytes before it expects the parity byte (byte_cnt wraps) -- not a legal packet");
      const need = (len === 0 ? 64 : len) + 2;
      const before = {};
      Object.keys(this.counter).forEach(k => { before[k] = this.counterValue(k); });
      // bytes stored while they arrive (header with the live router_en, payload with the latched one)
      const pm = this.mems.find(m => m.name === "yapp_pkt_mem");
      const stored = new Set();
      if (routerEn && pm) {
        pm.data[0] = hdr; stored.add(0);
        for (let i = 1; i < Math.min(bytes.length, need - 1); i++) { if (i < pm.size) { pm.data[i] = bytes[i]; stored.add(i); } }
      }
      rep.memWritten = stored.size;
      if (stored.size) this.memNew[pm.name] = stored;
      if (bytes.length < need) {
        rep.notes.push(`only ${bytes.length} of ${need} bytes: the DUT is still waiting for ${need - bytes.length} more byte(s) -- no pkt_done, nothing counted yet`);
        this.packets++;
        this.addLog("warn", `PKT addr=${addr} len=${len}: incomplete (${bytes.length}/${need} bytes)`);
        this.emit();
        return rep;
      }
      if (bytes.length > need) rep.notes.push(`${bytes.length - need} extra byte(s) after the parity byte: the DUT treats them as the start of the next packet`);
      const payload = bytes.slice(1, need - 1), parity = bytes[need - 1];
      const expected = evenParity([hdr, ...payload]);
      rep.payload = payload; rep.parity = parity; rep.expected = expected; rep.consumed = need;
      rep.parityErr = parity !== expected;
      rep.done = routerEn;                       // pkt_done = PARITY && accept && cur_enabled
      if (routerEn) {
        // end of packet: mem_size_reg, counters (each behind its enable), the error timer
        this.regs.set(this.byName.mem_size_reg.addr, len & 0xff); this.changed.add(this.byName.mem_size_reg.addr);
        const bump = (key, en) => { if (this.enBit(en)) { const a = this.counter[key]; this.regs.set(a, (this.regs.get(a) + 1) & 0xff); this.changed.add(a); } };
        if (rep.parityErr) bump("parity_err", 1);
        if (oversized) bump("oversized", 2);
        bump("addr" + addr, 4 + addr);
        rep.error = rep.parityErr;               // error timer start = pkt_done && pkt_parity_err
        rep.forwarded = drop ? null : addr;
      } else {
        rep.notes.push("router_en = 0 at the header: nothing stored, nothing counted, no error pulse (ROUTER DROPS PACKET ... router disabled)");
      }
      Object.keys(this.counter).forEach(k => { const a = this.counterValue(k); rep.counters.push({ key: k, name: this.rm.registers.find(r => r.addr === this.counter[k]).name, before: before[k], after: a }); });
      rep.memSize = this.regs.get(this.byName.mem_size_reg.addr);
      this.packets++;
      const what = drop ? `DROPPED (${rep.reason})` : `forwarded to channel ${addr}`;
      this.addLog(drop ? "bad" : "ok", `PKT addr=${addr} len=${len} parity=${hex(parity)}${rep.parityErr ? " BAD (expected " + hex(expected) + ")" : ""}: ${what}` +
        (rep.error ? "; error pulses 1..10 cycles later" : ""));
      this.emit();
      return rep;
    }
  }

  // ------------------------------------------------------------------ packet helpers
  function encodePacket(f) {
    const len = Math.max(0, Math.min(63, f.length | 0)), addr = f.addr & 3;
    const payload = (f.payload || []).slice(0, 63).map(b => b & 0xff);
    const hdr = (len << 2) | addr;
    let parity = evenParity([hdr, ...payload]);
    if (f.corrupt !== undefined && f.corrupt !== null && f.corrupt !== false) parity ^= 1 << (f.corrupt | 0);
    if (typeof f.parity === "number") parity = f.parity & 0xff;
    return { bytes: [hdr, ...payload, parity], header: hdr, parity, expected: evenParity([hdr, ...payload]) };
  }
  function checkPacket(bytes, ctx) {
    // ctx: { maxpktsize, routerEn, declaredLength (build mode) }
    ctx = ctx || {};
    const out = { checks: [], ok: true };
    const bad = (t, d) => { out.checks.push({ s: "bad", t, d }); out.ok = false; };
    const warn = (t, d) => { out.checks.push({ s: "warn", t, d }); };
    const good = (t, d) => { out.checks.push({ s: "ok", t, d }); };
    if (!bytes || !bytes.length) { bad("no bytes"); return out; }
    const hdr = bytes[0], len = hdr >> 2, addr = hdr & 3;
    Object.assign(out, { header: hdr, len, addr });
    if (addr === 3) bad(`address ${addr} is illegal`, "the router counts it in addr3_cnt_reg and drops the packet (c_addr_legal forbids it)"); else good(`address ${addr} -> channel ${addr}`);
    if (len < 1) bad(`length ${len}: must be 1 .. 63`); else good(`length ${len} (payload bytes)`, "6 bits, 1 .. 63");
    const need = len + 2;
    if (bytes.length === need) good(`${bytes.length} bytes = length + 2 (header + payload + parity)`);
    else if (bytes.length < need) bad(`${bytes.length} bytes, but length says ${need}: ${need - bytes.length} missing`, "payload.size() must equal length -- the DUT would wait for the missing bytes");
    else warn(`${bytes.length} bytes, but length says ${need}: ${bytes.length - need} extra`, `the DUT takes byte ${need - 1} as the parity byte and starts a new packet with the rest`);
    const payload = bytes.slice(1, Math.min(bytes.length - 1, need - 1));
    const parity = bytes[Math.min(bytes.length, need) - 1];
    const expected = evenParity([hdr, ...payload]);
    Object.assign(out, { payload, parity, expected });
    if (bytes.length >= 2) {
      if (parity === expected) good(`parity ${hex(parity)} is correct`, "even bitwise parity: XOR of the header and every payload byte");
      else bad(`parity ${hex(parity)}, expected ${hex(expected)}`, "parity_err_cnt_reg increments (if enabled) and `error` pulses; the packet is still forwarded");
    }
    if (ctx.maxpktsize !== undefined) {
      if (len > ctx.maxpktsize) warn(`length ${len} > maxpktsize ${ctx.maxpktsize}`, "oversized: dropped, oversized_pkt_cnt_reg increments (if enabled)");
      else good(`length ${len} <= maxpktsize ${ctx.maxpktsize}`);
    }
    if (ctx.routerEn === 0) warn("router_en = 0", "the router drops every packet and counts nothing");
    return out;
  }

  // ------------------------------------------------------------------ widgets
  function policyBadge(d) { return el("span", { class: `ys-badge ${d.policy === "RW" ? "RW" : d.policy === "RO" ? "RO" : "none"}`, text: d.policy === "none" ? "unmapped" : d.policy }); }

  function bitsView(r, model) {
    const v = model.regs.get(r.addr);
    const box = el("span", { class: "ys-bits" });
    for (let i = 7; i >= 0; i--) {
      const f = model.fieldsOf(r).find(x => i >= x.lo && i <= x.hi);
      box.append(el("span", { class: (v >> i) & 1 ? "one" : "", text: String((v >> i) & 1), title: f ? `[${i}] ${f.name}: ${f.desc || ""}` : `[${i}]` }));
    }
    return box;
  }

  function registerTable(model, compact) {
    const t = el("table", { class: "ys-t" });
    t.append(el("tr", {}, [el("th", { text: "addr" }), el("th", { text: "register" }), el("th", { text: "" }), el("th", { text: "value" }), compact ? "" : el("th", { text: "fields" })]));
    model.rm.registers.forEach(r => {
      const v = model.regs.get(r.addr);
      const tr = el("tr", { class: (model.changed.has(r.addr) ? "changed " : "") + (model.lastAddr === r.addr ? "hit" : "") });
      let dec = "";
      if (r.name === "ctrl_reg") dec = `maxpktsize = ${v & 0x3f}`;
      else if (r.name === "en_reg") dec = model.fieldsOf(r).filter(f => f.value && f.name !== "reserved").map(f => f.name).join(", ") || "all off";
      else dec = `${v} (dec)`;
      tr.append(el("td", { class: "mono", text: hex(r.addr, 4) }), el("td", { class: "mono", text: r.name, title: r.desc || "" }), el("td", {}, [policyBadge(r)]),
        el("td", { class: "mono" }, [hex(v), r.fields ? el("div", { style: "margin-top:2px" }, [bitsView(r, model)]) : ""]),
        compact ? "" : el("td", { text: dec, title: r.desc || "" }));
      t.append(tr);
    });
    return t;
  }

  function memoryView(model, mem, opts) {
    opts = opts || {};
    const wrap = el("div");
    const size = mem.size, base = mem.base;
    let start = opts.start || 0, rows = opts.rows || Math.ceil(size / 16);
    if (opts.window && model.lastAddr !== null && model.lastAddr >= base && model.lastAddr < base + size) start = Math.max(0, Math.min(size - rows * 16, (((model.lastAddr - base) >> 4) - 1) << 4));
    const head = el("div", { class: "ys-note" }, [`${mem.name}  ${hex(base, 4)} .. ${hex(base + size - 1, 4)}  (${size} x 8, ${mem.policy})  -- ${mem.desc || ""}`]);
    wrap.append(head);
    const grid = el("div", { class: "ys-mem" });
    const fresh = model.memNew[mem.name] || new Set();
    for (let r = 0; r < rows; r++) {
      const i0 = start + r * 16;
      if (i0 >= size) break;
      grid.append(el("div", { class: "a", text: hex(base + i0, 4) }));
      for (let i = i0; i < i0 + 16 && i < size; i++) {
        const cls = ["b"];
        if (mem.name === "yapp_pkt_mem" && i === 0) cls.push("hdr");
        if (fresh.has(i)) cls.push("new");
        if (model.lastAddr === base + i) cls.push("last");
        grid.append(el("div", { class: cls.join(" "), text: mem.data[i].toString(16).padStart(2, "0"), title: `${mem.name}[${i}] @ ${hex(base + i, 4)}` }));
      }
    }
    wrap.append(grid);
    return wrap;
  }

  function logView(model) {
    const box = el("div", { class: "ys-log" });
    if (!model.log.length) box.append(el("div", { class: "ys-note", text: "no transactions yet" }));
    model.log.slice(-40).forEach(l => box.append(el("div", { class: l.cls, text: l.text })));
    requestAnimationFrame(() => { box.scrollTop = box.scrollHeight; });
    return box;
  }

  // -- the register / HBUS widget
  function mountRegs(host, model) {
    host.innerHTML = "";
    const st = host.__ysRegs || (host.__ysRegs = { addr: model.rm.registers[0].addr, op: "write", data: 0x20, msg: null, pkt: { addr: 1, length: 4, bad: false }, memBase: 0 });
    const access = el("div", { class: "ys-card" });
    access.append(el("h4", { text: "HBUS access" }));
    const sel = el("select", { class: "wide", onchange: () => { st.addr = parseInt(sel.value, 10); hexIn.value = hex(st.addr, 4); refreshPolicy(); } });
    model.rm.registers.forEach(r => sel.append(el("option", { value: r.addr, text: `${hex(r.addr, 4)}  ${r.name}  (${r.policy})` })));
    model.mems.forEach(m => sel.append(el("option", { value: m.base, text: `${hex(m.base, 4)}  ${m.name}[0..${m.size - 1}]  (${m.policy})` })));
    sel.append(el("option", { value: 0x1002, text: "0x1002  (unmapped)" }));
    const hexIn = el("input", { type: "text", class: "w6", value: hex(st.addr, 4), oninput: () => { const v = parseNum(hexIn.value); if (!isNaN(v)) { st.addr = v & 0xffff; refreshPolicy(); } } });
    const badge = el("span");
    const dataIn = el("input", { type: "text", class: "w6", value: hex(st.data), oninput: () => { const v = parseNum(dataIn.value); if (!isNaN(v)) st.data = v & 0xff; } });
    const opBox = radio([["read", "Read"], ["write", "Write"]], st.op, v => { st.op = v; dataIn.disabled = v === "read"; });
    dataIn.disabled = st.op === "read";
    function refreshPolicy() {
      const d = model.describe(st.addr);
      badge.innerHTML = "";
      badge.append(policyBadge(d), " ", el("span", { class: "ys-note", style: "display:inline", text: d.name }));
      const opt = Array.from(sel.options).find(o => parseInt(o.value, 10) === st.addr);
      if (opt) sel.value = opt.value;
    }
    const exec = el("button", { type: "button", class: "primary", text: "Execute", onclick: () => {
      const r = st.op === "read" ? model.read(st.addr) : model.write(st.addr, st.data);
      st.msg = { cls: r.ok ? "ok" : "bad", text: r.text };
      if (st.op === "read") { st.data = r.value; }
      render();
    } });
    const rst = el("button", { type: "button", text: "Reset", title: "assert reset: registers back to their reset values", onclick: () => { st.msg = null; model.reset(false); } });
    access.append(el("div", { class: "ys-row" }, [field("address", sel), field("or type it", hexIn), el("div", { style: "padding-bottom:5px" }, [badge])]));
    access.append(el("div", { class: "ys-row" }, [field("operation", opBox), field("data (hex)", dataIn), exec, rst]));
    if (st.msg) access.append(el("div", { class: `ys-msg ${st.msg.cls}`, text: st.msg.text }));
    access.append(el("div", { class: "ys-note", html: "A write to a <b>RO</b> register or to an unmapped address is ignored by the router; a read of an unmapped address returns 0x00." }));
    refreshPolicy();
    host.append(access);

    const regs = el("div", { class: "ys-card" });
    regs.append(el("h4", { text: "Registers" }), registerTable(model, host.clientWidth > 0 && host.clientWidth < 520));
    host.append(regs);

    const mems = el("div", { class: "ys-card" });
    mems.append(el("h4", { text: "Memories" }));
    model.mems.forEach(m => mems.append(memoryView(model, m, m.size > 64 ? { rows: 2, window: true } : {})));
    host.append(mems);

    // a compact packet sender: the counters only move when packets arrive
    const pk = el("div", { class: "ys-card" });
    pk.append(el("h4", { text: "Send a packet" }));
    const pAddr = el("select", { onchange: () => { st.pkt.addr = +pAddr.value; } });
    [0, 1, 2, 3].forEach(a => pAddr.append(el("option", { value: a, text: a === 3 ? "3 (illegal)" : String(a), selected: a === st.pkt.addr })));
    const pLen = el("input", { type: "number", class: "w4", min: 1, max: 63, value: st.pkt.length, oninput: () => { st.pkt.length = Math.max(1, Math.min(63, +pLen.value || 1)); } });
    const pBad = el("input", { type: "checkbox", checked: st.pkt.bad, onchange: () => { st.pkt.bad = pBad.checked; } });
    const sendBtn = el("button", { type: "button", class: "primary", text: "Send", onclick: () => {
      const enc = encodePacket({ addr: st.pkt.addr, length: st.pkt.length, payload: randomBytes(st.pkt.length), corrupt: st.pkt.bad ? 0 : false });
      const rep = model.send(enc.bytes);
      st.msg = { cls: rep.dropped ? "bad" : "ok", text: model.log[model.log.length - 1].text + (rep.notes.length ? "\n" + rep.notes.join("\n") : "") };
      render();
    } });
    pk.append(el("div", { class: "ys-row" }, [field("addr", pAddr), field("length", pLen), el("label", { class: "ys-f" }, [el("span", { text: "parity" }), el("span", {}, [pBad, " BAD_PARITY"])]), sendBtn]));
    pk.append(el("div", { class: "ys-note", text: "Random payload; the header, the payload and the parity byte are stored in yapp_pkt_mem, the counters move according to en_reg, mem_size_reg takes the length. Oversized (> maxpktsize) and address-3 packets are counted and dropped." }));
    host.append(pk);

    const lg = el("div", { class: "ys-card" });
    lg.append(el("h4", { text: "Transaction log" }), logView(model));
    host.append(lg);

    function render() { mountRegs(host, model); }
    model.on(render, host);
  }

  // -- the packet playground
  function mountPacket(host, model) {
    host.innerHTML = "";
    const st = host.__ysPkt || (host.__ysPkt = { mode: "build", addr: 1, length: 4, payload: randomBytes(4), corrupt: false, bit: 0, raw: "", report: null, parityOverride: null });
    const tabs = el("div", { class: "ys-tabs" });
    [["build", "Build a packet"], ["parse", "Parse bytes"]].forEach(([m, l]) => tabs.append(el("button", { type: "button", class: st.mode === m ? "on" : "", onclick: () => { st.mode = m; st.report = null; render(); } }, [l])));
    host.append(tabs);
    const ctx = { maxpktsize: model.maxpktsize, routerEn: model.enBit(0) };
    let bytes = [];
    const card = el("div", { class: "ys-card" });
    if (st.mode === "build") {
      card.append(el("h4", { text: "Fields  (yapp_packet: addr, length, payload[], parity, parity_type)" }));
      const aSel = el("select", { onchange: () => { st.addr = +aSel.value; render(); } });
      [0, 1, 2, 3].forEach(a => aSel.append(el("option", { value: a, text: a === 3 ? "3 (illegal)" : String(a), selected: a === st.addr })));
      const lenIn = el("input", { type: "number", class: "w4", min: 0, max: 63, value: st.length, onchange: () => {
        st.length = Math.max(0, Math.min(63, +lenIn.value || 0));
        // keep payload.size() == length, like the constraint does
        if (st.payload.length < st.length) st.payload = st.payload.concat(randomBytes(st.length - st.payload.length));
        else st.payload = st.payload.slice(0, st.length);
        render();
      } });
      const payIn = el("textarea", { value: fmtBytes(st.payload), spellcheck: "false", oninput: () => { const b = parseBytes(payIn.value); if (b) { st.payload = b; live(); } } });
      const corrupt = el("input", { type: "checkbox", checked: st.corrupt, onchange: () => { st.corrupt = corrupt.checked; render(); } });
      const bitSel = el("select", { onchange: () => { st.bit = +bitSel.value; render(); } });
      for (let i = 0; i < 8; i++) bitSel.append(el("option", { value: i, text: "bit " + i, selected: i === st.bit }));
      bitSel.disabled = !st.corrupt;
      card.append(el("div", { class: "ys-row" }, [field("addr (2 bits)", aSel), field("length (6 bits)", lenIn),
        el("button", { type: "button", class: "small", text: "Random payload", onclick: () => { st.payload = randomBytes(st.length || 1); if (!st.length) st.length = st.payload.length; render(); } }),
        el("button", { type: "button", class: "small", text: "Counting payload", onclick: () => { st.payload = Array.from({ length: st.length || 1 }, (_, i) => i & 0xff); render(); } }),
        el("button", { type: "button", class: "small", text: "Clear", onclick: () => { st.payload = []; render(); } })]));
      card.append(field("payload bytes (hex)", payIn));
      card.append(el("div", { class: "ys-row", style: "margin-top:8px" }, [el("label", { class: "ys-f" }, [el("span", { text: "parity_type" }), el("span", {}, [corrupt, " BAD_PARITY: flip "])]), bitSel,
        el("span", { class: "ys-note", text: "set_parity(): GOOD = XOR of header + payload; BAD = GOOD with one bit flipped" })]));
      host.append(card);
    } else {
      card.append(el("h4", { text: "Raw bytes as the driver sends them (hex)" }));
      const rawIn = el("textarea", { value: st.raw, placeholder: "11 de ad be ef 33", spellcheck: "false", oninput: () => { st.raw = rawIn.value; live(); } });
      card.append(rawIn);
      card.append(el("div", { class: "ys-row" }, [
        el("button", { type: "button", class: "small", text: "Example: good packet", onclick: () => { st.raw = "11 de ad be ef 33"; render(); } }),
        el("button", { type: "button", class: "small", text: "Example: bad parity", onclick: () => { st.raw = "11 de ad be ef 32"; render(); } }),
        el("button", { type: "button", class: "small", text: "Example: address 3", onclick: () => { st.raw = "0f 01 02 03 0f"; render(); } }),
        el("button", { type: "button", class: "small", text: "Example: length mismatch", onclick: () => { st.raw = "11 de ad be"; render(); } })]));
      host.append(card);
    }
    const out = el("div", { class: "ys-card" });
    host.append(out);
    const sendCard = el("div", { class: "ys-card" });
    host.append(sendCard);

    function live() {
      out.innerHTML = "";
      if (st.mode === "build") {
        const enc = encodePacket({ addr: st.addr, length: st.length, payload: st.payload, corrupt: st.corrupt ? st.bit : false });
        bytes = enc.bytes;
        if (st.payload.length !== st.length) { bytes = [enc.header, ...st.payload, evenParity([enc.header, ...st.payload]) ^ (st.corrupt ? 1 << st.bit : 0)]; }
      } else {
        const b = parseBytes(st.raw);
        bytes = b || [];
        if (b === null) out.append(el("div", { class: "ys-msg bad", text: "cannot parse: hex bytes only (00 .. ff), separated by spaces" }));
      }
      out.append(el("h4", { text: "On the wire" }));
      const bv = el("div", { class: "ys-bytes" });
      const chk = checkPacket(bytes, ctx);
      bytes.forEach((b, i) => {
        const isHdr = i === 0, isPar = chk.len !== undefined && i === chk.len + 1;
        const lab = isHdr ? `header  len=${b >> 2} addr=${b & 3}` : isPar ? "parity" : i <= (chk.len || 0) ? `payload[${i - 1}]` : "extra";
        bv.append(el("div", { class: "byte" + (isHdr ? " hdr" : "") + (isPar ? " par" : "") + (isPar && b !== chk.expected ? " bad" : ""), title: `byte ${i}: ${bin8(b)}` }, [el("span", { text: b.toString(16).padStart(2, "0") }), el("small", { text: lab })]));
      });
      if (!bytes.length) bv.append(el("span", { class: "ys-note", text: "(empty)" }));
      out.append(bv);
      if (bytes.length) out.append(el("div", { class: "ys-kv" }, [el("b", { text: "header" }), el("span", { class: "mono", text: `${hex(chk.header)} = ${bin8(chk.header)}  ->  length[7:2] = ${chk.len}, addr[1:0] = ${chk.addr}` }),
        el("b", { text: "parity" }), el("span", { class: "mono", text: `${hex(chk.parity)}  (expected ${hex(chk.expected)} = ${[chk.header, ...(chk.payload || [])].map(x => x.toString(16).padStart(2, "0")).join(" ^ ")})` }),
        el("b", { text: "total" }), el("span", { text: `${bytes.length} bytes` })]));
      const ul = el("ul", { class: "ys-checks" });
      chk.checks.forEach(c => ul.append(el("li", { class: c.s }, [c.t, c.d ? el("div", { class: "ys-note", text: c.d }) : ""])));
      out.append(el("h4", { text: chk.ok ? "Checks: a valid packet" : "Checks" }), ul);
      out.append(el("div", { class: "ys-note", text: `Router state used by the checks: maxpktsize = ${ctx.maxpktsize}, router_en = ${ctx.routerEn}` }));
      renderSend();
    }
    function renderSend() {
      sendCard.innerHTML = "";
      sendCard.append(el("h4", { text: "Send it to the router" }));
      const btn = el("button", { type: "button", class: "primary", text: "Send to router", disabled: !bytes.length, onclick: () => { st.report = model.send(bytes); render(); } });
      const rst = el("button", { type: "button", text: "Reset router", onclick: () => { st.report = null; model.reset(false); } });
      sendCard.append(el("div", { class: "ys-row" }, [btn, rst, el("span", { class: "ys-note", text: "the same byte stream through yapp_input_fsm: FIFO push or drop, counters, yapp_pkt_mem, mem_size_reg, error" })]));
      const rep = st.report;
      if (rep) {
        const lines = [];
        if (!rep.done) lines.push(rep.notes.join("\n"));
        else {
          lines.push(rep.dropped ? `DROPPED: ${rep.reason}` : `forwarded to channel ${rep.forwarded} (data_${rep.forwarded} / data_vld_${rep.forwarded})`);
          lines.push(rep.parityErr ? `parity error: got ${hex(rep.parity)}, expected ${hex(rep.expected)} -> error pulses 1..10 cycles later` : "parity correct");
          lines.push(`yapp_pkt_mem: ${rep.memWritten} byte(s) written, mem_size_reg = ${rep.memSize}`);
          rep.notes.forEach(n => lines.push(n));
        }
        sendCard.append(el("div", { class: `ys-msg ${rep.dropped ? "bad" : rep.parityErr ? "warn" : "ok"}`, text: lines.filter(Boolean).join("\n") }));
        if (rep.counters.length) {
          const t = el("table", { class: "ys-t" });
          t.append(el("tr", {}, [el("th", { text: "counter" }), el("th", { text: "before" }), el("th", { text: "after" }), el("th", { text: "enable" })]));
          rep.counters.forEach(c => {
            const r = model.byName[c.name];
            const enName = c.key === "parity_err" ? "parity_err_cnt_en" : c.key === "oversized" ? "oversized_pkt_cnt_en" : c.key + "_cnt_en";
            const f = model.fieldsOf(model.byName.en_reg).find(x => x.name === enName);
            t.append(el("tr", { class: c.after !== c.before ? "changed" : "" }, [el("td", { class: "mono", text: `${hex(r.addr, 4)} ${c.name}` }), el("td", { class: "mono", text: hex(c.before) }), el("td", { class: "mono", text: hex(c.after) }), el("td", { text: `en_reg[${f ? f.lo : "?"}] = ${f ? f.value : "?"}` })]));
          });
          sendCard.append(t);
        }
      }
      const det = el("details", {}, [el("summary", { text: "router registers" }), registerTable(model, true)]);
      const pm = model.mems.find(m => m.name === "yapp_pkt_mem");
      if (pm) det.append(memoryView(model, pm, {}));
      sendCard.append(det);
    }
    function render() { mountPacket(host, model); }
    live();
    model.on(() => { ctx.maxpktsize = model.maxpktsize; ctx.routerEn = model.enBit(0); live(); }, host);
  }

  function mount(host, kind, model) {
    model = model || sharedModel();
    if (kind === "packet") mountPacket(host, model); else mountRegs(host, model);
    return model;
  }
  let shared = null;
  function sharedModel() { return shared || (shared = new RouterModel()); }
  function autoMount(root) {
    (root || document).querySelectorAll(".yapp-sim[data-sim]").forEach(h => { if (!h.__ysMounted) { h.__ysMounted = true; try { mount(h, h.dataset.sim); } catch (e) { h.textContent = "simulator unavailable: " + e.message; } } });
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", () => autoMount()); else autoMount();
  if (window.document$ && typeof window.document$.subscribe === "function") window.document$.subscribe(() => autoMount());   // MkDocs Material instant navigation

  window.YappSim = { RouterModel, encodePacket, checkPacket, parseBytes, evenParity, mount, mountRegs, mountPacket, sharedModel, autoMount, hex };
})();
