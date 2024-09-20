#import "/utils.typ": *

=== Discussion
<sec:ssl:multi_source:discussion>

Overall, we have bootstrapped a complete multi-source #acr("SSL") pipeline by drawing crucial inspiration from the work of He et al. in @he_deep_2018, @he_joint_2018 and @he_neural_2021.
This method was adapted and partly enhanced to provide convincing localization results on a challenging datasets collected thanks to the simulator presented in @chap:simulator.

The motivation to operate this large implementation effort was not to compete with state of the art #acr("SSL") solutions.
Conversely, the objective was to develop a flexible and effective platform that could be leveraged for achieving demanding dynamic robotic tasks.

The main advantage of the obtained method lies in its ability to handle a various number of sources.
This contrasts with the approach presented in @sec:ssl:single_source where only a single source can be localized at once.
Also, the network correctly handles cases where no speech sources are active in the environment.
An agent, given this module, would be able to act depending on the detected speech activity.
Furthermore, the short context window of 363ms with which the network has been trained on allows for using our model in real-time situations and let a decision policy act based on the localization results.

==== Limitations
Our framework still suffers from shortcomings.
On the one hand, the obtained metric values, even though respectable, do not line up 
with other works.
Indeed, although precise, as reaching more than 83% precision scores, sources get sometimes missed by the network.
Such a shortcoming motivated our investigation of sequence processing where we leverage multiple consecutive observations to enhance the performance of the method.
The addition of adversarial noise sources in the room, employing white noise and more realistically music instruments or the sound coming from a television would constitute an interesting extension of this work.
The presence of noise had an appreciable effect on the performance of our single source #acr("SSL") study (see @sec:ssl:single_source:experiments:noise).


#gaet[
  To which extent should I detail _how hard_ it was ?
  Is there some room to expose how tough it turned out to be, or should I stick to a more factual analysis ?
]

#draft[
  - [x] Performance is far from being perfect (SotA)
  - [x] No noise handling
  - [x] 2D environment (i.e. no 3D, no elevation). However, our simulator does support it

  Limitations:
  - Energy criteria (@sec:ssl:multi_source:method:dataset)
]

