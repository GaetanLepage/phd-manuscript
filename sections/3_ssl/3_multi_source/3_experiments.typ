#import "/utils.typ": *
#import "2_method.typ": tau-e

#let header-mae = [MAE (°) #sym.arrow.b]
#let header-acc = [Accuracy (%) #sym.arrow.t]
#let header-prec = [Precision (%) #sym.arrow.t]
#let header-recall = [Recall (%) #sym.arrow.t]

=== Experiments and results

// QUESTION: Should we mention the experiments made on the ILD/IPD binaural setup ?

==== Metrics

To evaluate the performance of the proposed #acr("SSL") method, a total of four metrics are computed.
They provide from two distinct setups.

*Known number of sources.*
In this first task, the number of active sources is assumed to be known.
@eq:ssl:multi_source:decoding_known_sources is then used to perform the decoding of the neural network output.
This process ensures to output as many detections as there are ground truth sources and allows to compute the two following metrics:

- The _#acr("MAE")_ gives an idea about the angular distance between detected and correct angles:
$ "MAE" = (
  sum_i
  sum_(j=1)^(z_i)
  colMath(d, #maroon) (
    hat(phi.alt)_(i j),
    phi.alt_(i j)
  )
)/(
  sum_i z_i
) $ <eq:ssl:multi_source:mae>
where  $colMath(d, #maroon)$ refers to the symmetric angular distance defined in @eq:ssl:multi_source:symmetric_angular_dist.
For convenience, the #acr("MAE") will most often be expressed in degrees:
$
  "MAE"° = 180 / pi "MAE"
$
#gaet[Not sure that the above equation is needed at all.]

The _#acr("ACC")_ constitutes the second metric for this framework and, given an error threshold $colMath(E_a, #eastern)$, provides the proportion of correctly localized sources:
$ "ACC" = (
  sum_i
  sum_(j=1)^(z_i)
  bb(1)_(
    colMath(d, #maroon)(
      hat(phi.alt)_(i j),
      phi.alt_(i j)
    ) < colMath(E_a, #eastern)
  )
)/(
  sum_i z_i
) $ <eq:ssl:multi_source:acc>

*Unknown number of sources.*
Besides, the second task evaluates the ability of the model to accurately predict an unknown number of #acr("DoA") values.
Such a setup resembles a conventional single-class detection problem, such as present in the computer vision literature.
In this case, the matching between ground truth #acr("DoA") angles $y_i = {phi.alt_(i j): j = 1, dots, z_i}$ and the predictions $hat(y)_i = {phi.alt_(i k): k = 1, dots, hat(z)_i}$ extracted by applying @eq:ssl:multi_source:decoding_unknown_sources might be incomplete, i.e. $hat(z)_i != z_i$.

The following function denotes a positive match:
$
  m(
    hat(phi.alt)_(i k),
    phi.alt_(i j)
  ) = cases(
    1
      &"if"
        d(hat(phi.alt)_(i k), phi.alt_(i j)) < E_a
        "and"\
        & k = limits("argmin")_(k in {1, dots, hat(z_i)})  d(hat(phi.alt)_(i k), phi.alt_(i j)),
    0 "otherwise"
  )
$

We may then introduce the two metrics used in this framework: _Precision_ and _Recall_:
$ "Precision" = (
  sum_i
  sum_(j=1)^(z_i)
  sum_(k=1)^(hat(z)_i)
  m(
    hat(phi.alt)_(i k),
    phi.alt_(i j)
  )
)/(
  sum_i hat(z)_i
) $ <eq:ssl:multi_source:prec>

$ "Recall" = (
  sum_i
  sum_(j=1)^(z_i)
  sum_(k=1)^(hat(z)_i)
  m(
    hat(phi.alt)_(i k),
    phi.alt_(i j)
  )
)/(
  sum_i z_i
) $ <eq:ssl:multi_source:recall>

As an important note, those two scenarios are used to grasp the overall performance of a given model.
The method stays the same in both cases as solely the extraction of the prediction employs either @eq:ssl:multi_source:decoding_unknown_sources or @eq:ssl:multi_source:decoding_known_sources.

#gaet[
  Again, should I go as far as explaining the GT-predictions matching algorithm ?
]

==== Loss and convergence <sec:ssl:multi_source:experiments:loss>

*Loss function.*
The objective used by He et al. in @he_deep_2018 along their #acr("DoA") encoding is a simple #acr("MSE") loss between the ground truth #acr("DoA") representation and the output vector provided by the neural network:
$
  cal(L) (hat(o), o) = norm(hat(o) - o)_2^2
$ <eq:ssl:multi_source:loss_function>
#gaet[
  Technically, this equation does not illustrate the _mean_ aspect of the MSE.
  If we want to add the $sum_(i=1)^n 1/n dots$ in front, then we should do it consistently everywhere.\
  I personally think that it is more readable to concentrate on the core formula for the loss between two samples. Of course it will be reduced using an average.
]

