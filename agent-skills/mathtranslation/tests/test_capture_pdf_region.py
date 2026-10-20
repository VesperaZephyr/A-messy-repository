"""Executable geometry and failure-path checks; no external documents needed."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

import pymupdf

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts' / 'capture_pdf_region.py'
SPEC = importlib.util.spec_from_file_location('capture_pdf_region', SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class CaptureTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.folder = Path(self.temp.name) / '中文路径'
        self.folder.mkdir()
        self.source = self.folder / '原书.pdf'
        with pymupdf.open() as doc:
            page = doc.new_page(width=300, height=200)
            page.draw_rect((30, 20, 90, 70), fill=(1, 0, 0), color=None)
            page.insert_text((120, 100), 'source label')
            doc.new_page(width=100, height=100)
            doc.save(self.source)
        self.source_bytes = self.source.read_bytes()

    def tearDown(self):
        self.temp.cleanup()

    def test_vector_crop_provenance_and_unicode(self):
        out = self.folder / 'figure-1.2'
        result = MODULE.capture(self.source, 1, out, [20, 10, 100, 80], 144)
        self.assertEqual(result['preview_size_px'], [160, 140])
        self.assertEqual(result['status'], 'exported_unreviewed')
        self.assertEqual(json.loads(Path(str(out) + '.json').read_text('utf-8')), result)
        with pymupdf.open(str(out) + '.pdf') as doc:
            self.assertEqual(list(doc[0].rect), [0, 0, 80, 70])
            self.assertTrue(doc[0].get_drawings())
            self.assertFalse(doc[0].get_images())
        self.assertEqual(self.source.read_bytes(), self.source_bytes)

    def test_rotations_match_visible_original(self):
        for angle in (0, 90, 180, 270):
            with self.subTest(angle=angle):
                source = self.folder / f'rotated-{angle}.pdf'
                with pymupdf.open(self.source) as doc:
                    doc[0].set_rotation(angle)
                    doc.save(source)
                out = self.folder / f'preview-{angle}'
                MODULE.capture(source, 1, out, dpi=72)
                with pymupdf.open(source) as doc:
                    expected = doc[0].get_pixmap(alpha=False)
                actual = pymupdf.Pixmap(str(out) + '.png')
                self.assertEqual((actual.width, actual.height), (expected.width, expected.height))
                self.assertEqual(actual.samples, expected.samples)

    def test_rotated_crop_location(self):
        source = self.folder / 'rotated-crop.pdf'
        with pymupdf.open(self.source) as doc:
            doc[0].set_rotation(90)
            doc.save(source)
        out = self.folder / 'rotated-clip'
        MODULE.capture(source, 1, out, [130, 30, 180, 90], 72)
        pix = pymupdf.Pixmap(str(out) + '.png')
        self.assertEqual(pix.pixel(25, 30), (255, 0, 0))

    def test_nonzero_cropbox(self):
        source = self.folder / 'cropbox.pdf'
        with pymupdf.open(self.source) as doc:
            doc[0].set_cropbox(pymupdf.Rect(10, 5, 280, 190))
            doc[0].set_rotation(270)
            doc.save(source)
        out = self.folder / 'cropbox-preview'
        MODULE.capture(source, 1, out, dpi=72)
        with pymupdf.open(source) as doc:
            expected = doc[0].get_pixmap(alpha=False)
        self.assertEqual(pymupdf.Pixmap(str(out) + '.png').samples, expected.samples)

    def test_scan_stays_raster(self):
        scan = self.folder / 'scan.pdf'
        pix = pymupdf.Pixmap(pymupdf.csRGB, pymupdf.IRect(0, 0, 40, 30), False)
        pix.clear_with(100)
        with pymupdf.open() as doc:
            page = doc.new_page(width=80, height=60)
            page.insert_image(page.rect, pixmap=pix)
            doc.save(scan)
        out = self.folder / 'scan-crop'
        MODULE.capture(scan, 1, out)
        with pymupdf.open(str(out) + '.pdf') as doc:
            self.assertTrue(doc[0].get_images())

    def test_blank_page(self):
        result = MODULE.capture(self.source, 2, self.folder / 'blank', dpi=72)
        self.assertEqual(result['preview_size_px'], [100, 100])

    def test_invalid_inputs_create_no_output(self):
        for bbox in ([100, 0, 20, 50], [-1, 0, 20, 50], [0, 0, 301, 50],
                     [0, 0, float('nan'), 50], [1, 1, 1, 20]):
            with self.subTest(bbox=bbox):
                with self.assertRaises(ValueError):
                    MODULE.capture(self.source, 1, self.folder / 'bad', bbox)
        for page in (0, 3):
            with self.assertRaises(ValueError):
                MODULE.capture(self.source, page, self.folder / 'bad')
        with self.assertRaises(ValueError):
            MODULE.capture(self.source, 1, self.folder / 'bad', dpi=0)
        self.assertFalse(list(self.folder.glob('bad.*')))

    def test_refuses_accidental_overwrite(self):
        out = self.folder / 'existing'
        MODULE.capture(self.source, 1, out)
        with self.assertRaises(FileExistsError):
            MODULE.capture(self.source, 1, out)
        MODULE.capture(self.source, 1, out, overwrite=True)
        with self.assertRaises(ValueError):
            MODULE.capture(self.source, 1, self.source.with_suffix(''), overwrite=True)


if __name__ == '__main__':
    unittest.main()
