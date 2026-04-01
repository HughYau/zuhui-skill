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
2. 用户是首次使用且没有明确要求复杂配置时，优先选择最低心智负担路径：先完成 Quick Mode，再提示可迁移到最小配置样例 `samples/example-config.minimal.yaml`
3. 否则按 Full Mode 工作流执行（配置→素材收集→内容生成→输出）
4. 素材收集时同时扫描 git 历史和 artifact 目录
5. 素材池中 confidence 和 asks 字段要如实反映，不要遗漏
6. 根据 profile 的导师预设调整详略，对生成内容执行去AI化
7. 如果用户不确定怎么配 profile，优先参考 `docs/profile-recipes.md` 中最接近的场景，而不是让用户从空白配置开始
8. 如果用户要求 experimental 格式，明确提示 experimental 状态，并回退到 markdown 结果
9. 如果没有 git 历史、没有 artifact 目录、或主要进展来自口述，不要把这些情况当成失败；应降级为可用路径继续生成
10. 只有在用户确认本次结果可用后，才更新 `.progress-state.yaml`
