#import "/utils.typ": *
#import "2_method.typ": tau-e
#import "_notations.typ": *

=== Experiments
<sec:ssl:multi_source:experiments>

// QUESTION: Should we mention the experiments made on the ILD/IPD binaural setup ?

==== Metrics

To evaluate the performance of the proposed #acr("SSL") method, a total of four metrics are computed.
Each pair of metrics targets a different task.

*Known number of sources.*
In this first task, the number of active sources is assumed to be known.
@eq:ssl:multi_source:decoding_known_sources is then used to perform the decoding of the neural network output.
This process ensures that the number of detections matches the number of ground-truth sources and allows the computation of the following two metrics.

- The _#acr("MAE")_ gives an idea about the angular distance between detected and correct angles:
$
  "MAE" = (
    sum_i
    sum_(j=1)^(z_i)
    #d (
      hat(phi.alt)_(i j),
      phi.alt_(i j)
    )
  ) / (sum_i z_i),
$
<eq:ssl:multi_source:mae>

where #d refers to the symmetric angular distance defined in @eq:ssl:single_source:angular_dist.
The #acr("MAE") will most often be expressed in degrees for convenience.

The _#acr("ACC")_ constitutes the second metric for this framework and, given an error threshold #angle-error-threshold, provides the proportion of correctly localized sources:
$
  "ACC" = (
    sum_i
    sum_(j=1)^(z_i)
    bb(1)_(
      #d (
        hat(phi.alt)_(i j),
        phi.alt_(i j)
      ) < #angle-error-threshold
    )
  ) / (sum_i z_i).
$
<eq:ssl:multi_source:acc>

*Unknown number of sources.*
The second task also evaluates the model's ability to accurately predict an unknown number of #doa values.
Such a setup resembles a conventional single-class detection problem in the computer vision literature.
In this case, the matching between ground truth #doa angles $y_i = {phi.alt_(i j): j = 1, dots, z_i}$ and the predictions $hat(y)_i = {phi.alt_(i k): k = 1, dots, hat(z)_i}$ extracted by applying @eq:ssl:multi_source:decoding_unknown_sources might be incomplete, i.e. $hat(z)_i != z_i$.

The following function denotes a positive match:
$
  m(
    hat(phi.alt)_(i k),
    phi.alt_(i j)
  ) = cases(
    1
      "if"
        d(hat(phi.alt)_(i k), phi.alt_(i j)) < E_a "and" k = limits("argmin")_(k in {1, dots, hat(z_i)})  d(hat(phi.alt)_(i k), phi.alt_(i j)),
    0 "otherwise,"
  )
$
We may then introduce the two metrics used in this framework: _Precision_ and _Recall_:
$
  "Precision" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(phi.alt)_(i k),
      phi.alt_(i j)
    )
  ) / (sum_i hat(z)_i),
$
<eq:ssl:multi_source:prec>

$
  "Recall" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(phi.alt)_(i k),
      phi.alt_(i j)
    )
  ) / (sum_i z_i).
$
<eq:ssl:multi_source:recall>

As an important note, those two scenarios are used to grasp the overall performance of a given model.
The method stays the same in both cases as solely the extraction of the prediction employs either @eq:ssl:multi_source:decoding_unknown_sources or @eq:ssl:multi_source:decoding_known_sources.

==== Loss and Convergence
<sec:ssl:multi_source:experiments:loss>

*Loss function.*
The objective used by He et al. in @he_deep_2018 along their #doa encoding is a simple #acr("MSE") loss between the ground truth #doa representation and the output vector provided by the neural network:
$
  cal(L) (hat(o), o) = norm(hat(o) - o)_2^2 med.
$
<eq:ssl:multi_source:loss_function>

*Sub-Optimal Convergence*

