# Profile Recipes

Use this page when you know the reporting scenario but do not want to design a profile from scratch.

## Main advisor weekly update

Recommended settings:

```yaml
format: email
layout: report
advisor_preset: detail-oriented
verbosity: standard
language: zh
```

Best for:
- advisors who care about setup, evidence, and comparison details
- weekly email updates

## Group meeting summary

Recommended settings:

```yaml
format: markdown
layout: slides
advisor_preset: high-level
verbosity: standard
language: zh
```

Best for:
- lab meeting slides
- updates where insight matters more than implementation detail

## Quick sync message

Recommended settings:

```yaml
format: chat
layout: report
advisor_preset: hands-off
verbosity: brief
language: zh
```

Best for:
- WeChat
- Slack
- Teams
- short same-day updates

## English collaborator update

Recommended settings:

```yaml
format: email
layout: report
advisor_preset: intuitive
verbosity: standard
language: en
```

Best for:
- collaborators outside the lab
- readers who do not want dense local context

## Bilingual progress sync

Recommended settings:

```yaml
format: markdown
layout: report
advisor_preset: high-level
verbosity: standard
language: bilingual
```

Best for:
- situations where you need one reusable draft for both Chinese and English contexts
- internal note taking before rewriting into a final outward-facing message

## How to choose

If you are unsure, use this order:
1. `quick-sync` if speed matters most
2. `weekly-email` if your advisor is the main audience
3. `group-meeting` if you need reusable markdown structure

Then tune language and audience names later.
