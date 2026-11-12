---
name: docx
description: Create or edit Word documents (.docx) with python-docx.
version: 1.0.0
author: Martin Etzrodt
license: CC-BY-4.0
metadata:
  hermes:
    tags: [docx, word, documents, memo, letter, report]
    related_skills: [pdf, ocr-and-documents]
---

# Word documents (.docx)

Use when the reader asks for a Word file, a .docx, or a document they will edit,
comment on or forward as an attachment: memo, letter, position paper, report,
minutes, a one-pager. For a fixed-layout read-only file use the `pdf` skill. For
slides use a deck skill. To *read* an incoming .docx or PDF use `ocr-and-documents`.

## Rules

- **Use python-docx, never hand-written OOXML.** Writing `document.xml` with
  zipfile and string templates works for plain paragraphs and breaks on tables,
  images, headers, lists and anything the reader edits later. If an older
  stdlib writer (`mkdocx.py`, `make_docx.py`) is lying around, do not extend it.
- One build script per document (`build_<topic>_docx.py`) next to the output, so
  a revision is an edit and a rerun, not a rewrite. Keep the text in the script
  or in a Markdown file the script reads; never retype numbers from a dataset
  into prose, compute them in the script.
- Real characters in the source: write `ä ö ü é` in the build script, not `ae oe
  ue`. A generator written in ASCII puts ASCII into the document. Apply the
  person's writing-style rules (dashes, quotes, spelling) to the text you write.
- Use the built-in styles (`Heading 1..3`, `List Bullet`, `List Number`,
  `Table Grid`, `Title`). Direct formatting on every run makes the file
  impossible to restyle in Word.
- Set title and author in core properties; the reader's mail client and file
  browser show them.

## Example (complete, tested)

```python
#!/usr/bin/env python3
"""Build a Word document. python-docx 1.1.2."""
from docx import Document
from docx.enum.section import WD_ORIENT
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt

OUT = "memo-example.docx"

def page_number_field(paragraph):
    """Insert a live PAGE field (Word updates it; there is no API for this)."""
    run = paragraph.add_run()
    for tag, attr in (("w:fldChar", {"w:fldCharType": "begin"}),
                      ("w:instrText", None),
                      ("w:fldChar", {"w:fldCharType": "end"})):
        el = OxmlElement(tag)
        if attr:
            for k, v in attr.items():
                el.set(qn(k), v)
        else:
            el.set(qn("xml:space"), "preserve")
            el.text = "PAGE"
        run._r.append(el)

doc = Document()

# A4 portrait, 2.5 cm margins (python-docx defaults to US Letter).
sec = doc.sections[0]
sec.orientation = WD_ORIENT.PORTRAIT
sec.page_width, sec.page_height = Cm(21.0), Cm(29.7)
for side in ("left_margin", "right_margin", "top_margin", "bottom_margin"):
    setattr(sec, side, Cm(2.5))

# Base font once, on the Normal style, not per run.
normal = doc.styles["Normal"]
normal.font.name = "Calibri"
normal.font.size = Pt(11)

doc.core_properties.title = "Memo: Beispiel"
doc.core_properties.author = "Author Name"

# Footer with centred page number.
fp = sec.footer.paragraphs[0]
fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
page_number_field(fp)

doc.add_heading("Memo: Beispiel", level=0)          # Title style
p = doc.add_paragraph()
p.add_run("Datum: ").bold = True
p.add_run("12. November 2026")

doc.add_heading("Ausgangslage", level=1)
doc.add_paragraph("Fliesstext mit Umlauten: Prüfung, Übergabe, Änderung.")
for item in ("Erster Punkt", "Zweiter Punkt"):
    doc.add_paragraph(item, style="List Bullet")
for item in ("Schritt eins", "Schritt zwei"):
    doc.add_paragraph(item, style="List Number")

doc.add_heading("Zahlen", level=1)
rows = [("Posten", "Betrag CHF"), ("Miete", "12'000"), ("Personal", "48'500")]
table = doc.add_table(rows=len(rows), cols=2, style="Table Grid")
table.alignment = WD_TABLE_ALIGNMENT.CENTER
for r, (a, b) in enumerate(rows):
    table.cell(r, 0).text, table.cell(r, 1).text = a, b
    table.cell(r, 1).paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.RIGHT
for cell in table.rows[0].cells:                      # bold header row
    for run in cell.paragraphs[0].runs:
        run.bold = True

# Images: doc.add_picture("chart.png", width=Cm(15))  (PNG/JPEG; render
# charts with matplotlib at dpi=200 first).

doc.add_page_break()
doc.add_heading("Anhang", level=1)
doc.add_paragraph("Quellen und Methode.")

doc.save(OUT)
print("wrote", OUT)
```

## Editing an existing .docx

`Document("in.docx")`, change, `save("in-v2.docx")` under a new name; never
overwrite the reader's original. Text is split into runs at arbitrary points
(spell-check marks, formatting changes), so `"old" in run.text` misses most
real occurrences. Search `paragraph.text`; when it matches, put the new text in
the first run and clear the others (this keeps the first run's formatting).
Walk `doc.paragraphs` *and* every `table.cell(...).paragraphs`, and the header
and footer of each section.

python-docx 1.1.2 has **no API for comments or tracked changes**. Do not fake
them with coloured text and call it "tracked changes". Say so, and deliver a
clean revised copy plus a short list of what changed.

## Verify the saved file (required)

There is no LibreOffice on a headless box, so nothing renders the page. Check
the **saved file**, not the script's intent:

```python
from docx import Document
import re, sys
d = Document(sys.argv[1])
print("sections:", len(d.sections), "page cm:",
      round(d.sections[0].page_width.cm, 1), "x", round(d.sections[0].page_height.cm, 1))
for p in d.paragraphs:
    if p.style.name.startswith(("Heading", "Title")):
        print(f"  {p.style.name:10} {p.text}")
print("tables:", len(d.tables), "| inline images:", len(d.inline_shapes))
text = "\n".join(p.text for p in d.paragraphs)
ascii_umlauts = sorted(set(re.findall(r"\b\w*(?:ae|oe|ue)\w*\b", text)))
print("check these for ASCII umlauts:", ascii_umlauts[:20])
print("empty paragraphs (each page break is one):", sum(1 for p in d.paragraphs if not p.text.strip()))
```

The ASCII-umlaut list has false positives (Israel, Duett, Quelle): read it,
don't auto-replace. Then tell the reader honestly that the layout was checked
structurally, not looked at, and that Word will show the final rendering.

If they need to *see* it before opening Word, render the same content through
the `pdf` skill as a preview. There is no docx-to-PDF converter here.

## Deliver

Descriptive filename with a date (`memo-rahmen-2026-11-12.docx`, no spaces).
On Hermes, attach it with a line of its own in the reply:

```
MEDIA:/absolute/path/memo-rahmen-2026-11-12.docx
```

followed by two or three sentences on what is in it and what to check.

## Install

`python3 -m pip install --user --break-system-packages python-docx==1.1.2`
(Debian's python3.13 has no ensurepip, so a venv cannot bootstrap pip).
