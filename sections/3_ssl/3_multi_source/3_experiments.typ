#import "/utils.typ": *

=== Method

==== Microphone array <sec:ssl:multi_source:mic_array>

For this investigation, a four microphone array is used.
The sensors form a square TODO
#gaet[
  Is a scheme of the array necessary here ?
  According to me, it would not help a lot with understanding.
]

==== Dataset generation and pre-processing

#gaet[
  "4-microphone array", "four-microphone array" or "four microphone array" ?
]

The audio simulator presented in @chap:simulator has been leveraged to generate synthetic datasets of a substantial size.
Although public #acr("SSL") datasets have been shared publicly by the community, we have chosen to work within our artificial #acr("HRI") environment for later reuse of this method.
For the sake of exhaustivity, here are some examples of other relevant datasets.
He et al. @he_deep_2018 have proposed the #acr("SSLR") dataset using the Pepper robot equipped with a four-microphone array.
Furthermore, the third task of the #acr("DCASE") challenge proposes a yearly competition around designing the best #acr("SSL") system.
For the 2024 edition of #acr("DCASE"), the target dataset was STARSS23 @shimada_starss23_nodate, introduced at the NeurIPS 2023 conference.

The generation process starts by randomly selecting a number of sources between zero and four according to the following distribution:
- 0 sources: 20%,
- 1 source: 40%,
- 2 sources: 30%,
- 3 sources: 5%,
- 4 sources: 5%.
#gaet[
  How do we motivate this choice ? By simply saying that we did the same as in the paper ?
]

The microphone array described in @sec:ssl:multi_source:mic_array and the speech sources get randomly positioned in the room.
Such a choice has lead to challenging samples were multiple targets share very similar #acr("DoA") angles from the agent's point of view. #gaet[is this the right word ?]
The resulting #acr("RIR") filters get computed to account for the reverberation properties of the room.
Then, each source outputs a clean speech signal randomly chosen from the LibriSpeech @noauthor_librispeech_nodate dataset.
The simulator computes the resulting listened signals at each microphone of the array.
Such signals last around 10 seconds.

*Sampling frequency.*
The method was designed to operate with audio signals sampled at 48kHz, which does not match the 16kHz sample rate of the LibriSpeech @noauthor_librispeech_nodate dataset that provides the clean speech utterances to the simulator.
To account for this, the simulation of the audio signaled listened by each microphone of the array is operated at the native 16kHz frequency.
The generated signals are then up-sampled to 48kHz.

*#acr("STFT") representation of audio signals.*
// multi-channel STFT
As discussed in @sec:ssl:sota:data_repr, several choices can be made when it comes to data representation.
Although we have generated different datasets, the format used in majority consisted in the Short Term Fourier Transform.
The #acr("STFT") is thus computed from the complete up-sampled simulated signal listened by each of the four microphones. #gaet[TODO: check the plurality of this last sentence.]
For this, we employ a Hann window of length 2048, with a 50% overlap. We also apply a band-pass filtering by removing frequencies lower than 100Hz and higher than 48kHz.
The consequent #acr("STFT") counts 337 frequency bins.


*Audio chunking.*
We finally extract at most five short chunks of 400ms (i.e. 16 frames) from the global #acr("STFT")s.
This duration constitutes a tradeoff between detection latency and performance.
The longest the method is offered to listen, the better more accurate the results will be.
However, in a dynamic robotics context, which we ultimately target, we cannot afford having long audio sequences for inferring the source positions.

