#import "/utils.typ": *

== Motivations

=== Social Robotics & Embodied AI

Recent years have seen rapid and remarkable progress in #acr("AI").
#acr("AI") systems have advanced dramatically in a relatively short period.
Subsequently, these techniques have been used in numerous domains, ranging from highly specialized applications to widely spread end-consumer products.
These technologies have had a profound impact on daily life, society, and the global economy.
#acrpl("LLM") are surely the latest and most striking illustration of this revolution.
Since the invention of the attention mechanism and the transformer architecture in 2017 @vaswani_attention_2017, larger and larger models could be trained on constantly growing datasets.
The capabilities of #acrpl("LLM")s have pushed the boundaries of artificial reasoning and natural language processing.
Similarly, diffusion models have been equally successful for image generation.
While interactions with these systems remain largely text-based, academic and industrial actors invest substantial resources in making them more natural.
More precisely, #acr("AI") agents aim to interact with humans directly through speech and vision.
For instance, KyutAI’s Moshi @defossez_moshi_2024 can engage in real-time two-way spoken interactions with humans.
Speech-based interaction is a central research challenge in #acr("HRI").
More generally, the design of embodied agents is at the core of social robotics.
Social robots operate in complex, dynamic, and often crowded environments.
They differ from traditional robots, such as the ones used in industrial settings to perform repetitive, narrow-scope actions.
These robots do not need to adapt and interact in an unpredictable environment.
Their policy is often deterministic and programmed in advance.
Also, they are not expected to interact naturally with humans.
Bridging the gap toward capable social robots remains a significant challenge.
As Hans Moravec observed in the 1980s @moravec_mind_1988, tasks that are easy for humans—such as perception and motor coordination—are surprisingly difficult for robots.
This paradox highlights a central challenge of social robotics: while computers can outperform humans in abstract reasoning tasks, they still struggle with sensorimotor skills that even infants master early in life.
His observation, from 1988, remains highly relevant today as multimodal perception and action remain key challenges in #acr("AI") and robotics.


=== Multimodal Perception, a Focus on Acoustics

Multimodal perception refers to a robot's ability to sense and understand its environment using multiple types of sensory input.
Robots can be equipped with various sensors depending on their objectives, nature, and budget constraints.
For example, LIDAR sensors allow for estimating the distance to surrounding objects and are widely used in autonomous vehicles.
Cameras and microphones are cost-effective and let robots sense their environment like humans.
The key challenge is to extract actionable, task-relevant information from raw sensor data.
The goal is to derive actionable knowledge from raw sensory input.
For instance, object detection involves localizing and classifying semantic objects in the captured frames.
Multi-object tracking adds a temporal aspect to the task by tracking each identified object across time.
Depth estimation attempts to infer how far each pixel is in an image.
Regarding auditory perception, #acr("ASR") aims to enable machines to "understand" human speech by transcribing audio input into a readable format.
This task is essential in social robotics as speech is often the primary communication channel between humans and robots.
#acr("SSL") involves estimating the direction or position of the active audio sources in an environment.
#acr("SSL") helps robots be more spatially aware by complementing visual features.
Also, it allows them to know which person is currently speaking and where they are located.
Therefore, social robots can behave accordingly to the conversation dynamics.
#acr("SSL") can also provide essential spatial context for navigation tasks.


#figure(
  image(
    "./figures/ari.png",
    width: 6cm
  ),
  caption: [
    A photo of the ARI robot, a humanoid robotic platform developed by PAL Robotics.
  ],
)
<fig:intro:ari>


=== Learning Robot Policies with Reinforcement Learning

Reinforcement learning is a flexible framework for solving discrete-time decision problems.
#acr("RL") has a long history of research and has allowed numerous successes in various application domains.
Since the rise of deep learning methods, #acr("RL") has benefited from more effective and capable models and function approximators.
#acr("DRL") methods make it possible to train deep neural networks with high representational capacity.
This shift from traditional #acr("RL") methods to modern neural-based algorithms has significantly broadened the range of solvable problems.
Traditional #acr("RL") was limited to low-dimensional observation spaces.
The use of #acrpl("DNN") as function approximators expanded #acr("RL")'s applicability to high-dimensional, unstructured inputs.
#acr("DRL") methods have led to breakthroughs in gaming environments like Atari 2600 @mnih_playing_2013 and Go @silver_mastering_2016, and more recently in complex embodied tasks such as legged locomotion @lee_learning_2020 and multi-agent cooperation @berner_dota_2019.
Such fundamental progress clearly impacted robotics, which is well suited to #acr("RL")'s sequential problem formulation.
Indeed, relevant robot behaviors are complex and cannot be modeled explicitly, especially in social robotics.
This limits the applicability of traditional rule-based approaches, which require explicit behavior modeling.
#acr("RL") proposes an alternative solution to the problem of robot policy design.
It relies on defining a reward function that gives the agent feedback on the quality of its action.
The agent will then progressively optimize its policy by interacting with the environment to maximize the collected reward.
Therefore, it is not required to model the environment explicitly; it is implicitly learned during training.
#acr("DRL") allows learning from high-dimensional sensory inputs, such as camera frames or recorded audio signals.
However, these approaches are extremely data-intensive and require considerable interaction with the environment to learn.
#acr("DRL") rapidly achieved impressive results on entirely virtual tasks where interacting with the environment is cost-effective and scalable.
Some recent works report agents interacting with environments for the equivalent of years of simulated time—OpenAI's Five agent trained on over 180 years of experience @raiman_long-term_2019, while common #acr("DRL") benchmarks like Atari require millions of frames to achieve good performance @mnih_playing_2013.
By contrast, robots are embodied agents that must interact with the physical world, where each action has a cost.
This mismatch gives rise to the well-known Sim-to-Real gap—the challenge of transferring policies trained in simulation to real-world hardware.
Overall, #acr("DRL") is a powerful framework for robotics, with many successful applications.
However, it still faces key limitations, including poor generalization, sample inefficiency, and limited interpretability.

=== Acoustic Localization and Navigation to Enhance Perception

Perceptually-motivated navigation is an interesting example of a complex multimodal robotics task.
It can be framed in various ways, depending on the context and the targeted application.
Robots must often perform complex tasks that require gathering information and planning actions with foresight.
Moreover, robots rarely have full observability.
Sensor limitations and occlusions often obscure parts of the environment.
Hence, a robot must willingly explore its environment to collect the necessary information and enhance its overall perception.
For example, the _Move2Hear_ task @majumder_move2hear_2021 requires a mobile robot to navigate in a realistic environment to enhance its ability to separate distinct speech sources.
Other objectives could similarly motivate an agent’s exploration strategy.
In this thesis, we narrow our focus to auditory perception as the sole sensory modality.
This constraint makes the task more challenging—since audio offers far less spatial information than vision—but also more fundamental.
It forces the robot to reason about its environment based on subtle acoustic cues, such as reverberation, directionality, and spectral variation.
The remainder of this thesis investigates how deep learning can support audio-based spatial perception and action in simulated environments.
This line of inquiry not only deepens our understanding of auditory intelligence but also contributes toward building more autonomous, resilient, and efficient robotic systems that can operate under minimal sensory assumptions.