#!/usr/bin/env python3
"""Build the course site as a folder that opens from disk, and zip it.

    make docs-offline            (needs mkdocs-material and npm)

Result:
    offline/site/                the site, committed; open offline/site/index.html
    build/QcomCourseSite.zip     the same folder as site/ inside a zip (no server, no internet)

Two small JavaScript files are fetched with npm once and cached in build/offline_cache/:
Mermaid (the diagrams) and iframe-worker (the search under file://). The public site loads
both from unpkg.com; mkdocs-offline.yml + scripts/mkdocs_offline_hooks.py ship them instead.
"""

import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CACHE = ROOT / "build" / "offline_cache"
OUT = ROOT / "offline"
ZIP = ROOT / "build" / "QcomCourseSite.zip"

# npm package, file inside the package, name in the cache
VENDOR = [
    ("mermaid@11", "dist/mermaid.min.js", "mermaid.min.js"),
    ("iframe-worker@1", "shim/index.js", "iframe-worker.js"),
]


def fetch_vendor():
    CACHE.mkdir(parents=True, exist_ok=True)
    for package, inner, name in VENDOR:
        if (CACHE / name).exists():
            continue
        with tempfile.TemporaryDirectory() as tmp:
            tgz = subprocess.run(
                ["npm", "pack", package, "--silent"], cwd=tmp, check=True,
                capture_output=True, text=True,
            ).stdout.strip().splitlines()[-1]
            subprocess.run(["tar", "xzf", tgz, "-C", tmp], cwd=tmp, check=True)
            shutil.copyfile(Path(tmp) / "package" / inner, CACHE / name)
        print("fetched " + name)


def build_site():
    site = OUT / "site"
    if site.exists():
        shutil.rmtree(site)
    subprocess.run(
        [sys.executable, "-m", "mkdocs", "build", "--strict", "-f", "mkdocs-offline.yml",
         "-d", str(site)],
        cwd=ROOT, check=True,
    )
    return site


def zip_site(site):
    if ZIP.exists():
        ZIP.unlink()
    with zipfile.ZipFile(ZIP, "w", zipfile.ZIP_DEFLATED) as z:
        for f in sorted(site.rglob("*")):
            if f.is_file():
                z.write(f, Path("site") / f.relative_to(site))
    print("wrote " + str(ZIP.relative_to(ROOT)) + " (" + str(ZIP.stat().st_size // 1024) + " KB)")


def main():
    fetch_vendor()
    if "--vendor-only" in sys.argv:      # scripts/build_pdf.py only needs the cached Mermaid
        return
    site = build_site()
    zip_site(site)
    print("open " + str((site / "index.html").relative_to(ROOT)))


if __name__ == "__main__":
    main()
