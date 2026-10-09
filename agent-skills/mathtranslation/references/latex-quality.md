# LaTeX And Mathematical Fidelity

Read this reference when editing TeX, recovering content from OCR, resolving
notation, or repairing a translated project.

## Preserve Semantic Structure

- Keep definitions, lemmas, propositions, theorems, corollaries, remarks,
  examples, exercises, proofs, and solutions in their corresponding semantic
  environments.
- Preserve the distinction between assumptions and conclusions.
- Check every negation, quantifier, comparison sign, set operation, index,
  bound, and condition.
- Keep equation grouping and alignment when it communicates derivation or
  equivalence.
- Do not normalize notation merely because another notation is more familiar.
- Use `enumerate` for ordered lists; never type the numbering manually.

When the source seems mathematically wrong, record the exact location and the
evidence. Preservation and correction are separate editorial choices.

## Prefer Project-Native LaTeX

- Reuse existing commands, theorem styles, bibliography tools, and reference
  packages.
- Define a new macro only when it removes meaningful repetition or encodes a
  stable semantic choice.
- Avoid global package or class changes for a local translation issue.
- Keep generated files out of source directories when the project already has
  a build directory convention.

When the user explicitly selects the MathTranslations template, treat its
supplied TeX as the project-native style. Do not replace its terminology,
theorem, long-proof, exercise-answer, section, or hyperlink systems with a
generic alternative merely for convenience.

## References And Numbering

Every numbered object that is mentioned elsewhere should have a stable label.
Use the reference command already established by the project, such as `\ref`,
`\eqref`, `\autoref`, or `\cref`.

Never translate a source phrase into hard-coded output such as:

```tex
由定理 2.3 可知
```

Prefer:

```tex
由定理~\ref{thm:main}可知
```

Do not rename existing labels without updating all callers. Keep labels unique
across included files.

## Citations

- Preserve citation keys when importing source TeX.
- Check that every cited key exists in a bibliography source or `\bibitem`.
- Preserve page, theorem, chapter, and equation locators.
- Do not infer a publication year, author spelling, DOI, or title from memory.
- Distinguish a citation in the mathematical source from a translator's note.

## Chinese Typesetting

- Use natural Chinese punctuation in prose and mathematical punctuation that
  matches the surrounding syntax.
- Keep spaces, nonbreaking spaces, and line breaks intentional around references,
  names, units, and inline mathematics.
- Avoid raw Unicode mathematical lookalikes when a LaTeX command is intended.
- Keep proper names, acronyms, and transliterations consistent with the project
  glossary.
- Follow the project's existing convention for theorem names, quotation marks,
  emphasis, and parenthetical English.

The inspected MathTranslations profile has an unusual but explicit rule:
Chinese punctuation is used inside prose, while sentence-final punctuation is
an ASCII period `.` rather than `。`. Apply this only when that template is the
selected presentation authority. The same profile requires display formulas in
`align`, `aligned`, or `align*` environments (never multiple `\[ \]` blocks in
a row), ordered lists in `enumerate`, and Chinese double quotes written with
the TeX ligatures — two grave accents opening, two straight apostrophes
closing — rather than Unicode curly quotes.

The same profile uses Song for prose and examples, Kai for first-introduction
terms, Fang for most theorem-like bodies, and CMU Serif for English. Preserve
those roles unless the supplied template version says otherwise.

## Multiline Formulas And Compactness Discipline

When multiple displayed formulas or equations appear in immediate sequence, **never stack independent single-equation environments** (such as consecutive `\[ ... \]` blocks or consecutive `gtmeq` blocks).
- **The Pitfall**: Independent display environments each introduce their own `\abovedisplayskip` and `\belowdisplayskip`, resulting in glaring blank lines and vertically fragmented equations that destroy mathematical coherence.
- **The Solution**: Merge consecutive displays into a single unified environment (`gather`, `align`, or `gathered`).
- **Unified Numbering Integration**: When the project uses a unified item counter (e.g. `gtmitem` in Springer GTM styles):
  ```latex
  % CORRECT: Compact multi-line display with per-line integrated tag
  \begin{gather}
    \Phi_n' \le \Phi_{n+1}' \gtmtag\label{eq:10.3.13} \\
    \varphi_n \le \Phi_n \le \Phi_n' \gtmtag\label{eq:10.3.14} \\
    \Phi_n' \in \mathscr{P}(f,G). \gtmtag\label{eq:10.3.15}
  \end{gather}
  ```
  This preserves the unified counter sequence while maintaining tight, professional vertical rhythm.

