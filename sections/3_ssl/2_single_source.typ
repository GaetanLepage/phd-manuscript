#import "/utils.typ": *

== Single-source localization <sec:ssl:single_source>
#minitoc(indent: true)

=== Problem statement

A robotic agent is evolving in a reverberant room.
A single speech source is also present in the environment.
The task consists in determining the relative position a unique sound source.
Although the focus will be directed towards methods predicting solely the #acr("DoA"), solutions that also estimate the distance to the source have been evaluated.
// TODO add a figure to illustrate the DOA + distance, basically a scheme of the problem
#figure(
  square(size: 10em, stroke: 2pt),
  caption: [
    Illustration of the #acr("SSL") problem setting
  ],
) <fig:ssl:single_source:ssl_schema>

As seen in @sec:ssl:sota:ssl_in_robotics, multi-modal information can be leveraged to perform #acr("SSL") in a robotics context. // TODO: remove if we end up not talking about A/V SSL
However, in this chapter, we will focus on the exclusive use of audio information.
This choice is more representative of the classical formulation of the #acr("SSL") problem and although simpler to formulate constitutes a challenging task.

Furthermore, we expect to leverage our solution in active interaction scenarios of dynamic nature.
In a real-time context, we expect reduce the latency of our localization system to improve the responsiveness of the overall solution.
As a consequence, only a short recording should suffice to accomplish an accurate localization of the source.
// TODO Nature of the source


=== Method


==== Custom dataset for #acr("SSL") <sec:ssl:single_source:method:dataset>

The objective of this study was to adapt State of the Art #acr("SSL") methods to diverse challenging setups.
The capable simulator presented in <chap:simulator> has let us put up different datasets to experiment with.
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

The omnidirectional pattern is the simpler one to think of.
All directions are given equal importance.
// TODO cardioid, supercardioid, figure 8
// TODO: insert figure of different patterns

// TODO: is this the right term ?
In the context of #acr("SSL"), an non-homogeneous pattern brings extra angular information which a neural network might be able to exploit.
We have thus tested different configurations in our single-source #acr("SSL") experiments


==== Neural Network Architectures <sec:ssl:single_source:method:nn_architectures>

As demonstrated in @sec:ssl:sota:deep_learning, deep neural networks have shown to be flexible and effective as building blocks for an #acr("SSL") solution.
We focused in this work on simple architectures that take some representation of the listened audio signal as their only input.
On the other end, those networks are trained to infer the #acr("DoA") value $theta$ of the single speech source present in the room.

Our networks are trained in a supervised fashion using some custom datasets presented in @sec:ssl:single_source:method:dataset.

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

=== Experiments <sec:ssl:single_source:experiments>

==== Metrics

This task of single-source #acr("SSL") boils down to a one-dimensional regression problem.
The neural network comprises a single output neuron expected to estimate the value of $theta$.

We will now present the loss function used during training.\
First, consider the following angular distance.
Let $theta_1, theta_2 in RR$ two angle values expressed in radians.
$
d: #h(1cm) RR^2 &arrow.r.long [-pi, pi]\
 (theta_1, theta_2) &arrow.r.long.bar  (theta_1 - theta_2 + pi)[2pi] - pi
$ <eq:ssl:single_source:angle_dist>
The angular distance, defined as such, yields values wrapped in the $[-pi, pi]$ interval.

#block(breakable: false)[
  Also, one should note that $d$ is antisymmetric, i.e. $forall (theta_1, theta_2) in RR^2$,
  $
    d(theta_1, theta_2) = -d(theta_2, theta_1)
  $
]

#draft[
  Shouldn't we simply formulate the loss for a single sample and not bother with the summation over all elements of the dataset ?\
  Or maybe simply adding it at the end of the paragraph.
]

#draft[
$
  cal(L)_"DoA"(
    theta, hat(theta)
  ) =
  d(theta_i, hat(theta)_i) ^ 2.
$
]

Let $theta = (theta_1, dots, theta_n)$  be the set of #acr("DoA") angles predicted by the network and $hat(theta) = (hat(theta)_1, dots, hat(theta)_n)$ the corresponding ground truth values.
The loss function expresses as
$
  cal(L)_"DoA"(
    theta, hat(theta)
  ) = 1 / n
    sum_(i=1)^n
    d(theta_i, hat(theta)_i) ^ 2. // TODO should their be a period here ?
$ <eq:ssl:single_source:doa_loss>

The neural network is trained to minimize this objective.

When the model additionally estimates the distance to the source, the natural $l_2$ distance is used
$
  cal(L)_"dist" (d, hat(d)) = norm(d - hat(d))_2^2
$ <eq:ssl:single_source:dist_loss>
and the total loss then becomes
$
  cal(L) (
    (theta, hat(theta)), (d, hat(d))
  ) =
  cal(L)_"DoA" (theta, hat(theta))
  + cal(L)_"dist" (d, hat(d))
$ <eq:ssl:single_source:total_loss>
// $
//   cal(L) (
//     (d, hat(d)), (theta, hat(theta))
//   ) = 1 / n
//   sum_(i=1)^n
//   [
//     cal(L)_"DoA" (theta_i, hat(theta)_i)
//     + norm(d_i - hat(d)_i)_2^2
//   ]
// $
//where $d = (d_1, dots, d_n)$ is the set of predicted distances and $hat(d) = (hat(d)_1, dots, hat(d)_n)$ the ground truth data.

==== Impact of input signal representation

The the neural network is expected to extract the relevant localization information from the audio signal provided as input.
Hence, the choice of the encoding method for the acoustic data has a substantial impact on the difficulty of this task.

In this work, we focus on time-frequency representations.
// TODO: for STFT, we use |z| and Arg(z) as real tensors, not Re(z), Im(z)

// Compare ILD/IPD performances


==== Sound Source Localization in noisy environments

Having succeeded at accurately estimating the #acr("DoA") in a reverberant but noiseless setting, we have attempted to add noise sources.
The latter has revealed to harden the task significantly.
We have focused on noises of basic nature: white noise and music.
Both share the property of noticeably differing from a speech signal in its fundamental acoustic nature.
// Having a parasite speech

// Which kinds of noises


=== Conclusion

// Limitations: single source (i.e., not more than one BUT ALSO always at least one)