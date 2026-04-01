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


## 三种入口

### Interactive Init

当用户传了 `--init`，或明确说“帮我配一个 `.progress-config.yaml` / 初始化配置 / 做 onboarding”，先不要急着生成汇报，优先完成配置向导。

目标：
- 把“第一次上手”的负担压到最低
- 用对话式提问替代让用户手写 YAML
- 最终直接产出可用的 `.progress-config.yaml`

向导规则：
1. 总问题数控制在 5-7 个，优先问高价值信息
2. 尽量用用户语言提问，不把问题写成配置字段考试
3. 如果用户回答模糊，做合理默认并明确说明
4. 如果仓库里已经有 `.progress-config.yaml`，不要静默覆盖；先读取现有配置，再生成 merge 建议或新 profile
5. 向导结束后给出：
   - 推荐 profile 名
   - 生成的 `.progress-config.yaml`
   - 为什么这样配置的简短解释

建议问题顺序：
1. 你最常汇报给谁，还是主要用于组会/协作同步？
2. 对方更喜欢看细节、结论，还是需要你把思路讲清楚？
3. 你平时更常用中文、英文，还是要双语底稿？
4. 你最常发邮件、聊天消息，还是做文档/幻灯片？
5. 你组里有没有固定黑话或偏好的术语？
6. 你最近汇报时更常见的语气是稳健中性、卡壳求助，还是突破汇报？
7. 项目里哪些目录最可能出现结果图、notebook、笔记或表格？

向导生成的最小配置至少应包含：
- `default_profile`
- 一个可用的 `profiles.<name>`
- `tone`
- `vocabulary`
- `repos`
- `artifacts.scan_dirs`
- `render`（如果用户需要文档导出）

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
- 如果用户明确想要长期复用工作流，优先建议 `/progress-report --init`
- 如果用户想要“能直接复制的配置”，优先给出 `samples/example-config.minimal.yaml`
- 如果用户说不清 profile 怎么配，优先从 `docs/profile-recipes.md` 里选最接近的沟通场景

这样做的目标是降低首次使用成本，而不是一开始就让用户理解全部配置字段

## 工作流（Full Mode）

### Step 0: 加载配置和状态

读取两个文件：
- `.progress-config.yaml`：profiles、风格、仓库、artifact 目录
- `.progress-state.yaml`：上次汇报时间、commit 范围、历史记录

规则：
- 配置不存在：如果用户明确要初始化或长期复用，进入首次配置向导；否则降级到 Quick Mode
- 状态不存在：创建空状态文件，默认从最近一周开始
- `--profile` 优先于 `default_profile`
- 命令行参数可覆盖 profile 中的 `format`、`layout`、`verbosity`、`language`、`tone`、`render`

推荐配置结构：

```yaml
language: zh

profiles:
  weekly-email:
    audience: "张老师"
    advisor_preset: detail-oriented
    format: email
    layout: report
    verbosity: standard
    language: zh
    tone: neutral
    vocabulary:
      - concept: "run experiments"
        preferred: "跑实验"
      - concept: "ablation study"
        preferred: "控制变量"
    signature:
      name: ""
      closing: "祝好"

default_profile: weekly-email

tone: neutral

vocabulary: []

style:
  sample_files: []
  style_summary: null

repos:
  - path: .

artifacts:
  scan_dirs: [results/, notebooks/, notes/]
  file_patterns: ["*.png", "*.ipynb", "*.md"]

render:
  enabled: auto
  format: markdown
  template: classic-report
  compile: auto
```

字段说明：
- `tone`：默认语气控制。可选 `neutral | struggling | triumphant`
- `vocabulary`：术语偏好表。优先使用 `preferred`，避免泛化成过于标准的 AI 套话
- `render.format`：文档导出目标，可选 `markdown | typst | latex | quarto`
- `render.template`：模板名，例如 `classic-report | thesis-status | lab-slides`
- `render.compile`：`auto | always | never`

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

词汇与语气控制同样是硬约束：
- 如果配置了 `vocabulary`，优先使用用户提供的实验室/导师黑话
- 同一份输出中，术语要前后一致，不要一会儿写 “ablation study” 一会儿写 “控制变量”
- 如果术语可能让外部合作者不理解，应根据 audience 做最小必要解释，而不是机械照搬
- `tone=struggling`：语气可以更委婉，突出卡点、尝试过的路径、希望对方给的帮助
- `tone=triumphant`：重点突出关键突破、证据、影响面，但禁止夸大和抢结论
- `tone=neutral`：保持事实先行，少修辞

按格式组织输出：