## Overfull \hbox Five-Tier Resolution Strategy

Eliminating horizontal overflow is a non-negotiable quality gate in book retypesetting. Tackle overflows using this battle-tested hierarchy of effective interventions:

1. **Strategic Line Splitting**: Break long summation expansions or chained equalities/inequalities before binary operators (`+`, `-`) or relation symbols (`=`, `\le`). In `align`, place continuation lines with proper indentation.
2. **`aligned` Subgrouping**: When a three-term relation chain (`A \le B \le C`) exceeds text width inside an `align` or `gtmeq` row, wrap the relation in an inner `\begin{aligned} ... \end{aligned}` split across two lines. `gtmeq` natively accommodates `aligned` without amsmath conflicts.
3. **Fidelity-Preserving `\linebreak`**: When inline math (such as $\limsup$ / $\liminf$ with complex indices) overflows tightly set Times Roman columns, render the original book page at 260+ DPI, inspect the original author's breaking point, and insert `\linebreak` or `\allowbreak` at the exact same semantic boundary.
4. **Delimiter Slimming**: Extraneous `\left` and `\right` enlarge bounding boxes and introduce unwanted padding, often triggering 0.5–2.5 pt overflows. Replace automatic delimiters with fixed sizing (`\bigl( \bigr)`, `\Bigl[ \Bigr]`) or plain ASCII parentheses where sizing is unnecessary.
5. **Compact Formatting (`\tfrac` / Sizing)**: In fractional exponents or secondary subscripts, use `\tfrac` instead of `\frac`, or compact index groupings with negative kerning (`\!`).

## Special Math Glyphs & High-Resolution Verification

- **Complex Conjugate & Accent Fidelity**: Low-resolution scans (150 DPI) and OCR engines (PaddleOCR/MinerU) silently misattribute overbars (`\bar{}` or `\overline{}`), hats, and tildes — e.g. drawing an overbar across an entire fraction instead of just the numerator, or confusing $\bar{z}_k$ with $\overline{z_k z_{k+1}}$.
  *Rule*: Always extract candidate regions via PyMuPDF at **$\ge 800$ DPI (up to 1200 DPI)** with a clipping rectangle that reserves at least 4–6 pt of ascender headroom above the baseline.
- **Author-Specific Notational Invariants**: Respect the original text's explicit notational choices:
  * Empty set as open square: `\eset` (`\square`), not $\emptyset$.
  * Trigonometric shortcut: `\cis \theta = \cos \theta + i \sin \theta`.
  * Weierstrass elliptic function: `\wp(z)`, not $\mathcal{P}$.
  * Specific operators: define via `\DeclareMathOperator{\ann}{ann}` rather than italic prose.

## OCR And Transcription

Treat OCR as a draft, not evidence. Check common confusions including:

- `0`, `O`, `o`, and `\circ`;
- `1`, `l`, `I`, and `|`;
- `v`, `\nu`, `u`, and `\upsilon`;
- minus signs, hyphens, and long dashes;
- superscripts, subscripts, primes, bars, hats, and tildes;
- opening and closing delimiters;
- `\in`, `\ni`, `\subset`, and `\subseteq`;
- equation numbers mistaken for equation content.

For a formula recovered from an image, compare the compiled result visually
with the source before accepting it.

## Figures, Tables, And Assets

Check that every `\includegraphics` target resolves with the project's extension
and search-path rules. Do not redraw or replace mathematical diagrams unless
the user requests it or the source asset cannot legally or technically be used.
When the MathTranslations template is selected, follow its figure priority:
re-render the figure region at 400 DPI from a clean vector source PDF with
`pymupdf` and autocrop for clear figures, redraw simple figures with TikZ, and
rebuild arrow-and-node diagrams with `tikz-cd`. When recreating a diagram,
compare geometry, labels, orientation, and semantic relationships, not just
visual style.

For arrow-and-node mathematical diagrams, use:

```tex
\[
\begin{tikzcd}
A \arrow[r, "f"] \arrow[d, "g"'] & B \arrow[d, "h"] \\
C \arrow[r, "k"']                & D
\end{tikzcd}
\]
```

This requirement covers commutative diagrams, category diagrams, morphism
diagrams, pullback and pushout squares, and similar structures. Preserve:

- node order and relative placement;
- every arrow's source and target;
- labels and their side of the arrow;
- hooks, two-headed arrows, isomorphism marks, dashed arrows, bends, and
  parallel arrows;
- stated or visually implied commutativity.

