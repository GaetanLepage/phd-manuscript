#import "/utils.typ": *

== Introduction
<sec:simulator:intro>

#acr("HRI") investigates the challenges of bringing capable humanoid robots into real-world environments.
These robots are embodied agents that must operate in complex, often unpredictable settings involving humans.
This context introduces multiple challenges: social robotics experiments are subject to material costs, safety constraints, and logistical complexity.
As a result, applying data-intensive, trial-and-error learning approaches to physical robots is difficult to scale.
Simulation provides an effective alternative to physical interaction for bootstrapping and designing intelligent robot behaviors.
However, it also introduces its own limitations, which must be carefully considered when transferring algorithms to the real world.
The following explores the role of simulation in robotics and why it is pivotal in addressing many of the field’s practical and scientific challenges.

// Importance of simulation in science
Simulation offers an alternative tool to experiment with new techniques.
Since its first operation in the late 1940s, the Monte Carlo algorithm has been widely used in most scientific fields @goldsman_brief_2009, @metropolis_beginning_1987.
In 1950, a team led by John von Neumann and Jule Charney used the ENIAC computer to produce the first weather forecast by an electronic computer @charney_numerical_1950.
Although their results carried important numerical errors, this work led to the foundation of modern meteorology.
This is an example of numerically replicating a physical phenomenon by implementing and solving the corresponding equations.
NASA has also used simulations early in its space programs, such as Apollo.
The primary goal of their enterprise was to build a training setup for astronauts to practice specific skills.
Indeed, in high-stakes enterprises, the crew's accommodation to their environment and tools is essential for the mission's success.
Between 1963 and 1972, the Apollo flight crew trained for 30,000 hours on different simulation devices.
Using simulators as sandbox environments to perform training is a significant use case of such systems.
It can be applied to human training, algorithm testing, and data collection.
Once built, simulation systems can be dramatically valuable as cheap replications of physical settings that are either expensive or difficult to access.
Multiple techniques or discoveries would have been impossible without the scaling offered by simulation.
For instance, the drug discovery field has benefited considerably from molecular computer simulation @durrant_molecular_2011 @lave_challenges_2007.
Building on this general overview of simulation, we now turn to its specific applications in deep learning and robotics.

// Simulation in DL and DRL
*Simulation for Deep (Reinforcement) Learning.*
Deep learning techniques have shown impressive results on various tasks ranging from computer vision to natural language processing.
At their core resides the processing of substantial amounts of data.
Collecting datasets of sufficient size and quality is a significant obstacle in many concrete applications of deep learning techniques.
Simulation provides an alternative way to gather massive amounts of data and often allows for automatic annotation.
However, building an effective simulator can be hard or even impossible.
Also, simulated features frequently deviate from real-world data, which can heavily hinder the  performance of a system trained with simulated data.
Reinforcement learning, for instance, considers an agent interacting with an environment and improving its action policy from trial and error.
Since deep neural networks have been employed in this field, the interest in simulating the targeted environments has grown significantly.
The success of #acr("DRL") in applications such as board games and video games came early because simulating them is trivial.
Large artificial neural networks could then be trained on massive amounts of data.
Nonetheless, the design of realistic simulated environments has allowed the deployment of #acr("DRL") in more complex and practical scenarios.

// Some examples of simulation in DRL
For instance, industrial and academic actors have used simulated environments as a first step toward achieving fully autonomous driving.
The availability of driving simulators allows more modest research teams to contribute to this field without requiring them to handle data collection.
Sallab et al. @sallab_deep_2017 and Osiński et al. @osinski_simulation-based_2020 proposed simulation-based #acr("DRL") techniques for autonomous driving.
@kiran_deep_2022 and @rosique_systematic_2019 further survey the landscape of available techniques, datasets, and simulators on this topic.
Additionally, a team from Google DeepMind has proposed a novel approach for controlling the magnetic field of tokamak plasmas using #acr("DRL") @degrave_magnetic_2022.
A critical challenge in this work has been the scarcity of access to a real-world fusion reactor and, thus, to the training data.
To get around this, they collaborated with physicists to build a fast and accurate JAX @jax2018github simulator modeling the plasma core, TORAX @citrin_torax_2024.
Finally, games have been among the most widespread application domains for #acr("DRL") as they are inherently virtual @vinyals_grandmaster_2019 @mnih_playing_2013 @berner_dota_2019 @silver_mastering_2016.
No effort is necessary to provide a simulated version of those environments.

