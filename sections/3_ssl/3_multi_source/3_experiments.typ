#import "/utils.typ": *
#import "2_method.typ": tau-e

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
#gaet[Not sure that this equation is needed at all.]

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
Some mass placed randomly on the $[-pi, pi]$ interval would likely not be overlapping with the ground-truth gaussians.
The loss would most often approach its upper bound:
#let gt = $colMath(o, #blue)$
#let pred = $colMath(hat(o), #red)$
$
  0 <= cal(L) (#gt, #pred) lt cal(L) (#gt, 0) + cal(L) (#pred, 0)
$

#figure(
  include("figures/loss_illustration.typ"),
  caption: [
    Fictive example of a network prediction (in red) prediction along with the corresponding ground truth spectrum (in blue)
  ],
) <fig:ssl:multi_source:loss_illustration>


From this observation, the strategy of enforcing $#pred = 0$, ensures the loss will never exceed $cal(L) (#gt, 0)$.
A careful choice of both the batch size and the learning rate were necessary to prevent this phenomenon for happening.
To empirically illustrate this behavior, we monitor in @fig:ssl:multi_source:energy_plot the norm $norm(o)_2^2$, defined by 
$
  norm(o)_2^2 = 1 / d sum_(i=1) ^d o_i^2
$
along a successful training process.

#figure(
  square(size: 10em, stroke: 2pt),
  caption: [
    Evolution of the norm of the network output $norm(o)_2^2$ (purple) and loss (green) during training.
  ],
) <fig:ssl:multi_source:energy_plot>

We can distinguish two distinct phases.
- First, the network exploits the trivial local optima consisting in predicting a null output.
  Both the loss and the output norm reach stable values. #draft[TODO: check network value.]
- Subsequently, from the #draft[TODO]-th step, the model escapes from this plateau and learns to successfully solve the regression task.

Using too important batch sizes or too aggressive learning rates, the model indefinitely stagnates, keeping predicting zeros.
Keskar et al. @keskar_large-batch_2017 have documented the negative effects that large batch sizes could have on generalization performance.

#gaet[Ideally, this would benefit from more exhaustive experiments, especially regarding the use of LR scheduling...]

Identifying, characterizing and overcoming this shortcoming has been an essential step in the development of this model.




==== Performance evaluation
// TODO: we can not really compare with the original authors as they evaluated on real data.

// TODO give the value we have chosen for E_a

// TODO PR-curves

===== Impact of the number of sources <sec:ssl:multi_source:experiments:number_of_sources>

#gaet[Should _zero_ and _four_ be written using the digit directly ?]
As explained in @sec:ssl:multi_source:method:dataset, the dataset allows for dynamically selecting a subset of zero to four sources at runtime.
This features has allowed us to experiment with the impact of how many sources are present in the room simultaneously.
// TODO

// Two different trainings

// Same training with different number of sources

The generation process starts by randomly selecting a number of sources between zero and four according to the following distribution:
- 0 sources: 20%,
- 1 source: 40%,
- 2 sources: 30%,
- 3 sources: 5%,
- 4 sources: 5%.
#gaet[
  How do we motivate this choice ? By simply saying that we did the same as in the paper ?
]


#gaet[
  Should I report the unit along the value in each cell or is it OK like this (to have the unit in the row name) ?
]

