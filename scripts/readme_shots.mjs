#!/usr/bin/env node
// readme_shots.mjs -- the screenshots of README.md, taken with headless Chromium (Playwright):
//
//   make readme-shots          (builds the site first; needs playwright, see export.mjs)
//
// Output: docs/assets/readme/*.png
//   map_overview.png      the whole testbench (hierarchy view, panel + source column)
//   map_dut.png           the hardware side: the DUT block diagram with pins and register map
//   sim_registers.png     the register simulator on the DUT specification page
//   sim_packet.png        the packet playground on the packet page, after "Send to router"
//   map_testplan.png      the Test plan view: feature cards with status chips, a feature open in the panel
import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";
import { fileURLToPath, pathToFileURL } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, "..");
const out = path.join(root, "docs", "assets", "readme");
const standalone = pathToFileURL(path.join(root, "docs", "downloads", "yapp_project_map.html")).href;
const site = p => pathToFileURL(path.join(root, "site", p, "index.html")).href;

async function loadPlaywright() {
  const candidates = [process.env.PLAYWRIGHT_MODULE, "/opt/node-tools/node_modules/playwright/index.mjs"];
  try { candidates.push(path.join(execSync("npm root -g", { encoding: "utf8" }).trim(), "playwright", "index.mjs")); } catch (e) { /* no npm */ }
  for (const c of candidates.filter(Boolean)) if (fs.existsSync(c)) return import(pathToFileURL(c).href);
  return import("playwright");
}

const { chromium } = await loadPlaywright();
fs.mkdirSync(out, { recursive: true });
const browser = await chromium.launch();
const ctx = await browser.newContext({ viewport: { width: 1600, height: 1000 }, deviceScaleFactor: 1.5, colorScheme: "light" });
const page = await ctx.newPage();
const shot = (name, opts) => page.screenshot({ path: path.join(out, name), ...opts });

// ---- the interactive map
await page.goto(standalone + "#theme=light", { waitUntil: "load" });
await page.waitForFunction(() => window.projectMap && window.projectMap.sceneIds);
await page.evaluate(() => { const m = window.projectMap; m.show("h:root"); m.select("tb"); m.fit(); });
await page.waitForTimeout(400);
await shot("map_overview.png");

// the Test plan view with one feature group open in the panel (source column hidden)
await page.evaluate(() => { const m = window.projectMap; m.toggleCode(false); m.switchView("plan"); m.select("plan:PKT"); m.fit(); });
await page.waitForTimeout(400);
await shot("map_testplan.png");
await page.evaluate(() => { window.projectMap.toggleCode(true); });

// zoom on hw_top: hide the side panels, fit the hardware frame to the canvas
await page.evaluate(() => {
  const m = window.projectMap;
  m.show("h:root");
  document.querySelector(".pm").classList.add("panel-hidden"); m.toggleCode(false);
  document.querySelectorAll(".pm-legend, .pm-statusbar").forEach(e => { e.style.display = "none"; });
});
await page.waitForTimeout(400);                       // the columns settle (afterResize re-fits once more)
await page.evaluate(() => {
  const m = window.projectMap;
  const s = m.scenes["h:root"];
  const hw = s.items.find(i => i.id === "hw_top");
  const r = m.canvas.getBoundingClientRect();
  const k = Math.min((r.width - 40) / hw.w, (r.height - 40) / hw.h);
  m.vp.k = k; m.vp.x = (r.width - hw.w * k) / 2 - hw.x * k; m.vp.y = (r.height - hw.h * k) / 2 - hw.y * k;
  m.applyVp();
});
await page.waitForTimeout(300);
const canvas = await page.locator(".pm-canvas").boundingBox();
await shot("map_dut.png", { clip: canvas });

// ---- the simulators on the site pages (external CDN assets do not load from file://, the widgets do)
await page.setViewportSize({ width: 1200, height: 1400 });
await page.goto(site("dut/spec"), { waitUntil: "load" });
await page.waitForSelector(".yapp-sim .ys-card");
await page.evaluate(() => {
  // a write to a read-only register, so the picture shows the policy at work
  const host = document.querySelector(".yapp-sim");
  const sel = host.querySelector("select.wide");
  sel.value = String(0x1004); sel.dispatchEvent(new Event("change"));
  const data = host.querySelectorAll("input.w6")[1];
  data.value = "0x05"; data.dispatchEvent(new Event("input"));
  host.querySelector("button.primary").click();
});
await page.waitForTimeout(200);
await page.locator(".yapp-sim").first().screenshot({ path: path.join(out, "sim_registers.png") });

await page.goto(site("components/packet"), { waitUntil: "load" });
await page.waitForSelector(".yapp-sim .ys-card");
await page.evaluate(() => {
  const host = document.querySelector(".yapp-sim");
  host.querySelector("button.primary").click();           // Send to router
});
await page.waitForTimeout(200);
await page.locator(".yapp-sim").first().screenshot({ path: path.join(out, "sim_packet.png") });

await browser.close();
console.log("wrote 5 screenshots ->", path.relative(root, out));
