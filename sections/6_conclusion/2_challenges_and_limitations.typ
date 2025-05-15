#import "/utils.typ": *

== Challenges and Limitations

*Restriction to simulated environments.*
Simulation provides a considerable amount of convenience when testing learning-based approaches for robotics.
It allows large datasets to be gathered to train deep neural networks without the costly, manual recording of real data.
Also, simulation offers a flexible sandbox for evaluating the performance of algorithms.
Large-scale comparative evaluation campaigns become feasible.
However, restricting our study to virtual environments is an obvious shortcoming of this thesis.
Ideally, the developed models would benefit from being tested on a robotic platform.
The #acr("SSL") literature insists on the challenges of integrating localizers on real robots. #draft[add citation].
Similarly, in #acr("RL"), adapting policies trained in simulators to physical platforms is a research area in itself.
The numerous works on _Sim2Real_ #draft[Add citation] study these difficulties.
A fine-tuning phase is often necessary to bridge the performance gap, which is inevitably initially observed.
More generally, roboticists have extensively covered the shortcomings of simulation.

*Overly simplified problems.*
Tackling the different acoustic problems we chose to study has been significantly challenging.
As such, it was necessary to simplify the initially envisioned tasks.
Experienced communities have scrutinized each of the acoustic tasks discussed in this thesis.
#gaet[Ça fait très victimaire. C'est le principe même de la recherche. Je pense qu'il faut au moins reformuler.]
We have been unable to design truly novel solutions competing with the existing state-of-the-art methods.
Our investigations would benefit from additional efforts to improve overall performance.
Switching to more modern architecture, such as attention-based transformers @vaswani_attention_2017 would be a sensible first step in enhancing our current models.
In the specific case of our #acr("RL") task, only a restricted and sanitized framing was handled.
The transition to more complex room geometries would probably underscore the need for adaptable policies.
Our current proof of concept heavily relies on the #acr("SSL") backbone for feature extraction.
The agent's decision-making capabilities play a minor role in the end, as the optimal policy involves moving in the direction of the source.
Hardening the problem formulation could make such trivial policies insufficient, fully justifying using #acr("RL") as a framework for this task.
