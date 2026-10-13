# -*- coding: utf-8 -*-
r"""
build.py — 用 XeLaTeX 重新编译仓库内全部实验报告。

对每个 .tex 源文件执行多趟 xelatex(含目录/交叉引用的跑三趟), 编译结束后
清除 .aux/.log/.out/.toc/.synctex.gz 等中间产物, 仅保留 .tex 源与 .pdf 成品。

用法:
  E:\\python\\python.exe tools/build.py
"""
import os
import re
import glob
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
XELATEX = r"D:\texlive\2026\bin\windows\xelatex.exe"

ARTIFACTS = (".aux", ".log", ".out", ".toc", ".synctex.gz", ".lof", ".lot", ".bbl", ".blg", ".nav", ".snm")


def passes_for(tex_path: str) -> int:
    with open(tex_path, "r", encoding="utf-8", errors="ignore") as f:
        src = f.read()
    return 3 if "\\tableofcontents" in src or "\\ref{" in src else 2


def build_one(tex_path: str):
    folder = os.path.dirname(tex_path)
    name = os.path.basename(tex_path)
    n = passes_for(tex_path)
    log_tail = ""
    for i in range(n):
        r = subprocess.run(
            [XELATEX, "-interaction=nonstopmode", "-file-line-error", name],
            cwd=folder,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        log_tail = r.stdout.decode("utf-8", errors="ignore")
    errors = [ln for ln in log_tail.splitlines() if ln.startswith("!") or "Error" in ln]
    pdf = os.path.splitext(tex_path)[0] + ".pdf"
    ok = os.path.exists(pdf)
    tag = "OK " if ok and not errors else ("ERR" if errors else "?? ")
    print(f"[{tag}] {os.path.relpath(tex_path, REPO)}  (passes={n})")
    for e in errors[:6]:
        print("        ", e.strip())


def main():
    tex_files = []
    for root, dirs, files in os.walk(REPO):
        if os.sep + "tools" in root:
            continue
        for f in files:
            if f.endswith(".tex"):
                tex_files.append(os.path.join(root, f))
    tex_files.sort()
    print(f"共 {len(tex_files)} 个报告\n")
    for t in tex_files:
        build_one(t)
    # 清理中间产物
    removed = 0
    for root, dirs, files in os.walk(REPO):
        for f in files:
            if f.endswith(ARTIFACTS):
                os.remove(os.path.join(root, f))
                removed += 1
    print(f"\n清理中间产物 {removed} 个")


if __name__ == "__main__":
    main()
