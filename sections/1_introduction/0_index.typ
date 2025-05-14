#import "/utils.typ": *

= Introduction
<chap:intro>

== Motivations

=== Social Robotics & Embodied AI

In recent years, there has been flourishing and rapid progress in #acr("AI").
The performance of #acr("AI") systems has evolved dramatically in a short period.
Subsequently, these techniques have been used in numerous domains, ranging from highly specialized applications to widely spread end-consumer products.
These disruptive technologies significantly impact our daily lives, societies, and economies.
#acrpl("LLM") are surely the latest and most striking illustration of this revolution.
Since the invention of the attention mechanism and the transformer architecture in 2017 @vaswani_attention_2017, larger and larger models could be trained on constantly growing datasets.
The capabilities of #acrpl("LLM")s have pushed the boundaries of artificial reasoning and natural language processing.
Similarly, diffusion models have been equally successful for image generation.
Although interactions with these systems are still primarily text-based, academic and industrial actors invest substantial resources in making them more natural.
More precisely, #acr("AI") agents aim to interact with humans directly through speech and vision.
Some solutions, like KyutAI's Moshi @defossez_moshi_2024, can now have a two-way conversation with a human in real time.
Speech-based interaction is a central research challenge in #acr("HRI").
More generally, the design of embodied agents is at the core of social robotics.
Social robots operate in complex, dynamic, and often crowded environments.
They differ from traditional robots, such as the ones used in industrial settings to perform repetitive, narrow-scope actions.
These robots do not need to adapt and interact in an unpredictable environment.
Their policy is often deterministic and programmed in advance.
Also, they are not expected to interact naturally with humans.
Bridging the gap to performant social robots turned out to be considerably challenging.

#todo
As Hans Moravec observed in the 1980s, tasks that are easy for humans — like perception and motor coordination — are surprisingly difficult for robots, whereas abstract reasoning is often easier for machines [3].

In 1986, Hans Moravec famously introduced the following paradox.
High-level reasoning, which is difficult for humans, tends to be relatively easy for computers.
However, sensorimotor skills, which all humans learn at a very young age, are extremely difficult for #acr("AI") and robots.
_It is comparatively easy to make computers exhibit adult-level performance in solving problems on intelligence tests or playing checkers, and difficult or impossible to give them the skills of a one-year-old when it comes to perception and mobility._ @moravec_mind_1988
His observation, from 1988, remains highly relevant today as multimodal perception and action remain key challenges in #acr("AI") and robotics.


=== Multimodal Perception, a Focus on Acoustics

Multi-modal perception for a robot consists of its ability to sense and understand the environment around it.
Robots can be equipped with various sensors depending on their objectives, nature, and budget constraints.
For example, LIDAR sensors allow for estimating the distance to surrounding objects and are widely used in autonomous vehicles.
Cameras and microphones are cost-effective and let robots sense their environment like humans.
Multimodal perception requires extracting task-relevant information from this kind of raw sensor data.
It entails extracting knowledge from the raw gathered data that is valuable for the task.
For instance, object detection involves localizing and classifying semantic objects in the captured frames.
Multi-object tracking adds a temporal aspect to the task by tracking each identified object across time.
Depth estimation attempts to infer how far each pixel is in an image.
Regarding auditory perception, #acr("ASR") aims to enable machines to "understand" human speech by transcribing audio input into a readable format.
This task is essential in social robotics as speech is often the primary communication channel between humans and robots.
#acr("SSL") involves estimating the direction or position of the active audio sources in an environment.
#acr("SSL") helps robots be more spatially aware by complementing visual features.
Also, it allows them to know which person is currently speaking and where she is located.
Therefore, social robots can behave accordingly to the conversation dynamics.
#acr("SSL") can also provide crucial sensory context regarding robot navigation.


#figure(
  image(
    "./figures/ari.png",
    width: 6cm
  ),
  caption: [
    A photo of the ARI robot, a humanoid robotic platform developed by PAL Robotics.
  ],
)
<fig:intro:ari>


=== Learning Robot Policies with Reinforcement Learning

