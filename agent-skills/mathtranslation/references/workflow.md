# Translation Workflow

Use this workflow for a new mathematical translation or a substantial new
chapter. Adapt the granularity to the project instead of forcing every job into
the same number of files or passes.

## 1. Inventory Inputs

Locate and classify:

- the published source PDF;
- editable TeX and bibliography sources;
- figures, tables, diagrams, and external data;
- custom classes, packages, fonts, and macros;
- an existing Chinese translation or terminology list;
- the build command and expected engine.

Record gaps before translating. A source PDF without TeX may require careful
transcription or OCR. TeX without the published PDF cannot support reliable
visual comparison.

## 2. Choose Evidence Priority

Use this default order for content when evidence conflicts:

1. the user-designated published edition for the visible mathematical work;
2. source TeX for exact markup, labels, citation keys, and macro intent;
3. errata or another edition as evidence for a proposed correction, when in scope;
4. OCR, HTML, notes, or secondary copies as supporting evidence only.

Do not merge editions silently. Record the edition, revision, or date used when
it is known. If an erratum disagrees with the designated printing, compare both
on the page image and record the decision; neither a newer note nor OCR silently
overrides the chosen source. If the user specifies an edition/errata rule, use it.

Presentation has a separate authority. If the user selects the
MathTranslations template, its TeX governs layout, fonts, semantic environments,
links, and terminology-index mechanics. Source content still governs what the
translation says and how displayed objects are numbered.

## 3. Bootstrap Or Preserve The Project

For an existing project, first compile an unchanged baseline when feasible.
Preserve local conventions unless they prevent a correct result.

For a new project:

- review the current resources linked from
  <https://mathtranslations.org/guide/>;
- when using the MathTranslations template, read
  [mathtranslations-template.md](mathtranslations-template.md), preserve an
  untouched copy, and compile the unchanged template as a baseline;
- if the user did not supply template files, copy the skill's bundled
  `assets/mathtranslations-translation-template.tex` and `assets/logo.pdf`
  into the project for the legacy ctexart variant, or the maintained
  `mathtranslation.cls` + `logo.pdf` for the current ctexbook variant;
- otherwise choose a Unicode-capable Chinese TeX setup appropriate to the
  environment;
- keep source assets and generated build artifacts separate;
- establish a repeatable build command — for `mathtranslation.cls` projects use
  `bash tools/build.sh full` (xelatex ×2 → biber → xelatex ×2); start from a
  clean auxiliary state after any template or `main.tex` change;
- create a minimal sample containing Chinese prose, formulas, theorem
  environments, references, citations, and one figure before scaling up.

Do not vendor a remote terminology export without checking its license and
version. The bundled MathTranslations template and logo are MIT-licensed;
prefer a user-supplied newer template when available.

The recommended extraction path is source PDF to MinerU or another parser,
then Markdown as a working draft, followed by translation and LaTeX reassembly.
Extraction output never outranks the source PDF.

## 4. Establish Terminology

Create a project glossary with at least:

| Source term | Preferred Chinese | Context or exception | Evidence |
|---|---|---|---|
| compact | 紧 | topology; not everyday "compact" | current glossary/textbook |

Use the current MathTranslations terminology page as one reference, then check
the field's established Chinese literature and the local context. The project
glossary wins only for deliberate, documented choices.

For a new or disputed term:

1. identify its mathematical field and exact sense;
2. inspect nearby definitions and usage;
3. compare established Chinese sources;
4. choose one translation and record alternatives or exceptions;
5. search the project for inconsistent variants.

Keep symbols, transliterations, capitalization, and named constructions
consistent. Do not translate a term mechanically when its meaning changes by
context.

With the MathTranslations template, encode the first formal occurrence with
`\newterm{stable-key}{中文术语}{English term}` and write the Chinese term normally
afterward. Reserve `\termcn` for emphasis that should not create an index row.

## 5. Translate In Reviewable Units

For book/chapter work use [independent-review.md](independent-review.md) to
separate translation from source-first review in fresh subagent contexts.
Do not treat switching role names in the same conversation as isolation.

Work by a coherent unit such as a section or subsection:

1. map source and translation headings, environments, numbered items,
   exercises, citations, figures, diagrams, footnotes and their page spans;
2. translate the prose while preserving all mathematical dependencies;
3. compile the unit;
4. compare each source paragraph, displayed formula, exercise and footnote
   against the translation and source page image; mark each unit as matched,
   corrected, intentionally different with evidence, or unresolved;
