#import "/utils.typ": *

== Multi-source localization

Complex human-robot interaction environments often imply a varying number of sound sources.
Hence, at a given time, the room might be completely silent.
On the other hand, multiple concurrent sources of different kinds could be active simultaneously.
The following section will present our investigation of a multi-source localization framework that will bring additional flexibility to our acoustic agent.
We will showcase a deep neural network that has been implemented and trained on a challenging customized dataset, collected thanks to our simulator.

// TODO, maybe do not talk about them this soon.
Weipeng He et al. have proposed and explored an interesting framework for multi-source localization.
// flexible

=== Microphone array

=== Data pre-processing

// multi-channel STFT
As discussed in @sec:ssl:sota:data_repr, several choices can be made when it comes to data representation.
Although we have generated different datasets, the format used in majority consisted in the Short Term Fourier Transform.


=== Direction of Arrival representation

The objective of the #acr("SSL") task is to predict the Direction of Arrival (DOA) of the sound sources.
Hence, the number of prediction outputted by an #acr("SSL") method can differ from situation to situation.
We therefore decided to use a representation of this information that is agnostic to the number of sources.
Having such a property is of great interest when training a Deep Neural Network.
The latter can then have a fixed output while still being able to handle a various number of sources.
The latter will be further denoted $n_s$.\
The set of DOA values will noted $Theta = (theta_1, ..., theta_n_s)$.

==== Angular heat maps

The solution in question has been introduced by He et al. @he_neural_2021 and consists in a discretized heat map defined over the interval $[-pi, pi]$.
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

==== Encoding of ground truth DOA values

The dataset contains the DOA values for each sample.
We need to convert this list of scalar angular values to our heat map encoding format.
There is not a unique w
A first solution to this problem could be placing a pseudo Dirac at the exact location of the source:

// TODO: introduce Theta being the vector of DOA angles
// TODO: introduce o(i)

$ Phi(Theta)_i = sum_(k=1)^n_s bb(1)_(alpha(i) = theta_k) $

$ Phi(Theta)_i := cases(
  1 #h(1cm) &"if" exists theta in Theta | alpha(i) = theta,
  0 &"otherwise"
) $

// TODO: insert figure for this case

This approach can be enhanced to allow for a more consistent regression target.

$
  Phi(Theta)_i = cases(
    display(max_(theta in Theta)) {e^(-d(alpha(i), theta)/ sigma^2)} &"if" abs(Theta) > 0,
    0 &"otherwise"
  )
$

> @fig:ssl:multi_source:doa_gt_encoding shows an example of the DOA encoding scheme for a situation with two sources.


#figure(
  image("./figures/doa_encoding.svg"),
  caption: [DOA encoding of two sources]
) <fig:ssl:multi_source:doa_gt_encoding>



=== Neural Network architecture


#gaet[should we note tensor shapes (X, Y, Z) or XxYxZ ?]
The implemented neural network is borrowed from He et al. @he_neural_2021.

The aim of the Neural Network is to process multi-channel audio data and to extract the angular positions of the speech sources.
The input of the model is the #acr("STFT") representation of the multi-channel signal.
The #acr("STFT") of a signal is a complex-valued matrix of size $F times T$.
We then split the real and imaginary values to form two distinct matrices.
Each one of the $M$ microphones leads to a $(2, F, T)$-shape real-valued tensor.
Its shape is noted $(C, F, T)$ where $C$ is the number of channels, i.e. twice the number of microphones in the array.

==== Multi source DOA encoding

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
- $x_i$ is an individual entry in the mini-batch $cal(B) = {x_1, dots, x_m}$
- $colMath(mu_cal(B) = 1 / m sum_(i=1)^m x_i, #maroon)$ is the mini-batch mean
- $colMath(sigma_cal(B)^2 = 1 / m sum_(i=1)^m (x_i - mu_cal(B))^2, #olive)$ is the mini-batch variance
- $epsilon$ is a constant ensuring numerical stability
- $colMath(gamma, #blue)$ and $colMath(beta, #blue)$ are learnable parameters

To be able to perform inference on single samples ()

_Layer Normalization_ follows the same principle but chooses to normalize each sample individually by computing statistics across the features dimensions.
@fig:ssl:multi_source:normalization displays the differences of both schemes.
Historically, Layer Normalization has been most commonly used within the Natural Language Processing field.
However,

#figure(
  image("./figures/normalization.png", height: 4cm),
  caption: [
    A visual comparison of Batch and Layer normalizations
    (adapted from @wu_group_2018)
  ]
) <fig:ssl:multi_source:normalization>

Although He et al. chose to use Batch Normalization in their work, our final architecture makes use of the more flexible Layer Normalization.
Those two methods have been proven to be effective in the training deep neural network architectures.

The choice of the normalization scheme ended up being crucial to achieving good performance.

==== Two stage training

// TODO: doesn't seem to work well...

== Experiments

// QUESTION: Should we mention the experiments made on the ILD/IPD binaural setup ?

=== Static Sound Source Localization

==== Metrics

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

=== Training strategy

// Batch size

=== Results

==== Performance evaluation

==== Limitations

==== Sequence processing

Impact of window length
// TODO: insert table of results