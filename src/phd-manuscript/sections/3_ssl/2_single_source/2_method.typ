#import "../../../utils.typ": *
#import "_notations.typ": *

=== Method
<sec:ssl:single_source:method>


==== Custom Dataset for #acr("SSL")
<sec:ssl:single_source:method:dataset>

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
Once  the source and microphones are positioned, this configuration's #acr("RIR") is computed.
Then, a random sample is drawn from the LibriSpeech @panayotov_librispeech_2015 dataset.
An arbitrary 1s chunk is extracted from the speech recording and set as the source input signal.
By convolving this input signal with the #acr("RIR"), we obtain the simulated signal recorded by each microphone.
Finally, the multi-channel complex #acr("STFT") is computed from the waveform and saved on disk.
For each sample, we save the localization ground-truth information, additional metadata, and the acoustic observation.
Most notably, the #doa value $theta$ and the source-array distance $D$ are included.
This process is repeated to obtain 100,000 distinct samples, which will later be split between training, validation, and testing.
The final datasets weigh from 26 to 50GB, depending on the number of microphones in the array.
@fig:ssl:single_source:dataset_statistics outlines the repartition of the generated samples regarding source-array relative positions.


#include "figures/dataset_statistics/fig.typ"


==== Microphone Arrays
<sec:ssl:single_source:method:mic_arrays>

Several microphone arrays have been experimented with in this study.
Leveraging multiple microphones to form an array is essential.
Geometric information is extracted from the differences between the signals each sensor receives.
The room's acoustic properties and the array's layout significantly impact the characteristics of the generated audio signals.
The resulting patterns in the collected data are thus heavily affected by these choices.

We present the following microphone array configurations that have been tested:
- A *binaural* array comprises two microphones placed a few centimeters apart.
  This setup constitutes the most studied robotic #acr("SSL") framework in the literature.
  This layout was primarily considered because of a humanoid robotic head equipped with two microphones on each side.
- We have also proposed a *three-microphone* design in a V-shaped arrangement.
- A *square* array of four microphones has been implemented too.
- Finally, the *#acr("ULA")* configuration is available, supporting a configurable number of microphones.

Their implementation has been integrated into our simulator (see @sec:simulator:simulator:components:sim_scenarios).

The number of microphones plays an essential role in the #"SSL" performance.
As an illustrative example, when having a binaural microphone in an anechoic environment, i.e., where the effects of reverberation can be neglected, there exists a fundamental limit:
It is theoretically impossible to distinguish between two possible locations for the source.
This phenomenon, known as front-back ambiguity, was presented earlier in this chapter @sec:ssl:background:classical_approaches.
The front-back ambiguity can be cleared by introducing relative movement or an additional microphone in the array.

Importantly, all our microphone arrays are deprived of any physical incarnation.
No real material constitutes the actual array.
In a more realistic setup, the presence of a robotic head between two microphones can be modeled using an #acr("HRTF").

// Number of microphones
// Directionality / Pattern
Each microphone's _polar pattern_ also stands out as an essential characteristic of the array.
This property describes which incoming capture directions are amplified or dampened by the sensor.
Each use of a microphone can benefit from appropriate directionality.
For instance, when recording a singer or speaker's voice, one can afford to point the receiver towards the source and have it ignore the unwanted sounds coming from other directions.

The _omnidirectional_ pattern is the simpler one to think of.
All directions are given equal importance.
In contrast, the cardioid and its variants (super-cardioid, hyper-cardioid, ultra-cardioid, etc.) weigh non-uniformly each angle of incidence and thus privilege some directions above others.
@fig:ssl:single_source:polar_patterns shows the receptive field of the most common microphone patterns.

#include "figures/polar_patterns/fig.typ"

In the context of #acr("SSL"), a non-homogeneous pattern brings extra angular information that a neural network may be able to exploit.
We have thus tested different configurations in our experiments.


==== Audio Pre-Processing
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
  #func-def(
    $phi_"Cart"$,
    $#h(1cm)CC^(F times T)$,
    $RR^(2 times F times T)$,
    $Z$,
    $lr((cal(Re)(Z), cal(Im)(Z)), size: #140%).$,
  )
  This form will be referred to as the Cartesian projection.

