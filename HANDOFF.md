# HANDOFF.md — YAPP Router UVM course (`tamirgabgab/qcom-mentoring`)

> נכתב בסוף הסשן הרביעי (2026-10-07), עודכן בסשן החמישי (2026-10-08) ובסשן השישי (2026-10-09: סימולציה
> ב-Verilator). סשן חדש לא זוכר כלום — זה המקור היחיד להקשר, יחד עם `CLAUDE.md` בשורש.
> HEAD: ראה "סטטוס git" בסעיף 2. `main` תמיד מצביע לאותו commit כמו ענף העבודה. עץ העבודה נקי.
> CI (lint + sim + docs) — ראה סעיף 2. האתר: https://tamirgabgab.github.io/Qcom-Mentoring/
> **לאן ממשיכים:** סעיף 8: השלמת ה-Test plan (CNT-06, ROUTE-04) ← UX במפה. הקוד **רץ** עכשיו ב-Verilator
> (`make sim` / `make regress`, Codespaces, workflow `sim`); Xcelium עדיין לא.

---

## 1. מטרת הפרויקט

**מה זה.** מימוש מלא, מאפס, של פרויקט האימות YAPP packet router מתוך הקורס
"SystemVerilog Accelerated Verification Using UVM" של Cadence, בתור חומר הוראה. תמיר מלמד
את הקורס לסטודנטיות שלו (mentoring) ורוצה ממשק נוח וקריא להעברת הקורס.

**מה מנסים להשיג.**
- פתרונות עיון מלאים וקריאים לכל המעבדות 1 → 11C (כולל האופציונליות 9C, 9D, 10 ו-RAL 11A/B/C).
- ה-DUT (yapp_router) ממומש מהמפרט, עם טסטים שבודקים את כל החומרה.
- אתר הוראה (MkDocs Material) עם דיאגרמות UVM כלליות ופרויקטליות, מדריך לכל רכיב, test plan,
  דף לכל מעבדה.
- מפת פרויקט אינטראקטיבית (web) שאפשר "להסתכל לתוכה": היררכיה עם drill-down, זרימת TLM,
  UML של המחלקות, קוד המקור של כל פריט, סימולטורים קטנים.
- `yapp_project/` כ"מקור האמת": הפרויקט המלא כאילו נכתב מאפס (rtl / uvc / tb).

**אילוצים.**
- סימולטור יעד של הקורס: Cadence Xcelium (`xrun -uvmhome CDNS-1.1d`, גם CDNS-1.2 דרך shim).
- **לתמיר אין שום סימולטור/קומפיילר SV במחשב** (סשן 6). לכן נבנה flow חינמי עם **Verilator 5.052**
  (`scripts/sim.py`, `make sim` / `make regress`), שרץ אצלי בקונטיינר, אצל תמיר ב-GitHub Codespaces
  (`.devcontainer/`) וב-CI (`.github/workflows/sim.yml`). **כל הלאבים וכל הטסטים עוברים ב-Verilator**;
  ב-Xcelium הקוד עדיין לא רץ (four-state, UVM 1.1d, IMC — `docs/appendix/unverified.md`).
