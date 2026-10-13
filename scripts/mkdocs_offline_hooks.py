"""MkDocs hooks for the offline build (mkdocs-offline.yml).

The public site loads Mermaid from unpkg.com and links pages as directories. Neither works from
a folder opened with file://, so this hook ships Mermaid (and the iframe-worker shim that the
search needs under file://) inside the site, loads Mermaid before Material's bundle (which then
skips the CDN), and fixes the one raw-HTML path in the docs.
"""

import shutil
from pathlib import Path

CACHE = Path("build/offline_cache")
# cached file -> path inside the site; scripts/build_offline_site.py fills the cache with npm
VENDOR = {
    "mermaid.min.js": "assets/vendor/mermaid.min.js",
    "iframe-worker.js": "assets/vendor/iframe-worker.js",
}
MERMAID_DEST = VENDOR["mermaid.min.js"]


def on_post_page(output, page, config):
    depth = page.file.dest_uri.count("/")
    prefix = "../" * depth
    # project-map.md embeds the map with a raw <iframe>; MkDocs does not rewrite raw HTML paths.
    output = output.replace('src="../downloads/', 'src="' + prefix + 'downloads/')
    if 'class="mermaid"' in output:
        tag = '<script src="' + prefix + MERMAID_DEST + '"></script>'
        output = output.replace("</head>", tag + "</head>", 1)
    return output


def on_post_build(config):
    for name, rel in VENDOR.items():
        src = CACHE / name
        if not src.exists():
            raise SystemExit(
                "offline build: " + str(src) + " is missing (run `make docs-offline`, "
                "which fetches it with npm first)"
            )
        dest = Path(config["site_dir"]) / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dest)