- The other method consists in using the polar form of the Fourier representation:
  #func-def(
    $phi_"polar"$,
    $#h(1cm)CC^(F times T)$,
    $RR^(2 times F times T)$,
    $Z$,
    $lr((abs(Z), arg(Z)), size: #140%).$,
  )

In both cases, a $C$-channel #acr("STFT") #shape("C", "F", "T") complex tensor translates to a to #shape("2C", "F", "T") real one.

Besides raw #acr("STFT") values, interaural features, presented in @sec:simulator:background:spectral-features, have been widely used in the #acr("SSL") literature @nguyen_autonomous_2018, @sivasankaran_keyword_2018 @youssef_learning-based_2013.
Binaural representations have been explicitly designed to highlight geometric information relevant to localization.
Hence, and for the sake of exhaustivity, those cues have also been tested.
This comparison employs a binaural array which allows for trivial computation of the #acr("ILD") and #acr("IPD") from the two #acr("STFT") arrays.
Notably, the number of resulting channels in the processed data remains two.
The interaural tensor $cal(I) in RR^(C times F times T)$, with $C=2$, amounts to:
$
  cal(I) = mat(
    "ILD"(m_1, m_2);
    "IPD"(m_1, m_2)
  ).
$
Both #acr("ILD") and #acr("IPD") take real values, which does not lead to doubling the number of channels.
When dealing with arrays having $C > 2$ microphones, we compute the interaural features for successive and overlapping microphone pairs.
For an array with microphones ${m_1, dots, m_k}$, the interaural features is expressed as:\
$quad forall i in [|1, C|]$,
$
  cal(I)[i] = cases(
    "IPD"(m_i, m_((i+1) mod C)) space "if "i" even;",
    "ILD"(m_i, m_((i+1) mod C)) space "if" i" odd."
  )
$
When using a single interaural feature, and not both #acr("ILD") and #acr("IPD"), the coefficients of $cal(I)$ become:
$
  cal(I)[i] = "IPD"(m_i, m_((i+1) mod C)).
$

An ablation study was conducted to measure the impact of pre-processing methods on #acr("SSL") performance (@sec:ssl:single_source:experiments:pre-processing).


==== Neural Network Architecture
<sec:ssl:single_source:method:architecture>


As demonstrated in @sec:ssl:background:deep_learning, deep neural networks are flexible and effective building blocks for an #acr("SSL") solution.
We focused in this work on a simple architecture that takes some representation of the listened audio signal as its single input.
At the other end, this network is trained to infer the #doa value $theta$ and optionally the distance $D$ from the single speech source in the room.
Our model is trained in a supervised fashion using some custom datasets presented in @sec:ssl:single_source:method:dataset.

The architecture, depicted in @fig:ssl:single_source:nn_architecture, consists of five convolutional blocks.
Each encompasses a 2D convolution layer, batch normalization, and a #acr("ReLU") operator.
The convolutional filters operate in the time-frequency plane.
The dimension of the multi-channel image progressively shrinks along the network.
The convolutional feature extractor ends with an adaptive max-pooling operation, which reduces the input tensor from a #shape("C", "F", "T") shape to a $C$-dimensional vector.
At this stage of the network, the spatial dimensions $F$ and $T$ have been reduced to 30 and 6, respectively, while the number of channels $C$ has increased to 256.
The convolutional backbone is followed by a 3-layer #acr("MLP") in charge of regressing the computed features to the final expected values.
Each fully-connected hidden layer is followed by a #acr("ReLU") and a dropout operation.
The output neurons are trained to predict the sine and cosine of the #doa and, optionally, the distance to the source $D$.


#figure(
  image(
    "figures/ssl_singlesource_nn_architecture.svg",
    height: 70%,
  ),
  caption: [
    Deep convolutional network architecture for SSL.
  ],
)
<fig:ssl:single_source:nn_architecture>


==== Loss Function
<sec:ssl:single_source:method:loss>

This single-source #acr("SSL") task boils down to a low-dimensional regression problem.
The network is designed to eventually predict a scalar value for the #doa and optionally an extra value for the source-microphone distance.

