#import "/utils.typ": *
#import "_notations.typ": *

=== Method


==== Custom dataset for #acr("SSL")
<sec:ssl:single_source:method:dataset>
//TODO This section is a mess and needs to be properly re-written along with its @sec:ssl:multi_source:method:dataset sibling.

This study aimed to adapt state-of-the-art #acr("SSL") methods to diverse, challenging setups.
The audio simulator presented in @chap:simulator has been leveraged to generate various synthetic datasets for experimentation.

Although public #acr("SSL") datasets have been shared publicly by the community, we have chosen to work within our artificial #acr("HRI") environment for later reuse of this method.
For the sake of completeness, here are some examples of other relevant datasets.
He et al. @he_deep_2018 have proposed the #acr("SSLR") dataset using the Pepper robot equipped with a four-microphone array.
Furthermore, the third task of the #acr("DCASE") challenge proposes a yearly competition around designing the best #acr("SSL") system.
The target dataset for the 2024 edition of #acr("DCASE") was STARSS23 @shimada_starss23_2023, introduced at the NeurIPS 2023 conference.

Training and test samples are generated independently according to the following process.
An omnidirectional speech source, our acoustic model for a speaking human, is placed randomly in the room.
A multi-microphone array is also positioned randomly in the room.
Apart from ensuring that the source and microphones are not too close to the walls, no constraint is set on their location.
Several published #acr("SSL") methods are only tested with restricted positions for the sources.
Such limitations can be inherent to the physical experimental setup.
Using a simulator allows for maximizing the diversity of environment configurations.
Once  the source and microphones are positioned, this configuration's #acr("RIR") filter is computed.
Then, a random sample is drawn from the LibriSpeech @panayotov_librispeech_2015 dataset.
An arbitrary 1s chunk is extracted from the speech recording and set as the source input signal.
By convolving this input signal with the #acr("RIR") filter, we obtain the simulated signal recorded by each microphone.
Finally, the multi-channel complex #acr("STFT") is computed from the waveform and saved on disk.
For each sample, we save the localization ground-truth information, additional metadata, and the acoustic observation.
Most notably, the #acr("DoA") value $theta$ and the source-array distance $D$ are included.
This process is repeated to obtain 100,000 distinct samples, which will later be split between training, validation, and testing.
The final datasets weigh from 26 to 50GB, depending on the number of microphones in the array.
@fig:ssl:single_source:dataset_statistics outlines the repartition of the generated samples regarding source-array relative positions.


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



==== Microphone arrays
<sec:ssl:single_source:method:mic_arrays>

Several microphone arrays have been experimented with in this study.
Leveraging multiple microphones to form an array is essential.
Geometric information is extracted from the differences between the signals each sensor receives.
Acoustic reverberation and the spatial configuration of the array lead to the appearance of exploitable patterns in the overall collected data.

We present the following microphone array configurations that have been tested.

- A *binaural* array comprises two microphones placed a few centimeters apart.
 This setup constitutes the most studied robotic #acr("SSL") framework in the literature.
 This layout was primarily considered because of a humanoid robotic head equipped with two microphones on each side.
- We have also proposed a *three-microphone* design in a V-shaped arrangement.
- Finally, a *square* array of four microphones has been implemented too.

Their implementation has been integrated into our simulator (see @sec:simulator:simulator:components:sim_scenarios).

The number of microphones plays an essential role in the #("SSL") performance.
As an illustrative example, when having a binaural microphone in the free field, i.e. where the effects of reverberation can be neglected, there exists a fundamental limit:
It is theoretically impossible to distinguish between two possible locations for the source.
This phenomenon is known as front-back ambiguity and was presented earlier in this chapter @sec:ssl:background:classical_approaches.
The front-back ambiguity can be cleared by introducing relative movement or an additional microphone in the array.

Importantly, all our microphone arrays are deprived of any physical incarnation.
No real material constitutes the actual array.
In a more realistic setup, the presence of a robotic head between two microphones can be modeled using an #acr("HRTF").

// Number of microphones
// Directionality / Pattern
Each microphone's _polar pattern_ also stands out as an essential characteristic of the array.
This property describes which incoming capture directions will be amplified or dampened by the sensor.
Each use of a microphone can benefit from appropriate directionality.
For instance, when recording a singer or speaker's voice, one can afford to point the receiver towards the source and have it ignore the unwanted sounds coming from other directions.

The _omnidirectional_ pattern is the simpler one to think of.
All directions are given equal importance.
In contrast, the cardioid and its variants (super-cardioid, hyper-cardioid, ultra-cardioid, etc.) weigh non-uniformly each angle of incidence and thus privilege some directions above others.
@fig:ssl:single_source:polar_patterns shows the receptive field of the most common microphone patterns.
#figure(
  image("figures/polar_patterns.jpg", height: 8cm),
  caption: [
    Illustration of the most common microphone polar patterns @stoddart_beginners_2016
  ],
) <fig:ssl:single_source:polar_patterns>

