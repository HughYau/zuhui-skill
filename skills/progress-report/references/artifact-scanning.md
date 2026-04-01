# Artifact 扫描指南

## 目的

科研进展大量存在于非代码产物中。Git 只能覆盖代码和提交层面的变更，但实验结果图、notebook 分析、阅读笔记、数据处理产物等同样是重要的进展证据。Artifact 扫描补充 git 分析的盲区。

## 扫描逻辑

1. 读取配置中的 `artifacts.scan_dirs` 和 `artifacts.file_patterns`
2. 在每个目录中查找匹配 pattern 的文件
3. 只保留 **`last_report_at` 之后修改** 的文件（从状态文件读取时间戳）
4. 无状态文件时，默认扫描最近 7 天修改的文件

## 文件类型处理

### 结果图片（*.png, *.jpg, *.pdf）
- 记录文件名和修改时间
- 从文件名或所在目录推测实验名称（如 `results/cifar10_mixup_acc.png` → 实验 "cifar10 mixup"）
- 列出供用户选择是否纳入汇报
- 如果输出格式支持插图（markdown slides），可引用路径

### Jupyter Notebook（*.ipynb）
- 读取 notebook，提取：
  - 第一个 markdown cell 作为标题/描述
  - 最后几个输出 cell 的摘要（表格、图表、打印结果）
- 生成一句话摘要供用户确认

### Markdown 笔记（*.md）
- 读取标题（第一个 # 标题）和前几行内容
- 如果是阅读笔记，提取论文标题和关键结论
- 如果是讨论记录，提取决策和 action items

### CSV / 表格数据（*.csv, *.tsv）
- 读取列名和行数
- 如果文件名暗示是实验结果（如 `results_comparison.csv`），标记为实验产物
- 不读取完整内容，只提供元信息

### 其他文件
- 记录文件名和修改时间
- 让用户决定是否有汇报价值

## 输出格式

扫描结果以列表形式展示给用户：

```
发现以下近期更新的文件：

  [实验产物]
  ✓ results/cifar10_mixup_acc.png     (3月28日修改)
  ✓ results/comparison_table.csv      (3月29日修改)

  [Notebook]
  ✓ notebooks/mixup_analysis.ipynb    (3月27日修改)
    → "Mixup vs CutMix Comparison on CIFAR-10"

  [笔记]
  ✓ notes/cutmix-reading.md           (3月26日修改)
    → "CutMix论文阅读笔记"

哪些要纳入本次汇报？（默认全选，输入编号排除）
```

用户确认后，选中的 artifact 作为 evidence 附加到对应的素材池 item 中。

## 和 git 分析的配合

- Artifact 扫描在 git 分析之后执行
- 如果某个 artifact 的修改时间和某个 git commit 相近，尝试自动关联
- 用户可以手动调整关联关系
- 最终素材池中，每个 item 的 evidence 可以同时包含 git ref 和 artifact ref
