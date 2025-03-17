#import "/utils.typ": *
#import "_notations.typ": *


=== Experiments
<sec:ssl:single_source:experiments>

This section presents a collection of experimental results on #acr("SSL") performance.
This study's objective is to understand the influence of certain parameters on the difficulty of the #acr("SSL") task.
For this purpose, a baseline solution and scenario are described and will serve as a reference point for the tested variations.
First, the general testing methodology and metrics will be presented.
The actual experimental results, including quantitative results, will follow.

// An initial series of experiments were conducted with apparently successful results.
// The following section was initially written to present this satisfying outcome.
// Unfortunately, we discovered a flaw in the experimental setup at a very late stage of the project.
// The issue consists of a subtle behavior of the random generator used during the data collection.
// The entire dataset is first generated using a parallel implementation.
// Once generated, it is randomly split into two subsets: training and test datasets.
// Naturally, they are expected to be distinct, as the latter is used to evaluate the neural network's performance.
// Once the seed is set, the initial generation process is behaving in a deterministic manner.
// // TODO check
// The specificity of the Numpy random generator is that the initial state is the same for each separate thread.
// Hence, each thread generated the same sequence of training pairs, and the final dataset consisted of a concatenation of duplicated samples.
// This highly problematic error implied that numerous samples were shared between the train and test datasets.
// Hence, this explains the highly satisfying results of our approach.
// 
// After fixing the bias in the dataset generation, the model's performance degraded significantly.
// Nonetheless, we chose to describe the methodology initially developed and the experiments we conducted.

==== Metrics

In this first formulation of the #acr("SSL") problem, each situation includes exactly one source to localize.

*#acr("DoA") metric.*
Naturally, the performance of the method is characterized by how far the estimate $hat(theta)$ lies from the real #acr("DoA") value $theta$.
As the network predicts the sine and cosine of $theta$, the #acr("DoA") value is first computed following:
$
  hat(theta) = op("atan2")(sin(hat(theta)), cos(hat(theta)))
  = arg(
    cos(hat(theta)) + i sin(hat(theta))
  )
$

We then compute the average $ell^1$ angular distance #d between $hat(theta)$ and $theta$.
As both the predicted and ground-truth #acr("DoA") values are constrained to the $[-pi, pi]$ interval.
#func-def(
  d,
  $[-pi, pi]^2$,
  $[0, 1]$,
  $(theta_1, theta_2)$,
  $abs(theta_2 - theta_1)$
)
This measure will be referred to as the #acr("MAE"):
$
  #mae-theta = 1 / n_"test" sum_(i=1) ^ n_"test" #d (hat(theta)_i, theta_i)
$ <eq:ssl:single_source:mae>
where $n_"test"$ counts the number of samples in the test set.


*Source-array distance metric.*
When predicting the source-array distance, the #acr("MAE") is also used, here between predicted $hat(D)$ values and ground truth $D$:
$
  #mae-dist = 1 / n_"test" sum_(i=1) ^ n_"test"
  abs(hat(D)_i - D_i)
$ <eq:ssl:single_source:dist_metricc>


The choice of the #acr("MAE") as performance criteria has the advantage of being expressed in length units.
For clarity reasons, the values for this metrics will be displayed in centimeters (cm).


==== Base solution and general methodology

In order to have a 
The goal
#todo

- The goal is to compare different factors and see their influence on the performance
- Describe the base scenario (binaural, )
- It does not give the best performance, but it is not the point
- Single room (not different sizes)
- General methodology: isolate a parameter and study its impact.
  - Several repetitions per experiment. We take the best result


==== Microphone arrays and layouts

#include "tables/arrays.typ"


==== Impact of input signal representation

The neural network is expected to extract the relevant localization information from the audio signal provided as input.
This section explores the importance of the choice of the input features fed into the network.
Here, the sensors consist in a binaural microphone array of two omnidirectional transducers.

In this work, we focus on time-frequency representations.
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
This comparison employs a binaural array which allows to trivially compute #acr("ILD") and #acr("IPD") from the two #acr("STFT") arrays.

Importantly, the number of resulting channels in the processed data remains two in this case.
The interaural tensor $cal(I) in RR^(C, F, T)$ amounts to:
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

To measure the impact of the input representation, we run the training process with each aforementioned encoding choice.
The number of channels depends on the selected method and varies from 1 to 4.

#include "tables/input_features.typ"


// TODO: Hence, the choice of the encoding method for the acoustic data has a substantial impact on the difficulty of this task.
@table:ssl:single_source:input_features summarizes the method's performance when using different input features.
We report the corresponding channel dimension of the resulting tensor for each set of cues.
On the one hand, both complex-to-real #acr("STFT") polar and Cartesian mappings yield substantially different results.
Indeed, despite having the same underlying data, those two representations do not offer the network the same ease of learning from.
On the other hand, further processing the #acr("STFT") into the binaural features does not seem to improve performance.
#todo (faux):
Unsurprisingly, displaying phase-related information directly rather than indirectly seems to matter the most.
Both the polar #acr("STFT") and interaural features explicitly contain this phase:
The former by $arg(L)$ and $arg(R)$ on two distinct channels and the latter by the ratio $arg(L) / arg(R)$ on a single one.
$L$ and $R$ denote the spectrograms from the left and right microphones, respectively.

To further prove this hypothesis, an ablation study is performed.
The objective involves showing whether phase-related features alone are sufficient to perform localization efficiently.
Results are in the bottom half of @table:ssl:single_source:input_features.
They show that limiting the input information to phase information alone suffices to accurately estimate both the #acr("DoA") and distance values.
Paradoxically, such filtering of the input data even achieves results slightly better than those obtained when using the full features.
This further confirms that the rest of the features is fully redundant.

Interestingly, solely using the #acr("ILD") matrix yields a promising #mae-theta of 2.39° which shows that our model manages to leverage the difference in amplitude between the two channels for performing localization.
However, those results are less consistent across several runs than the ones using #acr("IPD") or the phase of the #acrpl("STFT").
Lastly, providing the only magnitude of the #acrpl("STFT") does not lead to comparable performance with a #mae-theta of 14.73 at best.

Considering their satisfying results, the interaural features will be kept as the baseline method for the rest of the study.


==== Reverberation

#acr("SSL") methods leverage the inter-channel differences present in the time-frequency input data to infer the source position.
Those variations, theoretically discussed in @sec:simulator:background:spectral-features

#include "tables/reverb.typ"



==== Sound Source Localization in noisy environments
<sec:ssl:single_source:experiments:noise>

Having succeeded at accurately estimating the #acr("DoA") in a reverberant but noiseless setting, we have attempted to add noise sources.
The latter has revealed to harden the task significantly.
We have focused on noises of basic nature: white noise and music.
Both share the property of noticeably differing from a speech signal in its fundamental acoustic nature.
// Having a parasite speech

// Which kinds of noises

$
  E(S) = sum_(t=1)^T sum_(f=1)^F
    abs(S(t, f))^2
$

$
  #snr = 10 log_10 (E(S_"speech") / E(S_"noise"))
$
