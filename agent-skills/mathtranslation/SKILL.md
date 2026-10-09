---
name: mathtranslation
description: Translate mathematical books, papers, notes, and existing LaTeX projects into rigorous Chinese LaTeX, review/repair an existing translation, compile and visually verify the result (xelatex + biber + texindy, Windows/WorkBuddy), convert hard-coded references into clickable cross-references, and migrate a translation from the old mathtranslation template onto mathtranslation.cls v3.1. Use when source fidelity, mathematical correctness, terminology consistency, cross-references, citations, compilation, and PDF-level proofreading matter. Do not use for ordinary non-mathematical translation.
---

# MathTranslation

一个统一的数学书中文 LaTeX 翻译 / 审校技能。它把四类密切相关的工作流合并到
一个技能里：

1. **翻译与审校** —— 把数学书籍 / 论文 / 讲义 / 已有 LaTeX 项目译为中文 LaTeX，
   或对照原书复核、修复现有译稿（主干流程，见下）。
2. **编译与可视化验证** —— 在本机（Windows / WorkBuddy）用
   `xelatex + biber + texindy` 编译，并从渲染后的 PDF 层面证明结果真的正确，
   而非仅仅"没报错"。见 [references/build-verify.md](references/build-verify.md)
   与 `scripts/build_and_check.py`。
3. **硬编码引用转可点击交叉引用** —— 把 `定理 3.4` / `(2.3)` / `见 3.25` /
   索引页码等纯文本引用转成 `\ref` / `\eqref` / `\hyperpage` 链接。见
   [references/hardref.md](references/hardref.md) 与 `scripts/convert_hardrefs.py`、
   `scripts/convert_bare_refs.py`。
4. **模板迁移到 mathtranslation.cls v3.1** —— 把旧的 ctexart 单文件模板迁移到
   基于 ctexbook 的 `mathtranslation.cls` v3.1，并做回归审计。见
   [references/cls-v31-upgrade.md](references/cls-v31-upgrade.md)。

四条流程共享同一套纪律：**以原书 PDF 为内容权威、不擅自改写、编号从渲染 PDF
实抽、0 错误 / 0 未定义 / 0 缺字符 / 0 新增 overfull 为红线**。翻译工程的
交叉引用补全经验（编号公式共享计数器、按章 Claim、overfull 修复等）沉淀在
独立的重排技能 `latex-book-retypeset` 中，本技能聚焦"中文翻译模板体系"。

## Establish The Source Of Truth

1. Inventory the supplied PDF, TeX sources, bibliography, figures, fonts,
   templates, and any existing translated files before editing.
2. Treat the published source PDF as the authority for visible mathematical
   content and structure. Use source TeX to recover markup and reduce
   transcription errors, but do not follow it when it conflicts with the
   published PDF.
3. If the source PDF is unavailable, state that limitation and use the best
   available source without pretending that page-level comparison was done.
4. Never silently repair a suspected error in the source. Preserve it by
   default and clearly record the issue; apply a correction only when the user
   requests it or reliable evidence resolves it.
5. Separate content authority from presentation authority. The source PDF
   governs mathematical content; when the user chooses the MathTranslations
   template, `mathtranslations-translation-template.tex` governs typesetting
   conventions.

## Prepare The Project

- Preserve an existing project's document class, packages, file layout, labels,
  citation keys, macros, and build system unless a change is necessary or the
  user explicitly chooses the MathTranslations template.
- For a new project, consult the current MathTranslations guide before choosing
  a template or terminology source. Prefer the latest stable resources linked
  from <https://mathtranslations.org/guide/> over bundled stale copies.
- When a `mathtranslations-translation-template.zip` or
  `mathtranslations-translation-template.tex` is supplied, inspect that exact
  version instead of relying on memory. Archives under the older name
  `MathTranslations-Template.zip` are earlier releases of the same template.
  Read [references/mathtranslations-template.md](references/mathtranslations-template.md)
  before adapting it.
- The current MathTranslations template for books is the `mathtranslation.cls`
  class (ctexbook-based). If the user supplies or prefers it, use its public
  interface (`\makecover`, `\frontmatter`, `\makecontents`, `\makebibliography`,
  `\printterminology`) and build via `tools/build.sh full` (xelatex ×2 → biber →
  xelatex ×2). biblatex is loaded by the class from `BibStyle`/`BibFile`
  options, so only call `\addbibresource` — never `\usepackage{biblatex}`. The
  older single-file `mathtranslations-translation-template.tex` (ctexart) is
  bundled under `assets/` as a legacy reference only.
- If the user selects the MathTranslations template but supplies no template
  files, copy `assets/mathtranslations-translation-template.tex` and
  `assets/logo.pdf` into the project for the legacy variant, or the maintained
  `mathtranslation.cls` + `logo.pdf` for the current variant. Keep the bundled
  masters unchanged; edit the project copies.
- If the user supplies a newer template, prefer that version after comparing
  its contract with the bundled baseline and recording any meaningful changes.
- Build a small project glossary before translating substantial text. Reuse
  established Chinese mathematical terms; keep named objects and symbols
  stable across chapters.
