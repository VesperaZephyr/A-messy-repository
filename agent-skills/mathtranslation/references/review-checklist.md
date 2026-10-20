# Review Checklist

Use three distinct passes. Combining them encourages the reviewer to notice
fluent Chinese while missing a mathematical or structural defect.

Before the passes, establish the designated source edition and a per-section
coverage ledger. Record source/translation spans and counts for numbered
statements, exercises, displayed formulas, footnotes and diagrams. Check the
source for units absent in the translation as well as defects in existing units;
searching only translated TeX cannot find a wholly omitted exercise or figure.
Keep discrepancies and their resolutions in the ledger. Equal counts are a
triage signal, not proof of one-to-one correspondence.
For a claimed complete sentence/diagram review, use the concrete inventory,
reverse-pass and completion rules in [forensic-review.md](forensic-review.md).
This checklist alone is not evidence that the passes occurred.

## Pass 1: Chinese And Terminology

- [ ] The Chinese is natural, concise, and suitable for mathematical writing.
- [ ] No source sentence, heading, caption, footnote, or list item is omitted.
- [ ] Every source paragraph, proof step and exercise has a corresponding
      translation unit or a recorded, justified exception; no extra hypothesis,
      conclusion or proof step was silently introduced.
- [ ] Sentence correspondences are recorded within paragraphs; source-only
      and translation-only units were both examined, and a challenge pass was
      performed without accepting the first pass's verdict as evidence.
- [ ] Terms match the project glossary and current authoritative usage.
- [ ] Pronouns and omitted subjects remain unambiguous.
- [ ] Logical connectors retain their force.
- [ ] Proper names, transliterations, acronyms, and capitalization are stable.
- [ ] Punctuation and spacing are consistent.
- [ ] Chinese double quotes use the TeX ligatures (two grave accents opening,
      two straight apostrophes closing), not Unicode curly quotes.
- [ ] If the MathTranslations template is selected, Chinese prose sentences
      end in ASCII `.` and first-introduction terms use unique `\newterm` keys.
- [ ] Translator additions are visibly distinguished from source content.

## Pass 2: Mathematics And Structure

- [ ] Every definition preserves the defined object and its scope.
- [ ] Every hypothesis, conclusion, quantifier, negation, and uniqueness claim
  matches the source.
- [ ] Formula symbols, indices, limits, signs, delimiters, and equation order
  match the source PDF.
- [ ] Theorem-like environment types and proof boundaries are preserved.
- [ ] Section hierarchy, lists, examples, exercises, figures, and tables are
  complete and in the correct order.
- [ ] Source and translation exercise identifiers and special marks match;
      second-printing additions are checked explicitly.
- [ ] Every arrow-and-node mathematical diagram is rebuilt with `tikzcd`;
  nodes, labels, directions, arrow styles, and commutativity match the source.
- [ ] The diagram inventory covers every actually compiled source, including
  legacy `array/aligned/matrix/CD/xymatrix`, custom macros, footnotes and appendices;
  each candidate is classified (a clean `tikzcd` search is not a completeness check).
- [ ] Every source diagram, including one absent from the translation, has a
      mapped target or an unresolved finding; source and target edge lists were
      built independently and checked on rendered pages.
- [ ] Original and translated edge lists were independently established. Each
  head, injection hook, double head, equal/no-head edge and label side is matched;
  global/local style overrides and explicit from/to endpoints were checked.
- [ ] Other figures follow the template priority: re-rendered at 400 DPI from a
  clean vector source PDF with `pymupdf` and autocropped (preferred for clarity),
  ordinary TikZ for simple figures.
- [ ] Figure environments strictly enforce scheme A: standard floats `\begin{figure}[htbp] \centering ... \end{figure}`; no `\begin{center}` inside `figure`; widths in relative `\textwidth` fractions (`0.40\textwidth` to `0.80\textwidth`), never absolute physical lengths.
- [ ] No `wrapfigure` used where display math or xeCJK paragraph shaping breaks: wrapped diagrams from the original book are safely promoted to independent centered figures or side-by-side `minipage` blocks.
- [ ] Figure captions and cross-references are sound: `\caption{...}\label{fig:...}` sequence preserved; no manual numbering prefix (e.g. no `图 3.1:`) inside `\caption`; 100% of defined figures are referenced in prose via `\ref`.
- [ ] Display formulas use `align`-family or `gather` environments with no juxtaposed
  `\[ \]` blocks or stacked independent `equation`/`gtmeq` blocks; multi-line equations are vertically compact and cohesive.
