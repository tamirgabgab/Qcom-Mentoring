# HANDOFF.md — YAPP Router UVM course (`tamirgabgab/qcom-mentoring`)

> נכתב בסוף הסשן הרביעי (2026-10-07), עודכן בסשן החמישי (2026-10-08). סשן חדש לא זוכר כלום — זה המקור היחיד להקשר.
> HEAD: ראה "סטטוס git" בסעיף 2. `main` תמיד מצביע לאותו commit כמו ענף העבודה. עץ העבודה נקי.
> CI (lint + docs) ירוק על `79b5fd4` (אומת בסשן 5 דרך GitHub Actions API). האתר: https://tamirgabgab.github.io/Qcom-Mentoring/

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
- סימולטור יעד: Cadence Xcelium (`xrun -uvmhome CDNS-1.1d`, גם CDNS-1.2 דרך shim).
- **אין סימולטור בקונטיינר.** האימות היחיד הוא slang (pyslang 12.0.0) מול מקור UVM של
  Accellera — elaboration בלבד. **הקוד מעולם לא הורץ ב-xrun.** תמיר צריך להריץ רגרסיה אצלו.
- **אסור להכניס לריפו** את ה-PDF של Cadence (`UVMA_1_2_6.secured.lab.pdf`, מסומן "Do not
  distribute") או את `uvm_course.md` (הסיכום שתמיר העלה). `.gitignore` חוסם `*.pdf`. איור מבנה
  הפקטה צויר מחדש כ-SVG שלנו במקום צילום מה-PDF — בכוונה.
- אין קבצי מקור של Cadence (UVCs "מסופקים", reg_verifier) — הכול נכתב מחדש.
- שפת האתר והקוד: אנגלית. השיחה עם תמיר: עברית.

**העדפות שהוצהרו (כללים קבועים).**
- **סגנון קוד SV** (נאכף ב-CI על ידי `scripts/sv_style.py --check`):
  - מחלקה אחת בכל קובץ; קבצי ה-"include" של הקורס (`yapp_tx_seqs.sv`, `router_test_lib.sv`,
    `router_mcseqs_lib.sv`, `yapp_router_reg_pkg.sv`) נשארים בשמם ורק עושים `include` לקבצי
    `seqs/`, `tests/`, `mcseqs/`, `reg/`.
  - פרוטוטיפים `extern` בתוך המחלקה, מימושים אחרי `endclass` כ-`function cls::name(...)`,
    תחת באנר `// <cls> -- method implementations`, ו-**delimiter `//-----…` (78 מקפים) לפני כל
    מימוש** (שורה ריקה, delimiter, המימוש).
  - **משתנים מקומיים בתחילת הפונקציה** — אף פעם לא בלוק `begin/end` עירום באמצע הגוף.
  - **כל גוף של `if/else/for/foreach/while/repeat` שנמצא בשורה נפרדת עטוף ב-`begin … end`**
    (גם ב-RTL). שורות בודדות כמו `if (x) y;` נשארות. `begin` תמיד על שורת הכותרת.
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
  `claude/confident-rubin-m1zkvc`), לדחוף, ואז **fast-forward של `main`** לאותו
  commit אחרי כל push (תמיר רוצה ש-`main` וה-Pages יישאו הכול). כל הודעת commit מסתיימת ב:
  ```
  Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_019YD6YiAr5HMbC8uqHiEF7E
  ```
  (זה ה-session id של הסשנים עד כה; סשן חדש מקבל id חדש — להשתמש במה שה-system reminder נותן.)
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
- `make lint` — כל 18 ה-`run.f` (17 מעבדות/test_install + `yapp_project/tb/run.f`) עוברים slang
  ב-0 שגיאות ו-0 אזהרות.
- `make style-check` — `sv_style: OK` (ואידמפוטנטי: `--fix` פעמיים = אין שינוי).
- `make map && make map-check` — 217 nodes, 188 edges, 39 scenes; `test_model.py` עובר
  (כולל הבדיקות החדשות: pins/regmap ב-root scene, regmap.yaml ⇔ localparams ב-RTL ⇔ offsets ב-RAL)
  **+ `test_sim.mjs` (536 assertions על `RouterModel` ועוזרי הפקטה, רץ מתוך `build --check` כשיש node)**.
