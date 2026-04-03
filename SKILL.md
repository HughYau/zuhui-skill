---
name: zuhui
description: Use when preparing research progress updates, advisor emails, lab meeting notes, or collaborator syncs from scattered evidence such as git history, notebooks, figures, and notes, especially when the output must adapt to audience, tone, and Chinese/English workflow.
---

# Zuhui

## Overview

生成真正可用的科研进展汇报，适用于导师邮件、组会记录、协作者同步和临时进展更新。

**核心原则：** 汇报的目标不是展示你有多忙，而是让对方迅速看懂四件事：做了什么、证据够不够、卡在哪里、是否需要决定或帮助。

## Entry Modes

| 模式 | 何时使用 | 结果 |
|------|----------|------|
| `--quick` | 没有配置，或只想立刻得到一版可发送草稿 | 最低心智负担，直接产出 |
| `--init` | 想长期复用，但不想手写 YAML | 用 5-7 个问题生成或更新 `.progress-config.yaml` |
| Full Mode | 已有配置，或需要 profile、周期追踪、artifact 扫描 | 构建稳定可复用工作流 |

默认路由：
- 用户传入 `--quick` 时，强制走 Quick Mode。
- 用户传入 `--init`，或明确要求“初始化配置”“生成配置”时，先完成 Interactive Init。
- 没有 `.progress-config.yaml` 且用户没有要求复杂配置时，优先 Quick Mode。
- 只有在用户已经有配置，或明确要求 profile、周期追踪、artifact 扫描时，才进入 Full Mode。

## Quick Reference

```text
/zuhui [options]
  --quick
  --init
  --profile <name>
  --format email | chat | markdown | typst | latex | quarto
  --layout report | slides
  --template classic-report | thesis-status | lab-slides
  --verbosity brief | standard | detailed
  --language zh | en | bilingual
  --since "last monday" | "2 weeks ago" | ...
  --tone neutral | struggling | triumphant
```

输出优先级：
- 最稳定：`email`、`chat`、`markdown`
- 文档导出：`typst`、`latex`、`quarto`

对导出格式，默认采用 markdown-first 路径：先生成稳定的 markdown 内容，再映射到模板源码；返回源码文本即可，不把本地编译 PDF 当作成功条件。

## Workflow

### 1. Route the request

先判断用户是要快速出稿、初始化配置，还是运行完整工作流。不要在首次使用时立刻逼用户手写完整 YAML。

### 2. Interactive Init

当用户传入 `--init`，或明确要求初始化配置时，先完成配置向导，不要直接写汇报。

向导规则：
1. 总问题数控制在 5-7 个，只问高价值问题。
2. 用自然语言提问，不把问题写成配置字段考试。
3. 用户回答模糊时做合理默认，并明确说明默认值。
4. 如果仓库里已经有 `.progress-config.yaml`，先读取现有配置，不要静默覆盖。
5. 结束时必须给出推荐 profile 名、生成或更新后的配置、以及一段简短理由。

建议问题范围：
- 主要汇报对象是谁。
- 对方更看重结论、细节还是思路。
- 常用中文、英文还是双语。
- 最常见输出是邮件、聊天还是文档。
- 组里固定术语或不想被改写的表达。
- 最近更常见的语气是中性、卡壳求助还是阶段性突破。
- 哪些目录最可能出现结果图、notebook、笔记或表格。

最小可用配置至少应覆盖：
- `default_profile`
- 一个可用的 `profiles.<name>`
- `tone`
- `vocabulary`
- `repos`
- `artifacts.scan_dirs`
- `render`（用户需要文档导出时）

初始化时优先参考：
- `assets/samples/example-config.minimal.yaml`
- `references/profile-recipes.md`

### 3. Quick Mode

当用户传入 `--quick`，或没有配置文件但只想先出一版结果时，只问三个问题：
1. 发给谁。
2. 什么场景。
3. 最近做了什么。

然后立即生成一版可编辑、可发送的内容：
- 不做复杂风格学习。
- 使用默认去 AI 化规则。
- 生成后提醒用户：如果后续会反复使用，可以迁移到 `--init` 或最小配置样例。

### 4. Full Mode

当存在配置，或用户明确要求复用 profile、扫描 artifact、跟踪周期时，按完整工作流执行。

#### Step 0: Load config and state

读取：
- `.progress-config.yaml`
- `.progress-state.yaml`

规则：
- 配置不存在：若用户明确要长期复用则转入 `--init`；否则降级到 Quick Mode。
- 状态不存在：创建空状态，并默认从最近一周开始。
- `--profile` 优先于 `default_profile`。
- 命令行参数可以覆盖 profile 中的 `format`、`layout`、`verbosity`、`language`、`tone`、`render`。

#### Step 1: Build the progress pool

默认时间范围：
- 从 `last_report_at` 到现在
- 用户可用 `--since` 覆盖
- 如果与上次汇报重叠，提醒用户确认，避免重报

素材来源分四类：

**A. Git 进展**

```bash
git log --since=<last_report_at> --pretty=format:"%h|%s|%an|%ad" --date=short
```

要求：
- 对关键 commit 运行 `git diff --stat`
- 自动分类为 `experiment`、`feature`、`fix`、`docs`、`chore`
- 多仓库按 `repos` 逐个分析

**B. Artifact 扫描**

扫描 `artifacts.scan_dirs` 中在时间范围内变更的内容：
- 结果图：`*.png`、`*.jpg`、`*.pdf`
- Notebook：`*.ipynb`
- Markdown 笔记：`*.md`
- 表格：`*.csv`、`*.tsv`