- Read [references/workflow.md](references/workflow.md) when starting a new
  translation, importing a long source, or deciding how to stage the work.

## Translate

- Translate mathematical meaning rather than sentence shape. Use natural,
  concise Chinese while preserving definitions, hypotheses, quantifiers,
  logical dependencies, notation, equation content, theorem status, and the
  force of words such as "if", "only if", "unique", and "respectively".
- Keep math in LaTeX. Reuse the source's macros and environments when they are
  sound. Do not convert formulas into prose, screenshots, or Unicode lookalikes.
- Preserve theorem-like environments, equation structure, bibliography links,
  footnotes, figures, tables, and section hierarchy.
- Recreate commutative diagrams, morphism diagrams, category diagrams,
  pullback or pushout squares, and other arrow-and-node mathematical diagrams
  with the `tikz-cd` package and `tikzcd` environment. Do not replace them with
  screenshots or raster images. Preserve every node, label, arrow direction,
  arrow style, and commutative relationship from the source.
- Handle ordinary figures by priority: when the source PDF is a clean vector
  PDF, re-render the figure region at 400 DPI with `pymupdf` and autocrop it as
  the preferred asset (perfect clarity, no raster blur); redraw simple figures
  with ordinary TikZ; keep `tikzcd` for arrow-and-node diagrams. For crooched
  crops feed a hand-verified `bbox` through an override table. Record any
  exception.
- Typeset display formulas uniformly in `align`, `aligned`, or `align*`
  environments. Never place multiple `\[ \]` blocks side by side; merge them
  into a single environment.
- Use the `enumerate` environment for every ordered list; never type the
  numbering manually.
- Write Chinese double quotes with TeX ligatures: two grave accents for the
  opening quote and two straight apostrophes for the closing quote. The
  apostrophe pair alone renders a closing quote, and Unicode curly quotes
  are not used in this template.
- On the MathTranslations cover, keep the publisher line and the
  `\Translator 翻译及重排` credit line directly below it, set slightly larger
  than the publisher line, as the template sample shows.
- With the MathTranslations template, introduce a concept once with
  `\newterm{stable-key}{中文术语}{English term}`, write the Chinese term normally
  afterward, and keep `\printterminology` as the final document content.
- Follow the selected template's punctuation policy. The inspected
  MathTranslations template uses Chinese punctuation except for an ASCII `.`
  at the end of Chinese prose sentences.
- Use `\label` plus the project's reference command for numbered objects. Do
  not hard-code theorem, equation, section, figure, table, or page numbers in
  translated prose.
- Do not invent missing proof steps, citations, definitions, labels, or
  references. Mark unresolved source ambiguity explicitly.
- Read [references/latex-quality.md](references/latex-quality.md) when editing
  TeX, resolving ambiguous notation, handling OCR, or repairing references.

## Build & verify (compile and visually prove correctness)

Verification is part of the translation, not an optional final polish. The full
recipe — environment facts (broken-coreutils probe, PowerShell encoding traps),
the 5-step build (`xelatex → biber → xelatex → texindy → xelatex`, C-locale
`texindy`), the non-ASCII `-output-directory` trap, log decoding, rendering PDF
pages to images, glyph-level measurement, overfull reduction, and PDF bookmark
verification — lives in [references/build-verify.md](references/build-verify.md).

Key rules (the non-obvious ones):

- Always 3 xelatex passes; if the project has an index (`\makeindex` /
  `main.idx`), it is **5 steps** with `texindy` between the passes that write and
  read `main.ind`. Skipping `texindy` is a *silent-corruption* bug, not an error.
- Run `scripts/build_and_check.py <project_dir>` (defaults to cwd) — it performs
  all steps, forces the C locale only for `texindy`, counts every error pattern
  (including both `^!` and `file:line:` forms), prints the verdict, and exits
  non-zero if anything is non-zero.
- Judge success on **build3**, not build1; require both
  `grep -cE '\.tex:[0-9]+:'` and `grep -c '^! '` to be 0 (`-file-line-error`
  makes `^! ` insufficient alone).
- Do **not** pass `-output-directory` for non-ASCII paths — change cwd instead.
- Visual verification is mandatory: render cover / TOC / index / last page to
  PNG and `Read` them (only if the running model is multimodal), then confirm
  real numbers (never `??`) and real cross-references.
- When a `.cls` redefines `\[`→`equation*` and `\qedhere`→`\tag*`, never wrap
  `align*` in `\[ \]` and never put `\qedhere` inside `aligned`.

## Convert hard-coded references to clickable cross-references

In a translation, the audit profile `mathtranslations` flags plain-text
references (`定理 3.4` / `方程 (22)` / `(2.3)` / `见 3.25`) as warnings. The
translator's note usually promises "可点击的交叉引用", so they should become real
`\ref` / `\eqref` / `\hyperpage` links. The full procedure — counter models, the
safe aux-derived mapping rule, the cover `pageanchor` trap, hand-typeset-item
technique, and the cross-chapter Roman-numeral variants — lives in
[references/hardref.md](references/hardref.md).

