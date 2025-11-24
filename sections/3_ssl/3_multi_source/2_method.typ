#import "/utils.typ": *
#import "_notations.typ": *

=== Method
<sec:ssl:multi_source:method>

He et al. conducted a solid line of work on the multi-source #acr("SSL") problem, focusing on the associated robotics challenges @he_deep_2018 @he_neural_2021 @he_sounddet_2021.
Their approach shows strong performance in challenging real-world scenarios.
For this reason, several aspects of the methodology from @he_neural_2021 inspired the work presented in this section.

==== Dataset Generation and Pre-Processing
<sec:ssl:multi_source:method:dataset>

The dataset generation process remains essentially identical to that presented in @sec:ssl:single_source:method:dataset.
All samples are independent and identically distributed.
The positions of both the microphone array and the sources are randomly sampled.
This section will focus on the necessary additions to support the multi-source setting.
Also, most choices have been made to follow the methodology from He et al. @he_neural_2021.

*Microphone array.*
To effectively localize multiple sound sources, we choose to use a four-microphone array.
The $n_m = 4$ omnidirectional sensors are arranged in a 2cm wide square.


Audio processing has been kept the same, except for the sample duration.
The latter now amounts to approximately 360ms as 16 #acr("STFT") frames participate in each input of the model.


The microphone array and $n_s$ speech sources get randomly positioned in the room.
Such a choice has led to challenging samples where multiple targets share very similar #doa angles from the agent's point of view.
The resulting #acr("RIR")s are computed to account for the room's reverberation properties.
Then, each source outputs a clean speech signal randomly chosen from the #librispeech @panayotov_librispeech_2015 dataset.
The simulator computes the resulting listened signals at each microphone of the array.
Such signals last around 10 seconds.

*Source-wise simulation and late mixing.*
In practice, the sources are not placed simultaneously in the room.
Instead, they only get enabled individually to perform $n_s$ distinct single-source simulations.
This offers more possibilities as explained below.

First, let us start by leveraging the following property.
The signal $s_k$ recorded by the $k$-th microphone expresses simply as the sum of the signals $s_(i, k)$ providing from each source:
$
  s_k [t] = sum_(i=1)^n_s s_(i,k)[t],
$
where $s_(i, k)$ denotes the signal coming from the $i$-th source as received by microphone $k$.
The #acr("STFT") being a linear operator, this equality holds in the feature space:
$
  S_k [t, f] = sum_(i=1)^n S_(i, k)[t, f],
$
where $S_k$ and $S_(i, k)$ are the #acr("STFT") of respectively $s_k$ and $s_(i, k)$.
Hence, instead of saving the final features $S = (S_1, dots, S_(n_m))$, we save each source-specific encoding $S_i = (S_(i, 1), dots, S_(i, n_m))$ individually.

This overhead brings complexity to the data collection process but allows for a significant increase in flexibility.
Indeed, the number of sources plays a prominent role in performance, and quantifying this influence has required experimenting with this parameter.
Disposing of the audio features relating to each individual source allows for choosing how many sources should be active when loading each data sample from the disk.
One solely has to sample a set ${i_1, i_2, dots, i_n}$ of sources to enable and sum the relevant source-specific features $S_i_1, dots, S_i_n$.
The impact of the number of active sources is further studied in @sec:ssl:multi_source:experiments.

*Sampling frequency.*
The method was designed to operate with audio signals sampled at 48 kHz, which does not match the 16 kHz sample rate of the LibriSpeech @panayotov_librispeech_2015 dataset, which provides the simulator with clean speech utterances.
To account for this, the simulation of the audio signals received by each microphone in the array is performed at the native 16 kHz sampling rate.
The generated signals are then up-sampled to 48 kHz using the Fourier method.
More specifically, the signal's #acr("FFT") is zero-padded.
This provides an ideal antialiasing filter at the cost of assuming the signal to be periodic.


*#acr("STFT") representation of audio signals.*
// multi-channel STFT
As discussed in @sec:simulator:background:spectral-features, several choices can be made regarding data representation.
Although we have generated different datasets, the format used in the majority was the Short-Term Fourier Transform.
Thus, the #acr("STFT") is computed from the complete up-sampled simulated signal captured by each of the four microphones.
For this, we employ a Hann window of length 2048, with a 50% overlap.
We also apply band-pass filtering, removing frequencies below 100Hz and above 8kHz.
The consequent #acr("STFT") counts 337 frequency bins.