- slang (pyslang 12.0.0) מול מקור UVM של Accellera נשאר בדיקת ה-elaboration המהירה (`make lint`).
- **אסור להכניס לריפו** את ה-PDF של Cadence (`UVMA_1_2_6.secured.lab.pdf`, מסומן "Do not
  distribute") או את `uvm_course.md` (הסיכום שתמיר העלה). `.gitignore` חוסם `*.pdf`. איור מבנה
  הפקטה צויר מחדש כ-SVG שלנו במקום צילום מה-PDF — בכוונה.
- אין קבצי מקור של Cadence (UVCs "מסופקים", reg_verifier) — הכול נכתב מחדש.
- שפת האתר והקוד: אנגלית. השיחה עם תמיר: עברית.
- **פורמט התשובות בצ'אט (בקשה קבועה של תמיר, סשן 5):** כל פסקה, כותרת ופריט ברשימה מתחילים
  **במילה בעברית** (או בסימן RLM ‏U+200F לפני תו לטיני), אף פעם לא במילה באנגלית, במספר עם נקודה
  או בקוד — אחרת הדפדפן מרנדר את השורה משמאל לימין והטקסט נקרא הפוך. מונחים/שמות קוד
  באנגלית נכנסים באמצע או בסוף המשפט. רשימות ממוספרות: לכתוב "‏1. **מסגרת** ..." עם RLM לפני
  המספר. בלי רשימות שמתחילות ב-**Container** או ב-`code`. ההוראה שמורה גם ב-`CLAUDE.md` בשורש.

**העדפות שהוצהרו (כללים קבועים).**
- **סגנון קוד SV** (נאכף ב-CI על ידי `scripts/sv_style.py --check`):
  - מחלקה אחת בכל קובץ; קבצי ה-"include" של הקורס (`yapp_tx_seqs.sv`, `router_test_lib.sv`,
    `router_mcseqs_lib.sv`, `yapp_router_reg_pkg.sv`) נשארים בשמם ורק עושים `include` לקבצי
    `seqs/`, `tests/`, `mcseqs/`, `reg/`.
  - פרוטוטיפים `extern` בתוך המחלקה, מימושים אחרי `endclass` כ-`function cls::name(...)`,
    תחת באנר `// <cls> -- method implementations`, ו-**delimiter `//-----…` (78 מקפים) לפני כל
    מימוש** (שורה ריקה, delimiter, המימוש).
  - **משתנים מקומיים בתחילת הפונקציה** — אף פעם לא בלוק `begin/end` עירום באמצע הגוף.
  - **כל גוף של `if/else/for/foreach/while/repeat` עטוף ב-`begin … end`, גם פקודה אחת**
    (גם ב-RTL, גם `repeat (n) @(posedge clk);`). `begin` תמיד על שורת הכותרת. `sv_style.py` מפצל
    one-liners ועוטף; בלוקי constraint ו-`with {…}` לא נוגעים (שם begin/end לא חוקי).
  - **ערכים אקראיים רק דרך `rnd::`** (`common/rand_util_pkg.sv`, import בכל package וב-tb_top):
    `get_bit/get_int/get_uint/get_byte/get_bits/get_index/get_bytes/get_byte_queue`,
    `rnd_array #(N)::get_bytes` למערך קבוע. ארגומנט אחרון = שם לזיהוי; כישלון → `uvm_fatal("RND", ...)`.
    בלי `$urandom` ישיר. `randomize()` של אובייקטים (sequence items/sequences) נשאר כמו שהוא.
  - **בלי `uvm_do*` / `uvm_create` / `uvm_send`**: סיקוונס כותב `create → start_item → randomize()
    with {…} (+ uvm_error על כישלון) → finish_item`; תת-סיקוונס: `create → randomize → seq.start(p_sequencer.x, this)`.
  - **בלי `uvm_field_*`**: ל-objects יש `do_copy / do_compare / do_print / do_pack / do_unpack /
    do_record` ידניים; לרכיבים `do_print` + קריאה מפורשת `uvm_config_int::get(this,"",name,
    uvm_bitstream_t)` ב-`build_phase` אחרי `super.build_phase` (כך `set_config_test` עדיין עובד).
  - נשארים: `uvm_component_utils / uvm_object_utils`, `uvm_info/warning/error/fatal`,
    `uvm_declare_p_sequencer`, `uvm_analysis_imp_decl`.
- **ה-DUT מפוצל למודול בכל קובץ לפי הארכיטקטורה** (`yapp_project/rtl/`), נטען עם
  `-F ../rtl/yapp_router.f`.
- **Git**: לפתח על ענף ה-`claude/...` שהסשן קיבל (סשן 1–4: `claude/hopeful-meitner-r5epiu`; סשן 5:
  `claude/confident-rubin-m1zkvc`; סשן 6: `claude/hopeful-gates-acsuwt`), לדחוף, ואז **fast-forward של `main`** לאותו
  commit אחרי כל push (תמיר רוצה ש-`main` וה-Pages יישאו הכול). כל הודעת commit מסתיימת ב:
  ```
  Co-Authored-By: Claude <model> <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_<id>
  ```
  (המודל וה-session id משתנים בין סשנים — תמיד להעתיק את ה-trailer שה-system reminder נותן.)
  **אין מזהי מודל** (Claude/Fable וכו') בשום artifact שנדחף (קוד, הערות, PR body) מלבד ה-trailer.
- **מסירה**: אחרי כל סבב — `QcommMentoring.zip` של הריפו (בלי `.git`, `site`, `build`,
  `__pycache__`, `scripts/uvm_src`) + `yapp_project_map.html` העצמאי נשלחים לתמיר דרך
  SendUserFile. הוא מעתיק ל-`C:\Users\User\Desktop\PyProjects\QcommMentoring` או עושה
  `git pull origin main`.
- לפני שינויים גדולים תמיר רוצה **שאלות מנחות** (AskUserQuestion) ואז ביצוע מלא.
- מפת הפרויקט: תמיר מבקש **קליקים נוחים** (קליק בודד פותח/בוחר), **חצים מעוגלים ולא מבולגנים**,
  ולראות את **קובץ המקור המלא** של הפריט הנבחר.

---

## 2. מצב נוכחי

### מה עובד היום ונבדק (בקונטיינר)
- **סימולציה (סשן 6):** `make regress` = 18 ספריות סימולציה (`scripts/regress.yaml`), 61 טסטים — **כולם PASS**
  ב-Verilator 5.052 (מקומית ב-seed 1–2 וב-CI ב-2 seeds). `coverage_test` סוגר `yapp_pkt_cg` ב-100%,
  `backpressure_test`: in_suspend עלה 7 פעמים, 6/6 matched; `parity_error_test`: 12 פולסים ל-12 פקטות, 2..10 מחזורים.
  workflow `sim` ב-GitHub: job לכל ספרייה, ~3–4 דקות בסך הכול.
- `make lint` — כל 18 ה-`run.f` (17 מעבדות/test_install + `yapp_project/tb/run.f`) עוברים slang
  ב-0 שגיאות ו-0 אזהרות.
- `make style-check` — `sv_style: OK` (ואידמפוטנטי: `--fix` פעמיים = אין שינוי).
- `make map && make map-check` — 245 nodes, 279 edges, 41 scenes (5 תצוגות: Hierarchy, TLM, Classes,
  Environment, Test plan); `test_model.py` עובר (pins/regmap ב-root scene, regmap.yaml ⇔ localparams
  ב-RTL ⇔ offsets ב-RAL, סצנות env/plan, עקביות ה-Test plan מול המחלקות) **+ `test_sim.mjs`
  (536 assertions על `RouterModel` ועוזרי הפקטה, רץ מתוך `build --check` כשיש node)**. `docs/test-plan.md`
  נוצר מ-`build.py` ונבדק staleness.
- הטסטים: 24 מחלקות test במודל (17 של הקורס + 7 של ה-Test plan ב-`yapp_project/tb/tests`), לכל אחת plan
  (stages + expected) ולפחות פריט אחד ב-`plan:` שמזכיר אותה. 56 פריטי תוכנית: 53 covered, 1 partial, 1 gap, 1 excluded.
- `mkdocs build --strict` — 0 אזהרות (רק INFO על anchors של deep links — צפוי).
- בדיקת דפדפן (Playwright, סקריפט חד-פעמי ב-scratchpad, לא בריפו): המפה נטענת בבהיר/כהה,
  ה-DUT מצויר עם 19 פינים ובלוק רגיסטרים, קליק על הבלוק פותח את לשונית Simulate, כתיבה דרך ה-UI
  ל-en_reg, כתיבה ל-RO נדחית, ו-10 assertions על `RouterModel` (reset, good packet, bad parity,
  addr 3, oversized, router disabled, unmapped, warm reset, checkPacket) — הכול עבר.
- CI ב-GitHub: workflow `lint` (slang + style-check + map-check) ו-`docs` (mkdocs → GitHub Pages)
  ירוקים על כל commit של סשן 5 עד `3687ecb` (נבדק דרך ה-API). ה-runner של GitHub (ubuntu-latest) כולל node, ולכן `map-check`
  ב-CI מריץ גם את `test_sim.mjs`.
- GitHub Pages פעיל (Source = GitHub Actions), האתר חי, המפה ב-`/project-map/` והקובץ העצמאי
  ב-`/downloads/yapp_project_map.html`.

### מה נעשה — כרונולוגיה של כל הסשנים

**סשן 1 (בניית הכול מאפס):** DUT `router_rtl/yapp_router.sv` (אז קובץ אחד), ארבעה UVCs
(yapp, hbus, channel, clock_and_reset) + router module UVC (scoreboard, reference, fifo scoreboard),
17 snapshots של מעבדות ב-`labs/`, מודל רגיסטרים ידני (11A/B/C), lint harness
(`scripts/lint.py` + `scripts/get_uvm.sh`), אתר MkDocs עם ~42 דיאגרמות Mermaid ו-4 SVG של
waveforms (`scripts/gen_waves.py`), CI. Commits `0593ead`, `247ad6f`, `f21517b`. `main` עודכן
ל-feature branch לבקשת תמיר.

**סשן 2 (מפת הפרויקט):** `scripts/project_map/` (extract.py עם pyslang → model.py → layout.py →
build.py → `model.json` + `docs/downloads/yapp_project_map.html`), `docs/assets/project_map/app.js
+ app.css` (vanilla JS: pan/zoom, drill-down, פאנל צדדי, חיפוש, deep links, ייצוא SVG/PNG/print,
highlighter SV), `docs/project-map.md` (iframe + סנכרון hash/theme), `export.mjs` (Playwright →
`export/*.svg|png`, PDF ל-`build/`), `test_model.py`, CI staleness check. פיצול 173 מחלקות
לקובץ-למחלקה. פידבק של תמיר: חצים ישרים/מבולגנים → מתכנן קצוות דו-שלבי עם S-curves; "Open" לא
עבד → קליק בודד על `▸ open` + כפתורי פאנל. Commits `a4efbfb`, `1c8da5e`, `c78e729`.

**סשן 3 (קליקים + עמודת Source, Pages, restructure גדול):**
- `c12b5aa`: קליק על מחלקה רק סימן טקסט (pointer capture) → tap נפתר ב-pointerup עם
  `elementsFromPoint`; עמודת **Source** שלישית עם הקובץ המלא (`model.files`), כפתור `</> Source`, מקש `c`.
- הסברים לתמיר: גישה לתיקייה המקומית (אין — ZIP/`git pull`), Claude Desktop מול סשן ענן,
  איפה ה-HTML בריפו, הפעלת GitHub Pages (צילומי מסך עם עיגולים; הוא הפעיל Source=GitHub Actions,
  הרצתי מחדש את `docs.yml`), איפה כתובים הטסטים.
- **restructure** לפי 4 תשובות של תמיר: (1) DUT מפוצל לפי ארכיטקטורה ל-6 מודולים
  ב-`yapp_project/rtl/`; (2) extern בכל הקוד (175 מחלקות) — בוצע עם סקריפט pyslang חד-פעמי
  (`restyle.py`, ב-scratchpad, **לא בריפו**); (3) החלפת `uvm_do*`/`uvm_field_*`; (4) `yapp_project/`
  כמקור האמת (`git mv` של ה-UVCs מ-`<uvc>/sv` ל-`yapp_project/uvc/<uvc>`, `tb/` = עותק של lab11c,
  כל ה-`run.f` של המעבדות מצביעים ל-`../../../yapp_project/...`). backdoor root של ה-RAL עבר
  ל-`hw_top.dut.u_regs`. Commits `bea3cc2`, `d6e6c0a`, `294cf18`, `0fa3c80`.

**סשן 4 (הסשן הזה):**
1. `4f13ab5` — **code style pass**: `scripts/sv_style.py` חדש (`--fix/--check/--diff`), 240 קבצים
   עוצבו; תוקנו 9 פרוטוטיפים `extern // comment` + `virtual` בשורה הבאה (באג של ה-restyle);
   `make style / style-check`, שלב CI, תיעוד ב-getting-started ו-README. המפה נבנתה מחדש (מספרי
   שורות זזו).
2. `92171ec` — **ה-DUT כ-block diagram ב-root scene**: `hw_top` בשלוש עמודות
   (`columns` hint חדש ב-layout), ה-DUT 618px רחב עם 19 פינים כתובים בפנים (חיצי כיוון, רוחב bus),
   כותרת "DUT" גדולה, בלוק **registers (HBUS)** עם טווחי כתובות; חצי הסצנה נוחתים על קבוצת הפינים
   (`pin_groups` ב-annotations.yaml). `scripts/project_map/regmap.yaml` = מקור יחיד למפת הרגיסטרים
   → `meta.regmap` ב-model.json + `docs/assets/project_map/regmap.js` מיוצר.
3. `4948f7f` — **סימולטורים**: `docs/assets/project_map/sim.js + sim.css` (RouterModel שמשקף את
   `yapp_hbus_regs.sv` + `yapp_input_fsm.sv`; widget רגיסטרים; packet playground), לשונית
   **Simulate** במפה, אותם widgets בדפי `dut/spec.md` ו-`components/packet.md`,
   `docs/assets/packet_structure.svg` (gen_waves.py), `yapp_project/uvc/yapp/README.md`, ASCII של
   מבנה הפקטה בכותרת `yapp_packet.sv` (פרויקט + 6 עותקי מעבדות זהים), exports חודשו.
4. נשלחו `QcommMentoring.zip`, `yapp_project_map.html`, `project_map_root.png`. סיכום בעברית ניתן.
5. `c928f3d` — **HANDOFF.md** נכתב (לפי התבנית `handoff.md` של תמיר) ובסוף גם נכנס ל-commit: התבנית
   אמרה "בלי commit", אבל ה-stop hook שלו דרש פעמיים ושאלתו רמזה שהוא מצפה לקובץ בריפו.
6. `c98a036` — **שדרוג README.md** לפי 4 תשובות של תמיר (קהל: סטודנטיות קודם, מנטורים אחריהן; תמונות:
   היררכיה מלאה + זום על ה-DUT + סימולטור רגיסטרים + מגרש פקטה; עץ מלא עם שורת הסבר לכל תיקייה
   וקובץ מרכזי; badges של CI וקישורים לאתר/למפה בראש). מבנה: badges + תוכן עניינים → For students
   (המפה, ה-DUT ומפת הרגיסטרים המקוצרת, שני הסימולטורים, טבלת 8 המפגשים של המעבדות עם קישורים לאתר)
   → Quick start → Repository layout (עץ מלא, GENERATED מסומן) → For mentors (סגנון, כלים ו-CI, מה לא
   אומת). ארבעת הצילומים ב-`docs/assets/readme/` נוצרים ע"י **`scripts/readme_shots.mjs`**
   (`make readme-shots` = `mkdocs build --strict` + Playwright): `map_overview.png` (root scene עם `tb`
   נבחר, פאנל + עמודת Source), `map_dut.png` (hw_top בזום, פאנלים/legend/hint מוסתרים),
   `sim_registers.png` (דף `dut/spec` אחרי WR ל-0x1004 שנדחה), `sim_packet.png` (דף `components/packet`
   אחרי Send to router). נשלחו zip + README.
7. `79b5fd4` — HANDOFF.md עודכן (README + כלי הצילומים).

**סשן 5 (2026-10-08):**
1. נבדק ב-GitHub Actions ש-`lint` ו-`docs` ירוקים על `79b5fd4` (גם ב-main וגם בענף).
2. **`scripts/project_map/test_sim.mjs`** — פריט 2 מרשימת "הצעד הבא": 10 התרחישים של `RouterModel`
   מה-scratchpad של סשן 4 הועברו לריפו והורחבו ל-536 assertions (ערכי reset, מדיניות RW/RO/זיכרונות/לא
   ממופה כולל החורים 0x1002–3, 0x1007–8, 0x100c, 0x100e–f, פקטה תקינה, bad parity (נספר + error + מועבר),
   addr 3, oversized מול `ctrl_reg`, router disabled, gating של כל מונה לפי `en_reg`, פקטה חלקית/בתים
   עודפים/גלישת מונה, warm vs cold reset, `encodePacket/checkPacket/parseBytes/evenParity`). הסקריפט טוען
   את `regmap.js`+`sim.js` ב-`node:vm` עם stub של `window/document` (אין תלות ב-DOM). `build.py:check()` מריץ
   אותו אחרי `test_model.run_all` כש-`node` ב-PATH (אחרת מדפיס skipped). תועד ב-README (עץ + For mentors)
   וב-`docs/getting-started.md`. אומת: lint 18/18, style OK, map-check OK (לא STALE), mkdocs strict OK.
3. תמיר: אין לו מכונה עם Xcelium → הסימולציה נשארת לא-מאומתת בינתיים (סעיף 7).
4. **סבב UX במפה ובסימולטור** (לפי 5 הבקשות של תמיר + 8 תשובות לשאלות מנחות):
   - `sim.js`: מצב ה-widget של הרגיסטרים נשמר על המודל (`model.__ysRegs`) ולא על ה-host, כי הפאנל
     נבנה מחדש בכל מעבר לשונית → הבחירה (en_reg וכו') נשמרת. **דיאגרמת שדות** (`fieldDiagram`):
     מספרי ביטים 7..0 מעל, MSB משמאל / LSB מימין, תא לכל ביט, סוגריים עם שם השדה מתחת (אנכי לשדה
     צר, אופקי לרחב), reserved מקווקו, מקרא `[bits] name = value -- desc`. בטבלת הרגיסטרים: שורת-משנה
     עם הדיאגרמה לרגיסטרים עם שדות (ctrl_reg, en_reg); לחיצה על שורה בוחרת את הרגיסטר בכרטיס HBUS.
     **עורך כתיבה**: מתחת ל-data (hex) הדיאגרמה של הכתובת הנבחרת; לחיצה על ביט הופכת אותו ומעדכנת
     את ה-hex (ולהפך); במצב Read מציגה את הערך הנוכחי.
   - `layout.py`: **DUT קומפקטי ב-TLM** (`style: dut_tlm`): 11 פינים של ממשקים (6 משמאל = drivers,
     5 מימין = monitors), id = `hw_top.<if>@left|right`, בגובה ה-driver/monitor שלהם → חצי vif ישרים.
     `port_on_left()`: ה-pull port של ה-driver משמאל, ה-pull imp של ה-sequencer מימין (שניהם kind
     `seq_item_port`, מובחנים לפי type) → sequencer→driver קו ישר.
   - `app.js`: **ניתוב אורתוגונלי ב-JS** (`orthoRoute`, `roundedPath`, `routeEdges`): החצים מחושבים
     מגיאומטריית הקופסאות בדפדפן (ports, pins, anchors של dut_spec, צד נבחר ב-`pickSide`, פיזור
     לאורך הצלע, offset ל-corridor משותף, ports של container שמתחברים פנימה מתהפכים, שני ports של
     אותה קופסה = קו חוצה). ה-`points` של Python הם fallback בלבד. **גרירת קופסאות** (container
     גורר את ילדיו, frames של TLM עוקבים) עם שמירה ב-`localStorage` (`pm-layout:<scene>`) וכפתור
     **Reset layout**. **כפתור Arrows** (`a`): כבוי = רק חצי הקופסה שתחת העכבר/הנבחרת; ברירת מחדל כבוי
     ב-Hierarchy/TLM, דלוק ב-Classes, נשמר (`pm-arrows`). **ידיות רוחב** (`.pm-resizer`) לפאנל
     ולעמודת Source, נשמרות (`pm-w-panel`, `pm-w-code`), double-click מאפס. **טבלאות Fields/Methods**
     (שם | סוג | שורה; לחיצה → `showCodeAt` מסמנת וגוללת לשורה בעמודת Source). ציור `drawDutTlm`.
   - **באג ישן תוקן ב-`exportSvgString`**: ה-bg rect הוכנס לפני זיווג live/clone לפי אינדקס, כך שכל
     ה-`g.pm-edge` נמחקו — **ה-SVG/PNG המיוצאים מעולם לא כללו חצים**. עכשיו כן, וגם כש-Arrows כבוי.
   - `test_model.py`: pins נחשבים anchors; בדיקות ל-DUT ב-TLM (11 פינים, 6/5, כל vif נוגע בפין).
   - תועד ב-`docs/project-map.md` וב-README. צילומי ה-README **לא** חודשו (בקשת תמיר); `export/` חודש.
5. **סבב UX שני במפה** (7 בקשות של תמיר עם צילומים + 4 תשובות לשאלות מנחות):
   - `layout.py`: `PAD` 14→20 (ה-containers מרווחים יותר). **`face_partners()`** (בסיס `Layout`, רץ
     בסצנות היררכיה ו-TLM אחרי הסידור): port עובר לצד של הקופסה שפונה לקופסה שהוא מדבר איתה —
     רק כשכל השותפים באותו צד, לא כשהשותף הוא frame סביבו, ורק אם יש רוחב לתוויות בשני הצדדים;
     ה-ports נערמים מחדש והקופסה גדלה אם צריך. כך driver→sequencer ישר בכל סצנה (לא לולאה סביב ה-agent).
     **`add_stubs()`**: stub (הקצה הרחוק של חיבור שיוצא מהרמה) יושב בצד של הקופסה שהוא מדבר איתה
     (כל השותפים משמאל ל-root_cx → שמאל, כולם מימין → ימין, אחרת כלל הכיוון הישן), ממוין לפי גובה
     השותף ומיושר אליו כשיש מקום (`wanted_y`; שותף = קופסה בסצנה או port על ה-root). הרווח בין stub
     ל-container = max(54, min(110, רוחב התווית+24)). ב-`h:hw_top` המוניטורים של chan0..2 מימין ליד ch0..2.
     **DUT (`dut_spec`)**: החצים של הפינים **מחוץ** לקופסה (`PIN_OUT = 24`), השמות בפנים; `label_w`
     קטן ב-24; `extra["margin"] = PIN_OUT+4` ו-`margin_of()` ב-`arrange`/`arrange_columns` משאירים
     מקום; ה-anchors של הסצנה נוחתים בקצה החיצוני של חץ הפין (גם ב-Python וגם ב-JS `endpointOf`).
     `size_leaf`: +14px גובה לקופסה עם ports וגם סמן "open" (לא חופפים יותר).
   - `app.js`: **היסטוריית ניווט** (`pushHist/back/forward/restoreHist`): צעד = סצנה + פריט נבחר;
     נרשם ב-`updateHash()` (לא בזמן שחזור, `_restoring`); בחירה חדשה באותה סצנה מחליפה את הצעד של
     הבחירה הקודמת; כפתורים ◀ ▶ בסרגל + `Alt+←/→`; **⌂ Home** (`h`) = `h:root`, בלי בחירה, Fit.
     **`drawDutSpec`** כמו `drawDutTlm` (חץ בחוץ, שם בפנים, רוחב bus בחוץ). **עקיפת מכשולים
     ב-`orthoRoute`**: ל-Z/קו ישר בין שתי קופסאות שפונות זו לזו, אם המסלול חותך קופסת עלה/stub
     (`crossings()`, סגמנט נחשב אופקי/אנכי עד 1px), מנסים מעקף מעל/מתחת למכשולים ולוקחים אותו אם
     הוא חותך פחות (`routeEdges` מעביר את רשימת הקופסאות בלי שתי הקצוות). פתר את router_module
     (chan exports מתחת ל-reference), hbus (vif מעל ה-monitor), root (chan0→hbus סביב router_module).
   - `app.css`: **תיקון באג** — ידית הרוחב של Source הוסתרה כשהפאנל מוסתר (`.panel-hidden .r-code`),
     לכן לא ניתן היה לשנות רוחב עם Source בלבד. הכלל הוסר.
   - `sim.js`/`sim.css`: **דיאגרמת הביטים בלי שמות השדות** (הסוגריים האנכיים הוסרו); מתחת לכל
     דיאגרמה — גם בכרטיס HBUS וגם בטבלת REGISTERS — שורה לכל שדה `[bits] name = value -- desc`
     (אותו פורמט לכולם, גם ctrl_reg; רגיסטר בלי שדות = שורה אחת `[7:0] name = v -- desc`, לא ממופה =
     הסבר). `opts.legend` הוסר, נוסף `opts.singleDesc`.
   - תועד ב-`docs/project-map.md` (פסקה "Getting around") וב-README. `export/` חודש (50 קבצים).
     צילומי ה-README לא חודשו.
6. **סבב UX שלישי + שתי תצוגות חדשות** (5 בקשות של תמיר + 4 תשובות לשאלות מנחות):
   - `app.js` **גרירת container**: `moveItem` אוסף את הצאצאים לפי שרשרת ה-parent ב-`N` (לא רק לפי
     prefix של ה-id, כי `tb`/`uvm_test_top` לא מקבלים prefix) → גרירת `uvm_test_top` או `tb_top` לוקחת
     את כל מה שבפנים. **ה-frames המקווקווים ב-TLM נגררים** (`fg.__frame`, `drag.item` = ה-frame,
     `moveItem` מזיז את החברים לפי prefix; נשמר תחת id ה-frame). `layout.py`: `FRAME_GAP = 18` בין
     קבוצות עוקבות באותו lane.
   - **סמני `▸ open` ו-`↗` הוסרו** מכל הקופסאות (`drawItem`, `tap`), והמקום שנשמר להם ב-`size_leaf`.
   - **containers רחבים יותר**: `make_box` שומר שוליים לתוויות של ports **בשני** הצדדים (port יכול
     לעבור צד ב-`face_partners`), כך `chan1_export`/`chan2_export` של router_module ב-`h:tb` לא
     נוחתים על ה-scoreboard.
   - **תצוגת Tests** (`tests:main`, `TestsLayout`): כרטיס לכל מחלקת test במודל (17: גם הטסטים של
     לאבים 4–6 אחרי הוספת `labs/lab06_vif/tb/run.f` כמקור רביעי ב-`annotations.yaml`), בסדר הלאבים,
     `base_test` למעלה; בכרטיס: שם, Lab + extends, מטרה (עד 3 שורות), chips של שלבי התוכנית (3 בשורה,
     צבע לפי סוג: build/config/reset/program/stimulus/check/report, hover = פירוט). חיצי `inherits`
     (Arrows כבוי כברירת מחדל). **`tests:` ב-annotations.yaml**: לכל טסט purpose, stages
     (`{k, t, d}`), expected — כתבתי מהקוד ומדפי הלאבים (אין גישה ל-PDF בקונטיינר; תמונות ה-PDF
     אסורות ממילא). `model.py` מצרף `plan` לכל node מסוג test. בפאנל (`renderPlan`): ציר זמן SVG
     ממוספר, רשימת השלבים עם הפירוט, Expected, "Stimulus set up by the code" (default_sequence
     מ-config_sets, `start()` מ-notable_calls, overrides) ו-`make run TEST=`. חיפוש של test כש-Tests
     פתוח נשאר ב-Tests (`gotoNode`).
   - **תצוגת Environment** (`env:main`, `EnvLayout(HierarchyLayout)`): `root_scene` עם
     `expand_tb=6`, hints מ-`layout.env` (עמודה אחת per agent: sequencer/driver/monitor), `yapp_rm`
     נשאר קופסה אחת (`leaf_ids`), **שורת role** לכל עלה (`role_of`: summary של ה-node/המחלקה, עד 46
     תווים, `size_leaf` מוסיף גובה/רוחב). double-click פותח ב-Hierarchy.
   - `test_model.py`: בדיקות לשתי הסצנות (17 כרטיסים עם plan+expected, 16 חיצי inherits; env מציג
     sequencer/driver/monitor, yapp_rm סגור, role לכל עלה). `export.mjs`: PNG גם ל-env ו-tests.
   - מקשים `4`/`5` לתצוגות החדשות; README ו-`docs/project-map.md` מתארים חמש תצוגות (אין יותר "▸ open corner").
7. **סבב 4 של סשן 5 — Test plan (תמיר העלה שוב את ה-PDF; קראתי את עמודי המפרט 5–11 ואת לאבים 7, 9A, 10, 11C):**
   - **`plan:` ב-`annotations.yaml`** — תוכנית אימות לפי features, עמוד-עמוד: 11 קבוצות (ROUTE, PKT, IN,
     OUT, REG, DROP, CNT, MEM, HBUS, COV, TB), 56 פריטים; לכל פריט `id, title, stimulus, check, coverage,
     tests, status (covered/partial/gap/excluded), note`. 53 covered, ROUTE-04 partial (מרווח מינימלי בין
     פקטות), CNT-06 gap (גלישת counter — המפרט שותק), DROP-05 excluded (שינוי enable באמצע פקטה = undefined).
   - **7 טסטים חדשים ב-`yapp_project/tb/tests/`** (לא בלאבים; lab pseudo "TP" דרך `lab_overrides` + `labs.test_plan`):
     `router_disable_test` (DROP-02), `router_filter_test` (DROP-01/03/04, CNT-*; `yapp_boundary_seq`),
     `pkt_mem_test` (MEM-01..03, REG-06; `yapp_pkt_seq`), `reg_bit_walk_test` (REG-02/03, walking ones/zeros),
     `hbus_protocol_test` (HBUS-01..03, REG-05; raw sequences, tri-state, unmapped), `backpressure_test`
     (IN-03, OUT-03/04; `channel_rx_slow_seq` delay 20..40), `parity_error_test` (PKT-05, IN-04; `error_pulse_checker`
     subscriber שקורא `hw_top.error`/`hw_top.clock_period` היררכית — הפין היחיד מחוץ לכל ממשק). כולם
     extend `reg_function_test`/`reg_access_test` ומממשים `access_checks()`. **לא רצו בסימולטור** (slang 18/18 ירוק, style OK).
   - **באג שנמצא בכתיבת backpressure_test ותוקן ב-`yapp_if.sv`:** `wait_accept()` דגם `in_suspend` ב-negedge;
     header שמוצע ל-FIFO מלא נדחה ב-posedge, ואם ה-receiver משחרר באותו posedge, `in_suspend` כבר נמוך
     ב-negedge → ה-driver מתקדם וה-header אובד. עכשיו: `do @(posedge) while (in_suspend); @(negedge)` — כמו ה-DUT והמוניטור.
     מתועד ב-`components/driver.md`, IN-03 note, `unverified.md` #1.
   - **תצוגת Tests → Test plan** (`plan:main`, view `plan`, `PlanLayout`): למעלה כרטיס לכל feature group
     (`style: feature_card`, chips לפי status, hover = title, click = בחירה + גלילה לפריט בפאנל), למטה
     כרטיסי הטסטים (24; `base_test` לבד בשורה; טסטי ה-TP אחרונים, sub "test plan"); `split` בסצנה. קשתות
     `covers` (feature→test, מקווקו, `--k-feature`) + `inherits`; Arrows כבוי כברירת מחדל. `model.py`:
     `build_plan()` — nodes `plan:<ID>` kind `feature` (scope `plan`), `m["plan"]`, back links `covers` על
     כל test node, שם טסט לא קיים → `unresolved`. פאנל: `renderFeature` (counts, פריטים עם stimulus/check/
     coverage/tests/note, `#pi-<ID>` + flash), בטסט "Test plan items this test verifies". `labTxt()` מציג
     "Test plan" במקום "Lab TP". deep link `#view=plan&node=plan:PKT`.
   - **`docs/test-plan.md` נוצר מ-`build.py`** (`render_test_plan_md`, ב-`GENERATED` → map-check בודק staleness):
     טבלה לכל קבוצה (Item+status | What is verified, and how | Tests), טבלת הטסטים (Lab/test plan, Purpose,
     Verifies), checklist. סטטוס = `<span class="st st-covered">` (CSS ב-`docs/assets/extra.css`; אין pymdownx.emoji).
   - `test_model.py`: בדיקות ל-`plan:main` (24 כרטיסי test ≥, 11 feature ≥, split, ≥50 covers) ולתוכנית
     (ids ייחודיים, statuses, כל טסט שמוזכר קיים, **כל טסט מוזכר לפחות בפריט אחד**, note לכל לא-covered).
   - README/index-tables/project-map.md עודכנו; `export/plan_main.*` במקום `tests_main.*`.
8. **סבב 5 של סשן 5 — ניווט בתוך מסגרות (תמיר: "כשאני גורר בתוך המלבן של yapp הוא זז במקום המסך"):**
   אחרי דיון (5 אפשרויות) תמיר בחר 1+2: **container ו-frame מקווקו זזים רק מפס הכותרת** (30px עליונים
   של container, 24px של frame; `inTitleBar`/`inFrameTitle` + `scenePoint`), הגוף שלהם מזיז את המסך
   כמו הרקע; עלים נגררים כרגיל. **כפתור אמצעי** (`e.button === 1`, בלי tap ב-pointerup) ו-**Space לחוץ**
   (`initSpacePan`, class `pan-mode` על ה-canvas, cursor grab) = pan מכל מקום. CSS: container/frame
   cursor grab, כותרת cursor move. hints, help, project-map.md, README עודכנו. נבדק ב-Playwright
   (`drag7.mjs` ב-scratchpad): גוף/כותרת/אמצעי/Space/עלה/לחיצה/frame. לא נבחר (אופציה 4): גלגלת=גלילה
   במקום זום — תמיר העדיף להשאיר זום בגלגלת.
9. **סבב 6 של סשן 5 — סיכום ורענון (תמיר: "נסכם את ההתקדמות, עדכן HANDOFF ו-README"; 4 תשובות לשאלות מנחות:
   לרענן סעיפים ולא לכתוב מחדש; עדיפויות: Xcelium → Test plan → UX; לצלם מחדש את כל צילומי ה-README;
   סיכום בצ'אט + HANDOFF):** README עם סעיף "The test plan" וצילום חמישי `map_testplan.png`
   (`readme_shots.mjs` מצלם 5), עץ הקבצים (סיקוונסים חדשים, `test-plan.md` GENERATED, `CLAUDE.md`),
   Quick start עם `make run-project`, "What has not been verified" מזכיר את 7 הטסטים ואת תיקון ה-handshake;
   כל 5 הצילומים חודשו (`make readme-shots`). HANDOFF: כותרת, מצב נוכחי, סעיף 8 לפי העדיפויות החדשות.
   **הכלל הישן "לא לצלם מחדש את צילומי ה-README" בוטל** — מעכשיו מצלמים מחדש אחרי שינוי בממשק.

**סשן 6 (2026-10-09) — סימולציה ב-Verilator:**
1. תמיר שאל Fable מול Opus 5.5 (מכסה: Fable שבועי 25%); המלצתי Opus לרוב, Fable לבאגים קשים. תמיר עבר ל-Opus 5.5.
2. הסברתי לפרטים את 3 המשימות (Xcelium / Test plan / UX). **תמיר: אין לו קומפיילר SV בכלל.** ביקש דרך פשוטה
   שגם הוא וגם אני נריץ: קומפילציה, טסט, רגרסיה, גלים. בדקתי את Verilator 5.052 (משחרר "UVM 2020-3.2 supported")
   — בניתי מהמקור ב-scratchpad, הפרויקט התקמפל מהפעם הראשונה (2.5 דק'), ואז מצאתי ותיקנתי (תשובות תמיר: לתקן
   בכל העותקים; cross עם ifdef; make + Codespaces + רגרסיה על כל הלאבים):
   - **באג אמיתי** `yapp_packet::set_parity()`: שתי קריאות `$urandom_range` → ~44% מפקטות ה-bad parity יצאו תקינות.
     תוקן (סבב 1: `parity ^= 8'h01 << $urandom_range(7, 0)`; סבב 2: `rnd::get_index` + היפוך ביט), 7 עותקים זהים.
   - Verilator: `payload.size() == length` לא מתקיים תחת `randomize() with` → `post_randomize()` מקצה payload לפי length.
   - Verilator: `dist` + שוויון ב-`with` → UNSAT אקראי → `c_parity_dist.constraint_mode(0)` ב-4 סיקוונסים שבוחרים parity
     (`yapp_pkt_seq`, `yapp_coverage_seq`, `yapp_boundary_seq`, `yapp_88_packets_seq`).
   - Verilator דו-מצבי: `hbus_protocol_test` תחת `` `ifdef VERILATOR `` בודק `hdata_oe` של ה-master וה-DUT במקום `'z`.
   - coverage: `parity_cp` עם bins מפורשים (Verilator עושה bins לפי טווח ל-enum); תחת `` `ifdef VERILATOR `` ה-cross
     בנוי מ-`legal_addr_cp` × `bad_parity_cp` (Verilator מתעלם מ-`ignore_bins ... binsof/intersect`). Xcelium רואה את המקורי.
   - **Lab 9** `scoreboard_drop_test::build_phase` קרא `base_test::build_phase(phase)` — Verilator עושה dispatch וירטואלי
     → רקורסיה אינסופית → segfault. עכשיו `router_simple_mcseq_test.short_packets` (knob) ש-`scoreboard_drop_test::new` מאפס.
3. **ה-flow:** `scripts/sim.py` (compile/run/waves/regress, קורא את ה-run.f דרך `lint.parse_run_f`), `scripts/regress.yaml`
   (ספרייה → טסטים; `{test: X, expect: errors}` לבדיקה שלילית — רק `lab09_sba/scoreboard_drop_test`), `scripts/setup_sim.sh`
   (apt + בניית Verilator אם חסר + העתקת `test_regress/t/uvm/v2020_3_1/dpi` ל-`$VERILATOR_ROOT/uvm-dpi/`), `common/verilator/`
   (`public.vlt` = public רק ל-`yapp_hbus_regs` בשביל ה-backdoor; `vl_waves.sv` = `$dumpfile` כש-`+waves=<f>.fst`),
   `make compile|sim|waves` ב-`common/lab.mk`, `make regress|sim|sim-project|setup-sim` בשורש. `get_uvm.sh` ננעל על
   tag `2020.3.1`. `lint.py` מייבא pyslang בעצלות. `.devcontainer/` (FROM `verilator/verilator:v5.052` + setup_sim.sh,
   הרחבות VaporView ו-veriloghdl, 4 ליבות), `.github/workflows/sim.yml` (job `benches` קורא את regress.yaml → matrix).
4. תיעוד: `docs/appendix/verilator.md` (חדש, בניווט), `unverified.md` → "Verification status", getting-started, README
   (badge `sim`, Quick start, עץ, Tooling, Verification status), `coverage.md`, `lab01.md`, `lab10.md`, `index.md`.
5. **סבב 2 — ספריית אקראיות + begin/end בכל מקום** (תשובות תמיר: package `rand_util_pkg` + מחלקה `rnd`; בכל
   העותקים כולל לאבים 1–6; `uvm_fatal` עם השם; begin/end על **כל** גוף בקרה ו-sv_style אוכף):
   - `common/rand_util_pkg.sv`: `virtual class rnd` עם static `get_bit/get_int/get_uint/get_byte/get_bits/get_index/
     get_bytes/get_byte_queue(…, string name = "")` + `rnd_array #(N)::get_bytes` (מערך קבוע). הכול `std::randomize()`;
     מערכים מוקצים קודם (Verilator מחזיר תור ריק עם `q.size() == n` ב-`with`). כישלון / `min > max` / `size == 0` →
     `uvm_fatal("RND", "<name>: ...")`. נבדק ב-Verilator (טסט זמני ב-`build/rnd_check/`, לא בריפו).
   - נכנס לכל `run.f` (לאבים 1–11C חוץ מ-11A, ופרויקט) ו-`import rand_util_pkg::*;` בכל package של UVC, ב-`router_module_pkg`
     של 9B–9D וב-`tb_top`/`top`. `yapp_packet` (7 עותקים): `set_parity` = `rnd::get_index(8, …)` + היפוך ביט אחד;
     `post_randomize` = `rnd::get_bytes(length, …)`. שם = `{get_full_name(), ".field"}`. אין יותר `$urandom` בקוד שלנו.
   - `sv_style.py` כלל 2: `split_one_liners()` מפצל `if (x) y;` / `if (a) x; else y;` / `else y;` / כותרות רב-שורתיות
     (`router_filter_test`) / גוף רב-שורתי (`end else case … endcase` ב-`yapp_hbus_regs`), ואז ה-Wrapper עוטף. מדלג על
     בלוקי `{}` (constraints, `with`) ו-macros. 115 קבצים השתנו; קטעי קוד ב-`docs/dut/rtl.md` ו-`docs/uvm/phases.md` עודכנו.
   - תיעוד: `docs/components/random.md` (חדש, בניווט ובטבלת components), `packet.md`, `lab01.md`, getting-started, README.
   - **שני באגים חדשים של Verilator 5.052** (מתועדים ב-`verilator.md`): השמת מערך דינמי למערך בגודל קבוע לא מתקמפלת;
     בתוך מתודה של class, `if (v inside {[-5:5]})` שקרי ל-`v` שלילי (טווח עם גבול שלילי). הקוד שלנו לא משתמש בזה.
   - אימות: slang 18/18, `sv_style --check` OK, map-check OK, mkdocs strict OK, **`make regress SEEDS=2`: 150/150 PASS**
     (coverage_test 100%, parity_error_test 12/12 פולסים). commit `62c6e7f` + commit ה-HANDOFF.

### מה בתהליך ולא גמור
- כלום פתוח בקוד. כל המשימות שתמיר ביקש הושלמו ונדחפו. ה-handoff הזה הוא הפעולה האחרונה.

### סטטוס git
- ענף סשן 6: `claude/hopeful-gates-acsuwt` (= `main` אחרי ff בסוף הסשן). commits: `63b94b9` (flow + תיקונים),
  `05d4e2c` (Lab 9), `2af0853` (תיעוד/HANDOFF), `62c6e7f` (סבב 2: `rnd::` + begin/end), ואחריו commit ה-HANDOFF.
- ענף סשן 5: `claude/confident-rubin-m1zkvc` (= `main` = `origin/main` אחרי ה-ff). הענף הישן
  `claude/hopeful-meitner-r5epiu` נשאר ברימוט על `79b5fd4` (לא נמחק; אפשר למחוק).
- אין שינויים לא-committed. `HANDOFF.md` **כן** ב-commit.
- 28 commits בסך הכול; האחרונים: (סשן 5, סבב 6) README/HANDOFF/צילומים, `3687ecb` (גרירה מפס הכותרת + pan באמצעי/Space), `7dc58f6` (CLAUDE.md), `f3b3556` (Test plan + 7 טסטים), `a803879` (Tests/Environment), `a9b64b7` (סבב UX שני), `cde70e0` (סבב UX ראשון), `0df0f47`, `98565ae` (test_sim.mjs), `79b5fd4` (HANDOFF), `c98a036` (README),
  `c928f3d` (HANDOFF), `4948f7f`, `92171ec`, `4f13ab5`, `0fa3c80`, `294cf18`, `d6e6c0a`, `bea3cc2`, `c12b5aa`,
  `c78e729`, `1c8da5e`, `a4efbfb`.

---

## 3. החלטות מרכזיות ולמה

| החלטה | למה | חלופות שנשקלו | סטטוס |
|---|---|---|---|
| הכול נכתב מאפס, אין חומר Cadence בריפו | ה-PDF "Do not distribute"; לתמיר אין קבצי מקור | לבקש את קבצי הקורס — אין | סופי |
| אימות ב-slang בלבד (pyslang 12) מול UVM 1800.2-2020 של Accellera עם `-D UVM_ENABLE_DEPRECATED_API -D UVM_NO_DPI` | אין סימולטור; מקור UVM 1.2 "נקי" לא נגיש (אתר Accellera/CDNs חסומים ע"י ה-proxy, GitHub כן) | vendoring של UVM — לא (גודל, רישיון) | סופי; `docs/appendix/unverified.md` מפרט מה חייב xrun |
| shim `common/uvm_version_compat.svh` (`YAPP_STARTING_PHASE`) | תמיכה ב-CDNS-1.1d ו-1.2 יחד | לבחור גרסה אחת | סופי |
| אתר סטטי MkDocs Material + Mermaid מ-CDN (unpkg) | בחירת תמיר; Mermaid לא ניתן ל-vendoring (CDN חסום בקונטיינר) | Docusaurus / Sphinx | סופי; Mermaid דורש אינטרנט בצפייה |
| מפת פרויקט: layout דטרמיניסטי ב-Python → SVG, JS vanilla בלי ספריות | קובץ עצמאי offline קטן (<1MB), diffs נקיים, בלי תחזוקת JS לתמיר | d3/elk/cytoscape בדפדפן | סופי |
| מודל המפה **היברידי**: pyslang מחלץ מבנה, `annotations.yaml` מוסיף הסברים/פריסה/לאבים | בחירת תמיר | הכול ידני / הכול אוטומטי | סופי |
| artefacts מיוצרים (model.json, standalone html, regmap.js, export/) **ב-commit** + CI בודק staleness (`build --check`) | Pages וקובץ offline לא תלויים ב-pyslang; CI נכשל אם שכחו `make map` | build ב-CI בלבד | סופי |
| highlighter SV ב-regex בדפדפן במקום Pygments HTML במודל | model.json ירד מ-1.6MB ל-~0.7MB | Pygments | סופי |
| מחלקה אחת לקובץ; קבצי include של הקורס נשארים | בקשת תמיר + שמות הקורס נשמרים למעבדות | לשנות גם את שמות ה-pkg | סופי |
| extern + מימוש מחוץ למחלקה **בכל הקוד** (כולל מעבדות מוקדמות) | תשובת תמיר "בכל הקוד" | רק yapp_project | סופי |
| החלפת `uvm_do*` וגם `uvm_field_*`; לשמור `uvm_info`, utils, p_sequencer, imp_decl | תשובת תמיר | רק uvm_do* | סופי |
| `yapp_project/` = מקור האמת; לאבים 7+ קומפלים ממנו (`../../../yapp_project/...`); לאבים 1–6 שומרים עותק `sv/` משלהם (מצב ביניים הוראתי) | "כאילו פרויקט שנכתב מאפס"; המעבדות נשארות snapshots | להעתיק הכול לכל מעבדה | סופי |
| DUT מפוצל **לפי ארכיטקטורה**: `yapp_router` (wiring) + `yapp_input_fsm`, `yapp_output_channel` (×3 ב-`g_ch[i].u_ch`, בתוכו `u_fifo`), `yapp_fifo`, `yapp_hbus_regs` (כל הרגיסטרים/זיכרונות/HBUS), `yapp_error_timer`; `-F yapp_router.f` | תשובת תמיר "לפי הארכיטקטורה"; שומר התנהגות | פיצול לפי פונקציה/שכבה | סופי; backdoor root `hw_top.dut.u_regs` |
| הכרעות במפרט (ב-`dut/spec.md` "Decisions"): `router_en=0` → כלום לא נספר/נשמר; פקטות drop (oversize/addr3) כן נספרות, parity נבדק, error מורם, pkt_mem/mem_size מתעדכנים; פקטת bad-parity **מועברת** | המפרט שותק; DUT, reference model ו-RAL tests עקביים | — | סופי (לשנות רק יחד ב-3 המקומות + sim.js) |
| `begin/end` סביב **כל** גוף בקרה, גם one-liner (session 6; החליף את "רק לגופים בשורה נפרדת") | תשובת תמיר | להשאיר one-liners / לפטור המתנות לשעון | סופי |
| ספריית `rnd::` (`rand_util_pkg`, static functions, `std::randomize`) במקום `$urandom`; `uvm_fatal` עם שם | תשובת תמיר (session 6) | `uvm_error`+trace / include בכל package | סופי; `randomize()` של אובייקטים נשאר |
| סימולטור = רגיסטרים **+ תעבורת פקטות** (RouterModel מחקה את ה-RTL) | תשובת תמיר | רק קובץ רגיסטרים | סופי |
| widgets גם במפה וגם בדפי התיעוד, אותו `sim.js` (inlined במפה, `extra_javascript` באתר) | תשובת תמיר | רק במפה | סופי |
| איור הפקטה **צויר מחדש כ-SVG** (gen_waves.py) ולא צילום מה-PDF | זכויות יוצרים; מצב כהה | PNG של תמיר | סופי |
| `regmap.yaml` מקור יחיד; CI משווה ל-RTL ול-RAL | מניעת drift בין איור/סימולטור/RTL/RAL | לקרוא מה-RTL ישירות | סופי |
| `sv_style.py` טקסטואלי (regex) ולא pyslang | פשוט, מהיר, בלי UVM src; slang הוא רשת הביטחון | pyslang rewriting | סופי |
| `main` תמיד fast-forward ל-feature branch | תמיר ראה `main` ריק ורוצה את הכול שם | PRs | סופי (אין PRs) |
| סימולציה חינמית ב-**Verilator 5.052** מאותם `run.f`, לצד xrun (לא במקומו) | לתמיר אין סימולטור; Verilator תומך ב-UVM 2020-3.x; אני יכול להריץ בקונטיינר | Questa Starter (רק אצל תמיר), EDA Playground, Vivado xsim | סופי (סשן 6) |
| עקיפות Verilator **ניידות** (עובדות גם ב-Xcelium); `` `ifdef VERILATOR `` רק ל-Z ב-HBUS ול-cross של Lab 10 | קוד אחד; קוד הלימוד של הקורס נשאר ב-`else` | שתי גרסאות קוד | סופי (תשובות תמיר) |
| Codespaces (`.devcontainer`, image רשמי `verilator/verilator:v5.052`) + workflow `sim` עם matrix לכל ספרייה | תמיר רץ בדפדפן בלי התקנה; CI מקביל ~3 דק' | בנייה מהמקור ב-Codespace (~20 דק') | סופי |
| UVM ל-lint ול-sim = Accellera **2020.3.1** (tag נעול) + קוד ה-DPI של Verilator (`uvm_hdl_verilator.c`) | ה-DPI של Verilator נבנה לגרסה הזו; backdoor דרך VPI | DPI של uvm-core (אין backend ל-Verilator) / `UVM_NO_DPI` (אין `+UVM_TESTNAME`) | סופי |

---

## 4. מה ניסינו ונפסל / לא עבד — **אל תחזור על זה**

**pyslang / lint**
- `driver.runFullCompilation()` → "no top-level modules". **להשתמש** בשלבים: `parseCommandLine → processOptions → parseAllSources → reportParseDiags → createCompilation → reportCompilation → reportDiagnostics` (כך `scripts/lint.py` עובד).
- slang דוחה `-q`/`--quiet`; `--suppress-warnings` לא מסתיר הכול → `-Wno-unknown-escape-code`. `-covoverwrite`, `-uvmhome`, `-access`, `-coverage`, `+plusargs` נזרקים ב-`_DROP`.
- `pyslang.SymbolKind` לא קיים → `pyslang.ast.SymbolKind`. `Subroutine.flags` זורק `ValueError` ל-65536 → try/except. `MethodFlags` כנ"ל.
- מחלקות ש-`include` בתוך `tb_top` **לא** תחת `compilationUnits` → ללכת גם על `topInstances[*].body`.
- **`sourceRange` הם offsets של בתים**, לא תווים; הכותרות מכילות UTF-8 (חצים) → תמיד
  `text.encode("utf-8")[a:b].decode()`.
- אחרי המעבר ל-extern, ה-extractor איבד גופי מתודות ו-`connect()` → ללכת דרך
  `MethodPrototypeSymbol.subroutine` (ב-extract.py: `str(k).endswith("MethodPrototype")`).

**ה-restyle החד-פעמי (סשן 3, `restyle.py` ב-scratchpad)**
- `req` קיבל טיפוס `uvm_pkg::uvm_sequence::REQ` → להשתמש בשם המחלקה הקנוני.
- עטיפת `begin/end` מיותרת אחרי `\`uvm_info(...)` → `needs_block` בודק מילת בקרה.
- מחלקות שנוצרו ממאקרו (`uvm_analysis_imp_decl`) **הרסו קבצים** (`isMacroLoc`) → לדלג עליהן.
- מתודות ש-`include` מקובץ אחר (`packet_compare.sv` בתוך `router_scoreboard`/`router_fifo_scoreboard`) → לדלג; הן נשארות in-class, לא extern. אל תנסה להפוך אותן ל-extern.
- ה-restyle יצר `extern // comment\n  virtual task f();` (הערה מועתקת) — תוקן ב-`sv_style.py` כלל 4.

**`sv_style.py` (הסשן הזה)**
- `else` אחרי `foreach` מקונן נדבק ל-foreach במקום ל-if החיצוני → רק כותרת `if` סופגת `else` (`IF_RX`). אם מוסיפים כלל חדש — לבדוק על `yapp_project/uvc/router/packet_compare.sv` ו-`channel_packet.sv` (foreach→if מקונן) ו-`yapp_coverage_seq.sv` (if רב-שורתי עם `with {…}`).
- לא לעטוף בתוך `{}` (constraints, `randomize() with`): יש מעקב עומק סוגריים מסולסלים.

**מפת הפרויקט**
- `python … build | head -2` הרג את ה-build לפני `json.dump` (SIGPIPE) → model.json ישן/שבור. **אל תעשה pipe ל-head על build.**
- `build --check` **לא כותב** קבצים — אם רואים נתונים ישנים, להריץ `build` ואז `--check`.
- `window.projectMap.scenes = () => …` דרס את ה-dict → `sceneIds()`.
- קליק על מחלקה רק סימן טקסט: `setPointerCapture` בכל pointerdown retarget-ת את ה-click → taps נפתרים ב-pointerup, capture רק אחרי drag > 3px; פורטים מתחת ל-hit-area של חצים → `elementsFromPoint` עם סדר עדיפויות (`.pm-port`, `text.more`, `.pm-regmap`).
- סדר `frames` לא דטרמיניסטי (set) → `sorted()`. כל פלט חייב להיות דטרמיניסטי אחרת `map-check` נכשל ב-CI.
- iframe `src="downloads/…"` נתן 404 מתוך `/project-map/` → `../downloads/…`.
- קישורי `../project-map/#view=…` נתנו INFO של mkdocs → `../project-map.md#…` + `validation.anchors: info`.
- חיווט DUT במפה: קשת `suspend` מזויפת בין u_ch↔u_ch (זיווג "אין מפיק" רק ב-hw_top), fan-out של clock (HIDDEN_NETS מתחת ל-hw_top), צדדים שגויים של fifo (up mapping לפי כיוון פורט), bundles דו-כיווניים ממוזגים, חיצי frame כפולים (de-dup ב-`add_stubs`) — הכול כבר מטופל ב-`model.wire_module`/`layout.add_stubs`.
- `h_root` ו-`h_hw_top` שניהם מחזיקים DUT ב-DOM; לספור פינים עם `.pm-viewport .pm-node.dut-spec g.pin` (יש גם `text.pin`).

**JS/CSS**
- `textarea` לא מקבל `value` כ-attribute → ב-`sim.js` `el()` מטפל ב-`value` כ-property.
- **ייצוא SVG**: `live.forEach((src,i) => copy[i])` מזווג לפי סדר מסמך — אסור להוסיף שום דבר ל-clone
  (bg, title) לפני המעבר; מחיקת `hit` נעשית אחרי הלולאה (רשימת `drop`).
- `pointerdown` על קופסה = גרירת קופסה; על port/pin/regmap/רקע = pan. tap נפתר ב-pointerup רק אם לא זז.
- סטייל `.pm.arrows-off .pm-edge {opacity:0}` נכנס ל-computed style → בייצוא מסירים את המחלקה זמנית.
- טקסט אנכי (`writing-mode: vertical-rl`) נשבר לעמודה שנייה בלי `white-space: nowrap`.
- פורט "same kind" (`seq_item_port` ל-pull port וגם ל-pull imp) — הצד נקבע לפי ה-type, לא לפי kind.
- בדוגמאות של ה-playground ה-parity חייב להיות נכון באמת (`11 de ad be ef 33`, לא `5a`).

**Verilator (סשן 6)**
- `UVM_NO_DPI` → `+UVM_TESTNAME` לא נקרא (רץ base_test). חובה DPI: `--vpi` + `uvm_dpi.cc` של Verilator (מ-`test_regress/t/uvm/v2020_3_1/dpi`, לא של uvm-core).
- `--public-flat-rw` על הכול → שגיאת C++ (`uvm_config_object_wrapper::clone` מתנגש). public רק ל-`yapp_hbus_regs` דרך `common/verilator/public.vlt`.
- **הערה שמתחילה ב-`// Verilator ...`** = pragma → `BADVLTPRAGMA`. לנסח אחרת ("Some solvers (Verilator 5.052)").
- includes יחסיים (`reg/x.sv`, `router_tb.sv`) נמצאים רק כש-verilator רץ מתוך ספריית ה-run.f (`cwd=d` ב-sim.py).
- FST צריך `liblz4-dev`; constraints צריכים `z3`. ה-image הרשמי חסר את שניהם → setup_sim.sh מוסיף.
- קריאה מפורשת `grandparent::method()` → dispatch וירטואלי → רקורסיה (segfault בלי פלט, הלוג ריק). לא לכתוב כך.
- `randomize() with {...}` לא משנה גודל מערך דינמי; `dist` + שוויון ב-`with` נכשל אקראית; enum coverpoint בלי bins → bins לפי טווח; `ignore_bins binsof/intersect` מתעלם; `get_coverage()` (type) מחזיר 0 — להשתמש ב-`get_inst_coverage()`.
- Lab 1 נגמר ב-"Verilator: end at" ולא ב-`$finish` (אין run_test) — sim.py מקבל את שניהם.
- `make -j` של Verilator עם UVM: ~2.5 דק' לבנייה, 4 ליבות; בלי שינוי מקור `make sim` לא בונה מחדש (<1 שנ').
- GitHub job logs דרך MCP: ה-tail מכיל רק cleanup — לקרוא את ה-artifact או להריץ מקומית.

**סביבה**
- `github.io` לא נגיש מהקונטיינר (curl 000) → לאמת deploy דרך GitHub Actions API (`mcp__github__actions_list`), לא דרך fetch.
- אין גישה לתיקיות המקומיות של תמיר (Windows) ולא ל-`C:\Users\User\.claude\commands\*` — לבקש שידביק.
- Playwright: `/opt/node-tools/node_modules/playwright` + Chromium ב-`/opt/pw-browsers`; **לא** להריץ `playwright install`.
- בקונטיינר ה-site build מנסה לטעון Mermaid/search מ-CDN ונכשל (file://) — זה לא באג.

---

## 5. קבצים חשובים

| נתיב | תפקיד | שונה בסשן 4 |
|---|---|---|
| `Makefile` | `lint`, `style`, `style-check`, `run LAB= TEST=`, `run-project TEST=`, `docs`, `serve`, `map`, `map-check`, `map-export`, `clean` | + `style`, `style-check` |
| `common/lab.mk` | Makefile משותף לכל ספריית סימולציה (`run/gui/lint/clean`), `ROOT` יחסי | — |
| `common/uvm_version_compat.svh` | shim 1.1d/1.2 | — |
| `scripts/lint.py` | elaboration של `run.f` עם pyslang; `--all`, `--quiet`; `standard_args()`, `compile_run_f()` (משמש גם את ה-extractor) | — |
| `scripts/get_uvm.sh` | מוריד UVM של Accellera ל-`scripts/uvm_src/` (gitignored) | — |
| **`scripts/sv_style.py`** | כללי הסגנון: hoist config locals, wrap bodies, delimiters, תיקון `extern //`; `--fix/--check/--diff` | **חדש** |
| `scripts/gen_waves.py` | SVG של waveforms + **`packet_structure()`** → `docs/assets/packet_structure.svg` | + figure |
| `scripts/project_map/extract.py` | pyslang → מבנה גולמי (classes, methods incl. extern prototypes, modules, ports, connects, vif) | — |
| `scripts/project_map/model.py` | מיזוג + annotations → nodes/edges/paths/files; `wire_module` לחיווט מודולים | — |
| `scripts/project_map/layout.py` | גיאומטריית הסצנות; `arrange_columns`, `size_dut_spec` (פינים, anchors, בלוק רגיסטרים), pin anchors ב-`plan_edges`, de-dup של port bundles ב-`scene_edges`; **סשן 5: `port_on_left()`, DUT `dut_tlm` עם `pins` ב-`TlmLayout.scene`** | כן (+סשן 5) |
| `scripts/project_map/annotations.yaml` | החצי הידני: summaries, labs, layout hints; **`hw_top.columns`, `hw_top.dut.style: dut_spec`, `pin_groups`** | כן |
| **`scripts/project_map/regmap.yaml`** | מפת הרגיסטרים כנתונים (registers, memories, fields, `figure_rows`) | **חדש** |
| `scripts/project_map/build.py` | בונה model.json, **regmap.js**, standalone HTML (inlines app.css/js + **sim.css/js + regmap.js**); `--check` (test_model + **`check_sim()` → test_sim.mjs**); `GENERATED` dict | כן (+סשן 5) |
| `scripts/project_map/test_model.py` | בדיקות עקביות; **+ DUT block, regmap ⇔ RTL params ⇔ RAL offsets, standalone inlines sim** | כן |
| **`scripts/project_map/test_sim.mjs`** | בדיקות התנהגות של `sim.js` (`RouterModel`, עוזרי פקטה) ב-node; רץ מ-`build --check` | **חדש (סשן 5)** |
| `scripts/project_map/export.mjs` | Playwright → `export/*.svg|png`, PDF ל-`build/` | — |
| `scripts/project_map/templates/standalone.html.j2` | שלד ה-HTML העצמאי | + sim/regmap |
| `docs/assets/project_map/app.js` | אפליקציית המפה; `drawDutSpec`, tap על `.pm-regmap`, `simKind`, `renderSim`, לשונית Simulate; **סשן 5: `orthoRoute/roundedPath/routeEdges/endpointOf` (ניתוב ב-JS), `drawDutTlm`, גרירה (`moveItem`, `applySavedLayout`, `resetLayout`), `toggleArrows/applyArrows`, `initResizers`, `showCodeAt/focusRow`, טבלאות members, תיקון `exportSvgString`** | כן (+סשן 5) |
| `docs/assets/project_map/app.css` | עיצוב; **`.dut-spec`, `.pm-regmap`** | כן |
| **`docs/assets/project_map/sim.js`** | `YappSim`: `RouterModel`, `encodePacket`, `checkPacket`, `mountRegs`, `mountPacket`, auto-mount של `.yapp-sim[data-sim]`; **סשן 5: `fieldDiagram`/`parseFields`, עורך ביטים בכרטיס HBUS, מצב על `model.__ysRegs`** | חדש (+סשן 5) |
| **`docs/assets/project_map/sim.css`** | עיצוב ה-widgets (tokens `--ys-*` נופלים ל-`--pm-*`/`--md-*`) | **חדש** |
| **`docs/assets/project_map/regmap.js`** | **מיוצר** מ-regmap.yaml — לא לערוך ידנית | **חדש** |
| `docs/assets/project_map/model.json`, `docs/downloads/yapp_project_map.html`, `docs/assets/project_map/export/` | artefacts מיוצרים ו-committed | חודשו |
| **`docs/assets/packet_structure.svg`** | איור מבנה הפקטה (מיוצר) | **חדש** |
| `docs/project-map.md` | דף המפה (iframe) + פסקת **Simulate** | כן |
| `docs/dut/spec.md` | מפרט; טבלאות רגיסטרים/זיכרונות; **הערת כתובות לא ממופות + widget `data-sim="regs"`** | כן |
| `docs/components/packet.md` | מדריך הפקטה; **איור + טבלת bytes + widget `data-sim="packet"`** | כן |
| `docs/getting-started.md` | מבנה, הרצה, **כללי הסגנון** | כן |
| **`README.md`** | דף הבית של הריפו: badges, For students (מפה, DUT, סימולטורים, מעבדות) עם 4 צילומים, Quick start, עץ מלא מוסבר, For mentors | **נכתב מחדש** |
| **`scripts/readme_shots.mjs`** | מצלם את 4 תמונות ה-README מהמפה העצמאית ומ-`site/` (Playwright); `make readme-shots` | **חדש** |
| **`docs/assets/readme/*.png`** | `map_overview`, `map_dut`, `sim_registers`, `sim_packet` (מיוצרים, ב-commit, ~1.2MB) | **חדש** |
| `docs/appendix/unverified.md` | 11 פריטים שרק xrun יכול לאמת | — |
| `mkdocs.yml` | אתר; **`extra_javascript` (regmap.js, sim.js), `extra_css` (sim.css)** | כן |
| `.github/workflows/lint.yml` | pyslang + UVM src → **style-check** → lint → map-check | כן |
| `.github/workflows/docs.yml` | mkdocs strict → GitHub Pages (על push ל-main) | — |
| `yapp_project/rtl/{yapp_router,yapp_input_fsm,yapp_output_channel,yapp_fifo,yapp_hbus_regs,yapp_error_timer}.sv`, `yapp_router.f` | ה-DUT, מודול לקובץ | style pass |
| `yapp_project/uvc/{yapp,hbus,channel,clock_and_reset,router}/` | ה-UVCs (מחלקה לקובץ, `seqs/`) | style pass; **`yapp/README.md` חדש**; כותרת `yapp_packet.sv` |
| `yapp_project/tb/` | `tb_top.sv`, `hw_top.sv`, `router_tb.sv`, `router_mcsequencer.sv`, `tests/` (+7 טסטי test plan ו-`error_pulse_checker.sv`), `mcseqs/`, `reg/`, `yapp_router_reg_pkg.sv`, `run.f`, `Makefile` | style pass; סבב 4 |
| `docs/test-plan.md` | **נוצר** מ-`build.py` (`plan:` + `tests:` ב-annotations); לא לערוך ידנית | סבב 4 |
| `yapp_project/tb/reg/yapp_regs_c.sv` | ה-RAL block עם `add_reg/add_mem` offsets — **נבדק מול regmap.yaml ב-CI** | — |
| `labs/lab01_data … lab11c_rm_sim` | snapshots; 7+ קומפלים מ-`yapp_project`; 1–6 עם `sv/` משלהם | style pass |
| `test_install/` | בדיקת התקנה | — |
| **`scripts/sim.py`** | Verilator: `compile/run/waves/regress` מ-run.f; לוגים/גלים ב-`build/sim/<dir>/` | **חדש (סשן 6)** |
| **`scripts/regress.yaml`** | ספרייה → טסטים לרגרסיה; `{test, expect: errors}` | **חדש (סשן 6)** |
| **`scripts/setup_sim.sh`** | התקנת Verilator 5.052 + UVM DPI ל-Verilator + UVM src | **חדש (סשן 6)** |
| **`common/verilator/`** | `public.vlt` (backdoor), `vl_waves.sv` (FST) | **חדש (סשן 6)** |
| **`.devcontainer/`** | Codespaces: Dockerfile + devcontainer.json | **חדש (סשן 6)** |
| **`.github/workflows/sim.yml`** | רגרסיית Verilator, matrix לכל ספרייה | **חדש (סשן 6)** |
| **`docs/appendix/verilator.md`** | איך להריץ, Codespaces, הבדלים מ-Xcelium | **חדש (סשן 6)** |
| **`common/rand_util_pkg.sv`** | ספריית `rnd::` — כל ערך אקראי שאינו שדה של אובייקט | **חדש (סשן 6, סבב 2)** |
| **`docs/components/random.md`** | מדריך ל-`rnd::` | **חדש (סשן 6, סבב 2)** |
| **`HANDOFF.md`** | המסמך הזה (ב-commit) | חדש |

קבצים שנמחקו בעבר: `router_rtl/` (עבר ל-`yapp_project/rtl/`), `<uvc>/sv/` (עברו ל-`yapp_project/uvc/`). קבצים חד-פעמיים שאינם בריפו: `restyle.py`, `split_classes.py`, `sim_test.mjs`, `shot.mjs` (scratchpad של הסשנים). `readme_shots.mjs` לעומתם **כן** בריפו.

---

## 6. ארכיטקטורה והקשר טכני

**קוד SV.** `yapp_project/tb/run.f` (ו-`labs/*/tb/run.f`) → `-incdir ../uvc/<uvc>` + `<uvc>_pkg.sv` + `<uvc>_if.sv` לכל UVC, `router_module_pkg.sv`, `yapp_router_reg_pkg.sv`, `-F ../rtl/yapp_router.f`, `hw_top.sv`, `tb_top.sv`. `tb_top` מפרסם virtual interfaces עם `*_vif_config::set(null, "*.tb.<inst>.*", "vif", hw_top.<if>)` ואז `run_test()`. `base_test` בונה `router_tb` עם `yapp` (yapp_env), `hbus` (hbus_env, masters[1], slaves[0]), `chan0..2`, `clk_rst`, `mcseqr` (virtual sequencer), `router_module` (reference + scoreboard עם exports), `yapp_rm` + `reg2hbus` (RAL, `set_hdl_path_root("hw_top.dut.u_regs")`). וריאנט Lab 9D: `tb.fifo_sb`.

**DUT.** `yapp_router` מחווט: `u_input_fsm` (IDLE→PAYLOAD→PARITY; `hdr_drop = !router_en || len>maxpktsize || addr==3`; מדווח `pkt_done/pkt_addr/pkt_len/pkt_parity_err/pkt_oversized` ו-`pkt_mem_we/addr/wdata`), `g_ch[0..2].u_ch` (`yapp_output_channel` עם `u_fifo` 16×8, handshake `data_vld`/`suspend`), `u_regs` (`yapp_hbus_regs`: כל הרגיסטרים, זיכרונות, HBUS 1-cycle write / 2-cycle read, `INJECT_ERROR` הופך ביט 3 בקריאה מ-`yapp_mem[0x2a]`), `u_error_timer` (`start = pkt_done && pkt_parity_err`, delay 1..10). מפת כתובות: ראה `scripts/project_map/regmap.yaml` (0x1000 ctrl RW reset 0x3f, 0x1001 en RW reset 0x01, 0x1004/5/6/9/a/b RO counters, 0x100d mem_size RO, 0x1010–0x104f pkt_mem RO, 0x1100–0x11ff yapp_mem RW; לא ממופה → קורא 0x00, כתיבה נבלעת). כל כתובת = בית אחד.

**צינור המפה.** `scripts/lint.py:compile_run_f` → `extract.py` (על 3 sources: `yapp_project/tb/run.f`, `labs/lab10_cov/tb/run.f`, `labs/lab09_sbd/tb/run.f`) → `model.py` (+`annotations.yaml`, סריקת לאבים, `files` = טקסט מלא של כל קובץ) → `layout.py` (39 scenes: `h:root`, `h:<node>`, `tlm:main`, `tlm:lab09d`, `uml:<group>[:full]`) → `build.py` כותב `model.json`, `regmap.js`, standalone HTML (template + app.css/js + sim.css/js + regmap.js inlined, `</` escaped). `app.js` מצייר SVG מהסצנות **ומנתב את החצים בעצמו** (`routeEdges`: endpoints מ-ports/pins/anchors/קופסאות → `orthoRoute` אורתוגונלי עם פינות מעוגלות; ה-`points` ש-Python כותב הם fallback בלבד, אבל `p0/p3` שלהם עדיין נבדקים ב-`test_model`); גרירה משנה `it.x/y` (+ports) בזיכרון ושומרת offsets ב-localStorage; הפאנל: Overview / Code / Links / **Simulate**; עמודת Source; ידיות רוחב. `sim.js` עצמאי (אין תלות ב-app.js), מקבל `RouterModel` משותף אחד לכל מפה (`this.sim`) או לכל דף (`sharedModel()`). באתר: `mkdocs.yml` טוען `regmap.js`+`sim.js`+`sim.css`, ו-`<div class="yapp-sim" data-sim="regs|packet">` ממונט אוטומטית (גם ב-`document$` של Material).

**תלויות/גרסאות.** Python 3.12; pyslang 12.0.0 (pinned ב-CI); PyYAML 6, Jinja2 3.1; mkdocs 1.6.1, mkdocs-material 9.7.7; Node 22; Playwright ב-`/opt/node-tools` (רק לייצוא/בדיקות, לא ב-CI). Xcelium אצל תמיר (CDNS-1.1d/1.2). אין משתני סביבה/סודות. Mermaid נטען מ-unpkg CDN בזמן צפייה.

**הנחות עבודה לא כתובות בקוד.**
- המודל של `sim.js` **משכפל** את התנהגות ה-RTL ביד; שינוי ב-`yapp_input_fsm.sv`/`yapp_hbus_regs.sv` מחייב עדכון `RouterModel.send/write/read` **וגם `test_sim.mjs`** (הטסט מקבע את הכללים המתועדים; הוא לא קורא את ה-RTL — רק מפת הכתובות מושווית ל-RTL).
- `test_model.py` קשיח על מספרים (10 connects ב-router_tb, 6 ב-router_module_env, 11 vif, 8 מופעים ב-hw_top, 19 פינים, 7 anchors, 11 פיני DUT ב-TLM…) — שינוי מבני דורש עדכון הציפיות.
- הניתוב ב-JS **לא עוקף מכשולים**: חץ אופקי בין שתי קופסאות רחוקות באותה שורה יעבור דרך קופסאות שביניהן (למשל vif מ-agent ל-stub של interface ב-`h:tb`). Arrows-off ברירת המחדל מסתיר את זה; פתרון אמיתי = routing עם מכשולים.
- `annotations.yaml` `lab_overrides`/`labs` ממפים קבצים ללאב "שהציג אותם"; קובץ חדש ב-`yapp_project` בלי מקבילה בלאב ייפול ב-`expect(n.get("lab"))`.
- הלאבים 1–6 הם snapshots עצמאיים; תיקון ב-`yapp_project/uvc/yapp` לא מתפשט אליהם אוטומטית (ולהפך).

---

## 7. בעיות פתוחות

**עודכן בסשן 6: הכול רץ ועובר ב-Verilator** (`make regress`, workflow `sim`). מה שנשאר ל-Xcelium:
four-state (Z ב-HBUS, X לפני reset), תאימות UVM 1.1d, מספרי coverage של IMC, מרווחי race — ראה
`docs/appendix/unverified.md` ("Verification status"). הטקסט הבא הוא ההיסטוריה של סשן 5:
**(היסטוריה) אף פעם לא רץ בסימולטור.** כל הקוד (DUT, UVCs, RAL, 240 קבצים אחרי style pass)
אומת ב-slang בלבד. ראה `docs/appendix/unverified.md` (11 פריטים: back-pressure, channel handshake,
HBUS read timing, reset ב-t=0, error pulse, backdoor paths `hw_top.dut.u_regs.*`, reset seq על
counters לא volatile, mem walk 511/255, תאימות 1.1d של `set_drain_time`/`compare_field_int`/`find() with`,
coverage closure, מרווחי race של מוניטורים). **החלטה (סשן 5, 2026-10-08): לתמיר אין מכונה עם Xcelium ואין סימולטור אחר. הוחלט להשאיר את הקוד
לא-מאומת בינתיים ולהריץ את כל הטסטים מאוחר יותר. לא לשאול שוב על רגרסיה עד שתמיר יעלה את זה.**
אופציות שהוצגו לו אם ירצה בעתיד: Questa Intel FPGA Starter Edition (חינמי, Windows, UVM מלא; ידרוש
flow של vlog/vsim בריפו), Verilator בקונטיינר (תמיכת UVM חלקית), EDA Playground (web, מוגבל).

**חוב טכני / נדחה.**
- `hbus_slave_agent` הוא placeholder (ה-router הוא ה-slave היחיד).
- Mermaid מ-CDN — האתר offline מאבד דיאגרמות (המפה והסימולטורים כן עובדים offline).
- `restyle.py` לא בריפו — אם תמיר ירצה לשחזר את ההמרה על קוד חדש, אין כלי; `sv_style.py` מכסה רק את 4 הכללים שלו.
- ~~בפאנל הצר של המפה (360px) טבלת הרגיסטרים ב-"compact"~~ — הפאנל ניתן להרחבה (סשן 5); הדיאגרמה בשורת-משנה.
- תוויות של חצים (label) מונחות באמצע הקטע הארוך ביותר ויכולות לנחות על קופסה; בסצנות צפופות הן ממילא מוסתרות עד hover.
- עקיפת מכשולים (סשן 5, פריט 5) מכסה רק חץ בין שתי קופסאות שפונות זו לזו (Z או קו ישר) ורק מעקף אחד מעל/מתחת; מסלולי U/L וחצים אנכיים עדיין יכולים לחתוך קופסאות (ב-`h:tb` עם Arrows דלוק). ב-`h:hw_top` ה-backdoor של yapp_rm עובר בין clk_rst_if ל-clkgen.
- הסרגל נשבר לשתי שורות ברוחב 1600px בתצוגת TLM (כותרת ארוכה + 3 כפתורי ניווט); ב-1900+ שורה אחת.
- ה-packet playground מציג `maxpktsize`/`router_en` מהמודל המשותף — אחרי שינוי ברגיסטרים הוא מתעדכן דרך `model.on`, אבל שני widgets על אותו דף מתרנדרים מחדש כולם בכל שינוי (עדיין מהיר).
- ~~`test_model.py` לא בודק את `sim.js` עצמו~~ — **בוצע בסשן 5**: `test_sim.mjs` רץ ב-`map-check` כשיש node.
  מה שעדיין לא נבדק אוטומטית: ה-widgets עצמם (DOM) — רק דרך `readme_shots.mjs`/בדיקה ידנית.
- `CLAUDE.md` קצר בשורש (סשן 5): מפנה ל-HANDOFF.md ומחזיק את כללי הצ'אט הקבועים של תמיר (עברית, RTL).
- צילומי ה-README לא נבדקים ב-CI (כמו ה-exports): אחרי שינוי בממשק של המפה/הסימולטורים להריץ `make readme-shots` ולעשות commit לתמונות. התמונות תלויות ב-`site/` בנוי, לכן ה-target תלוי ב-`docs`.
- ב-README יש badge מ-shields.io (קישורים סטטיים לאתר/למפה) — תלות חיצונית קוסמטית בלבד.

**שאלות שעדיין לא נענו / החלטות של תמיר.**
- תוצאות הרגרסיה ב-xrun ומה לתקן.
- האם לרצות שהלאבים 1–6 יצביעו גם הם ל-`yapp_project/uvc/yapp` (היום עותקים).
- האם רוצים `restyle`-כלי קבוע ל-uvm_do*/uvm_field_* (למקרה שסטודנטית כותבת עם מאקרו).

- **7 טסטי ה-Test plan ו-3 הסיקוונסים החדשים מעולם לא רצו** (כמו כל השאר). נקודות שדורשות סימולציה כדי לוודא:
  ה-wait loops (`wait_channels`/`wait_scoreboard`, polling עד 400–1000 מחזורים), `error_pulse_checker` (חישוב
  מחזורים `($time - last_bad) / hw_top.clock_period`), `soft` constraints ב-`yapp_pkt_seq`, `localparam`
  מערך במחלקה (`hbus_protocol_test::UNMAPPED`), `c_delay.constraint_mode(0)` ב-`channel_rx_slow_seq`.
- ה-fix ב-`yapp_if.wait_accept()` (posedge sampling) משנה את ה-driver של **כל** הלאבים (קובץ משותף) — לאמת ב-sim שהלאבים 6–7 עדיין עוברים.
- בתצוגת Test plan עם Arrows דלוק 67 חיצי covers חותכים כרטיסים (לכן כבוי; hover מציג רק את החיצים של הכרטיס).

**באגים ידועים:** אין. בסשן 6 נמצאו ותוקנו `set_parity` ו-`scoreboard_drop_test` (סעיף 2).
- **חוב קטן (סשן 6):** `yapp_coverage_seq` ו-`yapp_88_packets_seq` עושים `randomize()` לפני `start_item` (סטייה מכלל
  הסגנון create → start_item → randomize). לא תוקן — לא היה בבקשה.
- Codespaces עם `hostRequirements.cpus: 4` צורך את המכסה החינמית פי 2 (לתמיר: לעצור את ה-codespace בסוף).
- ה-INJECT_ERROR build של Lab 11B לא ברגרסיה (צריך `+define+INJECT_ERROR` — אפשר להוסיף כספרייה נפרדת).

---

## 8. הצעד הבא

**סדר העדיפויות שתמיר קבע בסוף סשן 5 (סבב 6).** כל פריט עומד בפני עצמו; לפני כל אחד — לשאול שאלות מנחות.

**0. (סשן 6) סימולציה — בוצע ב-Verilator.** כל טסט חדש: להוסיף ל-`scripts/regress.yaml`, להריץ
`make sim TEST=...` ואז `make regress ONLY=<dir>`; ה-workflow `sim` חייב להיות ירוק. מה שנשאר ל-Xcelium (אם תמיר
ישיג גישה): ראה `unverified.md`.

**1. (היסטורי — לתמיר אין Xcelium) הרצה ב-Xcelium ותיקונים.**
- קודם 7 טסטי ה-Test plan, כי הם הקוד החדש ביותר ובודקים את תיקון `wait_accept`:
  `make run-project TEST=backpressure_test`, `parity_error_test`, `router_filter_test`, `router_disable_test`,
  `pkt_mem_test`, `reg_bit_walk_test`, `hbus_protocol_test`. אחר כך הלאבים 6–7 (אותו driver), ואז הכול:
  `reg_function_test`, `router_simple_mcseq_test`, `uvm_mem_walk_test`, `labs/lab09_sbd scoreboard_drop_test`, `coverage_test`.
- לבקש מתמיר `UVM Report Summary` + שגיאות קומפילציה של כל ריצה. נקודות חשודות מראש: סעיף 7 ("7 טסטי ה-Test plan
  ... מעולם לא רצו"), ו-`docs/appendix/unverified.md` (11 פריטים).
- לתקן, להריץ `make lint && make style-check && make map && make map-check && mkdocs build --strict`, commit, push, ff main, zip.
- אחרי שעובר: לסמן ב-`unverified.md` מה אומת, ולעדכן את ה-`expected` ב-`annotations.yaml` (tests:) לפי הלוגים האמיתיים.

**2. השלמת ה-Test plan.**
- לממש את ה-gap **CNT-06** (גלישת counter אחרי 255 פקטות): קודם להחליט עם תמיר מה ההתנהגות הרצויה (ה-RTL עוטף ל-0;
  המפרט שותק) ואז טסט שמשלח 256 פקטות לכתובת אחת ובודק. לממש את ה-partial **ROUTE-04**: constraint `packet_delay == 1`
  (ב-`yapp_pkt_seq` או סיקוונס חדש) + coverpoint על `packet_delay` ב-`yapp_pkt_cg`.
- לעבור עם תמיר על הטקסטים של `plan:` ו-`tests:` מול ה-PDF (רק אצלו) ולתקן ניסוחים/פריטים חסרים.
- כל שינוי: `annotations.yaml` → `make map` (מייצר גם `docs/test-plan.md`); `test_model.py` ייכשל אם טסט לא מוזכר.

**3. עוד שיפורי UX במפה (לפי מה שתמיר ימצא בשימוש).** פתוח מסעיף 7: עקיפת מכשולים מלאה לחצים (מסלולי U/L,
חצים אנכיים), מיקום תוויות, הסרגל שנשבר ב-1600px בתצוגת TLM, חיצי covers ב-Test plan כש-Arrows דלוק.
לא נבחר בסבב 5: גלגלת = גלילה (תמיר מעדיף זום בגלגלת).

**4. תוכן לאתר וללימוד** (לא נבחר כעדיפות, אבל נשאר רלוונטי): דפי הלאבים, שאלות checkpoint, הסברי UVM.

**דברים ישנים שנסגרו:** GitHub Actions ירוק (סשן 5); `test_sim.mjs` (סשן 5); בדיקת האתר החי (תמיר רואה; מהקונטיינר אין
גישה ל-github.io); שלושה סבבי UX, Test plan, גרירה (סעיף 2, פריטים 4–8).

**איך לוודא שהצעד הושלם:** `make regress` → "N of N runs passed" (או ה-workflow `sim` ירוק); `make lint` → "All 18 command file(s) passed lint"; `make style-check` →
`sv_style: OK`; `make map-check` → "project map checks: OK" בלי "STALE"; `mkdocs build --strict` → בלי
WARNING; ב-GitHub Actions שני ה-workflows ירוקים על ה-commit החדש.

---

## 9. פקודות שימושיות

```bash
# אימות מלא (מה שה-CI מריץ) — מהשורש
make lint                                   # slang על 18 run.f (מוריד UVM src בפעם הראשונה)
make style-check                            # סגנון; make style = לתקן
make map && make map-check                  # לבנות ולבדוק את המפה (חובה אחרי כל שינוי ב-.sv / app.js / sim.js / regmap.yaml)
mkdocs build --strict                       # האתר ל-site/ (gitignored)
python3 scripts/gen_waves.py                # waveforms + packet_structure.svg
make map-export                             # SVG/PNG ל-docs/assets/project_map/export/ (ל-commit), PDF ל-build/
make readme-shots                           # בונה את האתר ומצלם מחדש את 5 תמונות ה-README ל-docs/assets/readme/ (PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers בקונטיינר)

# בדיקות נקודתיות
python3 scripts/sv_style.py --check --diff path/to/file.sv
python3 scripts/lint.py labs/lab05_seq/tb/run.f
python3 -m pytest scripts/project_map/test_model.py
node scripts/project_map/test_sim.mjs       # בדיקות ה-RouterModel לבד (536 assertions, ~0.1s)

# סימולציה חינמית (Verilator; בקונטיינר: PATH של Verilator — ראה למטה)
bash scripts/setup_sim.sh                   # פעם אחת (בקונטיינר חדש: ~15 דק' בנייה; או PREFIX=...)
cd yapp_project/tb && make sim TEST=backpressure_test WAVES=1 SEED=3
make regress [SEEDS=2] [ONLY=lab09]         # מהשורש; טבלה ב-build/sim/regress.md
python3 scripts/sim.py run labs/lab07_integ/tb -t simple_test

# סימולציה (Xcelium — אם תמיר ישיג גישה)
cd yapp_project/tb && make run TEST=reg_function_test
make run-project TEST=router_simple_mcseq_test        # מהשורש
cd labs/lab07_integ/tb && make run TEST=simple_test
cd test_install && xrun -f run.f

# git (הכללים של תמיר)
git push -u origin <הענף של הסשן>          # סשן 5: claude/confident-rubin-m1zkvc
git branch -f main <הענף של הסשן> && git push origin main

# מסירה
zip -qr QcommMentoring.zip qcom-mentoring -x "qcom-mentoring/.git/*" "qcom-mentoring/site/*" "qcom-mentoring/build/*" "*/__pycache__/*" "qcom-mentoring/scripts/uvm_src/*"
# + docs/downloads/yapp_project_map.html  → SendUserFile

# debug של המפה בדפדפן (Playwright מקומי)
node -e "const pw=require('/opt/node-tools/node_modules/playwright'); ..."   # ראה sim_test.mjs בסעיף 7
# ב-console של המפה: projectMap.show("h:root"); projectMap.select("hw_top.dut"); projectMap.sim.send([0x11,0xde,0xad,0xbe,0xef,0x33]); YappSim.checkPacket([...])
```

---

## 10. הערות לסשן הבא

- **Verilator בקונטיינר חדש:** `bash scripts/setup_sim.sh` (apt + בנייה ~15 דק' ב-4 ליבות, אפשר ברקע). בסשן 6
  נבנה ב-scratchpad (`PATH=<scratchpad>/vl/inst/bin:$PATH`) — לא שורד סשן. בדיקה מהירה בלי לבנות: לדחוף ולקרוא את
  workflow `sim` (job לכל ספרייה, ~3–4 דק').
- **לפני שמתחילים:** `git fetch && git status`; לוודא ש-`main` == הענף של הסשן הקודם (סשן 5:
  `claude/confident-rubin-m1zkvc`). סשן חדש מקבל שם ענף חדש מה-system prompt — לפתוח אותו מ-`origin/main`
  ולעבוד עליו; `main` מקבל ff אחרי כל push.
- **הודעת ה-system reminder** של הסשן נותנת trailer עם session id חדש — להשתמש בו, לא בישן.
- **`make map` הוא חובה** אחרי כל שינוי שמזיז שורות ב-.sv (גם הערות!), ואחרי כל שינוי ב-`app.js/app.css/sim.js/sim.css/regmap.yaml/annotations.yaml` — אחרת `map-check` ב-CI אדום. ה-exports (`export/`) **לא** נבדקים — להריץ `make map-export` כשהתמונות משתנות.
- `build --check` לא כותב; `build` ואז `--check`. אל תעשה `| head` על ה-build.
- **צילומי ה-README** (`docs/assets/readme/`, 5 תמונות): לצלם מחדש עם `make readme-shots` אחרי כל שינוי שנראה בממשק
  (תמיר ביטל בסבב 6 את הבקשה הישנה "לא לצלם מחדש"). לבדוק את ה-PNG ב-Read לפני commit.
- אחרי שינוי ב-`app.js/app.css/sim.js/sim.css` — `make map` (ה-standalone inlines אותם, אחרת STALE) ו-`make map-export` (התמונות משתנות). בדיקה ויזואלית: סקריפט Playwright חד-פעמי ב-scratchpad (`check*.mjs` בסשן 5: צילומי מסך של סצנות, גרירה עם `page.mouse`, ה-resizer, הפאנל) ואז Read על ה-PNG.
- **טסט חדש ב-`tb/tests`** דורש ב-`annotations.yaml`: שורה ב-`classes:`, plan ב-`tests:` (stages+expected), אזכור בפריט של `plan:` (אחרת map-check: "tests not named by any item"), ו-`lab_overrides` "TP" אם הוא לא בלאב; ואז `make map` (מייצר גם `docs/test-plan.md`).
- כשמשנים התנהגות של ה-DUT: לעדכן ביחד `yapp_project/rtl`, `router_reference.sv`, הטסטים ב-`tb/tests` + `labs/lab11c`, `docs/dut/spec.md` ("Decisions"), ו-`sim.js` `RouterModel`. כשמשנים כתובת רגיסטר: `regmap.yaml`, `yapp_hbus_regs.sv` localparams, `yapp_regs_c.sv` offsets — CI ישווה.
- הלאבים 1–6 הם עותקים; `labs/lab0{3,4,5,6}*/sv/yapp_tx_agent.sv` וכו' זהים לפרויקט רק אם לא נגעו. לפני עריכה גורפת — `diff` מול `yapp_project/uvc/yapp`.
- `sv_style.py` טקסטואלי; קוד SV חדש "לא רגיל" (labels על begin, `case` כגוף של if, macros רב-שורתיים) — להריץ `--check --diff` ולקרוא לפני `--fix`. slang אחרי כל `--fix`.
- מחלקות שנוצרות ממאקרו ו-`packet_compare.sv` (include בתוך מחלקה) הן חריגים מכוונים לסגנון extern.
- המפה: ids של nodes = נתיבי מופעים (`tb.yapp.agent.monitor`), חומרה `hw_top.dut.u_regs`, מחלקות `cls:<name>`. Deep link: `#view=hierarchy|tlm|classes&node=<id>&scene=<id>&theme=dark`.
- תמיר אוהב: צילומי מסך עם סימונים כשמסבירים UI, תשובות בעברית עם מזהים באנגלית, סיכום סופי לפי סעיפים, ושנשאל שאלות מנחות (AskUserQuestion) לפני שינויים גדולים.
- ה-PDF וה-`uvm_course.md` של תמיר היו ב-`/root/.claude/uploads/...` — **לא קיימים** בקונטיינר חדש ולא בריפו (תמיר העלה את ה-PDF שוב בסשן 5 סבב 4; `pdftotext -layout` עובד עליו). אם צריך פרט מהמפרט, הוא כבר ב-`docs/dut/spec.md`; עמודי ה-DUT ב-PDF הם 5–11.
