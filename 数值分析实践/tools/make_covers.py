# -*- coding: utf-8 -*-
r"""
make_covers.py — 生成匿名化后的实验报告封面 PDF。
原封面由 Word/PDF 直接生成并含真实姓名、学号、班级、指导教师与机位信息。
这里用 LaTeX 重新排版一份同等样式、但个人字段留空的封面, 输出为各综合报告
目录下的 `封面.pdf`, 供正文 \includepdf 引用。

用法:
  E:\\python\\python.exe tools/make_covers.py
"""
import os
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
COVER_SRC = os.path.join(REPO, "tools", "covers")
XELATEX = r"D:\texlive\2026\bin\windows\xelatex.exe"

TEMPLATE = r"""\documentclass[12pt,a4paper]{ctexart}
\usepackage[margin=2.4cm,top=2.0cm,bottom=2.0cm]{geometry}
\usepackage{array}
\setCJKmainfont{SimSun}[AutoFakeBold=2.5]
\pagestyle{empty}
\setlength{\parindent}{0pt}
\begin{document}
\noindent\rule{\textwidth}{0.6pt}

\vspace{0.12cm}
\hfill
\begin{tabular}{|c|c|}
\hline
\rule{0pt}{15pt}\hspace{4pt}得\ \ 分\hspace{4pt} & \rule{0pt}{15pt}\hspace{3.0cm} \\
\hline
\end{tabular}

\vspace{2.5cm}
\begin{center}
{\zihao{2}\bfseries __TITLE__}\\[0.5cm]
{\zihao{4} __TERM__}
\end{center}

\vspace{1.3cm}
\begin{center}
\renewcommand{\arraystretch}{1.9}
\begin{tabular}{|c|p{9.2cm}|}
\hline
__ROWS__\end{tabular}
\end{center}

\vspace{3.1cm}
\begin{center}
\renewcommand{\arraystretch}{2.15}
\begin{tabular}{r@{\ }l}
班\qquad 级： & \underline{\makebox[5.4cm][c]{__CLASS__}} \\[0.15cm]
学\qquad 号： & \underline{\makebox[5.4cm][c]{__ID__}} \\[0.15cm]
姓\qquad 名： & \underline{\makebox[5.4cm][c]{__NAME__}} \\[0.15cm]
指导教师： & \underline{\makebox[5.4cm][c]{__TEACHER__}} \\
\end{tabular}
\end{center}

\vfill
\begin{center}
{\zihao{4} __DATE__}
\end{center}
\end{document}
"""

# 各封面: 目标目录 / 标题 / 实验名称行 / 日期
COVERS = [
    {
        "dir": "08_综合报告_实验1-2",
        "title": "《数值分析实践》综合实验报告",
        "rows": [
            ("实验名称1", "个性化非线性方程迭代求解及AI生成代码的批判性验证"),
            ("实验名称2", "线性方程组直接解法与迭代解法的实现、对比及应用"),
        ],
        "date": "2026 年 6 月 8 日",
    },
    {
        "dir": "09_综合报告_实验3-4",
        "title": "《数值分析实践》综合实验报告",
        "rows": [
            ("实验名称3", "Lagrange插值和Runge现象"),
            ("实验名称4", "最小二乘拟合及其应用"),
        ],
        "date": "2026 年 4 月 29 日",
    },
    {
        "dir": "10_综合报告_实验5-6",
        "title": "《数值分析实践》实验报告",
        "rows": [
            ("实验名称5", "数值积分方法的探究与比较分析"),
            ("实验名称6", "微分方程数值解法的探究与比较分析"),
        ],
        "date": "2026 年 6 月 5 日",
    },
    {
        "dir": "11_综合报告_桥梁振动模态",
        "title": "《数值分析实践》综合实验报告",
        "rows": [
            ("实验名称", "桥梁振动模态的数值分析与模拟"),
        ],
        "date": "2026 年 5 月 24 日",
    },
]


def build_tex(cover):
    rows = ""
    for label, content in cover["rows"]:
        rows += f"{label} & {content} \\\\\n\\hline\n"
    return (
        TEMPLATE.replace("__TITLE__", cover["title"])
        .replace("__TERM__", "（2025-2026-2）")
        .replace("__ROWS__", rows)
        .replace("__CLASS__", "数学与应用数学")
        .replace("__ID__", "")
        .replace("__NAME__", "VesperaZephyr")
        .replace("__TEACHER__", "")
        .replace("__DATE__", cover["date"])
    )


def main():
    os.makedirs(COVER_SRC, exist_ok=True)
    for cover in COVERS:
        name = cover["dir"]
        src_tex = os.path.join(COVER_SRC, f"cover_{name}.tex")
        with open(src_tex, "wb") as f:
            f.write(build_tex(cover).replace("\n", "\r\n").encode("utf-8"))

        out_dir = os.path.join(REPO, cover["dir"])
        print(f"[cover] {name} ...")
        subprocess.run(
            [
                XELATEX,
                "-interaction=nonstopmode",
                "-halt-on-error",
                f"cover_{name}.tex",
            ],
            cwd=COVER_SRC,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        produced = os.path.join(COVER_SRC, f"cover_{name}.pdf")
        target = os.path.join(out_dir, "封面.pdf")
        if os.path.exists(produced):
            os.replace(produced, target)
            print(f"        -> {target}")
        else:
            print(f"        !! 生成失败: {produced}")
        # 清理中间产物
        for ext in (".aux", ".log", ".out"):
            p = os.path.join(COVER_SRC, f"cover_{name}{ext}")
            if os.path.exists(p):
                os.remove(p)


if __name__ == "__main__":
    main()
