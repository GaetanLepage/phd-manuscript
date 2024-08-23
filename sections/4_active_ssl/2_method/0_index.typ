#import "/utils.typ": *
#import "../_notations.typ": *

== Methods
<sec:active_ssl:methods>

=== Problem formulation

As presented in @sec:active_ssl:sota, there exist several different problems related to #acr("SSL") in a dynamic robotic context.
In this work, a simple task is explored, motivated by the extension of the static #acr("SSL") methods developed in @chap:ssl to more realistic situations.
// TODO: if so, mentioned that we have tried to estimate the distance in single-source and that it was hard
Indeed, estimating both distance and #acr("DoA") from a single recording has shown to be challenging version of the #acr("SSL") problem.
#draft[
  Maybe, this is expressed in @grumiaux_survey_2021.
]
Theoretically, though, aggregating purely angular information accumulated over time by a mobile robot could permit to predict the actual location of sources in a room.


Specifically, a robotic agent moves in a room where one or several human speakers are present.
We adopt a step based representation in which the robot performs discrete movements denoted as $delta_t = (d_t, theta_t)$.\
Also, its trajectory is assumed to be determined by an external policy which should not be affected.
The goal of the developed method is thus to localize, in real time and as accurately as possible, the relative position of each source.
To enforce for the real-time constraint in this modelling, the duration of each step gets limited to a few hundred milliseconds.
The method is provided with the recorded signal at each microphone of the agent corresponding to this time frame.

*Horizon.*
This framework, until now, appears to be similar to the static formulation of #acr("SSL") used previously.
However, the input data also encompasses information about the last relative movement of the robot.
Although the movement policy should not be dictated by the #acr("ASSL") solution, its output is made available.
This data allows the model to accumulate knowledge along several consecutive steps to refine its prediction for the current sources positions.
The number of such steps after which the method's output is evaluated will be denoted as the horizon $H$.
Importantly, only relative movement information may be leveraged to perform the task as the absolute agent position remains unknown.
In this aspect, this formulation differs from problems where the robot localization is also available.

Sound sources model talking humans, present at arbitrary positions within the room.
Importantly, their positions are assumed to be static for an entire episode of $H$ steps.


=== Pipeline overview

To tackle the #acr("ASSL") problem formulated above, we explore ways of leveraging the previously developed multi-source static localizer.
The central concept of the method consists in building and refining a 2D egocentric map encoding the relative positions of each source.
They are built to model the likelihood of the sources presence in the surroundings of the robot.

To build such a map, we start by running the #acr("SSL") model which provides the estimated #acr("DoA") spectrum.
This detection is then transformed into a _#acr("DoA") map_ projecting the one dimensional localization result to an egocentric 2D map containing the same information.
Then, this map is combined to the ones from previous steps after the latter have been transposed to the current robot frame.
Different ways of operating this aggregation have been proposed.
Finally, the 2D relative position of the sources are extracted from this estimated egocentric map.

The overall procedure for performing one step of active-#acr("SSL") is described in @algo:active_ssl:algo.
The individual steps of the process will be detailed in the following sections.

#include "algorithm.typ"

#draft[
  - Trajectory
  - SSL running at each step
  - map generation
  - map shifting
  - blending
  - prediction extraction (clustering with DBSCAN)
]

=== Egocentric #acr("SSL") maps

At each step, a _#acr("DoA") map_ $M_t$ is built from the #acr("DoA") spectrum for the corresponding audio recording (line 9 in @algo:active_ssl:algo).
The latter solely provides angular information.
At this stage, no distance knowledge has been gathered yet.
The choice was made to not explicitly extract a set of detections from the spectrum but rather to preserve the raw 360 long vector.
Generating the #acr("DoA") map $M_t$ consists in projecting this spectrum on the egocentric 2D space.

All maps have a resolution of $p$ pixels and are thus represented by $p times p$ matrices.
They represent an area of $L times L$ square area around the robot.

