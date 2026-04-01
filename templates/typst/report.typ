// Progress Report Template (Typst)
// 可直接编译：typst compile report.typ
// 用户替换 {{}} 占位符后即可使用

#set document(title: "Weekly Progress Report", author: "{{author}}")
#set page(paper: "a4", margin: (x: 2.5cm, y: 2cm))
#set text(size: 11pt)
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.8em)

// 中文用户取消下面这行注释
// #set text(font: ("New Computer Modern", "Noto Sans CJK SC"), size: 11pt, lang: "zh")

#align(center)[
  #text(size: 16pt, weight: "bold")[Weekly Progress Report]

  #text(size: 11pt, fill: gray)[{{period}}]

  {{author}}
]

#line(length: 100%, stroke: 0.5pt + gray)

= Summary

// 1-2句话概括本周整体进展

= Progress

== {{item_1_title}}

// 描述、结果、evidence

// 插入结果图（取消注释并替换路径）：
// #figure(
//   image("results/example.png", width: 80%),
//   caption: [实验结果],
// )

== {{item_2_title}}

// ...

= Blockers

// 遇到的问题，是否需要帮助

= Questions for Advisor

// 需要导师确认/决策的事项
// 这一节不要省略——即使没有问题也写"暂无"

= Next Steps

// 下周计划
