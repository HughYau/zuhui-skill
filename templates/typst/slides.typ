// Progress Slides Template (Typst + Touying)
// Template id: lab-slides
// 需要 touying 包：typst compile slides.typ
// experimental — 基本结构可用，样式待打磨

#import "@preview/touying:0.5.5": *
#import themes.simple: *

#show: simple-theme.with(aspect-ratio: "16-9")

= Weekly Progress

2026-03-25 to 2026-04-01 / Your Name

== This Week

- Mixup outperformed CutMix on CIFAR-10.
- Reading notes on CutMix gave three concrete follow-up ideas.

// 插入图表：
// #figure(
//   image("results/example.png", width: 70%),
//   caption: [实验结果],
// )

== Questions

- Which follow-up direction should go first?
- Should we request more GPU resources?

== Blockers

- GPU queue is slowing down larger runs.

== Next Steps

- Run the ImageNet-subset validation.
- Start the related-work draft.
