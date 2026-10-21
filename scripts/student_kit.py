#!/usr/bin/env python3
"""The student kit: build/StudentKit.zip (make student-kit).

What a student gets on the first day, for a machine with or without internet:
  labs/<lab>/start/   the start point of every lab (TASKS.md inside), plus the tb/Makefile, run.f and
                      the common/ and yapp_project/ sources the labs compile against
  site/               the offline course site (offline/site, built by `make docs-offline`)
  yapp_project_map.html   the interactive map, one file
  QcomCourse.pdf      the site as one PDF (offline/QcomCourse.pdf, built by `make docs-pdf`), when present
  README.txt          what is where and how to start
The finished solutions (labs/<lab>/sv, tb) are not in the kit: they stay on the site and in the repository.
"""

import os
import sys
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "build", "StudentKit.zip")
README = """YAPP Router -- SystemVerilog & UVM course: the student kit
==========================================================

labs/<lab>/start/        where you work: the lab with the bodies of its methods emptied.
                         Read TASKS.md there first. `cd labs/<lab>/start/tb && make sim TEST=<test>`
                         runs a test with Verilator; `make check LAB=<lab> START=1` from the kit's
                         root checks every test of the lab against what the lab page promises.
common/, yapp_project/   the shared code the labs compile (the DUT, the finished UVCs from Lab 7 on).
site/index.html          the course site, works from disk: the labs, the guides, the DUT, the test plan.
yapp_project_map.html    the interactive project map, one file.
QcomCourse.pdf           the site as one PDF, for reading away from the computer.
scripts/, Makefile       the tools (`make help` lists them). Verilator: `bash scripts/setup_sim.sh`
                         once on Ubuntu / WSL2 -- or open the repository in a GitHub Codespace, where
                         it is already installed: https://codespaces.new/tamirgabgab/Qcom-Mentoring

The finished solutions are on the site and in the repository (labs/<lab>/sv and tb), not in this kit.
"""
SKIP = {".git", "build", "site", "offline", "__pycache__", "uvm_src", "xcelium.d", "INCA_libs", "node_modules"}


def add_tree(z, src, dst, keep=None):
    for base, dirs, files in os.walk(src):
        dirs[:] = [d for d in dirs if d not in SKIP and not d.endswith(".shm")]
        for f in files:
            if f.endswith((".log", ".pdf", ".history", ".key")) and f != "QcomCourse.pdf":
                continue
            p = os.path.join(base, f)
            rel = os.path.relpath(p, src)
            if keep and not keep(rel):
                continue
            z.write(p, os.path.join(dst, rel))


def main():
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    site = os.path.join(ROOT, "offline", "site")
    if not os.path.isdir(site):
        sys.exit("offline/site is missing: run `make docs-offline` first")
    n_labs = 0
    with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("StudentKit/README.txt", README)
        for lab in sorted(os.listdir(os.path.join(ROOT, "labs"))):
            start = os.path.join(ROOT, "labs", lab, "start")
            if os.path.isdir(start):
                add_tree(z, start, f"StudentKit/labs/{lab}/start")
                n_labs += 1
        add_tree(z, os.path.join(ROOT, "common"), "StudentKit/common")
        add_tree(z, os.path.join(ROOT, "yapp_project"), "StudentKit/yapp_project",
                 keep=lambda rel: not rel.startswith("regression"))
        add_tree(z, os.path.join(ROOT, "scripts"), "StudentKit/scripts",
                 keep=lambda rel: rel.endswith((".py", ".sh", ".yaml", ".f", ".vlt", ".sv", ".svh", ".mjs")) and not rel.startswith("project_map"))
        add_tree(z, os.path.join(ROOT, "test_install"), "StudentKit/test_install")
        for f in ("Makefile", "LICENSE"):
            if os.path.isfile(os.path.join(ROOT, f)):
                z.write(os.path.join(ROOT, f), f"StudentKit/{f}")
        add_tree(z, site, "StudentKit/site")
        z.write(os.path.join(ROOT, "docs", "downloads", "yapp_project_map.html"), "StudentKit/yapp_project_map.html")
        pdf = os.path.join(ROOT, "offline", "QcomCourse.pdf")
        if os.path.isfile(pdf):
            z.write(pdf, "StudentKit/QcomCourse.pdf")
    print(f"wrote {os.path.relpath(OUT, ROOT)} ({os.path.getsize(OUT) // 1024 // 1024} MB): {n_labs} labs' start/, the site, the map"
          + (", the PDF" if os.path.isfile(pdf) else ""))


if __name__ == "__main__":
    main()
