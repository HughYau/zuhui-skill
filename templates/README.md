# Templates

This directory contains the built-in document export templates used by `progress-report`.

## Template names

- `classic-report`
  - Typst: `templates/typst/report.typ`
  - LaTeX: `templates/latex/report.tex`
  - Quarto: `templates/quarto/report.qmd`
- `thesis-status`
  - Typst: `templates/typst/thesis-status.typ`
  - LaTeX: `templates/latex/thesis-status.tex`
  - Quarto: `templates/quarto/thesis-status.qmd`
- `lab-slides`
  - Typst: `templates/typst/slides.typ`
  - LaTeX: `templates/latex/slides.tex`
  - Quarto: `templates/quarto/slides.qmd`

## Design goals

- Every template should stay readable with ASCII-only sample content.
- Comments may mention optional CJK setup, but the default source should stay minimal.
- The source should be readable enough for users to patch without reverse engineering a large theme.
