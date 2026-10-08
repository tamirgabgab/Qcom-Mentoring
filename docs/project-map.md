---
hide:
  - toc
---

# Project map

One picture of the whole project that you can look into: **click** a box for its role, its file
and its lab, **double-click** (or the `▸ open` corner) to open it. Three views: Hierarchy,
TLM / data flow, Classes (UML). The **Source** column on the right shows the complete file of
whatever is selected (one class per file). Press ++question++ inside the map for the shortcuts.

<style>.md-grid { max-width: none; }</style>

[Open full screen](downloads/yapp_project_map.html){ .md-button .md-button--primary }
[Download the offline copy](downloads/yapp_project_map.html){ .md-button download="yapp_project_map.html" }
[Exported pictures](https://github.com/tamirgabgab/Qcom-Mentoring/tree/main/docs/assets/project_map/export){ .md-button }

<div class="pm-embed" markdown>
<iframe id="pm-iframe" src="../downloads/yapp_project_map.html" title="YAPP router project map" loading="eager" allow="clipboard-write"></iframe>
</div>

<script>
(function () {
  var frame = document.getElementById("pm-iframe");
  if (!frame) return;
  var base = frame.getAttribute("src").split("#")[0];
  function theme() { return (document.body.getAttribute("data-md-color-scheme") === "slate") ? "dark" : "light"; }
  function hashWithTheme(h) {
    var p = new URLSearchParams((h || "").replace(/^#/, ""));
    p.set("theme", theme());
    return "#" + p.toString().replace(/%3A/g, ":").replace(/%5B/g, "[").replace(/%5D/g, "]");
  }
  // deep link from the page URL into the map
  frame.setAttribute("src", base + hashWithTheme(location.hash));
  window.addEventListener("hashchange", function () {
    if (frame.contentWindow) frame.contentWindow.postMessage({ pmHash: hashWithTheme(location.hash) }, "*");
  });
  // the map reports its state back so the page URL stays shareable
  window.addEventListener("message", function (ev) {
    if (ev.source === frame.contentWindow && ev.data && ev.data.pmHash) {
      var h = ev.data.pmHash.replace(/[&?]theme=\w+/, "");
      if (location.hash !== h) history.replaceState(null, "", h);
    }
  });
  // follow the site's light / dark toggle
  new MutationObserver(function () {
    if (frame.contentWindow) frame.contentWindow.postMessage({ pmTheme: theme() }, "*");
  }).observe(document.body, { attributes: true, attributeFilter: ["data-md-color-scheme"] });
})();
</script>

## How to read it

* **Hierarchy** — who contains whom (test → testbench → UVC → agent → driver / monitor /
  sequencer, DUT → FSM / FIFOs / registers), with the TLM ports on each component and the
  virtual interfaces down to the hardware. Dashed boxes outside a frame are the far ends of
  connections leaving that level; click one to jump there.
* **TLM / data flow** — sequencers → drivers → DUT → monitors → reference model → scoreboard;
  click a port or an arrow to light up the complete path. The DUT is drawn compact here, one pin
  per interface (stimulus enters on the left, observation leaves on the right); the 19 signals
  are in the Hierarchy view. The **Lab 9D** button swaps in the FIFO-based scoreboard.
* **Classes (UML)** — inheritance per package; **Members** shows fields (with `rand`), methods
  and constraints. Dashed arrows: *runs on*, *uses*, *starts* (default sequence), *overrides*.

**Arrows, moving boxes, column widths.** Arrows are orthogonal (horizontal and vertical runs,
rounded corners) and routed in the browser from the boxes' positions. In the Hierarchy and TLM
views the **Arrows** button (or ++a++) starts *off*: only the arrows of the box under the pointer
(and of the selected one) are shown, which keeps a crowded view readable; switch it on to see
them all. An arrow between two neighbours runs straight: a port sits on the side of its box
that faces the box it talks to, and the far ends of connections leaving a level (the dashed
boxes) sit next to the box they talk to. An arrow that would cut through a box takes a detour
above or below it. Any box can be **dragged** to a better place, the arrows follow; the layout is
remembered in this browser per view, **Reset layout** puts everything back. The edges of the
side panel and of the Source column can be dragged to resize them (double-click for the default
width).

**Getting around.** ⌂ (or ++h++) is home: the overview, nothing selected. ◀ and ▶ (or
++alt+left++ / ++alt+right++) walk back and forward through the views visited, like a browser;
**↑ Up** (++esc++) goes one level out.

The side panel has three tabs: **Overview** (role, base chain, fields, connections, the lab that
introduces the item), **Code** (the source, with a link to GitHub) and **Links** (component
guide, lab page, the same item in the other views, a shareable link). The **Source** column
(toolbar button or ++c++) is a third column with the whole file of the selected class, module or
RTL block, the item's lines marked; it can be downloaded or opened on GitHub from there.

**Simulate.** The DUT is drawn as in the course figure, pins inside and the register map in a
block; click that block (or the **Simulate** tab on the DUT, `u_regs`, `hbus0`, the register
model or a packet class) for two small interactive models: HBUS reads and writes against the
register file with its RW / RO policy (the value to write is shown as a bit-field diagram, MSB on
the left, LSB on the right, one line per field underneath with its bits, name, value and meaning
from the register map -- click a bit to flip it), and a packet playground that builds or decodes a YAPP
packet, computes the parity, lists the checks and sends the bytes through the router model so
the counters and `yapp_pkt_mem` move. The same widgets are on the
[DUT specification](dut/spec.md#try-it-the-register-file) and
[packet](components/packet.md#try-it-build-or-check-a-packet) pages.

The map is generated from the SystemVerilog by `scripts/project_map/` — pyslang reads the
classes, ports, `connect()` calls and the module tree; `annotations.yaml` adds the prose — so it
never drifts from the code (`make map` regenerates it, CI checks it is current).

!!! tip "Offline use in class"
    The offline copy is one self-contained HTML file (no network needed). Save it, double-click
    it, press ++f++ to fit the view and ++question++ for the shortcuts. The **Export** menu
    produces SVG / PNG of the current view for slides; `make map-export` renders every view at once.
