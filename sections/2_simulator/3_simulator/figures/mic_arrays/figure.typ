#import "/utils.typ": *

#subpar.grid(
  figure(
    image("mic_array_binaural.svg", width: 100%),
    caption: [
      Binaural array
    ]
  ),
  <fig:simulator:simulator:mic_arrays:binaural>,
  
  figure(
    image("mic_array_triangle.svg", width: 100%),
    caption: [
      Triangle array
    ]
  ),
  <fig:simulator:simulator:mic_arrays:triangle>,
  
  figure(
    image("mic_array_square.svg", width: 100%),
    //image("/assets/mountains.jpg"),
    caption: [
      Square array
    ]
  ),
  <fig:simulator:simulator:mic_arrays:square>,
  columns: 3,
  caption: [
    Examples of microphone arrays available in the simulator
  ],
  align: top,
  numbering: fig-numbering,
  gap: grid-fig-gap,
  label: <fig:simulator:simulator:mic_arrays>,
)