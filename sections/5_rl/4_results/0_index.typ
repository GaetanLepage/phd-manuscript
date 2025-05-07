#import "/utils.typ": *

== Experiments and discussions
<sec:rl:results>

#include "figures/trajectories/figure.typ"

=== #acr("ASR") performance in a reverberant room

#draft[
  - Show how #acr("WER") decreases when adding reverb
  - This study motivates our choice for WER as an interesting objective / cost function
  - Show how #acr("WER") decreases when adding reverb
  - Show examples of #acr("WER") maps on different settings
  - Maybe add a #acr("WER") map with a noise source, even if we don't explicitly do RL in this case.
]


// #include "figures/wer_maps/figure.typ"

=== Alternative cost maps

Before using real #acr("WER") maps, we have conducted experiments on artificial cost maps.
We have used synthetic data to validate the concept of training an agent with our custom #acr("WER") maps.

#draft[
  Objective: sanity check\
  Lossless encoding of the distance

  TODO:
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

#draft[]

$
  r (s_t) = -w(s_t).
$

$
  r (s_t) = alpha e^(-beta w(s_t))
$
where $alpha$ and $beta$ are scaling parameters

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