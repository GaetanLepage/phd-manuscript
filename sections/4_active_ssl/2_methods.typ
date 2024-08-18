#import "/utils.typ": *
== Methods
<sec:active_ssl:methods>

=== Problem formulation

=== Pipeline overview

#draft[
  - Trajectory
  - SSL running at each step
  - map generation
  - map shifting
  - blending
  - prediction extraction (clustering with DBSCAN)
]

=== Aggregation strategies

==== Deterministic averaging

// TODO: naive simulation strategy

==== Deep Neural Network

// U-net architecture
#draft[Talk about impact of receptive field and how the naive CNN failed miserably.]

===== Motivation

===== Ground truth encoding

===== Loss function

$
  Psi_H: #h(4em) RR^(H times d times d) & -->  RR^(d times d)\
  (M_(t-H), dots, M_t) & arrow.r.long.bar tilde(M)_t^H
$

$
  Psi_H^"avg" (M_(t-H), dots, M_t) := 1 / H sum_(k=0)^H M_(t-k)
$

$Psi_H^("DNN"(theta))$

$
  cal(L) (
    tilde(M)_t^H,
    M_t
  ) =
$

// Task defined as a regression task

===== Architecture

===== Training strategy

=== Clustering for detection extraction