- [ ] Numbered equation drift prevented: only formulas explicitly tagged with numbers in the original book use numbering environments; unnumbered displays use bare `\[ \]`; alphabetical suffix equations (e.g. 1.19a) use sub-tags without incrementing base counters.
- [ ] Proof boundaries are sound: auxiliary proofs inside a main theorem proof do NOT nest `\begin{proof} ... \end{proof}`, but use `\noindent\textbf{Proof ...} ... \blacksquare`.
- [ ] High-DPI micro-glyph verification performed: complex conjugation overbars (`\bar{}` vs `\overline{}`), accents, prime symbols, and fine subscripts checked via $\ge 800$ DPI crops with ascender headroom.
- [ ] Labels are unique and all references resolve to the intended objects.
- [ ] Citation keys and locators match the source.
- [ ] Suspected source errors are recorded instead of silently altered.
- [ ] Errata versus the designated printing were checked on the page image and
      resolved under the project's edition rule, with discrepancies recorded.

## Pass 3: Build And Visual Comparison

- [ ] The full project build succeeds from a clean or documented state
  (`bash tools/build.sh full` for the `mathtranslation.cls` workflow: xelatex ×2
  → biber → xelatex ×2). Auxiliary files were cleared after any template or
  `main.tex` change.
- [ ] Bibliography, index, glossary, and cross-references are resolved; no
  undefined references/citations, no `LaTeX Error`, no missing figures, no rerun
  warnings in the log.
- [ ] The audit script reports no unexplained errors or warnings
  (`--profile mathtranslations --strict`).
- [ ] Displayed numbering was verified by extracting text from the compiled PDF:
  定义 `X.M.K`, 定理/问题/图 `X.Y` match the source book; no stray three-level
  numbers.
- [ ] The generated PDF has been compared with the source PDF page by page or
  section by section.
- [ ] Display equations, tables, figures, captions, footnotes, and page breaks
  are readable and not clipped.
- [ ] Every `tikzcd` diagram compiles without overlap, clipping, missing labels,
  or arrows pointing to the wrong node; hooks/double heads are checked in the final
  page as well as isolated examples.
- [ ] If image viewing fails, the path/viewer was checked and the failure was not
  treated as proof of a text-only model. Source topology, PDF path/glyph evidence
  and direct visual inspection are reported separately; missing extracted arrowhead
  strokes are not treated as proof that no arrowhead exists. Unresolved
  direction/hook details prevent an unqualified diagram-fidelity verdict.
- [ ] Fonts contain all required Chinese and mathematical glyphs.
- [ ] Overfull boxes, bad breaks, widows, and orphans have been reviewed where
  they materially affect reading.
- [ ] Links and bookmarks point to the correct **objects**, not merely existing
      destinations. Printed text preserves chapter/section prefixes (such as
      `I.4.2`), and PDF landing pages/coordinates show the intended heading or
      numbered item. Colliding anchors and AUX/PDF page disagreements are
      investigated rather than silently accepted.
- [ ] Table of Contents (TOC) Roman chapter numeral boxes are wide enough (e.g. 2.6em) to prevent overlapping chapter titles.
- [ ] Cover anchor trap eliminated: `\makecover` / `\makegtmcover` disables `pageanchor` during titlepage rendering so `page.1` anchors directly to Chapter 1, not the cover.
- [ ] Index and List of Symbols folios are clickable via `\hyperpage{P}` or `\pageref` and validated via automated link audit script against destination pages.
- [ ] `biblatex` is loaded only by the class — `main.tex` does not contain a
  manual `\usepackage{biblatex}` (would cause an option clash).
- [ ] MathTranslations long-proof links and environments are paired.
- [ ] MathTranslations exercises and answer prefixes preserve source order and
  navigate to the intended counterparts.
- [ ] Cover metadata no longer contains sample title, author, translator,
      model, edition, or date values, and the `\Translator 翻译及重排` credit
      line sits directly below the publisher line.
- [ ] `\makecover`, `\makecontents`, `\makebibliography`, and `\printterminology`
      are each called exactly as required; `\printterminology` is the final
      document content.

## Completion Note

Record:

- scope reviewed;
- source edition and files used;
- compilation command and result;
- date or version of external terminology resources consulted;
- unresolved ambiguities and known visual differences;
- any intentional departure from the source.
- coverage ledger totals, finding dispositions, and which final-PDF destination
  checks were actually performed; distinguish reviewed, repaired and validated.
