#import "/utils.typ": *
#import "../_notations.typ": *

== Experiments and discussions
<sec:rl:results>

After designing and implementing the complete #acr("RL") pipeline presented in the previous section, we turn to an experimental study of its capabilities and performance.

#include "figures/trajectories/figure.typ"

=== #acr("ASR") performance in a reverberant room

First and foremost, we investigate how #acr("ASR") performance is impacted by reverberation. 
Also, this study explores the importance of the robot position relative to the source, especially in highly reverberant environments.
Several cost maps

#draft[
  - Show how #acr("WER") decreases when adding reverb
  - *This study motivates our choice for WER as an interesting objective / cost function*
  - Show how #acr("WER") decreases when adding reverb
  - Show examples of #acr("WER") maps on different settings
  - Motivate the use of $T_60 = 0.5s$
]

@fig:rl:results:wer_maps_reverb

#include "figures/wer_maps/figure.typ"

*Cost map directionality*

When the cost function is invariant in the agent orientation $theta_a$, the map is said to be omnidirectional.
In the case of the #acr("WER") cost #wer-cost, this is when an omnidirectional microphone is used to record signals at each position on the grid.
When a directional microphone is used, separate recordings are made for all four cardinal orientations of the agent.

it is omnidirec, omnidirectional maps correspond to the 

@fig:rl:results:directional_map aims at being

#include "figures/directional_wer_map/figure.typ"


=== Alternative cost maps

Before using #acr("WER") cost maps to compute the reward, we have conducted experiments with alternative cost maps.
As highlighted in previous @sec:rl:method:wer_maps:computing, computing #wer-cost is very compute intensive.
Furthermore, the #acr("WER") cost is noisy has some artifacts.
In this section, we introduce an alternative formulation for the cost function #cost.
This analytical cost #analytical-cost

on artificial cost maps.
We have used synthetic data to validate the concept of training an agent with our custom #acr("WER") maps.

#draft[
  Objective: sanity check\
  Lossless encoding of the distance

  TODO:
  - Maybe introduce a different, abstract notation for the cost function (different form w)
  - Analytical vs WER maps
  - Directional vs omnidirectional maps (in both cases)
  - Material:
    - Training curves
    - Final results in terms of WER
]

The adopted proxy for the #acr("WER") is defined as:
The analytical cost is defined over the state space $cal(S)$ as:
// #let eta = $colMath(eta, #olive)$
// $
//   //c_a (s_t) = norm(bold(x)_"agent" - bold(x)_"source")_2^2 + theta\
//   C (
//     bold(x)_a,
//     theta_a,
//     bold(x)_s
//   ) = norm(bold(x)_a - bold(x)_a)_2^2 + eta "DoA"(bold(x)_a, theta_a, bold(x)_s),
// $
#func-def(
  analytical-cost,
  //$quad RR^2 times [0, 2pi] times RR^2$,
  $cal(S)$,
  $RR_+$,
  $(
    bold(x)_a,
    theta_a
    //bold(x)_s
  )$,
  $
  norm(bold(x)_s - bold(x)_a)_2^2 + eta "DoA"(bold(x)_a, theta_a, bold(x)_s),
  $
)
<eq:rl:results:analytical_cost>
where:
- $bold(x)_a$ and $theta_a$ are respectively the position and orientation of the agent in the room's frame;
- $bold(x)_s$ is the source position and is fixed for a given episode;
- $"DoA"(bold(x)_s, theta_a, bold(x)_s)$ is the direction of arival for this source-microphone positioning;
- $eta$ is a scaling factor; #draft[Say that we keep it as 1]

Similarly to the #acr("WER") cost, we normalize the obtained map to constrain its range in the $[0, 1]$ interval.
@fig:rl:results:analytical_map plots the analytical cost $C$

Our previous observations of real #acr("WER") maps motivate this formulation.

#include "figures/analytical_map/figure.typ"
#include "tables/maps_comparison.typ"


@fig:rl:results:analytical_map shows an example of 


=== Reward design

#draft[
  - Mention how important reward shaping is in DRL
  - Comparative study between different schemes (choices of $f$)
  - with or without early stopping (with and without big reward at the end)
]

==== Success signal and early stopping


#include "tables/early_stopping.typ"

==== Scalar reward shaping

#draft[
  Add a plot of the rewards as a function of $w(s_t)$
]

$
  r (s_t) = -w(s_t).
$

$
  r (s_t) = alpha e^(-beta w(s_t))
$
where $alpha$ and $beta$ are scaling parameters


#include "tables/reward_shaping.typ"

=== Feature extraction strategies

#draft[
  TODO: ablation study with/without pre-trained backbone
  - No pre-training at all: E2E training in #acr("RL")
  - Pre-training in SSL + frozen weights during #acr("RL") training
  - Pre-training in SSL + fine-tuning in RL
]

#include "tables/backbone_pretraining.typ"

=== Discussion and limitations

#draft[
  Limitations:
  - The solution struggles with too high reverberation levels (TODO: include ablation study to show this)

  - We only handled the single-source case in our experiments
  - The sources are static during an episode
  - As we pre-compute the WER, the set of initial source positions is finite.
  - The duration of each step is fairly large (1s) and should be reduced to approach a _real-time_ setup.

  - Extension to multi-source
]