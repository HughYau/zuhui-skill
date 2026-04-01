# FAQ

## I do not have any config yet. Should I still use this skill?

Yes. Start with:

```text
/progress-report --quick
```

That is the intended first-run path when you want the lowest setup cost.

## I have no git history for the real progress. Is this still useful?

Yes. The skill should fall back to:
- artifact scanning
- your own short description
- discussion notes, reading notes, and offline experiments

Git is helpful, not mandatory.

## I do not have artifact folders like `results/` or `notebooks/`.

That should not block usage. Start with Quick Mode or a minimal config, then add directories later only if they are actually part of your workflow.

## Most of my progress happened in meetings, reading, or failed attempts.

That still counts as reportable progress.

The skill is supposed to surface:
- decisions that were made
- dead ends that changed your plan
- blockers that need help
- next steps that follow from those discussions

## I need something sendable in English.

Use an English profile or set:

```yaml
language: en
```

If you switch audiences often, use profile recipes as the starting point rather than rewriting everything manually.

## I need Chinese and English from the same material.

Use `bilingual` only when you genuinely need one shared source draft. If you only need one outward-facing message, choose the target language directly because it produces a cleaner result with less cleanup.

## I asked for Typst, LaTeX, or Quarto. Why is markdown still mentioned?

Because those formats are experimental in this repo.

The stable path is:
1. generate the markdown content first
2. reuse or convert it into the experimental template

This keeps the reporting logic stable even when the export layer is still evolving.

## When does `.progress-state.yaml` get updated?

Only after the generated result is confirmed as usable. This avoids locking in a bad period boundary from a draft you do not want to keep.

## I only want one reusable profile. Which one should I start with?

Start with `weekly-email` from [example-config.minimal.yaml](../samples/example-config.minimal.yaml). It is the fastest path to a reusable setup without learning the entire config structure.
