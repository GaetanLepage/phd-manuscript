#import "/utils.typ": *

= Conclusion
<chap:conclusion>

== Summary of Contributions

In this thesis, we explored the vast domain of auditory perception for robotics.
In particular, we investigated how to make robots extract valuable information from the audio signals they record.
Our contributions involve different engineering efforts in the form of software libraries and pipelines.
These by-products of our research endeavor will hopefully enable future works to iterate and quickly test new ideas.
Furthermore, we designed, implemented, and tested various deep-learning models to perform a selection of auditory tasks.

*Acoustic simulator.*
Our first contribution is developing a capable virtual environment for modeling reverberant environments.
Building around libraries performing acoustic simulation, our solution allows for collecting data from 
complex scenarios.
Users can place an arbitrary multi-microphone array and several sound sources in a virtual reverberant room.
The sensor array and sources can be finely re-positioned for dynamic interaction settings.
The simulator embeds a notion of step-based operation with a controllable time resolution.
It ensures the smooth chaining of simulation steps and the consistency of generated and input signals.
The generated recordings can be up-sampled and further processed into various spectral representations.
This simulator is designed to be a flexible sandbox, allowing for diverse data collection or testing scenarios.
It has successfully been used within the other contributions of this thesis.
For instance, its versatile design has allowed us to smoothly derive a #acr("RL") environment from it.
A focus has been placed on the ease of use of researchers building novel acoustic algorithms for robotics.
We hope it can find many other use cases and help conduct future research in the field.

*Sound Source Localization* is a fundamental aspect of auditory perception in robotics.
@chap:ssl is dedicated to the study of this problem.
We tackled two formulations of the #acr("SSL") task.
On the one hand, we show how a simple deep convolutional network can localize a single source in a reverberant environment.
Our second model is deeper and more complex.
It addresses the more challenging setting of multi-source localization.
In both cases, attention was placed on conducting thorough experimental studies of the trained models.


*Active Sound Source Localization.*

*Deep Reinforcement Learning for Navigation.*


== Challenges and Limitations

*Restriction to simulated environments.*
Simulation provides a considerable amount of convenience when testing learning-based approaches for robotics.
It allows large datasets to be gathered to train deep neural networks without the costly, manual recording of real data.
Also, simulation offers a flexible sandbox for evaluating the performance of algorithms.
Large-scale comparative evaluation campaigns become feasible.
However, restricting our study to virtual environments is an obvious shortcoming of this thesis.
Ideally, the developed models would benefit from being tested on a robotic platform.
The #acr("SSL") literature insists on the challenges of integrating localizers on real robots. #draft[add citation].
Similarly, in #acr("RL"), the adaptation of policies trained in simulators to physical platforms is a research area in itself.
The numerous works on _Sim2Real_ #draft[Add citation] study these difficulties.
A fine-tuning phase is often necessary to bridge the performance gap, which is inevitably initially observed.
More generally, roboticists have extensively covered the shortcomings of simulation.

*Overly simplified problems.*
Tackling the different acoustic problems we chose to study has been significantly challenging.
As such, it was necessary to simplify the initially envisioned tasks.
Each of the acoustic problems discussed in this thesis have been scrutinized by experienced communities.
#gaet[Ça fait très victimaire. C'est le principe même de la recherche. Je pense qu'il faut au moins reformuler.]
We have been unable to design truly novel solutions competing with the existing state-of-the-art methods.
As such, #todo
- In #acr("RL"), it boiled down to learning to navigate towards the source instead of 


== Prospective Research Directions

*From Simulation to Real Robots.*
The most obvious extension of the work pursued in this PhD is its application to real robotic systems.

*Continuous Audio-Visual Simulation.*

*End-to-end Active Localization.*

*Audio-Visual Perceptionally-motivated Navigation.*
The idea of optimizing robots' navigation policies to enhance their perception
@majumder_move2hear_2021