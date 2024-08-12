#import "/utils.typ": *

=== Method


==== Custom dataset for #acr("SSL") <sec:ssl:single_source:method:dataset>

The objective of this study was to adapt State of the Art #acr("SSL") methods to diverse challenging setups.
The capable simulator presented in @chap:simulator has let us put up different datasets to experiment with.
The speech source present in the room is considered to be omnidirectional and simulated as such.
#draft[
  Should we already warn about the limitations of this choice ? i.e. not very realistic
]



// Each training sample is a one second long audio recorded by the microphone array in the presence of a speech source.
// The latter is also randomly situated in the room.
// The label consists of the angle (Direction of Arrival, DOA) and the distance to the source.
// The network is trained to infer the location of the speech source solely from the audio signal it perceives.
// The sound source localization task stands as one of the core problems of the signal processing community.
// Numerous deep learning based approaches have been used to tackle this challenge.
// % TODO cite SSL study of Laurent
// In the context of this work, by obtaining reasonable performance on this supervised task ensures that the chosen convolutional backbone is able to extract spatial cues from the audio signal.


==== Microphone arrays <sec:ssl:single_source:method:mic_arrays>

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


==== Audio post-processing <sec:ssl:single_source:method:audio_processing>


==== Neural Network Architecture

As demonstrated in @sec:ssl:sota:deep_learning, deep neural networks have shown to be flexible and effective as building blocks for an #acr("SSL") solution.
We focused in this work on simple architectures that take some representation of the listened audio signal as their only input.
At the other end, those networks are trained to infer the #acr("DoA") value $theta$ of the single speech source present in the room.

Our networks are trained in a supervised fashion using some custom datasets presented in @sec:ssl:single_source:method:dataset.

#gaet[
  Should we present both architectures or focus on the one we used the most ?
]

// TODO: first simple architecture
#figure(
  square(size: 10em, stroke: 2pt),
  caption: [
    Simple convolutional architecture for #acr("SSL")
  ],
) <fig:ssl:single_source:ssl_nn_simple>

The second architecture draws inspiration from the work of @krause_comparison_2021.
It shares some similarities with the first architecture as being built around 2D convolution filters in the time-frequency plan.
The two-dimensional representations of audio signals have the sensible

#figure(
 square(size: 10em, stroke: 2pt),
  caption: [
    Simple convolutional architecture for #acr("SSL")
  ],
) <fig:ssl:single_source:ssl_nn_krause>

// TODO: figure of the architecture

==== Loss function <sec:ssl:single_source:method:loss>

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
$ <eq:ssl:single_source:angle_dist>

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
) <fig:ssl:single_source:angular_dist_plot>


The neural network is trained to minimize this objective.

When the model additionally estimates the distance to the source, the natural #acr("MSE") loss is used to supervised the relevant output neuron:
#let l-dist = $colMath(cal(L)_"dist", #maroon)$
$
   #l-dist (hat(d), d) =
    1 / n
    sum_(i=1)^n
  norm(hat(d)_i - d_i)_2^2
$ <eq:ssl:single_source:dist_loss>
where $d = (d_1, dots, d_n)$ is the set of predicted distances and $hat(d) = (hat(d)_1, dots, hat(d)_n)$ the ground truth data.

#block(breakable: false)[
  The total loss then becomes
  $
    cal(L)
    lr(
      (
        (hat(theta), theta), (hat(d), d)
      ),
      size: #130%
    ) =
    #l-doa (hat(theta), theta)
    + cal(L)_"dist" (hat(d), d).
  $ <eq:ssl:single_source:total_loss>
]






#gaet[
 Wouldn't the following be even easier to read (although less accurate)
  $
    cal(L) =
    cal(L)_"DoA" (hat(theta), theta)
    + cal(L)_"dist" (hat(d), d)
  $ <eq:ssl:single_source:dist_loss>

  or even
  $
    cal(L) (
      (d, hat(d)), (theta, hat(theta))
    ) = 1 / n
    sum_(i=1)^n
    [
      d(theta_i, hat(theta)_i)^2
      + norm(d_i - hat(d)_i)_2^2
    ]
  $
]

#gaet[
  Also, do we really need to say "when also predicting the distance".
  Maybe we can conduct all experiments predicting both the #acr("DoA") and distance.
]