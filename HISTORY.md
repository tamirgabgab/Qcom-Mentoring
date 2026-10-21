# HISTORY.md — כרונולוגיה של הסשנים (הוצא מ-`HANDOFF.md` בסשן 9)

> מה נעשה בכל סשן, בסדר זמן, עם מספרי ה-commits. המצב הנוכחי, הכללים, הבעיות הפתוחות והצעד הבא נשארו ב-`HANDOFF.md`.
> סשן חדש קורא קודם את `HANDOFF.md`; לכאן באים רק כשצריך לדעת *איך* הגענו למצב מסוים.

---

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
6. **סבב 3 — השלמת ה-Test plan** (תשובות תמיר: counter **עוטף ל-0**; ROUTE-04 = מרווח 0 + מדידה ב-monitor +
   coverpoint; גם INJECT_ERROR ברגרסיה ותיקון randomize לפני start_item). התוכנית: **55 covered, 1 excluded**, 0 partial/gap.
   - **CNT-06** → `counter_wrap_test` (TP): 255 פקטות של בית אחד לכתובת 0 → `addr0_cnt_reg` 255, עוד אחת → 0, עוד → 1;
     scoreboard 257. ההחלטה ב-`docs/dut/spec.md` "Decisions". sim.js כבר עוטף (`& 0xff`).
   - **ROUTE-04** → מצאתי שה-driver **לא יכול** היה לייצר את המרווח המינימלי: ה-FSM מקבל header במחזור שאחרי ה-parity
     (0 מחזורים ריקים), אבל `send_to_dut` הוסיף `@(negedge)` לפני ה-header ו-`c_delay` 1..20 → מינימום 2 מחזורים ריקים.
     עכשיו `packet_delay` = **מספר המחזורים הריקים בדיוק**: `yapp_if` שומר `last_end` (זמן סוף הפקטה); אם ה-driver קיבל
     את הפקטה הבאה באותו time step הוא כבר על ה-negedge הנכון, ו-0 → header מיד. (כל פקטה רנדומלית קצרה במחזור אחד ממה
     שהייתה.) `collect_packets` מחזיר `idle_cycles`; ה-monitor: `last_gap`, `num_gap[4]` (0/1/2/3+; לא סופר את הפקטה
     הראשונה אחרי reset), `yapp_gap_cg` (נפרד מ-`yapp_pkt_cg` כדי לא לשנות את ה-% של Lab 10). `yapp_gap_seq` (TP;
     מכבה `c_delay`; פערים 3, ואז 1,2,3,0...; `planned_gap` בלי הפקטה הראשונה) + `back_to_back_test` (TP; משווה
     `num_gap` ל-`planned_gap`, gap coverage 100%, scoreboard 24).
   - **INJECT_ERROR**: מפתח `"<dir> +define+NAME"` ב-regress.yaml → build נפרד `build/sim/<dir>__NAME/`; `sim.py -D NAME`,
     `make sim DEFINES=INJECT_ERROR`. `uvm_mem_walk_test` עם ה-define: UVM_ERROR אחד על `yapp_mem[42]` = PASS (expect errors).
     `--only` עם מפתח מדויק בוחר רק אותו (ה-matrix ב-CI לא מריץ פעמיים).
   - `yapp_coverage_seq` / `yapp_88_packets_seq`: create → start_item → randomize → finish_item.
   - תיעוד: driver.md (פסקת "The gap between packets"), monitor.md, lab11b.md, verilator.md, unverified.md, spec.md, test-plan (נוצר).
   - אימות: slang 18/18, style OK, map-check OK, mkdocs strict OK, **`make regress SEEDS=2`: 156/156 PASS** (counter_wrap 255→0→1,
     back_to_back: 5/6/6/6 כמתוכנן, INJECT_ERROR: שגיאה אחת על `yapp_mem[42]`, coverage_test עדיין 100%). commit `77bae40`.
7. **סבב 4 — UX במפה** (תמיר בחר מתוך 10 הצעות את 1, 2, 3, 6, 10; רק `app.js`/`app.css`, בלי שינוי במודל):
   - **עמודת Source מתקפלת**: כשאין קובץ להציג (כלום לא נבחר, חץ נבחר, או העמודה כבויה) היא פס של 30px עם
     "Source" אנכי (`.pm.code-collapsed`); נפתחת לבד (מעבר 0.18s) כשבוחרים קופסה עם קובץ; ה-× מכבה (פס "Source ▸",
     לחיצה מדליקה). `afterResize()` מחליף את `fit()` אחרי שינוי רוחב: שומר את הפריט הנבחר בתוך הקנבס (`ensureVisible`)
     במקום Fit מחדש, ובלי בחירה — Fit. `code-hidden` = העדפה כבויה; `code-collapsed` = מצויר כפס.
   - **Legend** = `<details>` סגור כברירת מחדל (מצב ב-localStorage `pm-legend`), פינה שמאלית-תחתונה. **שורת סטטוס**
     (`footer.pm-statusbar`, מתחת ל-`.pm-body`): רמזי התצוגה משמאל, `flash()` ("link copied") באמצע, ומימין
     `.pm-statusbar-path` — המסלול המלא של הפריט הנבחר (`tb_top › uvm_test_top › tb › … › driver : type`), כל צעד
     לחיץ (`gotoNode`). שים לב: `.pm-status` הוא כבר ה-chip של סטטוס בתוכנית, לכן השם `pm-statusbar`.
   - **Fit בשני מצבים** (`fit(mode)`, `fitNext()`, `FIT_MIN_K = 0.5`): "width" (ברירת מחדל ב-`show()`; ממלא רוחב, לא
     מתחת ל-0.5, מיושר למעלה) ו-"all" (הישן). הכפתור מציג את הפעולה הבאה ("Fit all"/"Fit width"), או "Fit" כשהתמונה
     נכנסת בשני המצבים. `f` = `fitNext()`; resize = `fit()` במצב הנוכחי. ב-1600 ה-TLM עדיין נכנס כולו (k=0.525).
   - **חיפוש**: במקום datalist — `ul.pm-search-results` (`searchHits` מדורג: שם מדויק/מתחיל/מכיל → type → id/file →
     summary; מופעים לפני מחלקות), כל שורה: שם : type, המסלול (`placeOf`) ותצוגה (`viewOf`); ↑/↓/Enter/Esc. **רשימת
     הפריטים בפאנל** (`renderItemList`): קיבוץ לפי הורה (hierarchy/tlm/env), package (classes) או Features/Tests
     (plan), `: type` באפור, summary, ותיבת סינון; לחיצה = `select` (בלי לעבור סצנה).
   - **לשוניות package** (`.pm-subbar`, שורה שנייה מתחת לסרגל, רק ב-Classes): All classes + 7 packages עם מספר
     המחלקות; מחליפות את ה-`<select>` (`showGroup` נשאר). `readme_shots.mjs` משתמש ב-`toggleCode(false/true)`
     במקום להוסיף `code-hidden`.
   - אימות: סקריפט Playwright זמני (scratchpad `ux/check.mjs`, 33 בדיקות ב-1600 וב-1280, בלי שגיאות console),
     map-check, mkdocs strict, `make readme-shots` (5 תמונות חודשו). תיעוד: project-map.md, README.
