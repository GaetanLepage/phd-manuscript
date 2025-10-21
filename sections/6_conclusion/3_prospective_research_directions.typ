#import "/utils.typ": *

== Prospective Research Directions


This thesis focused on the use of audio as a primary modality for spatial perception and navigation in robotics.
By investigating learning-based localization and control in simulated environments, we explored how far a robot can go by "hearing" alone.
Although this work covered simulation, learning, and control, several directions remain open for extending and applying this work.
The following prospective directions reflect both short-term extensions and longer-term research trajectories.

*Toward More Realistic and Transferable Simulation*

One natural direction is to improve the realism and transferability of the simulated environments.
While the current simulator supports detailed spatialization and reverberation, it lacks features such as dynamic scenes, continuous-time audio rendering, and realistic sensor noise.
Incorporating human motion models, dynamic speech sources, and variable background conditions would allow the training of models that generalize more effectively.
The addition of domain randomization techniques or hybrid simulation (combining measured and synthetic impulse responses) may also help bridge the sim-to-real gap.
Ultimately, deploying trained models on real robotic platforms in uncontrolled acoustic environments will be a key step toward validating their practical utility.

*Embodied and Multimodal Audio Perception*

Another promising direction lies in integrating embodiment and multimodal sensing.
The current agent is modeled as a floating microphone array, abstracted away from physical structure.
Introducing embodiment could enable richer and more grounded perceptual policies.
This could be done through #acr("HRTF") modeling, simulated actuation noise, or even proprioceptive feedback.
Similarly, combining audio with visual input or depth sensing would allow for sensor fusion models that operate more robustly in ambiguous or noisy conditions.
A particularly interesting challenge is to investigate how attention can be coordinated across modalities.
The agent could be left to decide when to rely on audio, when to move, and when to switch sensing strategies.

*Active Perception Beyond Localization*

While this thesis focused primarily on localization and speech-driven navigation, the broader concept of active perception still offers many opportunities for exploration.
Tasks such as speaker-following, audio-based exploration, or information-seeking behavior could be formulated within the same reinforcement learning framework.
More complex objectives, such as reducing semantic uncertainty or improving conversational turn-taking, may also benefit from movement and auditory focus.
They would bridge the existing gaps to higher-level #acr("HRI"), which remain present in this work.
Studying how agents can autonomously decide what to listen to and where to go to improve their understanding remains a key question for socially intelligent robots.

*Model Efficiency and Generalization*

Finally, future work could focus on improving the sample efficiency and generalization ability of learned policies.
This includes investigating lightweight architectures for #acr("SSL"), training with fewer labeled samples, and exploring transfer learning across environments or source types.
While this thesis showed that pretrained #acr("SSL") models can be reused effectively, more systematic studies are needed to understand how spatial knowledge generalizes across rooms, microphone arrays, and acoustic conditions.
Meta-learning, continual learning, and hierarchical reinforcement learning could all contribute to more adaptable agents.