// Impact of BS and LR
*Local minimum.*
Several experiments were conducted to identify working hyperparameters for the proposed #acr("SSL") method.
An interesting observation has been the impact of the learning rate and batch size combination.
Theoretically, a larger batch size leads to more accurate gradients and thus, more sensible parameter updates.
This also allows for an increase in the learning rate and a reduction in overall training steps.
In most cases, the acceleration hardware and its inherently finite memory capacity dictate the limit for the maximum usable batch size.
However, in our situation, a different restraining factor has been observed.
There exists a trivial local optimum for the #acr("SSL") task defined as a #doa spatial spectrum regression.
Indeed, because of the relative sparsity of the ground truth encoding, a method outputting a plain zero spectrum achieves a comparatively low loss.
More precisely, the loss for the samples would approximately equal the area under $n_s$ distinct Gaussians.
Some limited mass placed randomly on the $[-pi, pi]$ interval would likely not overlap with the ground-truth Gaussians.
The loss would most often approach its upper bound:
#let gt = $colMath(o, #blue)$
#let pred = $colMath(hat(o), #red)$
$
  0 <= cal(L) (#gt, #pred) lt cal(L) (#gt, 0) + cal(L) (#pred, 0).
$

#figure(
  include("figures/loss_illustration.typ"),
  caption: flex-caption(
      short: [
        Illustrative example of a poor network prediction and the corresponding ground truth spectrum.
      ],
      long: [
        Illustrative example of a poor network prediction (in red) and the corresponding ground truth spectrum (in violet).
      ],
    ),
)
<fig:ssl:multi_source:loss_illustration>


From this observation, the strategy of enforcing $#pred = 0$ ensures the loss will never exceed $cal(L) (#gt, 0)$.
To prevent this phenomenon from occurring, both the batch size and the learning rate needed to be carefully chosen.
To empirically illustrate this behavior, we monitor in @fig:ssl:multi_source:output_norm_plot the $ell^2$ norm $norm(o)_2^2$ of the network output, defined by:
$
  norm(o)_2^2 = 1 / d sum_(i=1) ^d o_i^2,
$
along a successful training process.

#figure(
  image("figures/301_energy-loss.svg"),
  caption: flex-caption(
    short: [
      Evolution of the norm of the network output and loss during training.
    ],
    long: [
      Evolution of the norm of the network output $norm(o)_2^2$ (orange) and loss (blue) during training.
    ],
  ),
) <fig:ssl:multi_source:output_norm_plot>

We can distinguish two distinct phases:
- First, the network exploits a trivial local optimum, which entails predicting a null output.
  Both the loss and the output norm reach stable values.
- Subsequently, from the 50,000th step onward, the model escapes this plateau and successfully learns to solve the regression task.

When using too important batch sizes or too aggressive learning rates, the model indefinitely stagnates, keeping predicting zeros.
Keskar et al. @keskar_large-batch_2017 have documented the adverse effects that large batch sizes could have on generalization performance.

Identifying, characterizing, and overcoming this shortcoming was essential in developing this model.

==== Performance Evaluation
<sec:ssl:multi_source:experiments:performance_eval>

*Impact of the number of sources.*
As explained in @sec:ssl:multi_source:method:dataset, the dataset allows for dynamically selecting a subset of 0 to 4 sources at runtime.
This feature has allowed us to experiment with the impact of how many sources are present in the room simultaneously.

*Training frameworks.*
On the one hand, the two following training setups can be compared:
- _Scenario A_ is the setup proposed in @he_neural_2021 with the following repartition of samples:
  - 0 sources: 20%,
  - 1 source: 40%,
  - 2 sources: 30%,
  - 3 sources: 5%,
  - 4 sources: 5%.
- _Scenario B_ uniformly chooses a number of sources between one and four for each sample. Thus, it is more challenging as at least one source is always present in the room, and significantly more samples present 3 or 4 sources.

As no artificial noise is added to the speech sources' signals, the training dataset in _scenario A_ brings exactly 160k identical samples, whose observation tensor is null.
Once the network successfully learns that it should output a zero-vector for those trivial samples, they will not contribute to increasing or lowering the detection scores.

Furthermore, the more sources are simultaneously present in the room, the more challenging it becomes to localize them properly.
@table:ssl:multi_source:experiments:n_sources_train displays the final performance of models trained on datasets corresponding to each scenario.

#include "tables/n_sources_train.typ"

One should note that both training and test datasets are different.
The goal of this experiment is to highlight the consequential impact that the problem formulation can have on performance.
Notably, it compares both aforementioned scenarios
The rest of the experiments have been conducted with respect to _Scenario A_, following the same distribution of source numbers as He et al. used in @he_neural_2021.

*Evaluation frameworks.*
We have evaluated a given network in various scenarios to understand the impact of the number of concurrent sources in the room on performance.
The network has been trained according to the _scenario A_ presented above.
@table:ssl:multi_source:experiments:n_sources summarizes the performance on the aforementioned model in different evaluation scenarios.
We observe that the fewer the number of active sources, the higher the performance.
Even when evaluating the model in the hardest scenario, where four sources are always active at the same time, #acr("MAE") remains lower than 22°.
However, accuracy and recall suffer in those challenging situations.

