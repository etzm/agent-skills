---
name: pdf
description: Create PDFs: HTML+CSS printed by headless Chromium.
version: 1.0.0
author: Martin Etzrodt
license: CC-BY-4.0
metadata:
  hermes:
    tags: [pdf, documents, report, print, html]
    related_skills: [docx, ocr-and-documents]
---

# Creating PDFs

Use when the reader wants a PDF: a report, handout, one-pager, letter to sign,
anything with a fixed layout that should look the same everywhere. If they
will edit it, use the `docx` skill instead. To *read* or OCR an existing PDF use
`ocr-and-documents`.

## The route: HTML + print CSS → headless Chromium

On a headless Linux box without LaTeX, pandoc, WeasyPrint, ReportLab or
LibreOffice, the one engine that is installed and good is the browser.
Chromium's print engine supports `@page` size and margins, page-number margin
boxes, repeated table headers and page breaks, and embeds the fonts. Write the
document as one HTML file with a `<style>` block, print it, then check the
result. Do not try to install a PDF toolchain with apt (no root) or pip unless
the reader asks; this route already covers reports.

- Fonts: use installed ones (`fc-list : family`; typically DejaVu Sans/Serif,
  Liberation Sans/Serif, FreeSans). A web font that has to be downloaded makes
  printing depend on the network; don't.
- Images and charts: reference local files by absolute path or embed them.
  For charts, write matplotlib SVG (`fig.savefig("c.svg")`) and `<img src>` it:
  vector, sharp at any zoom.
- Real characters (`ä ö ü é`) in the source, `<meta charset="utf-8">`, and the
  document language in `<html lang>` so hyphenation works.
- Markdown source: there is no Markdown converter installed. Write the HTML
  directly (headings, `<p>`, `<ul>`, `<table>`); it is short.

## Example (complete, tested)

```python
#!/usr/bin/env python3
"""Build a PDF from HTML with headless Chromium."""
import html, os, subprocess

OUT_HTML, OUT_PDF = "report-example.html", "report-example.pdf"
rows = [("Miete", 12000), ("Personal", 48500), ("Reisen", 3150)]
total = sum(v for _, v in rows)                      # compute, never retype

def chf(v): return f"{v:,}".replace(",", "'")

body_rows = "\n".join(
    f"<tr><td>{html.escape(k)}</td><td class=num>{chf(v)}</td></tr>" for k, v in rows)

doc = f"""<!doctype html>
<html lang="de"><head><meta charset="utf-8"><title>Bericht: Beispiel</title>
<style>
  @page {{
    size: A4; margin: 22mm 20mm 25mm 20mm;
    @bottom-center {{ content: "Seite " counter(page) " von " counter(pages);
                      font: 8.5pt "DejaVu Sans"; color: #666; }}
  }}
  body  {{ font: 10.5pt/1.45 "DejaVu Sans", sans-serif; color: #1d1d1d; }}
  h1    {{ font-size: 20pt; margin: 0 0 4mm; }}
  h2    {{ font-size: 13pt; margin: 7mm 0 2mm; break-after: avoid; }}
  .meta {{ color: #666; margin-bottom: 8mm; }}
  table {{ width: 100%; border-collapse: collapse; margin: 3mm 0; }}
  th, td {{ border-bottom: 0.5pt solid #bbb; padding: 1.5mm 2mm; text-align: left; }}
  thead {{ display: table-header-group; }}           /* repeat on every page */
  tr    {{ break-inside: avoid; }}
  .num  {{ text-align: right; font-variant-numeric: tabular-nums; }}
  tfoot td {{ font-weight: bold; border-top: 1pt solid #1d1d1d; }}
  .page-break {{ break-before: page; }}
</style></head><body>
<h1>Bericht: Beispiel</h1>
<div class="meta">12. November 2026</div>
<h2>Ausgangslage</h2>
<p>Fliesstext mit Umlauten: Prüfung, Übergabe, Änderung.</p>
<ul><li>Erster Punkt</li><li>Zweiter Punkt</li></ul>
<h2>Kosten</h2>
<table>
  <thead><tr><th>Posten</th><th class=num>CHF</th></tr></thead>
  <tbody>{body_rows}</tbody>
  <tfoot><tr><td>Total</td><td class=num>{chf(total)}</td></tr></tfoot>
</table>
<h2 class="page-break">Anhang</h2>
<p>Quellen und Methode.</p>
</body></html>"""

with open(OUT_HTML, "w", encoding="utf-8") as f:
    f.write(doc)

subprocess.run(
    ["timeout", "120", "chromium", "--headless=new", "--no-sandbox", "--disable-gpu",
     "--no-pdf-header-footer", f"--print-to-pdf={os.path.abspath(OUT_PDF)}",
     "file://" + os.path.abspath(OUT_HTML)],
    check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
print("wrote", OUT_PDF)
```

Notes on the flags: `--no-pdf-header-footer` removes Chromium's default
date/URL header and footer (the `@bottom-center` box above replaces it).
`timeout` matters: a page that waits on the network can keep a headless
Chromium alive, and leaked browsers are what eat memory on a small box.

## Verify the saved PDF (required)

```bash
pdfinfo report-example.pdf | grep -E "Pages|Page size"      # A4 = 595 x 842 pts
pdffonts report-example.pdf                                  # all fonts "emb yes"
pdftotext -layout report-example.pdf - | head -40            # text, umlauts, totals
pdftoppm -r 60 -png report-example.pdf preview               # preview-1.png, ...
```

Then **look at the preview PNGs** with your vision: page breaks in sensible
places, no table split mid-row, no heading alone at the bottom of a page, page
numbers present. Unlike Word or PowerPoint files on this box, this is a real
rendering of the real file, so you may say you checked the layout. Delete the
preview PNGs and keep the HTML next to the PDF; the next revision is an edit
and a rerun.

## Other routes, for narrow cases

- Chart-only or figure-heavy pages: matplotlib `PdfPages` writes PDF directly,
  no browser needed.
- A Word document as PDF: there is no docx-to-PDF converter without
  LibreOffice. Build both from the same content (this skill for the PDF,
  `docx` for the Word file) rather than converting.
- Editing text inside an existing PDF is a different job; PDFs are not meant
  for that. Rebuild from source, or say it can't be done cleanly.

## Deliver

Descriptive filename with a date, no spaces. On Hermes, attach it with a line
of its own in the reply:

```
MEDIA:/absolute/path/report-kosten-2026-11-12.pdf
```

followed by two or three sentences on what is in it.
