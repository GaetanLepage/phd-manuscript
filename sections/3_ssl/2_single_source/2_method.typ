#import "/utils.typ": *

=== Method


==== Custom dataset for #acr("SSL")
<sec:ssl:single_source:method:dataset>

The objective of this study was to adapt State of the Art #acr("SSL") methods to diverse challenging setups.
The capable simulator presented in @chap:simulator has let us put up different datasets to experiment with.
The speech source present in the room is considered to be omnidirectional and simulated as such.
#draft[
  Should we already warn about the limitations of this choice ? i.e. not very realistic
]

#draft[
  Mention that both source and microphones can be anywhere in the room.
  Many papers restrict those much more (fixed mic. array, sources in a circle...)
]



// Each training sample is a one second long audio recorded by the microphone array in the presence of a speech source.
// The latter is also randomly situated in the room.
// The label consists of the angle (Direction of Arrival, DOA) and the distance to the source.
// The network is trained to infer the location of the speech source solely from the audio signal it perceives.
// The sound source localization task stands as one of the core problems of the signal processing community.
// Numerous deep learning based approaches have been used to tackle this challenge.
// % TODO cite SSL study of Laurent
// In the context of this work, by obtaining reasonable performance on this supervised task ensures that the chosen convolutional backbone is able to extract spatial cues from the audio signal.


==== Microphone arrays
<sec:ssl:single_source:method:mic_arrays>

#gaet[
  Do we move this in the global "acoustic" chapter/section ?
]

Several microphone arrays have been experimented in this study.
Leveraging multiple microphones forming an array is essential.
Geometric information is extracted from the differences between the signals received by each sensor.
Acoustic reverberation and the spatial configuration of the array lead to the apparition of exploitable patterns in the overall collected data.

We present the following microphone array configurations that have been tested.
Their implementation enriches the possibilities provided by our simulator.

- A *binaural* array comprises two microphones placed a few centimeters apart from each other.
 This setup certainly constitutes the most studied robotic #acr("SSL") framework in the literature.
 A humanoid robotic head equipped with two microphones on each side has been the motivation to primarily consider this layout.
- We have also proposed a *three microphone* design disposed in a V-shaped arrangement.
- Finally, a *square* array of four microphones has been implemented too.

// TODO figure wih the three possible arrays

The number of microphones plays an important role in the #("SSL") performance.
As an illustrative example, when having a binaural microphone in the free field, i.e. where the effects of reverberation can be neglected, there exist a fundamental limit:
It is theoretically impossible to distinguish the two possible locations of the source.
This phenomenon is known as the front-back ambiguity.
// TODO cite papers
The latter can be cleared up by introducing relative movement or by introducing an additional microphone in the array.



// Binaural
// Triangle
// Square

Importantly, all our microphone arrays are deprived from any physical incarnation.
No real material constitutes the actual array.
In a more realistic setup, the presence of a robotic head between two microphones can be modeled using a #acr("HRTF").


// Number of microphones
// Directionality / Pattern
The _polar pattern_ of each microphone also stands out as an important characteristic of the array.
This property describes which incoming capture directions will be favored by the sensor.
Each use of a microphone can benefit from an appropriate directionality.
For instance, when recording the voice of a singer or speaker, one can afford to point the receiver towards the source and have it ignoring the unwanted sounds coming from other directions.

The _omnidirectional_ pattern is the simpler one to think of.
All directions are given equal importance.
In contrast, the cardioid, and its variants (super-cardioid, hyper-cardioid, ultra-cardioid, ...)
// TODO cardioid, supercardioid, figure 8
// TODO: insert figure of different patterns
#figure(
  image("figures/polar_patterns.jpg", height: 8cm),
  caption: [
    Illustration of the most common microphone polar patterns @stoddart_beginners_2016
  ],
) <fig:ssl:single_source:polar_patterns>

// TODO: is this the right term ?
In the context of #acr("SSL"), an non-homogeneous pattern brings extra angular information which a neural network might be able to exploit.
We have thus tested different configurations in our single-source #acr("SSL") experiments


==== Audio post-processing
<sec:ssl:single_source:method:audio_processing>


==== Neural Network Architecture

As demonstrated in @sec:ssl:sota:deep_learning, deep neural networks have shown to be flexible and effective as building blocks for an #acr("SSL") solution.
We focused in this work on a simple architecture that takes some representation of the listened audio signal as its only input.
At the other end, this network is trained to infer the #acr("DoA") value $theta$ and optionally the distance $D$ from the the single speech source present in the room.

Our model is trained in a supervised fashion using some custom datasets presented in @sec:ssl:single_source:method:dataset.

#gaet[
  Should we say that the impact of the architecture (Relu vs ReLU+BN vs BN+ReLU vs ReLU+LN LN+ReLU) is laughingly HIGH ?
]

The architecture, depicted in @fig:ssl:single_source:nn_architecture, consists in three convolutional blocks.
Each of them encompasses a 2D convolution operator, layer normalization and finally a #acr("ReLU").
The convolutional filters operate in the time-frequency plane.
The dimension of the multi-channel image progressively shrinks along the network.
Ultimately, the data gets flatten into a one-dimensional vector fed into a 4-layers #acr("MLP").
The number of output neurons can be configured depending on the necessity to predict only the #acr("DoA") value or both #acr("DoA") and source-array distance.