#include "tables/n_sources.typ"

==== $epsilon$-Loss

We propose an original modification of the loss function.
The motivation comes from the observation that the target #doa spatial spectrum is sparse (see @fig:ssl:multi_source:doa_gt_encoding for instance).
This causes the active part of the spectrum to have a limited impact on the gradients.
As seen previously, we use a simple #acr("MSE") loss for the cost function.
Hence, predicting high activation will be heavily penalized as it will statistically correspond to false positives.
However, predicting overall low values will not lead to high loss values as the ground truth spectrogram is primarily flat.
This leads to the sub-optimal convergence phenomenon described in @sec:ssl:multi_source:experiments:loss.
The naive #acr("MSE") loss does not prioritize the supervision in the active region of the spectrogram.
We have attempted to circumvent this by more aggressively penalizing the sections of the spatial spectrum where sources are effectively present.
To circumvent this phenomenon, we introduce the following $epsilon$-loss:
#let damp-term = $colMath((o_i + epsilon), #maroon)$
$
  cal(L)_epsilon (hat(o)_i, o_i) =
    1/d sum_(i=1)^d
    #damp-term
    (hat(o)_i - o_i)^2.
$
<eq:ssl:multi_source:experiments:epsilon_loss>
The damping term #damp-term reduces the penalization of false positive peaks in the estimated spectrogram.
In a region of the spectrum where no sources are effectively present, i.e., where $o approx 0$, the loss value will be bounded by $epsilon$.

#include "tables/epsilon_loss.typ"

@table:ssl:multi_source:experiments:epsilon_loss summarizes the performance of our model after being trained with the $epsilon$-loss.
More precisely, we compare different values of $epsilon$ to better measure its influence on performance.
A baseline corresponding to the #acr("MSE") loss is also included for comparison.
This ablation study suggests that a value of $epsilon = 0.4$ improves the #acr("MAE") and accuracy scores at the expense of losing some precision points.
A value closer to 0.1 slightly boosts the recall, too, but comes with an important dip in precision.
Also, this choice has an impact on the training dynamics.
The $epsilon$ loss seems to shorten the initial stagnating phase of the training process, where the validation loss sees no improvement.
When training with the #acr("MSE"), the loss only starts improving after 50 to 60k steps, while this number falls to 16k steps when using the $epsilon$ loss.
Unfortunately, the behavior of the $epsilon$ loss remains unclear in some aspects.
Overall, its benefits are not satisfying enough to be included in the final method.
Notably, its impact on precision is detrimental to the overall performance.


==== Normalization <sec:ssl:multi_source:experiments:normalization>

*Background*

Various schemes of normalization have been used in Deep Neural Networks.
They address the phenomenon of _internal covariate shift_, which appears as architectures deepen.
This problem comes from the change in the distribution of each layer's inputs during training.
Such a drift causes the non-linear activation functions to saturate and harms the learning process.
Normalization also attempts to reduce the effects of mismatch between the training and test dataset distributions.

