---
name: progress-report
description: |
  生成研究进展汇报（邮件/即时消息/文档），适配不同沟通对象，双语去AI化。
---

读取并遵循 `skills/progress-report/SKILL.md`。

用户希望生成研究进展汇报。

$ARGUMENTS

输出要求：
1. 如果用户传了 --quick 或没有配置文件，走 Quick Mode（只问三个问题，立即生成）
2. 否则按 Full Mode 工作流执行（配置→素材收集→内容生成→输出）
3. 素材收集时同时扫描 git 历史和 artifact 目录
4. 素材池中 confidence 和 asks 字段要如实反映，不要遗漏
5. 根据 profile 的导师预设调整详略，对生成内容执行去AI化
6. 如果用户要求 experimental 格式，明确提示 experimental 状态，并回退到 markdown 结果
7. 只有在用户确认本次结果可用后，才更新 `.progress-state.yaml`