- `mkdocs build --strict` — 0 אזהרות (רק INFO על anchors של deep links — צפוי).
- בדיקת דפדפן (Playwright, סקריפט חד-פעמי ב-scratchpad, לא בריפו): המפה נטענת בבהיר/כהה,
  ה-DUT מצויר עם 19 פינים ובלוק רגיסטרים, קליק על הבלוק פותח את לשונית Simulate, כתיבה דרך ה-UI
  ל-en_reg, כתיבה ל-RO נדחית, ו-10 assertions על `RouterModel` (reset, good packet, bad parity,
  addr 3, oversized, router disabled, unmapped, warm reset, checkPacket) — הכול עבר.
- CI ב-GitHub: workflow `lint` (slang + style-check + map-check) ו-`docs` (mkdocs → GitHub Pages)
  ירוקים על `79b5fd4` (נבדק בסשן 5). ה-runner של GitHub (ubuntu-latest) כולל node, ולכן `map-check`
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

### מה בתהליך ולא גמור
- כלום פתוח בקוד. כל המשימות שתמיר ביקש הושלמו ונדחפו. ה-handoff הזה הוא הפעולה האחרונה.

### סטטוס git
- ענף סשן 5: `claude/confident-rubin-m1zkvc` (= `main` = `origin/main` אחרי ה-ff). הענף הישן
  `claude/hopeful-meitner-r5epiu` נשאר ברימוט על `79b5fd4` (לא נמחק; אפשר למחוק).
- אין שינויים לא-committed. `HANDOFF.md` **כן** ב-commit.
- 20 commits בסך הכול; האחרונים: (סשן 5) test_sim.mjs + HANDOFF, `79b5fd4` (HANDOFF), `c98a036` (README),
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
| `begin/end` רק לגופים בשורה נפרדת; same-line one-liners נשארים | תשובת תמיר | לעטוף הכול | סופי |
| סימולטור = רגיסטרים **+ תעבורת פקטות** (RouterModel מחקה את ה-RTL) | תשובת תמיר | רק קובץ רגיסטרים | סופי |
| widgets גם במפה וגם בדפי התיעוד, אותו `sim.js` (inlined במפה, `extra_javascript` באתר) | תשובת תמיר | רק במפה | סופי |
| איור הפקטה **צויר מחדש כ-SVG** (gen_waves.py) ולא צילום מה-PDF | זכויות יוצרים; מצב כהה | PNG של תמיר | סופי |
| `regmap.yaml` מקור יחיד; CI משווה ל-RTL ול-RAL | מניעת drift בין איור/סימולטור/RTL/RAL | לקרוא מה-RTL ישירות | סופי |
| `sv_style.py` טקסטואלי (regex) ולא pyslang | פשוט, מהיר, בלי UVM src; slang הוא רשת הביטחון | pyslang rewriting | סופי |
| `main` תמיד fast-forward ל-feature branch | תמיר ראה `main` ריק ורוצה את הכול שם | PRs | סופי (אין PRs) |

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
| `yapp_project/tb/` | `tb_top.sv`, `hw_top.sv`, `router_tb.sv`, `router_mcsequencer.sv`, `tests/`, `mcseqs/`, `reg/`, `yapp_router_reg_pkg.sv`, `run.f`, `Makefile` | style pass |
| `yapp_project/tb/reg/yapp_regs_c.sv` | ה-RAL block עם `add_reg/add_mem` offsets — **נבדק מול regmap.yaml ב-CI** | — |
| `labs/lab01_data … lab11c_rm_sim` | snapshots; 7+ קומפלים מ-`yapp_project`; 1–6 עם `sv/` משלהם | style pass |
| `test_install/` | בדיקת התקנה | — |
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

