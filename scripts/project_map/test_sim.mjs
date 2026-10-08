// test_sim.mjs -- behavioural checks of the browser simulator (docs/assets/project_map/sim.js).
//
// RouterModel mirrors the RTL by hand (yapp_hbus_regs.sv + yapp_input_fsm.sv), so nothing
// else catches a drift between the two.  This script loads regmap.js + sim.js the way a
// page would (a stub `window` / `document`, no DOM library) and replays the scenarios the
// teaching pages rely on: reset values, RW / RO / unmapped policy, a good packet, bad
// parity, the three drop rules, the counter enables, warm reset, the packet helpers.
//
//   node scripts/project_map/test_sim.mjs        exit 0 = OK, 1 = a check failed
//
// Run by `python3 -m scripts.project_map.build --check` (make map-check, CI) when node is
// on the PATH.  No dependencies beyond node itself.
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import vm from "node:vm";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const ASSETS = join(ROOT, "docs", "assets", "project_map");

// ------------------------------------------------------------------ load sim.js like a page would
function loadSim() {
  const noop = () => {};
  const document = {
    readyState: "complete",
    addEventListener: noop,
    querySelectorAll: () => [],
    createElement: () => { throw new Error("the model must not touch the DOM"); },
  };
  const window = { document };
  const sandbox = { window, document, console, Error, Map, Set, Uint8Array, Array, Object, String, Math, parseInt, JSON };
  window.window = window;
  vm.createContext(sandbox);
  for (const file of ["regmap.js", "sim.js"]) {
    vm.runInContext(readFileSync(join(ASSETS, file), "utf-8"), sandbox, { filename: file });
  }
  if (!window.YappSim) throw new Error("sim.js did not publish window.YappSim");
  if (!window.YAPP_REGMAP) throw new Error("regmap.js did not publish window.YAPP_REGMAP");
  return { sim: window.YappSim, regmap: window.YAPP_REGMAP };
}

// ------------------------------------------------------------------ tiny harness
const failures = [];
let checks = 0;
function expect(cond, msg) {
  checks++;
  if (!cond) failures.push(msg);
}
function eq(actual, expected, msg) {
  expect(actual === expected, `${msg}: got ${fmt(actual)}, expected ${fmt(expected)}`);
}
function fmt(v) {
  if (typeof v === "number") return v >= 0 && Number.isInteger(v) ? "0x" + v.toString(16) : String(v);
  return JSON.stringify(v);
}

const { sim, regmap } = loadSim();
const { RouterModel, encodePacket, checkPacket, parseBytes, evenParity } = sim;
const R = {};
regmap.registers.forEach(r => { R[r.name] = r.addr; });
const PKT_MEM = regmap.memories.find(m => m.name === "yapp_pkt_mem");
const YAPP_MEM = regmap.memories.find(m => m.name === "yapp_mem");

// A legal packet: header (len << 2 | addr), payload, even parity.  The worked example of the
// teaching pages -- its parity really is 0x33.
const GOOD = [0x11, 0xde, 0xad, 0xbe, 0xef, 0x33];

// ------------------------------------------------------------------ 1. reset values
{
  const m = new RouterModel(regmap);
  regmap.registers.forEach(r => eq(m.peek(r.addr), r.reset, `reset value of ${r.name}`));
  eq(m.maxpktsize, 0x3f, "maxpktsize after reset");
  eq(m.enBit(0), 1, "router_en after reset");
  for (let i = 0; i < PKT_MEM.size; i++) expect(m.peek(PKT_MEM.base + i) === 0, "yapp_pkt_mem cleared at power-up");
  for (let i = 0; i < YAPP_MEM.size; i++) expect(m.peek(YAPP_MEM.base + i) === 0, "yapp_mem cleared at power-up");
}

