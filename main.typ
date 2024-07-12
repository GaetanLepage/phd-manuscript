#import "template.typ": *
#import "@preview/acrostiche:0.3.1": *
#import "@preview/drafting:0.2.0": *


#show: project.with(
  title: "Deep Learning for Dynamic Acoustic Robot Interactions",
  authors: (
    (name: "Gaétan Lepage", affiliation: "RobotLearn Team, Inria Grenoble Alpes"),
  ),
  // date: "March 27, 2024",
)
#set-page-properties()

#init-acronyms((
  "ASR": ("Automatic Speech Recognition"),
  "RL": ("Reinforcement Learning"),
  "SSL": ("Sound Source Localization"),
  "IPD": ("Interaural Phase Difference"),
  "ILD": ("Interaural Level Difference"),
  "DOA": ("Direction of Arrival"),
  "STFT": ("Short Term Fourier Transform"),
))

#set math.equation(numbering: "(1)")

#outline(title: "Table of Contents", indent: true, depth: 2)

// TODO
#include "sections/index.typ"
#bibliography("bibliography.bib")