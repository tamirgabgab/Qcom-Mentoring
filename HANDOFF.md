# HANDOFF.md — YAPP Router UVM course (`tamirgabgab/Qcom-Mentoring`)

> נכתב בסוף הסשן הרביעי (2026-10-07), עודכן בסשן החמישי (2026-10-08), בסשן השישי (2026-10-09: סימולציה
> ב-Verilator) ובסשן השביעי (2026-10-12: לוגים קריאים, tracer של ה-DUT, דוח רגרסיה עם צירי זמן ותמונות גלים).
> סשן חדש לא זוכר כלום — זה המקור היחיד להקשר, יחד עם `CLAUDE.md` בשורש (והכרונולוגיה ב-`HISTORY.md`).
> HEAD: ראה "סטטוס git" בסעיף 2. `main` תמיד מצביע לאותו commit כמו ענף העבודה. עץ העבודה נקי.
> CI (lint + sim + docs) — ראה סעיף 2. האתר: https://tamirgabgab.github.io/Qcom-Mentoring/
> **לאן ממשיכים:** סעיף 8. מצב בסוף סשן 6: ה-Test plan **הושלם** (55 covered + 1 excluded), ספריית `rnd::` בכל הקוד,
> שני סבבי UX במפה **הושלמו** (9 מ-10 ההצעות; תמיר ויתר על עקיפת מכשולים מלאה לחצים). הקוד **רץ** ב-Verilator
> (`make sim` / `make regress` 156/156, Codespaces, workflow `sim`); Xcelium עדיין לא. מה שנשאר פתוח תלוי בתמיר:
> מעבר על ניסוחי ה-Test plan מול ה-PDF (רק אצלו), הרצה ב-Xcelium אם ישיג גישה, ותוכן לימודי לאתר.
> **סשן 7:** הלוגים מספרים את הסיפור ([TEST] באנר+שלבים+פסק דין, שורה לאירוע בכל UVC, [DUT] מ-`yapp_router_tracer`),
> `make regress WAVES=1` מקליט FST + CSV סיגנלים לכל ריצה, `make sim-report` בונה `build/sim/report/` (לוג, timeline,
> גלים, תמונות SVG לכל ריצה) + `regression_report.zip`. layout מוכן ל-Surfer (`yapp_router.sucl` / `.surf.ron`), זיכרונות
> ב-waves (`--trace-max-array 256`). **סבב 5:** 4 טסטים אקראיים (`random_*_test`) עם מודל מלא ב-`router_reference` שבודק כל
> קריאת HBUS; נמצא ותוקן באג ב-`yapp_error_timer` (פולס אחד לכל פקטה bad). רגרסיה: **158/158** (מעבדות seed אחד; הפרויקט
> 96/96 = 16 מכוונים × 4 + 4 אקראיים × 8). Test plan אז: 60 פריטים (קבוצה חדשה RND); **היום 64 פריטים ב-12 קבוצות, 63 covered + 1 excluded**.
> **סשן 8 (2026-10-13, coverage):** כל covergroup בקובץ משלו — coverage collector (`uvm_subscriber`): `yapp_pkt_coverage`,
> `yapp_gap_coverage` (על ה-monitor), `router_coverage` (על `router_reference.decision_out`). כל ריצה כותבת `.dat`
> (`--coverage-user`), `coverage_report.py` ממזג → `coverage.md` / `coverage.json` בדוח, HTML של genhtml ב-`docs/coverage/`,
> עמוד אתר "Coverage results", טבלת bins בפאנל של כל collector במפה. רגרסיה **158/158**; ממוזג על 96 ריצות: **57/57 bins (100%)**.
> **סשן 8 סבב 2 (HBUS coverage):** 4 collectors חדשים על `hbus_export` (כתובת×R/W, ביטי ctrl/en, תבניות yapp_mem, ערכי מונים)
> + `hbus_sweep_test` שסוגר אותם (כל קריאה נבדקת מול הרפרנס). רגרסיה **162/162**; ממוזג על 100 ריצות: **222/222 bins**.
> נפתח PR [tamirgabgab/Qcom-Mentoring#1](https://github.com/tamirgabgab/Qcom-Mentoring/pull/1) מה-UI; תמיר אישר: **ממשיכים
> לקדם את `main` (ff) אחרי כל push כמו תמיד**, גם כשיש PR פתוח (ה-PR יסומן merged אוטומטית).
> **סשן 8ב (2026-10-13, במקביל, אתר אופליין):** `make docs-offline` בונה את אתר הקורס לתיקייה שנפתחת מהדיסק
> (`offline/site/index.html`, **committed** בבקשת תמיר) + `build/QcomCourseSite.zip`. חיפוש, mermaid והמפה עובדים בלי שרת
> ובלי אינטרנט (נבדק ב-Playwright עם חסימת רשת). האתר הציבורי לא השתנה. פירוט: סעיף 2, פריט 16.
> **סשן 8 סבב 3 (ביקורת + דוח באתר):** ביקורת קריאה של HANDOFF/אתר/דוח/מפה → 16 הצעות; תמיר בחר ניקיון + דוח רגרסיה
> באתר וכיווץ + קישורים ותגים במפה. הדוח המחויב 83 → **33 MB** (`runs.json`, בלי `all_logs.log`/`signals.csv`/`timeline.csv`,
> timeline מקוצץ), עמוד אתר **Regression results** + דף לכל טסט (`docs/regression/`, מיוצר ב-`build.py`), סעיף Regression
> ותגי seeds/bins על כרטיסי הטסטים במפה, טבלאות ה-Appendix מיוצרות, CI מעלה את הדוח כ-artifact, ~30 דפי אתר תוקנו.
> **סשן 8 סבב 4 (2026-10-14, סגנון קוד + Coverage במפה):** שישה כללי סגנון חדשים של תמיר על **כל** הקוד (yapp_project,
> 16 ה-labs, common): כל שדה של class מתחיל ב-`m_` (שמות הריצה `create("monitor")` ומפתחות config_db לא השתנו), `bit[7:0]`
> בלי רווח, constraints כ-`extern` עם גוף `constraint cls::c {}` אחרי `endclass` ולפני המתודות, typedef/enum בקובץ
> `<pkg>_defines.sv` לכל חבילה, enums `NAME_UNDEFINED, NAME_X…` (`parity_type_e → PARITY_TYPE_*`, `hbus_op_e`, `ROUTER_REASON_*`,
> `CHANNEL_RX_PROFILE_*`, `CHANNEL_PARITY_TYPE_*`). `sv_style.py` אוכף הכול (כללים 5–11, דיווח `קובץ:שורה`; R11 מסבב 5:
> גוף constraint בפריסה של מתודה). במפה: לשונית
> שישית **Coverage** (כרטיס לכל collector, פס לכל covergroup, צ'יפ לכל coverpoint). באתר: `uvm/coverage.md` כללי + קבוצת Results.
> פירוט: סעיף 2, פריט 18.
> **סשן 8 סבב 5 (2026-10-14, תיקונים קטנים):** גופי ה-constraints פרוסים כמו מתודות (delimiter, משפט בשורה; כלל R11),
> תוויות קוד בתרשימי האתר ב-`m_` כמו בקוד (עצי היררכיה נשארים בשמות הריצה), 4 שמות bins שה-rename של סבב 4 קלקל הוחזרו.
> בלי רגרסיה מקומית (קומפילציה + lint בלבד); ה-workflow `sim` על `6f18453` עבר. רשימת השדרוגים הבאים: סעיף 8.
> **סשן 9 (2026-10-21, סקירה ותוכנית):** `--trace-max-array` כבר ב-main (c78971d). סקירת הממשק כולו (אתר, מפה, README,
> CI, קוד) ותוכנית שדרוגים ב-7 סבבים (א–ז) עם סדר מומלץ, הערכות והחלטות שתמיר צריך לקבל — **סעיף 8**.
> **סשן 9 המשך — סבבים א, ב, ד, ו בוצעו** (תמיר בחר: למחוק `hbus_slave_agent`; `start/` committed עם מתודות מרוקנות; עמוד
> Bug hunt גלוי; מדריך למנחה + ערכה + PDF). ניקיון (אייקונים, טבלת Regression, `HISTORY.md`, workflow `fresh`, hook, סרגל
> לטלפון); מסלול הסטודנטית (`labs/<lab>/start/` + `TASKS.md`, `make check LAB=… START=1`, Getting started מבוסס Verilator,
> "See it run" ו-"Try this" בכל דף לאב, Glossary, FAQ); Bug hunt (10 mutants ב-RTL, `make bug-hunt`, workflow `bughunt`,
> עמוד + מטריצה, test ranking ב-Coverage results, `history.csv` + גרף ב-Regression results); העברת הקורס (`docs/mentor/`
> 8 מפגשים, `make student-kit`, `make docs-pdf` → `offline/QcomCourse.pdf`). רגרסיה: 162/162 ריצות עברו (64.8 דקות, Verilator 5.052, אחרי מחיקת ה-slave agent וה-`ifdef BUG_*`). Bug hunt: 9/10 mutants נתפסו (`BUG_FIFO_DEPTH_8` שרד — אין בדיקה של עומק ה-FIFO; `BUG_HBUS_READ_STALE` נתפס ע"י 17 טסטים, `BUG_COUNTER_SATURATES` רק ע"י `counter_wrap_test`), ~6 דקות למוטנט.
> **נשארו**: סבבים ג (SVA, reset, RAL predictor, coverpoints), ה (המפה כמורה), ז (מותנה) — סעיף 8.

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
  - **(סבב 4, 2026-10-14) שישה כללים נוספים, על classes וחבילות בלבד** (RTL, interfaces, מודולי tb ומודל הרגיסטרים
    של Lab 11A לא נוגעים; `sv_style.py` כללים 5–10):
    1. **כל שדה של class מתחיל ב-`m_`** (`m_addr`, `m_length`, `m_monitor`, `m_vif`, `m_item_collected_port`, מונים);
       ארגומנטים ומשתנים מקומיים **לא** (בודק הפוך). static/const/parameter פטורים, וגם שדות של UVM עצמו
       (`is_active`, `req/rsp`, `model` של `uvm_reg_hw_reset_seq`). **שמות הריצה נשארים פשוטים**:
       `create("monitor", this)`, `new("item_collected_port", this)`, מפתחות `uvm_config_db` ("vif", "is_active"),
       `print_generic("parity_type", …)` — לכן ההיררכיה בלוגים, ב-Surfer, ב-`sim_report.py` ובמזהי המפה לא זזה.
    2. **רוחב בלי רווח**: `bit[7:0]`, `logic[15:0]` (גם בהערות של קבצי ה-classes).
    3. **constraints כמו מתודות**: `extern constraint c_x;` במחלקה, `constraint cls::c_x { … }` אחרי `endclass`
       תחת באנר `// <cls> -- constraints`, לפני `-- method implementations`. **(סבב 5)** כל גוף constraint נראה כמו
       גוף מתודה: delimiter `//---` מעליו (חוץ מהראשון אחרי הבאנר), `constraint cls::c_x {` בשורה משלו, משפט אחד
       בשורה, `}` לבד, שורה ריקה אחת בין גופים (`sv_style.py` כלל R11).
    4. **סדר במחלקה**: שדות → מאקרו utils → covergroups → `extern constraint` → `extern function/task`; אחרי
       `endclass`: גופי constraints ואז גופי מתודות.
    5. **typedef/enum רק ב-`<pkg>_defines.sv`** (`yapp_defines.sv`, `hbus_defines.sv`, `channel_defines.sv`,
       `router_defines.sv`, `clock_and_reset_defines.sv`, `common/rand_util_defines.sv`, ועותקים ב-labs 1–6),
       הערה לכל טיפוס, `include` ראשון בחבילה. typedef בתוך class/פונקציה מותר (`rnd_array::bytes_t`).
    6. **enums**: שם הטיפוס מסתיים ב-`_e`, הערכים באותיות גדולות עם שם הטיפוס כקידומת, הראשון תמיד
       `<NAME>_UNDEFINED` ואף פעם לא נוצר (constraint `c_*_defined`, השמות מפורשות). `hbus_op_e` הוא `enum bit[1:0]`
       (2 ביטים, `$bits` סימטרי ב-pack/unpack).
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
- **מסירה**: אחרי כל סבב — `QcommMentoring.zip` של הריפו (בלי `.git`, `site`, `offline`, `build`,
  `__pycache__`, `scripts/uvm_src`, `tr_db.log`; מגבלת SendUserFile 30 MB) + `yapp_project_map.html` העצמאי, ואחרי שינוי
  בדפי האתר גם `build/QcomCourseSite.zip` (`make docs-offline`; ~9 MB) נשלחים לתמיר דרך SendUserFile. הוא מעתיק ל-`C:\Users\User\Desktop\PyProjects\QcommMentoring` או עושה
  `git pull origin main`.
- לפני שינויים גדולים תמיר רוצה **שאלות מנחות** (AskUserQuestion) ואז ביצוע מלא.
- מפת הפרויקט: תמיר מבקש **קליקים נוחים** (קליק בודד פותח/בוחר), **חצים מעוגלים ולא מבולגנים**,
  ולראות את **קובץ המקור המלא** של הפריט הנבחר.

---

## 2. מצב נוכחי

### מה עובד היום ונבדק (בקונטיינר)
- **סשן 9 (סבבים א/ב/ד/ו):** `make start` מייצר 15 ספריות `labs/<lab>/start/` (11A בלי), `make start-check` ו-`make lint`
  (33 `run.f`, כולל ה-start) ב-CI (`lint.yml`); `make check LAB=lab05_seq [START=1]` רץ ב-Verilator ומשווה ל-`scripts/lab_checks.yaml`
  (נבדק על lab05: הפתרון = הכול ok, ה-start = MISSING בשורות של הסיקוונסים); `make bug-hunt` = 10 mutants × 21 טסטים
  (9/10 mutants נתפסו (`BUG_FIFO_DEPTH_8` שרד — אין בדיקה של עומק ה-FIFO; `BUG_HBUS_READ_STALE` נתפס ע"י 17 טסטים, `BUG_COUNTER_SATURATES` רק ע"י `counter_wrap_test`), ~6 דקות למוטנט); `make docs-pdf` = 518 עמודים עם 44 דיאגרמות Mermaid מרונדרות (`offline/QcomCourse.pdf`, 6.4 MB, committed);
  `make student-kit` = `build/StudentKit.zip` (16 MB). רגרסיה אחרי מחיקת `hbus_slave_agent` והוספת ה-mutants (כבויים בלי define):
  162/162 ריצות עברו (64.8 דקות, Verilator 5.052, אחרי מחיקת ה-slave agent וה-`ifdef BUG_*`). workflow חדש `fresh` (offline/site + runs.json מול regress.yaml + bug_hunt.json מול mutants.yaml), `bughunt`
  (job לכל mutant, נכשל אם mutant שורד).
- **סימולציה (סשן 6):** `make regress` = 18 ספריות סימולציה + build אחד עם `INJECT_ERROR` (`scripts/regress.yaml`), 64 טסטים — **כולם PASS**
  ב-Verilator 5.052 (מקומית ב-seed 1–2 וב-CI ב-2 seeds). `coverage_test` סוגר `yapp_pkt_cg` ב-100%,
  `backpressure_test`: in_suspend עלה 7 פעמים, 6/6 matched; `parity_error_test`: 12 פולסים ל-12 פקטות, 2..10 מחזורים.
  workflow `sim` ב-GitHub: job לכל ספרייה, ~3–4 דקות בסך הכול.
- **לוגים ודוח (סשן 7):** `make regress ONLY=yapp_project WAVES=1` → 96 ריצות (16 מכוונים × 4 seeds + 4 אקראיים × 8);
  `make sim-report ONLY=yapp_project` → `build/sim/report/index.md`, תיקייה לכל ריצה (`<test>_s<seed>.log`, `timeline.md/.csv`,
  `<test>_s<seed>.fst`, `signals.csv`, `wave_*.svg`), `all_logs.log`, ו-`build/sim/regression_report.zip` (~2 MB, 18 MB פרוס).
  **הדוח committed ב-`yapp_project/regression/`** (בקשת תמיר, סבב 2 של סשן 7; `.gitignore` מחריג את ה-`*.log` שם). אחרי
  שינוי בטסטים/UVCs: להריץ מחדש ולעשות commit לתיקייה (סשן 8 סבב 3: **33 MB**, 100 ריצות; לוגים 22 MB, timeline.md 6 MB,
  SVG 4 MB, FST 3 MB; בלי `all_logs.log`/`signals.csv`/`timeline.csv` — הם נכתבים רק לדוח המקומי ב-`build/`).
  התמונות נבדקו ויזואלית (Playwright → PNG): פקטה נכנסת/יוצאת, suspend, error pulse, HBUS write/read.
- `make lint` — כל 18 ה-`run.f` (17 מעבדות/test_install + `yapp_project/tb/run.f`) עוברים slang
  ב-0 שגיאות ו-0 אזהרות.
- `make style-check` — `sv_style: OK` (ואידמפוטנטי: `--fix` פעמיים = אין שינוי). **(סבב 4–5)** כללים 5–11 מדווחים
  `path:line: R<n> …`; `--check` על עץ נקי = OK, על קובץ מכוון-רע (scratchpad) = 9 הפרות ו-exit 1 (נבדק).
- **(סבב 5, 2026-10-14)** אחרי פריסת ה-constraints: `make lint` 18/18, קומפילציית Verilator של lab01–06 ו-`yapp_project`
  נקייה, map-check/pytest/mkdocs strict OK, ה-workflow `sim` (כל ה-benches) ירוק על `6f18453`. **הדוח המחויב הוא עדיין
  של סבב 4**: שמות 4 ה-bins תוקנו בו טקסטואלית, מספרי השורות ב-gcov html של הקבצים עם constraints ישנים עד הרגרסיה הבאה.
- **(סבב 4, 2026-10-14) רגרסיה מלאה אחרי שינוי הסגנון: `make regress` = 162/162 PASS (81 דקות בקונטיינר), ואז
  `make regress ONLY=yapp_project WAVES=1` (100 ריצות עם גלים) לדוח המחויב.**
- `make map && make map-check` — 285 nodes, 332 edges, 42 scenes (6 תצוגות: Hierarchy, TLM, Classes,
  Environment, Test plan, **Coverage**). ממשק (סשן 6 סבבים 4–5): עמודת Source מתקפלת, שורת סטטוס עם מסלול, Fit width/all,
  חיפוש מדורג, רשימת פריטים מקובצת עם סינון, לשוניות package, רמת פירוט לפי זום, חצים עמומים ב-Test plan,
  מיני-מפה; `docs/test-plan.md` עם מטריצת כיסוי. `test_model.py` עובר (pins/regmap ב-root scene, regmap.yaml ⇔ localparams
  ב-RTL ⇔ offsets ב-RAL, סצנות env/plan, עקביות ה-Test plan מול המחלקות) **+ `test_sim.mjs`
  (536 assertions על `RouterModel` ועוזרי הפקטה, רץ מתוך `build --check` כשיש node)**. `docs/test-plan.md`
  נוצר מ-`build.py` ונבדק staleness.
- הטסטים: 31 מחלקות test במודל (17 של הקורס + 14 של ה-Test plan ב-`yapp_project/tb/tests`: 10 מכוונים + 4 אקראיים), לכל אחת
  plan (stages + expected) ולפחות פריט אחד ב-`plan:` שמזכיר אותה. 64 פריטי תוכנית ב-12 קבוצות: **63 covered, 1 excluded** (סשן 8).
- `mkdocs build --strict` — 0 אזהרות (רק INFO על anchors של deep links — צפוי).
- בדיקת דפדפן (Playwright, סקריפט חד-פעמי ב-scratchpad, לא בריפו): המפה נטענת בבהיר/כהה,
  ה-DUT מצויר עם 19 פינים ובלוק רגיסטרים, קליק על הבלוק פותח את לשונית Simulate, כתיבה דרך ה-UI
  ל-en_reg, כתיבה ל-RO נדחית, ו-10 assertions על `RouterModel` (reset, good packet, bad parity,
  addr 3, oversized, router disabled, unmapped, warm reset, checkPacket) — הכול עבר.
- CI ב-GitHub: workflow `lint` (slang + style-check + map-check) ו-`docs` (mkdocs → GitHub Pages)
  ירוקים על כל commit של סשן 5 עד `3687ecb` (נבדק דרך ה-API). ה-runner של GitHub (ubuntu-latest) כולל node, ולכן `map-check`
  ב-CI מריץ גם את `test_sim.mjs`.
- **אתר הקורס אופליין (סשן 8ב):** `make docs-offline` (`scripts/build_offline_site.py`, `mkdocs-offline.yml` שיורש מ-`mkdocs.yml`,
  `scripts/mkdocs_offline_hooks.py`) בונה את `offline/site/` (**committed**, ~25 MB, 190 קבצים) שנפתחת עם `index.html` מהדיסק (file://)
  ו-`build/QcomCourseSite.zip` (התיקייה `site/` בפנים, ~9 MB). `use_directory_urls: false` + תוסף `offline` של Material; Mermaid ו-`iframe-worker` (החיפוש תחת file://)
  נשלפים עם `npm pack` ל-`build/offline_cache/` ונשלחים בתוך האתר במקום unpkg; ה-iframe של המפה ב-`project-map.md` הוא HTML גולמי ולכן
  ה-hook מתקן לו את הנתיב. נבדק ב-Playwright עם חסימת כל הרשת: חיפוש (10 תוצאות), ניווט, תרשימי mermaid והמפה האינטראקטיבית עובדים;
  רק ה-API של GitHub (כוכבים/forks בכותרת) מנסה לצאת ונכשל בשקט. האתר הציבורי ב-Pages לא השתנה (ה-CI ממשיך לבנות עם `mkdocs.yml`).
- GitHub Pages פעיל (Source = GitHub Actions), האתר חי, המפה ב-`/project-map/` והקובץ העצמאי
  ב-`/downloads/yapp_project_map.html`.

### מה נעשה — כרונולוגיה של כל הסשנים

הכרונולוגיה המלאה (סשנים 1–8, פריט לכל סבב, עם מספרי ה-commits) עברה ל-**`HISTORY.md`** בסשן 9, כדי שהקובץ הזה
יחזיק רק את המצב הנוכחי, הכללים, הבעיות הפתוחות והצעד הבא. בקצרה: סשן 1 בנה הכול מאפס (DUT, ארבעה UVCs, 17 לאבים,
אתר, lint); סשן 2–4 — המפה האינטראקטיבית על חמש תצוגות, הסימולטורים בדפדפן, ה-RAL; סשן 5 — סגנון extern/אחד-לקובץ,
Test plan + 7 טסטים, שלושה סבבי UX; סשן 6 — Verilator + CI, `rnd::`, השלמת ה-Test plan, שני סבבי UX; סשן 7 — לוגים
קריאים, tracer, דוח רגרסיה, Surfer, טסטים אקראיים; סשן 8 — coverage collectors ודוחות, אתר offline, דוח באתר,
כללי סגנון `m_`/defines/enums/constraints, לשונית Coverage; סשן 9 — הסקירה והסבבים (סעיף 8).

### מה בתהליך ולא גמור
- כלום פתוח בקוד. מה שתמיר דחה במפורש להמשך: reset באמצע טסט, receiver שעוצר באמצע פקטה (סעיף 8 פריט 5), ומהביקורת של
  סשן 8 סבב 3 — תוכן לימודי (סעיף 8 פריט 7) ו-history/trend של הרגרסיה.

### סטטוס git
- **סשן 9 (2026-10-21), ענף `claude/hopeful-gates-acsuwt` (הענף של סשן 6, ממוזג עם `main` = `ef2747c`), `main` ff:**
  `65b0638` (`--trace-max-array 256`), `ed73f83` (סעיף 8 כסבבים), ואז הסבבים: `13d1c16` (א), `296c93b` (ב), `8bd1fce` (ד),
  `ae4c650` (ו), `ef7cc93` (README + offline), `0cd49ec` (HANDOFF) — `main` ff ל-`0cd49ec` באמצע הסשן, ואחריו commit
  תוצאות ה-bug hunt (עמוד Bug hunt, offline, PDF) ו-ff נוסף. ה-workflows: lint, sim, docs, fresh (חדש), bughunt (חדש, 10 jobs).
- **סשן 8 סבב 5 (2026-10-14), אותו ענף, `main` ff:** `4b15d5d` (פריסת constraints + R11 + bins), `6f18453` (שמות `m_`
  בתרשימי האתר, נתוני coverage, HANDOFF פריט 19), ואחריו commit ה-HANDOFF/README עם רשימת השדרוגים. CI על `6f18453`:
  lint, docs, sim — ירוקים.
- ההיסטוריה המלאה של הענפים וה-commits של סשנים 1–8: `HISTORY.md`.

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
| `main` תמיד fast-forward ל-feature branch | תמיר ראה `main` ריק ורוצה את הכול שם | PRs | סופי; גם כשתמיר פותח PR מה-UI (סשן 8), `main` מקבל ff אחרי כל push |
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
- **(סבב 4) `m_` לעומת שמות ריצה**: המפה (`model.py`) סומכת על כך שמחרוזת ה-`create("x")` היא שם השדה בלי `m_`.
  שדה `m_foo` שנוצר כ-`create("bar")` ייעלם מהמפה (ה-node מסונן) — תמיד `m_foo = …::create("foo", this)`.
- **(סבב 4) `*_UNDEFINED` מזיז את הערכים המספריים**: אינדקס מערך לפי enum (`hits_reason_parity[t.m_reason]`) וקאסט
  מ-`rnd::get_int` (`random_test::pick_profile`) חייבים לדלג על 0. `enum bit` של ביט אחד לא מכיל 3 ערכים → `bit[1:0]`.
- **(סבב 4) שם שהוא גם class וגם שדה** (`hbus_read_seq`): rename גלובלי של שדות משנה גם את ה-class. לבדוק `grep '^class m_'`.
- **(סבב 5) rename גלובלי פוגע גם בשמות bins** של covergroup שזהים לשם שדה במחלקה אחרת — לבדוק `bins m_`.
- **(סבב 4) מתודות של מחלקה פרמטרית** (`rnd_array #(N)`) נשארות in-class: R3 פוטר אותן (`parameterized`).

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

**סשן 9 (סבבים א/ב/ד/ו) — קבצים חדשים.** `HISTORY.md` (הכרונולוגיה); `scripts/make_start.py` (+ `labs/*/start/`, מיוצר ו-committed,
`PREV`/`EXTRA`/`KEEP` בראש הקובץ); `scripts/lab_checks.yaml` + `check()` ב-`sim.py` (`make check`); `scripts/see_it_run.py` →
`docs/assets/generated/see_it_run/<lab>.md` (snippet בכל דף לאב, "## See it run"); `scripts/mutants.yaml` + `scripts/bug_hunt.py` →
`docs/assets/generated/bug_hunt.json` → `docs/bug-hunt.md` (ב-`build.py`: `render_bug_hunt_md`, `mutant_source`); `render_test_ranking`
ו-`render_history_svg` ב-`build.py`; `yapp_project/regression/history.csv` (+ `append_history` ב-`sim_report.py`); `scripts/check_fresh.py`
+ `.github/workflows/fresh.yml`; `.github/workflows/bughunt.yml`; `.githooks/pre-commit` (`make hooks`); `docs/glossary.md`, `docs/faq.md`,
`docs/mentor/` (index + session-1..8); `mkdocs-print.yml` + `docs/assets/print/cover.tpl` + `scripts/build_pdf.py` → `offline/QcomCourse.pdf`
(חריג ב-`.gitignore`); `scripts/student_kit.py`. ה-RTL: `ifdef BUG_*` ב-`yapp_input_fsm.sv`, `yapp_hbus_regs.sv`, `yapp_output_channel.sv`.

| נתיב | תפקיד | שונה בסשן 4 |
|---|---|---|
| `Makefile` | `lint`, `style`, `style-check`, `run LAB= TEST=`, `run-project TEST=`, `docs`, `serve`, `map`, `map-check`, `map-export`, `clean` | + `style`, `style-check` |
| `common/lab.mk` | Makefile משותף לכל ספריית סימולציה (`run/gui/lint/clean`), `ROOT` יחסי | — |
| `common/uvm_version_compat.svh` | shim 1.1d/1.2 | — |
| `scripts/lint.py` | elaboration של `run.f` עם pyslang; `--all`, `--quiet`; `standard_args()`, `compile_run_f()` (משמש גם את ה-extractor) | — |
| `scripts/get_uvm.sh` | מוריד UVM של Accellera ל-`scripts/uvm_src/` (gitignored) | — |
| **`scripts/sv_style.py`** | כללי הסגנון: hoist config locals, wrap bodies, delimiters, תיקון `extern //`; `--fix/--check/--diff` | **חדש** |
| `scripts/gen_waves.py` | SVG של waveforms + **`packet_structure()`** → `docs/assets/packet_structure.svg`; **סשן 7: `render(out_dir, title, quiet)` משמש גם את `sim_report.py`** | + figure |
| **`scripts/sim_report.py`** | **סשן 7:** לוגים → `build/sim/report/` (timeline md/csv, FST, signals.csv, `wave_*.svg`), `index.md`, `all_logs.log`, zip | **חדש (סשן 7)** |
| **`mkdocs-offline.yml`**, **`scripts/mkdocs_offline_hooks.py`**, **`scripts/build_offline_site.py`** | **סשן 8ב:** האתר כתיקייה שנפתחת מהדיסק (`make docs-offline`) → `offline/site/` (committed) + `build/QcomCourseSite.zip` | **חדש (סשן 8ב)** |
| **`yapp_project/tb/yapp_router_tracer.sv`** | **סשן 7:** observer שנקשר ל-DUT ב-`bind`: שורות `[DUT]` + `+trace_csv` (CSV לכל מחזור) | **חדש (סשן 7)** |
| **`docs/appendix/sim-report.md`** | **סשן 7:** איך לקרוא לוג, מבנה הדוח, התמונות, פתיחת גלים | **חדש (סשן 7)** |
| `scripts/project_map/extract.py` | pyslang → מבנה גולמי (classes, methods incl. extern prototypes, modules, ports, connects, vif) | — |
| `scripts/project_map/model.py` | מיזוג + annotations → nodes/edges/paths/files; `wire_module` לחיווט מודולים; **(סבב 4) `runtime_names()`**: מזהי המפה משמות הריצה (בלי `m_`), `decl` ל-UML | — |
| `yapp_project/uvc/*/<uvc>_defines.sv`, `common/rand_util_defines.sv`, `labs/lab0[1-6]*/sv/yapp_defines.sv` | **(סבב 4)** typedefs ו-enums של כל חבילה, הערה לכל טיפוס, `include` ראשון בחבילה | כן |
| `docs/uvm/coverage.md` | **(סבב 4)** functional coverage כללי ב-UVM: מושגים, subscriber על ה-monitor, הלולאה coverage-driven, קריאת המספרים | כן |
| `scripts/project_map/layout.py` | גיאומטריית הסצנות; `arrange_columns`, `size_dut_spec` (פינים, anchors, בלוק רגיסטרים), pin anchors ב-`plan_edges`, de-dup של port bundles ב-`scene_edges`; **סשן 5: `port_on_left()`, DUT `dut_tlm` עם `pins` ב-`TlmLayout.scene`** ; **(סבב 4) `CoverageLayout`** (סצנה `cov:main`: publishers → כרטיסי collectors) | כן (+סשן 5) |
| `scripts/project_map/annotations.yaml` | החצי הידני: summaries, labs, layout hints; **`hw_top.columns`, `hw_top.dut.style: dut_spec`, `pin_groups`** | כן |
| **`scripts/project_map/regmap.yaml`** | מפת הרגיסטרים כנתונים (registers, memories, fields, `figure_rows`) | **חדש** |
| `scripts/project_map/build.py` | בונה model.json, **regmap.js**, standalone HTML (inlines app.css/js + **sim.css/js + regmap.js**), `docs/test-plan.md` (**+ `render_matrix_html`**, סשן 6); `--check` (test_model + **`check_sim()` → test_sim.mjs**); `GENERATED` dict | כן (+סשן 5, 6) |
| `scripts/project_map/test_model.py` | בדיקות עקביות; **+ DUT block, regmap ⇔ RTL params ⇔ RAL offsets, standalone inlines sim** | כן |
| **`scripts/project_map/test_sim.mjs`** | בדיקות התנהגות של `sim.js` (`RouterModel`, עוזרי פקטה) ב-node; רץ מ-`build --check` | **חדש (סשן 5)** |
| `scripts/project_map/export.mjs` | Playwright → `export/*.svg|png`, PDF ל-`build/` | — |
| `scripts/project_map/templates/standalone.html.j2` | שלד ה-HTML העצמאי | + sim/regmap |
| `docs/assets/project_map/app.js` | אפליקציית המפה; `drawDutSpec`, tap על `.pm-regmap`, `simKind`, `renderSim`, לשונית Simulate; **סשן 5: `orthoRoute/roundedPath/routeEdges/endpointOf` (ניתוב ב-JS), `drawDutTlm`, גרירה (`moveItem`, `applySavedLayout`, `resetLayout`), `toggleArrows/applyArrows`, `initResizers`, `showCodeAt/focusRow`, טבלאות members, תיקון `exportSvgString`**; **סשן 6 סבב 4: `renderCodePane` (פס מתקפל), `afterResize`, `fit(mode)/fitNext`, `renderStatus/flash`, `searchHits/renderSearch/pickSearch`, `renderItemList`, לשוניות `groupTabs`; סבב 5: `tagFar/applyLod`, `renderMinimap/updateMinimap/initMinimap`** | כן (+סשן 5, 6) |
| `docs/assets/project_map/app.css` | עיצוב; **`.dut-spec`, `.pm-regmap`**; סשן 6: `.pm-search-results`, `.pm-subbar`, `.pm-statusbar`, `.pm.code-collapsed`/`.pm-codepane-strip`, `.pm-filter`/`.pm-items` | כן |
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
| **`scripts/coverage_report.py`** | **סשן 8:** מיזוג ה-`.dat` של Verilator → coverage.md/json/HTML; `--md` לסיכום ה-CI | **חדש (סשן 8)** |
| **`yapp_project/uvc/*/*_coverage.sv`** | **סשן 8:** 7 coverage collectors (`uvm_subscriber`), covergroup אחד לקובץ | **חדש (סשן 8)** |
| **`yapp_project/regression/runs.json`** | **סשן 8 סבב 3:** כל ריצה כנתונים (תוצאה, זמנים, שלבים, תמונות, קישורים) — הקלט של `docs/regression/` ושל המפה | **חדש** |
| **`docs/regression/`**, **`docs/assets/regression/`** | **סשן 8 סבב 3:** דפי Regression results (מיוצרים ב-`build.py`) + תמונות הגלים של seed 1 לכל טסט (מועתקות ע"י `sim_report.py`) | **חדש** |
| **`docs/assets/generated/index_*.md`** | **סשן 8 סבב 3:** טבלאות הטסטים והסיקוונסים של `appendix/index-tables.md` (snippets, מיוצרים; `exclude_docs` ב-mkdocs.yml) | **חדש** |
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
- ~~`hbus_slave_agent` הוא placeholder~~ — נמחק בסשן 9 (סבב א, החלטת תמיר); `hbus_env` = masters + monitor.
- ~~Mermaid מ-CDN — האתר offline מאבד דיאגרמות~~ — סשן 8ב: `offline/site/` נושא את mermaid בעצמו. האתר הציבורי עדיין מ-unpkg (תקין).
- ~~`offline/site/` לא נבדק ב-CI~~ — סשן 9: workflow `fresh` בונה מחדש ומשווה (`git diff`); עדיין צריך `make docs-offline` + commit
  אחרי כל שינוי בדפים, אחרת ה-CI אדום. ה-PDF (`offline/QcomCourse.pdf`) **לא** נבדק ב-CI — `make docs-pdf` ידני אחרי שינוי תוכן.
- ~~חסר `pymdownx.emoji`~~ — תוקן בסשן 9 (סבב א).
- **(סשן 9) ידוע ולא תוקן:** `start/` של Lab 10 מצליל את `yapp_pkt_coverage.sv` ו-`seqs/yapp_coverage_seq.sv` דרך `-incdir ../sv` ראשון —
  עובד ב-slang וב-Verilator, לא נבדק ב-xrun (אמור לעבוד: סדר `-incdir`). ה-stubs של מודולים/interfaces לא מרוקנים (בכוונה).
  `make check` מזהה רק את מה שב-`lab_checks.yaml`; טסט שעובר בלי לעשות את הלאב (`set_config_test` ב-start) יופיע ok —
  זה מתועד ב-FAQ. ה-mutant `BUG_FIFO_DEPTH_8` **שרד** (0/21, ראה Bug hunt): FIFO של 8 במקום 16 רק מעלה `suspend_N` מוקדם יותר, ושום
  checker לא מודד את זה. לסגור בסבב ג: `cover`/`assert property` על הערוץ (suspend עולה בדיוק כשה-FIFO מלא, 16 בייטים
  נכנסים בלי suspend) או טסט `backpressure_test` שסופר כמה בייטים נכנסו לפני ה-suspend הראשון.
- `restyle.py` לא בריפו — אם תמיר ירצה לשחזר את ההמרה על קוד חדש, אין כלי; `sv_style.py` מכסה רק את 4 הכללים שלו.
- ~~בפאנל הצר של המפה (360px) טבלת הרגיסטרים ב-"compact"~~ — הפאנל ניתן להרחבה (סשן 5); הדיאגרמה בשורת-משנה.
- תוויות של חצים (label) מונחות באמצע הקטע הארוך ביותר ויכולות לנחות על קופסה; בסצנות צפופות הן ממילא מוסתרות עד hover.
- עקיפת מכשולים (סשן 5, פריט 5) מכסה רק חץ בין שתי קופסאות שפונות זו לזו (Z או קו ישר) ורק מעקף אחד מעל/מתחת; מסלולי U/L וחצים אנכיים עדיין יכולים לחתוך קופסאות (ב-`h:tb` עם Arrows דלוק). ב-`h:hw_top` ה-backdoor של yapp_rm עובר בין clk_rst_if ל-clkgen. **החלטת תמיר (סשן 6, סבב 5): לוותר** — Arrows כבוי כברירת מחדל, ועם בחירה רואים רק את החצים של הפריט.
- הסרגל הוא שתי שורות ב-1600px (תצוגות + crumbs + חיפוש / כפתורים) — מצב קבוע ועקבי אחרי סבב 4, לא באג.
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

- ~~7 טסטי ה-Test plan והסיקוונסים החדשים מעולם לא רצו~~ — **רצים ב-Verilator מסשן 6** (156/156 ברגרסיה, כולל 9 טסטי ה-Test plan והלאבים 6–7 עם ה-driver המתוקן).
- ~~בתצוגת Test plan עם Arrows דלוק 67 חיצי covers חותכים כרטיסים~~ — סבב 5: החצים עמומים עד שבוחרים כרטיס, ואז רק שלו.

**באגים ידועים:** אין. בסשן 6 נמצאו ותוקנו `set_parity` ו-`scoreboard_drop_test` (סעיף 2).
- ~~חוב קטן: randomize לפני start_item ב-`yapp_coverage_seq`/`yapp_88_packets_seq`~~ — תוקן בסבב 3 של סשן 6.
- Codespaces עם `hostRequirements.cpus: 4` צורך את המכסה החינמית פי 2 (לתמיר: לעצור את ה-codespace בסוף).
- ~~ה-INJECT_ERROR build לא ברגרסיה~~ — נוסף בסבב 3 (`"labs/lab11b_rm_integ/tb +define+INJECT_ERROR"` ב-regress.yaml).

---

## 8. הצעד הבא

**סשן 9 (2026-10-21): סקירת הממשק כולו ותוכנית שדרוגים בסבבים.** נכתב לבקשת תמיר ("איך לשדרג את הפרויקט ולקדם אותו
כמה צעדים קדימה — תציע בסבבים"). הסקירה כיסתה את האתר (צילומי Playwright של הבית, לאב 5, לאב 9A, Test plan, Regression,
Coverage, Driver, Getting started, Spec — במחשב 1440px ובטלפון 390px), את שש תצוגות המפה, את ה-README, ה-CI, הסקריפטים
והקוד. הרשימה השטוחה מסשן 8 סבב 5 (19 פריטים) נבלעה בסבבים שלמטה. **אין משימה פתוחה שאפשר להתחיל בלי תמיר** —
כל סבב מתחיל בשאלות מנחות ובבחירה שלו, ומסתיים ב-commit + push + ff של `main` + zip + מפה.

### מה הסקירה מצאה

**חזק היום.** פתרון מלא ומאומת לכל 16 הלאבים (162/162 ברגרסיה, 222/222 bins), DUT מפוצל ומתועד, אתר של ~60 דפים עם
דיאגרמות ושאלות checkpoint, מפה בשש תצוגות שמיוצרת מהקוד, שני סימולטורים בדפדפן, דוח רגרסיה עם לוגים/צירי זמן/גלים
לכל ריצה, coverage ממוזג על המקור, סגנון קוד אחיד שנאכף ב-CI, הכול עובד גם offline. הבסיס ההנדסי כמעט סגור.

**מה חסר או נראה בעין (מה שהסבבים מתקנים).**
- **לסטודנטית שעוד לא פתרה אין כלום**: כל לאב הוא פתרון גמור; אין נקודת התחלה (skeleton), אין "בדוק את עצמך", אין
  glossary / FAQ, ומסלול ההתחלה באתר עדיין Xcelium-first ("run `test_install`"). זה הפער הגדול ביותר מול מטרת הפרויקט (mentoring).
- **אין אף assertion** (`assert property` / `cover property`) בכל הריפו — כל הבדיקות חיות ב-scoreboard וב-reference model.
  לקורס אימות זה חור לימודי וגם הנדסי.
- **אין הוכחה שהטסטבנץ' תופס באגים**: רק `INJECT_ERROR` אחד (lab11b). סט mutants ב-RTL שהרגרסיה חייבת להפיל הוא הדרך
  הזולה ביותר להראות לסטודנטית למה כל checker קיים.
- עמוד הבית: אייקוני הכרטיסים מופיעים כטקסט (`:material-chip:{ .lg .middle }`, `:octicons-arrow-right-24:`) — חסר
  `pymdownx.emoji` ב-`mkdocs.yml` (ידוע מסשן 8, עדיין לא תוקן).
- עמוד Regression results: עמודת Test נשברת לשלוש שורות (`base_t / est`) כי הטבלה צרה ולשם הקוד אין `nowrap`.
- בטלפון (390px): סרגל המפה תופס שליש מסך (ארבע שורות), המיני-מפה מכסה את הציור, הפאנל נדחף למטה. המפה בנויה ל-1280px ומעלה.
- בתצוגת Classes "All classes" (129 מחלקות) חצי הירושה ל-`base_test` חוצים את כל התרשים — קריא רק דרך לשוניות ה-package.
- `yapp_project/regression` (33 MB) ו-`offline/site` (31 MB) הם committed ולא נבדקים ב-CI — מתיישנים בשקט אחרי כל שינוי
  (ה-pack של הריפו כבר 46 MB). גם צילומי ה-README ו-`export/` (9.7 MB) ידניים.
- `HANDOFF.md` הוא ~1,180 שורות; הכרונולוגיה (סעיף 2) היא רוב הקובץ ומקשה למצוא את המצב הנוכחי.
- `hbus_slave_agent` נשאר placeholder (45 שורות, אף פעם לא פעיל).

### מצב הסבבים (סוף סשן 9)

| סבב | מצב | מה נעשה / מה נשאר |
|---|---|---|
| א ניקיון | **בוצע** | 1–7 כולם: אייקונים, טבלאות, `HISTORY.md`, `fresh.yml` + `check_fresh.py`, `make hooks`, `hbus_slave_agent` נמחק, סרגל ☰ מתחת ל-900px + הודעה חד-פעמית |
| ב הסטודנטית | **בוצע** | 1–6: `start/` + `TASKS.md` (מתודות וקונסטריינטים שהשתנו מול הלאב הקודם מרוקנים, `new`/`super` נשארים), `make check`, Getting started/Home/README מבוססי Verilator + כפתור Codespaces, "See it run" + "Try this" (16 לאבים), Glossary, FAQ |
| ג עומק | לא התחיל | SVA, reset באמצע, `uvm_reg_predictor` + bit-bash/mem-access + RAL coverage, coverpoints חדשים, suspend באמצע |
| ד Bug hunt | **בוצע** | 10 mutants, `make bug-hunt`, `bughunt.yml`, עמוד + מטריצה, test ranking, `history.csv` + גרף. תג על כרטיסי הטסטים במפה — לא נעשה (ההצעה המקורית כללה; הפאנל של הטסט לא מציג "catches N bugs") |
| ה המפה כמורה | לא התחיל | Lab slider, מטריצות במפה, Run replay, תמונות גלים, פריסה לטאבלט, כיוון `FIT_MIN_K`/`LOD_FAR_K` |
| ו העברה | **בוצע** | `docs/mentor/` (8 מפגשים + overview), `make student-kit`, `make docs-pdf` (print-site + Playwright, Mermaid מרונדר ידנית ב-`build_pdf.py`) |
| ז מותנה | ממתין לתמיר | Xcelium, ניסוחי ה-plan מול ה-PDF, לאבים 1–6 בלי עותקים, `restyle`/pyslang |
| ח DUT חי בדפדפן | הצעה (סשן 9 ב') | מודל ברמת מחזור (JS או ה-RTL האמיתי דרך Verilator→WASM) + גלים חיים + HBUS ברמת מחזור, קישורים מהלאבים |
| ט מה-אם (פרמטרים) | הצעה (סשן 9 ב') | `yapp_router #(FIFO_DEPTH, CNT_W)`, `make sweep`, עמוד "What if" עם בוררים על תוצאות מחושבות מראש |
| י Constraints / Sequences / RAL | הצעה (סשן 9 ב') | מגרש constraints עם היסטוגרמות ו-bins, מרכיב סיקוונסים שמייצר קוד, מגרש RAL (desired/mirrored/actual) |
| יא גלים באתר | הצעה (סשן 9 ב') | צופה VCD בדפדפן (Surfer או משלנו), "See it in waves" בכל לאב עם סמן על הרגע המעניין |
| יב תרגול אינטראקטיבי | הצעה (סשן 9 ב') | "נחש את הלוג", משחק Bug hunt, שאלות checkpoint עם ציון והתקדמות ב-localStorage |

**הצעד הבא המומלץ:** מהסבבים האינטראקטיביים — ח קודם (הוא התשתית של ט, יב ושל חלק מ-ה), ואז יב (זול, יום אחד) ו-י; ג (SVA)
עדיין הפער ההנדסי הגדול ונשאר מומלץ בין לבין. לפני כל אחד — שאלות מנחות.

### הצעות חדשות (סשן 9 ב'): ממשקים אינטראקטיביים

**הבקשה של תמיר:** "הצעות נוספות לשיפורים, דברים שיותר קשורים לממשקים אינטראקטיביים — ממשקים עם דוגמאות שאני משנה
פרמטרים, וקטורים, דברים ב-DUT או רגיסטרים". **מה יש היום:** שני ווידג'טים ברמת טרנזקציה ב-`docs/assets/project_map/sim.js`
(`RouterModel` = `yapp_hbus_regs` + דוח סוף-פקטה של `yapp_input_fsm`): סימולטור הרגיסטרים ב-`dut/spec.md` ובצומת ה-DUT
במפה, ו-"packet playground" (קידוד/בדיקת פקטה). אין בהם מחזורים, FIFO, suspend, ערוצי פלט או תזמון HBUS. **תשתית שנבדקה
בקונטיינר:** ‏clang 18 עם target ‏wasm32 (אין wasi-sysroot ואין emscripten — צריך להביא דרך ה-proxy, לא מובטח), Verilator 5.052,
node 22 + Playwright. **חמישה סבבים, כל אחד עצמאי; ח הוא התשתית של ט ו-יב.**

**סבב ח — DUT חי בדפדפן (רמת מחזור).** ‏2–3 סשנים.
‏1. **מנוע**: שתי דרכים, להחליט ב-spike של חצי יום. (א) ה-RTL האמיתי: ‏Verilator `--cc` של `yapp_router` + harness ‏C++ קטן
   (clock, drive, sample) → ‏WASM (‏emscripten או clang+wasi-sysroot) → ‏JS API ‏`step()`, ‏`poke(sig)`, ‏`peek(sig)`. יתרון:
   אין מודל שני שנסחף; חיסרון: טולצ'יין חדש, ~1–2 MB באתר, לא בטוח שניתן להביא בקונטיינר. (ב) מודל JS ברמת מחזור
   (מצבי ה-FSM, שלושה FIFO בעומק 16, ‏suspend, פולס ‏error, תזמון HBUS) — זול יותר, אבל חייב בדיקת נאמנות: להרחיב את
   `test_sim.mjs` כך שיריץ את המודל על הגירוי של טסט אמיתי מהרגרסיה וישווה את הסיגנלים מול ה-FST של Verilator (מחזור
   מול מחזור). ממליץ לנסות (א) קודם; (ב) כגיבוי.
‏2. **ווידג'ט "Packet lab"**: טופס פקטה (כתובת, אורך, ה-payload כווקטור בייטים שאפשר לערוך, parity תקין/שבור), ידיות
   `router_en`, ‏`maxpktsize`, ביטי ‏`en_reg`, מתג ‏`suspend_N` לכל ערוץ, כפתורים "מחזור אחד / עד סוף הפקטה / הרץ";
   רצועת גלים חיה (SVG) של ‏`in_data`, ‏`in_data_vld`, ‏`in_suspend`, מצב ה-FSM, ‏`data_vld_N`, ‏`suspend_N`, מילוי ה-FIFO,
   ‏`error`, ודיאגרמת מצבים קטנה שמדגישה את המצב הנוכחי. התשובה הוויזואלית ל"למה ‏`in_suspend` עלה", "למה הפקטה נזרקה".
‏3. **HBUS ברמת מחזור**: לחיצה על read/write בסימולטור הרגיסטרים מציירת ‏`haddr`/`hdata`/`hen`/`hwr_rd`/`hdata_oe` לאורך
   המחזורים (השאלה שתמיר שאל בתחילת סשן 9, הפעם כאינטראקציה).
‏4. **קישורים מהתוכן**: מצב הווידג'ט ב-URL (‏`?pkt=...&en=0&suspend=1`) כך שדפי הלאבים, ה-spec ו-"Try this" יכולים לפתוח
   תרחיש מוכן ("פתח את זה במגרש"). מקום: עמוד חדש `docs/dut/playground.md` + צומת ה-DUT במפה.
**שאלות לתמיר:** ‏WASM או JS (או spike ואז להחליט); האם רוצים גם את ‏`yapp_fifo` כווידג'ט נפרד (push/pop/full/empty) ללאב
הראשון על ה-DUT.

**סבב ט — "מה אם": פרמטרים של ה-DUT ושל הטסטבנץ'.** ‏1–2 סשנים.
‏1. **פרמטריזציה של ה-RTL**: ‏`yapp_router #(FIFO_DEPTH=16, CNT_W=8, MAXPKT_RST=...)` עם ברירות מחדל זהות להיום (הרגרסיה
   לא משתנה), ‏`make sim ... PARAMS="FIFO_DEPTH=4"` (‏`-G` של Verilator). ידיות TB: טווח אורך פקטה, ‏`packet_delay`, מספר פקטות,
   הסתברות suspend ב-`backpressure_test` — דרך ‏`+args` קיימים או חדשים.
‏2. ‏**`make sweep PARAM=FIFO_DEPTH VALUES=4,8,16,32 TEST=backpressure_test`**: מריץ Verilator, אוסף pass/fail, מחזורי suspend,
   מילוי FIFO מקסימלי, throughput, ערכי counters, קטע גל וקטע לוג; כותב ‏`docs/assets/generated/sweeps/*.json` (committed,
   נבדק ב-`fresh`).
‏3. **עמוד "What if"**: בוררים לכל פרמטר → טבלה + גרף קטן + קטע הגל/הלוג של הצירוף שנבחר. עם המנוע של ח — חי בדפדפן
   במקום מחושב מראש.
‏4. **תרגיל**: "מצא את ה-FIFO הקטן ביותר שלא מרים suspend כש-`packet_delay ≥ 3`", "מה קורה ל-`addr0_cnt_reg` עם ‏CNT_W=4".
**שאלות לתמיר:** אילו פרמטרים (FIFO, רוחב counters, ‏maxpktsize באיפוס, חלון פולס ה-error?); האם הפרמטריזציה נכנסת גם
לעותקי ה-DUT של הלאבים או רק ל-`yapp_project/rtl`.

**סבב י — מגרש Constraints, Sequences ו-RAL.** ‏2 סשנים.
‏1. **מגרש constraints**: טופס לשדות ‏`yapp_packet` (טווח ‏`length`, משקלי ‏`addr`, משקלי ‏`parity_type`, תבנית payload) →
   N דגימות → היסטוגרמות, קוד ה-constraint התואם ב-SystemVerilog (‏`dist`, ‏`inside`, ‏`solve before`, ‏`randomize with`)
   להעתקה ל-`start/`, ואילו ‏bins של ‏`yapp_pkt_cg` ייפגעו ואילו לא (מהגדרות ה-bins ב-`coverage.json`).
‏2. **מרכיב סיקוונסים**: רשימת ספריית הסיקוונסים (מ-`model.json`, תצוגת Sequences) → שרשור לסיקוונס וירטואלי עם חזרות →
   זרם הפקטות, ה-counters בסוף, מה ה-scoreboard יצפה (drops), והקוד של הסיקוונס הווירטואלי (‏`uvm_do` / ‏`start`).
‏3. **מגרש RAL**: טבלת רגיסטרים בשלוש עמודות desired/mirrored/actual וכפתורים ‏`write` ‏`read` ‏`peek` ‏`poke` ‏`mirror`
   ‏`update` ‏`predict`; כל לחיצה מראה אילו עמודות זזו ולמה — החלק המבלבל ביותר בלאב 11, עם ‏`RouterModel` כ-"actual".
**שאלות לתמיר:** סמנטיקה של ‏`dist` כמו ב-SV או אחידה כמו ‏`rand_util`; האם מרכיב הסיקוונסים צריך להתחבר למגרש של ח
(להריץ את הזרם ברמת מחזור).

**סבב יא — גלים אינטראקטיביים באתר.** ‏1–2 סשנים.
‏1. **צופה גלים בדפדפן**: או ‏Surfer (‏WASM, כבר משמש ל-layouts; ~10 MB באתר) או צופה VCD קל משלנו (רשימת סיגנלים, זום,
   סמן, ערכים ב-hover, פענוח אפיקים כמספרים). הרגרסיה שומרת FST לכל ריצה — לחתוך את ה-N µs הראשונים → VCD דחוס לכל טסט
   (תקציב ~100 KB).
‏2. **"See it in waves" בכל לאב**: הגל האמיתי של טסט הלאב עם קבוצות סיגנלים מוכנות וסמן על הרגע המעניין (פקטה ראשונה
   החוצה, suspend ראשון, פולס error), וקישורי טקסט "קפוץ ל-1,240 ns".
‏3. **זול קודם**: ‏tooltips על תמונות ה-SVG הקיימות (‏`wave_first_*.svg`) עם ערכי הסיגנלים בנקודה.
**שאלות לתמיר:** ‏Surfer או משלנו; תקציב גודל לאתר ה-offline.

**סבב יב — תרגול אינטראקטיבי.** ‏1 סשן.
‏1. **"נחש את הלוג"**: בדפי הלאבים — תרחיש קטן (סיקוונס + קונפיגורציית רגיסטרים) → הסטודנטית ממלאת counters צפויים / כמה
   פקטות הועברו / כמה נזרקו → המודל בודק ומסביר. היום על ‏`RouterModel`, אחרי ח על מודל המחזורים.
‏2. **משחק Bug hunt**: בוחרים mutant בלי לדעת מהו, רואים רק את קטע הלוג הנכשל (ואת הגל) ומנחשים קובץ/שורה ב-RTL; חשיפה.
   נבנה על ‏`bug_hunt.json`.
‏3. **שאלות checkpoint עם ציון**: בחירה מרובה עם הסבר, התקדמות ב-localStorage, ווידג'ט "איפה אני" בעמוד הבית (לכל לאב:
   ‏`start/` נבנה? ‏`make check` עבר? שאלות נענו?) — את תוצאת ‏`make check` אפשר להדביק כ-JSON.
**שאלות לתמיר:** האם רוצים שמירת התקדמות מעבר לדפדפן (קובץ ב-`labs/<lab>/progress.json`).

**סדר מומלץ לחלק האינטראקטיבי: ח → יב → י → ט → יא.** ח הוא התשתית ועונה ישירות על הבקשה (משנים וקטורים/רגיסטרים/DUT
ורואים); יב זול ומשתמש במה שכבר יש; י מרחיב למגרש של ה-TB; ט דורש את הפרמטריזציה ב-RTL; יא יקר בגודל. את ג (SVA) כדאי
לשלב אחרי ח. ה (המפה כמורה) חופף: ‏Run replay של ה נבנה בקלות על המנוע של ח.

### הסבבים המוצעים (התוכנית המקורית של תחילת סשן 9)

**סדר מומלץ: א → ב → ד → ג → ה → ו; ז כשיש גישה ל-Xcelium.** א זול ונראה מיד; ב הוא לב המטרה (mentoring); ד נותן כלי
הוראה חזק בסשן אחד ומוכיח את הטסטבנץ'; ג מעמיק את האימות; ה הכי מרשים אבל הכי יקר; ו אחרי שהתוכן מתייצב.
ההערכות הן בסשנים של עבודה (סשן ≈ כמה שעות של עבודה שלי, כולל רגרסיה ובדיקות).

**סבב א — ניקיון ומהירות (חצי סשן, סיכון נמוך, הכול נראה מיד).**
‏1. **אייקונים** בעמוד הבית: `pymdownx.emoji` ב-`mkdocs.yml` (ולבדוק שהאתר ה-offline נושא את ה-SVG בעצמו).
‏2. **טבלת Regression results**: `white-space: nowrap` לעמודת Test, רוחב הדף כמו בעמוד המפה; אותו תיקון לטבלאות ה-Appendix.
‏3. **HANDOFF מפוצל**: הכרונולוגיה (סעיף 2, "מה נעשה") יוצאת ל-`HISTORY.md`; כאן נשארים מצב, כללים, בעיות פתוחות, הסבבים.
‏4. **staleness ב-CI**: job שבונה מחדש את `offline/site` ומשווה (`git diff --exit-code`), ובודק ש-`runs.json` של הדוח המחויב
   מתאים ל-`regress.yaml` (אותם טסטים ואותם seeds). כשלון = הודעה ברורה "run make docs-offline / make sim-report".
‏5. **pre-commit**: `make hooks` מתקין hook שמריץ `sv_style.py --check` ו-`build --check` על הקבצים שהשתנו (בלי תלות חיצונית).
‏6. **`hbus_slave_agent`**: החלטה — למחוק (ה-DUT הוא ה-slave היחיד, `num_slaves = 0`) או לממש responder אמיתי לשימוש
   בלאבים. ההמלצה: למחוק ולתעד במדריך ה-agent למה.
‏7. **טלפון/טאבלט במפה** (מינימום): מתחת ל-900px הסרגל מתקפל לתפריט ☰, המיני-מפה מוסתרת, הודעה "best on a desktop" פעם אחת.
   (הפריסה המלאה — סבב ה.)

**סבב ב — מסלול הסטודנטית (1–2 סשנים; הערך הלימודי הגדול ביותר).**
‏1. **נקודת התחלה לכל לאב** (`labs/<lab>/start/`): הפתרון של הלאב הקודם + הקבצים שהלאב משנה עם גופי מתודות מרוקנים
   ל-`// TODO (step N)` ו-stub שמתקמפל (`uvm_warning("TODO", ...)`), ו-`TASKS.md` עם הצעדים מהדף באתר. מיוצר על ידי
   `scripts/make_start.py` מתוך רשימת ה-"Changed" של כל דף לאב — הסגנון של extern prototypes מתאים לזה בדיוק (הפרוטוטיפים
   נשארים כתוכן עניינים, הסטודנטית ממלאת גופים). CI מוודא שכל `start/` מתקמפל ב-slang.
‏2. **`make check LAB=lab05`**: מריץ את טסטי הלאב ב-Verilator ומשווה את הלוג ל-`expected` של `annotations.yaml` (`tests:`),
   שורה ירוקה/אדומה לכל שלב — "בדוק את עצמך" בלי מנחה. ב-Codespaces זה הכפתור היחיד שהסטודנטית צריכה.
‏3. **Verilator-first**: Getting started ו-`index.md` מתחילים ב-Codespaces / `make sim`; Xcelium הופך לחלופה. כפתור
   "Open in Codespaces" ב-README ובאתר.
‏4. **"See it run" בכל דף לאב**: ציטוט של השורות האמיתיות מהלוג ב-`yapp_project/regression` (snippet מיוצר ב-`build.py`,
   כך שלא מתיישן) + קישור לדף הטסט ב-Regression results ולכרטיס במפה.
‏5. **Glossary** (`docs/glossary.md`, כל מונח מקשר לדף הרכיב) ו-**FAQ / troubleshooting** מתוך `pitfalls.md` ושגיאות
   Verilator/slang אמיתיות שנתקלנו בהן (ה-HANDOFF סעיף 4 מלא בהן).
‏6. **תרגילי "נסי את זה"** בסוף כל לאב: וריאציה קטנה ("שני את ה-constraint כך ש… — איזה טסט נופל ולמה?") עם תשובה
   מוסתרת, ליד שאלות ה-checkpoint הקיימות.

**סבב ג — עומק האימות (1–2 סשנים).**
‏1. **SVA**: `assert property` + `cover property` בשלושת ה-interfaces — `yapp_if` (data_vld רציף לאורך פקטה, suspend עוצר
   את השולח), `channel_if` (handshake של suspend/data_vld), `hbus_if` (write מחזור אחד, read שני מחזורים, `hdata` ב-Z
   כשאף אחד לא מניע). לבדוק קודם מה Verilator 5.052 תומך (`--assert`; `##`, `|->`, `$rose` כן, sequences מורכבות חלקית)
   ולתעד ב-`verilator.md`. באתר: דף "Assertions" בפרק UVM, פריטי TB חדשים ב-Test plan.
‏2. **reset באמצע טסט**: driver/monitor/reference/scoreboard מודעי reset, סיקוונס ב-clock_and_reset, טסט `reset_mid_test`
   (נדחה בסשן 7).
‏3. **RAL**: `uvm_reg_predictor` מפורש מה-monitor של HBUS במקום auto-predict, טסטים עם `uvm_reg_bit_bash_seq` /
   `uvm_mem_access_seq`, RAL coverage במקום `UVM_NO_COVERAGE`.
‏4. **coverpoints חדשים** ("קודם לראות, אחר כך להוסיף"; המודל ב-100%): ערוץ יציאה × back-pressure, `in_suspend`/FIFO מלא,
   פולסי error חופפים, wrap של מונים, gap × parity, מעברי קונפיגורציה בין bursts. collector חדש = `*_coverage.sv` + חיבור + `make map`.
‏5. **suspend באמצע פקטה ב-receiver** — מחוץ ל-spec, ה-RTL תומך (אופציונלי, נדחה בסשן 7).

**סבב ד — "הוכחה שהטסטבנץ' תופס באגים" (סשן אחד).**
‏1. **סט mutants ב-RTL** מאחורי defines (`BUG_PARITY_IGNORED`, `BUG_ADDR3_NOT_DROPPED`, `BUG_OVERSIZED_PASSES`,
   `BUG_COUNTER_SATURATES`, `BUG_FIFO_DEPTH_15`, `BUG_HBUS_READ_ONE_CYCLE`, `BUG_ERROR_PULSE_SHORT`, …), כניסות
   `"yapp_project/tb +define+BUG_X"` עם `expect: errors` ב-`regress.yaml`, job ב-CI. באתר: דף **Bug hunt** — מטריצה
   באג × הטסט שתופס אותו (כמו מטריצת הכיסוי), ובמפה תג על כרטיס הטסט. להוראה: נותנים לסטודנטית build עם mutant ומבקשים
   למצוא אותו עם הלוג והגלים.
‏2. **test ranking** מתוך `coverage.json`: bins ייחודיים לכל טסט, הסט המינימלי שסוגר כיסוי — טבלה ב-Coverage results.
‏3. **`history.csv` + מגמה**: pass/bins/זמן לכל רגרסיה (commit, תאריך), גרף קטן בעמוד Regression results.

**סבב ה — המפה כמורה (1–2 סשנים).**
‏1. **Lab slider**: בתצוגות Hierarchy ו-Environment כפתור "Lab" שמראה את הטסטבנץ' כפי שהיה בלאב N (הלאבים הם snapshots;
   `extract.py` קורא גם `labs/<lab>/tb` + `sv`). הרכיבים מופיעים לאב אחרי לאב, הפאנל אומר מה לאב N הוסיף. הנתון היקר:
   16 חילוצים נוספים ו-`model.json` גדל — אפשר להתחיל מתצוגת Environment בלבד.
‏2. **מטריצות בתוך המפה**: מטריצת הכיסוי (היום באתר + קישור) ומטריצת ה-Bug hunt בפאנל של Test plan.
‏3. **Run replay**: בוחרים ריצה מהרגרסיה וגוררים על ציר הזמן שלה בתצוגת TLM — הרכיב שהאירוע שלו עכשיו נדלק, הפקטה זזה
   על החצים. הנתון: `timeline.md` committed; `timeline.csv` רק מקומי → להוסיף JSON קומפקטי לכל ריצה בדוח.
‏4. **תמונות גלים על הקופסאות**: ה-`wave_*.svg` של ריצה מקושרים מצמתי ה-interfaces וה-DUT.
‏5. **פריסה לטאבלט/טלפון**: סרגל מתקפל, הפאנל כ-bottom sheet, עמודת Source מוסתרת כברירת מחדל (מינימום — סבב א, 7).
‏6. **כיוונים קטנים**: `FIT_MIN_K` (0.5) ו-`LOD_FAR_K` (0.45) ב-`app.js`; ב-Classes "All" להסתיר את חצי הירושה ל-`base_test`
   כברירת מחדל (רק חצי package) או לסדר את הטסטים ברשת מתחתיו.

**סבב ו — העברת הקורס (סשן אחד).**
‏1. **מדריך למנחה לכל מפגש** (`docs/mentor/session-N.md`, שמונה מפגשים לפי טבלת ה-labs index): תזמון, איזו סצנה במפה
   להראות, איזה טסט להריץ בשידור חי, איזה גל לפתוח, שאלות checkpoint לשאול, טעויות נפוצות.
‏2. **ערכת סטודנטית** (`make student-kit`): zip עם `start/` של כל הלאבים, האתר ה-offline והמפה — מה שמחלקים ביום הראשון.
‏3. **שקפים / PDF**: deck לכל מפגש מתוך דפי האתר (marp או reveal, עם ה-exports של המפה), או PDF מודפס של האתר
   (`mkdocs-print-site-plugin`) — תלוי איך תמיר מלמד.

**סבב ז — מותנה בתמיר.**
‏1. **Xcelium** — אם תמיר ישיג גישה: four-state (`z` ב-HBUS, `x` לפני reset), UVM 1.1d, מספרי IMC; לעדכן `unverified.md`
   ואת `expected` ב-`annotations.yaml`.
‏2. **ניסוחי ה-Test plan מול ה-PDF** (`annotations.yaml` `plan:`/`tests:`) — ה-PDF רק אצל תמיר.
‏3. **לאבים 1–6 מצביעים ל-`yapp_project/uvc/yapp`** במקום עותקים (החלטה פתוחה מסשן 5).
‏4. **כלי `restyle`** ל-`uvm_do*`/`uvm_field_*` (אם סטודנטית כותבת עם מאקרו); **`sv_style.py` על pyslang** במקום regex.

**מה תמיר צריך להחליט לפני כל סבב** (השאלות המנחות): א — למחוק את `hbus_slave_agent`? ב — `start/` committed או מיוצר
(zip) בלבד, ומה עומק ה-stub (קובץ שלם או מתודות)? ד — כמה mutants ואילו (7–10 מספיקים), האם הם נראים לסטודנטיות באתר
או רק למנחה? ג — SVA רק ב-interfaces או גם בתוך ה-RTL? ה — להתחיל מ-Lab slider או מ-Run replay? ו — שקפים או PDF?

**הרשימה הישנה (סשן 8 סבב 5)** כוסתה כך: 1 (רגרסיה מחדש) → חלק מכל סבב שמשנה קוד; 2 → ז1; 3 → ג1; 4 → ג2; 5 → ג5; 6 → ג3;
7 → ג4; 8 → ד1; 9 → ד2; 10 → א4; 11 → ד3; 12 → ז4 + א5; 13 → ב3; 14 → ב4; 15 → ב5 + ב1; 16 → ז2; 17 → ה2 + ה6; 18 → א1;
19 → א3.

הטקסט ההיסטורי של העדיפויות מסשן 5 נשמר למטה. לפני כל פריט — לשאול שאלות מנחות.

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

**2. השלמת ה-Test plan.** ✅ CNT-06, ROUTE-04, INJECT_ERROR — בוצעו בסשן 6 סבב 3 (סעיף 2, פריט 6). נשאר רק הסעיף
  של מעבר על הניסוחים מול ה-PDF. הטקסט ההיסטורי:
- לממש את ה-gap **CNT-06** (גלישת counter אחרי 255 פקטות): קודם להחליט עם תמיר מה ההתנהגות הרצויה (ה-RTL עוטף ל-0;
  המפרט שותק) ואז טסט שמשלח 256 פקטות לכתובת אחת ובודק. לממש את ה-partial **ROUTE-04**: constraint `packet_delay == 1`
  (ב-`yapp_pkt_seq` או סיקוונס חדש) + coverpoint על `packet_delay` ב-`yapp_pkt_cg`.
- לעבור עם תמיר על הטקסטים של `plan:` ו-`tests:` מול ה-PDF (רק אצלו) ולתקן ניסוחים/פריטים חסרים.
- כל שינוי: `annotations.yaml` → `make map` (מייצר גם `docs/test-plan.md`); `test_model.py` ייכשל אם טסט לא מוזכר.

**3. עוד שיפורי UX במפה.** בסשן 6 סבבים 4–5 בוצעו 1, 2, 3, 4, 5, 6, 7 (זול), 8, 10 מרשימת 10 ההצעות (עמודת Source
מתקפלת, Legend + שורת סטטוס עם מסלול, Fit width/all, חיפוש + רשימה מקובצת, לשוניות package, רמת פירוט לפי זום,
חצים עמומים ב-Test plan, מטריצת כיסוי באתר, מיני-מפה). 9 (Copy link) היה קיים. **נשאר**: 7 מלא — עקיפת מכשולים
לחצי U/L/אנכיים (ימים של עבודה, נראה רק עם Arrows דלוק). רעיונות שלא נדרשו: מטריצה גם בתוך המפה; סף ה-LOD
(`LOD_FAR_K`) וסף ה-Fit (`FIT_MIN_K`) הם קבועים שאפשר לכוון. לא נבחר בסבב 5: גלגלת = גלילה (תמיר מעדיף זום בגלגלת).

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
make docs-offline                           # האתר האופליין ל-offline/site/ (committed) + build/QcomCourseSite.zip; צריך npm בפעם הראשונה
python3 scripts/gen_waves.py                # waveforms + packet_structure.svg
make map-export                             # SVG/PNG ל-docs/assets/project_map/export/ (ל-commit), PDF ל-build/
make readme-shots                           # בונה את האתר ומצלם מחדש את 5 תמונות ה-README ל-docs/assets/readme/ (PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers בקונטיינר)

# סשן 9: הסטודנטית, ה-bug hunt, ההעברה
make start && make start-check              # labs/<lab>/start/ מחדש (אחרי שינוי בלאב!) + בדיקה שהם עדכניים (CI)
make check LAB=lab05_seq [START=1] [TEST=t] # הטסטים של הלאב ב-Verilator מול scripts/lab_checks.yaml
make see-it-run                             # אחרי make regress: הציטוטים של דפי הלאבים (docs/assets/generated/see_it_run)
make bug-hunt [MUTANT=BUG_X]                # ~1 שעה: 10 קומפילציות; כותב docs/assets/generated/bug_hunt.json; ואז make map
make check-fresh                            # runs.json מול regress.yaml, bug_hunt.json מול mutants.yaml
make docs-pdf                               # offline/QcomCourse.pdf (~2 דק'; mkdocs-print-site-plugin + Playwright)
make student-kit                            # build/StudentKit.zip (צריך offline/site)
make hooks                                  # pre-commit: sv_style על .sv staged + תזכורות map/offline

# בדיקות נקודתיות
python3 scripts/sv_style.py --check --diff path/to/file.sv
python3 scripts/lint.py labs/lab05_seq/tb/run.f
python3 -m pytest scripts/project_map/test_model.py
node scripts/project_map/test_sim.mjs       # בדיקות ה-RouterModel לבד (536 assertions, ~0.1s)

# סימולציה חינמית (Verilator; בקונטיינר: PATH של Verilator — ראה למטה)
bash scripts/setup_sim.sh                   # פעם אחת (בקונטיינר חדש: ~15 דק' בנייה; או PREFIX=...)
cd yapp_project/tb && make sim TEST=backpressure_test WAVES=1 SEED=3
make regress [SEEDS=2] [ONLY=lab09] [WAVES=1]   # מהשורש; טבלה ב-build/sim/regress.md; WAVES=1 = FST + signals CSV לכל ריצה
make regress ONLY=yapp_project SEEDS=3 WAVES=1 && make sim-report ONLY=yapp_project   # הדוח: build/sim/report/ + regression_report.zip
python3 scripts/sim_report.py --only yapp_project --zip
make sim-report ONLY=yapp_project OUT=yapp_project/regression   # הדוח ה-committed (תמיר ביקש אותו בתוך yapp_project)
python3 scripts/sim.py run labs/lab07_integ/tb -t simple_test

# סימולציה (Xcelium — אם תמיר ישיג גישה)
cd yapp_project/tb && make run TEST=reg_function_test
make run-project TEST=router_simple_mcseq_test        # מהשורש
cd labs/lab07_integ/tb && make run TEST=simple_test
cd test_install && xrun -f run.f

# git (הכללים של תמיר)
git push -u origin <הענף של הסשן>          # סשן 5+7: claude/confident-rubin-m1zkvc
git branch -f main <הענף של הסשן> && git push origin main

# מסירה
zip -qr QcommMentoring.zip qcom-mentoring -x "qcom-mentoring/.git/*" "qcom-mentoring/site/*" "qcom-mentoring/offline/*" "qcom-mentoring/build/*" "*/__pycache__/*" "qcom-mentoring/scripts/uvm_src/*" "*.pdf" "qcom-mentoring/uvm_course.md" "*/node_modules/*" "*/tr_db.log"   # tr_db.log = UVM recording, 300+ MB; offline/site (25 MB) goes separately as build/QcomCourseSite.zip (make docs-offline)
# + docs/downloads/yapp_project_map.html  → SendUserFile

# debug של המפה בדפדפן (Playwright מקומי)
node -e "const pw=require('/opt/node-tools/node_modules/playwright'); ..."   # ראה sim_test.mjs בסעיף 7
# ב-console של המפה: projectMap.show("h:root"); projectMap.select("hw_top.dut"); projectMap.sim.send([0x11,0xde,0xad,0xbe,0xef,0x33]); YappSim.checkPacket([...])
```

---

## 10. הערות לסשן הבא

- **(סשן 9) אחרי כל שינוי בקובץ של לאב** — `make start` (ה-start נגזר מ-diff מול הלאב הקודם; `make start-check` ב-CI אדום אחרת).
  כשמשנים טסט/UVC: `make regress` → `make see-it-run` (הציטוטים) → `make sim-report OUT=yapp_project/regression` (מוסיף שורה
  ל-`history.csv`) → `make map` → `make docs-offline` → `make docs-pdf` (ידני, לא ב-CI). כשמשנים RTL: `make bug-hunt` (~שעה) → `make map`.
- **(סשן 9) `lab_checks.yaml`** נכתב מהלוגים האמיתיים; טסט חדש בלאב = שורה ב-`regress.yaml` + רשומה כאן (אחרת רק pass/fail).
- **(סשן 9) ה-PDF:** Material מרנדר Mermaid ל-shadow DOM מ-CDN; `build_pdf.py` משנה `pre.mermaid` ל-`pre.mermaid-src` ומרנדר עם
  ה-Mermaid המקומי (`build/offline_cache`) לפני ההדפסה. `page-break-inside: avoid` משאיר לפעמים חצי עמוד ריק לפני דיאגרמה גדולה.

- **Verilator בקונטיינר חדש:** `bash scripts/setup_sim.sh` (apt + בנייה ~15 דק' ב-4 ליבות, אפשר ברקע). בסשן 6
  נבנה ב-scratchpad (`PATH=<scratchpad>/vl/inst/bin:$PATH`) — לא שורד סשן. בדיקה מהירה בלי לבנות: לדחוף ולקרוא את
  workflow `sim` (job לכל ספרייה, ~3–4 דק').
- **לפני שמתחילים:** `git fetch && git status`; לוודא ש-`main` == הענף של הסשן הקודם (סשן 5:
  `claude/confident-rubin-m1zkvc`). סשן חדש מקבל שם ענף חדש מה-system prompt — לפתוח אותו מ-`origin/main`
  ולעבוד עליו; `main` מקבל ff אחרי כל push.
- **אתר אופליין:** אחרי כל שינוי שמשנה דפים (docs/, `make map` שמייצר test-plan/coverage-results) — `make docs-offline` ו-commit
  ל-`offline/site/`. לבדיקה: סקריפט Playwright ב-scratchpad שפותח `file://.../offline/site/index.html` עם `context.route(/^https?:/, abort)`.
  כשתמיר מוריד zip — להזכיר לחלץ לפני שפותחים.
- **הודעת ה-system reminder** של הסשן נותנת trailer עם session id חדש — להשתמש בו, לא בישן.
- **`make map` הוא חובה** אחרי כל שינוי שמזיז שורות ב-.sv (גם הערות!), אחרי כל שינוי ב-`app.js/app.css/sim.js/sim.css/regmap.yaml/annotations.yaml`,
  **ואחרי כל דוח רגרסיה חדש** (`coverage.json` + `runs.json` → `coverage-results.md`, `docs/regression/`, המפה) — אחרת `map-check` ב-CI אדום. ה-exports (`export/`) **לא** נבדקים — להריץ `make map-export` כשהתמונות משתנות.
- `build --check` לא כותב; `build` ואז `--check`. אל תעשה `| head` על ה-build.
- **צילומי ה-README** (`docs/assets/readme/`, 5 תמונות): לצלם מחדש עם `make readme-shots` אחרי כל שינוי שנראה בממשק
  (תמיר ביטל בסבב 6 את הבקשה הישנה "לא לצלם מחדש"). לבדוק את ה-PNG ב-Read לפני commit.
- אחרי שינוי ב-`app.js/app.css/sim.js/sim.css` — `make map` (ה-standalone inlines אותם, אחרת STALE) ו-`make map-export` (התמונות משתנות). בדיקה ויזואלית: סקריפט Playwright חד-פעמי ב-scratchpad (`check*.mjs` בסשן 5: צילומי מסך של סצנות, גרירה עם `page.mouse`, ה-resizer, הפאנל) ואז Read על ה-PNG.
- **בדיקות ממשק של המפה (סשן 6):** אין טסט DOM בריפו (CI בלי Playwright). השיטה: סקריפט `check.mjs`/`check2.mjs` ב-scratchpad
  (`/opt/node22/bin/node`, Playwright מ-`/opt/node-tools`, `permissions: ["clipboard-write"]`), שטוען את
  `docs/downloads/yapp_project_map.html`, מפעיל `window.projectMap.*` (`switchView/show/select/fit("width"|"all")/zoomBy/
  toggleCode/copyLink`), בודק classes על `.pm` (`code-collapsed`, `lod-far`, `has-sel`, `arrows-off`, `data-view`) ומצלם
  ב-1600 וב-1280; ואז Read על ה-PNG. שימו לב: `afterResize()` מריץ Fit/ensureVisible שוב אחרי 240ms — בסקריפט לחכות
  לפני שמציבים `vp` ידנית (ראה `readme_shots.mjs`).
- **טסט חדש ב-`tb/tests`** דורש ב-`annotations.yaml`: שורה ב-`classes:`, plan ב-`tests:` (stages+expected), אזכור בפריט של `plan:` (אחרת map-check: "tests not named by any item"), ו-`lab_overrides` "TP" אם הוא לא בלאב; ואז `make map` (מייצר גם `docs/test-plan.md`).
- כשמשנים התנהגות של ה-DUT: לעדכן ביחד `yapp_project/rtl`, `router_reference.sv`, הטסטים ב-`tb/tests` + `labs/lab11c`, `docs/dut/spec.md` ("Decisions"), ו-`sim.js` `RouterModel`. כשמשנים כתובת רגיסטר: `regmap.yaml`, `yapp_hbus_regs.sv` localparams, `yapp_regs_c.sv` offsets — CI ישווה.
- הלאבים 1–6 הם עותקים; `labs/lab0{3,4,5,6}*/sv/yapp_tx_agent.sv` וכו' זהים לפרויקט רק אם לא נגעו. לפני עריכה גורפת — `diff` מול `yapp_project/uvc/yapp`.
- `sv_style.py` טקסטואלי; קוד SV חדש "לא רגיל" (labels על begin, `case` כגוף של if, macros רב-שורתיים) — להריץ `--check --diff` ולקרוא לפני `--fix`. slang אחרי כל `--fix`.
- מחלקות שנוצרות ממאקרו ו-`packet_compare.sv` (include בתוך מחלקה) הן חריגים מכוונים לסגנון extern.
- המפה: ids של nodes = נתיבי מופעים (`tb.yapp.agent.monitor`), חומרה `hw_top.dut.u_regs`, מחלקות `cls:<name>`. Deep link: `#view=hierarchy|tlm|classes&node=<id>&scene=<id>&theme=dark`.
- תמיר אוהב: צילומי מסך עם סימונים כשמסבירים UI, תשובות בעברית עם מזהים באנגלית, סיכום סופי לפי סעיפים, ושנשאל שאלות מנחות (AskUserQuestion) לפני שינויים גדולים.
- ה-PDF וה-`uvm_course.md` של תמיר היו ב-`/root/.claude/uploads/...` — **לא קיימים** בקונטיינר חדש ולא בריפו (תמיר העלה את ה-PDF שוב בסשן 5 סבב 4; `pdftotext -layout` עובד עליו). אם צריך פרט מהמפרט, הוא כבר ב-`docs/dut/spec.md`; עמודי ה-DUT ב-PDF הם 5–11.