// TODO: illustration ?
First, each point $bold(p) = (x, y) in [-L/2, L/2]^2$ in the robot frame is mapped to the corresponding #acr("DoA") value $theta(bold(p)) in [-pi, pi]$.\
This allows to associate all pixels $(i, j) in [|1, p|]^2$ of the map to the corresponding angle $theta_(i, j)$.\
Finally, the associated #acr("DoA") spectrum value can be recovered by computing the index $k_(i, j) in [|1, d|]$ corresponding to the angle $theta_(i, j)$:
$
  M_(t(i, j)) = o[k_(i, j)] #h(2em) forall (i, j) in [|1, p|]^2
$
Hence, the intensity of a pixel simply equals the value of the spectrogram at the corresponding angle.

@fig:active_ssl:doa_map presents an example of such a #acr("DoA") map along with the originating spectrum.
By construction, the value of this 2D function remains constant along lines where $theta = arctan(x/y)$ is constant.
This leads to a mixture of cone shapes originating at the center of the egocentric map.

#include "figures/doa_map.typ"

*Shifting.*
At each step, the method gets the #acr("DoA") maps $(M_(t-H+1), dots, M_(t-1))$ from the $H-1$ previous steps.
All of those maps need to be _shifted_ from their original frame $cal(F)_t'$ to the current robot frame $cal(F)_t$ in order to be combined together along with the current #acr("DoA") map $M_t$.
This operation makes use of the relative movement $Delta_(t_1 -> t_2)$ between two steps $t_1$ and $t_2$.
It encodes the position and orientation of the previous map in the current frame $cal(F)_t$.
This movement is computed from the robot movement at each step $delta_t'$ with $t' in [|t_1, t_2|]$.
The result of this operation will be denoted as $tilde(M)_t'$.

This correspond to the lines 12-16 of @algo:active_ssl:algo.
Of course the #acr("FoV") parameter $L$ has to be chosen relevantly with respect to the maximum distance $d_"max"$ travelled by the robot at each step and the horizon $H$.
If the characteristic value $H times d_"max"$ significantly overpasses $L/2$, information from the oldest steps will at least partly be out of scope and thus useless.
In practice, there are no strong reason to keep $L$ and choosing it greater than the dimensions of the room ensures to capture most available knowledge in the shifted maps $tilde(M)_t'$.
Of course, we have $tilde(M)_t = M_t$ as the current map does not need to be shifted.


=== Aggregation strategies

Once the collection of $H-1$ previous #acr("DoA") maps has been correctly shifted to $cal(F)_t$, they will be _combined_ altogether, along with the current map $M_t$.
The intuition behind this approach for #acr("ASSL") lies in the idea of combining those step-maps into a single aggregate which models a 2D likelihood for source presence around the robot.

Such a mapping defines as:
#func-def(
  $Psi$,
  $RR^(H times p times p)$,
  $RR^(p times p)$,
  $
  bold(tilde(M))_t = (
    tilde(M)_(t-H+1),
    dots,
    tilde(M)_t
  )$,
  AM,
)

where #AM denotes the obtained estimate for the likelihood.

Designing reliable process to aggregate the maps is crucial.
Indeed, the resulting #AM likelihood will be used to extract the positions of each source.
The cleaner the combined map can be, the easier the detection task becomes.

In this section, two methods are proposed to perform map blending.


==== Deterministic averaging

On the one hand, a naive approach has been attempted.
It simply consists in averaging the maps:
$
  Psi^"avg" (
    tilde(M)_(t-H+1),
    dots,
    tilde(M_t)
  ) := 1 / H sum_(t'=0)^(H-1) tilde(M)_(t-t')
$

As all maps are correctly expressed in the same local frame $cal(F)_t$, a given pixel in each one correspond to the same position.
The idea of averaging #acr("DoA") maps translates that each time step brings equal information about the presence of sources.
Thus, the intersection of the different cones will have the highest scores which appears reasonable.

However, in certain trajectories, averaging leads to artifacts that harden the clustering task performed to extract the final detection results.

The performance of this blending approach is discussed in later @sec:active_ssl:results:blending_methods.

==== Deep Neural Network

===== Motivation

Although averaging #acr("DoA") maps stands as a simple and explainable method for blending, we have developed a more advanced technique involving a Deep Neural Network.

Indeed, an oracle knowing the absolute positions of each source could be used to generate an ideal version of the 2D likelihood estimate #AM-targ,
This statement leads to the definition of the blending task as a regression task where a neural network $Psi^("DNN"(theta))$ is trained to blend real #acr("DoA") maps in the ideal estimate #AM-targ,

