#import "/utils.typ": *

#subpar.grid(
  figure(
    image("flamegraph_pyroomacoustics.png", width: 90%),
    caption: [
      _Pyroomacoustics_ back end
    ]
  ),
  //<fig:simulator:simulator:mic_arrays:binaural>,
  
  figure(
    image("flamegraph_gpurir.png", width: 90%),
    caption: [
      _gpuRIR_ back end
    ]
  ),
  //<fig:simulator:simulator:mic_arrays:triangle>,
  
  columns: 1,
  caption: [
    Profiling results for both available #acr("RIR") simulation back ends
  ],
  align: top,
  placement: fig-placement,
  gap: grid-fig-gap,
  label: <fig:simulator:simulator:flamegraphs>,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
)
<fig:simulator:performance:flamegraphs>