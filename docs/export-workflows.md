# Export Workflows

This page describes how document export is expected to work for `typst`, `latex`, and `quarto`.

## Recommended flow

1. Generate the stable report content first.
2. Convert that content into the chosen template source.
3. Return the source text directly.
4. Save the source file if the user asks for a file.
5. Keep the markdown output as the stable fallback when you need to show content separately from the template source.

This keeps the content logic and the export layer loosely coupled.

## Built-in template catalog

- `classic-report`: safest starter template for a short weekly progress report
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

## CJK note

For Chinese source export:
- Typst templates may still need a suitable CJK font once the user compiles them on their own machine
- LaTeX templates may still need `ctex` and matching fonts
- Quarto templates may depend on the user's downstream HTML or PDF toolchain

The skill itself should focus on producing clean source files rather than promising local rendering success.
