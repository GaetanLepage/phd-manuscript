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
<sec:ssl:single_source:experiments:metrics>

In this first formulation of the #acr("SSL") problem, each situation includes exactly one source to localize.

*#acr("DoA") metric.*
Naturally, the performance of the method is characterized by how far the estimate $hat(theta)$ lies from the real #acr("DoA") value $theta$.
As the network predicts the sine and cosine of $theta$, the #acr("DoA") value is first computed following:
$
  hat(theta) = op("atan2")
    lr(
      (sin(hat(theta)), cos(hat(theta)))
      , size: #150%
    )
  = arg lr(
      (
        cos(hat(theta))
        + i sin(hat(theta))
      ),
      size: #150%
    )
$

We then compute the average $ell^1$ angular distance #d between $hat(theta)$ and $theta$.
The following expression for #d accounts for the periodicity of the angular interval $[-pi, pi]$:
//As both the predicted and ground-truth #acr("DoA") values are constrained to the $[-pi, pi]$ interval.
#func-def(
  d,
  $[-pi, pi]^2$,
  $[0, 1]$,
  $(theta_1, theta_2)$,
  //$pi - abs(abs(theta_2 - theta_1) - pi)$
  $pi - lr(abs(abs(theta_2 - theta_1) - pi), size: #150%)$
)
<eq:ssl:single_source:angular_dist>
This measure will be referred to as the #acr("MAE"):
$
  #mae-theta = 1 / n_"test" sum_(i=1) ^ n_"test" #d (hat(theta)_i, theta_i)
$
<eq:ssl:single_source:mae>
where $n_"test"$ counts the number of samples in the test set.


*Source-array distance metric.*
When predicting the source-array distance, the #acr("MAE") is also used, here between predicted $hat(D)$ values and ground truth $D$:
$
  #mae-dist = 1 / n_"test" sum_(i=1) ^ n_"test"
  abs(hat(D)_i - D_i)
$ <eq:ssl:single_source:dist_metric>


The choice of the #acr("MAE") as performance criteria has the advantage of being expressed in length units.
For clarity reasons, the values for this metric will be displayed in centimeters (cm).
// TODO: check that we have indeed used cm.


==== Base solution and general methodology

