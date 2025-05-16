#import "/utils.typ": *

== Challenges and Limitations


While the contributions presented in this thesis provide a coherent and reproducible framework for studying audio-based perception and control, several limitations and challenges constrain the scope and generalizability of the results.
These limitations arise from deliberate design choices, computational constraints, and broader research trade-offs that reflect the current state of deep learning for embodied #acr("AI").

*Simulation-Only Evaluation*

All experiments in this work were conducted within a custom acoustic simulation environment.
Although this simulator was carefully engineered to model reverberation, spatialization, and microphone configurations with high realism, it inevitably abstracts away many factors present in real-world settings.
Real acoustic environments involve a broader range of phenomena—such as non-uniform materials, background noise, microphone imperfections, and non-stationary reverberation—that are difficult to model or anticipate.

This reliance on simulation limits the empirical validation of the proposed models and policies.
In particular, the active localization and reinforcement learning experiments assume perfect control over the agent's movement and audio capture, and do not account for hardware-specific delays, sensor calibration errors, or ambient variability.
While the simulation-based approach was essential for controlled experimentation and large-scale training, future work will need to address the sim-to-real transfer gap to confirm the applicability of these methods in physical robotic systems.

*Task and Agent Constraints*

Several simplifications were made in the formulation of the localization and navigation tasks.
First, the #acr("SSL") models assume that all sound sources are static during inference, with no modeling of speaker motion or interruption.
This assumption facilitates tractable evaluation but limits applicability to dynamic environments.
In the active localization pipeline, the agent moves in a discrete 2D grid with uniform steps and perfect self-location, without incorporating odometry drift, inertial feedback, or motion constraints typical of real robots.

The agent is modeled as a simple microphone array, without explicit embodiment or interaction with the environment beyond locomotion.
Notably, Head-related transfer functions (HRTFs), body occlusion effects, and mechanical actuation noise are not accounted for in this work while being highly relevant to embodied auditory sensing.
While this abstraction enabled a focused study on acoustic perception, it also means that the system does not yet reflect the full complexity of real-world sensing platforms.

The navigation task, in particular, is limited to a single, known room layout with a fixed number of possible source locations.
Although this constraint was imposed to manage the computational cost of generating and storing #acr("WER") maps, it narrows the diversity of encountered scenarios and may reduce the robustness of the learned policies.

*Engineering and Algorithmic Challenges*

From an engineering perspective, training deep reinforcement learning agents remained non-trivial.
The #acr("PPO") algorithm, while widely adopted, is known to be sensitive to hyperparameters and implementation details.
Extensive empirical tuning was required to obtain stable training and meaningful policies.
This sensitivity introduces reproducibility challenges and increases the barrier to broader adoption.

The design of the reward function, based on #acr("ASR") performance using precomputed WER maps, provided a task-relevant optimization signal but also imposed practical limitations.
Generating accurate WER maps for multiple source positions is computationally expensive and scales poorly with the number of concurrent speakers or room configurations.
As a result, the learning environment was deliberately simplified, and the agent was trained with a frozen feature extractor rather than in an end-to-end fashion.