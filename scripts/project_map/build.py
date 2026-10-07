#!/usr/bin/env python3
"""
build.py -- generate the project map.

    python3 -m scripts.project_map.build            # model.json + standalone HTML
    python3 -m scripts.project_map.build --check    # also run the consistency checks and fail
                                                    # if the committed files are out of date

Outputs (committed, so the site and the offline file never need pyslang):
    docs/assets/project_map/model.json
    docs/downloads/yapp_project_map.html
"""
import argparse
import json
import os
import re
import subprocess
import sys

import yaml
from jinja2 import Template

from . import extract, layout, model

ROOT = extract.ROOT
HERE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(ROOT, "docs", "assets", "project_map")
MODEL_JSON = os.path.join(ASSETS, "model.json")
STANDALONE = os.path.join(ROOT, "docs", "downloads", "yapp_project_map.html")


def site_config():
    with open(os.path.join(ROOT, "mkdocs.yml"), encoding="utf-8") as fh:
        txt = fh.read()
    repo = re.search(r"^repo_url:\s*(\S+)", txt, re.M)
    site = re.search(r"^site_url:\s*(\S+)", txt, re.M)
    return (repo.group(1) if repo else ""), (site.group(1) if site else "")


def build(write=True):
    ann = model.load_annotations()
    m = model.build_model(ann)
    scenes, where = layout.build_scenes(m, ann)
    m["scenes"] = scenes
    m["where"] = where
    repo_url, site_url = site_config()
    m["meta"]["repo_url"] = repo_url
    m["meta"]["site_url"] = site_url
    # compact, deterministic JSON
    model_json = json.dumps(m, indent=None, separators=(",", ":"), sort_keys=True, ensure_ascii=False)
    with open(os.path.join(ASSETS, "app.css"), encoding="utf-8") as fh:
        app_css = fh.read()
    with open(os.path.join(ASSETS, "app.js"), encoding="utf-8") as fh:
        app_js = fh.read()
    with open(os.path.join(HERE, "templates", "standalone.html.j2"), encoding="utf-8") as fh:
        tpl = Template(fh.read())
    html = tpl.render(
        app_css=app_css, app_js=app_js,
        model_json=model_json.replace("</", "<\\/"),
        repo_url=repo_url, docs_base=site_url, page_url=(site_url + "project-map/") if site_url else "",
    )
    if write:
        os.makedirs(os.path.dirname(STANDALONE), exist_ok=True)
        with open(MODEL_JSON, "w", encoding="utf-8") as fh:
            fh.write(model_json)
        with open(STANDALONE, "w", encoding="utf-8") as fh:
            fh.write(html)
    return m, model_json, html


def check(m, model_json, html):
    from . import test_model
    test_model.run_all(m, model_json, html)
    # staleness: the committed files must match what we just generated
    stale = []
    for path, content in ((MODEL_JSON, model_json), (STANDALONE, html)):
        try:
            with open(path, encoding="utf-8") as fh:
                if fh.read() != content:
                    stale.append(os.path.relpath(path, ROOT))
        except OSError:
            stale.append(os.path.relpath(path, ROOT))
    if stale:
        print("STALE: regenerate with `make map` and commit:", ", ".join(stale))
        return False
    return True


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--check", action="store_true", help="run the checks and verify the committed files are current")
    ns = ap.parse_args()
    m, model_json, html = build(write=not ns.check)
    print(f"project map: {len(m['nodes'])} nodes, {len(m['edges'])} edges, {len(m['scenes'])} scenes, "
          f"model {len(model_json) // 1024} KB, standalone {len(html) // 1024} KB")
    if m["unresolved"]:
        print("unresolved connections:")
        for u in m["unresolved"]:
            print("  ", u)
        sys.exit(1)
    if ns.check and not check(m, model_json, html):
        sys.exit(1)
    if not ns.check:
        print(f"wrote {os.path.relpath(MODEL_JSON, ROOT)} and {os.path.relpath(STANDALONE, ROOT)}")


if __name__ == "__main__":
    main()
