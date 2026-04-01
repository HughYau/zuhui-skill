# Progress Report Skill — Design Spec (v2)

## Context

早期科研人员（硕士生、博士生）频繁需要向导师和同门汇报研究进展——组会前准备材料、每周邮件汇报、即时消息同步。这些沟通任务重复性高但每次又需要个性化（导师偏好不同、汇报内容不同、场景不同），常常消耗大量时间。

本 skill 的目标：**让用户能稳定、可信、低成本地周周复用**——从 git 历史、项目产物、口述进展中生成适配不同沟通对象、保持个人风格、标注结论可信度和求助点的汇报内容。

### v2 主要改进
1. 周期锚点 + 状态文件，防漏报重报
2. Artifact 扫描层（结果图、notebook、笔记），覆盖不在 git 里的研究进展
3. 素材池增加 confidence、asks、decisions_needed 字段，支持事实校验
4. 单 advisor 升级为多沟通 profile，覆盖主导师/联导/组会/协作者
5. Quick Mode 零配置应急路径，降低首次使用门槛
6. 增加 `--init` 交互式初始化，降低首次配置门槛
7. 支持 `tone` 与 `vocabulary`，让输出贴合导师/实验室语境
8. Typst/LaTeX/Quarto 升级为 markdown-first 文档导出路径，默认返回或保存源码文件

---

## 1. Skill 概览

- **名称**: `progress-report`
- **架构**: 单一 skill，三种入口（Init / Quick / Full）
- **三大场景**: 邮件正文、即时消息（微信/Slack/Teams）、文档（Markdown + Typst/LaTeX/Quarto 导出）
- **核心特性**: 多沟通 profile、周期状态跟踪、artifact 扫描、事实校验/求助点、双语去AI化、个人风格保持、术语词典、语气控制

## 2. 整体架构

```
Init Mode:                Quick Mode:               Full Mode:
5-7个问题 → 生成配置        3个问题 → 生成 → 完成      Step 0: 配置+状态 → Step 1: 素材收集(git+artifact+口述)
                                                     → Step 2: 内容生成(profile适配+事实校验+tone/vocabulary)
                                                     → Step 3: 去AI化+风格 → Step 4: 导出/输出+状态更新
```

核心思路：**进展素材与输出格式解耦**，同时**跟踪汇报周期防止漏报重报**。

## 3. 配置系统

### 3.1 两个文件

- `.progress-config.yaml` — 用户配置（profiles、风格、仓库、artifact目录）
- `.progress-state.yaml` — 运行状态（自动维护，不需手动编辑）

### 3.2 配置文件核心结构

```yaml
language: zh
tone: neutral
vocabulary:
  - concept: "ablation study"
    preferred: "控制变量"

profiles:
  weekly-email:
    audience: "张老师"
    advisor_preset: detail-oriented
    format: email
    layout: report
    verbosity: standard
    language: zh
    tone: neutral
    signature: {name: "", closing: "祝好"}

  group-meeting:
    audience: "组会"
    advisor_preset: high-level
    format: markdown
    layout: slides
    verbosity: standard

  quick-sync:
    audience: "张老师"
    advisor_preset: hands-off
    format: chat
    verbosity: brief

default_profile: weekly-email

style:
  sample_files: []
  style_summary: null

repos:
  - path: .

artifacts:
  scan_dirs: [results/, notebooks/, notes/, data/]
  file_patterns: ["*.png", "*.csv", "*.ipynb", "*.md"]

render:
  enabled: auto
  format: markdown
  template: classic-report
```

### 3.3 状态文件核心结构

```yaml
last_report_at: "2026-03-25T10:00:00+08:00"
last_report_range:
  repos:
    - path: .
      from_commit: "abc1234"
      to_commit: "def5678"
last_confirmed_pool:
  period: "2026-03-18 ~ 2026-03-25"
  item_hashes: ["sha256:..."]
history:  # 最近20条
  - at: "2026-03-25T10:00:00+08:00"
    profile: weekly-email
    period: "2026-03-18 ~ 2026-03-25"
    commit_range: "abc1234..def5678"
    items_count: 4
```

### 3.4 导师性格预设

| 预设 ID | 名称 | 策略 |
|---------|------|------|
| `hands-off` | 放养型 | 精简结论，但 asks 和 needs_help 的 blocker 必须保留 |
| `detail-oriented` | 刨根问底型 | 展开实验细节，confidence=low 显式标出 |
| `high-level` | 高屋建瓴型 | 强调 insight，decisions_needed 放突出位置 |
| `intuitive` | 直觉比喻型 | 用类比替代术语，口语化 confidence 表达 |
| `custom` | 自定义 | 按 custom_traits 适配 |

跨预设通用规则：asks 不能省略、preliminary 结论必须标记、needs_help 的 blocker 必须保留、不夸大结果。

## 4. 素材收集层

### 4.1 四种输入源

| 来源 | 覆盖内容 | 自动化程度 |
|------|---------|-----------|
| Git 进展 | 代码变更、实验脚本、配置修改 | 全自动 |
| Artifact 扫描 | 结果图、notebook、笔记、数据表 | 半自动（扫描后用户筛选） |
| 用户口述 | 讨论决策、被否的尝试、线下实验、阅读心得 | 手动 |
| 组合（推荐） | 以上全部 | 自动提取 + 手动补充 |

**时间范围**：默认从 `last_report_at` 到现在。Git 用 commit 范围精确界定，artifact 用文件修改时间和 `last_report_at` 比较。和上次有重叠时提示用户。

