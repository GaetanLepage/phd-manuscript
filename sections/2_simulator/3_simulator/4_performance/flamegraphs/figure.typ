#import "/utils.typ": *

#let image-width = 95%

#subpar.grid(
  figure(
    image(
      "flamegraph_pyroomacoustics.png",
      width: image-width,
    ),
    caption: [
      _Pyroomacoustics_ back end
    ]
  ),
  //<fig:simulator:simulator:mic_arrays:binaural>,
  
  figure(
    image(
      "flamegraph_gpurir.png",
      width: image-width,
    ),
    caption: [
      _gpuRIR_ back end
    ]
  ),
  //<fig:simulator:simulator:mic_arrays:triangle>,
  
  columns: 1,
  caption: [
    Profiling results for both available RIR simulation back ends.
  ],
  align: top,
  placement: fig-placement,
  gap: grid-fig-gap,
  label: <fig:simulator:simulator:performance:flamegraphs>,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
)