Do not substitute a screenshot, OCR image, Mermaid diagram, or generic table
for a diagram that `tikz-cd` can express. Use ordinary TikZ or a source image
only when `tikz-cd` would lose essential geometry or visual meaning.

## Proof Environments And Semantic Boundaries

- **Proof Nesting Prohibition**: When proving a theorem whose proof contains the self-contained proof of an auxiliary lemma, **never nest standard `\begin{proof} ... \end{proof}` blocks**.
  *Symptom*: LaTeX's proof environment closes internal theorem stack hooks; nesting `\end{proof}` prematurely triggers `! LaTeX Error: \begin{document} ended by \end{proof}.`
  *Fix*: Format the inner proof as an inline block with explicit tombstone:
  ```latex
  \noindent\textbf{Proof of Lemma \ref{lem:inner}.} ... $\blacksquare$
  ```
- **Named Theorems (`[Title]`)**: Pass theorem titles as the optional third parameter (`\begin{theorem}[Cantor's Theorem]\label{thm:...}`). Never wrap theorem names in fragile macros or `\texorpdfstring` which may break capitalization headers.

## Structural Navigation & Hyperlink Architecture

1. **Color-Coded Hyperlink Hierarchy**:
   To maximize navigational clarity in mathematical texts, distinguish internal cross-references from external literature citations:
   ```latex
   \RequirePackage[
     colorlinks=true,
     linkcolor=blue,     % Theorem, equation, chapter, and page links in crisp blue
     citecolor=red,      % Bibliography citations in distinct red
     urlcolor=blue,
     pdfencoding=auto,
     psdextra,
     bookmarksnumbered=true
   ]{hyperref}
   ```
2. **Table of Contents (TOC) Roman Numeral Margin Defense**:
   In multi-chapter treatises using Roman numerals (e.g. Chapter VIII, Chapter XII), standard LaTeX allocates only `1.5em` for the chapter number box in the TOC. This causes Roman numbers to visibly collide with and overwrite chapter titles.
   *Fix*: Expand the chapter number box width in the class or preamble:
   ```latex
   \def\@chapapp@numwidth{2.6em} % Expand from 1.5em to 2.6em
   ```
   *Macro Scope Hygiene*: If modifying internal kernel macros with `@`, never execute bare `\makeatother` in preamble includes that might be read during macro expansion; use local `\begingroup \global... \endgroup` or keep edits confined strictly within `.cls`/`.sty` packages.
3. **Index & Symbols Hyperlink Anchoring & Cover Anchor Trap**:
   - **Clickable Folios**: Index entries and List of Symbols entries should map page numbers via `\hyperpage{P}` or `\pageref` to provide instant clickable jumps to the target page.
   - **Cover Anchor Trap**: When cover pages (`\makecover` or `\makegtmcover`) are typeset before `\frontmatter` / `\mainmatter`, `hyperref` automatically binds the destination `page.1` to the physical cover page! As a result, clicking index references to page 1 will incorrectly jump to the front cover rather than Chapter 1.
   - *Fix*: Disable pageanchors during cover generation:
     ```latex
     \newcommand{\makegtmcover}{%
       \hypersetup{pageanchor=false}%
       \begin{titlepage} ... \end{titlepage}%
       \cleardoublepage
       \hypersetup{pageanchor=true}%
     }
     ```

## Compilation Discipline

Use the project's build command. A successful single engine invocation may not
resolve bibliography, index, glossary, or cross-reference data, so run the full
build sequence.

For the `mathtranslation.cls` template, the canonical build is
`bash tools/build.sh full` (xelatex ×2 → biber → xelatex ×2): the first
xelatex pass records labels and terminology entries, biber resolves the
bibliography, and the later passes resolve page numbers, links, the table of
contents, and the terminology table. **After any change to the class or
`main.tex`, delete the auxiliary files (`main.aux`, `main.toc`, `main.out`,
`main.bbl`, `main.bcf`, `main.run.xml`) and rebuild clean** — a stale `.toc`
from another template version can crash the first pass with an undefined
control sequence such as `\InAppendixToctrue`.

Inspect logs for:

- LaTeX errors and undefined control sequences;
- undefined or multiply defined references and citations;
- missing files and fonts;
- overfull or underfull boxes that affect readability;
- rerun requests;
- bibliography, index, and glossary failures.

Compilation proves syntactic and toolchain consistency. It does not prove that
the translation or mathematics is correct, and a clean build can still ship
wrong displayed numbers — verify the rendered numbering (定理 X.Y, 定义 X.M.K,
图 X.Y) by extracting text from the PDF.
