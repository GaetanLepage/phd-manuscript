#import "/utils.typ": *

== Multi-source localization

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

@fig:ssl:doa_gt_encoding shows an example of the DOA encoding scheme for a situation with two sources.


#figure(
  image("./figures/doa_encoding.svg"),
  caption: [DOA encoding of two sources]
) <fig:ssl:doa_gt_encoding>


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

Although He et al. chose to use Batch Normalization in their work, our final architecture makes use of the more flexible Layer Normalization.

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