**הכי חשוב — אף פעם לא רץ בסימולטור.** כל הקוד (DUT, UVCs, RAL, 240 קבצים אחרי style pass)
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
- תוויות של חצים (label) מונחות באמצע הקטע הארוך ביותר ויכולות לנחות על קופסה (ב-`h:tb.hbus` למשל); בסצנות צפופות הן ממילא מוסתרות עד hover.
- ה-packet playground מציג `maxpktsize`/`router_en` מהמודל המשותף — אחרי שינוי ברגיסטרים הוא מתעדכן דרך `model.on`, אבל שני widgets על אותו דף מתרנדרים מחדש כולם בכל שינוי (עדיין מהיר).
- ~~`test_model.py` לא בודק את `sim.js` עצמו~~ — **בוצע בסשן 5**: `test_sim.mjs` רץ ב-`map-check` כשיש node.
  מה שעדיין לא נבדק אוטומטית: ה-widgets עצמם (DOM) — רק דרך `readme_shots.mjs`/בדיקה ידנית.
- אין `CLAUDE.md` בריפו (רק הקובץ הזה והתיעוד).
- צילומי ה-README לא נבדקים ב-CI (כמו ה-exports): אחרי שינוי בממשק של המפה/הסימולטורים להריץ `make readme-shots` ולעשות commit לתמונות. התמונות תלויות ב-`site/` בנוי, לכן ה-target תלוי ב-`docs`.
- ב-README יש badge מ-shields.io (קישורים סטטיים לאתר/למפה) — תלות חיצונית קוסמטית בלבד.

**שאלות שעדיין לא נענו / החלטות של תמיר.**
- תוצאות הרגרסיה ב-xrun ומה לתקן.
- האם לרצות שהלאבים 1–6 יצביעו גם הם ל-`yapp_project/uvc/yapp` (היום עותקים).
- האם רוצים `restyle`-כלי קבוע ל-uvm_do*/uvm_field_* (למקרה שסטודנטית כותבת עם מאקרו).

**באגים ידועים:** אין ידועים בקוד ה-Python/JS אחרי הבדיקות של הסשן. בקוד ה-SV — לא ידוע עד שירוץ.

---

## 8. הצעד הבא

**ראשון, קונקרטי:** ~~לבדוק ב-GitHub Actions שה-workflows ירוקים~~ (בוצע בסשן 5: ירוק גם על `98565ae`).
~~לשאול את תמיר אם הריץ רגרסיה ב-xrun~~ — **נדחה לבקשת תמיר (אין סימולטור), ראה סעיף 7.** הצעד הבא
נקבע לפי מה שתמיר יבקש; אם לא יבקש כלום, לפי רשימת העדיפות למטה (3, 4). הסעיף הישן נשמר כאן להקשר:
לשאול את תמיר אם הריץ רגרסיה ב-xrun אחרי `4948f7f`
(`cd yapp_project/tb && make run TEST=reg_function_test`, `router_simple_mcseq_test`,
`reg_access_test`, `uvm_mem_walk_test`, ו-`labs/lab09_sbd` `scoreboard_drop_test`) ולבקש את
`UVM Report Summary` + שגיאות קומפילציה. אם יש שגיאות — לתקן אותן קודם לכל דבר אחר (קטנות, מקומיות),
להריץ `make lint && make style-check && make map && make map-check && mkdocs build --strict`, commit,
push, ff main, לשלוח zip.

**אחר כך, לפי עדיפות (אם תמיר לא מבקש משהו אחר):**
1. לעבור על `docs/appendix/unverified.md` מול תוצאות הסימולציה ולסמן מה אומת.
2. ~~`scripts/project_map/test_sim.mjs`~~ — **בוצע בסשן 5.**
3. לבדוק את האתר החי אחרי deploy (תמיר רואה; מהקונטיינר אין גישה ל-github.io): `dut/spec/` ו-`components/packet/` עם ה-widgets, המפה עם ה-DUT החדש.
4. ~~שיפורי UX קטנים~~ — בוצע סבב UX בסשן 5 (ראה סעיף 2). פתוח: routing עם מכשולים, מיקום תוויות.
5. לבקש מתמיר פידבק על המפה החדשה (TLM קומפקטי, Arrows כבוי כברירת מחדל, גרירה) ולתקן לפי הצורך.

