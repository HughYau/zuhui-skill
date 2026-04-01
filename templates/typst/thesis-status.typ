// Thesis Status Template (Typst)
// Template id: thesis-status
// 可直接编译：typst compile thesis-status.typ

#set document(title: "Thesis Progress Note", author: "Your Name")
#set page(paper: "a4", margin: (x: 2.6cm, y: 2.2cm))
#set text(size: 11pt)
#set heading(numbering: "1.1")
#set par(justify: true, leading: 0.85em)

// 中文内容可启用 CJK 字体：
// #set text(font: ("New Computer Modern", "Noto Sans CJK SC"), size: 11pt, lang: "zh")

#align(center)[
  #text(size: 17pt, weight: "bold")[Thesis Progress Note]

  #text(size: 11pt, fill: gray)[Chapter-oriented weekly status]

  Your Name
]

= Current Thesis Focus

- Main problem: robust data augmentation for small-sample image classification.
- Current chapter tie-in: methodology and evaluation design.

= Completed Since Last Report

== Experiments

- Re-ran the mixup baseline with a fixed seed set.
- Confirmed the earlier gain was reproducible on three random seeds.
- Evidence: commit `abc1234`, table `results/reproducibility.csv`.

== Writing

- Drafted a one-page note on evaluation protocol changes.
- Cleaned up the thesis outline for the methods chapter.

= Risk Register

- The current result is still on CIFAR-10 only.
- ImageNet-subset validation is blocked by GPU queue time.

= Decisions Needed

- Should the next chapter focus on augmentation first or move to representation learning?
- Is a negative result section worth keeping in the thesis structure?

= Next Milestones

- Run the ImageNet-subset validation.
- Turn the evaluation note into a thesis subsection draft.
- Prepare one figure that compares all augmentation variants side by side.
