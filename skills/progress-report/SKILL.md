---
name: progress-report
description: |
  生成研究进展汇报内容（邮件/即时消息/文档），适配不同沟通对象，保持个人风格，双语去AI化。
  Generate research progress reports (email/chat/docs) adapted to communication profiles with de-AI processing.
---

> 汇报的核心不是展示你有多忙，而是让对方快速理解：做了什么、结论靠不靠谱、卡在哪、需不需要帮忙。

## 触发条件

用户需要：
- 准备组会汇报材料
- 给导师、联导、协作者写进展邮件
- 在微信、Slack、Teams 上同步进展
- 从 git 历史和项目产物中生成进展摘要
- 生成进展报告的 markdown 文档

关键词：组会、汇报、进展、weekly report、progress update、advisor、导师

## 不适用场景

- 论文写作（用 `paper-write`）
- 投稿或审稿邮件（用 `cover-letter`）
- 纯代码 review（用 `code-reviewer`）

## 两种模式

### Quick Mode

当没有 `.progress-config.yaml`，或用户明确要求快速生成时，只问三个问题：
1. 发给谁？
2. 什么场景？
3. 最近做了什么？

立即生成可发送的版本。不做风格学习，去 AI 化用默认规则。
生成后提示是否保存为常用 profile。

### Full Mode

当存在配置，或用户希望复用 profile、跟踪周期、扫描 artifact 时，走完整工作流。

## 首用默认策略

除非用户明确要求搭完整配置，否则优先让用户更快得到可用结果：
- 没有 `.progress-config.yaml` 时，默认先走 Quick Mode
- Quick Mode 结束后，再提示是否迁移到可复用配置
- 如果用户想要“能直接复制的配置”，优先给出 `samples/example-config.minimal.yaml`
- 如果用户说不清 profile 怎么配，优先从 `docs/profile-recipes.md` 里选最接近的沟通场景

这样做的目标是降低首次使用成本，而不是一开始就让用户理解全部配置字段

## 工作流（Full Mode）

### Step 0: 加载配置和状态

读取两个文件：
- `.progress-config.yaml`：profiles、风格、仓库、artifact 目录
- `.progress-state.yaml`：上次汇报时间、commit 范围、历史记录

规则：
- 配置不存在：进入首次配置向导，或降级到 Quick Mode
- 状态不存在：创建空状态文件，默认从最近一周开始
- `--profile` 优先于 `default_profile`
- 命令行参数可覆盖 profile 中的 `format`、`layout`、`verbosity`、`language`

### Step 1: 素材收集

时间范围：
- 默认从 `last_report_at` 到现在
- 用户可用 `--since` 覆盖
- 如果和上次汇报有重叠，提示用户确认，避免重报

四种素材来源：

**A. Git 进展**

```bash
git log --since=<last_report_at> --pretty=format:"%h|%s|%an|%ad" --date=short
```

- 对关键 commit 运行 `git diff --stat`
- 自动分类为 `experiment`、`feature`、`fix`、`docs`、`chore`
- 多仓库按 `repos` 配置依次分析
- 对比 `last_report_range`，标记新增范围

**B. Artifact 扫描**

扫描 `artifacts.scan_dirs` 中在 `last_report_at` 之后修改的文件：
- 结果图（`*.png`、`*.jpg`、`*.pdf`）
- Notebook（`*.ipynb`）
- Markdown 笔记（`*.md`）
- CSV 或表格（`*.csv`、`*.tsv`）

扫描规则见 `references/artifact-scanning.md`。扫描后要把发现结果列给用户，让用户确认哪些纳入本次汇报。

**C. 用户口述**

- 接受自由文本描述，中英混合也可以
- 主动补问不在代码里的进展：论文阅读、讨论决策、被否掉的尝试、线下实验

**D. 组合模式（推荐）**

先跑 Git 和 artifact 自动提取，再让用户补充口述内容。

素材池结构：

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

展示素材池给用户确认，可增删改。
特别提醒用户检查两点：
- `confidence` 标注是否准确
- `asks` 和 `decisions_needed` 是否完整

### Step 2: 内容生成

根据当前 profile 的 `advisor_preset` 调整详略和表达：

