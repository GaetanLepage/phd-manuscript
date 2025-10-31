#import "/_misc/deps.typ"
#import deps.subpar
#import "/utils.typ": *

#subpar.grid(
  figure(
    image("mic_array_binaural.svg", width: 100%),
    caption: [
      Binaural array.
    ],
  ),
  <fig:simulator:simulator:mic_arrays:binaural>,

  figure(
    image("mic_array_triangle.svg", width: 100%),
    caption: [
      Triangle array.
    ],
  ),
  <fig:simulator:simulator:mic_arrays:triangle>,

  figure(
    image("mic_array_square.svg", width: 100%),
    //image("/assets/mountains.jpg"),
    caption: [
      Square array.
    ],
  ),
  <fig:simulator:simulator:mic_arrays:square>,

  columns: 3,
  caption: flex-caption(
    short: [
      Examples of microphone arrays available in the simulator.
    ],
    long: [
      Examples of microphone arrays available in the simulator.
      All dimensions and angle values of the displayed geometries can be customized.
    ],
  ),
  align: top,
  placement: fig-placement,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  gap: grid-fig-gap,
  label: <fig:simulator:simulator:mic_arrays>,
)
