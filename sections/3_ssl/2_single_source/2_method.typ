#import "/utils.typ": *
#import "_notations.typ": *

=== Method


==== Custom dataset for #acr("SSL")
<sec:ssl:single_source:method:dataset>
//#gaet[
//  This section is a mess and needs to be properly re-written along with its @sec:ssl:multi_source:method:dataset sibling.
//]

The objective of this study was to adapt State of the Art #acr("SSL") methods to diverse challenging setups.
The audio simulator presented in @chap:simulator has been leveraged to generate various synthetic datasets to experiment with.

Although public #acr("SSL") datasets have been shared publicly by the community, we have chosen to work within our artificial #acr("HRI") environment for later reuse of this method.
For the sake of exhaustivity, here are some examples of other relevant datasets.
He et al. @he_deep_2018 have proposed the #acr("SSLR") dataset using the Pepper robot equipped with a four-microphone array.
Furthermore, the third task of the #acr("DCASE") challenge proposes a yearly competition around designing the best #acr("SSL") system.
For the 2024 edition of #acr("DCASE"), the target dataset was STARSS23 @shimada_starss23_nodate, introduced at the NeurIPS 2023 conference.


#figure(
  move(
    image(
      "figures/dataset_statistics.svg",
      height: 10cm,
    ),
    dx: 33pt
  ),
  caption: [
    Statistics of ground-truth label pairs ($theta$, $D$) in the generated dataset
  ]
)
<fig:ssl:single_source:dataset_statistics>


@fig:ssl:single_source:dataset_statistics outlines the repartition of the generated samples in terms of source-array relative positions.

The speech source present in the room is considered to be omnidirectional and simulated as such.
#draft[
  Should we already warn about the limitations of this choice ? i.e. not very realistic
]

//TODO
//#draft[
//  Mention that both source and microphones can be anywhere in the room.
//  Many papers restrict those much more (fixed mic. array, sources in a circle...)
//
//  Talk about the size (in GB) of the dataset
//]



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

Several microphone arrays have been experimented in this study.
Leveraging multiple microphones to form an array is essential.
Geometric information is extracted from the differences between the signals each sensor receives.
Acoustic reverberation and the spatial configuration of the array lead to the apparition of exploitable patterns in the overall collected data.

We present the following microphone array configurations that have been tested.

- A *binaural* array comprises two microphones placed a few centimeters apart from each other.
 This setup certainly constitutes the most studied robotic #acr("SSL") framework in the literature.
 A humanoid robotic head equipped with two microphones on each side has been the motivation to primarily consider this layout.
- We have also proposed a *three-microphone* design laid out in a V-shaped arrangement.
- Finally, a *square* array of four microphones has been implemented too.

Their implementation has been integrated in our simulator (see @sec:simulator:simulator:components:sim_scenarios).

The number of microphones plays an important role in the #("SSL") performance.
As an illustrative example, when having a binaural microphone in the free field, i.e. where the effects of reverberation can be neglected, there exist a fundamental limit:
It is theoretically impossible to distinguish the two possible locations of the source.
This phenomenon is known as the front-back ambiguity and has been presented earlier in this chapter @sec:ssl:sota:classical_approaches.
The latter can be cleared up by introducing relative movement or an additional microphone in the array.

// TODO
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

The simulator allows the extraction of spectral representations directly from received signals.
This section summarizes the explicit choices made regarding audio processing for performing the #acr("SSL") task.
//TODO
//The Short Term Fourier transform is computed on short frames of 
//Originally, the dataset is constituted by #draft[TODO]


==== Neural Network Architecture
<sec:ssl:single_source:method:architecture>


As demonstrated in @sec:ssl:sota:deep_learning, deep neural networks have shown to be flexible and effective as building blocks for an #acr("SSL") solution.
We focused in this work on a simple architecture that takes some representation of the listened audio signal as its only input.
At the other end, this network is trained to infer the #acr("DoA") value $theta$ and optionally the distance $D$ from the the single speech source present in the room.

Our model is trained in a supervised fashion using some custom datasets presented in @sec:ssl:single_source:method:dataset.

The architecture, depicted in @fig:ssl:single_source:nn_architecture, consists in three convolutional blocks.
Each of them encompasses a 2D convolution operator, layer normalization and finally a #acr("ReLU").
The convolutional filters operate in the time-frequency plane.
The dimension of the multi-channel image progressively shrinks along the network.
Ultimately, the data gets flatten into a one-dimensional vector fed into a 4-layers #acr("MLP").
The number of output neurons can be configured depending on the necessity to predict only the #acr("DoA") value or both #acr("DoA") and source-array distance.

#figure(
  image("figures/ssl_singlesource_nn_architecture.svg"),
  caption: [
    Simple convolutional architecture for #acr("SSL")
  ],
) <fig:ssl:single_source:nn_architecture>


*Architecture impact.*
Our model architecture has been explicitly designed for the present use case.
Literature on #acr("SSL") and more broadly computer vision has motivated the structure of this reasonably standard network.
However, several variations have been regarding the layout of the convolutional blocks.
Although performance in _easy_ tasks were not significantly impacted by those changes, they have turned out to be crucial for achieving satisfying results in more complex settings.
More specifically, the presence of normalization layers has shown to enhance training stability across our experiments.
Interestingly, whether to place those normalization before or after the #acr("ReLU") in each convolutional block ended up mattering substantially.
Albeit in some cases, similarly good performance was achieved #todo

