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
- 给导师/联导/协作者写进展邮件
- 在微信/Slack/Teams上同步进展
- 从git历史和项目产物中生成进展摘要
- 生成进展报告的markdown文档

关键词：组会、汇报、进展、weekly report、progress update、advisor、导师

## 不适用场景

- 论文写作（用 paper-write）
- 投稿/审稿邮件（用 cover-letter）
- 纯代码review（用 code-reviewer）

## 两种模式

### Quick Mode（零配置，应急用）

当没有 `.progress-config.yaml` 或用户明确要求快速生成时，只问三个问题：
1. **发给谁？**（导师名字或"组会"）
2. **什么场景？**（email / 微信 / slides）
3. **最近做了什么？**（口述，或 "帮我看git"）

立即生成可发送的版本。不做风格学习，去AI化用默认规则。
生成后提示："要不要保存为常用 profile？下次直接用。"

### Full Mode（有配置，日常用）

走完整工作流（下面的 Step 0-4）。

---

## 工作流（Full Mode）

### Step 0: 加载配置和状态

读取两个文件：
- `.progress-config.yaml` — 配置（profiles、风格、仓库、artifact目录）
- `.progress-state.yaml` — 状态（上次汇报时间、commit范围、历史）

如果配置不存在 → 进入首次配置向导或降级到 Quick Mode。
如果状态不存在 → 创建空状态文件，素材从"最近一周"开始。

选择本次使用的 profile：
- 用户指定了 `--profile xxx` → 用指定的
- 没指定 → 用 `default_profile`
- 命令行参数（--format等）可覆盖 profile 中的对应字段

### Step 1: 素材收集

**时间范围确定**：
- 默认：从 `last_report_at`（状态文件）到现在
- 用户可用 `--since` ���盖
- 如果和上次汇报有重叠，提示用户确认（防重报）

**四种素材来源**：

**A — Git 进展**：
```bash
git log --since=<last_report_at> --pretty=format:"%h|%s|%an|%ad" --date=short
```
- 对关键commit跑 `git diff --stat`
- 自动分类：experiment / feature / fix / docs / chore
- 多仓库按 `repos` 配置依次分析
- 和上次 `last_report_range` 对比，标记哪些是新增的

**B — Artifact 扫描**：
扫描 `artifacts.scan_dirs` 中在 `last_report_at` 之后修改的文件：
- 结果图片（*.png, *.pdf）→ 标记为实验产物
- Notebook（*.ipynb）→ 提取标题和关键输出
- Markdown笔记 → 提取标题和摘要
- CSV/表格 → 标记为数据产物
- 列出发现的artifact，让用户��选要纳入汇报的

**C — 用户口述**：
- 自由文本描述（中英混合ok）
- 引导补充：不在代码里的进展（论文阅读、讨论决策、被否���的尝试、线下实验）

**D — 组合**（推荐）：
先跑 A+B 自动提取，展示给用户，再让用户用 C 补充遗漏的

**素材池结构**：

```yaml
progress_pool:
  period: "2026-03-25 ~ 2026-04-01"
  items:
    - category: experiment    # experiment | reading | coding | writing | discussion | other
      what: "在CIFAR-10上测试了mixup数据增强"
      why: "上周组会决定验证mixup对小样本的效果"
      result: "准确率78.3%→81.7%，比cutmix���"
      confidence: high        # high | medium | low | preliminary
      evidence:
        - type: git
          ref: "abc1234 - add mixup augmentation"
        - type: artifact
          ref: "results/cifar10_mixup_acc.png"
      asks: null              # 需要导师决策/���助的事项

    - category: reading
      what: "精读了CutMix论文"
      why: "找对比方法"
      result: "总结了3个改进方向"
      confidence: medium      # 还没验证
      evidence:
        - type: note
          ref: "notes/cutmix-reading.md"
      asks: "这三个方向老师觉得哪个优先级更高？"

    - category: discussion
      what: "和师兄讨论了检测任务上的扩展可能"
      why: "探索后续方向"
      result: "初步觉得可行，但需要调研更多"
      confidence: preliminary
      evidence: []
      asks: null

  blockers:
    - what: "GPU资源紧张"
      impact: "ImageNet实验需要排队，预计delay一周"
      needs_help: true        # 是否需要导师介入

  next_steps:
    - "在ImageNet子集上验证"
    - "写related work"

  decisions_needed:           # 需要导师拍板的事项（汇总）
    - "cutmix论文中三个改进方向的优先级"
    - "是否需要申请额外GPU资源"
```