#gaet[
  I definitely have to double check this with Laurent.
  But at least, this is how I have implemented it.
]
*Minimal energy criteria.*
We aim at preventing the inclusion of samples were one of the target sources is not active enough for the duration of the recording.\
Given its #acr("STFT") $S in CC^(T times F)$, the energy of a real-valued signal, expressed in decibels (dB), is defined as
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
- $colMath(S_k, #olive)$ the #acr("STFT") of the signal received by microphone $k$.
- $colMath(tilde(S)_k, #maroon)$ the #acr("STFT") of the considered chunk, i.e. a slice of $S_k$.
The energy criteria defining a valid sample expresses as
$
  delta_"energy" = limits(and)_(k=1)^4
  [
    E(colMath(tilde(S)_k, #maroon))_"dB" 
    > E(colMath(S_k, #olive))_"dB"
      - 10]
$
The average energy of a given chunk can be at most 10dB lower than the one of the entire signal.
In practice, around 40% of the generated chunks are rejected.

#gaet[Maybe a scheme of this process could bring additional clarity.]

The #acr("STFT") of each multi-channel 400ms segment provides the final training samples of the dataset.
Besides each input sample, the relevant ground truth information gets saved for supervising the learning process and computing performance metrics.
It comprises all the necessary geometric information about the microphone array and sources (positions, orientations, relative distance and angle of incidence).
One million of such sample pairs constitute the core training data set.
The total audio duration of the data approximates 47 hours.


==== Direction of Arrival representation

The objective of the #acr("SSL") task is to predict the Direction of Arrival (DOA) of the sound sources.
Hence, the number of prediction outputted by an #acr("SSL") method can differ from situation to situation.
We therefore decided to use a representation of this information that is agnostic to the number of sources.
Having such a property is of great interest when training a Deep Neural Network.
The latter can then have a fixed output while still being able to handle a various number of sources.
The latter will be further denoted $n_s$.\
The set of DOA values will noted $Theta = (theta_1, ..., theta_n_s)$.

==== Angular heat maps

The solution in question has been introduced by He et al. @he_deep_2018 and consists in a discretized heat map defined over the interval $[-pi, pi]$.
In practice, the source locations is encoded in a $d$ dimensional real vector $Phi$.
$ Phi in [0, 1]^d $

We denote $alpha(i)$ the angle value corresponding to the $i$-th index of $Phi$.
$
  alpha : bracket.l.double 1, d bracket.r.double & arrow.r [-pi, pi] \
   i & |-> alpha(i)
$
We naturally have 
- $alpha(1) = - pi$
- $alpha(floor(d/2)) tilde.eq 0$
- $alpha(d) = pi$
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
We need to convert this list of scalar angular values to our heat map encoding format.
Numerous methods could be employed to achieve this.
A first solution to this problem could be placing a pseudo Dirac at the exact location of the source:

// TODO: introduce Theta being the vector of DOA angles
// TODO: introduce o(i)

$
  Phi(Theta)_i = sum_(k=1)^n_s bb(1)_(alpha(i) = theta_k)
$

$
  Phi(Theta)_i := cases(
    1 #h(1cm) &"if" exists theta in Theta | alpha(i) = theta,
    0 &"otherwise"
  )
$

// TODO: insert figure for this case

This approach can be enhanced to allow for a more consistent regression target.

$
  Phi(Theta)_i = cases(
    display(max_(theta in Theta))
      {
        e^(
          -d(
            alpha(i),
            theta
          )
          / sigma^2
        )
      } &"if" abs(Theta) > 0,
    0 &"otherwise"
  )
$ <eq:ssl:multi_source:doa_encoding>

The result is a mixture of $abs(Theta)$ gaussians centered at the actual #acr("DoA") angles.
We chosen to set $sigma = 5°$.
@fig:ssl:multi_source:doa_gt_encoding shows an example of the DOA encoding scheme for a situation with two sources.


#figure(
  image("figures/doa_encoding.svg"),
  caption: [DOA encoding of two sources]
) <fig:ssl:multi_source:doa_gt_encoding>

#gaet[
  Should we plot it with discrete points (scatter) instead of continuous lines ? It would be more relatable to the given definition.
]



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

==== Normalization

Various schemes of normalization have been used in Deep Neural Networks.
They address the phenomenon of _internal covariate shift_ which appears as architectures get deeper.
This problem comes from the distribution of each layer's inputs changing during training.
Such a drift causes the non-linear activation functions to saturate and harms the learning process.
Normalization also attempts at reducing the effects of mismatch between the training and test data set distributions.

_Batch Normalization_, proposed by Ioffe et al. in @ioffe_batch_2015 has gathered significant success, especially in the computer vision community.
It consists in normalizing each mini-batch input with respect to its own statistics.
Acting as a form of regularizer, this process stabilizes learning by ensuring that the values entering all layers do not deviate too significantly.
The data will get distributed according to a standard normal distribution.
The _Batch Normalization Transform_ algorithm expresses as such:
$
  y_i = colMath(gamma, #blue) [
    (
      x_i
      - colMath(mu_cal(B), #maroon)
    )
    /sqrt(
      colMath(sigma_cal(B)^2, #olive) + epsilon
    )
  ] + colMath(beta, #blue)
$ <eq:ssl:multi_source:batch_norm>
where
- $x_i$ is an individual entry in the mini-batch $cal(B) = {x_1, dots, x_m}$,
- $colMath(mu_cal(B) = 1 / m sum_(i=1)^m x_i, #maroon)$ is the mini-batch mean,
- $colMath(sigma_cal(B)^2 = 1 / m sum_(i=1)^m (x_i - mu_cal(B))^2, #olive)$ is the mini-batch variance,
- $epsilon$ is a constant ensuring numerical stability,
- $colMath(gamma, #blue)$ and $colMath(beta, #blue)$ are learnable parameters.

To be able to perform inference on single samples, i.e. without disposing of an entire mini-batch, substitution statistics are used in place of $colMath(mu_cal(B), #maroon)$ and $colMath(sigma_cal(B)^2, #olive)$.
Indeed, during training, the Batch Normalization layer will keep updating a running mean and variance to be used at evaluation time.

_Layer Normalization_ (Ba et al. @ba_layer_2016) follows the same principle but chooses to normalize each sample individually by computing statistics across the features dimensions.
@fig:ssl:multi_source:normalization displays the differences of both schemes.
Historically, Layer Normalization has been most commonly employed within the Natural Language Processing field.

$
  y_(l, i) = colMath(gamma, #blue) [
    (
      x_(l, i)
      - colMath(mu_l, #maroon)
    )
    /sqrt(
      colMath(sigma_l^2, #olive) + epsilon
    )
  ] + colMath(beta, #blue)
$ <eq:ssl:multi_source:batch_norm>
where
- $x_(l, i)$ is an individual hidden unit in the $l$-th layer's inputs $X = {x_(l, 1), dots, x_(l, H)}$,
- $colMath(mu_l = 1 / H sum_(i=1)^H x_(l, i), #maroon)$ is the mean,
- $colMath(sigma_l^2 = 1 / H sum_(i=1)^H (x_(l, i) - mu_l)^2, #olive)$ is the variance,
- $epsilon$ is a constant ensuring numerical stability,
- $colMath(gamma, #blue)$ and $colMath(beta, #blue)$ are learnable parameters.

#figure(
  image("./figures/normalization.png", height: 4cm),
  caption: [
    A visual comparison of Batch and Layer normalizations
    (adapted from @wu_group_2018)
  ]
) <fig:ssl:multi_source:normalization>

Those two methods have been proven to be effective in the training deep neural network architectures.

Although He et al. chose to use Batch Normalization in their work, our final architecture makes use of the more flexible Layer Normalization.
The choice of the normalization scheme ended up being crucial to achieving good performance.
We observed that the latter was yielding the same stabilization benefits during training while removing the dependence on the batch size.

#gaet[
  Basically, there are two parts in the "Normalization" discussion:
  - SotA/Methodology, described above
  - My results with plots and numbers.
-> Should I split this across two distinct paragraphs (i.e. put another one in the )
]

==== Two stage training

// TODO: doesn't seem to work well...
#gaet[
  As we have not seriously tried it and anyway haven't obtained any significant results, maybe we should entirely omit 2-stage training.
]

==== Training strategy <sec:ssl:multi_source:method:training_strategy>

*Loss function.*
The objective used by He et al. in @he_deep_2018 along their #acr("DoA") encoding is a simple #acr("MSE") loss between the ground truth #acr("DoA") representation and the output vector provided by the neural network:
$
  cal(L) (hat(y), y) = norm(hat(y) - y)_2^2
$ <eq:ssl:multi_source:loss_function>

// Batch size
@keskar_large-batch_2017


=== Experiments and results

// QUESTION: Should we mention the experiments made on the ILD/IPD binaural setup ?

==== Metrics

To evaluate the performance of our method

// Parallel with vision detection classes

// Known sources (MAE, Acc)
// TODO: check notation consistency
#gaet[Not sure if $sum_(i=1)^n$ or $limits(sum)_(i=1)^n$ is better here.]
#chris[the first, but do not bother too much with such details, just go on]
$ "MAE" = (
  limits(sum)_i
  limits(sum)_(j=1)^(z_i)
  d(
    hat(phi.alt)_(i j),
    phi.alt_(i j)
  )
)/(
  limits(sum)_i z_i
) $ <eq:ssl:ms:mae>

$ "ACC" = (
  limits(sum)_i
  limits(sum)_(j=1)^(z_i)
  bb(1)_(
    d(
      hat(phi.alt)_(i j),
      phi.alt_(i j)
    ) < E_a
  )
)/(
  limits(sum)_i z_i
) $ <eq:ssl:ms:acc>

// Unknown sources (Prec, Recall)
$ "Precision" = (
  limits(sum)_i
  limits(sum)_(j=1)^(z_i)
  limits(sum)_(k=1)^(hat(z)_i)
  m(
    hat(phi.alt)_(i k),
    phi.alt_(i j)
  )
)/(
  limits(sum)_i hat(z)_i
) $ <eq:ssl:ms:prec>

$ "Recall" = (
  limits(sum)_i
  limits(sum)_(j=1)^(z_i)
  limits(sum)_(k=1)^(hat(z)_i)
  m(
    hat(phi.alt)_(i k),
    phi.alt_(i j)
  )
)/(
  limits(sum)_i z_i
) $ <eq:ssl:ms:recall>



// TODO: we can not really compare with them as they evaluated on real data.

==== Performance evaluation

==== $epsilon$-loss

We propose an original modification of the loss function.
The motivation comes from the observation that the target #acr("DoA") heat map is sparse.
As seen in @sec:ssl:multi_source:method:training_strategy, we use a simple #acr("MSE") loss (@eq:ssl:multi_source:loss_function) for the cost function.

We have made an attempt at adjusting the latter to more aggressively penalize the sections of the #acr("DoA") heat maps where sources are actually present.

$
  cal(L)_epsilon (hat(y)_i, y_i) =
    1/d sum_(i=1)^d
    colMath((y_i + epsilon), #maroon)
    (hat(y)_i - y_i)^2
$ <eq:ssl:multi_source:epsilon_loss>

#gaet[Should we do a plot to show the multiplicative factor across the DoA spectrum ?]

//TODO: add the results (ablation study)

==== Limitations

#draft[
  - Performance is far from being perfect (SotA)
  - No noise handling
]

==== Sequence processing

In order to overcome the weaknesses of our model, we have proposed to use our method on longer recordings.
Like so, we are able to account for the missed detections and achieve a higher robustness in the detections.

The main idea resides in splitting the longer input audio in $M$ chunks sized appropriately to be processed by the neural network.
$M$ output #acr("DoA") heat maps are thus obtained and need to be aggregated.
We simply average those signals to obtain a single vector:
$
  hat(o) = 1/M sum_(i=1)^M o_i #h(1em) in [0, 1]^d
$ <eq:ssl:multi_source:sequence_averaging>

The flexibility of the #acr("DoA") encoding permits the former combination without the need of additional steps.
Our detection algorithm can

#draft[Impact of window length]
// TODO: insert table of results