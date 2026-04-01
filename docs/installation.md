# Installation

This repository works best as a project-local skill pack rather than a global install.

## Recommendation

Do not install this globally by default.

Put it in the project you actually want to report on, or in a dedicated workspace for one reporting context.

Why project-local is better:
- the AI can read the actual git history, figures, notebooks, and notes for that project
- `.progress-config.yaml` and `.progress-state.yaml` stay tied to the right reporting context
- you avoid one global skill mixing multiple labs, advisors, or projects together

## Minimal Install Rule

Only three things really matter:

1. Keep this repo somewhere inside the project or workspace you want the AI to use.
2. Keep `.progress-config.yaml` in that same project or workspace root.
3. Make sure the AI reads:
   - `commands/progress-report.md`
   - `skills/progress-report/SKILL.md`

That is the generic installation model.

The exact folder name does not matter.

Valid examples:
- `./progress-report-skill/`
- `./tools/progress-report-skill/`
- `./.ai/skills/progress-report/`
- `../shared/progress-report-skill/` if your tool can still read it from the current workspace

## Tool-Agnostic Install Steps

These steps are designed to work for Codex, Claude Code, OpenCode, and similar agent tools.

1. Clone or copy this repo into the workspace where reporting should happen.
2. Keep it local to that project or workspace.
3. Open the project root in your AI tool, not just the skill folder by itself.
4. Ask the AI to read:
   - `commands/progress-report.md`
   - `skills/progress-report/SKILL.md`
   If the repo lives in a subfolder, use that subfolder prefix.
5. Create `.progress-config.yaml` in the project or workspace root from:
   - `samples/example-config.minimal.yaml`, or
   - `samples/example-config.yaml`, or
   - `/progress-report --init`
6. Keep `.progress-state.yaml` in that same root so the reporting period stays local.

## Codex / Claude Code / OpenCode

The repo is intentionally structured so the same prompt contract can be reused across tools:
- `commands/` defines the command entry contract
- `skills/progress-report/SKILL.md` defines the behavior
- `samples/` provides starter config and output examples
- `templates/` provides Typst/LaTeX/Quarto source templates

If a tool does not support native slash commands, you can still use the repo by asking the agent to read the same files and follow their instructions manually.

## Copy This To Your AI

Use this when you want the AI to set up the skill inside the current research project or reporting workspace.

```text
Please install the progress-report skill into this project as a project-local tool, not as a global install.

Requirements:
1. Keep the skill repo local to this project or workspace. The exact folder name is not important.
2. Read and follow:
   - `commands/progress-report.md`
   - `skills/progress-report/SKILL.md`
   If the repo is placed in a subfolder, use the correct prefixed paths.
3. Create `.progress-config.yaml` in the project or workspace root using the minimal sample unless a richer config is clearly needed.
4. Keep `.progress-state.yaml` in the same root.
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
