#import "/utils.typ": *
#import "../../_notations.typ": *

=== Benchmarking and Performance analysis
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
To speed up this step, we perform the convolution in the Fourier domain instead of in the time domain (Section 8.7 of Oppenheim et al. @oppenheim_discrete-time_1989).
This leverages the aforementioned convolution theorem (@eq:simulator:background:conv_theorem) and adapts #text[@eq:simulator:background:reverb_convolution] as follows:
$
  x[n] &= (#rir * s)[n]\
  &= cal(F)^(-1) [cal(F)(#rir) times cal(F)(s)].
$
In the Fourier domain, the convolution turns into a simple product and is thus less computationally expensive.
The cost of computing the forward and inverse Fourier transforms is worth it overall, especially for longer signals.
The complexity of the naive convolution, operated in the time domain, is $O(L_s times L_"RIR")$ where $L_s$ and $L_"RIR"$ are the respective lengths of the clean speech signal and the #acr("RIR") filter.
By contrast, the total complexity of the #acr("FFT")-convolution approach is $O(L log(L))$


We experiment with a binaural array and four sources randomly placed in a room.
The reverberation time $T_60$ is set to 500ms.
The simulator is tasked to render the multichannel audio signal received by each microphone.
These signals result from the sound emitted by the four sources and the reverberation effects encoded in the #acr("RIR") filters.
For 100 steps, the sources will load a new speech sample from the _LibriSpeech_ corpus @panayotov_librispeech_2015.
Each sentence is trimmed to last 6 seconds to enhance reproducibility.
This experiment is repeated for the two supported #acr("RIR") back-ends.
Apart from which library performs the acoustic simulation, every parameter remains the same.
We profile the simulator's execution in both cases to study the relative importance of the different computation steps.
The _py-spy_ @frederickson_benfredpy-spy_2025 and _vprof_ @volynets_nvdvvprof_2025 utilities are employed to perform this profiling.

#include "flamegraphs/figure.typ"
#include "table.typ"

@fig:simulator:simulator:performance:flamegraphs displays the resulting flame graphs.
They illustrate the relative amount of time spent in each part of the code.
We restricted the view to the `step` function, which hosts the simulation code of interest.
This excludes the time spent initializing modules and libraries and loading the dataset.
These representations do not display the difference in absolute time between the two runs but only how time is spent in the different parts of the process.
To account for this, @table:simulator:simulator:performance:backends gives the absolute durations involved.
$T_"sim"$ measures the total time spent in the `step` function.
We notice that _gpuRIR_ can compute the 100 sets of 8 #acr("RIR") filters considerably faster than _Pyroomacoustics_.
The #acr("RIR") simulation took 3.69 and 109 seconds, respectively (denoted as $t_"RIR"$).
The flame graph clearly shows that this step is the principal bottleneck when running the simulator with the _Pyroomacoustics_.
Conversely, when using _gpuRIR_, $t_"RIR"$ becomes negligible compared to the other computation steps involved.
$t_"FFT"$ denotes the duration of the 8 convolutions between the 6s long clean source signals and the generated #acr("RIR")s.
$t_"STFT"$ measures the time taken by the computation of the #acr("STFT") from the generated listened signals.

This simple experiment highlights how significantly the choice of each component can matter in the overall simulator performance.
Our framework's ability to support both _Pyroomacoustics_ and _gpuRIR_ back-ends grants it great flexibility.
The high performance of the _gpuRIR_ back-end allowed us to generate considerable datasets, which have been keyed to our subsequent research efforts in localization and navigation.
In future works, it could be relevant to explore other strategies for speeding up the convolution step by operating the #acr("FFT")-convolution operation on the #acr("GPU").