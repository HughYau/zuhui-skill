# Export Workflows

This page describes how document export is expected to work for `typst`, `latex`, and `quarto`.

## Recommended flow

1. Generate the stable report content first.
2. Convert that content into the chosen template source.
3. Detect the local toolchain.
4. Compile when available.
5. If compilation fails, keep the markdown output and return the source file plus a short failure summary.

This keeps the content logic and the PDF/export layer loosely coupled.

## Toolchain detection

Use these commands:

```text
typst --version
pdflatex --version
quarto --version
```

If a command is unavailable, the export path should not be treated as failed research reporting. It should simply fall back to markdown plus source.

## Built-in template catalog

- `classic-report`: safest first smoke test for a short weekly progress report
- `thesis-status`: chapter-style progress note for thesis-oriented reporting
- `lab-slides`: meeting slides with a simple section structure

Current file mapping:

- Typst:
  - `templates/typst/report.typ`
  - `templates/typst/thesis-status.typ`
  - `templates/typst/slides.typ`
- LaTeX:
  - `templates/latex/report.tex`
  - `templates/latex/thesis-status.tex`
  - `templates/latex/slides.tex`
- Quarto:
  - `templates/quarto/report.qmd`
  - `templates/quarto/thesis-status.qmd`
  - `templates/quarto/slides.qmd`

## Compile commands

Typst:

```text
typst compile templates/typst/report.typ
typst compile templates/typst/thesis-status.typ
```

LaTeX:

```text
pdflatex -interaction=nonstopmode -halt-on-error templates/latex/report.tex
pdflatex -interaction=nonstopmode -halt-on-error templates/latex/thesis-status.tex
```

Quarto:

```text
quarto render templates/quarto/report.qmd --to pdf
quarto render templates/quarto/thesis-status.qmd --to pdf
```

## CJK note

ASCII-only smoke tests are the most reliable baseline.

For Chinese PDF export:
- Typst usually needs a suitable CJK font
- LaTeX often needs `ctex` and matching fonts
- Quarto PDF may depend on the underlying LaTeX stack

If Chinese content fails to compile, the tool should report the missing dependency instead of pretending the export succeeded.