Reinforcement learning is a flexible framework for solving discrete-time decision problems.
#acr("RL") has a long history of research and has allowed numerous successes in various application domains.
Since the rise of deep learning methods, #acr("RL") has benefited from more effective and capable models and function approximators.
By leveraging high loads of training data, #acr("DRL") methods allow for the training of deep neural network models with great capacity.
This shift from traditional #acr("RL") methods to modern neural-based algorithms has considerably broadened the scope of problems that could be tackled.
Traditional #acr("RL") was limited to low-dimensional observation spaces.
The use of #acrpl("DNN") as function approximators expanded #acr("RL")'s applicability to high-dimensional, unstructured inputs.
#draft[TODO, examples?]
Such fundamental progress clearly impacted robotics, which is well suited to #acr("RL")'s sequential problem formulation.
Indeed, relevant robot behaviors are complex and cannot be modeled explicitly, especially in social robotics.
This restrains traditional, deterministic algorithms where rules must be explicitly formalized.
#acr("RL") proposes an alternative solution to the problem of robot policy design.
It relies on defining a reward function that gives the agent feedback on the quality of its action.
The agent will then progressively optimize its policy by interacting with the environment to maximize the collected reward.
Therefore, it is not required to model the environment explicitly; it is implicitly learned during training.
#acr("DRL") allows learning from high-dimensional sensory inputs, such as camera frames or recorded audio signals.
#draft[TODO, examples?]
However, these approaches are extremely data-intensive and require considerable interaction with the environment to learn.
#acr("DRL") rapidly achieved impressive results on entirely virtual tasks where interacting with the environment is cost-effective and scalable.
By contrast, robots are embodied entities and must ultimately interact with the real world.
#draft[Maybe one or two papers with examples of the scale of interactions. Even though I already gave such examples in Chap 2 and 5.]
Therefore, most approaches adopt a hybrid strategy, in which the policy is first trained on a simulated replication of the environment and then transferred to the physical one.
The so-called _Sim-to-Real_ gap characterizes the challenges of deploying such virtually-trained policies to real robots.
Overall, #acr("DRL") is a powerful framework for robotics and numerous successful applications in this domain have been found.
However, it suffers from key limitations such as poor generalization, sample inefficiency, and a lack of explainability.

=== Acoustic Localization and Navigation to Enhance Perception

#draft[
Objective: optimize ASR
- Robots need to understand what humans say to interact with them.
- ASR systems are sensible to the position of the agent -> let's optimize the agent's position
]

Perceptually-motivated navigation is an interesting example of a complex multimodal robotics task.
It can be framed in various ways, depending on the context and the targeted application.
Ultimately, robots are tasked to perform complex actions, requiring gathering information and carefully planning actions with anticipation.
Furthermore, exhaustively observing the environment is often impossible as sensors are limited and context might be missing or hidden.
Hence, a robot must willingly explore its environment to collect the necessary information and enhance its overall perception.
For example, the _Move2Hear_ task @majumder_move2hear_2021 requires a mobile robot to navigate in a realistic environment to enhance its ability to separate distinct speech sources.
Other different objectives could be used to motivate an agent's exploration strategy.


== Outline and Contributions

This thesis explores how deep learning can be leveraged to enhance acoustic perception in robotics, with a focus on sound source localization and navigation tasks driven by auditory input.
The contributions are centered around the development of tools and learning-based methods that enable social robots to operate more effectively in complex, reverberant environments using audio alone.
The research is articulated across four technical chapters, each addressing a distinct sub-problem: from simulation and signal modeling to supervised perception and reinforcement learning.
All contributions are supported by original software implementations and extensive experimentation.


=== A Modular Simulation Platform for Robotic Acoustic Learning

#draft[
Maybe our most relevant/useful contribution.
This is the core building block of the entire PhD project.
It leverages a SotA library for the RIR estimation.
We then build an entire multi-function library around it.
It can be used to do several things:
  - collect datasets (static, dynamic)
  - RL environment
  - compute WER maps
Can configure the reverb, the microphone array etc...
Insist that it can be used and extended to conduct future research.
We built it as a toolbox for research.
]

The first core contribution is the development of a custom acoustic simulation platform (@chap:simulator).
We introduce a flexible and feature-rich simulation framework for acoustic robotics, developed as a foundational tool for the research conducted in this thesis.
Modern deep learning methods—particularly in #acr("SSL") and #acr("DRL")—require large-scale data that is difficult to acquire through physical experimentation.
To address this, we designed a modular simulator that generates realistic multi-channel audio recordings in 3D virtual rooms.
The simulator supports customizable microphone arrays, varied source types (speech, noise), and dynamic trajectories for both sources and receivers.
It integrates two back-end RIR simulation engines: the feature-rich but slower _Pyroomacoustics_ @scheibler_pyroomacoustics_2018, and the high-performance GPU-accelerated _gpuRIR_ @diaz-guerra_gpurir_2021 library.
Additional layers of abstraction were developed to model robot movement, generate egocentric acoustic features, and simulate realistic interaction scenarios in a step-based pipeline.
A novel method was also introduced to bootstrap reverberation across short simulation steps, allowing accurate modeling of reverberant tails during dynamic agent movement.
This simulator, released as open-source research software, is used throughout the thesis for dataset generation, training supervision, and online policy interaction.