_#acr("BatchNorm")_, proposed by Ioffe et al. @ioffe_batch_2015, has gathered significant success, especially in the computer vision community.
It entails normalizing the activations within each mini-batch using that mini-batch's own mean and variance.
Acting as a form of regularizer, this process stabilizes learning by ensuring that the values entering all layers do not deviate too significantly.
The data will be distributed according to a standard normal distribution.
The _Batch Normalization Transform_ algorithm is expressed as such:
$
  y_i = colMath(gamma, #blue) [
    (
      x_i
      - colMath(mu_cal(B), #maroon)
    )
    /sqrt(
      colMath(sigma_cal(B)^2, #olive) + epsilon
    )
  ] + colMath(beta, #blue),
$
<eq:ssl:multi_source:batch_norm>
where
- $x_i$ is an individual entry in the mini-batch $cal(B) = {x_1, dots, x_m}$,
- $colMath(mu_cal(B) = 1 / m sum_(i=1)^m x_i, #maroon)$ is the mini-batch mean,
- $colMath(sigma_cal(B)^2 = 1 / m sum_(i=1)^m (x_i - mu_cal(B))^2, #olive)$ is the mini-batch variance,
- $epsilon$ is a constant ensuring numerical stability,
- $colMath(gamma, #blue)$ and $colMath(beta, #blue)$ are learnable parameters.

To be able to perform inference on single samples, i.e., without disposing of an entire mini-batch, substitution statistics are used in place of $colMath(mu_cal(B), #maroon)$ and $colMath(sigma_cal(B)^2, #olive)$.
Indeed, during training, the #acr("BatchNorm") layer will keep updating a running mean and variance to be used at evaluation time.

_#acr("LayerNorm")_ (Ba et al. @ba_layer_2016) follows the same principle but chooses to normalize each sample individually by computing statistics across the features' dimensions.
@fig:ssl:multi_source:normalization displays the differences between both schemes.
Historically, #acr("LayerNorm") has been most commonly employed in Natural Language Processing.

$
  y_(l, i) = colMath(gamma, #blue) [
    (
      x_(l, i)
      - colMath(mu_l, #maroon)
    )
    /sqrt(
      colMath(sigma_l^2, #olive) + epsilon
    )
  ] + colMath(beta, #blue),
$
<eq:ssl:multi_source:batch_norm>
where
- $x_(l, i)$ is an individual hidden unit in the $l$-th layer's inputs $X = {x_(l, 1), dots, x_(l, H)}$,
- $colMath(mu_l = 1 / H sum_(i=1)^H x_(l, i), #maroon)$ is the mean,
- $colMath(sigma_l^2 = 1 / H sum_(i=1)^H (x_(l, i) - mu_l)^2, #olive)$ is the variance,
- $epsilon$ is a constant ensuring numerical stability,
- $colMath(gamma, #blue)$ and $colMath(beta, #blue)$ are learnable parameters.

#figure(
  image("./figures/normalization.png", height: 4cm),
  caption: flex-caption(
    short: [
      A visual comparison of Batch and Layer Normalization.
    ],
    long: [
      A visual comparison of Batch and Layer Normalization, adapted from @wu_group_2018.
    ],
  ),
)
<fig:ssl:multi_source:normalization>

Those two methods have proven effective in training deep neural network architectures.
Ren et al. @ren_normalizing_2017 develop a unified view of the #acr("BatchNorm") and #acr("LayerNorm") schemes.
Furthermore, they proposed a novel addition to better handle sparsity and achieved better results in various downstream tasks.
Similarly, the _PowerNorm_ scheme, introduced by Shen et al. @shen_powernorm_2020, attempts to circumvent the identified weaknesses of the existing normalization schemes when applied to the transformer architecture.
Those works further demonstrate the importance of normalization in deep neural networks.

*Experiments*

Although He et al. chose to use #acr("BatchNorm") in their work, our final architecture employs the more flexible #acr("LayerNorm").
The choice of the normalization scheme ended up being crucial to achieving good performance.
We observed that the latter yielded the same stabilization benefits during training while removing the dependence on the batch size.

@fig:ssl:multi_source:normalization_plots illustrates the evolution of the training and validation accuracy during training for different normalization schemes.

#figure(
  image("./figures/normalization_exp.svg"),
  caption: [
    Training and validation accuracies during training for different normalization schemes.
  ]
)
<fig:ssl:multi_source:normalization_plots>

This specific metric clearly exposes the differences between those three choices but the other metrics behave similarly.
Both normalization techniques bring additional stability and performance to the training process.
However, significant differences arise when looking at the validation metrics.
When run in evaluation mode, i.e., using the running statistics gathered during training, the network trained with #acr("BatchNorm") performs poorly compared to training.
This would suggest that the saved means and averages do not adequately account for the differences between the training and validation sets.

Interestingly, evaluating this network's performance while forcing the batch normalization to use the training strategy avoids facing this issue.
Indeed, using the current validation batch statistics instead of those gathered at training time provides results that are on par with the training performance.
This constitutes an essential limitation of batch normalization in this case, as the evaluation thus needs to be performed in a batched manner.
@table:ssl:multi_source:experiments:normalization displays the batch size's influence on the network's performance trained with #acr("BatchNorm").


#include "tables/normalization.typ"


Those results depict the positive role played by larger batch sizes for evaluation in _training mode_.
Although in a purely synthetic benchmark, this does not constitute an important drawback, it will become one as soon as the model will be asked to perform one-shot inference.
In our robotics context, the developed #acr("SSL") solution would have to be able to be used in a real-world scenario where an entire batch of observations is not available for inference.

This is what motivated the enhancement of the model using other normalization schemes.
As explained in @sec:ssl:multi_source:experiments:normalization, #acr("LayerNorm") does not encompass this behavioral distinction between training and evaluation.
@table:ssl:multi_source:experiments:normalization also compares the final performance of the layer normalization strategy.

Overall, #acr("LayerNorm") and #acr("BatchNorm") offer comparable performance.
However, the model trained with #acr("LayerNorm") behaves consistently when used in evaluation.
For those reasons, we have preferred this approach over the original one.


==== Exploring How Context Length Matters

The choice of the signal duration used for training the localizer has some importance.
A tradeoff needs to be made between the system's reactivity and detection performance.
Naturally, disposing of longer sequences of input audio is suspected to lead to higher metrics values.
On the other hand, restricting the snippet length even further might hinder the robustness of the results.
Also, when available, a pre-trained method should be able to leverage longer segments of audio to refine its prediction.

To evaluate those assumptions quantitatively, we train our neural network on different context lengths.
Each training dataset has been generated from audio recordings of a given fixed duration, translating into #acr("STFT") tensors of #T-train frames.
As presented in @sec:ssl:multi_source:method:dataset, the baseline duration of used recordings amounts to roughly 320ms of audio ($#T-train = 16$).
Here, training on shorter durations has also been attempted.
We test the models obtained from each value of #T-train on samples of equal or larger durations by performing subsequent forward passes.
This process will be referred to as _sequence processing_.

*Sequence processing.*
The main idea of sequence processing is splitting the longer input audio into $M$ chunks of #T-train frames to be processed individually by the neural network.
$M$ output #doa spectra are thus obtained and must be aggregated.
We average those signals to obtain a single vector:
$
  #averaged-spectrum = 1/M sum_(i=1)^M hat(o)_k #h(1em) in [0, 1]^d.
$
<eq:ssl:multi_source:sequence_averaging>
The flexibility of the #doa spatial spectrum encoding permits the former combination without the need of additional steps.
The detection algorithm can then be applied on the average output.

*Sequence dataset generation.*
#let D-full = $cal(D)_"full"$
To evaluate the performance of the obtained models, a new dataset #D-full is generated.
Instead of saving 16 frames long individual #acr("STFT") chunks, we record the features for recordings of several seconds.
To generate each sample, each active source outputs one recorded sentence from the #librispeech @panayotov_librispeech_2015 dataset.
#acr("STFT")s of the multi-channel signals received by the microphone array from each source are saved independently.
Disposing of features corresponding to several seconds of simulation allows for performing #acr("SSL") on context windows of varying lengths.

#include "figures/sequence_processing/fig.typ"


@fig:ssl:multi_source:sequence_processing illustrates the sequence processing workflow on a single example.
Here, around 16 seconds of continuous speech produced by three distinct static sources get recorded by the microphone array.
The latter also stands at a fixed position in the room.
@fig:ssl:multi_source:sequence_processing:doa_spectrum depicts the averaged #doa spectrum #averaged-spectrum along with the corresponding overall predictions.
On this specific example, the averaging process successfully aggregates the angular information and allows for the accurate localization of all three sources.
More precisely, the top part of @fig:ssl:multi_source:sequence_processing:result displays the network output at each time step.
The gray-scale patches represent the individual estimated #doa spectra $hat(o)_k$.
The resulting predicted angles are highlighted by the red dots.
Finally, the histogram of predictions characterizes the distribution of detections along the process.

Presenting the #acr("SSL") results as such highlights the strengths and weaknesses of the proposed approach.
Even for a single frame, the estimated #doa spectrum allows for precise predictions.
Very few false positives are observed, as confirmed by the several quantitative experiments conducted.
However, individual sources are sometimes missed, maybe because they were not active enough at this specific time.
This drawback gets offset by leveraging the overall consistency of the method over a longer time.

#include "tables/context_length.typ"

In order to further characterize this behavior, we have executed an exhaustive performance evaluation of the sequence processing workflow.
@table:ssl:multi_source:experiments:context_length summarizes the results from the conducted experiments.
Leveraging the aforementioned generated dataset #D-full, containing full audio recordings, it was possible to evaluate multiple models on different context lengths.

For evaluation durations $d_"eval"$ from 21ms to 320ms, we compare models trained on different sub-factors of $T_"eval"$ frames performing _sequence processing_.
A network trained on #acrpl("STFT") of #T-train frames gets evaluated $N_"pass" = T_"eval" / #T-train$ times using the _sequence processing_ method.
The results unsurprisingly suggest that directly training a model on $T_"eval"$ frames will always yield better results than averaging inference results of a model trained on fewer frames.

However, _sequence processing_ still holds value by allowing a given pre-trained network to leverage lengthier recordings.
The base model trained on $#T-train = 16$ samples has been evaluated on signals ranging from 320ms, its base context length, up to more than 10s.
The last row of @table:ssl:multi_source:experiments:context_length comes from an experiment where the entire recordings were provided to the network.
As many forward passes as needed were performed for each sample to exploit the complete data.
It appears clearly that the longer the agent is able to hear, the better its localization performance becomes.
In this way, we account for missed detections and enhance the robustness of the system.

The base context window of 16 #acr("STFT") frames amounts to approximately 320ms, a fairly short period.
During this interval, one or more speech sources could be inactive as the energy criteria $delta_"energy" (#tau-e)$ is not enforced on this specific data set.
This sole difference in the data generation process explains the gap in performance between this experiment and the evaluation on the normal dataset reported in @sec:ssl:multi_source:experiments:performance_eval (see @table:ssl:multi_source:experiments:n_sources for example).



==== Ablation Study on Sources' Angular Proximity

The decoding process, presented in @sec:ssl:multi_source:method:doa_repr, involves extracting the local maxima of the predicted #doa spectrum.
The abscissas of the resulting peaks are considered as the final angle values.
As such, our method is expected to be challenged by samples involving sources with close #doa values.

#let delta-t = $Delta theta_"min"$
Let #delta-t be the angle difference between the two closest sources in terms of their #doa:
$
  #delta-t = min_(i, j in [|1, n_s|]\ i!= j) #d (theta_i, theta_j),
$
where $(theta_i)_(i=1dots n_s)$ are the real #doa values for this sample and #d is the angle distance introduced in @eq:ssl:single_source:angular_dist.
It should be noted that this quantity can only be defined for samples encompassing at least two sources.

#figure(
  image(
    "figures/doa_min_dist_histogram.svg",
    height: 10cm,
  ),
  caption: [
    Distribution of #delta-t for different numbers of active sources.
  ]
)
<fig:ssl:multi_source:experiments:doa_min_dist_hist>

From a single original dataset, generated with $n_s = 4$ sources active in each of the 8000 samples, #delta-t is evaluated in three cases.
In the first scenario, all four sources remain active, and the four corresponding #doa values are used to compute #delta-t.
On the other two, only two (respectively three) random sources are enabled simultaneously in every sample.
@fig:ssl:multi_source:experiments:doa_min_dist_hist depicts the distribution of #delta-t depending on this number of active sources.
Naturally, when only two sources are present concurrently, high values of #delta-t remain likely.
Yet, increasing the number of sources tends to decrease their likelihood, and the minimum #doa gap more often reaches lower values.
Hence, the correlation between the number of sources and the difficulty of the #acr("SSL") task highlighted in @sec:ssl:multi_source:experiments:performance_eval might be caused by two underlying reasons.
On the one hand, the model is expected to extract each speaker's location from the mixture of speech signals that constitute its input.
An increase in the number of sources inherently hardens this task.
On the other hand, low #delta-t samples also become more frequent, which could contribute to hindering proper localization by itself.

To empirically study the impact of #delta-t on the #acr("SSL") performance, the model trained on a regular dataset has been evaluated on specific test cases.
Each test dataset ensures that it respects a lower bound #tau-doa such that $#delta-t >= #tau-doa$ for all samples.
Also, the number of sources is fixed to $n_s = 4$ to best isolate the influence of #delta-t on the results.

#include "tables/min_doa.typ"

@fig:ssl:multi_source:experiments:doa_min_dist_hist_2 plots the distribution of #delta-t of all four test datasets.

The pre-trained model's performance on each scenario is summarized in @table:ssl:multi_source:experiments:min_doa.
Although #acr("MAE") and Precision do not show to be meaningfully affected by #delta-t, Accuracy and Recall improve by 6.5 and 11 points, respectively, across this range of scenarios.
This observation confirms that samples with very low #delta-t constitute more difficult cases.

#figure(
  image(
    "figures/doa_min_dist_histogram_2.svg",
    height: 10cm,
  ),
  caption: [
    Distribution of #delta-t for different values of #tau-doa.
  ]
)
<fig:ssl:multi_source:experiments:doa_min_dist_hist_2>
