// Progress Slides Template (Typst + Touying)
// 需要 touying 包：typst compile slides.typ
// experimental — 基本结构可用，样式待打磨

#import "@preview/touying:0.5.5": *
#import themes.simple: *

#show: simple-theme.with(aspect-ratio: "16-9")

= Weekly Progress

{{period}} / {{author}}

== This Week

// 要点列表，每项1-2句

// 插入图表：
// #figure(
//   image("results/example.png", width: 70%),
//   caption: [实验结果],
// )

== Blockers

// 卡点，是否需要帮助

== Questions

// 需要导师确认的事项

== Next Steps

// 下周计划
