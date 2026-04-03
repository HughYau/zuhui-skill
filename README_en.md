# 🧑‍🔬 zuhui Skill

> Generate research progress updates that are actually usable: quick when you are in a rush, structured when you need repeatable weekly reporting. ✨
> 
> *[阅读中文版本 (Read this in Chinese)](./README.md)* 🇨🇳

`zuhui` is a lightweight reporting skill for grad students and researchers who need to report to advisors, lab meetings, and collaborators without rewriting the same update from scratch every week. 🎓

It is better understood now as a **project-local reporting skill pack**: Claude Code can use it, Codex can use it, and OpenCode or other AI tools that can read project files can use it too.

## 🎯 What it produces

- 📧 **Email**: Formal updates for your advisor or project leads.
- 💬 **Chat**: Quick syncs for WeChat, Slack, or Teams.
- 📝 **Markdown**: Formatted meeting notes or long-form reports.
- 📄 **Typst/LaTeX/Quarto**: Document-export templates for formal reports, using a markdown-first flow that returns source files.
- 🧭 **Interactive Init (`--init`)**: A low-friction onboarding path that generates `.progress-config.yaml` through a short conversation.
- 🗣️ **Vocabulary + Tone Control**: Supports lab-specific wording and rhetorical framing through `vocabulary` and `tone`.

Every generated output keeps four things crystal clear:
✅ **Progress**: What key tasks were accomplished recently.
❓ **Questions/Decisions**: Things you need the advisor or collaborators to decide on.
🚧 **Blockers**: Where you are currently stuck or facing difficulties.
👣 **Next steps**: What you plan to do next.

## 🤔 Why this repo exists

This skill is designed to solve three practical problems:
1. **Scattered Information**: Research progress is often spread across git commits, plots, notebooks, notes, and offline discussions. 😵‍💫
2. **Audience Differences**: Different audiences (PIs, lab mates, external collaborators) want different levels of detail. 🤷‍♂️
3. **Generic AI Text**: Most AI-generated updates sound artificial unless tone, evidence, and confidence are strictly controlled. 🤖

## ⚡ Quick Mode

Use Quick Mode when you need a sendable update immediately. 🚀

```bash
/zuhui --quick
```

Quick Mode asks only three core questions:
1. Who is this for? 👤
2. What is the communication context? 🏢
3. What did you do recently? ✍️

It skips complex configurations and produces a directly editable draft with default rules that remove the typical "AI vibe."

If you already know you want a reusable setup but do not want to hand-write YAML, run:

```bash
/zuhui --init
```

That path asks a few onboarding questions and generates `.progress-config.yaml` for you.

## 🛠️ Full Mode

Use Full Mode when you want repeatable weekly reporting with profiles, artifact scanning, and period tracking. 📅

```bash
/zuhui --profile weekly-email
/zuhui --format chat --since "last monday"
```

Full Mode is equipped with:
- `.progress-config.yaml`: Your personal profile, writing style, repositories, and artifact directories. 🗂️
- `.progress-state.yaml`: Remembers the last report boundary to prevent overlaps and omissions. 🕰️

The config now supports two high-impact controls for making the wording feel native to a lab:
- `vocabulary`: lab-specific preferred terminology
- `tone`: `neutral | struggling | triumphant`

## 💡 Core Philosophy

The core of this skill is not "helping you write more like an AI," but **making your updates instantly readable for your advisor** 👁️:
- What did you do?
- Is there enough evidence?
- Where are you stuck?
- Do you need the boss to make a decision right now?

## 🚀 First Run

1. Do not default to a global install. Put this skill inside the research project you want to report on, or create a dedicated reporting workspace.
2. For the lowest-friction path, test the waters with `/zuhui --quick`. 🌊
3. If you want the skill to create the config for you, run `/zuhui --init`.
4. Switch to Full Mode when you are ready for reusable templates and time tracking.
5. When customizing your workflow, copy and modify the sample config files:
   - 📄 `assets/samples/example-config.yaml`
   - 📄 `assets/samples/example-config.minimal.yaml`
   Let `.progress-state.yaml` be created after the first confirmed usable run.

