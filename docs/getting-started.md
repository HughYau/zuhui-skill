# Getting Started

This guide is for the first 10 minutes with `progress-report`.

Before anything else: keep this skill project-local when possible.

Best practice:
- put it inside the research repo you are actually reporting on
- or create a separate reporting workspace for one project or one advisor workflow
- avoid a global install unless you are very sure you want one shared setup across projects

## Choose the right path

Use Interactive Init if:
- you want a reusable setup but do not want to hand-write YAML
- you want Claude to ask a few onboarding questions and generate `.progress-config.yaml`
- you want to set default tone and lab-specific wording once

Run:

```text
/progress-report --init
```

Use Quick Mode if:
- you need a usable draft right now
- you do not have `.progress-config.yaml` yet
- you are reporting a one-off update

Use Full Mode if:
- you report progress every week
- you want separate profiles for advisor, co-advisor, group meeting, or collaborator
- you want the skill to remember the last reporting period
- you want git history and artifact scanning to work together

## Fastest first run

Run:

```text
/progress-report --quick
```

You will only be asked:
1. who the message is for
2. what communication setting it is for
3. what changed recently

This path is the lowest-friction option and is the recommended default for new users.

## Move to reusable setup

When Quick Mode proves useful, create reusable project-local files:

1. Either run `/progress-report --init` or copy `samples/example-config.yaml` to `.progress-config.yaml`.
2. Adjust the profiles you actually need.
3. Set `tone`, `vocabulary`, and `render` before you over-customize style learning.
4. Let the skill create or update `.progress-state.yaml` after a confirmed run.

Recommended starter profiles:
- `weekly-email` for a detailed advisor message
- `group-meeting` for markdown slides or a report
- `quick-sync` for short chat updates

## What to configure first

The highest-value fields to edit are:
- `audience`
- `advisor_preset`
- `format`
- `language`
- `tone`
- `vocabulary`
- `artifacts.scan_dirs`
- `render.format`
- `render.template`

Leave style learning empty until you have a few real past reports to learn from.

## What good input looks like

The skill works best when it can combine:
- git activity
- result artifacts such as figures, notebooks, CSV files, and notes
- your own short explanation of discussions, dead ends, or decisions

If your real progress mostly lives outside git, say that early and rely more on artifact scanning plus spoken context.

## Common workflow

1. Run Quick Mode once to get a feel for the output.
2. Run Interactive Init when you are ready for a reusable setup.
3. Set up one profile for your main advisor.
4. Add artifact directories that matter in your workflow.
5. If you need formal document source, set `render.format` to `typst` or `latex` and keep `render.template: classic-report` for the first export.
6. Use Full Mode for your next weekly update.
7. Only after the draft is acceptable, let the skill update `.progress-state.yaml`.

## Output expectations

The generated result should always make these items easy to scan:
- progress made
- confidence level or evidence quality
- blockers
- requests for decisions or help
- next steps

Example outputs:
- [Email sample (Chinese)](../samples/example-output-email-zh.md)
- [Email sample (English)](../samples/example-output-email-en.md)
- [Chat sample](../samples/example-output-chat.md)
- [Markdown report sample](../samples/example-output-report.md)

If you hit an edge case, check [FAQ](faq.md) before expanding the config.
For document source export, see [Export Workflows](export-workflows.md).
