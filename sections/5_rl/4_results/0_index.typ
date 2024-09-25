#import "/utils.typ": *

== Experiments and discussions
<sec:rl:results>

=== Training with analytical maps

=== Real #acr("WER") maps

=== Reward shaping

#draft[
  - Mention how important reward shaping is in DRL
  - Comparative study between different schemes (choices of $f$)
]

=== Feature extraction

#draft[
  TODO: ablation study with/without pre-trained backbone
]

=== Discussion and limitations

#draft[
  Limitations:
  - The solution struggles with too high reverberation levels (TODO: include ablation study to show this)

  - We only handled the single-source case in our experiments
  - The sources are static during an episode
  - As we pre-compute the WER, the set of initial source positions is finite.

  - Extension to multi-source
]