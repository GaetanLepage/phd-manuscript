#import "/utils.typ": *

== Experiments and discussions
<sec:rl:results>

=== #acr("ASR") performance in a reverberant room

#draft[
  - Show how #acr("WER") decreases when adding reverb
]

=== Training with analytical maps

#draft[
  Objective: sanity check\
  Lossless encoding of the distance
]

=== Real #acr("WER") maps

#draft[
  - Show how #acr("WER") decreases when adding reverb
  - Show examples of #acr("WER") maps on different settings
]

=== Reward shaping

#draft[
  - Mention how important reward shaping is in DRL
  - Comparative study between different schemes (choices of $f$)
]

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