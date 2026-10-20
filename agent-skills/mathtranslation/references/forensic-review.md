# Evidence-driven full translation review

Use this procedure when the user asks for a complete sentence-by-sentence or
diagram-by-diagram review, or when an earlier review has missed substantial
errors. It is a completion standard, not a fast audit. A compiler, OCR diff,
checklist tick, or list of discovered errors cannot establish coverage.

## Fix the scope and source

Record the designated edition/printing, source PDF identity, errata policy,
translation build entry point, included TeX files, and source and translated
page ranges. Establish each PDF's printed-to-physical page mapping from visible
folios. A later printing and its errata may disagree: inspect the relevant
page images and apply the project's stated authority rule. Do not infer the
source text from the translation or from OCR alone.

## Build two inventories independently

Make the **source inventory first**, page by page, before using the translation
as a checklist. Mark every page in scope, including blank and boundary pages.
For each section list, in reading order, headings, prose paragraphs and their
sentences, displayed equations, numbered statements and proofs, exercises and
special marks, footnotes, tables, figures, diagrams, citations, and internal
references. Record a page/region or short identifying excerpt for each unit.
Inspect the page image; extraction text is a locator and may omit tiny glyphs,
arrows, footnotes, or entire diagrams.

Build a separate inventory from the **actual compiled translation chain** and
its rendered PDF. Include material in macros, footnotes, appendices, and
exercise sections. Only then reconcile the inventories. Counting translated
`tikzcd` blocks or finding no error in translated TeX cannot reveal a source
diagram or exercise that was never translated. Equal counts can hide one
omission plus one extra item.

Keep a correspondence ledger. A useful row has
`unit_id | source_page/region | unit_kind | source_identifier | translation_file/location | translation_pdf_page | mapping | result | evidence/finding_id`.
Mapping may be one-to-many or many-to-one, but every source unit must have a
disposition and every translation-only unit must be explained. For a request
for 逐句审阅, identify sentence correspondences within each paragraph rather
than marking a whole page or section as checked. A short source incipit and
sentence ordinal suffice; copying whole pages into the ledger is unnecessary.
Use explicit results such as `matched`, `defect`, `intentional_with_reason`,
`source_issue_retained`, and `unresolved`; never fill missing evidence with
`matched`.

## Compare semantics, then challenge the comparison

Read source → translation to find omissions, substitutions, changed order, and
weakened or strengthened claims. Read translation → source separately to find
invented assumptions, proof steps, examples, or diagrams. Compare all
sentences, not just those containing mathematical notation. For each
mathematical assertion and display check the object and its type, domain and
codomain, hypotheses, quantifiers and negation, implication direction,
composition order, equality/inclusion direction, signs, bounds, indices,
accents, and proof dependencies. Check exercises and footnotes in the same
pass; they are not lower-priority prose. For hard-to-read symbols, inspect an
enlarged source crop rather than accepting OCR or a plausible reconstruction.

Make a second challenge pass over the reconciled ledger without treating the
first verdict as evidence. Start from source pages and ask which units could
have been missed, then check translation-only units in reverse. Recheck every
`defect` after editing, and all high-risk formulas, diagrams, and references
affected by nearby edits. Re-running the same search or compiler is not an
independent challenge pass. Record who/what performed each pass and the
evidence used; if the second pass was not done, report that limit.

## Automatic heading numbers versus translated titles

At each chapter or section transition, compare the source's printed heading
identifier with the *rendered* translation heading. If the document class
numbers headings automatically, a numeral copied into a `\section` or
`\subsection` title can silently produce a doubled number such as
`16.1.1. 1. ...`. Keep numerals that are part of the title's meaning (for
example, a named “Coffin 1”), but remove a redundant enumeration prefix.
Inspect the PDF page and table of contents after the edit; a TeX-source search
or clean build alone cannot establish the visible result.

## Cross-page prose and footnote traps

When a source sentence, footnote, or heading crosses a physical page boundary,
track its continuation on both pages. Printed folios and PDF physical pages may
disagree; record both before claiming a range complete. A page with only a
continuation still needs a correspondence result. Check the start and end of
each footnote separately, especially when a new footnote begins below a
continuing one.

At every section or chapter transition, compare the final source paragraphs
before the next heading with the translation's final paragraphs *before its
next heading*. A translated footnote and an apparently correct new heading do
not prove that the preceding body reached its end; whole closing paragraphs
may be missing. Cross-check source marginal page markers at the actual
paragraph boundary: an orphan marker earlier in the translation can signal
that its intended paragraphs were skipped, not merely that a marker needs
moving. Restore the omitted prose before moving the marker, and inspect the
resulting page break in the PDF.

At long inset quotations, portrait galleries, extracts, and lists of examples,
inventory **each quoted item and its closing sentence separately** before
following the narrator's prose. A correct introductory quotation plus an
apparently smooth return to commentary can conceal an omitted second portrait
or several complete paragraphs. Compare the original's item count, title,
mathematical objects, and typography (including intentional name spellings)
against the translated block. If a source quotation contains an apparent
technical or proper-name error, keep the printed wording visible or document
the emendation rather than silently substituting the expected mathematical
term. Check original page markers that fall inside the missing quotation;
their absence helps locate the gap.

