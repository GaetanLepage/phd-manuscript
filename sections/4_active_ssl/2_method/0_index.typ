#import "/utils.typ": *
#import "../_notations.typ": *

== Methods
<sec:active_ssl:methods>

=== Problem formulation

As presented in @sec:active_ssl:sota, there exist several different problems related to #acr("SSL") in a dynamic robotic context.
In this work, a simple task is explored, motivated by the extension of the static #acr("SSL") methods developed in @chap:ssl to more realistic situations.

Specifically, a robotic agent moves in a room where one or several human speakers are present.
We adopt a step based representation in which the robot performs discrete movements.
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

At each step, a _#acr("DoA") map_ $M_t$ is built from the #acr("DoA") spectrum for the corresponding audio recording.
The latter solely provides angular information.
At this stage, no distance knowledge has been gathered yet.
The choice was made to not explicitly extract a set of detections from the spectrum but rather to preserve the raw 360 long vector.
Generating the #acr("DoA") map $M_t$ consists in projecting this spectrum on the egocentric 2D space.

All maps have a resolution of $p$ pixels and are thus represented by $p times p$ matrices.
They represent an area of $L times L$ square area around the robot.

// TODO: illustration ?
First, each point $bold(p) = (x, y) in [-L/2, L/2]^2$ in the robot frame is mapped to the corresponding #acr("DoA") value $theta(bold(p)) in [-pi, pi]$.\
This allows to associate all pixels $(i, j) in [|1, p|]^2$ of the map to the corresponding angle value $theta_(i, j)$.\
Finally, the associated #acr("DoA") spectrum value can be recovered by computing the index $k_(i, j) in [|1, d|]$ corresponding to the angle $theta_(i, j)$:

$
  M_(t(i, j)) = o[k_(i, j)] #h(2em) forall (i, j) in [|1, p|]^2
$

#include "figures/doa_map.typ"



At each step, the method gets the #acr("SSL") maps $(M_(t-H), dots, M_(t-1))$ from the $H-1$ previous steps.
All of those previous maps need to be _shifted_ to the current robot frame in order to be combined together, along with the current #acr("SSL") map $M_t$

$
  M_(t_1 -> t_2)
$

=== Aggregation strategies

==== Deterministic averaging

// TODO: naive simulation strategy

#func-decl(
  $Psi$,
  $RR^(H times p times p)$,
  $RR^(p times p)$,
  $(M_(t-H), dots, M_t)$,
  $MM_t$
)

$
  Psi^"avg" (M_(t-H), dots, M_t) := 1 / H sum_(k=0)^H M_(t-k)
$

==== Deep Neural Network

// U-net architecture
#draft[Talk about impact of receptive field and how the naive CNN failed miserably.]

===== Motivation

===== Ground truth encoding

===== Loss function

$Psi^("DNN"(theta))$

$
  cal(L) (
    #m-hat,
    M_t
  ) = norm(
    #m-hat - M_t
  )_2 ^2
$

// Task defined as a regression task

===== Architecture

===== Training strategy

=== Clustering for detection extraction