#import "@preview/colorful-boxes:1.3.1": *
#import "@preview/cheq:0.2.0": checklist
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
  //#line(length: 100%)

  *>>> This list shows what sections are ready to be reviewed. <<<*
  
  - [ ] Abstract
  - [ ] Acknowledgement
  + *Intro*
    - [ ] #link(<chap:intro>)[Intro]
  + *Simulator*
    - [x] #link(<sec:simulator:intro>)[1. Intro]
    - [x] #link(<sec:simulator:reverb>)[2. Background]
      - [x] #link(<sec:simulator:reverb:background>)[2.1 Acoustic]
      - [x] #link(<sec:simulator:reverb:methods>)[2.2 Simulation methods and libraries]
      - [x] #link(<sec:simulator:background:rir_libraries>)[2.3 RIR libraries]
    - [x] #link(<sec:simulator:simulator>)[3. Simulator]
      - [x] #link(<sec:simulator:simulator:overview>)[1. Overview]
      - [x] #link(<sec:simulator:simulator:components>)[2. Components]
      - [x] #link(<sec:simulator:simulator:features>)[3. Features]
      - [ ] #link(<sec:simulator:simulator:performance>)[4. Performance] -> Not enough time + chapter already big enough
    - [x] #link(<sec:simulator:conclusion>)[4. Conclusion]
  + *SSL*
    - [-] #link(<sec:ssl:sota>)[1. Background]
    - [-] #link(<sec:ssl:single_source>)[2. Single-source]
    - [-] #link(<sec:ssl:multi_source>)[2. Multi-source]
  + *Active SSL*
    - [x] #link(<sec:active_ssl:background>)[1. Background]
    - [x] #link(<sec:active_ssl:methods>)[2. Methods]
    - [x] #link(<sec:active_ssl:results>)[3. Results]
    - [x] #link(<sec:active_ssl:conclusion>)[4. Conclusion]
  + *RL*
    - [-] #link(<sec:rl:intro>)[1. Intro to RL]
    - [-] #link(<sec:rl:method>)[2. Sound-driven robot navigation]
    - [-] #link(<sec:rl:results>)[3. Experiments and discussions]
  + *Conclusion*
    - [ ] #link(<chap:conclusion>)[Conclusion]
]

#pagebreak()
#outline-colorbox(
  title: "Final checklist",
  color: "blue",
  width: auto,
  radius: 2pt,
  centering: true
)[
  #show: checklist
  - [ ] Grammar check
  - [ ] Ensure consistency between: BatchNorm / Batch Norm / batch norm
  - *Layout:*
    - [ ] figure/table placement check
    - [ ] Check that all `subpar.grid` figures have their:
      - [ ] `numbering` set to `fig-numbering`,
      - [ ] `numbering-sub-ref` set to `fig-numbering-sub-ref`,
      - [ ] `align` set to `top`,
      - [ ] `placement` set to `fig-placement`,
    - [ ] Check margins
    - [ ] Check all page breaks\
      $=>$ i.e. that nothing is incorrectly split across two subsequent pages.
]

#outline-colorbox(
  title: "My questions to you, reviewers",
  color: "red",
  width: auto,
  radius: 2pt,
  centering: true
)[
  #show: checklist
  
  *General questions:*
  - [ ] Should we note tensor shapes $(X, Y, Z)$ or $X times Y times Z$ ?
  - [x] DOA or DoA ? FOV or FoV ?
    - Xavi: I prefer DoA, FoV.
    - This is what has been done.

  *Visual/Layout questions:*
  - [ ] Aren't the margins OK ?\
    -> I am currently using 2.5cm everywhere.
  - [ ] Should library names (SpeechBrain, gpuRIR...) be emphasized ? (italics ?)
  - [ ] Should the links (references to sections/papers) be in blue?
  - [ ] Limit the _Table of Contents_ depth ? (currently none)
  - [ ] Should figure captions be centered or left-align? (I assume that table captions will them always be centered)

  *Style-related questions:*
  - [x] Is passive style OK ? to be encouraged? discouraged ?\
    Xavi: Use it when you need to.
    \<SUBJECT\> is/will be/has been \<VERB\>.

  *Questions for Laurent:*
  #strike[
    - [x] How to compute duration from $F$ (i.e. number of #acr("STFT") frames) ?\
      $N = H(T - 1) => d = H(T - 1) / f$
  ]
  - [ ] How to organize the "audio" sections ?

  *Remarks:*
  - I have added _local_ TOCs at the beginning of each chapter to help me, but I plan to remove them later.
]