For a fuller walkthrough, see:
- 🧩 [Installation](docs/installation.md)
- 📖 [Getting Started](docs/getting-started.md)
- 🤝 [Compatibility](docs/compatibility.md)
- 🧾 [Export Workflows](docs/export-workflows.md)
- 🍳 [Profile Recipes](docs/profile-recipes.md)
- ❓ [FAQ](docs/faq.md)

## 📦 Recommended Install

The preferred setup is **project-local**, not global.

This repository's **root directory is now the skill root**. The simplest install is to clone it directly into a project's local skills directory, for example:

```bash
git clone https://github.com/HughYau/zuhui-skill.git .agents/skills/zuhui-skill
```

If you are using Claude Code, this is also fine:

```bash
git clone https://github.com/HughYau/zuhui-skill.git .claude/skills/zuhui-skill
```

The minimum viable install only needs three things:
1. Clone this repo into `.agents/skills/zuhui-skill` or an equivalent project-local skills directory.
2. Keep `.progress-config.yaml` and `.progress-state.yaml` in the project or workspace root.
3. Make sure the AI reads at least:
   - `SKILL.md`
   - and loads `references/` or `assets/` only when needed

Treat the repo root as the actual skill body:
- `SKILL.md` is the canonical skill entry.
- `assets/samples/` is the canonical source for install-time config samples.
- `examples/` is primarily for human preview, not the primary install source.

This matters because the AI can read the actual git history, figures, notebooks, and notes from the project, while the state and config stay tied to the correct reporting context.

See [docs/installation.md](docs/installation.md) for the full version.

## 🤖 Copy This To Your AI

If you want an AI agent to install the skill for you, copy this block as-is:

```text
Please install `zuhui` into this project and keep it project-local, not global.

Keep it simple:
1. Clone the repo into `.agents/skills/zuhui-skill`; if this environment is better suited for Claude Code, `.claude/skills/zuhui-skill` is also fine.
2. Read and follow `SKILL.md` from that skill directory.
3. Create `.progress-config.yaml` in the project root, using `assets/samples/example-config.minimal.yaml` by default.
4. Keep `.progress-state.yaml` in the same project root.
5. After setup, tell me where the skill was installed, which files were created, and how to run `/zuhui --quick` and `/zuhui --init`.
```

## 👀 Samples

If you want to see the end result before configuring anything, start here:
- 🇨🇳 [Email Sample (Chinese)](examples/example-output-email-zh.md)
- 🇬🇧 [Email Sample (English)](examples/example-output-email-en.md)
- 💬 [Chat Sample](examples/example-output-chat.md)
- 📝 [Markdown Report Sample](examples/example-output-report.md)
- ⚙️ [Minimal Config Sample](assets/samples/example-config.minimal.yaml)

(The README intentionally links to concrete sample files so users can judge tone and structure before investing time in setup. 😎)

## 🧩 Compatibility

`email`, `chat`, and `markdown` are the supported V1 outputs, highly stable and reliable. 🐕

For `typst`, `latex`, and `quarto`, the repo now uses a stronger document-export path: generate stable markdown first, then map it into template source. The default behavior is to return source text or save code files when requested.

Audience and language coverage supported by this repo:
- Advisors, co-advisors, lab meetings, external collaborators. 👨‍🏫
- Chinese, English, and bilingual workflows. 🔤
- Zero-config emergency usage vs. reusable profile-driven usage. 🌊

Detailed compatibility notes are documented in [docs/compatibility.md](docs/compatibility.md).

## 🍳 Starter Recipes

If you do not want to design profiles from scratch, use:
- 🏃 [Minimal Config Sample](assets/samples/example-config.minimal.yaml): For the fastest reusable setup.
- 👨‍🍳 [Profile Recipes](docs/profile-recipes.md): Covers advisor emails, group meeting notes, collaborator syncs, and bilingual cases.

## 📂 Repository Layout

```text
SKILL.md                                       🧠 Canonical skill entry
agents/                                        🏷️ UI metadata
references/                                    📖 On-demand rules and references
assets/samples/                                ⚙️ Canonical config samples
assets/templates/                              🪄 Typst/LaTeX/Quarto document-export templates
examples/                                      🎁 Human-facing output samples
docs/                                          📚 Onboarding and compatibility docs
```