**איך לוודא שהצעד הושלם:** `make lint` → "All 18 command file(s) passed lint"; `make style-check` →
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
make readme-shots                           # בונה את האתר ומצלם מחדש את 4 תמונות ה-README ל-docs/assets/readme/

# בדיקות נקודתיות
python3 scripts/sv_style.py --check --diff path/to/file.sv
python3 scripts/lint.py labs/lab05_seq/tb/run.f
python3 -m pytest scripts/project_map/test_model.py
node scripts/project_map/test_sim.mjs       # בדיקות ה-RouterModel לבד (536 assertions, ~0.1s)

# סימולציה (אצל תמיר, Xcelium)
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

- **לפני שמתחילים:** `git fetch && git status`; לוודא ש-`main` == הענף של הסשן הקודם (סשן 5:
  `claude/confident-rubin-m1zkvc`). סשן חדש מקבל שם ענף חדש מה-system prompt — לפתוח אותו מ-`origin/main`
  ולעבוד עליו; `main` מקבל ff אחרי כל push.
- **הודעת ה-system reminder** של הסשן נותנת trailer עם session id חדש — להשתמש בו, לא בישן.
- **`make map` הוא חובה** אחרי כל שינוי שמזיז שורות ב-.sv (גם הערות!), ואחרי כל שינוי ב-`app.js/app.css/sim.js/sim.css/regmap.yaml/annotations.yaml` — אחרת `map-check` ב-CI אדום. ה-exports (`export/`) **לא** נבדקים — להריץ `make map-export` כשהתמונות משתנות.
- `build --check` לא כותב; `build` ואז `--check`. אל תעשה `| head` על ה-build.
- אחרי שינוי ב-`app.js/app.css/sim.js/sim.css` — `make map` (ה-standalone inlines אותם, אחרת STALE) ו-`make map-export` (התמונות משתנות). בדיקה ויזואלית: סקריפט Playwright חד-פעמי ב-scratchpad (`check*.mjs` בסשן 5: צילומי מסך של סצנות, גרירה עם `page.mouse`, ה-resizer, הפאנל) ואז Read על ה-PNG.
- כשמשנים התנהגות של ה-DUT: לעדכן ביחד `yapp_project/rtl`, `router_reference.sv`, הטסטים ב-`tb/tests` + `labs/lab11c`, `docs/dut/spec.md` ("Decisions"), ו-`sim.js` `RouterModel`. כשמשנים כתובת רגיסטר: `regmap.yaml`, `yapp_hbus_regs.sv` localparams, `yapp_regs_c.sv` offsets — CI ישווה.
- הלאבים 1–6 הם עותקים; `labs/lab0{3,4,5,6}*/sv/yapp_tx_agent.sv` וכו' זהים לפרויקט רק אם לא נגעו. לפני עריכה גורפת — `diff` מול `yapp_project/uvc/yapp`.
- `sv_style.py` טקסטואלי; קוד SV חדש "לא רגיל" (labels על begin, `case` כגוף של if, macros רב-שורתיים) — להריץ `--check --diff` ולקרוא לפני `--fix`. slang אחרי כל `--fix`.
- מחלקות שנוצרות ממאקרו ו-`packet_compare.sv` (include בתוך מחלקה) הן חריגים מכוונים לסגנון extern.
- המפה: ids של nodes = נתיבי מופעים (`tb.yapp.agent.monitor`), חומרה `hw_top.dut.u_regs`, מחלקות `cls:<name>`. Deep link: `#view=hierarchy|tlm|classes&node=<id>&scene=<id>&theme=dark`.
- תמיר אוהב: צילומי מסך עם סימונים כשמסבירים UI, תשובות בעברית עם מזהים באנגלית, סיכום סופי לפי סעיפים, ושנשאל שאלות מנחות (AskUserQuestion) לפני שינויים גדולים.
- ה-PDF וה-`uvm_course.md` של תמיר היו ב-`/root/.claude/uploads/...` של הסשן הראשון — **לא קיימים יותר** בקונטיינר חדש ולא בריפו. אם צריך פרט מהמפרט, הוא כבר ב-`docs/dut/spec.md`.