// Simulation in robotics
*Robotics.*
Returning to #acr("HRI") and robotics in general, simulators have also been shown to be essential for developing and testing novel algorithms.
Experimenting with uncertain methods remains cheaper and safer in a virtual environment than in the physical world.
Involving real hardware brings extra cost and the need for sufficient safety measures.
Simulation for robotics is fundamentally a multidisciplinary field.
Liu et al. @liu_role_2021 discuss the role of physics-based simulators in robotics.
The authors highlight the necessity of relying on software simulation to compensate for real-world robotic systems' challenges.
Naturally, most existing toolboxes commonly feature the simulation of the various physics phenomena involved in a robotic platform.
Depending on the richness of the targeted environment, modeling the necessary behaviors may be difficult.
The diversity of existing solutions is highlighted by Collins et al. @collins_review_2021.
They list and compare the available offerings for a selection of robotics applications (medical, marine, aerial, and soft robotics).
In addition to the underlying physics, a simulator should also model the behavior of different sensors.
Indeed, in the natural world, robots use sensors to build a faithful representation of their surroundings.
The accuracy of simulators in this regard conditions the algorithm's performance in practical use cases.
Furthermore, performance is a crucial metric when developing a robotics simulator.
Solving complex equations that model multi-physics phenomena is often computationally expensive.
Keeping runtime low enough requires simulator designers to make tradeoffs in their implementation choices.
In their study on opportunities and challenges of robotics simulation @choi_use_2021, Choi et al. notably highlight the difficulty of gauging the right level of model complexity.
They also suggest that the speed limitations of current solutions are an obstacle to the broader adoption of simulation in this field.


*Simulation for dataset collection.*
Most #acr("DRL") research projects directly learn from a robotics simulator by running their policy within it to train.
Simulators have also been leveraged to gather substantial synthetic datasets for offline training.
The branch of #acr("RL") that operates on fixed interaction data collected a priori is known as offline reinforcement learning.
Despite its formulation deviating from the traditional, interaction-based framework of #acr("RL"), offline #acr("RL") offers sensible advantages.
Gathering data remains a costly operation in any #acr("RL") training process, so delegating this task allows one to focus exclusively on algorithm development.
It separates the expensive effort of gathering data and lets diverse research actors attempt to solve the underlying decision problem.
For instance, Walke et al. @walke_bridgedata_2024 introduced the _BridgeData V2_ dataset.
It contains 60,096 trajectories collected across 24 robot manipulation environments.
In this case, they used a real robot, not a simulator, bringing additional fidelity.
However, they acknowledge that such endeavors are both expensive and time-consuming.
D4RL @fu_d4rl_2021 and its successor D54L @rafailov_d5rl_2024 were released to become the de facto standards of offline #acr("RL") robotics benchmarks.
They comprise a variety of environments relying on existing simulation platforms such as Mujoco @todorov_mujoco_2012 or CARLA @dosovitskiy_carla_nodate.
The high costs of gathering and labeling datasets also limit supervised learning applications.
Synthetic datasets can be generated by simulators that also offer automatic sample labeling.
The Kubric @greff_kubric_2022 dataset generator leverages the _PyBullet_ @noauthor_bulletphysicsbullet3_2024 simulator and allows for synthesizing massive amounts of photorealistic data.


*Human-robot interactions.*
Human-robot interactions are another dynamic field of study @robinson_robotic_2023.
This broad field encompasses all the tasks that require robots to operate near or directly with humans.
Such scenarios bring additional difficulties, such as safety implications or social acceptance.
Zachari et al. @zacharaki_safety_2020 conducted an extensive survey on the multiple facets of safety in #acr("HRI").
They enumerate the numerous remaining open problems in this field.
For instance, adding machine learning techniques in social robotics introduces new possibilities and safety difficulties.
Simulation is, therefore, compelling to researchers working in #acr("HRI").
Abeyruwan et al. @abeyruwan_i-sim2real_2023 propose a framework to train #acr("RL") policies for human-interaction tasks.
Specifically, they train a robot arm to play table tennis against a human adversary.
The learning process iteratively switches from a simulated environment to a physical system involving a human player.
Kaur et al. @kaur_simulators_2022 insist on the importance of modeling human behaviors in #acr("HRI") simulators.
They reviewed the existing simulators for mobile robot navigation in pedestrian-rich environments.
They identified the key missing features of available solutions.
For instance, the richness of human behavior models is not satisfying as they often lack realism and diversity.
Sprague et al. @sprague_socialgym_2023 proposed _SocialGym 2.0_, a multi-agent navigation simulator that models robot-robot and human-robot interactions.
Safety is another crucial challenge when humans are added to the loop.