5. inventory diagrams on **both** sides separately, including drawings hidden
   in arrays/macros and source diagrams absent from the translation; compare
   node and edge lists, then inspect the rendered result;
6. update the glossary, coverage ledger and issue log;
7. commit or checkpoint a clean state before moving on.

Keep units small enough that a missing paragraph, swapped equation, or broken
reference can be localized quickly. Compare source and translation counts per
section (numbered statements, exercises, footnotes, diagrams), but investigate
differences rather than treating equal totals as proof: one omission can cancel
one spurious addition. Page drift is normal, so align by heading and content,
not by assuming equal PDF page numbers. OCR is a locator, never the final judge
of tiny symbols, arrow styles or whether a passage exists.

For a full review, retain a compact ledger with source edition/page, translation
file/position, unit type, comparison result and evidence. A chapter is only
"reviewed" when its source range and every section's units are accounted for;
"repaired" requires every finding to have a disposition; "validated" requires
the final rebuilt PDF and destination checks. Do not promote one status to the
next merely because the source compiles.
For a complete audit of an existing translation, apply the stricter
[evidence-driven full-review procedure](forensic-review.md), including two
independent inventories, sentence correspondences, a reverse pass, and a
recorded challenge pass.

## 6. Handle Special Content

### Definitions, Theorems, And Proofs

Preserve environment type, numbering behavior, hypotheses, conclusions, and
proof boundaries. Do not upgrade an informal claim into a theorem or fill an
omitted argument.

### Equations

Retain displayed versus inline status when it carries meaning. Preserve
alignment, tags, cases, punctuation, and surrounding grammatical connections.
Compare every symbol, subscript, superscript, delimiter, and quantifier. With
the MathTranslations template, typeset display formulas in `align`, `aligned`,
or `align*` environments and never place multiple `\[ \]` blocks side by side.

### Figures And Tables

Choose representation using [illustrations.md](illustrations.md) and execute
captures/redraws using [figure-capture.md](figure-capture.md). Preserve suitable
source vectors as cropped PDF; a 400-DPI PNG is a raster preview, not lossless
vector reuse. For scans, preserve available detail; redraw with TikZ/PGFPlots
when the mathematical specification is reliable or editable output is requested.
Use `scripts/capture_pdf_region.py` from the skill directory for explicit physical
pages and inspected bounds; do not assume project-specific crop/rewire scripts exist.
Caption matching and automatic boxes produce candidates, not verified crops.
Translate captions and table text without changing data; preserve labels and references.

Rebuild arrow-and-node diagrams with tikz-cd, following
[diagram-practice.md](diagram-practice.md). Use captures as source evidence, not
the final representation of a commutative diagram. For unavailable assets,
record a placeholder/limitation rather than inventing content. Verify every panel,
the standalone asset and the final compiled page.

### Bibliography

Preserve citation keys and bibliographic facts. Translate a title only when the
project has a consistent policy. Do not fabricate metadata that cannot be
verified.

### Front And Back Matter

Translate title pages, prefaces, appendices, indices, acknowledgements, and
license notices according to project scope. Keep legal and attribution text
faithful.

For the MathTranslations cover, replace all sample metadata: Chinese and
English titles, author, edition, publisher, year, translator, model, and update
date. Keep the `\Translator 翻译及重排` credit line directly below the
publisher line. Keep the terminology index after the bibliography and all
other content.

## 7. Track Uncertainty

Maintain a short issue log for:

- suspected source errors;
- terminology disputes;
- illegible or missing source content;
- edition differences;
- unresolved references or citations;
- layout differences that may alter interpretation.

Separate observed facts from proposed fixes. This makes editorial decisions
reviewable and prevents quiet drift from the source.

## 8. Deliver

A finished handoff should include the editable project, generated PDF when the
toolchain permits, build instructions already present in the project, the
project glossary, and a concise unresolved-issues list. Reconcile the finding
ledger against actual edits, then verify the final PDF rather than an older
build. For internal references, check both the printed source-style number
(including its Roman chapter prefix) and the semantic destination: the target
heading/item and page coordinate, not just that a named anchor exists. Check
every new or changed link, sample unchanged links by reference pattern, and
investigate all detected anchor collisions or page mismatches. Do not claim a
complete PDF comparison when only source text or
compilation logs were checked.