===== Sub-optimal convergence

#gaet[This should go in the _Results_ section... maybe as well as this entire _Training strategy_ section]
// Impact of BS and LR
*Local minimum.*
#draft[TODO: this is the motivation for trying the $epsilon$-loss initially].
Several experiments were conducted to identify working hyperparameters for the proposed #acr("SSL") method.
An interesting observation has been the impact of the learning rate batch size combination.
Theoretically, a larger batch size leads to more accurate gradients and thus, more sensible parameter updates.
This also allows for increasing the learning rate and reducing the number of overall training steps.
In most cases, the acceleration hardware and its inherently finite memory capacity dictates the limit for the maximum usable batch size.
However, in our situation, a different restraining factor has been observed.
There exists a trivial local optimum for the #acr("SSL") task defined as a #acr("DoA") spatial spectrum regression.
Indeed, because of the relative sparsity of the ground truth encoding, a method outputting a plain zero spectrum achieves a comparatively low loss.
More precisely, the loss for the samples would approximately equal the area under $n_s$ distinct gaussians.
Some limited mass placed randomly on the $[-pi, pi]$ interval would likely not be overlapping with the ground-truth gaussians.
The loss would most often approach its upper bound:
#let gt = $colMath(o, #blue)$
#let pred = $colMath(hat(o), #red)$
$
  0 <= cal(L) (#gt, #pred) lt cal(L) (#gt, 0) + cal(L) (#pred, 0)
$

#figure(
  include("figures/loss_illustration.typ"),
  caption: [
    Fictive example of a poor network prediction (in red) prediction along with the corresponding ground truth spectrum (in violet)
  ],
) <fig:ssl:multi_source:loss_illustration>


From this observation, the strategy of enforcing $#pred = 0$, ensures the loss will never exceed $cal(L) (#gt, 0)$.
A careful choice of both the batch size and the learning rate were necessary to prevent this phenomenon for happening.
To empirically illustrate this behavior, we monitor in @fig:ssl:multi_source:output_norm_plot the $cal(l)^2$ norm $norm(o)_2^2$ of the network output, defined by 

$
  norm(o)_2^2 = 1 / d sum_(i=1) ^d o_i^2
$
along a successful training process.

#figure(
  image("figures/301_energy-loss.svg"),
  caption: flex-caption(
    [Evolution of the norm of the network output $norm(o)_2^2$ (orange) and loss (blue) during training],
    [Evolution of the norm of the network output and loss during training],
  ),
) <fig:ssl:multi_source:output_norm_plot>

We can distinguish two distinct phases.
- First, the network exploits the trivial local optima consisting in predicting a null output.
  Both the loss and the output norm reach stable values.
- Subsequently, from the 50k-th step, the model escapes from this plateau and learns to successfully solve the regression task.

When using too important batch sizes or too aggressive learning rates, the model indefinitely stagnates, keeping predicting zeros.
Keskar et al. @keskar_large-batch_2017 have documented the negative effects that large batch sizes could have on generalization performance.

