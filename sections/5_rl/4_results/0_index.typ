#import "/utils.typ": *

== Experiments and discussions
<sec:rl:results>

=== #acr("ASR") performance in a reverberant room

#draft[
  - Show how #acr("WER") decreases when adding reverb
]

=== Training with analytical maps

Before using real #acr("WER") maps, we have conducted experiments on synthetic cost maps.
We have used synthetic data to validate the concept of training an agent with our custom #acr("WER") maps.

#draft[
  Objective: sanity check\
  Lossless encoding of the distance
]

The adopted proxy for the #acr("WER") is defined as:
$
  hat("WER") = d + theta.
$
where:
- $d$ is the source-microphone distance
- $theta$ is the #doa between the source and the microphone

Our previous observations of real #acr("WER") maps motivate this formulation.

#figure(
  image(
    "figures/synthetic_wer_map.svg",
    width: 80%,
  ),
  caption: flex-caption(
    [Directional (east orientation) synthetic #acr("WER") map],
    [Directional synthetic WER map]),
)
<fig:rl:results:analytical_map>

@fig:rl:results:analytical_map shows an example of 


=== Real #acr("WER") maps

#draft[
  - Show how #acr("WER") decreases when adding reverb
  - Show examples of #acr("WER") maps on different settings
  - Maybe add a #acr("WER") map with a noise source, even if we don't explicitly do RL in this case.
]

#include "figures/wer_maps/figure.typ"

=== Reward shaping

#draft[
  - Mention how important reward shaping is in DRL
  - Comparative study between different schemes (choices of $f$)
]

$
  r_1 (s_t) = -w(s_t).
$

=== Feature extraction

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