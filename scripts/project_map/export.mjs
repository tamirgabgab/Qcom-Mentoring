#!/usr/bin/env node
// export.mjs -- render every view of the project map to SVG (+ PNG for the main
// views, + one PDF per view family) with headless Chromium through Playwright.
//
//   node scripts/project_map/export.mjs            # SVG + PNG -> docs/assets/project_map/export/, PDF -> build/
//   node scripts/project_map/export.mjs --dark     # also a dark-theme set
//
// Playwright is found through `npm root -g` or the PLAYWRIGHT_MODULE environment variable.
import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";
import { fileURLToPath, pathToFileURL } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, "..", "..");
const standalone = path.join(root, "docs", "downloads", "yapp_project_map.html");
const outDir = path.join(root, "docs", "assets", "project_map", "export");
const pdfDir = path.join(root, "build");
const dark = process.argv.includes("--dark");

async function loadPlaywright() {
  const candidates = [process.env.PLAYWRIGHT_MODULE, "/opt/node-tools/node_modules/playwright/index.mjs"];
  try { candidates.push(path.join(execSync("npm root -g", { encoding: "utf8" }).trim(), "playwright", "index.mjs")); } catch (e) { /* no npm */ }
  for (const c of candidates.filter(Boolean)) {
    if (fs.existsSync(c)) return import(pathToFileURL(c).href);
  }
  try { return await import("playwright"); } catch (e) { throw new Error("playwright not found: npm i -g playwright && npx playwright install chromium"); }
}

// which scenes get a PNG as well (the ones a slide deck needs; every scene gets an SVG)
const PNG = new Set(["h:root", "h:tb", "h:tb.yapp.agent", "h:tb.router_module", "h:hw_top.dut", "tlm:main",
  "uml:yapp_pkg", "uml:yapp_pkg:full", "env:main", "tests:main"]);

const { chromium } = await loadPlaywright();
fs.mkdirSync(outDir, { recursive: true });
fs.mkdirSync(pdfDir, { recursive: true });
const browser = await chromium.launch();
const themes = dark ? ["light", "dark"] : ["light"];
let count = 0;
for (const theme of themes) {
  const ctx = await browser.newContext({ viewport: { width: 1600, height: 1000 }, deviceScaleFactor: 2 });
  const page = await ctx.newPage();
  await page.goto(pathToFileURL(standalone).href + `#theme=${theme}`, { waitUntil: "load" });
  await page.waitForFunction(() => window.projectMap && window.projectMap.sceneIds);
  const ids = await page.evaluate(() => window.projectMap.sceneIds());
  const svgs = {};
  for (const id of ids) {
    const svg = await page.evaluate(sid => { window.projectMap.show(sid); return window.projectMap.exportSvgString(); }, id);
    svgs[id] = svg;
    const base = id.replace(/[^\w.-]+/g, "_") + (theme === "dark" ? "_dark" : "");
    fs.writeFileSync(path.join(outDir, base + ".svg"), svg);
    count++;
    if (PNG.has(id)) {
      const p2 = await ctx.newPage();
      await p2.setContent(`<!doctype html><html><body style="margin:0;background:${theme === "dark" ? "#262a33" : "#fff"}">${svg}</body></html>`);
      const el = await p2.locator("svg").first();
      await el.screenshot({ path: path.join(outDir, base + ".png"), type: "png" });
      await p2.close();
      count++;
    }
  }
  // one PDF per view family (landscape pages, one scene per page)
  const families = { hierarchy: ids.filter(i => i.startsWith("h:")), tlm: ids.filter(i => i.startsWith("tlm:")), classes: ids.filter(i => i.startsWith("uml:") && !i.endsWith(":full")) };
  for (const [fam, list] of Object.entries(families)) {
    const html = `<!doctype html><html><head><style>
      @page { size: A4 landscape; margin: 10mm; }
      body { margin: 0; font-family: sans-serif; }
      section { page-break-after: always; display: flex; flex-direction: column; height: 190mm; }
      h1 { font-size: 12pt; margin: 0 0 4mm; color: #444; }
      svg { max-width: 100%; max-height: 175mm; height: auto; width: auto; }
      </style></head><body>` +
      list.map(id => `<section><h1>${id}</h1>${svgs[id].replace(/^<\?xml[^>]*>\s*/, "")}</section>`).join("") + "</body></html>";
    const p3 = await ctx.newPage();
    await p3.setContent(html);
    await p3.pdf({ path: path.join(pdfDir, `project_map_${fam}${theme === "dark" ? "_dark" : ""}.pdf`), format: "A4", landscape: true, printBackground: true });
    await p3.close();
    count++;
  }
  await ctx.close();
}
await browser.close();
console.log(`exported ${count} files -> ${path.relative(root, outDir)}/ and ${path.relative(root, pdfDir)}/`);
