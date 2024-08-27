#import "/utils.typ": *

#subpar.grid(
  figure(
    square(size: 10em, stroke: 2pt),
    caption: [
      Spectrogram
    ]
  ), <fig:ssl:sota:tf_representations:spectrogram>,
  figure(
    square(size: 10em, stroke: 2pt),
    caption: [
      #reset-acronym("ILD")
      #acr("ILD")
    ]
  ), <fig:ssl:sota:tf_representations:ild>,
  figure(
    square(size: 10em, stroke: 2pt),
    //image("/assets/mountains.jpg"),
    caption: [
      #reset-acronym("IPD")
      #acr("IPD")
    ]
  ), <fig:ssl:sota:tf_representations:ipd>,
  columns: (1fr, 1fr, 1fr),
  align: top,
  numbering: fig-numbering,
  caption: [Illustration of time-frequency representations of a speech signal],
  gap: grid-fig-gap,
  label: <fig:ssl:sota:tf_representations>,
)