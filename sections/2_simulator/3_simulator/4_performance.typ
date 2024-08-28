#import "/utils.typ": *

=== Performance
<sec:simulator:simulator:performance>

In this section, a simple ben

#draft[
  - FFT convolution complexity w.r.t the length of the signal ($O(n)$ I suppose)
  - Compare to classic 1D convolution
]

==== Benchmarking #acr("RIR") simulation back ends

#subpar.grid(
  figure(
    image("figures/flamegraph_pyroomacoustics.png", width: 90%),
    caption: [
      _Pyroomacoustics_ back end
    ]
  ),
  <fig:simulator:simulator:mic_arrays:binaural>,
  
  figure(
    image("figures/flamegraph_gpurir.png", width: 90%),
    caption: [
      _gpuRIR_ back end
    ]
  ),
  <fig:simulator:simulator:mic_arrays:triangle>,
  
  columns: 1,
  caption: [
    Profiling results for both available #acr("RIR") simulation back ends
  ],
  align: top,
  gap: grid-fig-gap,
  label: <fig:simulator:simulator:flamegraphs>,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
)