*Architecture impact.*
Our model architecture has been explicitly designed for the present use case.
Literature on #acr("SSL") and more broadly computer vision has motivated the structure of this reasonably standard network.
However, several variations have been regarding the layout of the convolutional blocks.
Although performance in _easy_ tasks were not significantly impacted by those changes, they have turned out to be crucial for achieving satisfying results in more complex settings.

#figure(
  image("figures/ssl_singlesource_nn_architecture.svg"),
  caption: [
    Simple convolutional architecture for #acr("SSL")
  ],
) <fig:ssl:single_source:nn_architecture>

// TODO: figure of the architecture

==== Loss function
<sec:ssl:single_source:method:loss>

This task of single-source #acr("SSL") boils down to a one-dimensional regression problem.
The neural network comprises a single output neuron $hat(theta)$ expected to estimate the true value of $theta$.
We will now present the loss function used during training.

*Angular distance.*
First, consider the following symmetric angular pseudo-distance.
Let $theta_1, theta_2 in RR$ two angle values expressed in radians.
#let d-color = rgb(31,119,180)
#let d = $colMath(d, #d-color)$
#let l-color = rgb(255,127,14)
$
  #d: #h(1cm) RR^2 & -->               RR_+\
  (theta_1, theta_2)        & arrow.r.long.bar 
    lr(
      mabs(
        pi - lr(
          mabs(
            mabs(theta_2 - theta_1)
            - pi
          )
        )
      )
    )
$
<eq:ssl:single_source:angle_dist>

#d is represented in blue in @fig:ssl:single_source:angular_dist_plot.

On the $[-2pi, 2pi]$ interval, #d behaves like the conventional angular periodic distance.
However, for values of $abs(theta_2 - theta_1) > 2pi$, the distance diverges to $+infinity$.
The natural choice would have been to wrap #d in $[0, pi]$ by choosing:
$
  d(theta_1, theta_2) =
    pi
    - lr(mabs(
        mabs(theta_2 - theta_1)colMath([2pi], #olive)
        - pi
      )
    ).
$
Conversely, this pseudo-distance discourages the network from predicting high magnitudes values of $theta$ even though they would satisfy $theta approx hat(theta)[2pi]$.
Empirically, this choice has shown no effect on neither the training process nor the final results.

// TODO REMOVE
// #draft[
//   We have to properly discuss about the angle distances.
//   This one goes to $+infinity$ when $abs(theta_2-theta_1) -> + infinity$.
//   It has the benefit of taking into account the wrap at $abs(theta_2-theta_1) = plus.minus pi$ and $plus.minus 2 pi$, but diverges to enforce that the network predict angles $>> 2pi$
//   $
//     #d: #h(1cm) RR^2 & -->               RR_+\
//     (theta_1, theta_2)        & arrow.r.long.bar  pi - lr(abs(abs(theta_2 - theta_1) - pi))
//   $
//   $
//     #d: #h(1cm) RR^2 & -->               [0, pi]\
//     (theta_1, theta_2)        & arrow.r.long.bar  pi - lr(abs(abs(theta_2 - theta_1)[2pi] - pi))
//   $
// ]
// 
// 
// #draft[
//   *The following should be removed:*
//   #block(breakable: false)[
//     The angular distance, defined as such, yields values wrapped in the $[-pi, pi]$ interval.
//     
//     Also, one should note that $d$ is antisymmetric, i.e. $forall (theta_1, theta_2) in RR^2$,
//     $
//       d(theta_1, theta_2) = -d(theta_2, theta_1)
//     $
//   ]
// ]

*Loss function.*
Let $hat(theta) = (hat(theta)_1, dots, hat(theta)_n)$ be the set of #acr("DoA") angles predicted by the network and $theta = (theta_1, dots, theta_n)$ the corresponding ground truth values.
The loss function expresses as
#let l-doa = $colMath(cal(L)_"DoA", #l-color)$
$
  #l-doa (
    hat(theta), theta
  ) = 1 / n
    sum_(i=1)^n
    d(hat(theta)_i, theta_i) ^ 2. // TODO should their be a period here ?
$
@fig:ssl:single_source:angular_dist_plot plots the value of #l-doa with respect to the value of $theta_2 - theta_1$.

#figure(
  image("figures/angular_dist_loss.svg"),
  caption: flex-caption( [
    Plot of the angular pseudo-distance $colMath(d(theta_1, theta_2), #d-color)$
    and the angular $cal(l)^2$ loss $colMath(d(theta_1, theta_2)^2, #l-color)$
    against $theta_2 - theta_1$
  ],
  [
    Plot of the angular pseudo-distance
    and the angular $cal(l)^2$ loss
  ])
)
<fig:ssl:single_source:angular_dist_plot>


The neural network is trained to minimize this objective.

When the model additionally estimates the distance to the source, the natural #acr("MSE") loss is used to supervised the relevant output neuron:
#let l-dist = $colMath(cal(L)_"dist", #maroon)$
$
   #l-dist (hat(d), d) =
    1 / n
    sum_(i=1)^n
  norm(hat(D)_i - D_i)_2^2
$ <eq:ssl:single_source:dist_loss>
where $D = (D_1, dots, D_n)$ is the set of predicted distances and $hat(D) = (hat(D)_1, dots, hat(D)_n)$ the ground truth data.

#block(breakable: false)[
  The total loss then becomes
  $
    cal(L)
     =
    #l-doa (hat(theta), theta)
    + #l-dist (hat(D), D).
  $
  <eq:ssl:single_source:total_loss>
]