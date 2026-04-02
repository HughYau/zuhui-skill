# FAQ

## I do not have any config yet. Should I still use this skill?

Yes. Start with:

```text
/progress-report --quick
```

That is the intended first-run path when you want the lowest setup cost.

If you already know you want a reusable setup, use:

```text
/progress-report --init
```

That path asks a few onboarding questions and generates `.progress-config.yaml` for you.

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

Because the repo uses a markdown-first export path on purpose.

The stable logic is:
1. generate the markdown content first
2. reuse or convert it into the document template
3. return or save the document source file

This keeps the reporting logic stable even when the export layer is still evolving.

## How do I make the wording sound like my lab instead of generic AI text?

Use `vocabulary` in `.progress-config.yaml` and keep it small and intentional.

Example:

```yaml
vocabulary:
  - concept: "run experiments"
    preferred: "炼丹"
  - concept: "ablation study"
    preferred: "控制变量"
```

The skill should then keep those terms consistent in the final report.

## What is `tone` for?

Use `tone` when you want the same facts presented with different rhetorical emphasis.

- `neutral`: default weekly update
- `struggling`: blocker-heavy update where you need help
- `triumphant`: breakthrough-heavy update where you need to surface impact clearly

`tone` changes framing, not the evidence standard. It must not be used to exaggerate results.

## When does `.progress-state.yaml` get updated?

Only after the generated result is confirmed as usable. This avoids locking in a bad period boundary from a draft you do not want to keep.

## I only want one reusable profile. Which one should I start with?

Start with `weekly-email` from [example-config.minimal.yaml](../assets/samples/example-config.minimal.yaml). It is the fastest path to a reusable setup without learning the entire config structure.