*Sim2Real challenges.*
Despite offering substantial advantages for learning robust policies using #acr("DRL"), simulators should be handled carefully.
Indeed, the end objective of robotics is to design systems that can interact with the real world.
The performance of policies learned in simulated environments is not guaranteed to transfer to real scenarios.
Hence, an entire segment of the robotics #acr("DRL") community targets the problem of sim-to-real @zhao_sim--real_2021 @peng_sim--real_2018 @tan_sim--real_2018.
This area encompasses the challenge of leveraging simulation while ensuring appropriate behavior and performance of the target physical system.
These discrepancies are primarily due to differences between the simulator and the real-world environment.
They can be modeling limitations, numerical imprecision, unrealistic assumptions, etc.
In conclusion, simulation's many benefits come at some cost, which must be carefully accounted for when deploying #acr("RL") policies in the real world.


*Acoustic simulation.*
Thanks to the widespread availability of camera sensors and significant advancements in image processing techniques, vision has emerged as one of the most predominant modalities in robotics.
Nevertheless, other cues have also been employed, either in conjunction with or in place of vision (#acr("LIDAR") @malavazi_lidar-only_2018 @hutabarat_lidar-based_2019, haptic feedback @seminara_active_2019, audio @chen_soundspaces_2020 @majumder_move2hear_2021 @bustamante_multi-step-ahead_2017, etc.).
In this thesis, the focus will be on acoustic applications in robotics.
Simulators targeting audio simulation are scarcer, especially the ones dedicated to robotics.
In their review, Kaur et al. @kaur_simulators_2022 highlight the absence of ambient sound modeling for testing sound-based navigation algorithms.
The video game industry, among others, has motivated the development of acoustic rendering engines.
Zhao et al. @zhao_sim--real_2021 enhanced a vision-based #acr("RL") pipeline for robotic grasping by implementing audio perception.
To conduct their experiments, they use the _ThreeDWorld_ @gan_threedworld_2021 multi-modal simulator, which can synthesize impact sounds.
The proposed grasping pipeline performs better using both vision and audio cues than with vision only.
Grauman et al. conducted a line of work on auditory-based robot navigation tasks @chen_soundspaces_2020 @majumder_move2hear_2021.
They used a simulated environment modeling both visual and auditory cues to train their deep neural networks.
Srivastava's doctoral thesis @srivastava_how_2023 investigates the functioning of acoustic simulation in great detail.
It provides a precise overview of the functioning of #acr("RIR") estimation techniques and related concepts.
Srivastava's main contribution is training a deep neural network to estimate the room acoustic parameters.
The acoustic pipeline has been developed explicitly for this project and is built around the _Bidirectional Sound Transport_ algorithm by Cao et al. @cao_interactive_2016.
This chapter will detail the literature on acoustic reverberation simulators and provide an overview of existing software solutions.


In conclusion, simulation is a key component in many scientific domains, especially in robotics and deep reinforcement learning.
It allows for scaling experiments and iterating rapidly on research ideas without relying on costly and time-consuming physical infrastructure.
However, simulation has trade-offs that should be carefully considered when developing software platforms.
For instance, #acr("RL") policies learned in simulated environments do not always translate to performing convincingly in real-world scenarios.
Also, no satisfying simulation solution exists for sound-based robot navigation.
For those reasons, we contributed an original implementation of a flexible and feature-rich acoustic simulator for robotics.
Its goal is to provide a practical and convenient sandbox for machine learning and robotics scientists to experiment with various sound-related problems.
The obtained software ecosystem has been the core framework for the experimental work conducted in the present thesis.
This chapter will introduce the fundamental notions of sound propagation and audio processing to understand the phenomenon of acoustic reverberation.
Also, various state-of-the-art methods for acoustic simulation will be presented along with existing implementations.
Finally, we will detail the core design of our simulator and highlight its several features.