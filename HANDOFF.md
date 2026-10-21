# HANDOFF.md — YAPP Router UVM course (`tamirgabgab/Qcom-Mentoring`)

> נכתב בסוף הסשן הרביעי (2026-10-07), עודכן בסשן החמישי (2026-10-08), בסשן השישי (2026-10-09: סימולציה
> ב-Verilator) ובסשן השביעי (2026-10-12: לוגים קריאים, tracer של ה-DUT, דוח רגרסיה עם צירי זמן ותמונות גלים).
> סשן חדש לא זוכר כלום — זה המקור היחיד להקשר, יחד עם `CLAUDE.md` בשורש.
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
> CI, קוד) ותוכנית שדרוגים ב-7 סבבים (א–ז) עם סדר מומלץ, הערכות והחלטות שתמיר צריך לקבל — **סעיף 8**. ללא שינוי בקוד.

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

### מה בתהליך ולא גמור
- כלום פתוח בקוד. מה שתמיר דחה במפורש להמשך: reset באמצע טסט, receiver שעוצר באמצע פקטה (סעיף 8 פריט 5), ומהביקורת של
  סשן 8 סבב 3 — תוכן לימודי (סעיף 8 פריט 7) ו-history/trend של הרגרסיה.

### סטטוס git
- **סשן 9 (2026-10-21), ענף `claude/hopeful-gates-acsuwt` (הענף של סשן 6, ממוזג עם `main` = `ef2747c`), `main` ff:**
  commit של HANDOFF (סעיף 8 נכתב מחדש כסבבים). CI לא מושפע (אין שינוי בקוד).
- **סשן 8 סבב 5 (2026-10-14), אותו ענף, `main` ff:** `4b15d5d` (פריסת constraints + R11 + bins), `6f18453` (שמות `m_`
  בתרשימי האתר, נתוני coverage, HANDOFF פריט 19), ואחריו commit ה-HANDOFF/README עם רשימת השדרוגים. CI על `6f18453`:
  lint, docs, sim — ירוקים.
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
- `hbus_slave_agent` הוא placeholder (ה-router הוא ה-slave היחיד).
- ~~Mermaid מ-CDN — האתר offline מאבד דיאגרמות~~ — סשן 8ב: `offline/site/` נושא את mermaid בעצמו. האתר הציבורי עדיין מ-unpkg (תקין).
- `offline/site/` **לא נבדק ב-CI**: אחרי שינוי ב-`docs/` (או ב-map/coverage שמייצרים דפים) להריץ `make docs-offline` ולעשות commit,
  אחרת הוא מתיישן. ה-diff גדול (כל ה-HTML משתנה כשה-nav משתנה).
- **באג באתר הציבורי ובאופליין:** חסר `pymdownx.emoji` ב-`mkdocs.yml`, ולכן בכרטיסים של עמוד הבית רואים `:material-chip:{ .lg .middle }`
  ו-`:octicons-arrow-right-24:` כטקסט במקום אייקונים (תמיר ראה בצילום). לא תוקן — מחכה לאישור.
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

### הסבבים המוצעים

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
