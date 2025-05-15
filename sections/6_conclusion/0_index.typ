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
On the one hand, we showed how a simple deep convolutional network can localize a single source in a reverberant environment.
Our second model is deeper and more complex.
It addresses the more challenging setting of multi-source localization.
In both cases, attention was placed on conducting thorough experimental studies of the trained models.
We have explored the #acr("SSL") task to better grasp this problem's intricacies.
Furthermore, the obtained models could be used in the later stages of the project as part of more complex pipelines.
As such, we demonstrate that our deep localizers are flexible models that can be employed as feature extractors, for example.

*Active Sound Source Localization.*
In @chap:active_ssl, we have focused on a dynamic formulation of the source localization problem.
Inspiring from prior works in active sound source localization, especially in robotics, we have proposed an interesting challenge where a mobile robot is tasked to localize several sources in a reverberant room.
While predicting the #doa of multiple sources' signals has been achieved in the static case, accurately estimating the exact position to each source remained a difficult task.
In this dynamic context, the robot can aggregate point-wise angular estimates to form accurate predictions of the sources' relative positions.
We designed a complete pipeline for solving this task, leveraging the previously developed multi-source static localizer.
It entails projecting the #doa spectra to the 2D space by building egocentric maps.
These maps are then combined thanks to a deep neural network.
The U-net architecture is trained to map a series of past egocentric maps to a final heatmap that encodes each active source's relative position.
The second core component of this pipeline is the clustering algorithm, which extracts final position estimates from the computed heatmaps.
We have successfully tested our approach in various experimental settings thanks to the acoustic simulator's versatility.
An exhaustive study of the impact of different parameters and task variations has been conducted.

*Deep Reinforcement Learning for Sound-Driven Navigation.*
Our long-term goal was to design of capable robotic policies.
@chap:rl summarizes our investigation of #acr("DRL") methods for acoustic robotic navigations.
After probing the vast pool of state of the art #acr("RL") algorithms and their application to robotics, we proposed a novel task motivated by our previous contributions.
We showed that the performance of #acr("ASR") algorithms, which are essential to robot's ability to understand human speech, are highly affected by reverberation.
Therefore, we propose to train an agent to navigate in a reverberant environment so as to maximize the accuracy of its embedded #acr("ASR") system.
This perceptually motivated task requires the agent to intrinsically build strong localization capabilities that will allow it to find its way to the optimal position and orientation.
// TODO repetition "embedded"
To help with this, we bootstrapped a sound source localizer in the actor-critic neural network.
We achieved this by pre-training a feature extractor on a supervised sound source localization task, directly building on the models developed in @chap:ssl.
Thanks to this sound initialization of the network backbone, as well as careful tuning of #acr("PPO")'s numerous hyperparameters, we have been able to learn a working policy for this task.
The agent's behavior was evaluated both quantitatively and qualitatively in the virtual environment.
We also compared it to a selection of reference baselines to measure the improvement in #acr("ASR") performance.


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


== Prospective Research Directions

*From simulation to real robots.*
The most obvious extension of the work pursued in this PhD is its application to real robotic systems.

*Continuous audio-visual simulation.*

*End-to-end active localization.*
#draft[Directly train a model that is fed with a s]

*Audio-visual perceptionally-motivated navigation.*
The idea of optimizing robots' navigation policies to enhance their perception
@majumder_move2hear_2021