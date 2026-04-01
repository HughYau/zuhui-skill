# progress-report

Claude Code skill for generating research progress reports. Built for grad students and researchers who need to report to advisors, lab meetings, and collaborators.

## What it does

Collects progress from git history, project artifacts (result figures, notebooks, notes), and your own description, then generates a report tailored to who you're talking to.

Supported output formats:
- **Email** — weekly reports to advisors
- **Chat** — quick sync on WeChat/Slack/Teams
- **Markdown** — meeting slides or archival documents
- **Typst/LaTeX/Quarto** — formal reports and presentations (experimental)

## Key features

- **Multiple communication profiles** — different presets for your main advisor, co-advisor, lab meeting, collaborators
- **Advisor personality adaptation** — hands-off, detail-oriented, high-level, intuitive, or custom
- **Period tracking** — remembers what you reported last time, prevents gaps and overlaps
- **Artifact scanning** — picks up result figures, notebooks, reading notes, not just code commits
- **Confidence & asks** — marks preliminary results, surfaces questions that need advisor decisions
- **Bilingual de-AI** — separate Chinese and English humanization rules
- **Personal style learning** — learns your writing habits from past report samples

## Quick start

```
# Zero-config, emergency mode — just answer 3 questions and get a sendable result
/progress-report --quick

# Use a saved profile
/progress-report --profile weekly-email

# Override format and time range
/progress-report --format chat --since "last monday"
```

## Setup

1. Install as a Claude Code skill
2. Run `/progress-report` — first-run wizard creates `.progress-config.yaml`
3. Or use `--quick` to skip config and generate immediately

## Configuration

Two files in your project root (both auto-managed):
- `.progress-config.yaml` — profiles, style, repos, artifact dirs (see `samples/example-config.yaml`)
- `.progress-state.yaml` — last report time, commit range, history (see `samples/example-state.yaml`)
