// Progress Report Template (Typst)
// Template id: classic-report
// 可直接编译：typst compile report.typ
// 将示例文本替换成你的内容即可使用

#set document(title: "Weekly Progress Report", author: "Your Name")
#set page(paper: "a4", margin: (x: 2.5cm, y: 2cm))
#set text(size: 11pt)
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.8em)

// 中文用户取消下面这行注释
// #set text(font: ("New Computer Modern", "Noto Sans CJK SC"), size: 11pt, lang: "zh")

#align(center)[
  #text(size: 16pt, weight: "bold")[Weekly Progress Report]

  #text(size: 11pt, fill: gray)[2026-03-25 to 2026-04-01]

  Your Name
]

#line(length: 100%, stroke: 0.5pt + gray)

= Summary

// 1-2句话概括本周整体进展

= Progress

== Experiment A

- Tested mixup on CIFAR-10 after last week's discussion.
- Accuracy improved from 78.3% to 81.7%.
- Evidence: commit `abc1234`, figure `results/example.png`

// 插入结果图（取消注释并替换路径）：
// #figure(
//   image("results/example.png", width: 80%),
//   caption: [实验结果],
// )

== Reading and Discussion

- Read the CutMix paper and wrote down three follow-up ideas.
- Discussed detection-task extensions with a senior labmate.

= Questions

- Which direction should we prioritize next: adaptive mixup, contrastive learning, or detection?
- Do we need to request extra GPU time for the ImageNet run?

= Blockers

- GPU queue is long. ImageNet experiments may be delayed by about a week.

= Next Steps

- Validate the result on an ImageNet subset.
- Start drafting the related-work section.
