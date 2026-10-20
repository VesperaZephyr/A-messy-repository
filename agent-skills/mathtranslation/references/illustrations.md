# Mathematical illustrations: source fidelity and final-page readability

Use this workflow for a book-wide illustration repair, ordinary geometry,
curves and surfaces, vector fields, level sets, tangent/cotangent bundles,
orientation and boundary diagrams. For commutative arrow-and-node diagrams,
also follow the existing diagram audit skill. Do not recreate a mathematical
figure with image generation: exact mathematical relationships require
deterministic geometry and a published-source comparison.

For executable capture commands, coordinate conventions and TikZ implementation,
read [figure-capture.md](figure-capture.md). For clean-context figure review,
read [independent-review.md](independent-review.md).

## Diagnose before selecting a drawing method

Record six distinct questions for each figure:

1. Identity: is this actually the source figure attached to this number?
2. Completeness: are all panels, labels, axes, level lines and arrows present?
3. Crop: is there foreign prose, a caption fragment, or another figure?
4. Representation: are paths/text retained, or were vectors rasterized?
5. Readability: are principal labels and fine distinctions legible at the final size?
6. Placement: does the actual book page keep the figure, caption and context usable?

Do not solve identity/completeness by increasing DPI. Do not solve a layout
problem by arbitrarily changing the mathematical drawing. When the user wants
redrawn or editable illustrations, retaining a source crop is an intermediate
reference, not fulfillment of that request.

## Independent inventories and an evidence ledger

Inventory the published PDF first, using its page images as authority. Locate
captions with text extraction, but inspect complete pages to distinguish
captions from prose references and to find unnumbered figures. Then inventory
the actual TeX input chain (including macros, appendices, exercises and inline
graphics) and the compiled PDF independently. Reconcile by identity, not count.

Suggested fields:

`id, source_sha256, physical_page_1based, printed_folio, bbox_pdf_points,
source_panels, mathematical_facts, tex_file/line, label, asset,
method, displayed_width, final_pdf_page, crop_review, final_review,
evidence, unresolved`.

Distinguish `pending`, `defect`, `repaired`, `source_issue_retained` and
`verified`. Never automatically initialize `verified` because an export ran.
Record source and output numbering from rendered PDFs/AUX, not guessed file
names. Compare neighboring figures to detect duplicate or displaced crops.
Retain original files or a timestamped backup before changing a batch.

## Choose the representation

- **Clean source vector PDF:** faithfully reuse a cropped PDF region if its
  typography and language suit the project. PyMuPDF `show_pdf_page(..., clip=...)`
  preserves paths, glyphs, shading and transparency; render the result to confirm
  what survived. Inspect `get_drawings()`, fonts and embedded images as diagnostics.
  A PDF container can contain a bitmap, so the extension alone proves nothing.
- **Native redraw:** use ordinary TikZ/PGFPlots for editable geometry and plots,
  or `tikzcd` for commutative diagrams. Recover the mathematical specification
  independently from the printed source. Use consistent line weights, arrowheads,
  fonts and palette, but preserve geometric and orientation facts. Curves should
  come from their known functions/parameters where possible, not arbitrary
  approximations. Check front/back occlusion, dashed hidden lines, projections,
  field direction, boundary signs, level spacing and shared scales explicitly.
- **Original raster/scan:** retain the source resolution or redraw when a reliable
  specification exists. Do not upsample and claim recovered detail. If a raster
  must be used, calculate effective PPI from pixels and displayed width; increasing
  render DPI cannot recover information absent from an embedded source bitmap.
- **Mixed diagrams:** preserve vectors while keeping unavoidable embedded images;
  record the exception instead of claiming the entire image is vector.

Translation inside the figure is a separate task: do not replace mathematical
symbols when changing English labels. For vector overlays, ensure the original
text is actually removed, no line is covered, glyphs are embedded and searchable,
and the Chinese labels fit at final size. For outlined source text, native redraw
may be safer than opaque boxes. If source labels remain, disclose that scope.

## Crop candidates are not truth

Create a manifest of physical pages and manually reviewable PDF-point bounds.
Automated caption bands, graphics boxes, image boxes and white-margin trimming
are candidate generators only. Typical failure modes:

- A text block merges spatially separated labels; using its width as a prose
  classifier discards an entire left panel or a remote formula.
- The largest graphic near a caption belongs to the next figure, particularly
  with side captions, stacked figures or captions broken across math spans.
