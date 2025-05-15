#import "/utils.typ": *

== Summary of Contributions

#reset-acronym("SSL")
#reset-acronym("POMDP")

#draft[

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
]

This thesis explored how deep learning can support spatial auditory perception and sound-driven decision-making for robots operating in acoustically complex environments. Across simulation, perception, and control, we proposed a coherent pipeline in which audio-based models were trained, evaluated, and integrated into higher-level behaviors. Rather than treating sound as a supplementary cue, we placed it at the core of the robotic perception loop—asking how far a robot can go by relying on audio alone.

// Simulator
To support this investigation, we first developed a modular and extensible acoustic simulation platform, tailored for learning-based robotic experiments.
Unlike existing tools focused on fixed environments or signal processing evaluation, our simulator was designed to generate dynamic, spatialized audio observations suitable for training and testing neural networks.
It supported the construction of controlled experimental settings, enabling reproducible comparisons across tasks and architectures.

// SSL
Using this foundation, we explored two formulations of the #acr("SSL") problem.
In the single-source case, we trained supervised deep models to estimate the #doa from short binaural audio segments.
We studied the effects of microphone array configuration, spatial feature encoding, and training loss formulation.
In the multi-source setting, we extended the problem to predict a continuous #doa spectrum capturing simultaneous speaker locations.
We adapted and reimplemented existing architectures within our framework, and conducted extensive ablations on model performance under varying spatial and acoustic conditions.
Together, these contributions provide a robust baseline for learning-based #acr("SSL") in simulated environments.

// ASSL
We then shifted from passive to active localization, introducing a method for aggregating directional predictions over time as a robot moves.
By accumulating egocentric #doa maps along a trajectory, we constructed spatial heatmaps, which estimate the source positions without requiring any ground-truth localization or odometry.
This approach demonstrated how movement itself can be leveraged as a perceptual strategy, allowing the robot to disambiguate uncertain cues and improve spatial awareness over time.

// RL
Finally, we proposed a reinforcement learning approach for perceptually motivated navigation, where a robot learns to move in order to improve downstream #acr("ASR") performance.
We formalized the task as a #acr("POMDP") and trained policies using the PPO algorithm.
The agent relied only on audio input and used a pretrained SSL model as a feature extractor.
Despite the minimal sensing setup, the learned policies reliably navigated toward acoustically favorable positions.
This contribution shows that auditory perception can be treated not only as a sensory challenge but also as a control objective, where movement is learned in service of better perception.