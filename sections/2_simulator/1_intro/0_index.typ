#import "/utils.typ": *

== Introduction


An intrinsic aspect of robotics, and especially of #acr("HRI") lays in the physical world.
Developing novel methods for interacting with humanoid robots encompasses several challenges related to its embodiment dimension.
Robotics platform suffer from severe limitations that sometimes prevent from applying data-intensive techniques.

// Importance of simulation in science
Simulation offers an alternative tool to experiment with new techniques.
They have been widely used in most scientific fields since the first operation of the Monte Carlo algorithm at the end of the 1940s (@goldsman_brief_2009, @metropolis_beginning_nodate).
#draft[Maybe cite more examples.]
Since then, computers and simulation have progressed massively and offer accurate representations of the real world in fully virtual environments.

// Simulation in DL and DRL
Deep learning techniques have shown impressive results on a variety of tasks ranging from computer vision to natural language processing.
At their core resides the processing of substantial amounts of data.
In many concrete applications of deep learning techniques, collecting datasets of sufficient size and quality stands as a major obstacle.
Simulation provides an alternative way to gather massive amount of data, and often allows for automatic annotation.
However, building an effective simulator can be hard or even impossible.
Also, simulated features frequently deviate from real-world data, which can heavily hinder the final performance.
Reinforcement learning for instance has an agent interacting with an environment and improving its policy from trial and error.
Since deep neural networks have been employed in this field, the interest in simulating the targeted environments has grown significantly.
The success of #acr("DRL") in applications such as board games and video games came early because simulating them is trivial.
Large neural network could then be trained on massive amounts of data.
Nonetheless, the design of realistic simulated environments has allowed the deployment of #acr("DRL") in more complex and _useful_ scenarios.

// 2 examples of simulation in DRL
For instance, industrial and academic actors have used simulated environments as a first step towards achieving fully autonomous driving.
The availability of driving simulators lets more modest research teams contributing to this field without requiring to handle data collection.
Sallab et al. @sallab_deep_2017 and Osiński et al. @osinski_simulation-based_2020 were able to propose simulation-based #acr("DRL") techniques for autonomous driving.
@kiran_deep_2022 and @rosique_systematic_2019 further survey the landscape of available techniques, datasets and simulators in this topic
Additionally, Google DeepMind have proposed a novel approach for magnetic control of tokamak plasmas using #acr("DRL") (@degrave_magnetic_2022).
A critical challenge in this work has been the scarcity of access to a real fusion reactor and thus of the training data.
To get around this, they collaborated with physicists to build a fast and accurate JAX @jax2018github simulator modelling the core of the plasma, TORAX @citrin_torax_2024.


// Simulation in robotics
Coming back to the subject of #acr("HRI") and robotics in general, simulators have also shown to be essential for developing and testing novel algorithms.
Experimenting with uncertain methods remains cheaper and safer within a virtual environment rather than in the physical world.
Involving real hardware brings extra cost and the need for sufficient safety measures.
#draft[
  - In classic robotics, simulator are cheaper and faster (especially for DRL)
  - In HRI, all this is true, but it's even more useful as there are humans involved in the loop (human time is expensive + eventual risks of hurting people)
]
#draft[TODO: challenges of Sim2Real, for learning methods]

// Audio
#draft[TODO: audio]

// Our motivation to develop a simulator
#draft[TODO: Our motivation to develop a simulator]