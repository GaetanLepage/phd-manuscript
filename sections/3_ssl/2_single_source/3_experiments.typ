#import "/utils.typ": *
#import "_notations.typ": *


=== Experiments
<sec:ssl:single_source:experiments>

This section presents a collection of experimental results on #acr("SSL") performance.
This study aims to understand the influence of specific parameters on the difficulty of the #acr("SSL") task.
For this purpose, a baseline solution and scenario are described and will serve as a reference point for the tested variations.
First, the general testing methodology and metrics will be presented.
The actual experimental results, including quantitative results, will follow.


==== Metrics
<sec:ssl:single_source:experiments:metrics>

In this first formulation of the #acr("SSL") problem, each situation includes exactly one source to localize.

*#acr("DoA") metric.*
Naturally, the performance of the method is characterized by how far the estimate $hat(theta)$ lies from the real #acr("DoA") value $theta$.
As the network predicts the sine and cosine of $theta$, the #acr("DoA") value is first computed following:
$
  hat(theta) &= op("atan2")
    lr(
      (sin(hat(theta)), cos(hat(theta)))
      , size: #150%
    )\
  &= arg lr(
      (
        cos(hat(theta))
        + i sin(hat(theta))
      ),
      size: #150%
    ).
$

#block(breakable: false)[
  We then compute the average $ell^1$ angular distance #d between $hat(theta)$ and $theta$.
  The following expression for #d accounts for the periodicity of the angular interval $[-pi, pi]$:
  //As both the predicted and ground-truth #acr("DoA") values are constrained to the $[-pi, pi]$ interval.
  #func-def(
    d,
    $[-pi, pi]^2$,
    $[0, 1]$,
    $(theta_1, theta_2)$,
    //$pi - abs(abs(theta_2 - theta_1) - pi)$
    $pi - lr(abs(abs(theta_2 - theta_1) - pi), size: #150%).$
  )
  <eq:ssl:single_source:angular_dist>
  ]
#block(breakable: false)[
  This distance is used to define the #acr("MAE") metric that quantifies the performance of #acr("DoA") estimation:
  $
    #mae-theta = 1 / n_"test" sum_(i=1) ^ n_"test" #d (hat(theta)_i, theta_i),
  $
  <eq:ssl:single_source:mae>
  where $n_"test"$ counts the number of samples in the test set.
]


*Source-array distance metric.*
When predicting the source-array distance, the #acr("MAE") is also used, here between predicted $hat(D)$ values and ground truth $D$:
$
  #mae-dist = 1 / n_"test" sum_(i=1) ^ n_"test"
  abs(hat(D)_i - D_i).
$ <eq:ssl:single_source:dist_metric>


The choice of the #acr("MAE") as performance criteria has the advantage of being expressed in length units.
For clarity reasons, the values for this metric will be displayed in centimeters (cm).
// TODO: check that we have indeed used cm.


==== Base Solution and General Methodology