扫描后要把发现结果列给用户确认，不能静默纳入。

**C. 用户口述**

主动接收并补问：
- 论文阅读
- 讨论结论
- 被否掉的尝试
- 线下实验
- 还没进 git 的工作

**D. 组合模式**

优先推荐 Git + artifact + 用户补充的组合模式。

素材池应保持这种结构：

```yaml
progress_pool:
  period: "2026-03-25 ~ 2026-04-01"
  items:
    - category: experiment
      what: "在 CIFAR-10 上测试了 mixup 数据增强"
      why: "上周组会决定验证 mixup 对小样本的效果"
      result: "准确率从 78.3% 提到 81.7%，比 CutMix 更好"
      confidence: high
      evidence:
        - type: git
          ref: "abc1234 - add mixup augmentation"
        - type: artifact
          ref: "results/cifar10_mixup_acc.png"
      asks: null
  blockers:
    - what: "GPU 资源紧张"
      impact: "ImageNet 实验需要排队，预计延后一周"
      needs_help: true
  next_steps:
    - "在 ImageNet 子集上验证"
    - "写 related work"
  decisions_needed:
    - "是否需要申请额外 GPU 资源"
```

展示素材池时，明确提醒用户检查：
- `confidence` 是否准确
- `asks` 是否缺失
- `decisions_needed` 是否需要前置到更显眼位置

#### Step 2: 内容生成

根据 `advisor_preset` 调整详略和表达：

| 预设 | 策略 |
|------|------|
| `hands-off` | 保留结论、阻塞和下一步，压缩细节 |
| `detail-oriented` | 展开实验设置、参数、数据对比，并标注 `low` 或 `preliminary` |
| `high-level` | 强调动机、结论和待决定事项 |
| `intuitive` | 用更直观的解释，减少技术堆砌 |
| `custom` | 按 `custom_traits` 定制 |

生成时的硬约束：
- `confidence=preliminary` 的结论必须显式标记
- `evidence` 为空时，要说明它来自口述、讨论或暂未整理的材料
- 不夸大结果，不把单次实验写成“证明”
- `asks` 和 `decisions_needed` 不能埋到结尾

术语和语气控制：
- 若配置了 `vocabulary`，优先使用用户提供的实验室术语
- 术语前后一致，不要同一份汇报里来回切换说法
- 对外部合作者只做最小必要解释，不机械照搬黑话
- `tone=struggling`：强调卡点、已尝试路径、希望得到的帮助
- `tone=triumphant`：突出突破、证据和影响，但不能抢结论
- `tone=neutral`：事实优先，少修辞

#### Step 3: 去 AI 化和风格适配

按 `language` 加载：
- `zh` -> `references/anti-ai-zh.md`
- `en` -> `references/anti-ai-en.md`
- `bilingual` -> 两套都加载

流程：
1. 生成结构正确的初稿。
2. 扫描套话和 AI 语言模式。
3. 重写表达，而不是只替换同义词。
4. 如有风格样本，再参考 `references/style-extraction.md` 做二次对齐。

#### Step 4: Output and state update

输出后允许用户：
- 微调局部段落。
- 切换 profile 重生成。
- 返回源码文本或按要求保存到文件。

只有在用户明确确认“这版可用”之后，才更新 `.progress-state.yaml`：
- `last_report_at`
- `last_report_range`
- `last_confirmed_pool`
- `history`（最多保留最近 20 条）

## Output Formats

| 格式 | 推荐结构 |
|------|----------|
| `email` | 称呼 -> 进展 -> 需要确认的事项 -> blockers -> 下一步 -> 签名 |
| `chat` | 一句话开头 -> 要点 -> 卡点或求助 -> 下一步 |
| `markdown` | 标题 -> progress -> questions -> blockers -> next steps |
| `markdown + slides` | 每个主题一页，最后一页放 questions 和 next steps |
| `typst/latex/quarto report` | 先产出 markdown，再映射到模板源码 |
| `typst/latex/quarto slides` | 先产出 markdown slides，再映射到幻灯片模板 |

## Common Mistakes

- 首次使用就逼用户手写完整 YAML，而不是先给出可用结果。
- 把 blockers 和 asks 写得太隐蔽，导致导师看不出是否需要帮助。
- 对证据不足的结果写得过满。
- 术语前后不一致，导致同一份汇报像多个人写的。
- 没有 git 历史或 artifact 时直接失败，而不是降级到可用路径。
- 用户还没确认可用，就提前更新 `.progress-state.yaml`。
- 为了“显得完整”而编造材料来源、时间范围或结论强度。

## References

常用参考：
- `references/advisor-presets.md`
- `references/profile-recipes.md`
- `references/artifact-scanning.md`
- `references/style-extraction.md`
- `references/anti-ai-zh.md`
- `references/anti-ai-en.md`

常用资源：
- `assets/samples/example-config.minimal.yaml`
- `assets/samples/example-config.yaml`
- `assets/templates/`

按需加载参考文件，不要一次性读完所有 references。

## Edge Cases

- 无 git 历史：跳过 git 分析，使用 artifact 扫描和用户口述。
- 无 artifact 目录：继续使用 git 和口述。
- 无配置文件：进入 Quick Mode 或 `--init`。
- 用户明确要求初始化：优先 `--init`。
- 无风格样本：跳过风格学习，只做去 AI 化。
- 无状态文件：创建新状态，并默认从最近一周开始。
- 与上次汇报重叠：提示用户并标记重叠部分。
- 用户要求文档源码：返回 markdown + 模板源码，必要时保存为文件。
- 全部素材都只是 preliminary：在输出开头明确提醒。