#show table.cell.where(x: 0): strong
#show table.cell.where(y: 0): strong
#figure(
  table(
    columns: 5,
    table.header(
      [],
      [1 source],
      [2 sources],
      [3 sources],
      [4 sources],
    ),
    [MAE (°) #sym.arrow.b],       [0.0], [0.0], [0.0], [0.0],
    [Accuracy (%) #sym.arrow.t],  [0.0], [0.0], [0.0], [0.0],
    [Precision (%) #sym.arrow.t], [0.0], [0.0], [0.0], [0.0],
    [Recall (%) #sym.arrow.t],    [0.0], [0.0], [0.0], [0.0],
  ),
  caption: [
    #acr("SSL") performance depending on the number of active sources
  ]
)

==== $epsilon$-loss

We propose an original modification of the loss function.
The motivation comes from the observation that the target #acr("DoA") spatial spectrum is sparse (see @fig:ssl:multi_source:doa_gt_encoding for instance).
As seen in @sec:ssl:multi_source:experiments:loss, we use a simple #acr("MSE") loss (@eq:ssl:multi_source:loss_function) for the cost function.

We have made an attempt at adjusting the latter to more aggressively penalize the sections of the spatial spectrum where sources are actually present.

$
  cal(L)_epsilon (hat(o)_i, o_i) =
    1/d sum_(i=1)^d
    colMath((o_i + epsilon), #maroon)
    (hat(o)_i - o_i)^2
$ <eq:ssl:multi_source:epsilon_loss>

#gaet[Should we do a plot to show the multiplicative factor across the DoA spectrum ?]

//TODO: add the results (ablation study)
#show table.cell.where(x: 0): strong
#show table.cell.where(y: 0): strong
#figure(
  table(
    columns: 7,
    table.header(
      [],
      [$diameter$],
      [$epsilon=0.1$],
      [$epsilon=0.2$],
      [$epsilon=0.4$],
      [$epsilon=0.6$],
      [$epsilon=1.0$],
    ),
    [MAE (°) #sym.arrow.b],       [0.0], [0.0], [0.0], [0.0], [0.0], [0.0],
    [Accuracy (%) #sym.arrow.t],  [0.0], [0.0], [0.0], [0.0], [0.0], [0.0],
    [Precision (%) #sym.arrow.t], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0],
    [Recall (%) #sym.arrow.t],    [0.0], [0.0], [0.0], [0.0], [0.0], [0.0],
  ),
  caption: [
    Performance of the #acr("SSL") model trained with the $epsilon$-loss
  ]
)

==== Sequence processing

#gaet[This sounds very pessimistic and might not be necessary]
In order to overcome the weaknesses of our model, we have proposed to use our method on longer recordings.
Like so, we are able to account for the missed detections and achieve a higher robustness in the detections.

The main idea resides in splitting the longer input audio in $M$ chunks sized appropriately to be processed by the neural network.
$M$ output #acr("DoA") spectra are thus obtained and need to be aggregated.
We simply average those signals to obtain a single vector:
$
  hat(o) = 1/M sum_(i=1)^M hat(o)_k #h(1em) in [0, 1]^d
$ <eq:ssl:multi_source:sequence_averaging>

The flexibility of the #acr("DoA") spatial spectrum encoding permits the former combination without the need of additional steps.
Our detection algorithm can then be applied on the average output.

To evaluate the performance of this method, a new dataset is generated.
Instead of saving 16 frames long individual #acr("STFT") chunks, we record the features for recordings of several seconds.
To generate each sample, each active source outputs one recorded sentence from the LibriSpeech @noauthor_librispeech_nodate dataset.
#acr("STFT")s of the multi-channel signals received by the microphone array coming from each source are saved independently.
Disposing of features corresponding to several seconds of simulation allows for performing #acr("SSL") on context windows of varying lengths.

#gaet[
  - Which precision for the numbers in the tables ?
  - Should I put in bold the best values ?
]

// TODO: align
#show table.cell.where(x: 0): strong
#show table.cell.where(y: 0): strong
#set text(size: 0.8em)
#figure(
  table(
    columns: 6,
    table.header(
      [],
      [16 frames (363ms)],
      [32 frames (704ms)],
      [64 frames (1.39s)],
      [512 frames (10.9s)],
      [full samples],
    ),
    [MAE (°) #sym.arrow.b],       [8.85],  [6.26],  [5.41],  [3.94],  [3.90],
    [Accuracy (%) #sym.arrow.t],  [72.80], [80.93], [84.41], [87.80], [88.00],
    [Precision (%) #sym.arrow.t], [83.20], [89.93], [94.33], [96.26], [96.26],
    [Recall (%) #sym.arrow.t],    [70.96], [78.70], [82.09], [84.61], [84.80],
  ),
  caption: [
    #acr("SSL") performance for different context lengths
  ]
) <table:ssl:multi_source:experiments:sequence_processing>

@table:ssl:multi_source:experiments:sequence_processing exposes the results of the trained model for various context windows.
It appears clearly that the longest the agent is able to hear for, the better its localization performance will be.
The base context window of 16 #acr("STFT") frames amounts to approximately 363 milliseconds, which is a fairly short time period.
During this interval, one or more speech sources could be inactive as the energy criteria $delta_"energy" (#tau-e)$ is not enforced on this specific data set.
This sole difference in the data generation process explains the gap in performance between this experiment and the evaluation on the normal dataset reported in @sec:ssl:multi_source:experiments:number_of_sources.

#draft[Impact of window length]
// TODO: insert table of results