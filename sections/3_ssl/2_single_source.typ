#import "/utils.typ": *

== Single-source localization
#minitoc(indent: true)

=== Problem statement

A robotic agent is evolving in a reverberant room.
A single speech source is also present in the environment.
The task consists in determining the relative angle between the agent position and the speech source.
This value is referred as the #acr("DoA"). // TODO, this could be introduced in the SotA section
// Only angular localization
// TODO add a figure to illustrate the DOA.
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
// TODO: should we already warn about the limitations of this choice ? i.e. not very realistic


// Each training sample is a one second long audio recorded by the microphone array in the presence of a speech source.
// The latter is also randomly situated in the room.
// The label consists of the angle (Direction of Arrival, DOA) and the distance to the source.
// The network is trained to infer the location of the speech source solely from the audio signal it perceives.
// The sound source localization task stands as one of the core problems of the signal processing community.
// Numerous deep learning based approaches have been used to tackle this challenge.
// % TODO cite SSL study of Laurent
// In the context of this work, by obtaining reasonable performance on this supervised task ensures that the chosen convolutional backbone is able to extract spatial cues from the audio signal.


==== Microphone arrays <sec:ssl:single_source:method:mic_arrays>

// Binaural
// Triangle
// Square

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

The second architecture draws inspiration from the work of @krause_comparison_2021.
It shares some similarities with the first architecture as being built around 2D convolution filters in the time-frequency plan.
The two-dimensional representations of audio signals have the sensible

// TODO: figure of the architecture

=== Experiments <sec:ssl:single_source:experiments>

==== Metrics

This task of single-source #acr("SSL") boils down to a one-dimensional regression problem.
The neural network comprises a single output neuron expected to estimate the value of $theta$.

We will now present the loss function used during training.\
First, consider the following angular distance.
Let $theta_1, theta_2 in RR$ two angle values expressed in radians.
$
d:  RR^2 &arrow.r.long [-pi, pi]\
 (theta_1, theta_2) &arrow.r.long.bar  (theta_1 - theta_2 + pi)[2pi] - pi
$ <eq:ssl:single_source:angle_dist>

One should note that $d$ is antisymmetric, i.e.
$ d(theta_1, theta_2) = -d(theta_2, theta_1) $
$
  cal(L)(
    theta, hat(theta)
  ) = 1 / n
    sum_(i=1)^n
    d(theta_i, hat(theta)_i) ^ 2
$ <eq:ssl:single_source:doa_loss>

==== Impact of input signal representation

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