Key rules:

- **Convert only when there is a UNIQUE candidate label** satisfying same
  file + exact printed number (from `main.aux` `\newlabel`) + matching env type.
  Derive the number→label map from `main.aux`, never hand-write it.
- For `mathtranslation.cls` (wraps ctexart): theorem counter is "subsection.theorem",
  shared across `\input` files — simulate the full chapter chain, never a single file.
- For book classes (AJbook.cls / ctexbook): theorem-like envs share ONE counter
  printed "section.item"; labels are `<type>:<chap><sec>.<item>`. Resolve by
  (chapter, number) from `main.aux`, never by guessing the type.
- Hand-typeset (unlabeled) numbered items: insert
  `\phantomsection\hypertarget{item:<chap>.<N.M>}{}` and reference with
  `\hyperlink{item:<chap>.<N.M>}{N.M}` — do NOT add `\label` (it would rewrite the
  bold/emph visual).
- Run `scripts/convert_hardrefs.py` (mathtranslation.cls, dry-run + `--apply`) and
  `scripts/convert_bare_refs.py` (book classes, dry-run + `--go`). Recompile twice;
  `0 Undefined reference` proves every converted label resolves.
- Index / List-of-Symbols page numbers: wrap with `\hyperpage{<P>}`. Fix the cover
  `page.1` collision by wrapping the cover in
  `\hypersetup{pageanchor=false}` … `\hypersetup{pageanchor=true}`.

## Migrate a translation to mathtranslation.cls v3.1

When an old ctexart-based template must move to `mathtranslation.cls` v3.1
(ctexbook-based, kvoptions), a naive `\documentclass` swap compiles yet silently
mangles numbering. The safe, auditable recipe — three-layer heading remap,
continuous equation numbering, the two theorem-counter traps (`\@addtoreset`
survival, shared-counter register), the `\printterminology` unnumbered-chapter
override, and the pymupdf regression audit — lives in
[references/cls-v31-upgrade.md](references/cls-v31-upgrade.md).

Key steps: shift every heading down one level (`\section`→`\chapter`,
`\subsection`→`\section`, …); restore continuous equation numbering with
`\@removefromreset{equation}{chapter}`; rebuild theorem aliases pointing their
counters at the shared `\c@theorem` register; clear residual
`\@addtoreset{X}{section}` hooks precisely (never wipe the whole `\cl@section`
list); override `\printterminology` to a starred chapter when there is no
`\appendix`.

## Verify (translation-level)

Verification is part of the translation, not an optional final polish.

1. Compile early and repeatedly with the project's actual build command
   (`bash tools/build.sh full` for the `mathtranslation.cls` workflow: xelatex
   ×2 → biber → xelatex ×2). Always start from a clean auxiliary state after any
   template or `main.tex` change — stale `.aux`/`.toc` from a previous template
   version can crash the first pass.
2. Compare the generated PDF with the source PDF section by section. Also assert
   the *rendered* numbering by extracting text from the PDF (期望 `定义 X.M.K`,
   `定理 X.Y`, `图 X.Y`); a clean build can still ship wrong numbers.
3. Perform three separate passes: Chinese language and terminology;
   mathematics and structural fidelity; compilation and visual layout.
4. Run `scripts/audit_latex.py <project-or-tex-file>` for deterministic checks.
   Add `--profile mathtranslations` for projects based on the
   `mathtranslation.cls` template, and use `--strict` when warnings should fail
   CI.
5. Read [references/review-checklist.md](references/review-checklist.md) before
   declaring a chapter or project complete.

## Report The Result

Summarize:

- translated or reviewed scope;
- source files and authority used;
- build command and whether it succeeded;
- checks performed;
- unresolved ambiguities, suspected source errors, missing assets, or visual
  differences that still need human judgment.

## Bundled resources

- `references/workflow.md` — new-translation staging workflow.
- `references/latex-quality.md` — TeX editing / OCR / reference-repair quality rules.
- `references/mathtranslations-template.md` — `mathtranslation.cls` v3.x template guide.
- `references/review-checklist.md` — pre-completion review checklist.
- `references/build-verify.md` — full compile + visual-verification recipe (Windows/WorkBuddy).
- `references/hardref.md` — hard-coded reference → clickable cross-reference procedure.
- `references/cls-v31-upgrade.md` — old-template → `mathtranslation.cls` v3.1 migration.
- `scripts/audit_latex.py` — deterministic LaTeX audit (labels, refs, resources, …).
- `scripts/build_and_check.py` — 5-step build driver + verdict (build-verify).
- `scripts/convert_hardrefs.py` — mathtranslation.cls hard-ref converter (dry-run/`--apply`).
- `scripts/convert_bare_refs.py` — book-class bare-ref converter (dry-run/`--go`).
- `tests/test_audit_latex.py` — unit test for the audit script.
- `assets/mathtranslations-translation-template.tex` — legacy ctexart template.
- `assets/logo.pdf` — cover logo.
- `agents/openai.yaml` — optional OpenAI/Codex interface metadata.