In the context of #acr("SSL"), a non-homogeneous pattern brings extra angular information that a neural network might be able to exploit.
We have thus tested different configurations in our experiments.


==== Audio pre-processing
<sec:ssl:single_source:method:pre-processing>

Motivated by their popularity in the literature, we focus on spectral representations of audio data.
The simulator allows the extraction of such representations directly from the generated signals.
The observations are stored in the dataset as multichannel complex #acrpl("STFT")s.
These complex tensors are not fed directly into the neural network but are further processed.
The role of this step is to convert the complex spectral observation to a real-valued tensor.
The neural network is expected to extract the relevant localization information from the obtained representation.
This section explores the importance of choosing the input features fed into the network.
Several methods have been tested and compared.
The corresponding experimental section (@sec:ssl:single_source:experiments:pre-processing) summarizes our findings regarding their respective performance.

Adaptations of 2D convolutions to complex tensors do exist and have already been used in the #acr("SSL") literature.
Krause et al. @krause_comparison_2021 present this variation along with its benefits (Section II.B).
However, regular 2D convolutions have been employed in the present work, and the complex-valued #acr("STFT") needed to be converted to real values.
To achieve this, two schemes were compared:
- On the one hand, both the real and imaginary parts of the complex data can populate the two real resulting matrices:
  $
    phi_"cart": #h(1cm) CC^(F times T) & -->               RR^(2 times F times T)\
    Z        & arrow.r.long.bar 
    lr((cal(Re)(Z), cal(Im)(Z)), size: #140%)
  $
  This form will be referred to as the Cartesian projection.

- The other method consists in using the polar form of the Fourier representation:
$
  phi_"polar": #h(1cm) CC^(F times T) & -->               RR^(2 times F times T)\
  Z        & arrow.r.long.bar 
  lr((abs(Z), arg(Z)), size: #140%)
$

In both cases, a $C$-channel #acr("STFT") #shape("C","F","T") complex tensor translates to a to #shape("2C", "F", "T") real one.

Besides raw #acr("STFT") values, interaural features, presented in @sec:simulator:background:spectral-features, have been widely used in the #acr("SSL") literature @nguyen_autonomous_2018, @sivasankaran_keyword_2018 @youssef_learning-based_2013.
Binaural representations have been explicitly designed to highlight geometric information relevant to localization.
Hence, and for the sake of exhaustivity, those cues have also been tested.
This comparison employs a binaural array which allows for trivial computation of the #acr("ILD") and #acr("IPD") from the two #acr("STFT") arrays.
Notably, the number of resulting channels in the processed data remains two.
The interaural tensor $cal(I) in RR^(C times F times T)$ amounts to:
$
  cal(I) = mat(
      "ILD"(m_1, m_2);
      "IPD"(m_1, m_2)
  )
$
Both #acr("ILD") and #acr("IPD") take real values, which does not lead to doubling the number of channels.
When dealing with arrays having more than two microphones, we compute the interaural features for successive and overlapping microphone pairs.
#block(breakable: false)[
  For an array with microphones ${m_1, dots, m_k}$, the interaural features is expressed as:\
  $quad forall i in [|1, C|]$,
  $
    cal(I)[i] = cases(
      "IPD"(m_i, m_((i+1) equiv C))\, space "if" i equiv 2 = 0,
      "ILD"(m_i, m_((i+1) equiv C))\, space "if" i equiv 2 = 1
    )
  $
]
When using a single interaural feature, and not both #acr("ILD") and #acr("IPD"), the coefficients of $cal(I)$ become:
$
  cal(I)[i] = "IPD"(m_i, m_((i+1) equiv C))
$

An ablation study was conducted to measure the impact of pre-processing methods on #acr("SSL") performance (@sec:ssl:single_source:experiments:pre-processing).


==== Neural Network Architecture
<sec:ssl:single_source:method:architecture>


As demonstrated in @sec:ssl:background:deep_learning, deep neural networks are flexible and effective building blocks for an #acr("SSL") solution.
We focused in this work on a simple architecture that takes some representation of the listened audio signal as its only input.
At the other end, this network is trained to infer the #acr("DoA") value $theta$ and optionally the distance $D$ from the single speech source in the room.
Our model is trained in a supervised fashion using some custom datasets presented in @sec:ssl:single_source:method:dataset.

The architecture, depicted in @fig:ssl:single_source:nn_architecture, consists of five convolutional blocks.
Each encompasses a 2D convolution layer, batch normalization, and a #acr("ReLU") operator.
The convolutional filters operate in the time-frequency plane.
The dimension of the multi-channel image progressively shrinks along the network.
The convolutional feature extractor ends with an adaptive max-pooling operation, which reduces the input tensor from a #shape("C", "F", "T") shape to a $C$-dimensional vector.
At this stage of the network, the spatial dimensions $F$ and $T$ have been reduced to 30 and 6, respectively, while the number of channels $C$ has increased to 256.
The convolutional backbone is followed by a 3-layer #acr("MLP") in charge of regressing the computed features to the final expected values.
Each fully-connected hidden layer is followed by a #acr("ReLU") and a dropout operation.
The output neurons are trained to predict the sine and cosine of the #acr("DoA") and, optionally, the distance to the source $D$.


#figure(
  image(
    "figures/ssl_singlesource_nn_architecture.svg",
    height: 70%
  ),
  caption: [
    Simple convolutional architecture for #acr("SSL")
  ],
) <fig:ssl:single_source:nn_architecture>


