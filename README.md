# 🧑‍🔬 组会 Skill (Progress Report)

> 生成真正可用的科研进度汇报：无论你是急需发送简报，还是需要结构化的每周例行汇报，都能轻松搞定。✨
> 
> *[Read this in English](./README_en.md)* 🌍

`组会 Skill` (Progress Report) 是一个专为研究生和科研人员打造的 Claude Code 技能。它可以帮助你高效地向导师、实验室会议和合作者进行汇报，让你无需每周从头开始撰写重复的更新。🎓

## 🎯 支持的输出格式

- 📧 **邮件 (Email)**：适用于向导师汇报进度的正式邮件。
- 💬 **聊天 (Chat)**：适用于微信、Slack 或 Teams 的快速日常同步。
- 📝 **Markdown**：适用于组会记录、长篇报告或个人存档。
- 📄 **Typst/LaTeX/Quarto**：用于正式文档的排版与导出模板，采用 Markdown-first 工作流并返回源码文件。
- 🧭 **交互式初始化 (`--init`)**：通过少量对话问题自动生成 `.progress-config.yaml`。
- 🗣️ **术语词典 + 语气控制**：支持 `vocabulary` 和 `tone`，让输出更贴近导师/实验室语境。

无论选择哪种格式，生成的汇报都会清晰地呈现以下四个核心板块：
✅ **当前进度 (Progress)**：近期完成的核心工作。
❓ **待决事项 (Questions/Decisions)**：需要讨论或由导师/合作者决定的事项。
🚧 **痛点难点 (Blockers)**：目前遇到的困难或卡点。
👣 **下一步 (Next steps)**：接下来的工作计划。

## 🤔 解决的核心痛点

本技能旨在解决科研工作汇报中的三个实际问题：
1. **信息分散**：科研进度往往散落在 git commit、图表、Jupyter 笔记本、笔记和线下讨论中，难以快速汇总。
2. **受众差异**：不同的汇报对象（导师、同门、合作者）需要不同颗粒度的细节。
3. **AI 生成内容过于笼统**：大多数 AI 生成的汇报听起来像套话，除非能够严格控制语气、证据链和置信度。🤖

## ⚡ 极速模式 (Quick Mode)

当你需要立刻发送一份汇报时，请使用极速模式。🚀

```bash
/progress-report --quick
```

极速模式只需你回答三个核心问题：
1. 汇报对象是谁？👤
2. 汇报的场合或沟通渠道是什么？🏢
3. 最近完成了哪些工作？✍️

它会跳过复杂的样式学习，直接生成一份去除“AI味”、可直接编辑发送的草稿。

如果你已经确定要长期复用，但不想手写 YAML，可以直接运行：

```bash
/progress-report --init
```

这个路径会通过 5-7 个 onboarding 问题，自动生成适合你场景的 `.progress-config.yaml`。

## 🛠️ 完全体模式 (Full Mode)

当你需要可重复的周报工作流，并希望结合个人 Profile、项目产物扫描和时间周期追踪时，请使用完全体模式。📅

```bash
/progress-report --profile weekly-email
/progress-report --format chat --since "last monday"
```

完全体模式依赖以下配置文件：
- `.progress-config.yaml`：用于配置个人 Profile、文风、代码库和产物目录。🗂️
- `.progress-state.yaml`：记录上次汇报的时间边界，防止内容重叠并保存历史记录。🕰️

其中 `.progress-config.yaml` 现在支持两类对“去 AI 化”影响最大的字段：
- `vocabulary`：你组里固定使用的术语或黑话
- `tone`：`neutral | struggling | triumphant`


## 🚀 首次使用指南 (First Run)

1. 不要优先全局安装，建议把这个 skill 放进你要汇报的研究项目里，或者单独新建一个汇报 workspace。
2. 如果想快速体验，建议从 `/progress-report --quick` 开始。🌊
3. 如果你想直接让系统帮你生成配置，运行 `/progress-report --init`。
4. 当你需要可复用的模板和时间范围追踪时，切换到完全体模式 (Full Mode)。
5. 准备好自定义配置时，可以复制并修改示例文件：
   - 📄 `samples/example-config.yaml`
   - 📄 `samples/example-state.yaml`

