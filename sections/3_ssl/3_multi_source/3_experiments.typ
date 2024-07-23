#import "/utils.typ": *

#import "/utils.typ": *

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
        & k = "argmin"_(k=1) ^ hat(z_i) d(hat(phi.alt)_(i k), phi.alt_(i j)),
    0 "otherwise"
  )
$

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

====== Matching algorithms

==== Performance evaluation
// TODO: we can not really compare with the original authors as they evaluated on real data.

// TODO give the value we have chosen for E_a

// TODO PR-curves

===== Impact of the number of sources <sec:ssl:multi_source:experiments:number_of_sources>

Although the raw dataset contains TODO
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
    [MAE (°) #sym.arrow.b],       [0.0],        [0.0],         [0.0],         [0.0],
    [Accuracy (%) #sym.arrow.t],  [0.0],        [0.0],         [0.0],         [0.0],
    [Precision (%) #sym.arrow.t], [0.0],        [0.0],         [0.0],         [0.0],
    [Recall (%) #sym.arrow.t],    [0.0],        [0.0],         [0.0],         [0.0],
  ),
  caption: [
    #acr("SSL") performance depending on the number of active sources
  ]
)

==== $epsilon$-loss

We propose an original modification of the loss function.
The motivation comes from the observation that the target #acr("DoA") spatial spectrum is sparse (see @fig:ssl:multi_source:doa_gt_encoding for instance).
As seen in @sec:ssl:multi_source:method:training_strategy, we use a simple #acr("MSE") loss (@eq:ssl:multi_source:loss_function) for the cost function.

We have made an attempt at adjusting the latter to more aggressively penalize the sections of the spatial spectrum where sources are actually present.

$
  cal(L)_epsilon (hat(o)_i, o_i) =
    1/d sum_(i=1)^d
    colMath((o_i + epsilon), #maroon)
    (hat(o)_i - o_i)^2
$ <eq:ssl:multi_source:epsilon_loss>

#gaet[Should we do a plot to show the multiplicative factor across the DoA spectrum ?]

//TODO: add the results (ablation study)

==== Limitations

#gaet[Maybe this paragraph should go at the very end of the MS-SSL section]

#draft[
  - Performance is far from being perfect (SotA)
  - No noise handling
]

==== Sequence processing

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
Each sample corresponds to TODO entire sentences

#gaet[check with Laurent that the length of the input signal is $H(F+1) / (48 000)$]

#show table.cell.where(x: 0): strong
#show table.cell.where(y: 0): strong
#set text(size: 0.8em)
#figure(
  table(
    columns: 6,
    align: left,
    table.header(
      [],
      [16 frames (363ms)],
      [32 frames (704ms)],
      [64 frames (1.39s)],
      [512 frames (10.9s)],
      [full samples],
    ),
    [MAE (°) #sym.arrow.b],       [0.0], [0.0], [0.0], [0.0], [0.0],
    [Accuracy (%) #sym.arrow.t],  [0.0], [0.0], [0.0], [0.0], [0.0],
    [Precision (%) #sym.arrow.t], [0.0], [0.0], [0.0], [0.0], [0.0],
    [Recall (%) #sym.arrow.t],    [0.0], [0.0], [0.0], [0.0], [0.0],
  ),
  caption: [
    #acr("SSL") performance depending on the number of active sources
  ]
)

#draft[Impact of window length]
// TODO: insert table of results