==== Loss function
<sec:ssl:single_source:method:loss>

This single-source #acr("SSL") task boils down to a low-dimensional regression problem.
The network is designed to eventually predict a scalar value for the #acr("DoA") and optionally an extra value for the source-microphone distance.

*Angular loss.*
While the distance case is straightforward, the #acr("DoA") estimation should be cautiously handled.
Indeed, the #acr("DoA") lies in the $[-pi, pi]$ periodic interval.
For instance, if the ground truth is $-3.1$ radians, then values close to either $-pi$ or $pi$ would be accurate predictions.
A naive #acr("MSE") loss would wrongly penalize estimations close to $+pi$.
We adopt a periodic loss for the #acr("DoA") to account for this specificity.
Also, the network does not directly predict the #acr("DoA") value $theta$, but its sine and cosine instead.

#block(breakable: false)[
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
]

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
    + kappa #l-dist (hat(D), D),
  $
  <eq:ssl:single_source:total_loss>
]
where $kappa$ balances the relative importance of the distance loss in the final result.

// #draft[
//   // @fig:ssl:single_source:angular_dist_plot plots the value of #l-doa with respect to the value of $theta_2 - theta_1$.
//   
//   #todo
//   // @fig:ssl:single_source:angular_dist_plot plots the value of #l-doa with respect to the value of $theta_2 - theta_1$.
//   
//   
//   The neural network comprises a single output neuron $hat(theta)$ expected to estimate the true value of $theta$.
//   We will now introduce the loss function used during training.
// 
//   // Angular distance
//   
// //   #d is represented in blue in @fig:ssl:single_source:angular_dist_plot.
//   
//   On the $[-2pi, 2pi]$ interval, #d behaves like the conventional angular periodic distance.
//   However, for values of $abs(theta_2 - theta_1) > 2pi$, the distance diverges to $+infinity$.
//   The natural choice would have been to wrap #d in $[0, pi]$ by choosing:
//   $
//     d'(theta_1, theta_2) :=
//       pi
//       - lr(mabs(
//           mabs(theta_2 - theta_1)colMath([2pi], #olive)
//           - pi
//         )
//       ).
//   $
//   Conversely, this pseudo-distance discourages the network from predicting high magnitudes values of $theta$ even though they would satisfy $theta approx hat(theta)[2pi]$.
//   Empirically, this choice has shown no effect on neither the training process nor the final results.
//   
// 
//   
//   //#figure(
//   //  image("figures/angular_dist_loss.svg"),
//   //  caption: flex-caption( [
//   //    Plot of the angular pseudo-distance $colMath(d(theta_1, theta_2), #d-color)$
//   //    and the angular $ell^2$ loss $colMath(d(theta_1, theta_2)^2, #l-color)$
//   //    against $theta_2 - theta_1$
//   //  ],
//   //  [
//   //    Plot of the angular pseudo-distance
//   //    and the angular $ell^2$ loss
//   //  ])
//   //)
//   //<fig:ssl:single_source:angular_dist_plot>
//   //
//   //
//   //The neural network is trained to minimize this objective.
//   
// ]




==== Training strategy

Training deep neural networks involves determining relevant values for multiple hyperparameters.
The network architecture itself plays a crucial role and has already been discussed in @sec:ssl:single_source:method:architecture.
Similarly, the rest of the parameters have been set empirically, leveraging their impact on the final performance.

The model is trained in a supervised fashion on the synthetic datasets generated by the audio simulator (see @sec:ssl:single_source:method:dataset).
The training set consists of 80k samples. 
72k elements are used for training itself while 8k are reserved for validation.
Besides, the remaining 20k samples constitute a test dataset and serve to evaluate the model's performance.

The training employs a batch size of 250 items for $T_"max" = 100$ epochs.
A learning rate scheduler helps stabilize the training and further improve the final results.
Cosine annealing, proposed by Loshchilov and Hutter @loshchilov_sgdr_2017, decays the learning rate according to the following scheme:
$
  eta_t = eta_min + (eta_0 - eta_min) / 2  (1 + cos(T_"cur" / T_"max" pi))
$
where $eta_t$ is the learning rate at epoch $t$, $eta_0$ is the initial learning rate, $T_"cur"$ is the current epoch.
The minimum learning rate $eta_min$ has been set to $10^(-5)$ and is reached at the very end of the training.
A base learning rate of $eta_0=10^(-3)$ has been shown to ensure rapid convergence without suffering from instability issues.
Regarding the optimizer, we have chosen to use Adam @kingma_adam_2017.
Training runs have been performed on an Nvidia RTX A6000 GPU and have lasted approximately one hour.