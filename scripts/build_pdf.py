#!/usr/bin/env python3
"""The course site as one printable PDF: offline/QcomCourse.pdf (make docs-pdf).

Builds the site with mkdocs-print.yml (the offline configuration plus the print-site plugin,
which joins every page into one), opens the joined page in Chromium through Playwright and
prints it to PDF. Needs mkdocs-material, mkdocs-print-site-plugin, node and Playwright
(PLAYWRIGHT_BROWSERS_PATH as for the README screenshots). The project map page is left out
(it is interactive); the Mermaid diagrams are rendered by the vendored Mermaid of the offline
build before printing.
"""

import os
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SITE = os.path.join(ROOT, "build", "print_site")
PDF = os.path.join(ROOT, "offline", "QcomCourse.pdf")
NODE = shutil.which("node") or "/opt/node22/bin/node"
PRINT_JS = r"""
const path = require("path");
const { pathToFileURL } = require("url");
const pw = require(process.env.PW_MODULE || "playwright");
(async () => {
  const [site, pdf] = process.argv.slice(2);
  const browser = await pw.chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1100, height: 1400 } });
  const url = pathToFileURL(path.join(site, "print_page.html")).href;
  await page.goto(url, { waitUntil: "load" });
  // the diagrams are drawn by the script patch_print_page() added (the vendored Mermaid)
  const drawn = await page.waitForFunction(() => window.__mermaidDone === true, null, { timeout: 120000 })
    .then(() => true).catch(() => false);
  const n = await page.evaluate(() => [document.querySelectorAll(".mermaid-out svg").length,
    document.querySelectorAll("pre.mermaid-src").length]);
  console.log(`mermaid diagrams: ${n[0]} rendered, ${n[1]} failed${drawn ? "" : " (timeout)"}`);
  await page.waitForTimeout(1500);
  await page.emulateMedia({ media: "print" });
  await page.pdf({ path: pdf, format: "A4", printBackground: true,
                   margin: { top: "16mm", bottom: "16mm", left: "14mm", right: "14mm" },
                   displayHeaderFooter: true,
                   headerTemplate: "<div></div>",
                   footerTemplate: '<div style="font-size:8px;width:100%;text-align:center;color:#888">YAPP Router — SystemVerilog &amp; UVM course · <span class="pageNumber"></span> / <span class="totalPages"></span></div>' });
  await browser.close();
})().catch(e => { console.error(e); process.exit(1); });
"""


RENDER_JS = """
<script src="assets/vendor/mermaid.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", async () => {
  mermaid.initialize({ startOnLoad: false, theme: "default", securityLevel: "loose" });
  let i = 0;
  for (const pre of document.querySelectorAll("pre.mermaid-src")) {
    const code = (pre.querySelector("code") || pre).textContent;
    try {
      const { svg } = await mermaid.render("mmd" + (i++), code);
      const div = document.createElement("div");
      div.className = "mermaid-out";
      div.innerHTML = svg;
      pre.replaceWith(div);
    } catch (e) { pre.setAttribute("data-mermaid-error", String(e)); }
  }
  window.__mermaidDone = true;
});
</script>
<style>.mermaid-out { text-align: center; margin: 1em 0; page-break-inside: avoid; } .mermaid-out svg { max-width: 100%; height: auto; }</style>
"""


def patch_print_page(path):
    """Material's own Mermaid integration fetches the library from a CDN and renders into shadow
    DOM, which the print page does not get; rename the diagram blocks so that it leaves them
    alone and render them with the vendored Mermaid before printing."""
    with open(path, encoding="utf-8") as fh:
        html = fh.read()
    html = html.replace('<pre class="mermaid">', '<pre class="mermaid-src">')
    html = html.replace("</body>", RENDER_JS + "</body>", 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(html)


def main():
    if os.path.isdir(SITE):
        shutil.rmtree(SITE)
    subprocess.run([sys.executable, "scripts/build_offline_site.py", "--vendor-only"], cwd=ROOT, check=True)
    subprocess.run([sys.executable, "-m", "mkdocs", "build", "-f", "mkdocs-print.yml", "-d", SITE], cwd=ROOT, check=True)
    patch_print_page(os.path.join(SITE, "print_page.html"))
    js = os.path.join(SITE, "print.js")
    with open(js, "w") as fh:
        fh.write(PRINT_JS)
    env = dict(os.environ)
    env.setdefault("PW_MODULE", "/opt/node-tools/node_modules/playwright" if os.path.isdir("/opt/node-tools/node_modules/playwright") else "playwright")
    os.makedirs(os.path.dirname(PDF), exist_ok=True)
    subprocess.run([NODE, js, SITE, PDF], cwd=ROOT, check=True, env=env)
    print(f"wrote {os.path.relpath(PDF, ROOT)} ({os.path.getsize(PDF) // 1024} KB)")


if __name__ == "__main__":
    main()