| 预设 | 策略 |
|------|------|
| `hands-off` | 只保留结论和下一步，省掉细节，但 `asks` 和 `needs_help=true` 的 blocker 必须保留 |
| `detail-oriented` | 展开实验设置、参数、对比数据，显式标出 `low` 或 `preliminary` |
| `high-level` | 强调动机和 insight，把 `decisions_needed` 放突出位置 |
| `intuitive` | 用类比和直观解释代替技术堆砌 |
| `custom` | 按 `custom_traits` 自由适配 |

详细规则见 `references/advisor-presets.md`。

事实校验是生成时的硬约束，不是附加功能：
- `confidence=preliminary` 的结论必须带标记
- `evidence` 为空的 item 要标注为基于口述或讨论
- 不夸大结果。单次实验不写“显著提升”，小数据集不写“证明”
- `asks` 和 `decisions_needed` 放在容易看到的位置，不要埋到结尾

按格式组织输出：

| 格式 | 结构 |
|------|------|
| `email` | 称呼 → 正文 → 需要确认的事项 → blockers → 下一步 → 签名 |
| `chat` | 一句话开头 → 要点 → 卡点或求助 → 下一步 |
| `markdown report` | 标题 → progress → questions → blockers → next steps |
| `markdown slides` | 每个主题一页，最后一页放 questions 和 next steps |

### Step 3: 去 AI 化和风格适配

按 `language` 加载规则：
- `zh`：`references/anti-ai-zh.md`
- `en`：`references/anti-ai-en.md`
- `bilingual`：两套都加载

流程：
1. 生成初稿
2. 扫描 AI 模式
3. 重写表达，不只是换词
4. 二次审查

如果配置了样本：
- 读取 `style.style_summary`
- 参考原始样本文件
- 对齐句式、用词、结构、开头结尾和标点习惯

指南见 `references/style-extraction.md`。

### Step 4: 输出和状态更新

展示结果后，允许用户：
- 微调某一段
- 切换到另一个 profile 重新生成
- 输出到文件

只有在用户确认本次结果可用之后，才更新 `.progress-state.yaml`：
- `last_report_at`
- `last_report_range`
- `last_confirmed_pool`
- `history`（只保留最近 20 条）

## 输出控制参数

```text
/progress-report [options]
  --profile   使用指定的沟通 profile
  --format    email | chat | markdown
  --layout    report | slides
  --verbosity brief | standard | detailed
  --language  zh | en | bilingual
  --since     时间范围，如 "last monday", "2 weeks ago"
  --quick     强制 Quick Mode
```

V1 只正式暴露 `email`、`chat`、`markdown`。
`typst`、`latex`、`quarto` 模板在 `templates/` 下作为 experimental 预留。
如果用户要求 experimental 格式，要明确提示当前状态，并回退到 `markdown` 结果。

## 常见适配场景

优先覆盖这些高频场景：
- 主导师周报：`email` + `detail-oriented`
- 组会汇报：`markdown` + `high-level`
- 快速同步：`chat` + `hands-off`
- 英文协作者：`email` 或 `chat` + `en`
- 中英混合沟通：`bilingual`

如果用户只是说“帮我配一个常用模板”，优先推荐上面最接近的组合，不要让用户从空白开始想

## References

required:
- `references/advisor-presets.md`

leaf_hints:
- `references/anti-ai-zh.md` — `language=zh` 或 `bilingual`
- `references/anti-ai-en.md` — `language=en` 或 `bilingual`
- `references/style-extraction.md` — 配置了风格样本时
- `references/artifact-scanning.md` — 配置了 artifact 扫描时

## Edge Cases

- 无 git 历史：跳过 git 分析，用 artifact 扫描和口述补足
- 无配置文件：进入 Quick Mode 或首次配置向导
- 无风格样本：跳过风格适配，仅做去 AI 化
- 无状态文件：创建新状态，默认从最近一周开始
- 素材和上次汇报重叠：提示用户，标记重叠部分让用户决定是否保留
- 用户要求 experimental 格式：提示状态并 fallback 到 markdown
- 素材全部 `confidence=preliminary`：在输出开头加一句明确提示

## 与其他 skill 的关系

- `paper-write`：论文写作用 `paper-write`，进展汇报用本 skill
- `humanizer-zh` / `humanizer`：去 AI 化模块引用其规则体系
- `ppw-cover-letter`：投稿 cover letter 用对应 skill，日常汇报用本 skill
