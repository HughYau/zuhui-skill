# Installation

这个仓库是一个分发仓库，不是单文件 skill。

真正的 skill 本体始终在：

```text
skills/progress-report/
```

也就是说：
- 仓库根目录负责 README、文档、样例和命令入口
- `skills/progress-report/` 才是需要被 AI 读取和安装的核心目录

## Recommended: Project-Local Install

推荐把整个仓库放进你正在汇报的研究项目里，或者放进一个专门的汇报 workspace。

这样做的原因：
- AI 可以直接读取当前项目里的 git 历史、notebook、结果图和笔记
- `.progress-config.yaml` 和 `.progress-state.yaml` 会和正确的项目上下文绑定
- 不同项目不会共用一套容易串味的配置

### Step 1: Clone the repo locally

```bash
cd your-research-project
git clone <this-repo-url> .progress-report-skill
```

目录名不重要，以下都可以：
- `.progress-report-skill/`
- `tools/progress-report-skill/`
- `.ai/progress-report/`

关键不是名字，而是仓库要留在当前项目或当前汇报 workspace 里。

### Step 2: Point the AI at the right files

最少需要让 AI 读取：

| Path | Purpose |
|------|---------|
| `<repo-prefix>/skills/progress-report/SKILL.md` | Skill 主行为，必读 |
| `<repo-prefix>/commands/progress-report.md` | 命令入口约定，推荐 |

如果你使用 Claude Code 并希望通过 slash command 调用，再额外暴露：

| Path | Purpose |
|------|---------|
| `.claude/commands/progress-report.md` | Claude Code 的项目内命令入口 |

常见做法：

```bash
mkdir -p .claude/commands
cp .progress-report-skill/.claude/commands/progress-report.md .claude/commands/progress-report.md
```

复制后，需要把命令文件里的 skill 路径改成仓库子目录中的实际位置，例如：

```text
<repo-prefix>/skills/progress-report/SKILL.md
```

如果你的仓库目录名是 `.progress-report-skill`，那这个前缀就是：

```text
.progress-report-skill
```

如果仓库目录名不同，把 `<repo-prefix>` 替换成实际目录名即可。

### Step 3: Create project-root config files

配置和状态文件应放在当前项目或当前汇报 workspace 的根目录，而不是 skill 目录里。

初始化配置的推荐起点：

```bash
cp .progress-report-skill/skills/progress-report/assets/samples/example-config.minimal.yaml .progress-config.yaml
```

`.progress-state.yaml` 可以：
- 首次手动创建空文件
- 或让 skill 在第一次确认输出可用后自动创建/更新

### Step 4: First run

最快体验路径：

```text
/progress-report --quick
```

如果你想让系统通过对话生成配置：

```text
/progress-report --init
```

## Optional: Global Install

只有在你明确想要“一次安装，多项目共用”时，才考虑全局安装。

全局安装时也不要把 `SKILL.md` 搬到仓库根目录；仍然只安装或引用这个目录：

```text
skills/progress-report/
```

建议做法：
- 把仓库克隆到一个固定位置
- 将 `skills/progress-report/` 复制或软链接到你的个人 skill 目录
- 仍然把 `.progress-config.yaml` 和 `.progress-state.yaml` 放在具体项目根目录

全局安装的风险：
- 容易让不同项目共用一套 profile 和 state
- AI 不一定处在你真正想扫描的研究上下文中
- 对首次使用者来说，理解成本更高

因此全局安装是兼容选项，不是默认推荐路径。

## What the AI May Load On Demand

在 `skills/progress-report/` 内，常见按需读取内容如下：

| Path | Purpose |
|------|---------|
| `skills/progress-report/references/advisor-presets.md` | 导师/对象偏好规则 |
| `skills/progress-report/references/anti-ai-zh.md` | 中文去 AI 化规则 |
| `skills/progress-report/references/anti-ai-en.md` | 英文去 AI 化规则 |
| `skills/progress-report/references/artifact-scanning.md` | artifact 扫描规则 |
| `skills/progress-report/references/style-extraction.md` | 风格样本提取 |
| `skills/progress-report/references/profile-recipes.md` | profile 配方 |
| `skills/progress-report/assets/samples/example-config.minimal.yaml` | 极简配置样例 |
| `skills/progress-report/assets/templates/` | Typst/LaTeX/Quarto 模板 |

## Repository Layout

```text
.claude/commands/              Claude Code 项目内命令入口
commands/                      通用命令入口文档
docs/                          使用说明和兼容性文档
samples/                       用户浏览用样例
skills/progress-report/        真正的 skill 本体
  ├── SKILL.md
  ├── references/
  └── assets/
```

## Compatibility

适配思路如下：
- **Claude Code**：优先项目内安装，必要时复制 `.claude/commands/progress-report.md`
- **Codex / OpenCode**：直接读取 `skills/progress-report/SKILL.md`
- **其他可读文件的 AI agent**：显式要求其读取 `skills/progress-report/SKILL.md` 并遵循

关键点不变：
- skill 本体不在仓库根目录
- 配置和状态不放进 skill 目录
- 项目内安装优先于全局安装