#gaet[Ideally, this would benefit from more exhaustive experiments, especially regarding the use of LR scheduling...]

Identifying, characterizing and overcoming this shortcoming has been an essential step in the development of this model.


#gaet[
  I am not really sure on how to layout the whole _Results_ section.\
  Should we have a dedicated paragraph just to show the (best) results, in the default scenario ?
]
==== Performance evaluation
// TODO: we can not really compare with the original authors as they evaluated on real data.

// TODO give the value we have chosen for E_a

// TODO PR-curves

===== Impact of the number of sources <sec:ssl:multi_source:experiments:number_of_sources>

#gaet[Should _zero_ and _four_ be written using the digit directly ?]
As explained in @sec:ssl:multi_source:method:dataset, the dataset allows for dynamically selecting a subset of zero to four sources at runtime.
This features has allowed us to experiment with the impact of how many sources are present in the room simultaneously.

#gaet[
  According to Chris, this is not that relevant
]
#draft[
*Training frameworks.*
On the one hand, the two following training setups can be compared:
- _Scenario A_ is the setup proposed in @he_neural_2021 with the following repartition of samples:
  - 0 sources: 20%,
  - 1 source: 40%,
  - 2 sources: 30%,
  - 3 sources: 5%,
  - 4 sources: 5%.
- _Scenario B_ uniformly chooses a number of sources between 1 and 4 for each sample. Thus, it is more challenging as at least one source is always present in the room, and significantly more samples present 3 or 4 sources.

As no artificial noise is added to the speech sources signal, the training dataset in _scenario A_ brings exactly 160k identical samples which observation tensor is null.
Once the network successfully learns that it should output a zero-vector for those trivial samples, they will not contribute either to increasing or lowering the detection scores.

Furthermore, the more sources are simultaneously present in the room, the more challenging it becomes to properly localize them.
@table:ssl:multi_source:experiments:n_sources_train displays the final performance of models trained on datasets corresponding to each scenario.

#figure(
  tablex(
    // SETTINGS
    columns: 3,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [],
    [Dataset A],
    [Dataset B],
    
    midrule,

    // ROWS
    header-mae,     [9.13],  [14.05],
    header-acc,     [71.36], [61.76],
    header-prec,    [80.98], [76.96],
    header-recall,  [69.26], [58.53],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance when trained with different number of sources
  ]
) <table:ssl:multi_source:experiments:n_sources_train>

One should note that both training and test datasets are different.
The goal of this experiment is to highlight the consequential impact that the problem formulation can have on performance.
The rest of the experiments have been conducted with respect to _Scenario A_, following the same distribution of source numbers as He et al used in @he_neural_2021.
]

*Evaluation frameworks.*
For understanding the impact of the number of concurrent sources in the room on performance, we have evaluated a given network in various scenarios.
The network has been trained according to the _scenario A_ presented above.


// Same training with different number of sources
#figure(
  tablex(
    // SETTINGS
    columns: 7,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [],
    [1 source],
    [2 sources],
    [3 sources],
    [4 sources],
    [Scenario A\ (0-4 sources)],
    [Scenario B\ (1-4 sources)],
    
    midrule,

    // ROWS
    header-mae,     [2.59],  [7.26],  [15.89], [21.95], [9.13],  [15.24],
    header-acc,     [88.58], [70.78], [58.18], [50.21], [71.36], [60.52],
    header-prec,    [87.70], [79.56], [74.99], [72.08], [80.99], [76.73],
    header-recall,  [88.70], [68.07], [54.73], [46.22], [69.26], [57.36],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the number of active sources
  ]
)

#draft[
  TODO: make a comparison between performance achieved on single-source SSL.\
  I guess that this 2° MAE is quite close from what the single-source SSL will give.
]

==== $epsilon$-loss

