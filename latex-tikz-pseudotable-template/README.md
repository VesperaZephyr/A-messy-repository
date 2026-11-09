# TikZ 伪表格模板（通用版 v2）

把 **Word 表格「LaTeX 化」** 的 TikZ 方案。本模板源自「数值分析实践综合实验报告」中用到的一个排版片段，整理为可独立复用的模块。

> 来源：知乎专栏《[TikZ绘图实例] 在LaTeX中实现伪表格绘制，实现Word表格LaTeX化》  
> https://zhuanlan.zhihu.com/p/2046401005638754922  
> 整理重制：VesperaZephyr

## 为什么需要「伪表格」

标准 `tabular` 在以下场景要么繁琐、要么做不到：

- 表头 / 单元格**着色**、**隔行底纹**；
- **跨行（multirow）/ 跨列（multicolumn）/ 任意矩形区块合并**，且合并处网格线不能「穿线」；
- 各列**不同对齐**；
- **自定义边框**（只画竖线、只画横线、booktabs 风格、局部断线）。

「伪表格」的思路是：**文字用 TikZ 的 `matrix of nodes` 排版（天然支持中文换行、逗号、公式），边框与填充用 TikZ 自己画**，从而 100% 可控。

## 三套能力

| 方法 | 思路 | 适合 |
| :-- | :-- | :-- |
| 方法一 | `tikzpagenodes` + `shipout/background`，在**背景层**画整页边框与首页 2×6 信息条 | 报告封面信息区（姓名 / 学号 / 班级 …） |
| 方法二 | 基于 `tikz matrix of nodes` 的**声明式表格引擎**（推荐） | 绝大多数数据表：表头、底纹、合并、对齐、边框全配置 |
| 方法三 | `\drawgridspec` **纯手绘规则网格** | 需要不对称 / 局部断线等完全自定义边框的极端版式 |

## 快速上手（方法二）

```latex
\tcols{4}                          % 列数
\trows{5}                          % 行数
\tcolwidths{0.16,0.30,0.20,0.34}  % 列相对宽（留空=均分）
\theaderrow{1}                     % 表头行号；0=无表头
\zebratrue                        % 隔行底纹（\zebrafalse 关闭）
\tgridstyle{all}                   % 边框：all|outer|hlines|vlines
\tcolalign{1}{left}                % 第 1 列左对齐（其余默认居中）
\preparetable                      % 读配置、算列宽、生成样式

\begin{center}
\begin{tikzpicture}
  \matrix (m)[tblstyle]{
    方法   & 参数         & 数值结果 & 备注    \\
    二分法 & tol=1e-6     & 0.739085 & 精度满足 \\
    牛顿法 & x0=1.0       & 0.739085 & 收敛快   \\
    割线法 & x0=1,x1=0.5  & 0.739085 & 需两点   \\
    说明   &             &          &         \\  % 末行首格有字，2~4 列留给合并
  };
  % 末行第 2~4 列跨列合并（被合并的格子在 matrix 里留空）：
  \mergeblock[fill=white, draw=black]{5}{2}{1}{3}{三种迭代法对方程 $x=\cos x$ 求根，结果一致}
  \finishtable                       % 按 \tgridstyle 收尾画边框
\end{tikzpicture}
\end{center}
```

编译（**至少 2 遍**，背景层 `remember picture` 需二次编译才能拿到坐标）：

```bash
xelatex tikz-pseudotable-template.tex
xelatex tikz-pseudotable-template.tex
```

## 配置项 API（方法二）

| 命令 | 默认值 | 作用 |
| :-- | :-- | :-- |
| `\tcols{n}` | 4 | 列数 |
| `\trows{n}` | 5 | 行数 |
| `\tcolwidths{a,b,c,…}` | 空（均分） | 列相对宽度（比例，会自动归一化） |
| `\ttablew{宽度}` | `\textwidth` | 整表总宽（如 `0.8\textwidth`） |
| `\theaderrow{n}` | 1 | 表头行号；`0` 表示无表头 |
| `\zebratrue` / `\zebrafalse` | true | 隔行底纹开关 |
| `\tgridstyle{style}` | `all` | 边框风格：`all` 全网格 / `outer` 仅外框 / `hlines` 仅横线 / `vlines` 仅竖线 |
| `\tminrow{尺寸}` | `0.72cm` | 单元格最小高度 |
| `\tcolalign{列号}{left\|center\|right}` | center | 逐列对齐（可选） |

