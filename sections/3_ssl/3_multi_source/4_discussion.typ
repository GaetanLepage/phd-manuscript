#import "/utils.typ": *

=== Discussion
<sec:ssl:multi_source:discussion>

Overall, we have bootstrapped a complete multi-source #acr("SSL") pipeline by drawing crucial inspiration from the work of He et al. in @he_deep_2018, @he_joint_2018 and @he_neural_2021.
This method was adapted and partly enhanced to provide convincing localization results on challenging datasets collected thanks to the simulator presented in @chap:simulator.

The motivation for operating this large implementation effort was not to compete with state-of-the-art #acr("SSL") solutions.
Conversely, the objective was to develop a flexible and effective platform that could be leveraged to achieve demanding dynamic robotic tasks.

The main advantage of the obtained method lies in its ability to handle a various number of sources.
This contrasts with the approach presented in @sec:ssl:single_source where only a single source can be localized simultaneously.
Also, the network correctly handles cases where no speech sources are active in the environment.
Given this module, an agent would be able to act depending on the detected speech activity.
Furthermore, the short context window of 363ms on which the network has been trained allows for using our model in real-time situations.
It thus permits a decision policy to act based on the localization results.

==== Limitations
Our framework still suffers from shortcomings.
On the one hand, the obtained metric values, even though respectable, do not line up 
with other works.
Indeed, although precise, as it reached more than 83% precision scores, the network sometimes misses some sources.
Such a shortcoming motivated our investigation of sequence processing, in which we leverage multiple consecutive observations to enhance the method's performance.
Adding adversarial noise sources in the room, employing white noise and, more realistically, sound from musical instruments or television would constitute an interesting extension of this work.
//The presence of noise had an appreciable effect on the performance of our single source #acr("SSL") study (see @sec:ssl:single_source:experiments:noise).
It would thus be interesting to study the impact of noise on this approach.

// #gaet[
//   To which extent should I detail _how hard_ it was ?
//   Is there some room to expose how tough it turned out to be, or should I stick to a more factual analysis ?
// ]
// 
// #draft[
//   - [x] Performance is far from being perfect (SotA)
//   - [x] No noise handling
//   - [x] 2D environment (i.e. no 3D, no elevation). However, our simulator does support it
// 
//   Limitations:
//   - Energy criteria (@sec:ssl:multi_source:method:dataset)
// ]

