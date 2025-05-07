#import "/utils.typ": *

== Experiments and discussions
<sec:rl:results>

After designing and implementing the complete #acr("RL") pipeline presented in the previous section, we turn to an experimental study of its capabilities and performance.

#include "figures/trajectories/figure.typ"

=== #acr("ASR") performance in a reverberant room

First and foremost, we investigate how #acr("ASR") performance is impacted by reverberation. 
Also, this study explores the importance of the robot position with respect to the source, especially in highly reverberant environments.

#draft[
  - Show how #acr("WER") decreases when adding reverb
  - *This study motivates our choice for WER as an interesting objective / cost function*
  - Show how #acr("WER") decreases when adding reverb
  - Show examples of #acr("WER") maps on different settings
  - Motivate the use of $T_60 = 0.5s$
]

@fig:rl:results:wer_maps_reverb a

#include "figures/wer_maps/figure.typ"


=== Alternative cost maps

Before using #acr("WER") maps to compute the reward, we have conducted experiments with alternative cost maps.
As illustrated previously ()

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
$
  hat("WER") = d + theta.
$
where:
- $d$ is the source-microphone distance
- $theta$ is the #doa between the source and the microphone

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