Also audit the **middle** of long notes and sections, not only their
boundaries. A translated paragraph ending with a dash or ellipsis and the next
one beginning with another ellipsis can conceal several omitted source
paragraphs while the topic still sounds coherent. For every source paragraph
in a long reflective passage, record its opening and closing thought, then
check that both appear in order in the translation. Recheck marginal page
markers after restoration: an unexplained marker jump, duplicate folio, or
marker embedded in the wrong sentence is evidence of a possible missing span.

For each printed footnote, transcribe the in-text callout and the
footnote-body label independently from the page images. Their numeral,
asterisk, or other suffix need not agree: a callout such as `28(*)` may lead to
a body headed only `28`. When they differ, use separate typesetting controls
for the two visible marks, verify both in the compiled PDF, and record the
source asymmetry rather than normalizing it away.

In literary passages of a mathematical work, test concrete nouns against their
later use before settling a dictionary sense: an object called `casse-tête`
that later fractures a skull is a club, not a nutcracker. Resolve each compact
modifier or parenthesis against the source grammar and nearby action: in a
mouth-rinsing scene, `rougie par le sang` can modify the water rather than the
mirror. These checks belong in the same source-to-translation and reverse
passes as mathematical quantifiers; fluent Chinese can preserve the wrong
referent.

For self-references to numbered notes with suffixes, compare the printed
identifier on the source page with the actual target heading, then check the
translation's rendered identifier and destination. If the printed source omits
or misprints a suffix, make the editorial correction explicit in the ledger;
do not silently present it as though the source printed the corrected number.

For songs, poems, and other lineated source passages, inventory the stanza
count and line count per stanza as well as the wording. A translated `quote`
environment can silently end at an original page boundary, leaving later
stanzas as prose; blank paragraphs between every verse line can also turn a
compact poem into an oversized column. Compare source and final PDF images,
keep explicit verse line breaks and stanza spacing, and check that a short
stanza is not stranded across a page break. Treat a footnote body consisting
only of an ellipsis or another placeholder as an unresolved omission even
when its marker and number pass automated completeness checks. Verify the
full body against the printed source and inspect its beginning and end in the
compiled PDF.

At a page-bottom footnote continuation, an isolated numeral plus period can be
the tail of a cross-reference printed on the preceding page, not a new footnote.
Trace the syntax of the preceding footnote through the next physical page
before creating any editorial note or numbering anomaly. Compare both page
images and the final PDF footnote; also reject explanatory sentences that
appear in the translation but have no source counterpart.

For repeated conceptual oppositions, check the source word family as a unit
across adjacent paragraphs (for example `acceptation`, `non-acceptation`,
`inacceptable`). A locally fluent synonym can obscure the author's argument
if it severs the recurring root. Record any printed source wording that is
internally strange rather than inventing a fluent but unsupported sense.

For coordinated clauses under a shared negation or uncertainty, check the
polarity of **each** conjunct separately. A source such as “without caring
whether the child resembles him or bears his name” must not turn the second
alternative into “does not bear his name”. Preserve approximate quantifiers
(`une quinzaine`, “a dozen or so”) as approximate, then count any nearby
enumerated items: a source list of sixteen may still correctly be described
as “about fifteen”, whereas an exact translated “fifteen” creates a false
conflict.

When a long mathematical footnote contains a numbered list, verify both the
individual statement of every item and the list's **rendered** structure.
Plain source newlines inside a TeX footnote often collapse to one paragraph;
use explicit paragraph or line breaks where the print source sets items on
separate lines, and inspect the final PDF for wrapping and split notes.

## Diagrams and navigation have their own ledgers

For every **source** arrow-and-node diagram, identify the corresponding
translation diagram and establish source and translation node sets and edge
lists independently. Record each edge's source, target, label, arrowhead,
hook/two-head/equality style, and omitted zero or empty nodes. Check effective
styles after macro expansion or TikZ overrides, compile the replacement in
isolation when useful, and inspect its final PDF rendering. Apply the
[diagram audit skill](../../latex-array-diagram-audit/SKILL.md) for details.
Classify ordinary figures and formula matrices separately. A correct-looking
diagram count, a successful compile, or legible labels cannot certify topology.

For each internal prose reference, record the source's full printed identifier,
the translation's rendered identifier (including Roman chapter prefix), the
target label/anchor, and the actual PDF destination object. Audit all PDF links
automatically for missing names and collisions, then verify semantic targets
for every prose reference; a resolvable link can still reach the wrong theorem.
Check TOC/bookmark destinations against heading position, not only page number.
Use [hardref-completeness.md](hardref-completeness.md) for candidate discovery
and ambiguous number resolution. Investigate every collision and AUX/PDF page
disagreement; do not auto-classify them as broken or harmless.

## Completion gate

Keep the states distinct:

- **Inventoried:** source and translation units located; comparison may remain.
- **Reviewed:** every in-scope source and translation unit has a reasoned
  correspondence or explicit unresolved status; the challenge pass is recorded.
- **Repaired:** every confirmed finding has a traceable edit or a documented
  decision to retain the source; no issue is silently dropped.
- **Validated:** rebuild the **final** source with the project's full pipeline,
  recheck edited units in the final PDF, inspect diagrams, and verify printed
  reference text and semantic destinations. Index and bibliography production
  must be current.

Unresolved units or uninspected pages block an unqualified “full review
complete” claim. A finding list proves what was found, not that nothing else
was missed. Report inventory totals by unit type, unmatched and unresolved
rows, finding dispositions, the exact final artifact checked, and the limits of
any automated or sampled validation.
