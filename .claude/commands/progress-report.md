---
name: progress-report
description: |
  生成研究进展汇报（邮件/即时消息/文档），适配不同沟通对象，双语去AI化。
---

读取并遵循 `<repo-prefix>/skills/progress-report/SKILL.md`。
如果仓库就放在当前工作目录，`<repo-prefix>/` 可省略；如果仓库被克隆到子目录（例如 `.progress-report-skill/`），必须带上此前缀。

用户希望生成研究进展汇报。

$ARGUMENTS

输出要求：
1. 如果用户传了 `--init`，进入 Interactive Init：用聊天方式完成 5-7 个低负担问题，并生成或更新 `.progress-config.yaml`
2. 如果用户传了 `--quick`，或没有配置文件且用户只是想先出一版结果，走 Quick Mode（只问三个问题，立即生成）
3. 用户是首次使用且没有明确要求复杂配置时，优先选择最低心智负担路径：先完成 Quick Mode，再提示可迁移到最小配置样例 `<repo-prefix>/skills/progress-report/assets/samples/example-config.minimal.yaml`
4. 否则按 Full Mode 工作流执行（配置→素材收集→内容生成→导出源码/输出）
5. 素材收集时同时扫描 git 历史和 artifact 目录
6. 素材池中 `confidence`、`asks`、`decisions_needed` 字段要如实反映，不要遗漏
7. 根据 profile 的导师预设调整详略，并应用 `vocabulary` 与 `tone` 约束后再执行去AI化
8. 如果用户不确定怎么配 profile，优先参考 `skills/progress-report/references/profile-recipes.md` 中最接近的场景，而不是让用户从空白配置开始
9. 如果用户要求 `typst`、`latex`、`quarto`，先生成 markdown 内容，再生成对应模板源码；模板位于 `skills/progress-report/assets/templates/`，按用户需要直接返回源码或保存到文件
10. 如果没有 git 历史、没有 artifact 目录、或主要进展来自口述，不要把这些情况当成失败；应降级为可用路径继续生成
11. 只有在用户确认本次结果可用后，才更新 `.progress-state.yaml`

常用参数：
- `--profile`：使用指定 profile
- `--format`：`email | chat | markdown | typst | latex | quarto`
- `--layout`：`report | slides`
- `--template`：覆盖默认导出模板，例如 `classic-report | thesis-status | lab-slides`
- `--verbosity`：`brief | standard | detailed`
- `--language`：`zh | en | bilingual`
- `--since`：覆盖默认时间范围
- `--tone`：`neutral | struggling | triumphant`
- `--init`：启动交互式初始化向导并生成配置
- `--quick`：强制 Quick Mode

文档导出说明：
- `typst`、`latex`、`quarto` 走 markdown-first 导出路径：先稳定生成内容，再映射到模板源码
- 默认行为是返回源码文本，或在用户要求时保存为对应代码文件
- Typst slides 模板当前依赖 `@preview/touying:0.5.5`
- 不需要主动尝试本地编译，也不需要把输出升级成 PDF
