#import "/utils.typ": *

== Summary of Contributions

#reset-acronym("SSL")
#reset-acronym("POMDP")

This thesis explored how deep learning can support spatial auditory perception and sound-driven decision-making for robots operating in acoustically complex environments. Across simulation, perception, and control, we proposed a coherent pipeline in which audio-based models were trained, evaluated, and integrated into higher-level behaviors. Rather than treating sound as a supplementary cue, we placed it at the core of the robotic perception loop—asking how far a robot can go by relying on audio alone.

// Simulator
To support this investigation, we first developed a modular and extensible *acoustic simulation platform*, tailored for learning-based robotic experiments.
Unlike existing tools focused on fixed environments or signal processing evaluation, our simulator was designed to generate dynamic, spatialized audio observations suitable for training and testing neural networks.
It supported the construction of controlled experimental settings, enabling reproducible comparisons across tasks and architectures.

// SSL
Using this foundation, we explored two formulations of the *#acr("SSL") problem*.
In the single-source case, we trained supervised deep models to estimate the #doa from short binaural audio segments.
We studied the effects of microphone array configuration, spatial feature encoding, and training loss formulation.
In the multi-source setting, we extended the problem to predict a continuous #doa spectrum capturing simultaneous speaker locations.
We adapted and reimplemented existing architectures within our framework, and conducted extensive ablations on model performance under varying spatial and acoustic conditions.
Together, these contributions provide a robust baseline for learning-based #acr("SSL") in simulated environments.

// ASSL
We then shifted from passive to *active localization*, introducing a method for aggregating directional predictions over time as a robot moves.
By accumulating egocentric DoA maps along a trajectory, we constructed spatial heatmaps that estimate source positions without relying on external localization data or privileged information.
This approach demonstrated how movement itself can be leveraged as a perceptual strategy, allowing the robot to disambiguate uncertain cues and improve spatial awareness over time.

// RL
Finally, we proposed a *reinforcement learning approach for perceptually motivated navigation*, where a robot learns to move in order to improve downstream #acr("ASR") performance.
We formalized the task as a #acr("POMDP") and trained policies using the #acr("PPO") algorithm.
The agent relied only on audio input and used a pretrained #acr("SSL") model as a feature extractor.
Despite the minimal sensing setup, the learned policies reliably navigated toward acoustically favorable positions.
This contribution shows that auditory perception can be treated not only as a sensory challenge but also as a control objective, where movement is learned to improve perception.

These contributions form a consistent and reproducible framework for investigating deep learning methods in auditory robotics.
The tools, models, and experimental insights developed throughout this work lay the foundation for future research in sound-driven interaction, navigation, and decision-making.