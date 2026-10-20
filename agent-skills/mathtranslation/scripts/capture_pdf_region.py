"""Export a reviewed-by-caller PDF region plus PNG and provenance (PyMuPDF)."""
import argparse
import hashlib
import json
import math
from pathlib import Path

import pymupdf


def capture(source, page_number, output, bbox=None, dpi=180, overwrite=False):
    source, output = Path(source).resolve(), Path(output).resolve()
    if not math.isfinite(dpi) or not 36 <= dpi <= 600:
        raise ValueError("dpi must be finite and between 36 and 600")
    if not callable(getattr(pymupdf.Page, 'remove_rotation', None)):
        raise ValueError("PyMuPDF Page.remove_rotation is required; upgrade PyMuPDF")
    # Treat output as a prefix, including dots in figure identifiers.
    paths = {ext: Path(str(output) + '.' + ext) for ext in ('pdf', 'png', 'json')}
    if source in paths.values():
        raise ValueError("output must not overwrite the source")
    if not overwrite and any(p.exists() for p in paths.values()):
        raise FileExistsError("output exists; choose another prefix or use --overwrite")
    with pymupdf.open(source) as original:
        if original.needs_pass:
            raise ValueError("encrypted PDF requires an accessible input copy")
        if not 1 <= page_number <= len(original):
            raise ValueError(f"physical page must be 1..{len(original)}")
        original_page = original[page_number - 1]
        rotation = original_page.rotation
        with pymupdf.open() as normalized:
            # First materialize the visible CropBox on a matching MediaBox.
            # remove_rotation() alone can reset a non-default CropBox.
            with pymupdf.open() as working:
                working.insert_pdf(original, from_page=page_number - 1,
                                   to_page=page_number - 1, links=False, annots=False)
                working[0].set_rotation(0)
                visible = working[0].rect
                flat = normalized.new_page(width=visible.width, height=visible.height)
                if working[0].get_contents():
                    flat.show_pdf_page(flat.rect, working, 0, clip=visible)
                flat.set_rotation(rotation)
            # Bake page rotation into content, yielding top-left visible coordinates.
            normalized[0].remove_rotation()
            page = normalized[0]
            bounds = page.rect
            values = list(bounds) if bbox is None else list(bbox)
            if len(values) != 4 or not all(math.isfinite(v) for v in values):
                raise ValueError("bbox needs four finite coordinates")
            x0, y0, x1, y1 = values
            if not (bounds.x0 <= x0 < x1 <= bounds.x1 and
                    bounds.y0 <= y0 < y1 <= bounds.y1):
                raise ValueError(f"bbox must be nonempty and inside visible page {list(bounds)}")
            clip = pymupdf.Rect(values)
            if math.ceil(clip.width * dpi / 72) * math.ceil(clip.height * dpi / 72) > 60_000_000:
                raise ValueError("preview exceeds 60 million pixels; reduce dpi or crop")
            with pymupdf.open() as asset:
                target = asset.new_page(width=clip.width, height=clip.height)
                if page.get_contents():
                    target.show_pdf_page(target.rect, normalized, 0, clip=clip)
                pix = target.get_pixmap(dpi=dpi, alpha=False)
                with source.open('rb') as stream:
                    digest = hashlib.sha256()
                    for chunk in iter(lambda: stream.read(1024 * 1024), b''):
                        digest.update(chunk)
                    source_hash = digest.hexdigest()
                metadata = {
                    'source': str(source),
                    'source_sha256': source_hash,
                    'physical_page_1based': page_number,
                    'source_rotation': rotation,
                    'source_annotation_count': len(list(original_page.annots() or [])),
                    'coordinate_system': 'visible-page-top-left-points',
                    'visible_page_bounds_pt': list(bounds),
                    'bbox_pt': values, 'dpi': dpi,
                    'preview_size_px': [pix.width, pix.height],
                    'outputs': {k: str(v) for k, v in paths.items()},
                    'status': 'exported_unreviewed',
                    'note': 'PDF content reused; raster sources remain raster. Annotations excluded.',
                }
                output.parent.mkdir(parents=True, exist_ok=True)
                asset.save(paths['pdf'], garbage=4, deflate=True)
                pix.save(paths['png'])
                paths['json'].write_text(json.dumps(metadata, ensure_ascii=False, indent=2),
                                         encoding='utf-8')
    return metadata


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--page', type=int, required=True, help='1-based physical PDF page')
    parser.add_argument('--bbox', type=float, nargs=4, metavar=('X0', 'Y0', 'X1', 'Y1'))
    parser.add_argument('--out', type=Path, required=True, help='output prefix, without extension')
    parser.add_argument('--dpi', type=int, default=180)
    parser.add_argument('--overwrite', action='store_true')
    args = parser.parse_args()
    try:
        metadata = capture(args.source, args.page, args.out, args.bbox, args.dpi, args.overwrite)
    except (ValueError, OSError, RuntimeError) as exc:
        parser.exit(2, f'capture failed: {exc}\n')
    print(json.dumps(metadata, ensure_ascii=True, indent=2))


if __name__ == '__main__':
    main()
