#import "/utils.typ": *

== Conclusion
<sec:rl:conclusion>

// Recall of the motivation
This chapter introduced a novel perceptually motivated navigation task for robotics, in which an agent equipped with a multi-microphone array must reposition itself to enhance its ability to understand human speech.
The agent relies solely on auditory cues, without access to visual or spatial information, requiring it to build internal representations of space and develop source localization capabilities.
To quantify perceptual quality, we employed the #acr("WER") of an #acr("ASR") system as the reward signal.
Experimental evidence showed that small changes in position and orientation could significantly impact #acr("ASR") performance in reverberant environments, motivating the task.

// Main contributions
We proposed a rigorous #acr("MDP") formulation for this navigation problem, fully integrated with the acoustic simulation tools presented earlier in this thesis.
The #acr("WER")-based cost maps were precomputed and cached to enable tractable training, despite the high computational cost of running #acr("ASR") evaluations.
A deep reinforcement learning agent, trained using the #acr("PPO") algorithm, successfully learned to minimize the WER by navigating toward favorable positions.
The neural agent incorporates a pre-trained source localization backbone, which encodes interaural acoustic features into a compact embedding, enabling the policy to leverage spatial cues.
The learning process was supported by extensive hyperparameter tuning and careful reward shaping.
Empirical results, both qualitative and quantitative, demonstrated that the learned policy consistently outperformed baseline strategies and led to significant reductions in WER.


// ----------------------------
// Limitations
While the proposed agent successfully solves the initial formulation of the task, several limitations remain.
First, the current environment setup implicitly favors policies that navigate directly to the sound source.
If an external source localizer is available, this behavior could be replicated deterministically, reducing the need for reinforcement learning.
However, this chapter provides the groundwork for tackling more complex and realistic scenarios where such shortcuts are no longer feasible.
For instance, introducing occlusions or non-convex environments would challenge the agent to explore and reason over partial observations.
The _Move2Hear_ framework @majumder_move2hear_2021 exemplifies such complexity by coupling audio-visual perception with source separation and navigation.
Within this broader context, the integration of pre-trained perception modules with #acr("DRL") agents remains a promising and effective strategy.

Second, training with PPO was non-trivial.
While #acr("PPO") is often praised for its stability, we found it to be highly sensitive to implementation details and reward scaling.
Careful tuning of hyperparameters, loss coefficients, and training dynamics was essential to obtain a working solution.
Our experience echoes observations from prior work on the fragility of #acr("DRL") algorithms when applied to new domains.

The complete #acr("DRL") pipeline presented here — including the simulator interface, WER map generation, agent architecture, PPO training loop, and evaluation framework — was implemented from scratch.
This engineering effort contributes a reproducible foundation for future work on audio-based navigation tasks.
Several promising extensions lie ahead.
Incorporating multiple sound sources, enabling dynamic environments with moving targets, or introducing higher-level behavioral goals could create more realistic and socially aware robotics scenarios.
In such contexts, deep reinforcement learning agents will need to combine multimodal perception, dynamic planning, and long-horizon reasoning — all of which are facilitated by the foundations established in this chapter.