如需更详细的教程，请参阅：
- 🧩 [安装指南 (Installation)](docs/installation.md)
- 📖 [入门指南 (Getting Started)](docs/getting-started.md)
- 🤝 [兼容性说明 (Compatibility)](docs/compatibility.md)
- 🧾 [导出工作流 (Export Workflows)](docs/export-workflows.md)
- 🍳 [Profile 配置文件参考 (Profile Recipes)](docs/profile-recipes.md)
- ❓ [常见问题 (FAQ)](docs/faq.md)

## 📦 安装方式 (Recommended Install)

推荐方式不是全局安装，而是**项目内安装**。

最推荐的目录结构如下：

```text
your-research-project/
├── .progress-config.yaml
├── .progress-state.yaml
├── tools/
│   └── progress-report-skill/
├── results/
├── notebooks/
└── notes/
```

这样做的原因很直接：AI 可以直接读到当前项目的 git 历史、结果图、notebook 和笔记，状态文件也不会和别的项目串掉。

Codex、Claude Code、OpenCode 以及其他能读取项目文件的 AI 工具，都可以复用同一套接入方式：
1. 把本仓库放到项目里，例如 `tools/progress-report-skill/`
2. 让 AI 读取：
   - `tools/progress-report-skill/commands/progress-report.md`
   - `tools/progress-report-skill/skills/progress-report/SKILL.md`
3. 在项目根目录创建 `.progress-config.yaml`
4. 后续在同一个项目根目录维护 `.progress-state.yaml`

完整说明见 [docs/installation.md](docs/installation.md)。

## 🤖 复制给 AI 安装

如果你希望直接把安装工作交给 AI，可以把下面这段原样复制给它：

```text
请把 progress-report skill 安装到当前项目里，按项目级工具处理，不要做全局安装。

要求：
1. 将 skill 放到 `tools/progress-report-skill/`，如果该目录已存在则复用。
2. 读取并遵循：
   - `tools/progress-report-skill/commands/progress-report.md`
   - `tools/progress-report-skill/skills/progress-report/SKILL.md`
3. 在项目根目录创建 `.progress-config.yaml`，默认优先使用 minimal sample，除非当前项目明显需要完整配置。
4. 将 `.progress-state.yaml` 也放在项目根目录。
5. 这套安装方式需要兼容 Codex、Claude Code、OpenCode 以及类似的 AI 工具。
6. 除非我明确要求，否则不要全局安装。

安装完成后，请告诉我：
- skill 被放在了哪里
- 创建了哪个配置文件
- 如何触发 Quick Mode
- 如何触发 Interactive Init
```

## 👀 汇报示例 (Samples)

如果你想在配置之前先看看效果，可以参考以下示例：
- 🇨🇳 [中文邮件示例](samples/example-output-email-zh.md)
- 🇬🇧 [英文邮件示例](samples/example-output-email-en.md)
- 💬 [聊天工具汇报示例](samples/example-output-chat.md)
- 📝 [Markdown 报告示例](samples/example-output-report.md)
- ⚙️ [极简配置文件示例](samples/example-config.minimal.yaml)

（README 中提供这些具体示例，是为了让大家在投入时间配置前，能直观地评估汇报的语气和结构。😎）

## 🍳 新手配置参考 (Starter Recipes)

如果你不想从零开始设计 Profile，可以使用：
- 🏃 [极简配置示例](samples/example-config.minimal.yaml)：最快搭建可复用工作流。
- 👨‍🍳 [高级配置参考](docs/profile-recipes.md)：涵盖导师邮件、组会、合作者同步以及双语场景。

## 📂 仓库目录结构

```text
commands/                      🚪 Claude Code 技能命令入口
docs/                          📚 使用指南和兼容性文档
samples/                       🎁 配置/状态示例及生成的输出样本
skills/progress-report/        🧠 Skill 核心指令和参考说明
templates/                     🪄 Typst/LaTeX/Quarto 文档导出模板
```
