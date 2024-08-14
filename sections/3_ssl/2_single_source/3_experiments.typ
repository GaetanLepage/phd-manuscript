#import "/utils.typ": *
#import "2_method.typ": d


=== Experiments <sec:ssl:single_source:experiments>

==== Metrics

In this first formulation of the #acr("SSL") problem, each situation includes exactly one source to localize.

*#acr("DoA") metric.*
Naturally, the performance of the method is characterized by how far the estimate $hat(theta)$ lays from the real #acr("DoA") value $theta$.
For this, we compute the $l_1$ angular pseudo-distance #d between $hat(theta)$ and $theta$.
This measure will be referred to as the #acr("MAE"):
#let mae-theta = $"MAE"_theta$
$
  #mae-theta = 1 / n_"test" sum_(i=1) ^  n_"test" #d (hat(theta)_i, theta_i)
$ <eq:ssl:single_source:mae>
where $n_"test"$ counts the number of samples in the test set.


*Source-array distance metric.*
When predicting the source-array distance, the #acr("MAE") is also used, here between predicted $hat(D)$ values and ground truth $D$:
#let mae-dist = $"MAE"_D$
$
  #mae-dist = 1 / n_"test" sum_(i=1) ^ n_"test"
  abs(hat(D)_i - D_i)
$ <eq:ssl:single_source:dist_metricc>


The choice of the #acr("MAE") as performance criteria has the advantage of being expressed in length units.
For clarity reasons, the values for this metrics will be displayed in centimeters (cm).

/* METRICS HEADERS (for tables) */
#let mae-theta-header = mae-theta + " (°) " + sym.arrow.b
#let mae-dist-header = mae-dist + " (cm) " + sym.arrow.b

==== Impact of input signal representation

The the neural network is expected to extract the relevant localization information from the audio signal provided as input.

In this work, we focus on time-frequency representations.
Adaptations of 2D convolutions to complex tensors do exist and have already been used in the #acr("SSL") literature.
In @krause_comparison_2021, Krause et al. present this variation along with its benefits (Section II.B).
In this work though, regular 2D convolutions have been employed and the complex-valued #acr("STFT") were needed to be converted to real values.
To achieve this, two schemes were compared:
- On the one hand, both the real and imaginary parts of the complex data can populate the two real resulting matrices:
  $
    phi_"cart": #h(1cm) CC^(F times T) & -->               RR^(2 times F times T)\
    Z        & arrow.r.long.bar 
    lr((cal(Re)(Z), cal(Im)(Z)), size: #140%)
  $
  This form will be referred to as the Cartesian projection.
#gaet[
  The following is less accurate, but maybe enough and clearer. What do you prefer ?
  $
    Z |-> lr((cal(Re)(Z), cal(Im)(Z)), size: #140%)
  $
]

- The other method consists in using the polar form of the Fourier representation:
$
  phi_"pol": #h(1cm) CC^(F times T) & -->               RR^(2 times F times T)\
  Z        & arrow.r.long.bar 
  lr((abs(Z), arg(Z)), size: #140%)
$
#gaet[
  Same here,
  $
    Z |-> lr((abs(Z), arg(Z)), size: #140%)
  $
]

Besides raw #acr("STFT") values, interaural features

// TODO: Hence, the choice of the encoding method for the acoustic data has a substantial impact on the difficulty of this task.

When using #acr("STFT") features directly, they get converted to real values as following.
Each complex matrix translates to two real ones by splitting the modulus and the phase of each entry.
Thus, a $N$-channel #acr("STFT") $N times F times T$ complex tensor ends up as a $2N times F times T$ real array.
This choice allows the use for conventional real-valued 2D convolutions.

// Compare ILD/IPD performances

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
    [#mae-theta-header],
    [#mae-dist-header],
    
    midrule,

    // ROWS
    [Interaural (#acr("ILD")/#acr("IPD"))],     [1.90], [3.87],
    [#acr("STFT") (Cartesian)],                 [9.90], [18.29],
    [#acr("STFT") (polar)],                     [0.0], [0.0],
    
    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the input features
  ]
)


==== Reverberation

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
    [$T_60$],
    [#mae-theta-header],
    [#mae-dist-header],
    
    midrule,

    // ROWS
    [100ms],  [0.0], [0.0],
    [200ms],  [0.0], [0.0],
    [300ms],  [0.0], [0.0],
    [500ms],  [0.0], [0.0],
    [1s],     [0.0], [0.0],
    [2s],     [0.0], [0.0],
    
    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Reverberation impact on #acr("SSL") performance
  ]
)


==== Sound Source Localization in noisy environments <sec:ssl:single_source:experiments:noise>

Having succeeded at accurately estimating the #acr("DoA") in a reverberant but noiseless setting, we have attempted to add noise sources.
The latter has revealed to harden the task significantly.
We have focused on noises of basic nature: white noise and music.
Both share the property of noticeably differing from a speech signal in its fundamental acoustic nature.
// Having a parasite speech

// Which kinds of noises


=== Conclusion

// Limitations: single source (i.e., not more than one BUT ALSO always at least one)