=== Learning-Based Sound Source Localization in Static Settings

#draft[
- Static
  - single-source:
    huge field of research. But we build our own pipeline and train it on our simulator.
    100% homemade implementation
  - multi-source:
    Leveraging an existing work, but we implement it ourself and demonstrate strong multi-source localization performance in our simulator
- Active localization:
  Quite novel (at least we didn't copy) approach to a form of active SSL.
  Estimating distance is hard, but we leverage movement to accumulate position information over time.
  We use our existing SSL implem as a base, and then show how we use it in a dynamic context.
]

Static sound source localization is the focus of chap:ssl, where we examine how deep learning can address this fundamental challenge in speech-based auditory perception.
We begin with a focused literature review of this fundamental signal processing task, covering both classical methods and recent deep learning-based approaches.
The chapter then explores two deep learning-based localization pipelines developed and tested using synthetic datasets generated by our simulator.

In the single-source setting, a convolutional neural network is trained to estimate the #doa of a speech source based on interaural features (ILD and IPD).
We evaluate the model across several microphone array layouts and signal representations, showing how design choices—such as array geometry, microphone directivity, and feature pre-processing—impact performance.
This analysis offers practical insights into building accurate, low-latency #acr("SSL") models using compact hardware setups.

The multi-source formulation extends the problem to scenarios with an arbitrary number of active speakers.
An angular spectrum representation is adopted, framing #acr("SSL") as a continuous regression task.
A dedicated convolutional architecture is implemented and trained on a large synthetic dataset, with performance evaluated using both fixed and variable source counts.
Though inspired in part by prior work @he_neural_2021, the pipeline was reimplemented, adapted, and integrated into our experimental framework.
Additional contributions include a detailed ablation study on source proximity, context length, and alternative loss formulations.

Together, these experiments establish robust and reproducible baselines for #acr("SSL") in complex environments, forming a foundation for the dynamic and interactive extensions developed in the next chapters.


=== Active Sound Source Localization through Temporal Aggregation

@chap:active_ssl builds on the multi-source localization model and extends it to an active #acr("SSL") setting, where the robot uses its motion to improve spatial inference over time.
In realistic social environments, robots rarely remain stationary; movement introduces new observations and challenges, such as time-alignment, aggregation, and non-stationarity.
We define a dynamic localization task where the agent observes a sequence of egocentric DoA spectra as it moves, and must aggregate these over time to estimate the global positions of multiple active sources.
Our approach consists of a two-stage pipeline: (1) a temporal aggregation module that fuses directional predictions over short trajectories, and (2) a clustering and filtering procedure to extract candidate source locations.
We analyze different aggregation and filtering strategies, and evaluate the performance across variations in motion speed, horizon length, and angular resolution.
Experiments show that integrating observations over time yields significant accuracy improvements, particularly in challenging cases with occlusion, reverberation, or ambiguous initial observations.
Importantly, this contribution demonstrates how embodied perception—where the robot’s movement directly contributes to improving its auditory scene understanding—can be implemented in a learning-compatible framework.


=== Perceptually Guided Navigation via Deep Reinforcement Learning

#draft[
Complete RL pipeline design and implementation:
- Invent/define the task.
  Importantly, we motivate the task by "quantifying" the impact of navigation/positioning on the ASR performance
- Implement the environment thanks to our simulator
- Learn about PPO and implement from scratch
- Train and evaluate the policy + visualization
]

Chapter 5 explores how reinforcement learning can be used to train robots to act in ways that improve their own auditory perception.
We introduce a novel sound-driven navigation task, in which a robot must move within a room to optimize its position with respect to a speech source, with the goal of improving #acr("ASR") performance.
This task is motivated by the observation that ASR systems are highly sensitive to reverberation and signal-to-noise conditions.
The robot is rewarded based on the Word Error Rate (WER) achieved by a downstream ASR system on the captured audio.
To tackle this problem, we design a complete DRL pipeline based on the #acr("PPO") algorithm.
The agent operates in a discrete action space and receives only audio-based observations, encoded through directional spectral features.
We implement and train the policy in simulation, using the LibriSpeech dataset and our acoustic simulator.
To evaluate the policy, we conduct an ablation analysis of the reward shaping, feature representations, and training configurations.
Results show that the learned policy consistently reduces ASR error rates compared to baseline strategies, and demonstrates interpretable movement patterns that favor low-reverberation listening spots.
This contribution highlights how auditory perception can be framed as an optimization target, and how deep RL enables the emergence of purposeful, perception-driven behavior.