8. **סבב 5 — UX במפה, המשך** (תמיר: 5, 7 זול, 8, 4):
   - **רמת פירוט לפי זום** (`LOD_FAR_K = 0.45`): `applyVp` מחליף את `.pm.lod-far` על ה-root כשחוצים את הסף;
     ב-far מוסתרים sub/kind/role/purpose/members/טקסט chips/ports/תוויות חצים/פינים/regmap, והשם מצויר בגודל
     `data-far` ש-`tagFar()` מחשב לכל קופסה ברנדר (14..24px לפי רוחב ואורך השם; containers עד 20). `applyLod`
     רץ גם בסוף `render()` (אלמנטים חדשים) ו-`exportSvgString` מבטל אותו זמנית (הייצוא תמיד מפורט).
   - **חצים ב-Test plan** (`.pm[data-view="plan"]:not(.arrows-off)`): כש-Arrows דלוק החצים ב-opacity .3 ודקים;
     hover/path/selected מלאים; עם בחירה (`.pm.has-sel`, מ-`select()`) החצים שאינם `path` נעלמים לגמרי. ה-dim/path
     מגיעים מ-`markIncident` הקיים.
   - **מטריצת כיסוי** ב-`docs/test-plan.md` (נוצר): `render_matrix_html()` ב-build.py — טבלת HTML (`table.mx`,
     `markdown="0"`), שורה לפריט (קובצו לפי feature group), עמודה לטסט (סדר הקורס מסצנת plan), נקודה בצבע הסטטוס,
     עמודת "tests" ושורת "items per test". CSS ב-`docs/assets/extra.css` (כותרות אנכיות, hover). קישור "Coverage
     matrix ↗" בפאנל של תצוגת Test plan (`docUrl("test-plan.md") + "#coverage-matrix"`).
   - **מיני-מפה** (`.pm-minimap`, פינה ימנית-תחתונה של הקנבס): `renderMinimap(s)` מצייר rects של frames/items
     ב-viewBox של הסצנה (180×130 מקס'), `updateMinimap()` מ-`applyVp` מעדכן את מלבן ה-viewport ומציג רק כשהתמונה
     גדולה מהקנבס (`_cw/_ch` נשמרים ב-`fit`/`afterResize`); לחיצה/גרירה = pan למרכז. `readme_shots.mjs` מסתיר
     גם אותה. אימות: scratchpad `ux/check2.mjs` (16 בדיקות) + `check.mjs` (33) עוברים; map-check, mkdocs strict.

**סשן 7 (2026-10-12) — לוגים קריאים, tracer, דוח רגרסיה (ענף `claude/confident-rubin-m1zkvc` שוב):**
1. תמיר ביקש: רגרסיה + איגוד כל הלוגים בקובץ עם שם טסט + seed; הדפסות `uvm_info` שמתארות את מהלך הטסט ואת פעולות
   כל הרכיבים (ואפילו הארכיטקטורה); סקריפט שמחלץ מהלוג טרנזקציות ואירועי DUT; גלים ל-GTKWave ותמונות. שאלות מנחות —
   תשובותיו: **הפרויקט בלבד** (לא הלאבים), **3 seeds**, **שורה לאירוע ב-UVM_MEDIUM + פקטה מלאה רק ב-UVM_HIGH**,
   **FST + ציר זמן + תמונות אוטומטיות**. הנחה שלי (לא נשאל): הלוגים לא נכנסים לריפו, רק ל-`build/` ול-zip.
2. **`yapp_project/tb/yapp_router_tracer.sv`** (חדש): מודול testbench שנקשר ל-DUT עם `bind` (המודול `yapp_router_tracer_bind`
   באותו קובץ, רשום ב-`run.f` אחרי `tb_top.sv`; ה-RTL לא נגעו). מדפיס `[DUT]` ב-posedge עם הערכים שה-DUT דוגם: `RESET`,
   `IN pkt #n header: addr len -> channel X | DROP (reason)`, `IN pkt #n complete: … parity=ok|BAD forwarded|dropped, bytes/cycles/held`,
   `SUSPEND asserted: FIFO x full, byte 0x.. held` / `released after N cycle(s)`, `OUT chX pkt #n start/done`, `ERROR pulse, N cycle(s)
   after the bad-parity packet` (ב-`always @(posedge error)` — תואם ל-`error_pulse_checker`), `CONFIG router_en/maxpktsize`; ב-UVM_HIGH
   גם `HBUS write/read` עם שם הרגיסטר ו-`FIFO x full/has room`. עם `+trace_csv=<file>` כותב שורה לכל negedge (ערכי הפורטים
   + מצב ה-FSM דרך הפורט `fsm_state(u_input_fsm.state)`). **סבב 3:** סיגנל `in_phase` (enum IDLE/HEADER/PAYLOAD/PARITY)
   לצופה הגלים — סוג הבית שעל `in_data`, מתחלף בירידה (`bus_state <= fsm_state` ב-negedge + always_comb), כך ש-HEADER מחזור
   אחד בדיוק; עמודת `phase` ב-CSV ושורת `in_phase` בתמונות. תמיר שאל "למה אין header בגלים": ה-FSM מקבל את ה-header ב-IDLE —
   מצב HEADER אמיתי היה מוסיף מחזור לפקטה ומשנה את הפרוטוקול, לכן לא נגעתי ב-RTL. מלכודות Verilator שנתקלתי בהן: `cond ? "ok" : "BAD"` מרופד ל-"\0ok"
   (→ if/else למשתנה string), ו-`$fdisplay(fd, {"a","b"})` מדפיס מספר (→ literal אחד).
3. **הדפסות ב-UVCs** (שורה אחת, פורמט קבוע, UVM_MEDIUM; ה-`sprint()` עבר ל-UVM_HIGH): driver `TX pkt #n: addr len parity delay`
   + `TX pkt #n accepted by the DUT`; monitor `RX pkt #n on the input: … gap=`; channel driver `chX: packet consumed`; channel monitor
   `chX RX pkt #n: …`; hbus monitor `Collected …` (MEDIUM במקום LOW); scoreboard `chX pkt matched: addr len (k matched so far)`;
   reference `Packet forwarded: … -> channel X` ו-drops עם addr/len. `parity_text()` חדש ב-`yapp_packet`/`channel_packet`.
   **`+UVM_VERBOSITY=UVM_MEDIUM` בכל run.f** (פרויקט + לאבים 3–11C; lab02 נשאר HIGH). דפי לאבים 3/4/6 עודכנו ("TX pkt" במקום
   "Packet is tables").
4. **טסטים:** `base_test` — `start_of_simulation_phase` מדפיס `=== <test>  seed <n> ===` (`+SEED` מ-sim.py או `+SVSEED`),
   `stage(string)` מדפיס `[TEST] STAGE: …`, `final_phase` מדפיס `=== … PASSED|FAILED (e UVM_ERROR, f UVM_FATAL) ===`. כל 16
   הטסטים קוראים `stage()` בכל שלב (reg_access/reg_bit_walk: stage לכל רגיסטר במקום ה-`---` headers).
5. **`scripts/sim.py`:** `+SEED=<n>` לכל ריצה; `waves/<test>_s<seed>.fst` + `trace/<test>_s<seed>.csv` (עם `--waves`);
   `regress --waves`; Makefile `make regress WAVES=1`, `make sim-report [ONLY=]`.
6. **`scripts/sim_report.py`** (חדש): מפרסר לוגים (regex של פורמט UVM + `ROUTER DROPS PACKET`), מסווג who לפי נתיב הרכיב,
   סופר (packets sent/in/fwd/drop+reasons/out per channel/matched/suspends/pulses/hbus), כותב `timeline.md` (verdict, summary,
   stages, pictures, כל האירועים) + `timeline.csv`, מעתיק לוג/FST/CSV, ומצייר SVG עם `gen_waves.render()` (קיבל `out_dir`,
   `title`, `quiet`, רוחב לפי notes) מחלונות של `signals.csv` סביב האירוע הראשון מכל סוג: reset, first_packet_in, first_packet_out,
   first_suspend, first_error_pulse, first_hbus_write/read. `index.md` + `all_logs.log` + `--zip`.
7. **המפה:** `extract.py` מדלג על מופעי `bind` (`_from_bind` דרך `BindDirectiveSyntax` בשרשרת ה-syntax) — אחרת ה-tracer הופיע
   כתת-מודול של ה-DUT ו-`test_model.py` נכשל. map-check OK (250 nodes, 297 edges).
8. **תיעוד:** `docs/appendix/sim-report.md` (חדש, ב-nav: "Logs, timelines and waves") עם דוגמת לוג, טבלת השורות, מבנה הדוח,
   טבלת התמונות, שתי תמונות לדוגמה מ-`docs/assets/sim/` (הועתקו מהדוח של backpressure_test s1), פתיחת FST ב-GTKWave/Surfer/VaporView.
9. **גלים אצל תמיר (סבב 3):** FSDB לא אפשרי (קנייני של Synopsys, דורש VCS/Verdi). מה שהוריד בהתחלה היה קוד המקור של GTKWave;
   הוא עובד עם **Surfer בדפדפן** (app.surfer-project.org, גרירת ה-FST). הדרכתי אותו: Scopes/Variables, `+` = קבוצה, Name → Global,
   Format → Clock (קווים על עליות, Settings → Clock highlighting), Hex. אם ישאל על GTKWave מותקן: MSYS2 `pacman -S
   mingw-w64-ucrt-x86_64-gtkwave`. הוצע ועדיין לא נבחר: קובצי `.gtkw` מוכנים לכל טסט, `.surfer/config.toml` בריפו.
10. **סבב 4: layout מוכן ל-Surfer** (בקשת תמיר: "קונפיגורציה נוחה עם כל הסיגנלים, כניסות, יציאות, HBUS").
   `scripts/surfer_layout.py` (`LAYOUT` בראש הקובץ) כותב את `yapp_project/tb/yapp_router.sucl`: 10 קבוצות צבעוניות
   (Clock/reset, Input port + `in_phase`, Input FSM, FIFO fill = `u_fifo.count` ×3 בשם `chN count`, Channel 0/1/2, Error,
   HBUS, Config/counters), hex על buses, Clock על השעון, שמות Global (בקשת תמיר; = Settings → Variable names → Global), clock highlight Line. **מתכון הפקודות** (נבדק בקוד
   libsurfer): `variable_add` מוסיף אחרי ה-item ה-focused ומעביר אליו focus רק אם יש focus; `group_marked` עוטף את ה-focused
   ומפקס את הקבוצה; קבוצה פתוחה ב-focus → `variable_add` נכנס כילד ראשון. לכן כל קבוצה מתחילה מהסיגנל **האחרון** שלה
   (`item_unfocus` → `variable_add` → `item_focus <row>`), עוטפים, `item_rename`, ואז שאר הסיגנלים לפי הסדר. אינדקס
   `item_focus` = מספר השורה ב-hex באותיות a..p. **אומת** עם Surfer 0.7 שנבנה מהמקור (`cargo build --release -p surfer`
   מ-gitlab, ~18 דק'; app.surfer-project.org חסום ב-proxy, gitlab ו-crates פתוחים; צריך `apt install libxkbcommon-x11-0`) תחת
   Xvfb + `import` לצילום: backpressure/parity_error/hbus_protocol, 0 שגיאות, גם `load_url` + `run_command_file_from_url`.
   **קישור בלחיצה אחת:** ל-web app יש `?load_url=<fst>&startup_commands=<cmds>`; `surfer_layout.surfer_url()` בונה אותו
   מ-raw.githubusercontent (הריפו public, CORS `*`). `sim_report.py` מוסיף עמודת **Waves** ל-`index.md` ושורה ב-`timeline.md`
   רק כשהדוח נכתב לתוך הריפו (לא תחת `build/`). תיעוד: סעיף "A ready signal layout for Surfer" ב-`sim-report.md` +
   `docs/assets/sim/surfer_layout.png` (צילום Surfer, backpressure s1, 245–455ns).
   תמיר גרר את ה-`.sucl` לחלון ← `UnknownFileFormat` (קובץ שנגרר נקרא כגלים); ההסבר: File → Run command file.
   לבקשתו נוסף גם ה-state שלו `yapp_project/tb/yapp_lab.surf.ron`, ו**נמחק** אחרי ש-`yapp_router.surf.ron` נוסף (תמיר
   טען בטעות את שלו במקום את שלי; "תמחק כדי למנוע בלבול"). `yapp_router.surf.ron` הוא ה-state היחיד בריפו.
11. **זיכרונות ב-waves:** סשן אחר (`claude/hopeful-gates-acsuwt`) הוסיף `--trace-max-array 256` ב-`sim.py` (Verilator
   מדלג על מערכים מעל 32 איברים) ודחף ל-main; מוזג לענף (`c78971d`). קובצי ה-FST ב-`yapp_project/regression/` הוקלטו
   לפני כן, ולכן תמיר לא ראה את `yapp_pkt_mem`/`yapp_mem`. הרגרסיה הורצה מחדש (48/48), הדוח נבנה מחדש, ובכל 48 ה-FST
   יש 320 משתני זיכרון (scope `yapp_pkt_mem` עם `[0]..[63]`, `yapp_mem` עם `[0]..[255]`). ה-layout קיבל קבוצה מקופלת
   "Packet memory" (`scope_add_as_group` + `group_fold_recursive`), ולבקשת תמיר גם "Scratch memory" (`yapp_mem`, 256 B);
   שתיהן ב-`MEMORIES` ב-`surfer_layout.py`. קבוצה מקופלת = שורה נראית אחת (כך `item_focus` סופר).
12. **הגדרות תצוגה (בקשת תמיר):** Variable names → Global (`variable_force_name_type Global` = אותו Message כמו התפריט),
   Hierarchy → Tree (`preference_set_hierarchy_style Tree`). ל-Focus highlight → Background, Show hierarchy icons ו-Fill
   high values (off) **אין פקודה**, וה-web app לא שומר הגדרות בין ביקורים; הם נשמרים רק ב-state. לכן
   `yapp_project/tb/yapp_router.surf.ron` = state ש-Surfer 0.7 שמר אחרי הרצת ה-`.sucl`, ו-`surfer_layout.py --state <file>`
   מכניס `STATE_SETTINGS` ומאפס את `source` ל-`DragAndDrop(None)`. נבדק: `surfer <fst אחר> -s yapp_router.surf.ron` →
   עץ hierarchy עם אייקונים, בלי מילוי, הגלים של הקובץ הפתוח עם הקבוצות.
   `verilator.md`, README (quick start, layout, bullet "Logs that read like a story", verification status) עודכנו.
13. **טסטים אקראיים (סבב 5, בקשת תמיר "לרנדם יותר את הטסטים, מקרי קצה").** שאלות מנחות → תשובותיו: **מודל מלא ברפרנס**;
   מספר פקטות אקראי 10..100, קונפיגורציה אקראית, back-pressure אקראי (receiver שעוצר **בין** פקטות, לא באמצע), parity
   ושגיאות; **בלי** reset באמצע טסט ובלי suspend באמצע פקטה (להמשך); seeds: **4 למכוונים, 8 לאקראיים**; באג ה-error timer
   (פקטה bad שנייה לפני הפולס של הראשונה מוחקת אותו) → **תיקון ב-RTL**. תוכנית: `/root/.claude/plans/swift-conjuring-stearns.md`.
   - **RTL:** `yapp_error_timer.sv` — `sched[10:1]` (ביט k = פולס בעוד k מחזורים), `error <= sched[1]`, פקטה חדשה תופסת את
     הסלוט הפנוי הראשון מ-`want` (עטיפה בתוך 1..10). פקטה ≥3 מחזורים ⇒ לכל היותר 3 פולסים ממתינים ⇒ תמיד יש סלוט. פקטה
     בודדת: אותו תזמון בדיוק (נבדק מול ה-RTL הישן, parity_error_test 4 seeds). spec Decisions + rtl.md עודכנו.
   - **בדיקה:** `router_reference` = מודל מלא (ctrl/en, 6 מונים עם enable חי ו-wrap, mem_size, pkt_mem עם זנב ישן, yapp_mem,
     valid-bits לזיכרונות שלא אופסו) ובודק **כל קריאת HBUS** כש-`check_reads` (config_db #(bit), ברירת מחדל 0 כי טסטי RAL עושים
     poke). covergroup `ref_cg` + ספירה ידנית לפירוט (Verilator לא תומך ב-`get_inst_coverage()` של coverpoint בודד).
     `error_pulse_checker`: תור פולסים חייבים, דגימה ב-negedge, router_en מה-reference. `router_scoreboard::check_phase`: שגיאה
     על פקטות שנשארו בתור, תחת knob `check_empty` (config_db #(bit)) ש-`base_test` של הפרויקט מדליק; במעבדות 10/11b הוא
     כבוי: `router_simple_mcseq_test` שלהן נגמר 200ns אחרי הפקטה האחרונה (drain של הקורס) ופקטה אחת עוד יוצאת — נמצא בהרצה
     הראשונה. ה-tracer סופר פולסים חופפים (`bad_age[$]`).
   - **סטימולוס:** `yapp_random_burst_seq` (knobs: addr3/bad/short/long/boundary/gap0/gap_short pct; ערכים מ-`rnd::` ו-`==`),
     `channel_rx_random_seq` (`channel_rx_profile_e`: FAST/NORMAL/SLOW/STALLY), `router_random_mcseq` על `tb.mcseqr` (סוף
     סוף בשימוש): N פקטות ב-bursts, קונפיגורציה אקראית לפני כל burst, קריאות אקראיות, storms, קריאת הכול בסוף; שורות
     `[TEST] STAGE` לכל burst. Verilator: מחרוזות ב-`?:` מתרפדות — if/else.
   - **טסטים:** `random_test` (בסיס: `configure_scenario()`, `pick_profile()`, default_sequence **אובייקט** לכל ערוץ),
     `random_config_test`, `random_backpressure_test`, `random_parity_test`. `regress.yaml`: bench יכול להיות
     `{seeds: N, tests: [...]}`, טסט `{test: x, seeds: N}`; `SEEDS=` דורס הכול; `yapp_project/tb` = 4/8 → 96 ריצות. CI
     (`sim.yml`) כבר לא מעביר `--seeds 2` אלא את ה-seeds של הקובץ.
   - **אימות מוטציות:** ה-timer הישן → `random_parity_test` נכשל ("no error pulse within 10 cycles"); מונה addr2 שבור →
     `random_test` נכשל ("HBUS read 0x100b returned 0x03, the model expects 0x04"). הוחזר.
   - **תקלה שתמיר מצא אחרי הסבב:** ה-layout של Surfer עדיין ביקש `u_error_timer.err_timer`, שהתיקון ב-RTL הסיר → ב-FST
     החדשים שורה חסרה, והקבוצות שאחריה (Error, HBUS, Config, הזיכרונות) התפרקו גם ב-`.sucl` וגם ב-`.surf.ron`. הוחלף ב-
     `u_error_timer.sched` ("pulses owed", Binary); ה-`.surf.ron` נוצר מחדש; `surfer_layout.py --check <fst>` (pywellen) ו-
     `sim_report.py` בודק את זה אוטומטית כשהדוח נכתב לריפו. **כל שינוי שם של סיגנל ב-RTL/TB → לעדכן `LAYOUT`.**
   - תיעוד: `docs/components/random-tests.md` (חדש, nav "Random tests"), Test plan: קבוצה חדשה **RND-01..04** + הטסטים
     האקראיים תחת IN-03/04, OUT-02/05, DROP-01..04, CNT-01..05, MEM-01/03, REG-05/06, PKT-02/03/05, ROUTE-03.

14. **Coverage (סשן 8, בקשת תמיר "להתמקד ב-coverage, איך רואים תוצאות").** שאלות מנחות → תשובותיו: **functional בלבד**
   (בלי line/toggle); תצוגה: **עמוד coverage בדוח + HTML (lcov/genhtml) + אתר/מפה**; **תמיד ברגרסיה**; **קודם לראות,
   אחר כך להוסיף coverpoints**. בנוסף ביקש: **כל covergroup בקובץ נפרד מחוץ לאלמנט**, ובמפה האלמנט במקום הנכון.
   - **Refactor:** `yapp_pkt_coverage.sv` / `yapp_gap_coverage.sv` (`uvm_subscriber #(yapp_packet)`, נבנים תמיד ב-`yapp_tx_agent`
     ומחוברים ל-`monitor.item_collected_port`); ה-monitor כותב את ה-gap שמדד ל-`pkt.packet_delay` (-1 לפקטה הראשונה) ושומר
     `num_gap[]`. `router_decision.sv` (pkt, maxpktsize, en_reg, `router_reason_e`) + `router_coverage.sv` (`router_cfg_cg` =
     `ref_cg` לשעבר, אותם bins + ה-`hits_*`); `router_reference` מפרסם על `decision_out` לכל פקטה כש-enabled.
     `back_to_back_test` קורא `tb.yapp.agent.gap_cov.yapp_gap_cg`. **נבדק:** האחוזים זהים לפני/אחרי (lab10 coverage_test
     100/50/52.2, random_test s1 60/100/65.2, random_config_test s1 56.7/100/87.0, back_to_back_test s1 30/100/26.1).
   - **איסוף:** `sim.py` מקמפל עם `--coverage-user` (נבדק: רק bins של covergroups, `t=covergroup`), `run_one` מוסיף
     `+verilator+coverage+file+<bd>/coverage/<test>_s<seed>.dat`, `regress` מנקה את ה-`.dat` הישנים של bench ומאחד ל-`merged.dat/.info`.
     שם ה-covergroup ב-`.dat` הוא `__vlAnonCG_<name>` (בלי שם המחלקה) → `coverage_report.py` מזהה לפי `f=` (הקובץ).
   - **דוח:** `scripts/coverage_report.py` (חדש; `make coverage` מדפיס סיכום + holes) ← `sim_report.py` כותב `coverage.md`,
     `coverage.json`, `<bench>/merged.dat|info`, ו-genhtml ל-`docs/coverage/<bench>/` (לדוח המחויב; אחרת `coverage_html/`).
     genhtml: *Lines* = שורה עם bin שנפגע, *Branches* = כל bin בשורה עם כמה bins (`legal[]`, cross). נתיבים יחסיים ב-info
     מכפילים תיקיות → `write_html` הופך ל-absolute + `--prefix ROOT`. `lcov` נוסף ל-`setup_sim.sh`; CI מדפיס סיכום coverage.
   - **מפה/אתר:** kind חדש `coverage` ("Coverage collector", צהוב); `analysis_export` מרומז ל-`uvm_subscriber`;
     `model.attach_coverage()` קורא את `yapp_project/regression/coverage.json` → `renderCoverage` בפאנל (hole באדום, קליק
     מראה את השורה); `build.py` מייצר `docs/coverage-results.md` (nav "Coverage results"). `test_model`: router_module_env
     עכשיו 7 connects. **אחרי כל דוח חדש: `make map`** (אחרת map-check STALE).
   - **תוצאה:** ממוזג על 96 ריצות — `yapp_pkt_cg` 30/30, `yapp_gap_cg` 4/4, `router_cfg_cg` 23/23: **אין holes**;
     `random_parity_test` לבדו פוגע בכל 57. כלומר מודל ה-coverage הנוכחי רווי — הצעד הבא הוא coverpoints חדשים (סעיף 8).
   - תיעוד: `components/coverage.md` (איפה ה-covergroups, "Seeing the results (Verilator)"), `monitor.md`, `lab10.md`
     (הקורס שם ב-monitor, כאן subscriber), `reference-model.md`, `random-tests.md`, `sim-report.md`, `verilator.md`, README.

15. **HBUS coverage (סשן 8 סבב 2, בקשת תמיר "coverage של hbus, לקרוא ולכתוב מכל הכתובות").** תשובותיו: זיכרונות =
   **קצוות + אמצע** (לא bin לכל בית); לא ממופות = **החורים בין הרגיסטרים + 0x1050–0x10ff** (לא מחוץ לחלון); ערכים = **כל ביט
   ב-ctrl/en ב-0 וב-1, תבניות ב-yapp_mem, ערכי מונים שנקראו**; holes = **לסגור באותו סבב**.
   - **Collectors** (ב-router module UVC, כי מפת הכתובות של הראוטר; ה-HBUS UVC גנרי), כולם על `router_module_env.hbus_export`:
     `router_hbus_addr_coverage` (`hbus_addr_cg`: 9 רגיסטרים, `reg_hole[]` ×7, first/mid/last של pkt_mem / חור 0x1050–0x10ff /
     yapp_mem × read/write — 77 bins), `router_hbus_bits_coverage` (`hbus_bits_cg`: נדגם 8 פעמים לכל כתיבה ל-ctrl/en — 44),
     `router_hbus_data_coverage` (`hbus_data_cg`: yapp_mem × 0x00/0xff/0x55/0xaa/other — 17), `router_hbus_counter_coverage`
     (`hbus_counter_cg`: 6 מונים × 0 / 1..254 / 255 — 27). ב-`random_test` s1 לבדו: 40% / 98% / 29% / 56%.
   - **סגירה:** `router_hbus_sweep_mcseq` + `hbus_sweep_test` (TP, 4 seeds): כל כתובת 0x1000–0x100f עם 4 תבניות **וקריאת
     כל החלון אחרי כל כתיבה** (תופס כתיבה שנוחתת על רגיסטר אחר), walking 1/0, כתיבה לכל בית pkt_mem (RO), חור, yapp_mem×5,
     1020 פקטות 2 בתים bad parity ב-maxpktsize=1 (נזרקות) עם en 0x17/0x21/0x41/0x81 → כל מונה ל-255. `check_reads=1`;
     הטסט נכשל אם covergroup לא ב-100%. **מוטציה:** כתיבה ל-0x1002 שכותבת ל-ctrl_reg → `REF_READ ... 0x1000 returned 0x00,
     the model expects 0xaa` (הוחזר). `hbus_write`/`hbus_read`/`stage` עברו ל-`router_mcseq_base` (גם random משתמש).
     ה-sequencer/driver של HBUS ו-YAPP ב-`UVM_NONE` בטסט הזה (לוג 5.3→2 MB); הדוח המחויב 51→**83 MB** (מועמד לכיווץ).
   - Test plan: **COV-04..07** + `hbus_sweep_test` תחת REG-05, MEM-02, CNT-06; `test_model`: router_module_env = 11 connects.
   - **`docs/dut/register-map.md`** (חדש, nav "Register map"): תמיר ביקש "קובץ MD פשוט" למפת הרגיסטרים — נוצר ע"י `build.py` מ-
     `regmap.yaml` (טבלאות בלבד, נקרא ב-GitHub/VS Code), כולל קישור לסימולטור. map-check שומר שהוא עדכני.
16. **אתר הקורס אופליין (סשן 8ב, 2026-10-13, במקביל לסשן ה-coverage).** תמיר רצה את האתר אצלו כתיקייה `site`.
   - `mkdocs-offline.yml` (`INHERIT: mkdocs.yml`): `site_url: ""`, `use_directory_urls: false`, `theme.font: false`, תוסף
     `offline` של Material (אינדקס החיפוש כ-JS), `extra.polyfills: [assets/vendor/iframe-worker.js]` (אחרת התוסף מוסיף את
     ה-shim מ-unpkg — בלעדיו החיפוש לא עולה תחת file:// בלי אינטרנט), `hooks: scripts/mkdocs_offline_hooks.py`.
   - ה-hook: מעתיק `mermaid.min.js` ו-`iframe-worker.js` מ-`build/offline_cache/` ל-`assets/vendor/`; טוען את mermaid ב-`<head>`
     רק בדפים עם `class="mermaid"` (ה-bundle של Material מדלג על unpkg כש-`mermaid` כבר מוגדר); מתקן את ה-`<iframe>` הגולמי
     ב-`project-map.md` (`../downloads/` → `downloads/`), כי MkDocs לא משכתב נתיבים ב-HTML גולמי.
   - `scripts/build_offline_site.py`: `npm pack mermaid@11` / `iframe-worker@1` פעם אחת ל-cache, `mkdocs build --strict` ל-`offline/site`,
     zip ל-`build/QcomCourseSite.zip`. `.gitignore`: `!/offline/site/` (כי `site/` חסום בכל עומק).
   - **נבדק** (Playwright, `file://`, כל בקשת http(s) נחסמת): כותרת, חיפוש "scoreboard" → 10 תוצאות, ניווט ל-`labs/lab01.html`,
     תרשים mermaid ב-`uvm/big-picture.html`, המפה בתוך ה-iframe של `project-map.html`, 0 שגיאות JS. נשארות רק שתי בקשות ל-
     `api.github.com` (כוכבים/forks בכותרת) שנכשלות בשקט.
   - **תקלה אצל תמיר:** פתח את `index.html` מתוך ה-zip ב-Explorer → Windows חילץ רק את הקובץ הזה ל-Temp, בלי CSS/JS → טקסט
     גולמי. הפתרון: Extract All קודם. נכתב גם ב-README.
   - `make help` הדפיס שורות 2–21 קבועות ונחתך; עכשיו `awk` עד שורת ה-`# ---`.
   - **README → "Where to find everything"** (בקשת תמיר): טבלה בראש ה-README עם כל נקודת כניסה — אונליין (Pages) ובריפו
     (פתיחה מהדיסק): האתר, המפה (`docs/downloads/yapp_project_map.html` — הממשק כולו, קובץ עצמאי; נשאר ב-`downloads` כי הקישור
     הציבורי ותשעה מקומות תלויים בו), labs, spec + סימולטור, register map, packet playground, test plan, coverage results,
     genhtml, דוח הרגרסיה, Surfer, sim-report, verification status, CI. **כשמוסיפים דף/דוח חדש — להוסיף שורה לטבלה.**
   - בשיחה הוסברו גם (בלי שינוי קוד): `uvm_subscriber` מול פורט רגיל, ומה קורה לסשן ענן כשעוצרים או מכבים את המחשב.

17. **ביקורת + דוח רגרסיה באתר (סשן 8 סבב 3, בקשת תמיר "תסתכל על HANDOFF, האם הכול כתוב נכון, רשימת הצעות; דגש על הממשק
   האינטרנטי, דוחות הרגרסיה, דף ההיררכיה והאתר").** 3 סוכני ביקורת (אתר / דוח / מפה) → רשימת טעויות קטנות + 16 הצעות. תמיר בחר:
   ניקיון, דוח באתר (עמוד לכל טסט) + כיווץ (כל 4 האפשרויות), CI artifact בלבד (בלי בדיקת עדכניות), קישורים ותגים במפה. **לא** נבחר:
   תוכן לימודי (מסלול Verilator, glossary/FAQ, מבנה אחיד ללאבים עם "See it run", קוד התחלה), היסטוריה/trend, שכתוב HANDOFF.
   - **`sim_report.py`:** `runs.json` (date, commit, verilator, total/passed, wall; לכל ריצה: ok, verdict, sim_time, wall מהשורה
     `walltime` של Verilator, counts, summary, stages, pictures, first_error, dir/log/fst/surfer). הודעות רב-שורתיות
     (`report_phase` של reference/scoreboard) מצורפות לאירוע (` · `) — נעלמו 2 השורות הריקות בכל timeline. `TIMELINE_MAX = 1500`:
     ריצה ארוכה יותר שומרת רק test/DUT/hbus monitor/reports/warnings/errors ולכל היותר 1500 (hbus_sweep 875 KB → 100 KB). דוח
     מחויב (`committed`) לא כותב `all_logs.log`/`timeline.csv`/`signals.csv` (רק ב-`build/`), ומעתיק את תמונות seed 1 של כל טסט
     ל-`docs/assets/regression/<test>/`. `index.md`: שורת מטא-דאטה, סעיף Failures (שגיאה ראשונה), עמודות Wall + Note, בלי Bench
     כשיש bench אחד; "driver quiet (UVM_NONE)" במקום "sent 0"; `FAILED`; קישורים יחסיים אמיתיים. `--only` מקבל גם `labs/x/tb`.
   - **`build.py`:** `render_regression_md()` → `docs/regression/index.md` (מטא-דאטה, Failures, טבלה לכל טסט: seeds שעברו, sim/wall,
     bins hit) + `docs/regression/<test>.md` (seeds עם קישורי GitHub ללוג/timeline/.fst + Surfer, תוכנית הטסט, פריטי Test plan,
     סיכום/שלבים/תמונות של seed 1). `render_index_tables()` → `docs/assets/generated/index_tests.md` / `index_sequences.md`
     (snippets שמוכללים ב-`appendix/index-tables.md`; `exclude_docs` ב-mkdocs.yml). דפי regression של טסטים שנעלמו נמחקים ב-build.
     קישור הסימולטור ב-`register-map.md` יחסי (`spec.md#...`). nav: "Regression results".
   - **מפה:** `model.attach_regression()` (runs.json + coverage.json `tests[]`) → `regression` על כל test node; `renderRegression`
     בפאנל (seeds, תוצאה, זמנים, log/timeline/Surfer ↗, קישור לדף באתר ול-Test plan); תגי `4/4 ✓ seeds` (ירוק/אדום) ו-`N bins`
     (צהוב) על כרטיסי הטסטים (`drawTestCard`, מוסתרים ב-lod-far); `renderCoverage`: קישור ל-genhtml (`coverage[].html` מהמודל)
     ול-Coverage results, עמודת tests כ-`nodeLink`; `renderFeature`: קישור לדף המפרט; Overview: `GitHub ↗` ליד source; כרטיס
     העזרה: שורה כפולה הוסרה, `l`, `↑/↓`, `?`; ניגודיות התג הצהוב (`#3e2723`). `test_model`: ≥20 טסטים עם runs, דף לכל אחד, html לכל covergroup.
   - **CI (`sim.yml`):** אחרי הרגרסיה `sim_report.py --only <bench> --out build/sim/report` + `upload-artifact` `report-<i>` (תמיד);
     `coverage_report.py --md` לסיכום markdown; compile.log בכישלון.
   - **ניקיון (~30 קבצים):** README (64 פריטים/12 קבוצות, 10 טסטי TP + `hbus_sweep_test`, 7 collectors, Quick start שניתן להדבקה,
     עץ), `index.md` (5 תצוגות, מסלול Verilator, עץ), `architecture.md` (collectors בדיאגרמות + TLM עם `decision_out`/HBUS, טבלאות),
     `big-picture`, `components/index` (+Random tests), `concept-map`, `coverage.md`, `reference-model.md` (לא עוד "tiny"),
     `sequences.md` (+4), `unverified.md` (באג 3, 222/222), `getting-started` (עץ, lab.mk, sv/ ב-9A–9D, באנר, map outputs),
     `labs/index` (המבנה האמיתי), `lab09b/9c/10/11a` (Concepts, דיאגרמה ל-10), `sim-report`, `verilator`, `xrun`, `rtl`,
     `project-map.md` (4 לשוניות, Regression, collectors, 12 קבוצות), `annotations.yaml` (3 ניסוחים), `index-tables` (קבצים חדשים),
     `wave_clock_reset.svg` נמחק (לא בשימוש). **לא** אוחד האיות הבריטי/אמריקאי (מעורב; לא משנה לקוראות).

18. **סגנון קוד + Coverage במפה + עמוד coverage (סשן 8 סבב 4, 2026-10-14).** תמיר ביקש שישה כללי סגנון (ראה
   "העדפות שהוצהרו") ולשונית Coverage; אחרי שאלות מנחות בחר: הכול (yapp_project + labs + common), `m_` על כל שדה כולל
   handles/ports/vif, שמות enums חדשים, `<uvc>_defines.sv`, אכיפה מלאה ב-`sv_style.py`, כרטיסי collectors + bins בפאנל,
   עמוד כללי ב-UVM + קבוצת Results.
   - **A1 (`b7b756e`)** 12 קבצי defines + שמות enums + `*_UNDEFINED` (constraints `c_parity_defined`/`c_op_defined`,
     `random_test` מגריל 1..4, `router_coverage` טבלת `[4][2]`), `-incdir common` ל-run.f של labs 1–2.
   - **A2+A3 (`4b8b85a`)** 24 קבצים עם constraints הומרו ל-extern (סקריפט חד-פעמי ב-scratchpad), 38 קבצים `bit[7:0]`.
   - **A4+A5 (`0d19dae`)** `m_` ב-195 קבצים (171 שמות שדה מ-pyslang; הסקריפט דילג על מחרוזות, הערות, `rw.`/`vif.`/`hw_top.`,
     מודל הרגיסטרים); תיקוני יד: `hbus_read_seq` (class וגם שדה), `reset_seq.model`, 28 ארגומנטים/מקומיים שהתנגשו
     (`pkt`, `addr`, `data`, `reason`, sample() args) חזרו לשם פשוט. `model.py`: `runtime_names()` מוריד את ה-`m_` משמות
     השדות ומהנתיבים שהחילוץ העתיק (connect/set_sequencer/handles) → **אותם 285 nodes / 332 edges** (רק `cls:hbus_op_e` במקום
     `cls:hbus_read_write_enum`); `decl` שומר את השם האמיתי ל-UML. `test_install.sv` קיבל extern.
   - **B (`425d25e`)** `sv_style.py` כללים 5–10 עם דיווח `path:line: R<n> …`; R3 מדווח גם מתודה בתוך class (מחלקה
     פרמטרית `rnd_array #(N)` פטורה — גוף חיצוני היה דורש `#(N)`); מודל הרגיסטרים פטור (`REG_MODEL_RX`).
   - **C (`acc82e8`)** `CoverageLayout` ב-`layout.py` (סצנה `cov:main`, publishers משמאל דרך שרשרת ה-connect — ה-HBUS monitor
     דרך `hbus_export`), `drawCovCard()`, מקש `6`, פאנל התצוגה עם הסיכומים והקישורים, `cp-<cg>-<point>` ids בטבלת ה-bins
     לקפיצה מצ'יפ, CSS, `test_model.py`, PNG ב-export, `map_coverage.png` ב-readme-shots, `project-map.md`.
   - **D (`626a136`)** `docs/uvm/coverage.md`, nav (UVM + Results), קישורים צולבים (`components/coverage`, `big-picture`,
     `lab10`), מעבר שמות על 30 דפים (רק בתוך fences של SV וב-spans של קוד; לוגים/נתיבים/סיגנלים לא), README (6 הכללים,
     תמונת Coverage), `annotations.yaml`, `sim.js` (תוויות ה-playground), `getting-started`/`components/index` (איך הקוד כתוב).
   - **E** רגרסיה מלאה מחדש (כל ה-benches), `sim-report` → `yapp_project/regression`, `make map`, offline site, HANDOFF.
     מספרים: ראה "מה עובד היום".
   - **מה לא נעשה בכוונה**: RTL/interfaces/מודולים (`state_e` של ה-FSM, `logic [7:0]` ב-RTL) — תמיר בחר "רק classes וחבילות";
     מודל הרגיסטרים (Lab 11A) שומר את שמות הרגיסטרים (regmap.yaml, `test_model.py:164`); ההערות בקוד לא עברו rename (פרוזה).
19. **constraints מרווחים + שמות בתרשימים (סשן 8 סבב 5, 2026-10-14).** תמיר: (1) ה-UML ב-Lab 1 הראה `addr` במקום `m_addr`
   — כל משתנה שמוצג בתרשים צריך להיות בשם שבקוד; (2) גופי ה-constraints צפופים — לפרוס כמו מתודות. בחר: עצי היררכיה
   (`agent : yapp_tx_agent`) נשארים בשמות הריצה; רק ביטויי קוד ושדות מחלקה בתרשימים מקבלים `m_`; R11 נאכף; **בלי רגרסיה**
   (קומפילציה + lint בלבד).
   - 56 גופי constraints ב-24 קבצים פורסו (סקריפט חד-פעמי, פיצול לפי `;` בעומק סוגריים 0). `sv_style.py` כלל R11.
   - 17 דפים: תוויות mermaid שהן קוד (`m_vif.send_to_dut(pkt.m_addr, …)`, `m_item_collected_port.write(pkt)`, `m_pkt_q[addr]`,
     `m_reference.m_yapp_in`, `m_yapp_export`, …) + ה-UML של Lab 1. הקטע הידני של `short_yapp_packet` ב-lab04 הוחלף ב-`--8<--`.
   - **באג מסבב 4 שתוקן**: ה-rename הפך 4 שמות bins ל-`m_` (`ctrl_reg`, `en_reg` ב-`router_hbus_bits_coverage`,
     `oversized_cnt`, `mem_size` ב-`router_hbus_addr_coverage`) כי היו גם שמות שדות ב-`router_reference`. הוחזרו, ושמות ה-bins
     תוקנו טקסטואלית בנתוני הדוח (`coverage.json/md`, `merged.dat`, gcov html) כדי לא להריץ רגרסיה. `lab11c.md` (`ctrl_reg`
     של מודל הרגיסטרים) תוקן גם הוא. **מספרי השורות ב-gcov html של הקבצים עם constraints ישנים** עד הרגרסיה הבאה.


---

### סטטוס git — היסטוריה

- **סשן 8 סבב 4 (2026-10-14), אותו ענף `claude/confident-rubin-m1zkvc`, `main` ff אחרי כל push:** `b7b756e` (defines +
  enums), `4b8b85a` (extern constraints + `bit[7:0]`), `0d19dae` (`m_` + `runtime_names()` במפה), `425d25e` (`sv_style.py`
  כללים 5–10), `acc82e8` (לשונית Coverage), `626a136` (עמוד coverage, nav, מעבר שמות באתר), `551f3f1`/`b63c755` (HANDOFF),
  ואחריהם commit הדוח (רגרסיה מחדש: 100 ריצות עם גלים, `yapp_project/regression` 33 MB, דפי Regression/Coverage מחדש,
  אתר offline, צילומי README כולל `map_coverage.png`, export).
- **ענף סשן 8: `claude/confident-rubin-m1zkvc`** (אותו ענף כמו סשנים 5 ו-7; `main` ff אחרי כל push). commits של סשן 8:
  `9cbb6f1` (coverage collectors + דוח coverage), `edd70b9` (HBUS coverage + `hbus_sweep_test` + register-map.md), `2aafca1`/`094da66`
  (HANDOFF), ואחריהם סבב 3: הדוח המכווץ + `runs.json`, דפי Regression results + המפה, CI artifact, סבב הניקיון, HANDOFF.
  ה-remote המקומי הוחלף לשם החדש `Qcom-Mentoring` (הישן עובד דרך redirect).
- ענף סשן 8ב: `claude/hopeful-dijkstra-ldfxv2`, rebased על `094da66` (main אחרי שני הסבבים של סשן ה-coverage); commit של האתר
  האופליין ואחריו commit של התיקייה `offline/site/` + HANDOFF/README. `main` ff לאותו commit (באישור תמיר).
  לשים לב: סשן ה-coverage (סשן 8) עבד במקביל ודחף ל-`main` ישירות (`0004b0b`…`094da66`) — לפני push תמיד `git fetch` ולבדוק
  ש-`origin/main` הוא אב של הענף.
- ענף סשן 7: `claude/confident-rubin-m1zkvc` (הענף של סשן 5, קודם ל-`e9e0af2` = main של סשן 6, ואז commit הסשן; `main` ff).
  commits של סשן 7: `4bd6705` (לוגים, tracer, דוח), `b744589` (דוח committed), `852e92a` (in_phase), `1a6b908` (layout
  ל-Surfer), `0fdfe2c`/`5e62203` (state של תמיר נוסף ונמחק), `c78971d` (merge של `--trace-max-array` מסשן אחר),
  `7963190` (דוח מחדש עם זיכרונות), `a89ef84`/`5428fb2`/`c1afb05` (Scratch memory, Global, הגדרות תצוגה), `71636b3`
  (טסטים אקראיים + תיקון ה-timer). `main` = אותו commit אחרי כל push.
- ענף סשן 6: `claude/hopeful-gates-acsuwt` (= `main`, ff אחרי כל push). commits: `63b94b9` (flow + תיקונים),
  `05d4e2c` (Lab 9), `2af0853` (תיעוד/HANDOFF), `62c6e7f` + `4de60f4` (סבב 2: `rnd::` + begin/end), `77bae40` +
  `7984a96` (סבב 3: Test plan הושלם), `f1bd720` (סבב 4: UX), `a2b4b0b` (סבב 5: UX המשך), ואחריו commit ה-HANDOFF/README.
- ענף סשן 5: `claude/confident-rubin-m1zkvc` (= `main` = `origin/main` אחרי ה-ff). הענף הישן
  `claude/hopeful-meitner-r5epiu` נשאר ברימוט על `79b5fd4` (לא נמחק; אפשר למחוק).
- אין שינויים לא-committed. `HANDOFF.md` **כן** ב-commit.
- (היסטורי, סוף סשן 5) 28 commits בסך הכול; האחרונים: (סשן 5, סבב 6) README/HANDOFF/צילומים, `3687ecb` (גרירה מפס הכותרת + pan באמצעי/Space), `7dc58f6` (CLAUDE.md), `f3b3556` (Test plan + 7 טסטים), `a803879` (Tests/Environment), `a9b64b7` (סבב UX שני), `cde70e0` (סבב UX ראשון), `0df0f47`, `98565ae` (test_sim.mjs), `79b5fd4` (HANDOFF), `c98a036` (README),
  `c928f3d` (HANDOFF), `4948f7f`, `92171ec`, `4f13ab5`, `0fa3c80`, `294cf18`, `d6e6c0a`, `bea3cc2`, `c12b5aa`,
  `c78e729`, `1c8da5e`, `a4efbfb`.

---

