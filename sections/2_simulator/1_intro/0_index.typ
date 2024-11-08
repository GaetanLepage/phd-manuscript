#import "/utils.typ": *

== Introduction
<sec:simulator:intro>

The physical world is an intrinsic aspect of robotics, especially #acr("HRI").
Developing novel methods for interacting with humanoid robots encompasses several challenges related to their embodiment dimension.
Robotic platforms suffer from severe limitations that sometimes impede applying data-intensive techniques.

// Importance of simulation in science
Simulation offers an alternative tool to experiment with new techniques.
They have been widely used in most scientific fields since the first operation of the Monte Carlo algorithm at the end of the 1940s (@goldsman_brief_2009, @metropolis_beginning_nodate).
In 1950, a team led by Jon von Neumann and Jule Charney used the ENIAC computer to produce the first weather forecast by an electronic computer @charney_numerical_1950.
Although their results carried important numerical errors, this work led to the foundation of modern meteorology.
It is an example of numerically replicating a physical phenomenon by implementing and solving the corresponding equations.
NASA has also used simulation early in its space programs, such as Apollo.
The primary goal of their enterprise was to build a training setup for astronauts to practice specific skills.
Indeed, in high-stakes enterprises, the crew's accommodation to their environment and tools is essential for the mission's success.
Between 1963 and 1972, the Apollo flight crew trained for 30,000 hours on different simulation devices.
Using simulators as sandbox environments to perform training is a significant use case of such systems.
It can be applied to human training, algorithm testing, and data collection.
Once built, simulation systems can be dramatically valuable as cheap replications of physical settings that are either expensive or difficult to access.
Multiple techniques or discoveries would have been impossible without the scaling offered by simulation.
For instance, the field of drug discovery has considerably benefitted from molecular computer simulation @durrant_molecular_2011 @lave_challenges_2007.
Building on this general overview of simulation, we now turn to its specific applications in deep learning and robotics.

// Simulation in DL and DRL
*Simulation for Deep (Reinforcement) Learning.*
Deep learning techniques have shown impressive results on various tasks ranging from computer vision to natural language processing.
At their core resides the processing of substantial amounts of data.
Collecting datasets of sufficient size and quality is a significant obstacle in many concrete applications of deep learning techniques.
Simulation provides an alternative way to gather massive amounts of data and often allows for automatic annotation.
However, building an effective simulator can be hard or even impossible.
Also, simulated features frequently deviate from real-world data, which can heavily hinder the final performance.
Reinforcement learning, for instance, has an agent interacting with an environment and improving its policy from trial and error.
Since deep neural networks have been employed in this field, the interest in simulating the targeted environments has grown significantly.
The success of #acr("DRL") in applications such as board games and video games came early because simulating them is trivial.
Large artificial neural networks could then be trained on massive amounts of data.
Nonetheless, the design of realistic simulated environments has allowed the deployment of #acr("DRL") in more complex and practical scenarios.

// 2 examples of simulation in DRL
For instance, industrial and academic actors have used simulated environments as a first step toward achieving fully autonomous driving.
The availability of driving simulators allows more modest research teams to contribute to this field without requiring them to handle data collection.
Sallab et al. @sallab_deep_2017 and Osiński et al. @osinski_simulation-based_2020 proposed simulation-based #acr("DRL") techniques for autonomous driving.
@kiran_deep_2022 and @rosique_systematic_2019 further survey the landscape of available techniques, datasets, and simulators in this topic
Additionally, a team from Google DeepMind has proposed a novel approach for controlling the magnetic field of tokamak plasmas using #acr("DRL") (@degrave_magnetic_2022).
A critical challenge in this work has been the scarcity of access to a real-world fusion reactor and, thus, to the training data.
To get around this, they collaborated with physicists to build a fast and accurate JAX @jax2018github simulator modeling the plasma core, TORAX @citrin_torax_2024.
#todo

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
Solving complex equations modeling multi-physics phenomena is often computationally expensive.
Keeping runtime low enough requires simulator designers to make tradeoffs in their implementation choices.
In their study on opportunities and challenges of robotics simulation @choi_use_2021, Choi et al. notably highlight the difficulty of gauging the right level of model complexity.
They also suggest that the speed limitations of current solutions are an obstacle to the broader adoption of simulation in this field.

*Simulation for dataset collection.*
Most #acr("DRL") research projects directly learn from a robotics simulator by running their policy within it to train.
Simulators have also been leveraged to gather substantial synthetic datasets for offline training.
The branch of #acr("RL") that operates on fixed interaction data collected apriori is offline reinforcement learning @levine_offline_2020.
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

*Human Robot interactions.*
Human-robot interactions are another dynamic field of study @robinson_robotic_2023.
This wide-field encompasses all the tasks that require robots to operate nearby or directly with humans.
Such scenarios bring additional difficulties, such as safety implications or social acceptance.
In their survey, Zacharaki et al. summarize the existing works on safety in #acr("HRI") but also insist on the several open problems remaining.
Adding machine learning techniques in social robotics introduces new possibilities and safety difficulties.
Simulation is therefore compelling to researchers working in #acr("HRI").
Abeyruwan et al. @abeyruwan_i-sim2real_2023 propose a framework to train #acr("RL") policies for human-interaction tasks.
Specifically, they train a robot arm to play table-tennis against a human adversary.
The learning process iteratively switches from a simulated environment to a real physical system involving a human player.

@kaur_simulators_2022 @sprague_socialgym_2023

// TODO: add social robotics example


*Sim2Real challenges.*
Despite offering substantial advantages for learning robust policies using #acr("DRL"), simulators should be handled carefully.
Indeed, the end objective of robotics is to design systems that can interact with the real world.
The performance of policies learned in simulated environments is not guaranteed to transfer to real scenarios.
Hence, an entire segment of the robotics #acr("DRL") community targets the problem of Sim-to-Real @zhao_sim--real_2021 @peng_sim--real_2018 @tan_sim--real_2018.
This area encompasses the challenge of leveraging simulation while ensuring appropriate behavior and performance of the target physical system.
These discrepancies are primarily due to differences between the simulator and the real-world environment.
They can be modeling limitations, numerical imprecisions, unrealistic assumptions, etc.

*Acoustic simulation.*
Vision is the dominant modality used for robotic perception in practical applications.
Robots have also used different cues (LIDAR #todo, haptic feedback #todo, audio #todo, etc.).
In this thesis, the focus will be on acoustic applications in robotics.
Simulators targeting audio simulation are scarcer, especially the ones dedicated to robotics.
The video game industry, among others, has motivated the development of acoustic rendering engines.
#todo

In conclusion, simulation is a key component in many scientific domains, but especially in robotics and deep reinforcement learning.
It allows for scaling experiments and iterating rapidly on research ideas without the need to rely on costly and time-consuming physical infrastructure.
However, simulation has trade-offs that should be carefully considered when developing software platforms.
// TODO repetition
For instance, #acr("RL") policies learned in simulated environments do not always translate to performing convincingly in real-world scenarios.


#todo
#draft[
  - In classic robotics, simulators are cheaper and faster (especially for DRL)
  - In HRI, all this is true, but it's even more useful as there are humans involved in the loop (human time is expensive + eventual risks of hurting people)
]
#draft[TODO: challenges of Sim2Real, for learning methods]

// Audio
#draft[TODO: audio]

// Our motivation to develop a simulator
#draft[TODO: Our motivation to develop a simulator]