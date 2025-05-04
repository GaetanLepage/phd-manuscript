#import "/utils.typ": *

= Introduction
<chap:intro>

== Motivations

=== Social robotics & embodied AI

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
More generally, the design of embodied, intelligent, and capable agents is at the core of social robotics.
Social robots operate in complex, dynamic, and often crowded environments.
They differ from traditional robots, such as the ones used in industrial settings to perform repetitive, narrow-scope actions.
These robots do not need to adapt and interact in an unpredictable environment.
Their policy is often deterministic and programmed in advance.
Also, they are not expected to interact naturally with humans.
Bridging the gap to performant social robots turned out to be considerably challenging.
In 1986, Hans Moravec famously introduced the following paradox.
High-level reasoning, which is difficult for humans, tends to be relatively easy for computers.
However, sensorimotor skills, which all humans learn at a very young age, are extremely difficult for #acr("AI") and robots.
_It is comparatively easy to make computers exhibit adult-level performance in solving problems on intelligence tests or playing checkers, and difficult or impossible to give them the skills of a one-year-old when it comes to perception and mobility._ @moravec_mind_1988
His observation, from 1988, remains highly relevant today as multimodal perception and action remain key challenges in #acr("AI") and robotics.


=== Multi-modal perception, a focus on acoustics

Multi-modal perception for a robot consists of its ability to sense and understand the environment around it.
Robots can be equipped with various sensors depending on their objectives, nature, and budget constraints.
LIDAR sensors, for example, allow for estimating the distance to surrounding objects and are widely used in autonomous vehicles.
Cameras and microphones are cost-effective and let robots sense their environment like humans.
Processing the resulting information flux is a crucial aspect of multimodal perception.
It entails extracting knowledge from the raw gathered data that is valuable for the task.
For instance, object detection involves localizing and classifying semantic objects in the captured frames.
Multi-object tracking adds a temporal aspect to the task by including tracking each identified object across time.
Depth estimation attempts to infer how far each pixel is in an image.
In sound source localization, the system should estimate the direction or position of the active sources in an environment.


#figure(
  image(
    "./figures/ari.png",
    width: 5cm
  ),
  caption: [
    A photo of the ARI robot, a humanoid robotic platform developed by PAL Robotics.
  ],
)
<fig:intro:ari>


=== Reinforcement learning, a powerful yet challenging framework for learning robot policies

- Motivate the choice of RL for learning complex policies for robots.
- Example of success of RL in robotics, especially with DRL
- Issue: data requirements -> need for simulators
- Challenges of DRL: unstable, lack of generalization.
  Maybe give some details about how we struggled (or in conclusion?)

=== Acoustic Localization and navigation to enhance perception

Objective: optimize ASR
- Robots need to understand what humans say to interact with them.
- ASR systems are sensible to the position of the agent -> let's optimize the agent's position


== Outline and Contributions

Final goal: learn a policy for a robot to navigate

Main challenges:
- Design and implement from scratch
- Only acoustic perception

=== Building a sandbox for room acoustic simulation

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

=== Sound source localization

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
  

=== Deep Reinforcement learning for acoustic navigation

Complete RL pipeline design and implementation:
- Invent/define the task.
  Importantly, we motivate the task by "quantifying" the impact of navigation/positioning on the ASR performance
- Implement the environment thanks to our simulator
- Learn about PPO and implement from scratch
- Train and evaluate the policy + visualization


== Thesis structure


- Explain how chapters are articulated.
- Give the general organization of the manuscript

#figure(
  image("figures/diagram.svg", width: 80%),
  caption: flex-caption(
    short: [
      Overview of the thesis organization
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

== Funding

The SPRING H2020 project @alameda-pineda_socially_2024 aimed at bringing socially capable robots to gerontological healthcare.
It brought together eight European academic and industrial partners to develop the algorithms, models, and software components necessary for the ARI robot to successfully perform complex social tasks (@fig:intro:ari).
This PhD project was funded as a component of the SPRING project.