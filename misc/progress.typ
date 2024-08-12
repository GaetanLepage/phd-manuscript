#import "@preview/colorful-boxes:1.3.1": *
#import "@preview/cheq:0.1.0": checklist
#import "/utils.typ": *

#pagebreak()
#outline-colorbox(
  title: "Progress",
  color: "green",
  width: auto,
  radius: 2pt,
  centering: true
)[
  #show: checklist
  - *Misc:*
    - [ ] switch to a proper manuscript template
  #line(length: 100%)
  + *Intro*
    - [ ] write
  + *Simulator*
    + Intro
      - [ ] writting (incomplete)
    + Background
      - [ ] writting
    + Simulator implementation
      - [x] 1. Overview
      - [x] 2. Components
      - [ ] 3. Features
        - [x] 1. Dynamic scenarios
        - [ ] 2. ASR / WER maps
      - [ ] 4. Performance
    + Conclusion
  + *SSL*
    - [ ] 1. Background
    - [ ] 2. Single-source
    - [ ] 3. Multi-source
  + *Active SSL*
    - [ ] 1. SotA
    - [ ] 2. Methods
    - [ ] 3. Results
  + *RL*
  + *Conclusion*
  #line(length: 100%)
  - *Final things:*
    - [ ] Grammar check
    - [ ] figure/table placement check
]

#gaet[I have added _local_ TOCs at the beginning of each chapter to help me, but I plan to remove them later.]