We propose an original modification of the loss function.
The motivation comes from the observation that the target #acr("DoA") spatial spectrum is sparse (see @fig:ssl:multi_source:doa_gt_encoding for instance).
This causes TODO
As seen in @sec:ssl:multi_source:experiments:loss, we use a simple #acr("MSE") loss (@eq:ssl:multi_source:loss_function) for the cost function.

We have made an attempt at adjusting the latter to more aggressively penalize the sections of the spatial spectrum where sources are actually present.

$
  cal(L)_epsilon (hat(o)_i, o_i) =
    1/d sum_(i=1)^d
    colMath((o_i + epsilon), #maroon)
    (hat(o)_i - o_i)^2
$ <eq:ssl:multi_source:epsilon_loss>

#gaet[Should we do a plot to show the multiplicative factor across the DoA spectrum ?]

#figure(
  tablex(
    // SETTINGS
    columns: 7,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [],
    [$diameter$],
    [$epsilon=0.1$],
    [$epsilon=0.2$],
    [$epsilon=0.4$],
    [$epsilon=0.6$],
    [$epsilon=1.0$],
    
    midrule,

    // ROWS
    header-mae,     [9.36],  [8.17],  [8.29],  [*8.13*],  [8.32],  [8.49],
    header-acc,     [70.56], [71.68], [71.02], [*71.99*], [71.60], [71.38],
    header-prec,    [*81.04*], [67.86], [70.36], [75.96], [76.94], [76.87],
    header-recall,  [68.36], [*70.62*], [69.86], [70.28], [69.88], [69.61],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Performance of the #acr("SSL") model trained with the $epsilon$-loss
  ]
) <table:ssl:multi_source:experiments:epsilon_loss>


#gaet[
  Should we also show some training curves ?\
  I guess that I will put some. We might get rid of them afterwards if it they are too much.
]

#gaet[
  This requires to run more repetitions for each experiment so that the gaps in performance can be confirmed.
]
#draft[
  - Better MAE, Recall and Accuracy at the expense of precision (with $epsilon=0.1$).
    I am not too sure  about how to analyze this...
  - The epsilon loss shortens the "stagnating" phase at the beginning of the training (16-18k steps instead of 50-60k with the normal loss)
]

==== Normalization <sec:ssl:multi_source:experiments:normalization>

===== Background <sec:ssl:multi_source:experiments:normalization:background>

Various schemes of normalization have been used in Deep Neural Networks.
They address the phenomenon of _internal covariate shift_ which appears as architectures get deeper.
This problem comes from the distribution of each layer's inputs changing during training.
Such a drift causes the non-linear activation functions to saturate and harms the learning process.
Normalization also attempts at reducing the effects of mismatch between the training and test dataset distributions.

