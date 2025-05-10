#import "/utils.typ": *

=== #acr("RL") for Robotics
<sec:rl:intro:rl_for_robotics>

By its very nature, robotics has always been one of the main applications of #acr("RL").
Indeed, robotics often involves sequential decision-making under uncertainty, which is a natural fit for #acr("RL").
Also, robots are fundamentally embodied as they interact with the physical world.
As such, trial-and-error learning strategies have been a logical, biologically inspired approach to robotics.

// Earlier works
Historically, robotics has been studied from the perspective of control theory.
This area of research involves designing a controller for a given system.
#acr("PID") @kelly_control_2005 @galal_modern_2017, #acr("LQR"), and #acr("MPC") @camacho_model_2007 @rawlings_model_2009 are examples of classical techniques from control theory that have been extensively used in robotics.
Despite their numerous successes, they involve formally modeling the robotic system beforehand.
This is a limitation when dealing with complex multi-modal platforms where a closed-form mathematical model cannot be derived.
Furthermore, such methods cannot directly process raw, high-dimensional sensory input.

// First applications of RL
Prior to the #acr("DRL") wave, researchers have tried applying classic #acr("RL") techniques to robotics problem.
In their 2013 survey, Kober et al. @kober_reinforcement_2013 discuss using #acr("RL") methods in learning robot behaviours.
They highlight several successful cases where #acr("RL") techniques enabled robots to accomplish specific tasks.
However, the authors also underscore significant challenges, noting that applying #acr("RL") to robotics often requires substantial adaptation and that achieving positive outcomes is far from straightforward.
#todo
Since the first high-profile successes in #acr("DRL") emerged, interest in RL has grown substantially across the research community, including in robotics.



Before #acr("RL") to 

Robotics has been one of the domains targeted by A.I. researchers to apply Deep Reinforcement Learning

// "Navigating the Practical Pitfalls of Reinforcement Learning for Social Robot Navigation"
@pikuli_navigating_2024


- Ibarz et al. @ibarz_how_2021
- Sünderhauf et al. @sunderhauf_limits_2018: The Limits and Potentials of Deep Learning for Robotics
- Lathuillière RL for AV gaze-control @lathuiliere_neural_2019

#draft[
  Benchmarks on real-world robotics tasks
  @mahmood_benchmarking_2018

  How to Train Your Robot with Deep Reinforcement Learning – Lessons We’ve Learned
  @ibarz_how_2021
]