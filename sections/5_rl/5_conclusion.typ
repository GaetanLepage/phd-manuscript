#import "/utils.typ": *

== Conclusion
<sec:rl:conclusion>

#draft[
  Limitations:
  - The solution struggles with too high reverberation levels (TODO: include ablation study to show this)

  - We only handled the single-source case in our experiments
  - The sources are static during an episode
  - As we pre-compute the WER, the set of initial source positions is finite.
  - The duration of each step is fairly large (1s) and should be reduced to approach a _real-time_ setup.

  - Extension to multi-source
]