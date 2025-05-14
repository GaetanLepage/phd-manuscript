#import "/utils.typ": *

== Conclusion
<sec:rl:conclusion>

// Recall of the motivation
This chapter motivates and introduces a novel navigation task for robotics.
The agent, equipped with a multi-microphone array, is tasked to position itself to improve its ability to understand human speech.
It can only rely on auditory cues, as no other sensory information is available.
This constraint requires the agent to build implicit spatial representations and rely on source localization capabilities.
The #acr("WER") quantifies the performance of an #acr("ASR") system and serves as a proxy for the perceptual quality of the sensed audio signals.
We demonstrate how critical good positioning can be to transcribe speech content recorded in reverberant environments effectively.

// Main contributions
We introduce a rigorous #acr("MDP") formulation for this perceptually motivated navigation task.
The proposed environment allows training and evaluating #acr("DRL") agents with modern algorithms.
It directly integrates with the acoustic simulator in @chap:simulator.
#acr("WER") scores are computed for each possible agent position beforehand and cached to ensure satisfying environment performance.
Besides defining, designing, and implementing the environment for the proposed task, we develop a deep neural agent that successfully solves the initial formulation of the navigation problem.
It leverages a convolutional feature extractor that maps the interaural audio representation to an embedding of the source localization.
To achieve this, the agent backbone is pre-trained on an #acr("SSL") task in a supervised fashion.
The #acr("PPO") algorithm efficiently learns the navigation policy by having the agent interact with the environment.
Qualitative and quantitative experimental results show that the learned policy successfully navigates close to the source, thus significantly improving the #acr("WER").

// Limitations
Despite effectively solving the navigation task, the proposed approach, as well as the problem framing have some limitations.
On the one hand, the specific formulation of the environment leads the agent to learn to systematically navigate to the source.
By having access to a capable sound source localizer, one could craft a deterministic policy that positions the agent as close as possible to the source.
This observation naturally questions the need for training a #acr("DRL") agent.
The present contribution builds the necessary framework for eventually enriching the naive task introduced here as an example.
We are confident in the fact that considerably more complex variations of the problem could be imagined, where the optimal policy cannot be implemented deterministically.
For instance, using a simulator capable of modeling non-convex rooms, the agent could have to navigate in a more challenging environment, thus requiring extensive exploration.
For instance, the _Move2Hear_ task, introduced by Kirsten et al. @majumder_move2hear_2021, demonstrate an interesting audio-visual robotics navigation problem that could be solved using #acr("DRL").
Yet, we have shown that combining a source localizer with a deep reinforcement learning agent remains a valid strategy for solving this kind of audio-based navigation problem.
On the other hand, the #acr("PPO") algorithm employed in this work has proven difficult to use.
Several experimental difficulties arose in the development of the final solution.
A tedious, iterative research endeavor was necessary to effectively combine the multiple elements of the pipeline.
Most specifically, a careful and subtle tuning of the hyperparameters, loss coefficients, environment properties, and reward was crucial in obtaining a workable solution.

// Emphasis on the engineering effort (to finish on a positive note)
The entire #acr("RL") pipeline presented in this chapter has been implemented from scratch.
It entails the #acr("RL") environment for the sound-driven navigation task, along with the computation of #acr("WER") maps, the #acr("PPO") algorithm, the neural network model, and the training and evaluation logic.
This significant engineering effort aims to provide the research community with a quality software ecosystem for experimenting with more complex and interesting formulations of the sound-driven navigation task.
For instance, extending the current environment to a multi-source paradigm could bring additional considerations.
Improving the simulator is also an interesting perspective for future work.
Indeed, implementing the proper support for moving sources could lead to dynamic environments in which the agent would need to constantly adapt its positioning.
Finally, injecting other goals in addition to the #acr("WER")-based objective could be relevant in the context of social robotics.
Complex interaction tasks, involving multi-modal perception, require robots to handle multi-factor decision making.