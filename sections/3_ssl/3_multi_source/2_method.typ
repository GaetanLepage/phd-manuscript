#import "/utils.typ": *

=== Method

==== Microphone array <sec:ssl:multi_source:mic_array>

For this investigation, a four microphone array is used.
The sensors form a square TODO
#gaet[
  Is a scheme of the array necessary here ?
  According to me, it would not help a lot with understanding.
]

==== Dataset generation and pre-processing <sec:ssl:multi_source:method:dataset>

#gaet[
  "4-microphone array", "four-microphone array" or "four microphone array" ?
]

The audio simulator presented in @chap:simulator has been leveraged to generate synthetic datasets of a substantial size.
Although public #acr("SSL") datasets have been shared publicly by the community, we have chosen to work within our artificial #acr("HRI") environment for later reuse of this method.
For the sake of exhaustivity, here are some examples of other relevant datasets.
He et al. @he_deep_2018 have proposed the #acr("SSLR") dataset using the Pepper robot equipped with a four-microphone array.
Furthermore, the third task of the #acr("DCASE") challenge proposes a yearly competition around designing the best #acr("SSL") system.
For the 2024 edition of #acr("DCASE"), the target dataset was STARSS23 @shimada_starss23_nodate, introduced at the NeurIPS 2023 conference.

#gaet[An important difference with the source paper is that I always use the same room ($T_60$, size, ...)]

The microphone array described in @sec:ssl:multi_source:mic_array, comprising $n_m=4$, sensors and $n_s$ speech sources get randomly positioned in the room.
Such a choice has lead to challenging samples were multiple targets share very similar #acr("DoA") angles from the agent's point of view. #gaet[is this the right word ?]
The resulting #acr("RIR") filters get computed to account for the reverberation properties of the room.
Then, each source outputs a clean speech signal randomly chosen from the LibriSpeech @noauthor_librispeech_nodate dataset.
The simulator computes the resulting listened signals at each microphone of the array.
Such signals last around 10 seconds.

#gaet[
  Should we talk about train/val/test splits ? This could also be put in the "training" paragraph of the "method"
]

*Source-wise simulation and late mixing.*
In practice, the sources are not placed simultaneously in the room.
Instead, they only get enabled individually to perform $n_s$ distinct single-source simulations.
This offers more possibilities as explained below.

First, let us start from leveraging the following property.
The signal $s_k$ recorded by the $k$-th microphone expresses simply as the sum of the signals $s_(i, k)$ providing from each source:
#gaet[Laurent, should we adopt discrete or continuous notation here ($s_k (t)$ or $s_k [t]$) ?]
$
  s_k [t] = sum_(i=1)^n_s s_(i,k)[t]
$
where $s_(i, k)$ denotes the signal coming from the $i$-th source as received by microphone $k$.
The #acr("STFT") being a linear operator, this equality holds in the feature space:
$
  S_k [t, f] = sum_(i=1)^n S_(i, k)[t, f]
$
where $S_k$ and $S_(i, k)$ are the #acr("STFT") of respectively $s_k$ and $s_(i, k)$.
Hence, instead of saving the final features $S = (S_1, dots, S_(n_m))$, we save each source-specific encoding $S_i = (S_(i, 1), dots, S_(i, n_m))$ individually.

This overhead brings complexity to the data collection process but allows for a significant increase in flexibility.
Indeed, the number of sources plays a great role in performance and quantifying this influence has required experimenting with this parameter.
Disposing of the audio features relating to each individual source allows for choosing how many sources should be active when loading each data sample from the disk.
One solely has to sample a set ${i_1, i_2, dots, i_n}$ of sources to enable and sum the relevant source-specific features $S_i_1, dots, S_i_n$.
The impact of the number of active sources is further studied in @sec:ssl:multi_source:experiments:number_of_sources.


*Sampling frequency.*
The method was designed to operate with audio signals sampled at 48kHz, which does not match the 16kHz sample rate of the LibriSpeech @noauthor_librispeech_nodate dataset that provides the clean speech utterances to the simulator.
To account for this, the simulation of the audio signaled listened by each microphone of the array is operated at the native 16kHz frequency.
The generated signals are then up-sampled to 48kHz.


*#acr("STFT") representation of audio signals.*
// multi-channel STFT
As discussed in @sec:ssl:sota:data_repr, several choices can be made when it comes to data representation.
Although we have generated different datasets, the format used in majority consisted in the Short Term Fourier Transform.
The #acr("STFT") is thus computed from the complete up-sampled simulated signal captured by each of the four microphones.
For this, we employ a Hann window of length 2048, with a 50% overlap. We also apply a band-pass filtering by removing frequencies lower than 100Hz and higher than 48kHz.
The consequent #acr("STFT") counts 337 frequency bins.


