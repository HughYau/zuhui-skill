# Getting Started

This guide is for the first 10 minutes with `progress-report`.

## Choose the right path

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

1. Copy `samples/example-config.yaml` to `.progress-config.yaml`.
2. Adjust the profiles you actually need.
3. Let the skill create or update `.progress-state.yaml` after a confirmed run.

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
- `artifacts.scan_dirs`

Leave style learning empty until you have a few real past reports to learn from.

## What good input looks like

The skill works best when it can combine:
- git activity
- result artifacts such as figures, notebooks, CSV files, and notes
- your own short explanation of discussions, dead ends, or decisions

If your real progress mostly lives outside git, say that early and rely more on artifact scanning plus spoken context.

## Common workflow

1. Run Quick Mode once to get a feel for the output.
2. Set up one profile for your main advisor.
3. Add artifact directories that matter in your workflow.
4. Use Full Mode for your next weekly update.
5. Only after the draft is acceptable, let the skill update `.progress-state.yaml`.

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