This study investigates how different parameters influence the performance of our #acr("SSL") pipeline.
A baseline must be defined to have a reference for comparing experimental settings.
The starting setting involves a binaural array with two cardioid microphones for the agent.
Microphones are two centimeters apart.
The room's reverberation level ($T_60$) is set to 500ms.
Interaural features (#acr("ILD") + #acr("IPD")) have been chosen for this baseline.
By default, only the #acr("DoA") is predicted, not the distance.
The default number of epochs is set to 100.
This setup is not the best-performing combination, but it provides a credible formulation to start with.
These parameters will be individually changed across the following study.

Furthermore, the following settings are kept fixed across the experiments.
We use a single $4 times 7$ meter room.
Learning parameters, such as the batch size, the learning rate, and the number of epochs, remain constant across most experiments.
Also, the network architecture is common in all runs.
Naturally, the number of input channel is adapted to the shape of the input data.
The number of epochs has been exceptionally increased to reach proper convergence when necessary.
Finally, the network training for each individual configuration was repeated several times to ensure that the obtained results were repeatable.
The reported performance scores correspond to the most successful training run.


==== Microphone Arrays and Layouts

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
The asymmetry of the cardioid pattern helps to discriminate the direction of arrival.
Sound wavefronts coming from the back of a directional microphone are strongly attenuated.
This fundamentally injects additional spatial information into the recorded signal.
Besides the pattern influence, we have noticed that adding microphones substantially improves performance too.
Interestingly, the difference between an omnidirectional and a directional microphone pattern diminishes when dealing with three or more microphone arrays.
Our understanding is that the third microphone provides enough extra information to compensate for each microphone's lack of directionality.
The four-microphone array scores the lowest #acr("MAE").

#include "tables/arrays.typ"

Inter-microphone distance is another fundamental characteristic of a microphone array.
We have experimented with the influence of the microphone spacing in a binaural array on performance.
@table:ssl:single_source:mic_dist displays the results of this study.
Increasing the distance between microphones appears to be detrimental to the localization accuracy.
When microphones are further apart, the aliasing phenomenon becomes problematic and deteriorates the relationship between the recorded signal and the source positions.
Indeed, if the spacing amounts to $d$ meters, all frequencies above $f_0 = c / (2 d)$ Hz cannot be adequately distinguished.
For $d=2$ cm, this maximum frequency is 8.575 kHz, while most of human speech's frequencial content is below 5 kHz @hollien_phonational_1971.
Further lowering the distance to 1cm does not appear to bring additional benefits.


#include "tables/mic_dist.typ"


==== Impact of Input Signal Representation
<sec:ssl:single_source:experiments:pre-processing>


To measure the impact of the input representation, we run the training process with each aforementioned encoding choice (see @sec:ssl:single_source:method:pre-processing).
The number of channels depends on the selected method and varies from 1 to 4.
The network architecture's first convolutional layer is naturally scaled in consequence.

#include "tables/input_features.typ"


// TODO: Hence, the choice of the encoding method for the acoustic data has a substantial impact on the difficulty of this task.
@table:ssl:single_source:input_features summarizes the method's performance using different input features.
We report the corresponding channel dimension of the resulting tensor for each set of cues.
On the one hand, both complex-to-real #acr("STFT") polar and Cartesian mappings yield substantially different results.
Indeed, despite having the same underlying data, those two representations do not offer the network the same performance.
The polar projection proved to be harder to learn from.
Also, both Cartesian and polar projections lead to more unstable training compared to the interaural features.
The Cartesian features perform the same as the interaural ones in training but lead to a less robust convergence on the validation set.
Despite the final performance being comparable, training our neural network on interaural features is significantly more repeatable and robust.
Hence, the #acr("ILD") #acr("IPD") combination is shown to generalize better and have stronger stability.
@fig:ssl:single_source:input_features illustrates the training dynamics for the three types of features.
The discrepancy between training and validation for the Cartesian projection of the #acr("STFT") appears clearly.
We trained the network for 100 epochs in all three cases.
The number of epochs was later increased from 100 to 200 to attempt reaching a more stable training regime.
The #mae-theta reported in @table:ssl:single_source:input_features results from this longer training time.
However, the loss behavior was equally unstable, and the network achieved competitive metrics at the end of the training.
This contrasts with the interaural features experiments, where strong accuracy is already reached after a few epochs.
Normalization could be a potential explanation for these inconsistencies.
No additional pre-processing was applied in this study.
Additional normalization schemes might boost the network's performance, generalization, and stability.
Daniel Stoller @stoller_spectrogram_2017 presents two strategies for spectrogram normalization.

//On the other hand, further processing the #acr("STFT") into the binaural features does not seem to improve performance.
// Unsurprisingly, displaying phase-related information directly rather than indirectly seems to matter the most.
// Both the polar #acr("STFT") and interaural features explicitly contain this phase:
// The former by $arg(L)$ and $arg(R)$ on two distinct channels and the latter by the ratio $arg(L) / arg(R)$ on a single one.
// $L$ and $R$ denote the spectrograms from the left and right microphones, respectively.

#include "figures/input_features_loss/figure.typ"

Furthermore, we have explored the relative importance of the individual sub-features for each category.
The network was retrained with more granular features.
The results are presented in the bottom half of @table:ssl:single_source:input_features.
Regarding interaural features, neither #acr("ILD") nor #acr("IPD") appears to be fully redundant.
Each sub-feature performs worse than the #acr("ILD")-#acr("IPD") combo referred to as _Interaural features_ above.
Yet, #acr("IPD") allows for a lower #mae-theta compared to using #acr("IPD") only.
This observation is reasonable as #acr("IPD") is directly correlated to the #acr("TDoA") and thus the #acr("DoA").
Besides, regarding the sub-features of the polar #acr("STFT") representation, we notice a low drop in performance when discarding the magnitude information.
While the complete solar #acr("STFT") features allow for an #mae-theta of 25.7°, using the sole phase spectrogram only worsens it by 2.3°.

In conclusion, we have shown that it is highly important to carefully choose a pre-processing strategy when training a deep neural network for #acr("SSL").
While the information content is theoretically the same across different bijective transformations of the complex #acr("STFT") performance, some can be harder to learn from.
Our experimental results suggest that interaural features offer the best performance and stability.

==== Distance Estimation

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
When using the triangle array, the #mae-dist reaches 17cm on the training set, while it stagnates at 74cm on the validation and test datasets.
As discussed in @sec:ssl:background, methods that can accurately estimate the distance to the source often rely on additional temporal information or even controlled movement of the microphone array.
It appears that the proposed #acr("CNN")-based method presented in this work cannot solve this task.
In @chap:active_ssl, we leverage robot movement to accumulate localization information over time and accurately estimate the source's position.

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

#acr("SSL") methods leverage the inter-channel differences in the time-frequency input data to infer the source position.
As discussed in @sec:simulator:background:spectral-features, these interaural features are theoretically sufficient to infer a single sound source's #acr("DoA").
This result does not hold in a reverberant environment where sound reflections deteriorate the direct relationship between the recorded waveform and the direction of arrival.
Performing #acr("SSL") in reverberant environments remains a core challenge for the acoustic research community.
We have generated datasets from different reverberation settings thanks to our simulation library.
A neural network has been trained from scratch on these individual datasets before being evaluated on the corresponding test set.
Experimental results are summarized in @table:ssl:single_source:reverb.
Naturally, our method achieves very accurate localization in low-reverberation scenarios.
These results demonstrate the challenge of operating #acr("SSL") in reverberant environments.
Notably, there is a 10x factor between performance at $T_60=100$ms and the performance at $T_60=1$s.
@fig:ssl:single_source:reverb illustrates the quasi-linear relation between the #mae-theta and the reverberation level $T_60$.
Although performance certainly suffers from an increase of the reverberation time $T_60$, we noticed that the proposed method remained robust to reverberation.
Even in highly reverberant scenarios, the #acr("MAE") remains inferior to 30°.
This shows that the network successfully filters out the direct path information from the recorded signal's early and late reverberation artifacts.
Furthermore, we demonstrate that a simple #acr("CNN") architecture can perform accurate localization in challenging reverberation conditions.

#figure(
  image("figures/ssl_reverb.svg", width: 80%),
  caption: [
    Reverberation impact on #acr("SSL") performance.
  ]
)
<fig:ssl:single_source:reverb>

#include "tables/reverb.typ"