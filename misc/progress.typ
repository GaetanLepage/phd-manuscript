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
  #line(length: 100%)
  + *Front:*
    - [ ] Abstract
    - [ ] Acknowledgement
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
    - [ ] Intro to RL
    - [ ] Sound-driven robot navigation
    - [ ] Experiments and discussions
  + *Conclusion*
  #line(length: 100%)
  - *Final things:*
    - [ ] Grammar check
    - *Layout:*
      - [ ] figure/table placement check
      - [ ] Check that all `subpar.grid` figures have their `numbering` set to `fig-numbering`
      - [ ] Check margins
]

#gaet[
  
  *General questions:*
  - Aren't the margins too narrow ?
  - Should the links (references to sections/papers) be in blue ?
  - Should we note tensor shapes $(X, Y, Z)$ or $X times Y times Z$ ?

  *Remarks:*
  - I have added _local_ TOCs at the beginning of each chapter to help me, but I plan to remove them later.
]