### 4.2 素材池结构

```yaml
progress_pool:
  period: "2026-03-25 ~ 2026-04-01"
  items:
    - category: experiment | reading | coding | writing | discussion | other
      what: "做了什么"
      why: "为什么做"
      result: "结果如何"
      confidence: high | medium | low | preliminary
      evidence:
        - type: git | artifact | note
          ref: "路径或commit hash"
      asks: "需要导师决策的问题（可选）"

  blockers:
    - what: "问题描述"
      impact: "影响范围"
      needs_help: true | false

  next_steps: ["计划"]

  decisions_needed: ["需要导师拍板的事项汇总"]
```

## 5. 去AI化与个人风格

（同 v1，增加一条规则）

去AI化在 Step 3 执行，但**不是 skill 的核心价值**。核心价值是：素材收集完整、事实标注准确、求助点清晰。去AI化是锦上添花，不能本末倒置。

## 6. 输出格式层

### 6.1 V1 支持的格式

| 格式 | 场景 |
|------|------|
| `email` | 发邮件给导师 |
| `chat` | 微信/Slack/Teams |
| `markdown` | 组会展示或存档（report + slides） |

### 6.2 文档导出格式

| 格式 | 状态 | 模板 |
|------|------|------|
| `typst` | markdown-first，返回或保存源码，支持插图 | `templates/typst/` |
| `latex` | markdown-first，返回或保存源码，支持插图 | `templates/latex/` |
| `quarto` | markdown-first，返回或保存源码，支持插图 | `templates/quarto/` |

使用这些格式时先生成 markdown，再映射到模板源码，并按用户需要返回文本或保存文件。
模板均已支持基本结构、中文注释、figure 插入位。
Typst slides 当前依赖 `@preview/touying:0.5.5`，应在面向用户的文档里明确说明这一点。

### 6.3 所有格式统一包含的结构

无论什么格式，输出必须包含：
1. 进展内容（按 profile 详略调整）
2. **Questions / 需要确认的事项**（从 asks + decisions_needed 汇总）
3. Blockers（needs_help=true 的优先展示）
4. Next steps

标题约定：
- 当前示例和模板统一使用短标题 `Questions`
- 不再在 report 模板里单独写 `Questions for Advisor`
- 如果后续要区分 advisor / collaborator 语境，应通过正文语气和 audience 信息处理，而不是分叉标题

## 7. 文件结构

```
zuhui-skill/
├── skills/progress-report/
│   ├── SKILL.md
│   └── references/
│       ├── advisor-presets.md
│       ├── anti-ai-zh.md
│       ├── anti-ai-en.md
│       ├── style-extraction.md
│       └── artifact-scanning.md
├── templates/
│   ├── typst/    (report.typ, thesis-status.typ, slides.typ)
│   ├── latex/    (report.tex, thesis-status.tex, slides.tex)
│   └── quarto/   (report.qmd, thesis-status.qmd, slides.qmd)
├── commands/
│   └── progress-report.md
├── samples/
│   ├── example-config.yaml          # 完整配置示例
│   ├── example-config.minimal.yaml  # 最小配置示例
│   ├── example-state.yaml           # 状态文件示例
│   ├── example-output-email-zh.md   # 中文邮件输出示例
│   ├── example-output-email-en.md   # 英文邮件输出示例
│   ├── example-output-chat.md       # 即时消息输出示例
│   └── example-output-report.md     # Markdown report 输出示例
├── docs/
│   ├── getting-started.md
│   ├── compatibility.md
│   ├── export-workflows.md
│   ├── profile-recipes.md
│   └── faq.md
└── README.md
```

用户项目中生成（不在 skill 目录内）：
- `.progress-config.yaml`
- `.progress-state.yaml`

## 8. 交互流程

### Init Mode（首次配置）
1. `/progress-report --init`
2. 问 5-7 个 onboarding 问题
3. 自动生成 `.progress-config.yaml`
4. 若已有配置，则优先 merge 或新增 profile，而不是静默覆盖

### Quick Mode（应急）
1. `/progress-report --quick` 或首次无配置时
2. 问：发给谁？什么场景？最近做了什么？
3. 直接生成可发送的版本
4. 提示：要不要保存为常用 profile？

### Full Mode（日常）
1. `/progress-report [--profile xxx]`
2. 加载配置 + 状态
3. 自动扫描 git + artifact，用户补充口述
4. 确认素材池（特别检查 confidence 和 asks）
5. 按 profile 生成，事实校验内嵌
6. 去AI化 + 风格适配
7. 展示结果，可微调或切换 profile
8. 确认后更新状态文件

## 9. 验证方案

1. **Quick Mode 测试**: 无配置文件时，3个问题后生成可用的邮件/消息
2. **周期连续性测试**: 连续两次调用，验证第二次自动从上次结束位置开始，无重叠
3. **Artifact 扫描测试**: 在有 results/ 和 notebooks/ 的项目中验证文件发现和分类
4. **Confidence 标注测试**: 素材含 preliminary 结论时，输出中有明确标记
5. **多 Profile 测试**: 同一素材，切换 weekly-email 和 quick-sync profile，对比输出
6. **去AI化测试**: 生成后检查无 AI 高频模式
7. **Init 测试**: `--init` 能产出带 `tone`、`vocabulary`、`render` 的最小配置
8. **文档导出测试**: 请求 typst/latex/quarto 时，先产出 markdown，再返回或保存对应源码
9. **端到端测试**: git + artifact + 口述 → 完整汇报，Quick Mode < 1分钟，Full Mode < 3分钟