*Angular loss.*
While the distance case is straightforward, the #doa estimation should be cautiously handled.
Indeed, the #doa lies in the $[-pi, pi]$ periodic interval.
For instance, if the ground truth is $-3.1$ radians, then values close to either $-pi$ or $pi$ would be accurate predictions.
A naive #acr("MSE") loss would wrongly penalize estimations close to $+pi$.
We adopt a periodic loss for the #doa to account for this specificity.
Also, the network does not directly predict the #doa value $theta$, but its sine and cosine instead.

#let S_i = $colMath(S_i, #green)$
#let S_i_hat = $colMath(hat(S)_i, #olive)$
#let C_i = $colMath(C_i, #blue)$
#let C_i_hat = $colMath(hat(C)_i, #navy)$
Let $hat(theta) = (hat(theta)_1, dots, hat(theta)_n)$ be the set of #doa angles predicted by the network and $theta = (theta_1, dots, theta_n)$ the corresponding ground truth values.
The loss function is expressed as
$
  #l-doa (
    hat(theta), theta
  ) & = 1 / n
      sum_(i=1)^n
      [
        1 - (
          sin(theta_i) sin(hat(theta)_i)
          + cos(theta_i) cos(hat(theta)_i)
        )
      ].
$
<eq:ssl:single_source:doa_loss>
#include "figures/angular_loss.typ"

Mathematically, we can write $#l-doa (hat(theta), theta) = 1/n sum_(i=1)^n [1 - cos(theta_i - hat(theta)_i)]$, but the implementation specifically uses @eq:ssl:single_source:doa_loss as the network's output neurons ($cos hat(theta)_i$ and $sin hat(theta)_i$) need to appear explicitly.
@fig:ssl:single_source:angular_loss plots the value of $#l-doa (dot, hat(theta))$ for different values of $hat(theta)$.
We use this loss function to train the neural network to output accurate #doa values without suffering from boundary effects.

*Distance loss.*
When the model additionally estimates the distance to the source, the natural #acr("MSE") loss is used to supervise the relevant output neuron:
#let l-dist = $colMath(cal(L)_"dist", #maroon)$
$
  #l-dist (hat(d), d) =
  1 / n
  sum_(i=1)^n
  norm(hat(D)_i - D_i)_2^2 thick,
$ <eq:ssl:single_source:dist_loss>
where $D = (D_1, dots, D_n)$ is the set of predicted distances and $hat(D) = (hat(D)_1, dots, hat(D)_n)$ the ground truth data.

The total loss then becomes
$
  cal(L)
  =
  #l-doa (hat(theta), theta)
  + kappa #l-dist (hat(D), D),
$
<eq:ssl:single_source:total_loss>
where $kappa$ balances the relative importance of the distance loss in the final result.

==== Training Strategy
<sec:ssl:single_source:method:training_strategy>

Training deep neural networks involves determining relevant values for multiple hyperparameters.
The network architecture plays a crucial role and has already been discussed in @sec:ssl:single_source:method:architecture.
Similarly, the rest of the parameters have been set empirically, leveraging their impact on the final performance.

The model is trained in a supervised fashion on the synthetic datasets generated by the audio simulator (see @sec:ssl:single_source:method:dataset).
The training set consists of 80k samples.
72k elements are used for training, while 8k are reserved for validation.
Besides, the remaining 20k samples constitute a test dataset and serve to evaluate the model's performance.

The training employs a batch size of 250 items for $T_"max" = 100$ epochs.
A learning rate scheduler helps stabilize the training and further improve the final results.
Cosine annealing, proposed by Loshchilov and Hutter @loshchilov_sgdr_2017, decays the learning rate according to the following scheme:
$
  eta_t = eta_min + (eta_0 - eta_min) / 2 (1 + cos(T_"cur" / T_"max" pi)),
$
where $eta_t$ is the learning rate at epoch $t$, $eta_0$ is the initial learning rate, $T_"cur"$ is the current epoch.
The minimum learning rate $eta_min$ has been set to $10^(-5)$ and is reached at the very end of the training.
A base learning rate of $eta_0=10^(-3)$ has been shown to ensure rapid convergence without suffering from instability issues.
Regarding the optimizer, we have chosen to use Adam @kingma_adam_2017.
Training runs have been performed on an Nvidia RTX A6000 GPU and have lasted approximately one hour.
