#import "/utils.typ": *

=== Reinforcement Learning for Robotics
<sec:rl:intro:rl_for_robotics>

By its very nature, robotics has long been a central application area for #acr("RL").
Robotics tasks typically involve sequential decision-making under uncertainty, making them a natural fit for #acr("RL") methods.
Additionally, because robots are embodied agents that physically interact with the world, learning through trial and error has emerged as a compelling and biologically inspired strategy.
Historically, robotics has been approached primarily through the lens of control theory, employing classical methods such as #acr("PID") controllers, #acr("LQR"), and #acr("MPC") @kelly_control_2005 @galal_modern_2017 @camacho_model_2007 @rawlings_model_2009.
These approaches, while successful in many domains, require hand-engineered models of system dynamics and generally cannot scale to high-dimensional, multimodal inputs or adapt flexibly to unmodeled environments.

Prior to the rise of deep learning, classic #acr("RL") algorithms had been applied to robotics, often with limited success due to issues like poor sample efficiency and sensitivity to hyperparameters.
Kober et al. @kober_reinforcement_2013 provide an overview of such early efforts, noting several cases in which #acr("RL") enabled robots to acquire useful behaviors while highlighting the substantial manual engineering required.
The advent of #acr("DRL"), which integrates deep neural networks as function approximators with #acr("RL") algorithms, has significantly expanded the potential of learning-based control in robotics.
#acr("DRL") makes it possible to learn policies directly from raw, high-dimensional sensor inputs, such as images, and has demonstrated remarkable success in domains like manipulation, locomotion, and navigation.

Since the first notorious #acr("DRL") successes, interest in applying these methods to robotics has grown substantially.
However, integrating #acr("DRL") into real-world robotic systems remains challenging.
As Ibarz et al. emphasize @ibarz_how_2021, real-world deployment introduces issues that are absent from simulated environments.
They include sensor noise, hardware wear, safety constraints, and asynchronous execution, all of which can degrade learning stability and policy performance.
The authors document practical lessons learned from deploying #acr("DRL") on real robots, highlighting strategies such as combining offline and online learning, incorporating demonstrations, and designing robust reward functions.

Numerous studies have explored the application of #acr("DRL") to robotic navigation and social interaction.
Pikuli et al. @pikuli_navigating_2024, for instance, investigate the use of #acr("RL") for social robot navigation, where the dynamics of human-robot interaction are too complex to model explicitly.
Their study emphasizes the importance of design choices such as observation space, action representation, and reward shaping, and provides practical guidance for ensuring policy convergence.
Similarly, Lathuilière et al. @lathuiliere_neural_2019 demonstrate how reinforcement learning can be used for gaze control in human-robot interaction, learning audio-visual attention policies through a combination of simulation and real-world fine-tuning.

At the same time, researchers have reflected on the broader capabilities and limitations of deep learning in robotics.
Sünderhauf et al. @sunderhauf_limits_2018 argue that while #acr("DL") has enabled impressive progress in perception and control, robotics poses unique challenges, such as embodiment, uncertainty estimation, and sim-to-real transfer, that are not fully addressed by traditional #acr("DL") paradigms.
They advocate for a tighter integration between data-driven learning and model-based reasoning.

To help assess #acr("DRL") algorithms in real robotic platforms, Mahmood et al.
@mahmood_benchmarking_2018 benchmark several popular #acr("DRL") methods (e.g., #acr("TRPO"), #acr("PPO"), #acr("SAC"), #acr("DDPG")) on a set of standardized real-world tasks.
Their results show that while some algorithms perform well out-of-the-box, all are highly sensitive to hyperparameter choices, and performance often varies unpredictably across tasks.
This reinforces the importance of careful environment design and thorough empirical evaluation when applying #acr("DRL") in robotics.

Overall, deep reinforcement learning offers powerful tools for enabling robot autonomous behavior.
However, deploying these methods effectively requires addressing both fundamental algorithmic challenges and the complex realities of real-world robotic systems.