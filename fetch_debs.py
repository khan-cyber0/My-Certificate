#!/usr/bin/env python3
"""Debian'dan Linux yadrosi va busybox-static .deb fayllarini yuklaydi."""
import lzma, os, re, sys, urllib.request

MIRROR = os.environ.get("MIRROR", "https://deb.debian.org/debian")
SUITE = os.environ.get("SUITE", "stable")
OUT = sys.argv[1]

def get(url):
    with urllib.request.urlopen(url) as r:
        return r.read()

idx = lzma.decompress(get(f"{MIRROR}/dists/{SUITE}/main/binary-amd64/Packages.xz")).decode()
pkgs = {}
for block in idx.split("\n\n"):
    m = re.search(r"^Package: (.+)$", block, re.M)
    f = re.search(r"^Filename: (.+)$", block, re.M)
    if m and f:
        pkgs[m.group(1)] = f.group(1)

# linux-image-amd64 metapaketi haqiqiy yadro paketiga bog'liq
meta = next(b for b in idx.split("\n\n") if re.search(r"^Package: linux-image-amd64$", b, re.M))
dep = re.search(r"^Depends: (linux-image-[\w.+-]+)", meta, re.M).group(1)

os.makedirs(OUT, exist_ok=True)
for name in (dep, "busybox-static"):
    path = os.path.join(OUT, name + ".deb")
    print("yuklanmoqda:", name)
    open(path, "wb").write(get(f"{MIRROR}/{pkgs[name]}"))
