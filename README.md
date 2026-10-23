# A-messy-repository

本科阶段各类课程**结课报告、实验与编程大作业**的归档仓库。大部分文档使用 LaTeX（XeLaTeX）排版，源码与成品 PDF 一并提交，便于复现与查阅；另有 MATLAB 脚本与 Python 桌面程序。

> 本仓库已做**匿名化处理**，可放心公开分享（详见下方「隐私说明」）。

---

## 隐私与匿名化说明

为公开分享，上传副本已对全部个人可识别信息做脱敏处理：

- 真实姓名统一以昵称 **VesperaZephyr** 署名；
- 学号、手机号、邮箱、籍贯、出生年份等直接个人标识一律移除或替换为占位符（如 `（电话已隐匿）`、`anonymous@example.edu`）；
- 所属院校以「某高校」代称；
- 小组作业中其他同学的真实姓名以「同学甲 / 乙 / 丙 / 丁」代替。

原始未脱敏的本地源文件未做任何改动，仅对上传副本做了上述替换。

---

## 目录结构

| 文件夹 | 对应内容 | 说明 |
| :-- | :-- | :-- |
| `matlab-elective-course-report/` | 公共选修课《Matlab 编程与实践》结课报告 | 函数逼近：最佳一致逼近、最佳平方逼近、Padé 逼近、Lagrange–Chebyshev 插值（含 MATLAB 源码与对比图） |
| `matlab-practice-report/` | 专业实践课《Matlab 实践》结课报告 | 线性方程组迭代法：Jacobi / Gauss–Seidel / SOR 的收敛性可视化（残量收敛曲线、松弛因子影响） |
| `mining-safety-engineering/` | 矿业安全工程课程结课论文 | 煤层瓦斯参数原位监测技术建模；含 MATLAB 数据可视化代码（ROC 曲线、预测曲线、误差箱线图）与生成图 |
| `numerical-analysis-practice/` | 《数值分析实践》全部实验 | 6 个实验 + 综合报告 + 桥梁振动模态大作业（已匿名化，详见子目录 `README.md`） |
| `new-energy-report/` | 《新能源技术与应用》结课报告 | 课程结课论文（LaTeX 排版） |
| `python-final-homework/` | Python 结课大作业 | 基于 PyQt + SymPy + LaTeX 的数学计算与公式渲染桌面程序（含结课报告） |

> 另有 `大创答辩`、`大学物理研讨报告`、`补充材料`、`科技论文写作` 等课程资料按作者意愿**未纳入**本公开仓库。

---

## 各模块简介

- **MATLAB 结课报告（公共选修 / 专业实践）**：分别围绕函数逼近与线性方程组迭代法，给出理论推导、MATLAB 实现与可视化结果。
- **矿业安全工程**：以煤层瓦斯参数原位监测为背景，建立数据处理与误差分析模型，并用 MATLAB 绘制 ROC 曲线、预测曲线与误差箱线图。
- **数值分析实践**：覆盖非线性方程求根、线性方程组求解、Lagrange 插值 / Runge 现象、最小二乘拟合、数值积分、微分方程数值解法，以及桥梁振动模态综合大作业，结构与匿名化说明见其子目录 `README.md`。
- **新能源技术与应用**：课程结课论文。
- **Python 结课大作业**：一个桌面数学工具，支持极限、求导、积分、化简等运算，并调用 LaTeX 将结果渲染为公式图片（详见 `python-final-homework/结课作业报告.pdf`）。

---

## 构建与运行

### LaTeX 文档
使用 XeLaTeX 编译（部分文档需 Biber 或多遍编译以获得正确交叉引用）：

```bash
xelatex <file>.tex        # 中文文档依赖 ctex / Fandol 字体
# 若含参考文献：
# xelatex <file>.tex && biber <file> && xelatex <file>.tex && xelatex <file>.tex
```

### MATLAB 脚本
用 MATLAB 直接运行对应 `.m` 文件即可复现图表（如 `fig_roc_curve.m`、`JacobiTestAndPlot.m` 等）。

### Python 程序
`python-final-homework/final homework.py` 依赖 PyQt5、SymPy、matplotlib 等：

```bash
pip install pyqt5 sympy matplotlib
python "final homework.py"
```

---

## 许可证

代码与文档以 [MIT 许可证](LICENSE) 发布。