*Audio chunking.*
We finally extract at most five short chunks of 400ms (i.e. 16 frames) from the global #acr("STFT")s.
This duration constitutes a tradeoff between detection latency and performance.
The longest the method is offered to listen, the better more accurate the results will be.
However, in a dynamic robotics context, which we ultimately target, we cannot afford having long audio sequences for inferring the source positions.

// TODO add the footnote
#let tau-e = $colMath(tau_E, #orange)$
#let global-spec = $colMath(S_k, #olive)$
#let chunk-spec = $colMath(tilde(S)_k, #maroon)$
*Minimal energy criteria.*
We aim at preventing the inclusion of samples were one of the target sources is not active enough for the duration of the recording.\
Given its #acr("STFT") $S in CC^(T times F)$, the average energy
#footnote[
  Strictly speaking, this quantity is homogeneous to a spectral energy density.
  We will further simply refer to it as _energy_ for the sake of clarity.
]
of a real-valued signal, expressed in decibels (dB), is defined as
$
  E(S)_"dB" =
    1 / (T F)
    sum_(t=1)^T
    sum_(f=1)^F
    20 log_10
    lr(abs(S[t, f]), size: #150%)
$
We reject the chunks of the simulated samples where, for at least one microphone, the energy of the selected fragment is too low compared to the average energy of the entire simulated signal.
Let
- #global-spec the #acr("STFT") of the signal received by microphone $k$.
- #chunk-spec the #acr("STFT") of the considered chunk, i.e. a slice of #global-spec.
The energy criteria $delta_"energy"$ defining a valid sample expresses as
$
  delta_"energy" (
    #tau-e
  ) = limits(and)_(k=1)^4
  [
    E(#chunk-spec)_"dB" 
    > E(#global-spec)_"dB"
      - #tau-e
  ]
$
where $colMath(tau_E, #orange)$ has been set to 10dB in our main dataset.
The average energy of a given chunk can be at most 10dB lower than the one of the entire signal.
In practice, around 40% of the generated chunks are rejected.

#gaet[
  - Maybe a scheme of this process could bring additional clarity.
  - We might want to acknowledge that a rejection rate of 40% is quite high.
]

The #acr("STFT") of each multi-channel 400ms segment provides the final training samples of the dataset.
Besides each input sample, the relevant ground truth information gets saved for supervising the learning process and computing performance metrics.
It comprises all the necessary geometric information about the microphone array and sources (positions, orientations, relative distance and angle of incidence).
One million of such sample pairs constitute the core training and test datasets (of 800k and 200k samples respectively).
The total audio duration of the data approximates 47 hours.


==== Direction of Arrival representation <sec:ssl:multi_source:method:doa_repr>

The objective of the #acr("SSL") task is to predict the Direction of Arrival (DOA) of the sound sources.
Hence, the number of prediction outputted by an #acr("SSL") method can differ from situation to situation.
We therefore decided to use a representation of this information that is agnostic to the number of sources.
Having such a property is of great interest when training a Deep Neural Network.
The latter can then have a fixed output while still being able to handle a various number of sources.
The latter will be further denoted $n_s$.\
The set of DOA values will noted $Theta = (theta_1, ..., theta_n_s)$.

==== Spatial spectrum

The solution in question has been introduced by He et al. @he_deep_2018 and consists in estimating the spatial spectrum.
The latter is a real-valued function of the #acr("DoA") ($cal(o): [-pi, pi] -> RR$).
We discretize this continuous function by encoding the spectra in a $d$ dimensional real vector $o$.
$ o in [0, 1]^d $

We denote $phi.alt_i$ the angle value corresponding to the $i$-th index of $o$.
$
  phi.alt : bracket.l.double 1, d bracket.r.double & arrow.r [-pi, pi] \
   i & |-> phi.alt_i
$
We naturally have 
- $phi.alt_1 = - pi$
- $phi.alt_(floor(d/2)) tilde.eq 0$
- $phi.alt_d = pi$
#chris[This is already visible from eq. 2. Or is this information very important?]
#gaet[This was to make it even clearer, but with some plots it could be enough.]


We choose $d = 360$ which corresponds to a $1°$ resolution.

Higher numerical values translate the presence of a source at this location.
// TODO not sure how to pluralize DoA
Those angles, being Directions of Arrival are relative to the microphone array's orientation.
A peak at $0°$ designates the presence of a source in front of the microphones.

// TODO: insert figure

==== Multi source #acr("DoA") encoding

The dataset contains the DOA values for each sample.
We need to convert this list of scalar angular values to our spatial spectrum encoding format in order to allow its use as a regression target.
Numerous methods could be employed to achieve this.
A first solution to this problem could be placing a pseudo Dirac at the exact location of the source:

// TODO: introduce Theta being the vector of DOA angles
// TODO: introduce o(i)

$
  o(Theta)_i = sum_(k=1)^n_s bb(1)_(phi.alt_i = theta_k)
$

$
  o(Theta)_i := cases(
    1 #h(1cm) &"if" exists theta in Theta | phi.alt_i = theta,
    0 &"otherwise"
  )
$

// TODO: insert figure for this case

This approach can be enhanced to allow for a more consistent regression target.

$
  o(Theta)_i = cases(
    display(max_(theta in Theta))
      {
        e^(
          -(colMath(d, #maroon)(
            phi.alt_i,
            theta
          )^2)
          / sigma^2
        )
      } &"if" abs(Theta) > 0,
    0 &"otherwise"
  )
$ <eq:ssl:multi_source:doa_encoding>,
where $colMath(d, #maroon)$ is the following symmetric angle distance,
$
  colMath(d, #maroon): [-pi, pi]^2 & --> [0, pi]\
  (theta_1, theta_2) & arrow.r.long.bar pi - lr(abs(abs(theta_2 - theta_1) - pi), size: #150%)
$ <eq:ssl:multi_source:symmetric_angular_dist>

The result is a mixture of $abs(Theta)$ gaussians centered at the actual #acr("DoA") angles.
We chose to set $sigma = 5°$.
@fig:ssl:multi_source:doa_gt_encoding shows an example of the DOA encoding scheme for a situation with two sources.


#figure(
  image("figures/doa_encoding.svg"),
  caption: [DOA encoding of two sources]
) <fig:ssl:multi_source:doa_gt_encoding>

#gaet[
  Should we plot it with discrete points (scatter) instead of continuous lines ? It would be more relatable to the given definition.
]

The main benefit of this format, alongside with its ability to encode an arbitrary number of sources, is to frame the #acr("SSL") problem as a simple regression task.


==== Neural Network architecture


#gaet[should we note tensor shapes (X, Y, Z) or XxYxZ ?]
The implemented neural network inspires from the one proposed by He et al. in @he_neural_2021.

The aim of the Neural Network is to process multi-channel audio data and to extract the angular positions of the speech sources.
The input of the model is the #acr("STFT") representation of the multi-channel signal.
The #acr("STFT") of a signal is a complex-valued matrix of size $F times T$.
We then split the real and imaginary values to form two distinct matrices.
Each one of the $M$ microphones leads to a $(2, F, T)$-shape real-valued tensor.
Its shape is noted $(C, F, T)$ where $C$ is the number of channels, i.e. twice the number of microphones in the array.

The architecture draws inspiration from vision models by employing 2D convolution.
As discussed in @sec:ssl:sota:deep_learning, using the image-like time-frequency representation of audio signals allows applying techniques proven to perform well on conventional image data.

#figure(
  square(size: 10em, stroke: 2pt),
  caption: [
    Deep neural network architecture for multi-source #acr("SSL")
  ],
) <fig:ssl:multi_source:network_architecture>


// As we have not seriously tried 2-stage training and anyway haven't obtained any significant results, maybe we should entirely omit 2-stage training.
// ==== Two stage training
// 
// Similarly to our single-source methodology, we train our deep neural network in a supervised fashion.
// 
// // TODO: doesn't seem to work well...



==== Detection decoding

The employed #acr("DoA") encoding presented in @sec:ssl:multi_source:method:doa_repr presents several advantages.
Namely, thanks to its flexibility, it allows for representing an arbitrary number of sources.
Also, it enables to formulate the multi-source #acr("SSL") problem as a simple regression task.
However, to extract of set of actual #acr("DoA") values, one has to explicitly process the obtained spatial spectra.
#gaet[Do we have to, once more, cite the Odobez paper here ?]
This is achieved by detecting the peaks in the network output.
The index of local maxima higher than a threshold $colMath(xi, #maroon)$ serve as the #acr("DoA") predictions:
$
  hat(y) (hat(o), colMath(xi, #maroon)) = {
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
      i in [|1, n|]
  }
$ <eq:ssl:multi_source:decoding_unknown_sources>
The neighborhood threshold $colMath(sigma_n, #olive)$ must be defined carefully for this process to succeed.
If too low, some high frequency noise in the spatial spectrum could lead to several false positive angle detections.
On the other hand, a too high value for $sigma_n$ might cause two close peaks to be wrongly identified as a single one, thus missing a positive detection.
We have found $sigma_n = 8°$ to be a satisfying value.

#gaet[
  Is it interesting to describe the local maximum extraction process ?
  According to me, there is obviously no novelty here (as for the entire section...), but it can eat up some space.
]

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
      i in [|1, n|]
  }
$ <eq:ssl:multi_source:decoding_known_sources>
The $colMath(z, #eastern)$ highest peaks are used as the predicted angles.

// #algorithm({
//   import algorithmic: *
//   Function(
//     "ExtractDetections",
//     args: ("H", $tau$),
//     {
//       Cmt[Compute the neighborhood]
//     }
//   )
// })

// TODO: add figure

// TODO: hyperparameters are important