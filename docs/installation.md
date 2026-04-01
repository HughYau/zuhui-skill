# Installation

This repository works best as a project-local skill pack rather than a global install.

## Recommendation

Do not install this globally by default.

Prefer one of these layouts:

1. Put it inside the research project you actually report on.
2. Create a dedicated reporting workspace repo and keep the skill plus `.progress-config.yaml` there.

Why project-local is better:
- the AI can read the actual git history, figures, notebooks, and notes for that project
- `.progress-config.yaml` and `.progress-state.yaml` stay tied to the right reporting context
- you avoid one global skill mixing multiple labs, advisors, or projects together

## Generic Layout

Example 1: install inside an existing research repo

```text
your-research-project/
├── .progress-config.yaml
├── .progress-state.yaml
├── tools/
│   └── progress-report-skill/
│       ├── commands/
│       ├── docs/
│       ├── skills/
│       ├── samples/
│       └── templates/
├── results/
├── notebooks/
└── notes/
```

Example 2: create a separate reporting workspace

```text
weekly-report-workspace/
├── progress-report-skill/
├── .progress-config.yaml
├── .progress-state.yaml
├── linked-notes/
└── exported-reports/
```

## Tool-Agnostic Install Steps

These steps are designed to work for Codex, Claude Code, OpenCode, and similar agent tools.

1. Clone or copy this repo into the workspace where you want reporting to happen.
2. Keep it local to that project, for example under `tools/progress-report-skill/`.
3. Open the project root in your AI tool, not just the skill folder by itself.
4. Ask the AI to read:
   - `tools/progress-report-skill/commands/progress-report.md`
   - `tools/progress-report-skill/skills/progress-report/SKILL.md`
5. Create `.progress-config.yaml` from:
   - `tools/progress-report-skill/samples/example-config.minimal.yaml`, or
   - `tools/progress-report-skill/samples/example-config.yaml`, or
   - `/progress-report --init`
6. Keep `.progress-state.yaml` in the same project root so the reporting period is tracked locally.

## Codex / Claude Code / OpenCode

The repo is intentionally structured so the same prompt contract can be reused across tools:
- `commands/` defines the command entry contract
- `skills/progress-report/SKILL.md` defines the behavior
- `samples/` provides starter config and output examples
- `templates/` provides Typst/LaTeX/Quarto source templates

If a tool does not support native slash commands, you can still use the repo by asking the agent to read the same files and follow their instructions manually.

## Copy This To Your AI

Use this when you want the AI to set up the skill inside the current research project.

```text
Please install the progress-report skill into this project as a project-local tool, not as a global install.

Requirements:
1. Put the skill under `tools/progress-report-skill/` in the current project, or reuse that path if it already exists.
2. Read and follow:
   - `tools/progress-report-skill/commands/progress-report.md`
   - `tools/progress-report-skill/skills/progress-report/SKILL.md`
3. Create `.progress-config.yaml` in the project root using the minimal sample unless a richer config is clearly needed.
4. Keep `.progress-state.yaml` in the same project root.
5. Assume this project-local install should work for Codex, Claude Code, OpenCode, and similar AI coding tools.
6. Do not install anything globally unless I explicitly ask.

After setup, tell me:
- where the skill was placed
- which config file was created
- how I should trigger Quick Mode
- how I should trigger Interactive Init
```

## If You Need A Fresh Workspace

If the research project is messy or not AI-ready yet, create a fresh workspace and put this repo there together with:
- `.progress-config.yaml`
- `.progress-state.yaml`
- a copy or symlink of the important `results/`, `notebooks/`, and `notes/` directories

That is still better than a global install because the reporting context remains isolated.