- An axis or filled rectangle extends far beyond the few text labels used to
  seed the crop. A tangent-bundle diagram can shrink to one horizontal strip.
- Cropping to the main paths omits axes, negative ticks, isolated subpanels,
  panel letters, arrow tips, superscripts or long explanatory labels.
- A caption can start with raised math above the baseline of `Fig.`; subtracting
  a fixed amount from that baseline can still retain a formula fragment.
- Bézier path boxes may include distant control points, transformed paths or
  internal clipping. A path crossing a crop boundary is a warning, not proof
  of missing visible ink. Inspect the rendered original.
- White-margin sampling can miss fine or pale strokes. Keep a small physical
  safety margin and inspect every edge at high magnification.

For a side caption, isolate the correct horizontal region; expanding to a
full-page horizontal band reintroduces the caption. For two figures on one
page, compare top/bottom or left/right source regions separately. Store manual
overrides in the same manifest as the export source so a later script cannot
silently overwrite a repaired crop.

## Size from the content, not a universal percentage

Measure the final principal-label size and the available figure plus caption
height. Prefer `width=<fraction>\linewidth` so nested minipages behave correctly.
Do not prescribe 0.40–0.80 for every figure or clamp narrow/tall plots to one
minimum. PDF-point coordinates and native drawing coordinates can use physical
units; those are distinct from choosing the figure's displayed width.

Aim for principal labels near the book's small-text size; about 8–9 pt is a
useful starting point in an 11-pt book, not a universal pass criterion. Inspect
subscripts separately. A median over extracted spans can be dominated by
subscripts or omit outlined labels; use it to flag candidates, not certify
legibility. A crisp vector label can still be much too small.

Preserve aspect ratio. If width and height are both maximum constraints, use
`keepaspectratio`. Never stretch width and height independently. Reserve room
for the actual caption, including long translations.

For independent panels, reflow a very wide strip into two rows, or stack two
panels when it substantially improves label size. Preserve panel order and
identifiers. Never split a mapping diagram across an essential connecting arrow,
change common scales independently or drop connecting annotations. If a dense
figure cannot fit legibly, use a properly continued figure or justified larger
page layout instead of shrinking indefinitely. Preserve figure numbering and
cross-reference targets when introducing continued panels.

Use `\centering` within figures. Keep `\caption` before `\label`; preserve
existing labels and counters. Avoid wrapfigure where Chinese prose, display
math and theorem environments collide; choose standalone floats or a deliberate
minipage composition and inspect the resulting page flow.

## Verification that separates its claims

1. Compare the full source page with each crop, including every independent
   panel. Numbered contact sheets help cover a large inventory but cannot resolve
   tiny labels or subtle arrow styles; enlarge questionable regions.
2. Render each exported asset and compare it with the designated original region.
   For composed panels, compare each panel with its own original clip. Pixel
   differences detect export damage, but cannot validate a wrong input clip.
3. Compile the actual book until references and page positions stabilize. Inspect
   errors, missing glyphs, missing/duplicate references, oversized floats and
   overfull boxes. Compare pre-existing warnings with a saved baseline.
4. Map every figure label to its actual page and region in the final PDF. Verify
   asset inclusion/transforms and rendered content; do not assume the page from
   a previous build. Inspect each final figure/caption region, plus complete pages
   for dense, tall, reflowed and repaired figures and chapter boundaries.
5. Reconcile source identity, asset identity, rendered numbering, caption and
   reference target. Retain unresolved items with their exact figure/page.

Export completed, mathematical comparison completed and final-page visual review
completed are separate statuses. A successful compile or a high image similarity
score is not a substitute for any of the other checks.

## Demonstrated book-wide failure case

In Fortney's *A Visual Introduction to Differential Forms and Calculus on
Manifolds*, the existing translated project had 256 captions, 256 files and
no missing file paths, yet source comparison found severe defects: 1.8 retained
only the lower region, 2.17 retained a narrow strip of a tangent bundle, 7.3
used the region of 7.4, 9.9 used the next field diagram, 11.12 duplicated 11.11,
and 11.14 used the horizontal 11.15 instead of its vertical boundary diagram.
Other crops dropped negative level lines and isolated panels or included prose.
This case motivates identity/panel checks and final-size verification; it does
not justify reusing this book's crop coordinates or assuming every PDF has the
same failures.