// ------------------------------------------------------------------ 2. register policy: RW, RO, memories, unmapped
{
  const m = new RouterModel(regmap);
  let w = m.write(R.ctrl_reg, 0x0a);
  expect(w.ok, "write to ctrl_reg (RW) accepted");
  eq(m.read(R.ctrl_reg).value, 0x0a, "ctrl_reg reads back the written value");
  eq(m.maxpktsize, 0x0a, "maxpktsize decoded from ctrl_reg[5:0]");
  w = m.write(R.ctrl_reg, 0xff);
  eq(m.maxpktsize, 0x3f, "maxpktsize is the low 6 bits only");
  w = m.write(R.parity_err_cnt_reg, 0x55);
  expect(!w.ok && /read-only/.test(w.why), "write to a RO counter is rejected");
  eq(m.peek(R.parity_err_cnt_reg), 0x00, "RO counter unchanged by the write");
  w = m.write(PKT_MEM.base + 3, 0x42);
  expect(!w.ok, "write to yapp_pkt_mem (RO) is rejected");
  eq(m.peek(PKT_MEM.base + 3), 0x00, "yapp_pkt_mem unchanged by the write");
  w = m.write(YAPP_MEM.base + 0x2a, 0x5a);
  expect(w.ok, "write to yapp_mem (RW) accepted");
  eq(m.read(YAPP_MEM.base + 0x2a).value, 0x5a, "yapp_mem reads back the written value");
  // the unmapped hole between en_reg and the counters, and above yapp_mem
  for (const a of [0x1002, 0x1003, 0x1007, 0x1008, 0x100c, 0x100e, 0x100f, 0x1050, 0x10ff, 0x1200, 0x0000]) {
    const d = m.describe(a);
    eq(d.kind, "unmapped", `address ${fmt(a)} is unmapped`);
    w = m.write(a, 0xa5);
    expect(!w.ok && /unmapped/.test(w.why), `write to unmapped ${fmt(a)} is ignored`);
    eq(m.read(a).value, 0x00, `unmapped ${fmt(a)} reads as 0x00`);
  }
  eq(m.describe(PKT_MEM.base + PKT_MEM.size - 1).kind, "mem", "last byte of yapp_pkt_mem is mapped");
  eq(m.describe(YAPP_MEM.base + YAPP_MEM.size - 1).kind, "mem", "last byte of yapp_mem is mapped");
}

// ------------------------------------------------------------------ 3. a good packet
{
  const m = new RouterModel(regmap);
  m.write(R.en_reg, 0xff);                        // every counter enabled
  const rep = m.send(GOOD);
  expect(rep.done && !rep.dropped, "good packet completes and is not dropped");
  eq(rep.addr, 1, "address decoded from the header");
  eq(rep.len, 4, "length decoded from the header");
  eq(rep.forwarded, 1, "forwarded to channel 1");
  expect(!rep.parityErr && !rep.error, "no parity error, no error pulse");
  eq(m.peek(R.addr1_cnt_reg), 1, "addr1_cnt_reg incremented");
  eq(m.peek(R.addr0_cnt_reg), 0, "addr0_cnt_reg untouched");
  eq(m.peek(R.parity_err_cnt_reg), 0, "parity_err_cnt_reg untouched");
  eq(m.peek(R.oversized_pkt_cnt_reg), 0, "oversized_pkt_cnt_reg untouched");
  eq(m.peek(R.mem_size_reg), 4, "mem_size_reg = payload length");
  eq(m.peek(PKT_MEM.base + 0), 0x11, "yapp_pkt_mem[0] = header");
  eq(m.peek(PKT_MEM.base + 1), 0xde, "yapp_pkt_mem[1] = first payload byte");
  eq(m.peek(PKT_MEM.base + 4), 0xef, "yapp_pkt_mem[4] = last payload byte");
  eq(m.peek(PKT_MEM.base + 5), 0x00, "the parity byte is not stored");
  eq(rep.memWritten, 5, "header + 4 payload bytes written to the packet memory");
  // a second packet to another address
  const p2 = encodePacket({ addr: 2, length: 3, payload: [1, 2, 3] });
  m.send(p2.bytes);
  eq(m.peek(R.addr2_cnt_reg), 1, "addr2_cnt_reg incremented by the second packet");
  eq(m.peek(R.addr1_cnt_reg), 1, "addr1_cnt_reg keeps its count");
  eq(m.peek(R.mem_size_reg), 3, "mem_size_reg follows the last packet");
  eq(m.peek(PKT_MEM.base + 0), p2.header, "yapp_pkt_mem[0] overwritten by the new header");
  eq(m.peek(PKT_MEM.base + 4), 0xef, "bytes beyond the new payload keep the old contents");
}

// ------------------------------------------------------------------ 4. bad parity: counted, error pulse, still forwarded
{
  const m = new RouterModel(regmap);
  m.write(R.en_reg, 0xff);
  const bad = GOOD.slice(); bad[bad.length - 1] ^= 0x08;
  const rep = m.send(bad);
  expect(rep.parityErr, "parity error detected");
  eq(rep.expected, 0x33, "expected parity reported");
  expect(rep.error, "error pulse follows a bad-parity packet");
  expect(!rep.dropped && rep.forwarded === 1, "bad-parity packet is still forwarded (spec decision)");
  eq(m.peek(R.parity_err_cnt_reg), 1, "parity_err_cnt_reg incremented");
  eq(m.peek(R.addr1_cnt_reg), 1, "addr1_cnt_reg incremented as well");
}

