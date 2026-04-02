# Installation

这份仓库现在采用**扁平 skill 布局**：仓库根目录本身就是 skill 根目录。

也就是说：
- 根目录 `SKILL.md` 是唯一的 canonical skill 入口。
- `references/` 和 `assets/` 是按需加载的 skill 资源。
- `examples/` 是给人快速预览输出效果的示例目录。
- `docs/` 是仓库说明文档，不是安装 skill 时的主入口。

## Recommended: Clone into `clients/skills/`

默认推荐项目内安装，而不是全局安装。

最简单的方式就是把整个仓库 clone 到当前项目的 `clients/skills/` 下面：

```bash
cd your-project
git clone <this-repo-url> clients/skills/progress-report
```

如果你的项目用的是其他本地 skills 目录，也可以放在等价位置；关键点是：
- skill 仓库留在当前项目或当前 reporting workspace 内。
- AI 能在当前项目上下文中读取根目录 `SKILL.md`。
- `.progress-config.yaml` 和 `.progress-state.yaml` 仍然放在项目或 workspace 根目录，不放进 skill 目录。

这样做的好处：
- 安装动作就是普通 clone，没有二次拷贝或额外包装。
- AI 可以直接读取当前项目里的 git 历史、notebook、结果图和笔记。
- 配置和状态文件会和正确的项目上下文绑定。

## What the AI Should Read

最少需要让 AI 读取：

| Path | Purpose |
|------|---------|
| `SKILL.md` | Skill 主行为，必读 |
| `references/` | 规则和参考说明，按需读取 |
| `assets/` | 配置样例和导出模板，按需读取 |

通常不需要先读完整个仓库。正确做法是：
1. 先读 `SKILL.md`
2. 遇到配置、风格、artifact 扫描或模板导出时，再按需进入 `references/` 或 `assets/`

## Create Project-Root Config Files

配置和状态文件应放在当前项目或当前 workspace 根目录，而不是 skill 目录里。

推荐从最小配置样例开始：

```bash
cp clients/skills/progress-report/assets/samples/example-config.minimal.yaml .progress-config.yaml
```

`.progress-state.yaml` 可以：
- 首次手动创建空文件。
- 或让 skill 在第一次确认输出可用后自动创建和更新。

如果你更想让 AI 通过对话帮你建配置，直接运行：

```text
/progress-report --init
```

## First Run

最快体验路径：

```text
/progress-report --quick
```

如果你已经准备做可复用配置，优先走：

```text
/progress-report --init
```

## Optional: Personal or Global Install

只有在你明确想要“一次安装，多项目共用”时，才考虑把 skill 放进个人 skill 目录。

即便如此，也仍然建议保留整个 skill 根目录结构，而不是只拷贝单个文件：

```text
progress-report/
├── SKILL.md
├── agents/
├── assets/
└── references/
```

建议做法：
- 把仓库克隆到固定位置。
- 将整个目录放入你的个人 skills 目录。
- 仍然把 `.progress-config.yaml` 和 `.progress-state.yaml` 放在具体项目根目录。

这条路径的代价：
- 不同项目更容易共用 profile 和 state。
- AI 不一定天然处在你想扫描的研究上下文中。
- 首次理解成本更高。

因此它是兼容方案，不是默认推荐。

## Canonical Resources the AI May Load

根目录下常见按需读取内容如下：

| Path | Purpose |
|------|---------|
| `references/advisor-presets.md` | 导师或对象偏好规则 |
| `references/profile-recipes.md` | 常见 profile 配方 |
| `references/artifact-scanning.md` | artifact 扫描规则 |
| `references/style-extraction.md` | 风格样本提取规则 |
| `references/anti-ai-zh.md` | 中文去 AI 化规则 |
| `references/anti-ai-en.md` | 英文去 AI 化规则 |
| `assets/samples/example-config.minimal.yaml` | 极简配置样例 |
| `assets/samples/example-config.yaml` | 完整配置样例 |
| `assets/templates/` | Typst / LaTeX / Quarto 模板 |

## Repository Layout

```text
SKILL.md                           skill 主入口
agents/                            UI 元数据
references/                        按需加载的参考说明
assets/samples/                    canonical 配置样例
assets/templates/                  导出模板
examples/                          给人浏览的输出样例
docs/                              使用说明和兼容性文档
README.md                          中文仓库说明
README_en.md                       英文仓库说明
```

## Compatibility

适配思路如下：
- **Codex / OpenCode / 其他可读文件的 AI agent**：直接读取根目录 `SKILL.md`，再按需加载资源。
- **Claude Code**：同样读取根目录 `SKILL.md`；如果项目本身有自己的命令系统，可以由项目自行包装，但本仓库不再内置 `.claude/commands/`。

关键点不变：
- skill 本体就在仓库根目录。
- 配置和状态不放进 skill 目录。
- 项目内安装优先于全局安装。