#draft[
  >>> This should go into the section about the dataset, maybe in the "experiments" part.
  
  The ability of our simulator to model _dynamic_ discrete-time environments (see @sec:simulator:simulator:features:dynamic_scenarios) allows us to generate datasets for this #acr("ASSL") task.
]

===== Ground truth encoding

The target map $cal(M)_t^*$ is computed from a set of ground truth sources positions $cal(X)_s = lr(((x_1, y_1), dots, (x_n_s, y_n_s)), size: #150%)$ expressed in the current robot frame $cal(F)_t$.

A strategy similar to the spectrum encoding introduced for multi-source #acr("SSL") presented in @sec:ssl:multi_source:method:doa_repr:gt_encoding has been chosen.
Each source is modeled by a 2D gaussian blob centered at its position.
The envelope of those gaussians leads to the continuous target map:
#func-def(
  $overline(#AM-targ)$,
  $[-L/2, L/2]^2$,
  $[0, 1]$,
  $X = (x, y)$,
  $display(
    max_(
      X_s = (x_s, y_s)
      in cal(X)_s)
    )
      {
        e^(
          -(norm(X - X_s)^2)
          / sigma^2
        )
      }$,
)
where $sigma$ affects the spread of each blob and has been set to 0.5m.

This continuous function is discretized in the final $p times p$ matrix #AM-targ.
@fig:active_ssl:methods:gt_encoding shows the ground truth value for our previous example:

#figure(
  image(
    "figures/gt_encoding.svg",
    height: 7cm
  ),
  caption: [Ground truth encoding #AM-targ of the localization map]
)
<fig:active_ssl:methods:gt_encoding>

Hence, by using a more advanced blending method such as a #acr("DNN"), we expect to achieve a finer filtering result.
The network should get rid of all noise in the input maps and underline the regions where sources are expected to be.



===== Architecture

The neural network #psi-dnn takes the $H$ shifted #acr("DoA") maps $(tilde(M)_(t-H+1), dots, tilde(M)_(t))$ as a single $H$-channel image $bold(tilde(M))_t$.
It outputs a single-channel image #AM expected to approximate the target map #AM-targ.

To design a model aimed at processing image-like information, conventional architectures from the computer vision literature are considered.
Although several solutions could probably fit this problem successfully, one has to pay attention to the receptive field of the network.
Indeed, designs purely based on small convolutional kernels would not be able to capture global information.
In this specific task, the intersecting rays present in each #acr("DoA") map has to be considered from a sufficiently large scale.
What could appear locally as an intersection of rays, therefore indicating the presence of a source, could actually be noisy artifacts caused by an earlier crossing.
This hypothesis may explain the failure of experimented networks with too small receptive fields.

To account for this problem, we propose a custom U-Net architecture adapted from the original paper by Ronneberger et al. @ronneberger_u-net_2015.
This type of designs suits well our task of image-to-image mapping.
More specifically, it allows for a multi-scale processing, thus allowing larger patterns to be leveraged.
We opt for a four stage layout (@fig:active_ssl:methods:nn_architecture) within which the #shape(8, 256, 256) input gets progressively downscaled to a #shape(512, 32, 32) latent representation.

#figure(
  image(
    "figures/nn_architecture.svg",
    width: 100%,
  ),
  caption: [
    Deep neural network architecture for 2D localization map aggregation
  ]
)
<fig:active_ssl:methods:nn_architecture>



where $#AM = Psi^("DNN"(theta))(bold(tilde(M))_t)$ is the output of the network and #AM-targ is the target map.
$
  cal(L) (
    #AM,
    #AM-targ,
  ) = norm(
    #AM - #AM-targ,
  )_2 ^2
$


===== Training strategy

The network is trained in a supervised manner on a synthetic dataset.
The latter was generated by simulating $H$-step long random trajectories in the simulator.
The static #acr("SSL") model is called at each step and output an estimation of the #acr("DoA") spectrum $o_t$.
The latter are converted to #acr("DoA") maps $M_t$ which finally get shifted to the frame $cal(F)_H$ corresponding to the last robot position.

// TODO both GT and real SSL spectrums

=== Clustering for detection extraction