*Audio chunking.*
We finally extract at most five short chunks of 320ms (i.e., 16 frames) from the global #acr("STFT")s.
This duration constitutes a tradeoff between detection latency and performance.
The longer the method is offered to listen, the more accurate the results will be.
However, in a dynamic robotics context, which we ultimately target, we cannot afford to use long audio sequences to infer the source positions.

#let tau-e = $colMath(tau_E, #orange)$
#let global-spec = $colMath(S_k, #olive)$
#let chunk-spec = $colMath(tilde(S)_k, #maroon)$
*Minimal energy criteria.*
We aim to prevent the inclusion of samples where one of the target sources is not active enough for the recording duration.\
Given its #acr("STFT") $S in CC^(T times F)$, the average energy
#footnote[
  Strictly speaking, this quantity is dimensionally equivalent to a spectral energy density.
  For clarity, we will further refer to it as _energy_.
]
of a real-valued signal, expressed in decibels (dB), is defined as
$
  E(S)_"dB" =
  1 / (T F)
  sum_(t=1)^T
  sum_(f=1)^F
  20 log_10
  lr(abs(S[t, f]), size: #150%).
$
We reject the chunks of the simulated samples where, for at least one microphone, the energy of the selected fragment is too low compared to the average energy of the entire simulated signal.
Let
- #global-spec the #acr("STFT") of the signal received by microphone $k$.
- #chunk-spec the #acr("STFT") of the considered chunk, i.e., a slice of #global-spec.
The energy criteria $delta_"energy"$ defining a valid sample expresses as
$
  delta_"energy" (
    #tau-e
  ) = limits(and)_(k=1)^4
  [
    E(#chunk-spec)_"dB"
    > E(#global-spec)_"dB"
    - #tau-e
  ].
$
where $colMath(tau_E, #orange)$ has been set to 10dB in our primary dataset.
The average energy of a given chunk can be at most 10dB lower than that of the entire signal.
In practice, around 40% of the generated chunks are rejected.

The #acr("STFT") of each multi-channel 360ms segment provides the dataset's final training samples.
Besides each input sample, the relevant ground truth information gets saved for supervising the learning process and computing performance metrics.
It comprises all the necessary geometric information about the microphone array and sources (positions, orientations, relative distance, and angle of incidence).
One million of such sample pairs constitute the core training and test datasets (800k and 200k samples, respectively).
The total audio duration of the data approximates 47 hours.


==== Direction of Arrival Representation
<sec:ssl:multi_source:method:doa_repr>

The objective of the #acr("SSL") task is to predict the #doa of the sound sources.
Hence, the number of predictions outputted by an #acr("SSL") method can differ from situation to situation.
We therefore decided to use a representation of this information that is agnostic to the number of sources.
Such a property is of great interest when training a deep neural network.
The model can then have a fixed output while still being able to handle a varying number of sources.
The latter will be further denoted $n_s$.
The set of #doa values will noted $Theta = (theta_1, ..., theta_n_s)$.


*Spatial Spectrum*

The solution in question has been introduced by He et al. @he_deep_2018 and entails estimating the spatial spectrum.
The spatial spectrum is a real-valued function of the #doa ($cal(o): [-pi, pi] -> RR$).
We discretize this continuous function by encoding the spectra in a $d$-dimensional real vector $o$:
$
  o in [0, 1]^d.
$

We denote $phi.alt_i$ the angle value corresponding to the $i$-th index of $o$:
#func-def(
  $phi.alt$,
  $bracket.l.double 1, d bracket.r.double$,
  $[-pi, pi]$,
  $i$,
  $phi.alt_i.$,
)
<eq:ssl:multi_source:phi_def>
We naturally have
- $phi.alt_1 = - pi$,
- $phi.alt_(floor(d/2)) tilde.eq 0$,
- $phi.alt_d = pi$.


We choose $d = 360$, corresponding to a $1°$ resolution.
Higher spectrum numerical values indicate the presence of a source at this location.
Those angles, being #doa;s, are relative to the microphone array's orientation.
A peak at $0°$ designates the presence of a source in front of the microphones.


#block(breakable: false)[
  *Multi-Source #doa Encoding*

  The dataset contains the #doa values for each sample.
  We need to convert this list of scalar angular values to our spatial spectrum encoding format so that we can use it as a regression target.
  Numerous methods could be employed to achieve this.
  A first solution to this problem could be placing a pseudo-Dirac at the exact location of the sources.
  //$
  //  o(Theta)_i = sum_(k=1)^n_s bb(1)_(phi.alt_i = theta_k),
  //$

  $
    o(Theta)_i := cases(
      1 #h(1cm) & "if" exists theta in Theta | phi.alt_i = theta,
      0 & "otherwise,"
    )
  $
]
Instead, a more robust regression target is introduced.
It consists in combining $n_s$ unnormalized Gaussians centered at each #doa angles:
$
  o(Theta)_i := cases(
    display(max_(theta in Theta))
    {
      e^(
      -(#d (
        phi.alt_i,
        theta
      )^2)
      / sigma^2
      )
    } & "if" n_s > 0,
    0 & "otherwise,"
  )
$
<eq:ssl:multi_source:doa_encoding>
where #d is the symmetric angular distance introduced in @sec:ssl:single_source:experiments:metrics (@eq:ssl:single_source:angular_dist).
//The result is a mixture of $n_s$ unnormalized Gaussians centered at the actual #doa angles.
We chose to set $sigma = 5°$.
@fig:ssl:multi_source:doa_gt_encoding shows an example of the DOA encoding scheme for a situation with two sources.

#figure(
  image("figures/doa_encoding.svg"),
  caption: [
    #_doa spectrum encoding of three sources.
  ],
)
<fig:ssl:multi_source:doa_gt_encoding>

