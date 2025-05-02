#import "/utils.typ": *

=== Performance analysis
<sec:simulator:simulator:performance>

This section provides a short breakdown of the computation load of the simulator.
As seen previously, a typical simulation workflow consists of the following two phases:
- Generation of the #acr("RIR") filters using the #acr("ISM")-simulation library,
- Computation of the listened signal by convolving the source signals with the computed #acr("RIR") filters.
These two steps account for the majority of the overall computation time.
Both are affected by the number of sources and microphones.

On the one hand, the simulation library handles #acr("RIR") computation.
It is provided with the room properties and the positions of each source and microphone.
The result of this step $(n_m, n_s, L_"RIR")$-shape array containing the #acr("RIR") filters for each source-microphone pair.
The performance of the #acr("ISM") algorithm's implementation itself is independent of our control.
It plays a significant role in the overall simulator performance.

On the other hand, once the #acr("RIR") filters have been generated for a given geometrical configuration, the simulator convolves each input signal with the corresponding #acr("RIR") filter for a given microphone.
The obtained results are then summed according to @eq:simulator:rir_listened_signal_multi_source_multi_mic.
Hence, this step requires computing $n_m times n_s$ convolutions.
The time complexity of each convolution depends on the length of the #acr("RIR") filter ($L_"RIR"$).

We experiment with a binaural array and two sources randomly placed in a room.
The reverberation time $T_60$ is set to 500ms.
The simulator is tasked to render the multichannel audio signal received by each microphone.
These signals result from the sound emitted by the two sources and the reverberation effects encoded in the #acr("RIR") filters.
For 30 steps, the sources will load a new speech sample from the _LibriSpeech_ corpus @panayotov_librispeech_2015.
Each sentence is trimmed to last 6 seconds to enhance reproducibility.
@fig:simulator:simulator:flamegraphs shows a flamegraph 

//In this section, a simple ben

#gaet[
  This section is not very important and can be omitted if too little time is available.
]

#draft[
  - FFT convolution complexity w.r.t the length of the signal ($O(n)$ I suppose)
  - Compare to classic 1D convolution
]

==== Benchmarking #acr("RIR") simulation back ends


#include "figures/flamegraphs/figure.typ"