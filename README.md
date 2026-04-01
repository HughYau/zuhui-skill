# progress-report

Generate research progress updates that are actually usable: quick when you are in a rush, structured when you need repeatable weekly reporting.

`progress-report` is a Claude Code skill for grad students and researchers who need to report to advisors, lab meetings, and collaborators without rewriting the same update from scratch every week.

## What it produces

- **Email** for advisor updates
- **Chat** for WeChat, Slack, or Teams syncs
- **Markdown** for reports or meeting notes
- **Typst/LaTeX/Quarto** templates for formal outputs, marked as experimental with markdown fallback

Every generated output keeps four things visible:
- progress
- questions or decisions needed
- blockers
- next steps

## Why this repo exists

The skill is designed around three practical problems:
- research progress is spread across git commits, figures, notebooks, notes, and offline discussions
- different audiences want different levels of detail
- most AI-generated updates sound generic unless tone, evidence, and confidence are controlled

## Quick Mode

Use Quick Mode when you need a sendable update immediately.

```text
/progress-report --quick
```

Quick Mode asks only three questions:
1. Who is this for?
2. What is the communication context?
3. What did you do recently?

It skips style learning and produces a directly editable draft with default de-AI rules.

## Full Mode

Use Full Mode when you want repeatable weekly reporting with profiles, artifact scanning, and period tracking.

```text
/progress-report --profile weekly-email
/progress-report --format chat --since "last monday"
```

Full Mode uses:
- `.progress-config.yaml` for profiles, style, repos, and artifact directories
- `.progress-state.yaml` for the last report boundary, overlap prevention, and history

## 中文快速上手

如果你只是想先把这周汇报发出去，直接用：

```text
/progress-report --quick
```

如果你希望长期复用同一套导师/组会模板，用：

```text
/progress-report --profile weekly-email
```

这个 skill 的核心不是“帮你写得更像 AI”，而是让汇报更容易被导师快速看懂：
- 做了什么
- 证据够不够
- 卡在哪里
- 需不需要对方拍板

## First Run

1. Install the skill in Claude Code.
2. Start with `/progress-report --quick` if you want the lowest-friction path.
3. Move to Full Mode when you want reusable profiles and time-range tracking.
4. Copy the sample config and state files when you are ready to customize:
   - `samples/example-config.yaml`
   - `samples/example-state.yaml`

For a fuller walkthrough, see:
- [Getting Started](docs/getting-started.md)
- [Compatibility](docs/compatibility.md)
- [Profile Recipes](docs/profile-recipes.md)
- [FAQ](docs/faq.md)

## Samples

If you want to see the end result before configuring anything, start here:
- [Email sample](samples/example-output-email.md)
- [Chat sample](samples/example-output-chat.md)
- [Markdown report sample](samples/example-output-report.md)
- [Minimal config sample](samples/example-config.minimal.yaml)

The README intentionally links to concrete sample files so users can judge tone and structure before investing time in setup.

## Compatibility

`email`, `chat`, and `markdown` are the supported V1 outputs.

`typst`, `latex`, and `quarto` remain experimental. If a user asks for one of those formats, the skill should clearly say so and fall back to markdown content first.

Audience and language coverage supported by this repo:
- advisors, co-advisors, lab meetings, collaborators
- Chinese, English, and bilingual workflows
- zero-config emergency usage and reusable profile-driven usage

Detailed compatibility notes are documented in [docs/compatibility.md](docs/compatibility.md).

## Starter Recipes

If you do not want to design profiles from scratch, use:
- [Minimal config sample](samples/example-config.minimal.yaml) for the fastest reusable setup
- [Profile recipes](docs/profile-recipes.md) for advisor, group meeting, collaborator, and bilingual cases

## Repository Layout

```text
commands/                      Claude Code command entry
docs/                          onboarding and compatibility docs
samples/                       config/state examples and output samples
skills/progress-report/        skill instructions and references
templates/                     experimental Typst/LaTeX/Quarto templates
```
