# Compatibility

This document makes the supported paths explicit so users do not have to guess what is stable.

## Communication targets

The repo is designed to adapt to:
- main advisor updates
- co-advisor updates
- lab meeting summaries
- collaborator syncs

The mechanism is the same in all cases: collect evidence, shape detail level through `advisor_preset`, and keep asks visible.

## Supported output formats

Stable in V1:
- `email`
- `chat`
- `markdown`

Document export paths with markdown-first fallback:
- `typst`
- `latex`
- `quarto`

The expected behavior for document export requests is:
1. generate the markdown content first
2. adapt that content into the chosen template
3. detect whether the local toolchain exists
4. attempt compilation when possible
5. fall back to markdown plus source files if compilation is unavailable or fails

Current compile-time note:
- `templates/typst/slides.typ` depends on `@preview/touying:0.5.5`
- this is a template dependency, not part of the stable markdown-first path
- LaTeX PDF output assumes a working `pdflatex` installation
- Quarto PDF output assumes both `quarto` and a PDF backend such as LaTeX

Built-in safe starter templates:
- `classic-report`: first smoke test for short reports
- `thesis-status`: report-style structure for longer progress notes
- `lab-slides`: meeting slides for `markdown`, `typst`, `latex`, or `quarto`

## Language coverage

The skill is designed for:
- `zh`
- `en`
- `bilingual`

Language support includes separate anti-AI cleanup references for Chinese and English so the wording rules do not have to be shared blindly across both languages.

## Usage modes

Quick Mode is best for:
- emergency updates
- first-time users
- projects without config files

Full Mode is best for:
- recurring weekly reporting
- multiple communication profiles
- git plus artifact based evidence collection
- overlap prevention between reporting periods

## What this repo does not promise yet

This repository does not currently promise:
- polished non-markdown export quality for every template-engine-language combination
- automatic judgment of scientific importance
- perfect style matching without real past samples
- a single profile that works equally well for every advisor personality
- successful CJK PDF compilation on machines without the necessary fonts or TeX packages

Those limits should be stated plainly so users know where the stable path ends.

## Recommended fallback strategy

If you are unsure which path to trust, use:
- `chat` for the fastest practical result
- `email` for the clearest advisor-facing structure
- `markdown` when you need something easy to reuse across slides, notes, or archives
- `typst` or `latex` only after a `classic-report` smoke test succeeds locally