// ------------------------------------------------------------------ 5. illegal address 3: dropped, counted, parity still checked
{
  const m = new RouterModel(regmap);
  m.write(R.en_reg, 0xff);
  const p = encodePacket({ addr: 3, length: 2, payload: [0xaa, 0x55] });
  const rep = m.send(p.bytes);
  expect(rep.dropped && rep.forwarded === null, "address 3 is dropped");
  expect(/illegal address 3/.test(rep.reason), "drop reason names address 3");
  eq(m.peek(R.addr3_cnt_reg), 1, "addr3_cnt_reg incremented");
  eq(m.peek(R.mem_size_reg), 2, "mem_size_reg updated for a dropped packet");
  eq(m.peek(PKT_MEM.base + 0), p.header, "dropped packet is still stored in yapp_pkt_mem");
  expect(!rep.error, "no error pulse without a parity error");
  const badp = p.bytes.slice(); badp[badp.length - 1] ^= 1;
  const rep2 = m.send(badp);
  expect(rep2.dropped && rep2.parityErr && rep2.error, "address 3 with bad parity: dropped, parity checked, error pulses");
  eq(m.peek(R.parity_err_cnt_reg), 1, "parity_err_cnt_reg counts the dropped packet too");
  eq(m.peek(R.addr3_cnt_reg), 2, "addr3_cnt_reg counts both");
}

// ------------------------------------------------------------------ 6. oversized: maxpktsize from ctrl_reg
{
  const m = new RouterModel(regmap);
  m.write(R.en_reg, 0xff);
  m.write(R.ctrl_reg, 3);
  const ok = encodePacket({ addr: 0, length: 3, payload: [1, 2, 3] });
  let rep = m.send(ok.bytes);
  expect(!rep.dropped, "length == maxpktsize is accepted");
  eq(m.peek(R.oversized_pkt_cnt_reg), 0, "not counted as oversized");
  const big = encodePacket({ addr: 0, length: 4, payload: [1, 2, 3, 4] });
  rep = m.send(big.bytes);
  expect(rep.dropped && rep.forwarded === null, "length > maxpktsize is dropped");
  expect(/maxpktsize 3/.test(rep.reason), "drop reason names maxpktsize");
  eq(m.peek(R.oversized_pkt_cnt_reg), 1, "oversized_pkt_cnt_reg incremented");
  eq(m.peek(R.addr0_cnt_reg), 2, "addr0_cnt_reg counts accepted and dropped packets");
  eq(m.peek(R.mem_size_reg), 4, "mem_size_reg = length of the oversized packet");
  eq(m.peek(PKT_MEM.base + 4), 4, "the whole oversized payload is stored");
}

// ------------------------------------------------------------------ 7. router disabled: nothing stored, counted or reported
{
  const m = new RouterModel(regmap);
  m.write(R.en_reg, 0xfe);                        // counters on, router_en off
  const rep = m.send(GOOD);
  expect(rep.dropped && !rep.done, "router_en = 0 drops the packet without pkt_done");
  expect(/router disabled/.test(rep.reason), "drop reason names router_en");
  regmap.registers.filter(r => r.policy === "RO").forEach(r => eq(m.peek(r.addr), 0, `${r.name} untouched while disabled`));
  for (let i = 0; i < PKT_MEM.size; i++) expect(m.peek(PKT_MEM.base + i) === 0, "yapp_pkt_mem untouched while disabled");
  expect(!rep.error, "no error pulse while disabled");
  // the counters are gated by their own enable bits
  m.write(R.en_reg, 0x01);                        // router on, every counter off
  m.send(GOOD);
  const bad = GOOD.slice(); bad[bad.length - 1] ^= 1;
  m.send(bad);
  eq(m.peek(R.addr1_cnt_reg), 0, "addr1_cnt_reg gated by en_reg[5]");
  eq(m.peek(R.parity_err_cnt_reg), 0, "parity_err_cnt_reg gated by en_reg[1]");
  eq(m.peek(R.mem_size_reg), 4, "mem_size_reg is not gated");
  m.write(R.en_reg, 0x21);                        // router + addr1 counter
  m.send(GOOD);
  eq(m.peek(R.addr1_cnt_reg), 1, "addr1_cnt_reg counts once enabled");
}

// ------------------------------------------------------------------ 8. incomplete packet, extra bytes, counter wrap
{
  const m = new RouterModel(regmap);
  m.write(R.en_reg, 0xff);
  let rep = m.send(GOOD.slice(0, 3));
  expect(!rep.done && !rep.dropped, "a partial packet is neither done nor dropped");
  eq(m.peek(R.addr1_cnt_reg), 0, "nothing counted for a partial packet");
  eq(m.peek(PKT_MEM.base + 0), 0x11, "the header is stored as soon as it arrives");
  eq(m.peek(PKT_MEM.base + 2), 0xad, "payload bytes are stored as they arrive");
  rep = m.send([...GOOD, 0x99]);
  expect(rep.done && rep.consumed === GOOD.length, "extra bytes after the parity byte are not part of the packet");
  expect(rep.notes.some(n => /extra byte/.test(n)), "the extra byte is reported");
  m.poke(R.addr1_cnt_reg, 0xff);
  m.send(GOOD);
  eq(m.peek(R.addr1_cnt_reg), 0x00, "an 8-bit counter wraps");
}

