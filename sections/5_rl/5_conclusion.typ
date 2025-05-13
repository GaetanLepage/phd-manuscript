#import "/utils.typ": *

== Conclusion
<sec:rl:conclusion>


#gaet[
  This should probably go in the conclusion.
]
The entire #acr("RL") pipeline presented in this chapter has been implemented from scratch.
It entails the #acr("RL") environment for the sound-driven navigation task, along with the computation of #acr("WER") maps, the #acr("PPO") algorithm, the neural network model, and the training and evaluation logic.

#draft[
  The main thing to say is that this task in itself is trivial (it consists in going to the source).\
  However, we show that we can solve a perceptually-motivated navigation task thanks to:
  - #acr("RL")
  - a pre-trained localizer as the backbone.

  Other positive aspects:
  - Significant engineering effort (env + PPO + agent + WER maps)
  
  Limitations:
  - The solution struggles with too high reverberation levels (TODO: include ablation study to show this)
  - We only handled the single-source case in our experiments
  - The sources are static during an episode
  - On aurait p
  - As we pre-compute the WER, the set of initial source positions is finite.
  - The duration of each step is fairly large (1s) and should be reduced to approach a _real-time_ setup.

  - Extension to multi-source
  - Ouverture: combine chapitres 4 et 5...
]