# -*- coding: utf-8 -*-
"""
prepare.py — 将原始实验报告目录整理为可公开发布的仓库内容。

职责:
  1. 仅挑选源文件(.tex / .m / .png)复制到整理后的目录结构;
     排除 Word 导出件(.docx)、任务书、编译中间产物(.aux/.log/.out/.toc/.synctex.gz/.zip)
     以及模板文件; PDF 一律不复制, 由 LaTeX 重新编译生成。
  2. 对文本源文件做匿名化替换(去真名 / 去学号 / 去班级 / 去指导教师 / 去机位),
     全程按字节读写, 保持 CRLF 行尾与 UTF-8 无 BOM。

用法:
  E:\\python\\python.exe tools/prepare.py
"""
import os
import shutil

SRC_ROOT = r"F:\LaTeXFiles\乱七八糟的任务\数值分析实践"
DST_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# 源目录 -> 目标目录
FOLDERS = {
    "日常作业": "01_日常作业",
    "实验1 非线性方程求根": "02_实验1_非线性方程求根",
    "实验2 线性方程组的求解": "03_实验2_线性方程组的求解",
    "实验3 Lagrange插值和Runge现象": "04_实验3_Lagrange插值和Runge现象",
    "实验4_最小二乘拟合": "05_实验4_最小二乘拟合",
    "实验5_数值积分方法实验": "06_实验5_数值积分方法实验",
    "实验6_微分方程数值解法实验": "07_实验6_微分方程数值解法实验",
    "实验1和实验2的综合实验报告": "08_综合报告_实验1-2",
    "实验3和实验4的综合实验报告": "09_综合报告_实验3-4",
    "实验5和实验6的综合实验报告": "10_综合报告_实验5-6",
    "数值分析实践 综合实验报告": "11_综合报告_桥梁振动模态",
}

# 允许复制的扩展名
KEEP_EXT = {".tex", ".m", ".png"}

# 明确排除的文件名(模板 / 任务书 / 冗余导出件)
EXCLUDE_NAMES = {
    "《数值分析实践》综合实验报告 - 模板.tex",
}

# 匿名化替换表(按顺序应用)
REPLACEMENTS = [
    ("刘晨希", "VesperaZephyr"),          # 真名 -> 公开昵称
    ("10242314", "114514"),               # 真实学号 -> 占位学号(末两位仍为 14, 保持个性化参数一致)
    ("凌   思   涛", ""),                  # 指导教师
    ("凌  思  涛", ""),
    ("凌思涛", ""),
    ("数学与应用数学2024级1班", "数学与应用数学"),  # 班级 -> 仅保留专业
    ("数 B320", ""),
    ("数 B316", ""),
    ("数B320", ""),
    ("数B316", ""),
]

TEXT_EXT = {".tex", ".m"}


def anonymize(data: bytes) -> bytes:
    text = data.decode("utf-8")
    for old, new in REPLACEMENTS:
        text = text.replace(old, new)
    return text.encode("utf-8")


def main():
    copied = 0
    for src_name, dst_name in FOLDERS.items():
        src_dir = os.path.join(SRC_ROOT, src_name)
        dst_dir = os.path.join(DST_ROOT, dst_name)
        os.makedirs(dst_dir, exist_ok=True)
        for f in sorted(os.listdir(src_dir)):
            full = os.path.join(src_dir, f)
            if not os.path.isfile(full):
                continue
            ext = os.path.splitext(f)[1].lower()
            if ext not in KEEP_EXT:
                continue
            if f in EXCLUDE_NAMES:
                continue
            dst = os.path.join(dst_dir, f)
            if ext in TEXT_EXT:
                with open(full, "rb") as fp:
                    data = fp.read()
                with open(dst, "wb") as fp:
                    fp.write(anonymize(data))
            else:
                shutil.copy2(full, dst)
            copied += 1
            print("  +", os.path.join(dst_name, f))
    print(f"\n共复制 {copied} 个文件到 {DST_ROOT}")


if __name__ == "__main__":
    main()
