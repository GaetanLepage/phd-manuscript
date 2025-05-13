#import "/utils.typ": *

#let fig-width = 5cm

#subpar.grid(
  figure(
    image(
      "stft.png",
      width: fig-width,
    ),
    caption: [
      Spectrogram.
    ]
  ), <fig:ssl:sota:tf_representations:spectrogram>,
  figure(
    image(
      "ild.png",
      width: fig-width,
    ),
    caption: [
      #reset-acronym("ILD")
      #acr("ILD").
    ]
  ), <fig:ssl:sota:tf_representations:ild>,
  figure(
    image(
      "ipd.png",
      width: fig-width,
    ),
    //image("/assets/mountains.jpg"),
    caption: [
      #reset-acronym("IPD")
      #acr("IPD").
    ]
  ), <fig:ssl:sota:tf_representations:ipd>,
  columns: (1fr, 1fr, 1fr),
  align: top,
  placement: fig-placement,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  caption: flex-caption(
    short: [
      Illustration of time-frequency representations of a synthesized speech signal.
    ],
    long: [
      Illustration of time-frequency representations of a synthesized speech signal.
      (a) shows a mono-aural spectrogram obtained from the left microphone.
      (b) and (c) are interaural representations and use both left and right channels.
      Recordings have been generated in the acoustic simulator.
    ],
  ),
  gap: grid-fig-gap,
  label: <fig:ssl:sota:tf_representations>,
)