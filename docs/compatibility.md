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

Experimental templates with markdown fallback:
- `typst`
- `latex`
- `quarto`

The expected behavior for experimental requests is:
1. clearly state that the format is experimental
2. generate the markdown content first
3. optionally adapt that content into the template afterward

Current compile-time note:
- `templates/typst/slides.typ` depends on `@preview/touying:0.5.5`
- this is a template dependency, not part of the stable markdown-first path

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
- polished non-markdown export quality for every experimental template
- automatic judgment of scientific importance
- perfect style matching without real past samples
- a single profile that works equally well for every advisor personality

Those limits should be stated plainly so users know where the stable path ends.

## Recommended fallback strategy

If you are unsure which path to trust, use:
- `chat` for the fastest practical result
- `email` for the clearest advisor-facing structure
- `markdown` when you need something easy to reuse across slides, notes, or archives
