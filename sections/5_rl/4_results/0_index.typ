#import "/utils.typ": *
#import "../_variables.typ": *

== Experiments
<sec:rl:results>

After designing and implementing the complete #acr("RL") pipeline presented in the previous section, we turn to an experimental study of its capabilities and performance.

=== #acr("ASR") Performance in a Reverberant Room

First and foremost, we investigate how #acr("ASR") performance is impacted by reverberation. 
This study also explores the importance of the robot's position relative to the source, especially in highly reverberant environments.
#todo

*#acr("ASR") performance and reverberation.*
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

*Cost Map Directionality*

When the cost function is invariant in the agent orientation $theta_a$, the map is said to be omnidirectional.
In the case of the #acr("WER") cost #wer-cost, this is when an omnidirectional microphone is used to record signals at each position on the grid.
When a directional microphone is used, separate recordings are made for all four cardinal orientations of the agent.

it is omnidirec, omnidirectional maps correspond to the 

@fig:rl:results:directional_map aims at being

#include "figures/directional_wer_map/figure.typ"


=== Metrics and testing methodology
<sec:rl:results:metrics>

After training, a series of #n-ep episodes are executed to assess the performance of the #acr("RL") pipeline.
At each step, the agent greedily selects which action to take according to @eq:rl:intro:action_selection.
This selection technique differs from the training phase where the action is sampled according to the policy probability distribution $pi_theta$.

We define the primary performance metric for an episode as the loss value obtained at the final step.
The obtained final rewards are averaged over the #n-ep episodes:
$
  hat(C) = 1 / #n-ep sum_(i=1)^(#n-ep) r(s_T^i)
$
where $s_T^i$ is the final state of the $i$-th test episode

// TODO: where should I put this?
#include "figures/trajectories/figure.typ"


=== Reward Design

#include "figures/reward_function.typ"

*Exponential scaling.*
The base cost value is a scalar value between 0 and 1.
For example, most experiments use the #acr("WER") maps values #wer-cost.
A custom function #f-reward is designed to derive a reward signal from the underlying cost.
Most importantly, #f-reward must be a decreasing function of #cost-t.
We choose an exponential base to ensure the reward smoothly decays as #cost-t decreases.
More precisely, we introduce two scaling parameters #reward-exp-alpha and #reward-exp-beta to control the final reward range:
//$
//  f(#cost-t) = #reward-exp-alpha exp[-#reward-exp-beta #cost-t]
//$
#func-def(
  f-reward,
  $[0, 1]$,
  $RR$,
  cost-t,
  f-reward-exp + ".",
)
@fig:rl:results:reward plots the value of $#f-reward (#cost-t)$ in function of the cost value #cost-t.
//$
//  r_t = & #reward-exp-alpha e^(-#reward-exp-beta C_t) \
//        & quad - #reward-forward-penalty bb(1) (a_t = #a-forward) \
//        & quad - #reward-wall-penalty bb(1) (a_t "invalid"),
//$
The final reward, introduced in as @eq:rl:problem:reward  expression, becomes:
$
  r_t = cases(
    #reward-wall-penalty &quad "if the agent tries to hit a wall",
    #f-reward-exp
      - #reward-movement-penalty bb(1) (a_t = #a-forward) &quad "otherwise,"
  )
$
<eq:rl:results:reward>
where
- #reward-exp-alpha and #reward-exp-beta are the scaling factors for the exponential cost term;
- #reward-movement-penalty is the movement penalty;
- #reward-wall-penalty is the penalty for invalid movements.
  It corresponds to when the agent would hit a wall.
The values of these parameters were set after an empirical study of their impact.
The following paragraphs detail these investigations.

*Policy collapsing.*
Training a #acr("DRL") agent is significantly more intricate than classically supervised neural networks.
Training dynamics are complex, sensitive, and depend on multiple factors.
For instance, the numerous hyperparameters in the #acr("PPO") algorithm are pivotal.
Some turned out to be crucial for achieving proper training.
One example of the subtle instabilities encountered during our experimental study is the phenomenon of policy collapsing.
Due to the important expressivity of the feature vector extracted by the localizer backbone, it is easy to learn to move towards the source.
Let us denote this specific policy #pi-optimal.
Our initial experiments with the pre-trained backbone showed excellent performance, and the agent could consistently learn $pi^*$.
However, additional ablation studies demonstrated that the agent completely ignored the reward signal.
Completely numbing the reward by setting it to a constant or random value did not change the learnt behavior and the policy was still converging to #pi-optimal.
We interpret that the loss for the value function #ppo-value-loss (@eq:rl:intro:ppo:value_loss) and the entropy bonus #ppo-entropy-bonus prevail in the training dynamics.
It was expected that instead of converging to #pi-optimal, the learnt policy $pi_theta$ would collapse to the static policy, denoted #pi-still.
Indeed, in the absence of an informative reward signal and because of the penalties for hitting the room's walls (#reward-wall-penalty) and moving (#reward-movement-penalty), the agent would be expected to remain still.

*Reward scaling.*
The reward design needed further elaboration to prevent this phenomenon and ensure the reward signal dictated the learning behavior.
On the one hand, scaling up the reward permitted increasing its relative importance during training.
It balances the reward weight in the overall loss values and its gradients.
In practice, experimentally tuning the shaping coefficients led to choosing $#reward-exp-alpha = #reward-alpha-value$ and $#reward-exp-beta = #reward-beta-value$.
On the other hand, scaling #reward-movement-penalty to #reward-movement-penalty-value was also needed to balance its value properly concerning $#f-reward (#cost-t)$.
Once these two parameters were adequately tuned, the experiments were conducted voluntarily.


We observed that the policy's 


The 
$pi^*$ is the policy 
o


=== Alternative Cost Maps

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


=== Reward Design

#draft[
  - Mention how important reward shaping is in DRL
  - Comparative study between different schemes (choices of $f$)
  - with or without early stopping (with and without big reward at the end)
]

==== Success Signal and Early Stopping


#include "tables/early_stopping.typ"

==== Scalar Reward Shaping

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

=== Feature Extraction Strategies

#draft[
  TODO: ablation study with/without pre-trained backbone
  - No pre-training at all: E2E training in #acr("RL")
  - Pre-training in SSL + frozen weights during #acr("RL") training
  - Pre-training in SSL + fine-tuning in RL
]

#include "tables/backbone_pretraining.typ"