_#acr("BN")_, proposed by Ioffe et al. in @ioffe_batch_2015 has gathered significant success, especially in the computer vision community.
It consists in normalizing each mini-batch input with respect to its own statistics.
Acting as a form of regularizer, this process stabilizes learning by ensuring that the values entering all layers do not deviate too significantly.
The data will get distributed according to a standard normal distribution.
The _Batch Normalization Transform_ algorithm expresses as such:
$
  y_i = colMath(gamma, #blue) [
    (
      x_i
      - colMath(mu_cal(B), #maroon)
    )
    /sqrt(
      colMath(sigma_cal(B)^2, #olive) + epsilon
    )
  ] + colMath(beta, #blue)
$ <eq:ssl:multi_source:batch_norm>
where
- $x_i$ is an individual entry in the mini-batch $cal(B) = {x_1, dots, x_m}$,
- $colMath(mu_cal(B) = 1 / m sum_(i=1)^m x_i, #maroon)$ is the mini-batch mean,
- $colMath(sigma_cal(B)^2 = 1 / m sum_(i=1)^m (x_i - mu_cal(B))^2, #olive)$ is the mini-batch variance,
- $epsilon$ is a constant ensuring numerical stability,
- $colMath(gamma, #blue)$ and $colMath(beta, #blue)$ are learnable parameters.

To be able to perform inference on single samples, i.e. without disposing of an entire mini-batch, substitution statistics are used in place of $colMath(mu_cal(B), #maroon)$ and $colMath(sigma_cal(B)^2, #olive)$.
Indeed, during training, the #acr("BN") layer will keep updating a running mean and variance to be used at evaluation time.

_#acr("LN")_ (Ba et al. @ba_layer_2016) follows the same principle but chooses to normalize each sample individually by computing statistics across the features dimensions.
@fig:ssl:multi_source:normalization displays the differences of both schemes.
Historically, Layer Normalization has been most commonly employed within the Natural Language Processing field.

$
  y_(l, i) = colMath(gamma, #blue) [
    (
      x_(l, i)
      - colMath(mu_l, #maroon)
    )
    /sqrt(
      colMath(sigma_l^2, #olive) + epsilon
    )
  ] + colMath(beta, #blue)
$ <eq:ssl:multi_source:batch_norm>
where
- $x_(l, i)$ is an individual hidden unit in the $l$-th layer's inputs $X = {x_(l, 1), dots, x_(l, H)}$,
- $colMath(mu_l = 1 / H sum_(i=1)^H x_(l, i), #maroon)$ is the mean,
- $colMath(sigma_l^2 = 1 / H sum_(i=1)^H (x_(l, i) - mu_l)^2, #olive)$ is the variance,
- $epsilon$ is a constant ensuring numerical stability,
- $colMath(gamma, #blue)$ and $colMath(beta, #blue)$ are learnable parameters.

#figure(
  image("./figures/normalization.png", height: 4cm),
  caption: [
    A visual comparison of Batch and Layer normalizations
    (adapted from @wu_group_2018)
  ]
) <fig:ssl:multi_source:normalization>

Those two methods have been proven to be effective in the training deep neural network architectures.

===== Experiments

Although He et al. chose to use Batch Normalization in their work, our final architecture makes use of the more flexible Layer Normalization.
The choice of the normalization scheme ended up being crucial to achieving good performance.
We observed that the latter was yielding the same stabilization benefits during training while removing the dependence on the batch size.

@fig:ssl:multi_source:normalization_plots illustrates the evolution of the training and validation accuracy during training for different normalization schemes.

#figure(
  image("./figures/normalization_exp.svg"),
  caption: [
    Training and validation accuracies during training for different normalization schemes
  ]
) <fig:ssl:multi_source:normalization_plots>

This particular metric clearly exposes the differences between those three choices but the other metrics behave similarly.
Overall, both normalization techniques bring additional stability and performance to the training process.
However, significant differences arise when looking at the validation metrics.
When ran in evaluation mode, i.e. using the running statistics gathered during training, the network trained with #acr("BN") performs poorly compared to training.
This would suggest that the saved means and averages do not properly account for the differences between the training and validation sets.

Interestingly, evaluating this network's performance while forcing the batch normalization to use the training strategy avoids facing this issue.
Indeed, using the current validation batch statistics instead of the ones gathered at training provides results on par with the training performance.
This constitutes an important limitation of batch normalization in this case as the evaluation thus needs to be performed in a batched manner.
@table:ssl:multi_source:experiments:batch_norm displays the influence of the batch size on the performance of the network trained with #acr("BN").

#figure(
  tablex(
    // SETTINGS
    columns: 7,
    header-rows: 2,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,
    [],
    [evaluation mode],
    colspanx(5, align: center)[training mode],
    [Batch size],
    [-],
    [1],
    [50],
    [100],
    [200],
    [500],
    
    midrule,

    // ROWS
    header-mae,    [29.58], [42.10], [9.32],  [9.11],  [9.07],  [*8.95*],
    header-acc,    [53.45], [26.03], [73.00], [73.43], [73.66], [*73.76*],
    header-prec,   [45.37], [12.39], [83.7],  [84.26], [84.71], [*84.78*],
    header-recall, [61.00], [51.43], [70.61], [70.96], [71.19], [*71.35*],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance of #acr("BN") network w.r.t the evaluation mode
  ]
) <table:ssl:multi_source:experiments:batch_norm>



Those results depicts the positive role played by larger batch sizes for evaluation in _training mode_.
Although in a purely synthetic benchmark, this does not constitute an important drawback, it will become one as soon as the model will be asked to perform one-shot inference.
In our robotics context, the developed #acr("SSL") solution would have to be able to be used in real-world scenario where an entire batch of observation is not available at inference.

This is what motivated enhancement of the model using other normalization schemes.
As explained in @sec:ssl:multi_source:experiments:normalization:background, #acr("LN") does not encompass this behavioral distinction between training and evaluation.
@table:ssl:multi_source:experiments:norm_comparison compares the final performance of the different normalization approaches.
All models are evaluated on the same test dataset.

#draft[
  TODO empty column
]
#figure(
  tablex(
    // SETTINGS
    columns: 5,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [],
    [No normalization],
    [Batch norm\ (training mode, BS=500)],
    [Batch norm\ (eval mode)],
    [Layer norm],
    
    midrule,

    // ROWS
    header-mae,     [], [*8.95*],  [29.58], [9.37],
    header-acc,     [], [*73.76*], [53.45], [70.35],
    header-prec,    [], [*84.78*], [45.37], [80.21],
    header-recall,  [], [*71.35*], [61.00], [68.26],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the normalization strategy
  ]
) <table:ssl:multi_source:experiments:norm_comparison>

Overall, #acr("LN") and #acr("BN") offer comparable performance.
However, the model trained with #acr("LN") behave very consistently when used in evaluation.
For those reasons, we have preferred this approach over the original one.




==== Impact of context length

The choice of the signal duration used for training the localizer has some importance.
A tradeoff needs to be made between the reactivity of the system and detection performance.
Naturally, disposing of longer sequences of input audio is suspected to lead to higher metrics values.
On the other hand restricting the snippet length even further might hinder the robustness of the results.

To quantitatively evaluate those assumptions, we have trained our neural network on audio recordings of different lengths.
As presented in @sec:ssl:multi_source:method:dataset, the baseline duration of used recordings amount to roughly 360ms of audio.
Here, lower durations have been tested.

#figure(
  tablex(
    // SETTINGS
    columns: 5,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [],
    [2 frames (64ms)],
    [4 frames (107ms)],
    [8 frames (192ms)],
    [16 frames (341ms)],
    
    midrule,

    // ROWS
    header-mae,     [], [], [], [],
    header-acc,     [], [], [], [],
    header-prec,    [], [], [], [],
    header-recall,  [], [], [], [],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the input duration
  ]
) <table:ssl:multi_source:experiments:context_len_training>

#draft[
  Should 'Sequence processing' simply be a sub-section of this ?
]

#draft[
  TODO: compare trained on Tn vs trained on T and averaged n times
]

#draft[
  Transi: "going in the other direction and using longer snippets"
]

===== Sequence processing

#gaet[This sounds very pessimistic and might not be necessary]
In order to overcome the weaknesses of our model, we have proposed to use our method on longer recordings.
Like so, we are able to account for the missed detections and achieve a higher robustness in the detections.

The main idea resides in splitting the longer input audio in $M$ chunks sized appropriately to be processed by the neural network.
$M$ output #acr("DoA") spectra are thus obtained and need to be aggregated.
We simply average those signals to obtain a single vector:
#let averaged-spectrum = $colMath(hat(o), #maroon)$
$
  #averaged-spectrum = 1/M sum_(i=1)^M hat(o)_k #h(1em) in [0, 1]^d
$ <eq:ssl:multi_source:sequence_averaging>

The flexibility of the #acr("DoA") spatial spectrum encoding permits the former combination without the need of additional steps.
Our detection algorithm can then be applied on the average output.

To evaluate the performance of this method, a new dataset is generated.
Instead of saving 16 frames long individual #acr("STFT") chunks, we record the features for recordings of several seconds.
To generate each sample, each active source outputs one recorded sentence from the LibriSpeech @noauthor_librispeech_nodate dataset.
#acr("STFT")s of the multi-channel signals received by the microphone array coming from each source are saved independently.
Disposing of features corresponding to several seconds of simulation allows for performing #acr("SSL") on context windows of varying lengths.

#subpar.grid(
  figure(
    image("figures/sequence_processing_doa_spectrum.svg", width: 80%),
    caption: [
      Averaged #acr("DoA") spectrum #averaged-spectrum
    ]
  ),
  <fig:ssl:multi_source:sequence_processing:doa_spectrum>,
  
  figure(
    image("figures/sequence_processing_result.svg", width: 80%),
    //image("/assets/mountains.jpg"),
    caption: [
      Network output and extracted detections over time (top) and histogram of predictions (bottom)
    ]
  ),
  <fig:ssl:multi_source:sequence_processing:result>,
  columns: 1,
  caption: [
    Example of a sequence processing result
  ],
  numbering: fig-numbering,
  label: <fig:ssl:multi_source:sequence_processing>,
)

@fig:ssl:multi_source:sequence_processing illustrates the sequence processing workflow on a single example.
Here, around 16 seconds of continuous speech produced by three distinct static sources get recorded by the microphone array.
The latter also stands at a fixed position in the room.
@fig:ssl:multi_source:sequence_processing:doa_spectrum depicts the averaged #acr("DoA") spectrum #averaged-spectrum along with the corresponding overall predictions.
On this specific example, the averaging process successfully aggregates the angular information and allows for an accurate localization of all three sources.
More precisely, the top part of @fig:ssl:multi_source:sequence_processing:result displays the network output at each time step.
The gray scale patches represent the individual estimated #acr("DoA") spectrums $hat(o)_k$.
The resulting predicted angles are highlighted by the red dots.
Finally, the histogram of predictions characterizes the distribution of detections along the process.

Presenting the #acr("SSL") results as such highlights the strength and weaknesses of the proposed approach.
Even for a single frame, the estimated #acr("DoA") spectrum allows for precise predictions.
Very few false positives are observed, as confirmed by the several quantitative experiments conducted.
However, individual sources are sometimes missed, maybe because they were not active enough at this specific time.
This drawback gets offset by leveraging the overall consistency of the method over a longer time.

In order to further characterize this behavior, we have executed an exhaustive performance evaluation of the sequence processing workflow.


#figure(
  tablex(
    // SETTINGS
    columns: 6,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [],
    [16 frames (363ms)],
    [32 frames (704ms)],
    [64 frames (1.39s)],
    [512 frames (10.9s)],
    [full samples],
    
    midrule,

    // ROWS
    header-mae,     [8.85],  [6.26],  [5.41],  [3.94],  [*3.90*],
    header-acc,     [72.80], [80.93], [84.41], [87.80], [*88.00*],
    header-prec,    [83.20], [89.93], [94.33], [96.26], [*96.26*],
    header-recall,  [70.96], [78.70], [82.09], [84.61], [*84.80*],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance for different context lengths
  ]
) <table:ssl:multi_source:experiments:sequence_processing>





@table:ssl:multi_source:experiments:sequence_processing exposes the results of the trained model for various context windows.
It appears clearly that the longer the agent is able to hear, the better its localization performance becomes.
The base context window of 16 #acr("STFT") frames amounts to approximately 363 milliseconds, which is a fairly short time period.
During this interval, one or more speech sources could be inactive as the energy criteria $delta_"energy" (#tau-e)$ is not enforced on this specific data set.
This sole difference in the data generation process explains the gap in performance between this experiment and the evaluation on the normal dataset reported in @sec:ssl:multi_source:experiments:number_of_sources (see @table:ssl:multi_source:experiments:n_sources_train for example).