| 格式 | 结构 |
|------|------|
| `email` | 称呼 → 正文 → 需要确认的事项 → blockers → 下一步 → 签名 |
| `chat` | 一句话开头 → 要点 → 卡点或求助 → 下一步 |
| `markdown report` | 标题 → progress → questions → blockers → next steps |
| `markdown slides` | 每个主题一页，最后一页放 questions 和 next steps |
| `typst/latex/quarto report` | 先产出 markdown 版结构，再映射到文档模板 |
| `typst/latex/quarto slides` | 先产出 markdown slides 结构，再映射到幻灯片模板 |

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

如果用户请求 `typst`、`latex` 或 `quarto`：
1. 先生成稳定的 markdown 内容
2. 按 `render.template` 选择模板并生成源码
3. 检测本地环境：
   - Typst: `typst --version`
   - LaTeX: `pdflatex --version`
   - Quarto: `quarto --version`
4. 若 `render.compile != never` 且环境存在，则尝试本地编译
5. 若编译成功，返回源码路径和 PDF 路径
6. 若编译失败，返回：
   - markdown 内容
   - 模板源码
   - 失败原因摘要
   - 用户下一步可执行的修复建议

编译策略：
- `classic-report`：最稳健的单页/短报告模板，优先用于 smoke test
- `thesis-status`：更接近 thesis/progress note 的章节结构
- `lab-slides`：组会幻灯片模板
- 对中文内容，如果编译环境缺少 CJK 字体或宏包，不要伪装成成功；要明确指出缺的依赖

只有在用户确认本次结果可用之后，才更新 `.progress-state.yaml`：
- `last_report_at`
- `last_report_range`
- `last_confirmed_pool`
- `history`（只保留最近 20 条）

## 输出控制参数

```text
/progress-report [options]
  --init      交互式初始化并生成 .progress-config.yaml
  --profile   使用指定的沟通 profile
  --format    email | chat | markdown | typst | latex | quarto
  --layout    report | slides
  --template  classic-report | thesis-status | lab-slides
  --verbosity brief | standard | detailed
  --language  zh | en | bilingual
  --since     时间范围，如 "last monday", "2 weeks ago"
  --tone      neutral | struggling | triumphant
  --quick     强制 Quick Mode
  --no-compile 请求文档格式时仅生成源码，不尝试编译
```

稳定输出仍以 `email`、`chat`、`markdown` 为主。
`typst`、`latex`、`quarto` 走增强后的文档导出路径：
- 允许直接请求
- 默认先生成 markdown
- 有环境时尝试编译到 PDF
- 无环境或失败时回退到 markdown + 源码，而不是只给一句 experimental 提示

## 常见适配场景

优先覆盖这些高频场景：
- 主导师周报：`email` + `detail-oriented`
- 组会汇报：`markdown` + `high-level`
- 快速同步：`chat` + `hands-off`
- 英文协作者：`email` 或 `chat` + `en`
- 中英混合沟通：`bilingual`
- 想长期复用又不想手写配置：`--init`
- 想要正式 PDF：`typst` 或 `latex` 的 `classic-report`

如果用户只是说“帮我配一个常用模板”，优先推荐上面最接近的组合，不要让用户从空白开始想

## 低阻塞兜底规则

以下情况都不应阻止生成一版可用结果：
- 没有 git 历史：用 artifact 扫描和用户口述补足
- 没有 artifact 目录：继续用 git 和口述
- 主要进展不在代码里：主动收集讨论、阅读、线下实验、被否掉的尝试
- 用户只想先发出去：优先 Quick Mode，不强推完整配置

原则是先产出一版可编辑结果，再决定是否进入更完整的配置和周期跟踪

## References

required:
- `references/advisor-presets.md`

leaf_hints:
- `references/anti-ai-zh.md` — `language=zh` 或 `bilingual`
- `references/anti-ai-en.md` — `language=en` 或 `bilingual`
- `references/style-extraction.md` — 配置了风格样本时
- `references/artifact-scanning.md` — 配置了 artifact 扫描时
- `samples/example-config.minimal.yaml` — 首次使用引导时
- `docs/profile-recipes.md` — 用户不确定如何配 profile 时

## Edge Cases

- 无 git 历史：跳过 git 分析，用 artifact 扫描和口述补足
- 无配置文件：进入 Quick Mode 或首次配置向导
- 用户要求初始化：优先 `--init`，而不是先逼用户读配置字段
- 无风格样本：跳过风格适配，仅做去 AI 化
- 无状态文件：创建新状态，默认从最近一周开始
- 素材和上次汇报重叠：提示用户，标记重叠部分让用户决定是否保留
- 用户要求文档格式但本地无编译环境：返回 markdown + 模板源码 + 安装提示
- 用户要求文档格式且编译失败：返回失败摘要，不要伪装成 PDF 已生成
- 素材全部 `confidence=preliminary`：在输出开头加一句明确提示