This study aims to investigate how different parameters influence the performance of our #acr("SSL") pipeline.
A baseline has to be defined to have a reference for comparing experimental settings.
The starting setting involves a binaural array with two cardioid microphones for the agent.
Microphones are two centimeters apart.
The room's reverberation level ($T_60$) is set to 500ms.
Interaural features (#acr("ILD") + #acr("IPD")) have been chosen for this baseline.
By default, only the #acr("DoA") is predicted, not the distance.
The default number of epochs is set to 100.
This setup is not the best-performing combination, but it provides a credible formulation from which to start.
These parameters will be individually changed across the following study.

Furthermore, the following settings are kept fixed across the experiments.
We use a single $4 times 7$ meters room.
Learning parameters, such as the batch size, the learning rate, and the number of epochs, remain constant across most experiments.
The number of epochs has been exceptionally increased to reach proper convergence when necessary.
Finally, the network training for each individual configuration was repeated several times to ensure that the obtained results were repeatable.
The reported performance scores correspond to the most successful training run.


==== Microphone arrays and layouts

#acr("SSL") relies on extracting spatial information from audio signals.
Hence, as discussed in @chap:simulator and in the present chapter, the use of arrays of multiple microphones is essential for this task.
#acr("SSL") methods aim to leverage the microphones' phase and level differences.
The number of microphones in the array is an essential characteristic of the localizer.
In the physical world, available hardware can limit the size and layout of microphone arrays.
This work employs a simulator, so different configurations could easily be tested.
We selected three array layouts: binaural, triangle, and square.
They have, respectively, two, three, and four microphones.
Furthermore, both microphone patterns were tested for the binaural and triangle arrays.
@table:ssl:single_source:mic_arrays shows the obtained #acr("SSL") performance with each array.
The binaural array allows for an accurate localization as long as the pattern is directional.
Indeed, when using omnidirectional microphones, the performance drops significantly to 46°.
The asymmetry of the cardioid pattern helps discriminate the direction of arrival.
Sound wavefronts coming from the back of a directional microphone are strongly attenuated.
This fundamentally injects additional spatial information into the recorded signal.
Besides the pattern influence, we have noticed that adding microphones was substancially improving performance too.
Interestingly, the difference between an omnidirectional and a directional microphone patterns fades when dealing with three or more microphone arrays.
Our understanding is that the third microphone provides enough additional information to compensate for each microphone's lack of directionality.
The four-microphones array scores the lowest #acr("MAE").

#include "tables/arrays.typ"

Inter-microphone distance is another fundamental characteristic of a microphone array.
We have experimented with the influence of the microphone spacing in a binaural array on performance.
@table:ssl:single_source:mic_dist displays the results of this study.
Increasing the distance between microphones appears to be detrimental to the localization accuracy.
When microphones are further apart, the aliasing phenomenon becomes problematic and deteriorates the relationship between the recorded signal and the source positions.
Indeed, if the spacing amounts to $d$ meters, all frequencies above $f_0 = c / (2 d)$ Hz cannot be adequately distinguished.
For $d=2$ cm, this maximum frequency is 8.575 kHz, while most of the of human speech's frequential content is below 5 kHz @baken_clinical_2000. #draft[TODO: double-check].
Lowering the distance further to 1cm does not seem to bring additional benefits.


#include "tables/mic_dist.typ"


==== Impact of input signal representation



To measure the impact of the input representation, we run the training process with each aforementioned encoding choice.
The number of channels depends on the selected method and varies from 1 to 4.

#include "tables/input_features.typ"


// TODO: Hence, the choice of the encoding method for the acoustic data has a substantial impact on the difficulty of this task.
@table:ssl:single_source:input_features summarizes the method's performance when using different input features.
We report the corresponding channel dimension of the resulting tensor for each set of cues.
On the one hand, both complex-to-real #acr("STFT") polar and Cartesian mappings yield substantially different results.
Indeed, despite having the same underlying data, those two representations do not offer the network the same performance.
The polar projection has been shown to be harder to learn from.
Also, both Cartesian and polar projections lead to more unstable training compared to the interaural features.
The number of epochs had to be increased from 100 to 200 to reach proper convergence.
On the other hand, further processing the #acr("STFT") into the binaural features does not seem to improve performance.
// Unsurprisingly, displaying phase-related information directly rather than indirectly seems to matter the most.
// Both the polar #acr("STFT") and interaural features explicitly contain this phase:
// The former by $arg(L)$ and $arg(R)$ on two distinct channels and the latter by the ratio $arg(L) / arg(R)$ on a single one.
// $L$ and $R$ denote the spectrograms from the left and right microphones, respectively.

To further prove this hypothesis, an ablation study is performed.
The objective involves showing whether phase-related features alone are sufficient to perform localization efficiently.
Results are in the bottom half of @table:ssl:single_source:input_features.
They show that limiting the input information to phase information does not dramatically penalize the localization performance.
On the other hand, going with the sole magnitude measurements leads to an absolute error approaching 40°.
Also, it naturally appears that employing both the magnitude and phase information is preferable.
//Paradoxically, such filtering of the input data even achieves results slightly better than those obtained when using the full features.
//This further confirms that the rest of the features is fully redundant.

//Interestingly, solely using the #acr("ILD") matrix yields a promising #mae-theta of 2.39° which shows that our model manages to leverage the difference in amplitude between the two channels for performing localization.

// However, those results are less consistent across several runs than the ones using #acr("IPD") or the phase of the #acrpl("STFT").
// Lastly, providing the only magnitude of the #acrpl("STFT") does not lead to comparable performance with a #mae-theta of 14.73 at best.
// 
// Considering their satisfying results, the interaural features will be kept as the baseline method for the rest of the study.


==== Distance estimation

#acr("DoA") estimation has historically been the focus of the #acr("SSL") literature.
Indeed, predicting the distance to a sound source is known to be a significantly more challenging problem @grumiaux_survey_2021.
As the proposed architecture and methodology also support distance estimation, some experimental attempts were made with the combined objective (@eq:ssl:single_source:total_loss).

Our results have confirmed that predicting the distance was less accessible for our neural network.
@table:ssl:single_source:distance_estimation shows the combined localization performance for two microphone arrays (binaural and triangle).
The obtained results are not satisfying, as the mean absolute error in distance estimation (#mae-dist) is over 70cm in the best-case scenario.
Also, control experiments were included in @table:ssl:single_source:distance_estimation to highlight the negative influence of distance estimation on the #acr("DoA") error.

#include "tables/distance_estimation.typ"

Finally, a closer observation of the training behavior suggests an overfitting phenomenon.
Indeed, the network achieves a significantly lower error on distance estimation on the training set than on the test set.
The #mae-dist reaches 17cm on the training set when using the triangle array, while it stagnates to 74cm on the validation and test datasets.

#figure(
  image(
    "figures/dist_error.svg",
    width: 80%
  ),
  caption: [
    Evolution of the mean absolute error on the distance estimation #mae-dist during training.
  ],
)


==== Reverberation

#acr("SSL") methods leverage the inter-channel differences present in the time-frequency input data to infer the source position.
As discussed in @sec:simulator:background:spectral-features, these interaural features are theoretically sufficient to infer the #acr("DoA") of a single sound source.
This result does not hold in a reverberant environment where sound reflections deteriorate the direct relationship between the recorded waveform and the direction of arrival.
Performing #acr("SSL") in reverberant environments remains a core challenge for the acoustic research community.
Thanks to our simulation library, we have generated datasets from different reverberation settings.
A neural network has been trained from scratch on each of these datasets before being evaluated on the corresponding test set.
Experimental results are summarized in @table:ssl:single_source:reverb.
Naturally, our method achieves very accurate localization in low-reverberation scenarios.
Although performance certainly suffers from an increase of the reverberation time $T_60$, we noticed that the proposed method remained robust to reverberation.
Even in highly reverberant scenarios, the #acr("MAE") remains inferior to 30°.
This shows that the network succeeds in filtering out the direct path information from the recorded signal's early and late reverberation artifacts.

#include "tables/reverb.typ"

// ==== Sound Source Localization in noisy environments
// <sec:ssl:single_source:experiments:noise>
// 
// Having succeeded at accurately estimating the #acr("DoA") in a reverberant but noiseless setting, we have attempted to add noise sources.
// The latter has revealed to harden the task significantly.
// We have focused on noises of basic nature: white noise and music.
// Both share the property of noticeably differing from a speech signal in its fundamental acoustic nature.
// // Having a parasite speech
// 
// // Which kinds of noises
// 
// $
//   E(S) = sum_(t=1)^T sum_(f=1)^F
//     abs(S(t, f))^2
// $
// 
// $
//   #snr = 10 log_10 (E(S_"speech") / E(S_"noise"))
// $
// 