=== Scope, Methodology, and Implementation Context

A deliberate constraint throughout the thesis is the exclusive use of acoustic sensing.
While audio is often used in combination with vision or depth sensing in robotics, this work focuses solely on microphone-based input to explore how far auditory perception alone can be pushed.
This makes the learning tasks harder but also more focused, and aligns with biological inspiration—many animals rely heavily on hearing for navigation and interaction.
This constraint also emphasizes the contribution of the acoustic simulation platform, which enables the creation of large, diverse datasets without relying on costly visual modeling.

The entire research pipeline—simulator, datasets, models, training routines, and evaluation tools—was developed from scratch as part of this thesis.
No pre-existing codebase was forked or extended.
Instead, each module was built to fit within a coherent ecosystem.
This reflects a dual contribution: a set of scientific results in deep learning for robotic audition, and a reproducible software foundation for future research in the field.


== Thesis Structure


#figure(
  image("figures/diagram.svg", width: 80%),
  caption: flex-caption(
    short: [
      Overview of the thesis organization.
    ],
    long: [
      Overview of the thesis organization.
      Each chapter, represented by a block, outlines a specific contribution.
    ],
  ),
)
<fig:intro:thesis_structure>

@fig:intro:thesis_structure  provides a graphical overview of the thesis organization, which is structured around four technical chapters, each corresponding to a specific contribution.

@chap:simulator introduces key acoustic principles and reviews the state of the art in room acoustic simulation.
It presents the custom simulation library developed for this thesis, detailing its architecture, capabilities, and performance.
This simulator supports both static and dynamic scenarios and serves as the foundation for all subsequent experiments.

@chap:ssl addresses the task of #acr("SSL").
After reviewing relevant literature, we present deep learning-based models for both single- and multi-source localization.
These models are evaluated within our simulated environment, with a focus on their robustness and limitations.

@chap:active_ssl extends the #acr("SSL") problem to dynamic settings.
We define an active localization task in which the robot moves to improve spatial awareness.
A deep-learning-based pipeline is introduced to accumulate localization evidence over time, leveraging motion as a source of information.

#reset-acronym("DRL")
@chap:rl applies #acr("DRL") to a perceptually motivated navigation task.
Here, the robot learns to reposition itself in order to improve #acr("ASR") performance, using only acoustic feedback.
We describe the task design, learning setup, and policy evaluation.

@chap:conclusion concludes the thesis by summarizing the main contributions, highlighting limitations, and proposing future research directions.


This structure reflects a gradual progression—from simulation tools (Chapter 2), to perception (Chapters 3 and 4), and finally to learned control and behavior (Chapter 5).
Each stage builds upon the previous one to address the overarching challenge of embodied auditory intelligence in robotics.

#draft[

  An interesting point is the limitation to audio.
  - On the one hand, it is a limit as we didn't have the time to explore visual perception.
  - On the other hand, learning from audio only is harder (less information)

  Critic evaluation:
  *Positives:*
  - Decent engineering effort
    - Capable simulator, with various simulation
    - All the software has been developped from scratch:
      - Deep Networks;
      - Algorithms (supervised, RL...)
      - Data collection
    -> We do not fork an existing code base.
  
  *Negatives / Limits (Why this work might be completely useless):*
  - Better simulators exist. Ours is very simplistic
  - No novelty on the (static) SSL part.
    - We haven't used transformers
    - Not trained/evaluated on a physical real-world setup
  - Active SSL is fairly new...
  - Our RL policy is not really useful as:
    - Better ASR that are less sensible to position might exist
    - other similar works exist and are more capable
  - In general, no attention to adversarial noise sources
  - *More specifically, this is basically _Move2Hear_ but worse.*
]

// == Funding
// 
// The SPRING H2020 project @alameda-pineda_socially_2024 aimed at bringing socially capable robots to gerontological healthcare.
// It brought together eight European academic and industrial partners to develop the algorithms, models, and software components necessary for the ARI robot to successfully perform complex social tasks (@fig:intro:ari).
// This PhD project was funded as a component of the SPRING project.