展示素材池给用户确认，可增删改。
特别提醒用户检查：confidence 标注是否准确、asks 是否完整。

### Step 2: 内容生成

根据当前 profile 的 `advisor_preset` 调整内容：

| 预设 | 策略 |
|------|------|
| hands-off | 只保留结论和下一步，砍掉过程细节。asks和blockers(needs_help=true)必须保留 |
| detail-oriented | 展开实验设置、参数、对比数据。confidence=low/preliminary的要标出来 |
| high-level | 强调动机和insight。decisions_needed放突出位置 |
| intuitive | 加入类比和直观解释。用简单比喻替代技术细节 |
| custom | 按 custom_traits 描述自由适配 |

详细规则见 `references/advisor-presets.md`。

**事实校验**（生成时内嵌，不是单独步骤）：
- confidence=preliminary 的结论加标记（如"初步结果"、"待进一步验证"）
- evidence 为空的 item 标注为"基于口述/讨论"
- 不夸大结果——如果只跑了一次实验，不说"显著提升"
- asks 和 decisions_needed 放在容易被看到的位置（邮件中不要埋在最后）

根据 profile ��� format 调整结构：

| 格式 | 结构 |
|------|------|
| email | 称呼 → 正文 → **需要您确认的事项** → 下一步 → 签名 |
| chat | 一句话开头 → 要点 → 卡点/求助 → 下一步（控制在一屏内） |
| markdown report | 标题 → 各节 → decisions needed → blockers → next steps |
| markdown slides | 每主题一页，最后一页放 questions & next steps |

### Step 3: 去AI化 + 风格适配

**去AI化**（根据 profile 的 language 字段选规则集）：

- zh → `references/anti-ai-zh.md`
- en → `references/anti-ai-en.md`
- bilingual → 两套都加载

流程：生成初稿 → 扫描AI模式 → 重写（不是换词，是重组表达）→ 二次审查

**风格适配**（有样本时）：
- 读 `style.style_summary` + 参考原始样本
- 匹配句式、用词、结构、开头结尾、标点习惯
- 指南见 `references/style-extraction.md`

### Step 4: 输出 + 状态更新

展示结果，用户可以：
- 微调某段
- 切换到另一个 profile 重新生成（素材池复用）
- 输出到文件

**用户确认后，更新状态文件** `.progress-state.yaml`：
- `last_report_at` → 当前时间
- `last_report_range` → 本次覆盖的 commit 范围
- `last_confirmed_pool` → 本次素材池的 item 哈希
- `history` → 追加一条记录（保留最近20条）

## 输出控制参数

```
/progress-report [options]
  --profile   使用指定的沟通 profile
  --format    email | chat | markdown
  --layout    report | slides
  --verbosity brief | standard | detailed
  --language  zh | en | bilingual
  --since     时间范围，如 "last monday", "2 weeks ago"
  --quick     强制 Quick Mode（跳过配置）
```

格式参数只包含 V1 已实现的格式。
Typst/LaTeX/Quarto 模板在 `templates/` 下作为 experimental 预留，
使用 `--format typst|latex|quarto` 时会提示 experimental 状态并 fallback 到 markdown。

## References

required:
- `references/advisor-presets.md`

leaf_hints:
- `references/anti-ai-zh.md` — language=zh 或 bilingual
- `references/anti-ai-en.md` — language=en 或 bilingual
- `references/style-extraction.md` — 有风格样本时
- `references/artifact-scanning.md` — 有 artifact 配置时

## Edge Cases

- 无git历史 → 跳过git分析，用artifact扫描+口述
- 无配置文件 → Quick Mode 或首次配置向导
- 无风格样本 → 跳过风格适配，仅做去AI化
- 无状态文件 → 创建新状态，默认从"最近一周"开始
- 素材和上次汇报重叠 → 提示用户，标记重叠部分让用户决定是否保留
- experimental格式 → 提示状态，fallback到markdown
- 素材全部 confidence=preliminary → 在输出开头加 disclaimer

## 与其他skill的关系

- paper-write：论文写作用paper-write，进展汇报用本skill
- humanizer-zh / humanizer：去AI化模块引用其规则体系
- ppw-cover-letter：投稿cover letter用ppw，日常汇报用本skill