调用顺序：**先配置 → `\preparetable` → 写 `\matrix` → 需要合并就 `\mergeblock` → `\finishtable`**。

## 单元格着色与合并

- **整格高亮**：在 matrix 单元格内写成 `|[fill=tblhi]| 文字`（颜色见下）。
- **合并单元格**：`\mergeblock[样式]{起始行}{起始列}{跨行}{跨列}{文字}`
  - 跨行 / 跨列 / 矩形区块合并都用它，合并区域内部网格线会被自动覆盖（白色填充 + 重描合并区外框），不会「穿线」；
  - 被合并覆盖的格子在 `\matrix` 里**留空**即可；
  - 若合并落在表头，传 `fill=tblhead` 保持表头颜色。

预置颜色：`tblhead`（表头淡蓝 `RGB{217,236,247}`）、`tblrow`（隔行淡色 `RGB{245,248,252}`）、`tblhi`（高亮暖橙 `RGB{255,235,205}`），可在导言区自行改 `definecolor`。

## 四种边框风格

| `style` | 效果 |
| :-- | :-- |
| `all` | 全网格（外框粗 + 内线细） |
| `outer` | 仅外框 |
| `hlines` | 仅横线 + 外框（类似 booktabs 无竖线观感） |
| `vlines` | 仅竖线 + 外框（首列左对齐 + 仅竖线很适合参数表） |

## 方法一：报告封面信息条

导言区用 `\AddToHook{shipout/background}` 在背景层画：

- 所有页：底部横线；
- 首页：2×6 信息条（姓名 / 学号 / 班级 / 地点 / 指导教师 / 报告评分），由背景层画线、正文用 `tabular` + 自定义等宽列 `C`（`\newcolumntype{C}{>{\raggedright}p{\textwidth/6-...}}`）对应填充；
- 可用 `\drawbackgroundfalse` / `\infostripfalse` 关闭。

## 方法三：纯手绘规则网格

```latex
\begin{tikzpicture}
  \drawgridspec{0.16,0.30,0.20,0.34}{0.9,0.9,0.9,0.9,0.9} % 列宽比例 / 行高(cm)
  % 之后手动 \draw 局部线段即可做断线 / 不对称边框
  \node[...] at (<坐标>) {说明文字};
\end{tikzpicture}
```

`\drawgridspec{列宽比例}{行高cm}` 自动画外框 + 全网格；需要断线就在其后用背景色覆盖或手动重描。

## 示例（见 PDF）

| 页 | 示例 | 演示点 |
| :-- | :-- | :-- |
| p.1 | 方法一信息条 | 背景层 2×6 信息条 + 页边框 |
| p.2 | 示例一 方法求根结果表 | 表头着色 + 隔行底纹 + 单元格高亮 + 末行跨列合并 |
| p.2 | 示例二 学生成绩表 | 姓名列跨两行（multirow）+ 末行跨列合并 |
| p.2 | 示例三 参数对照表 | 首列左对齐 + 仅竖线（vlines）+ 高亮 |
| p.2 | 示例四 booktabs 风格表 | 仅横线 + 整行脚注 |
| p.3 | 示例五 纯手绘网格 | `\drawgridspec` 规则 4×5 网格 |

## 编译与依赖

- 引擎：**XeLaTeX**（至少 2 遍）。
- 关键宏包：`ctex` / `xeCJK`（中文）、`tikz`（含库 `calc`、`matrix`、`fit`）、`tikzpagenodes`、`etoolbox`、`pgfmath`、`geometry`、`fancyhdr`、`enumitem`、`caption`、`lipsum`（仅示例填充）。
- 中文字体：示例用 `SimSun`（宋体）；本机无对应字体时把 `\setCJKmainfont{...}` 改为你系统有的（如 `FandolSong`、`Noto Serif CJK SC` 等）。
- 源文件 `tikz-pseudotable-template.tex` 为 **CRLF、无 BOM**；配套 `tikz-pseudotable-template.pdf` 为已编译成品。

## 许可证

以仓库根目录 [MIT LICENSE](../LICENSE) 发布。