*Detection Decoding*

The employed #doa encoding presented in @sec:ssl:multi_source:method:doa_repr presents several advantages.
Namely, thanks to its flexibility, it allows for the representation of a variable number of sources.
Also, it enables the framing of the multi-source #acr("SSL") problem as a simple regression task.
However, to extract the set of actual #doa values, one has to explicitly process the obtained spatial spectra.
This is achieved by detecting the peaks in the network output.
The index of local maxima higher than a threshold #xi-doa serve as the #doa predictions:
$
  hat(y) (hat(o), #xi-doa) = {
    phi.alt_i:
    // heat threshold
    colMath(hat(o)_i > xi, #maroon)
    "and"
    // Local maximum
    colMath(
      hat(o)_i = max_(
      j in [|1, d|],\
      d(
        phi.alt_i, phi.alt_j
      ) < sigma_n
      ) hat(o)_j,
      #olive
    ),
    #h(2em)
    i in [|1, d|]
  }.
$ <eq:ssl:multi_source:decoding_unknown_sources>
For this process to succeed, the neighborhood threshold $colMath(sigma_n, #olive)$ must be defined carefully.
If too low, some high-frequency noise in the spatial spectrum could lead to several false-positive angle detections.
On the other hand, a large value of $sigma_n$ might cause two close peaks to be wrongly identified as a single one, thus missing a positive detection.
We have found $sigma_n = 8 degree$ to be a satisfying value.

#block(breakable: false)[
  When the number $colMath(z, #eastern)$ of active sources is known, @eq:ssl:multi_source:decoding_unknown_sources can be adapted as:
  $
    hat(y) (hat(o); colMath(z, #eastern)) = {
      phi.alt_i:
      "among the" colMath(z, #eastern) "greatest"
      colMath(
        hat(o)_i = max_(
        j in [|1, d|],\
        d(
          phi.alt_i, phi.alt_j
        ) < sigma_n
        )
        hat(o)_j,
        #olive
      )
      // heat threshold
      ,
      #h(2em)
      i in [|1, d|]
    }.
  $
  <eq:ssl:multi_source:decoding_known_sources>
  The $colMath(z, #eastern)$ highest peaks are used as the predicted angles.
]

==== Neural Network Architecture

The implemented neural network for multi-source localization is inspired by the one proposed by He et al. @he_neural_2021.
It aims to process multi-channel audio data and extract the angular positions of the speech sources.
The model's input is the multi-channel signal's #acr("STFT") representation.
The #acr("STFT") of a signal is a complex-valued matrix of size $F times T$.
We then split the real and imaginary values to form two distinct matrices.
Each one of the $M$ microphones leads to a #shape(2, "F", "T")-shape real-valued tensor.
Its shape is noted #shape("C", "F", "T"), where $C$ is the number of channels, i.e., twice the number of microphones in the array.

The architecture draws inspiration from vision models by employing 2D convolution.
As discussed in @sec:ssl:background:deep_learning, using the image-like time-frequency representation of audio signals allows applying techniques proven to perform well on conventional image data.
@fig:ssl:multi_source:network_architecture depicts the proposed network architecture and details the inner layout of the convolutional and residual building blocks.

#figure(
  image(
    "figures/ssl_multisource_nn_architecture.svg",
    height: 100%,
  ),
  caption: [
    Deep neural network architecture for multi-source SSL.
  ],
)
<fig:ssl:multi_source:network_architecture>