// ------------------------------------------------------------------ 9. warm reset: registers back, memories kept
{
  const m = new RouterModel(regmap);
  m.write(R.en_reg, 0xff);
  m.write(R.ctrl_reg, 0x07);
  m.write(YAPP_MEM.base + 1, 0x77);
  m.send(GOOD);
  m.reset(false);
  regmap.registers.forEach(r => eq(m.peek(r.addr), r.reset, `${r.name} back at its reset value after a warm reset`));
  eq(m.peek(YAPP_MEM.base + 1), 0x77, "yapp_mem keeps its contents through a warm reset");
  eq(m.peek(PKT_MEM.base + 0), 0x11, "yapp_pkt_mem keeps its contents through a warm reset");
  m.reset(true);
  eq(m.peek(YAPP_MEM.base + 1), 0x00, "a cold reset clears yapp_mem");
  eq(m.peek(PKT_MEM.base + 0), 0x00, "a cold reset clears yapp_pkt_mem");
}

// ------------------------------------------------------------------ 10. packet helpers: encode, check, parse
{
  eq(evenParity([0x11, 0xde, 0xad, 0xbe, 0xef]), 0x33, "even parity of the worked example");
  const p = encodePacket({ addr: 1, length: 4, payload: [0xde, 0xad, 0xbe, 0xef] });
  eq(p.bytes.join(","), GOOD.join(","), "encodePacket reproduces the worked example");
  eq(encodePacket({ addr: 1, length: 4, payload: [0xde, 0xad, 0xbe, 0xef], corrupt: 3 }).parity, 0x33 ^ 0x08, "corrupt flips the requested parity bit");
  eq(encodePacket({ addr: 2, length: 70, payload: [] }).header >> 2, 63, "length saturates at 63");
  eq(encodePacket({ addr: 7, length: 1, payload: [0] }).header & 3, 3, "address is 2 bits");

  let c = checkPacket(GOOD, { maxpktsize: 63, routerEn: 1 });
  expect(c.ok && c.checks.every(x => x.s === "ok"), "checkPacket: the worked example is clean");
  c = checkPacket([0x11, 0xde, 0xad, 0xbe, 0xef, 0x32]);
  expect(!c.ok && c.checks.some(x => x.s === "bad" && /parity/.test(x.t)), "checkPacket: bad parity flagged");
  c = checkPacket(encodePacket({ addr: 3, length: 1, payload: [0] }).bytes);
  expect(!c.ok && c.checks.some(x => /illegal/.test(x.t)), "checkPacket: address 3 flagged");
  c = checkPacket([0x11, 0xde, 0xad]);
  expect(!c.ok && c.checks.some(x => /missing/.test(x.t)), "checkPacket: missing bytes flagged");
  c = checkPacket([...GOOD, 0x00]);
  expect(c.ok && c.checks.some(x => x.s === "warn" && /extra/.test(x.t)), "checkPacket: extra bytes are a warning, not an error");
  c = checkPacket(GOOD, { maxpktsize: 2 });
  expect(c.ok && c.checks.some(x => x.s === "warn" && /maxpktsize/.test(x.t)), "checkPacket: oversized is a warning");
  c = checkPacket(GOOD, { routerEn: 0 });
  expect(c.checks.some(x => x.s === "warn" && /router_en/.test(x.t)), "checkPacket: router_en = 0 is a warning");
  c = checkPacket([0x01, 0x00]);
  expect(!c.ok && c.checks.some(x => /length 0/.test(x.t)), "checkPacket: length 0 is illegal");

  eq(parseBytes("11 de ad be ef 33").join(","), GOOD.join(","), "parseBytes: spaces");
  eq(parseBytes("0x11,0xde,0xad,0xbe,0xef,0x33").join(","), GOOD.join(","), "parseBytes: 0x and commas");
  eq(parseBytes("11deadbeef33").join(","), GOOD.join(","), "parseBytes: one hex string");
  expect(Array.isArray(parseBytes("")) && parseBytes("").length === 0, "parseBytes: empty text gives no bytes");
  eq(parseBytes("zz"), null, "parseBytes: rejects non-hex");
  eq(parseBytes("100"), null, "parseBytes: rejects a value above 0xff");
}

// ------------------------------------------------------------------ report
if (failures.length) {
  console.error(`sim checks: ${failures.length} of ${checks} FAILED`);
  failures.forEach(f => console.error("  - " + f));
  process.exit(1);
}
console.log(`sim checks: OK (${checks} assertions)`);
