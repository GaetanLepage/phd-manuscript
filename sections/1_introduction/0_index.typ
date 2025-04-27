#import "/utils.typ": *

= Introduction
<chap:intro>

== Motivations

=== Social robotics & embodied AI

General introduction about AI and robotics:

- Increasing presence of AI systems in our lives
- LLM: emerging use cases of intelligent systems. Mostly text-based interaction.
  First demonstrations of speech-based interaction
- Robotics:
  - very challenging field, multiple unsolved research and technical problems
  - Quite old. A lot of research has been done to bring robots to life
  - Early success happened in very specific tasks with limited interaction (industrial robots for e.g.)
  - Human-robot interaction is still hard. Perception, multi-modal
  - This PhD was funded by the SPRING project @alameda-pineda_socially_2024


=== Multi-modal perception, a focus on acoustics

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


== Contributions

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

== Personal experience

Not sure if we want to have this in the intro
???

== Thesis structure


- Explain how chapters are articulated.
- Give the general organization of the manuscript

#figure(
  image("figures/diagram.svg", width: 80%),
  caption: [
    Overview of the thesis organization
  ]
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