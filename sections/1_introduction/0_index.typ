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


=== Multi-Modal Perception, a Focus on Acoustics

Multi-modal perception for a robot consists of its ability to sense and understand the environment around it.
Robots can be equipped with various sensors depending on their objectives, nature, and budget constraints.
For example, #acr("LIDAR") sensors allow for estimating the distance to surrounding objects and are widely used in autonomous vehicles.
Cameras and microphones are cost-effective and let robots sense their environment like humans.
Multimodal perception requires extracting task-relevant information from this kind of raw sensor data.
It entails extracting knowledge from the raw gathered data that is valuable for the task.
For instance, object detection involves localizing and classifying semantic objects in the captured frames.
Multi-object tracking adds a temporal aspect to the task by including tracking each identified object across time.
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


=== Reinforcement Learning: a Powerful yet Challenging Framework for Learning Robot Policies

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

Perceptually-motivated navigation is an interesting example of a complex multimodal robotics task.
It can be framed in various ways, depending on the context and the targeted application.
Ultimately, robots are tasked to perform complex actions, requiring gathering information and carefully planning actions with anticipation.
Furthermore, exhaustively observing the environment is often impossible as sensors are limited and context might be missing or hidden.
Hence, a robot must willingly explore its environment to collect the necessary information and enhance its overall perception.
For example, the _Move2Hear_ task @majumder_move2hear_2021 requires a mobile robot to navigate in a realistic environment to enhance its ability to separate distinct speech sources.
Other different objectives could be used to motivate an agent's exploration strategy.

Objective: optimize ASR
- Robots need to understand what humans say to interact with them.
- ASR systems are sensible to the position of the agent -> let's optimize the agent's position


== Outline and Contributions

Final goal: learn a policy for a robot to navigate

Main challenges:
- Design and implement from scratch
- Only acoustic perception

=== Building a Sandbox for Room Acoustic Simulation

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

=== Sound Source Localization

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
  

=== Deep Reinforcement Learning for Acoustic Navigation

Complete RL pipeline design and implementation:
- Invent/define the task.
  Importantly, we motivate the task by "quantifying" the impact of navigation/positioning on the ASR performance
- Implement the environment thanks to our simulator
- Learn about PPO and implement from scratch
- Train and evaluate the policy + visualization


== Thesis Structure


- Explain how chapters are articulated.
- Give the general organization of the manuscript

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