// TODO
// #gaet[
//   Should we say that the impact of the architecture (Relu vs ReLU+BN vs BN+ReLU vs ReLU+LN LN+ReLU) is laughingly HIGH ?
//   Should we include 
// ]


==== Loss function
<sec:ssl:single_source:method:loss>

This single-source #acr("SSL") task boils down to a one or two-dimensional regression problem.
The network is designed to eventually predict a scalar value for the #acr("DoA") and optionally an extra value for the source-microphone distance.

*Angular loss.*
While the distance case is straightforward, the #acr("DoA") estimation should be cautiously handled.
Indeed, the #acr("DoA") lies in the $[-pi, pi]$ periodic interval.
For instance, if the ground truth is $-3.1$ radians, then values close to either $-pi$ or $pi$ would be accurate predictions.
A naive #acr("MSE") loss would wrongly penalize estimations close to $+pi$.
We adopt a periodic loss for the #acr("DoA") to account for this specificity.

Let $hat(theta) = (hat(theta)_1, dots, hat(theta)_n)$ be the set of #acr("DoA") angles predicted by the network and $theta = (theta_1, dots, theta_n)$ the corresponding ground truth values.
The loss function is expressed as
$
  #l-doa (
    hat(theta), theta
  ) = 1 / n
    sum_(i=1)^n
    [
       1 - (
         sin(theta_i) sin(hat(theta)_i)
         +  cos(theta_i) cos(hat(theta)_i)
       )
    ]
$

#include "figures/angular_loss.typ"
@fig:ssl:single_source:angular_loss plots the value of $#l-doa (dot, hat(theta))$ for different values of $hat(theta)$.
We use this loss function to train the neural network to output accurate #acr("DoA") values without suffering from boundary effects.

*Distance loss.*
When the model additionally estimates the distance to the source, the natural #acr("MSE") loss is used to supervise the relevant output neuron:
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
    + kappa #l-dist (hat(D), D).
  $
  <eq:ssl:single_source:total_loss>
]
$kappa$ balances the relative importance of the distance loss in the final result.

#draft[
  // @fig:ssl:single_source:angular_dist_plot plots the value of #l-doa with respect to the value of $theta_2 - theta_1$.
  
  #todo
  // @fig:ssl:single_source:angular_dist_plot plots the value of #l-doa with respect to the value of $theta_2 - theta_1$.
  
  
  The neural network comprises a single output neuron $hat(theta)$ expected to estimate the true value of $theta$.
  We will now introduce the loss function used during training.

  // Angular distance
  
//   #d is represented in blue in @fig:ssl:single_source:angular_dist_plot.
  
  On the $[-2pi, 2pi]$ interval, #d behaves like the conventional angular periodic distance.
  However, for values of $abs(theta_2 - theta_1) > 2pi$, the distance diverges to $+infinity$.
  The natural choice would have been to wrap #d in $[0, pi]$ by choosing:
  $
    d'(theta_1, theta_2) :=
      pi
      - lr(mabs(
          mabs(theta_2 - theta_1)colMath([2pi], #olive)
          - pi
        )
      ).
  $
  Conversely, this pseudo-distance discourages the network from predicting high magnitudes values of $theta$ even though they would satisfy $theta approx hat(theta)[2pi]$.
  Empirically, this choice has shown no effect on neither the training process nor the final results.
  

  
  //#figure(
  //  image("figures/angular_dist_loss.svg"),
  //  caption: flex-caption( [
  //    Plot of the angular pseudo-distance $colMath(d(theta_1, theta_2), #d-color)$
  //    and the angular $ell^2$ loss $colMath(d(theta_1, theta_2)^2, #l-color)$
  //    against $theta_2 - theta_1$
  //  ],
  //  [
  //    Plot of the angular pseudo-distance
  //    and the angular $ell^2$ loss
  //  ])
  //)
  //<fig:ssl:single_source:angular_dist_plot>
  //
  //
  //The neural network is trained to minimize this objective.
  
]




==== Training strategy

Training deep neural networks involve determining relevant values for multiple hyper parameters.
The network architecture itself plays a crucial role and has already been discussed in @sec:ssl:single_source:method:architecture.
Similarly, the rest of the parameters have been set empirically, leveraging their impact on the final performance.

The model is trained in a supervised fashion on the synthetic datasets generated by the audio simulator (see @sec:ssl:single_source:method:dataset).
The training set consists in 80k samples. 
72k elements are used for training itself while 8k are reserved for validation.
Besides, a 20k samples test dataset serves for evaluating the model's performance.

The training employs a batch size of 200 items for $T_"max" = 60$ epochs.
A learning rate scheduler helps stabilizing the training and further improving the final results.
Cosine annealing, proposed by Loshchilov and Hutter @loshchilov_sgdr_2017, decays the learning rate according to the following scheme:
$
  eta_t = eta_0/2 (1 + cos(T_"cur" / T_"max" pi))
$
where $eta_t$ is the learning rate at epoch $t$, $eta_0$ is the initial learning rate, $T_"cur"$ is the current epoch.
At the end of the training, the learning rate thus reaches zero.
A base learning rate of $10^(-3)$ has shown to ensure rapid convergence without suffering from instability issues.
Regarding the optimizer, the Adam @kingma_adam_2017 optimizer has been used.
Trainings have been performed on an Nvidia RTX A6000 GPU and could be efficiently terminated in approximately 20 minutes.