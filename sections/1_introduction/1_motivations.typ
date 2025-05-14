#import "/utils.typ": *

== Motivations

=== Social Robotics & Embodied AI

In recent years, there has been flourishing and rapid progress in #acr("AI").
The performance of #acr("AI") systems has evolved dramatically in a short period.
Subsequently, these techniques have been used in numerous domains, ranging from highly specialized applications to widely spread end-consumer products.
These disruptive technologies significantly impact our daily lives, societies, and economies.
#acrpl("LLM") are surely the latest and most striking illustration of this revolution.
Since the invention of the attention mechanism and the transformer architecture in 2017 @vaswani_attention_2017, larger and larger models could be trained on constantly growing datasets.
The capabilities of #acrpl("LLM")s have pushed the boundaries of artificial reasoning and natural language processing.
Similarly, diffusion models have been equally successful for image generation.
Although interactions with these systems are still primarily text-based, academic and industrial actors invest substantial resources in making them more natural.
More precisely, #acr("AI") agents aim to interact with humans directly through speech and vision.
Some solutions, like KyutAI's Moshi @defossez_moshi_2024, can now have a two-way conversation with a human in real time.
Speech-based interaction is a central research challenge in #acr("HRI").
More generally, the design of embodied agents is at the core of social robotics.
Social robots operate in complex, dynamic, and often crowded environments.
They differ from traditional robots, such as the ones used in industrial settings to perform repetitive, narrow-scope actions.
These robots do not need to adapt and interact in an unpredictable environment.
Their policy is often deterministic and programmed in advance.
Also, they are not expected to interact naturally with humans.
Bridging the gap to performant social robots turned out to be considerably challenging.

#todo
As Hans Moravec observed in the 1980s, tasks that are easy for humans — like perception and motor coordination — are surprisingly difficult for robots, whereas abstract reasoning is often easier for machines [3].

In 1986, Hans Moravec famously introduced the following paradox.
High-level reasoning, which is difficult for humans, tends to be relatively easy for computers.
However, sensorimotor skills, which all humans learn at a very young age, are extremely difficult for #acr("AI") and robots.
_It is comparatively easy to make computers exhibit adult-level performance in solving problems on intelligence tests or playing checkers, and difficult or impossible to give them the skills of a one-year-old when it comes to perception and mobility._ @moravec_mind_1988
His observation, from 1988, remains highly relevant today as multimodal perception and action remain key challenges in #acr("AI") and robotics.


=== Multimodal Perception, a Focus on Acoustics

Multi-modal perception for a robot consists of its ability to sense and understand the environment around it.
Robots can be equipped with various sensors depending on their objectives, nature, and budget constraints.
For example, LIDAR sensors allow for estimating the distance to surrounding objects and are widely used in autonomous vehicles.
Cameras and microphones are cost-effective and let robots sense their environment like humans.
Multimodal perception requires extracting task-relevant information from this kind of raw sensor data.
It entails extracting knowledge from the raw gathered data that is valuable for the task.
For instance, object detection involves localizing and classifying semantic objects in the captured frames.
Multi-object tracking adds a temporal aspect to the task by tracking each identified object across time.
Depth estimation attempts to infer how far each pixel is in an image.
Regarding auditory perception, #acr("ASR") aims to enable machines to "understand" human speech by transcribing audio input into a readable format.
This task is essential in social robotics as speech is often the primary communication channel between humans and robots.
#acr("SSL") involves estimating the direction or position of the active audio sources in an environment.
#acr("SSL") helps robots be more spatially aware by complementing visual features.
Also, it allows them to know which person is currently speaking and where she is located.
Therefore, social robots can behave accordingly to the conversation dynamics.
#acr("SSL") can also provide crucial sensory context regarding robot navigation.


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
By leveraging high loads of training data, #acr("DRL") methods allow for the training of deep neural network models with great capacity.
This shift from traditional #acr("RL") methods to modern neural-based algorithms has considerably broadened the scope of problems that could be tackled.
Traditional #acr("RL") was limited to low-dimensional observation spaces.
The use of #acrpl("DNN") as function approximators expanded #acr("RL")'s applicability to high-dimensional, unstructured inputs.
#draft[TODO, examples?]
Such fundamental progress clearly impacted robotics, which is well suited to #acr("RL")'s sequential problem formulation.
Indeed, relevant robot behaviors are complex and cannot be modeled explicitly, especially in social robotics.
This restrains traditional, deterministic algorithms where rules must be explicitly formalized.
#acr("RL") proposes an alternative solution to the problem of robot policy design.
It relies on defining a reward function that gives the agent feedback on the quality of its action.
The agent will then progressively optimize its policy by interacting with the environment to maximize the collected reward.
Therefore, it is not required to model the environment explicitly; it is implicitly learned during training.
#acr("DRL") allows learning from high-dimensional sensory inputs, such as camera frames or recorded audio signals.
#draft[TODO, examples?]
However, these approaches are extremely data-intensive and require considerable interaction with the environment to learn.
#acr("DRL") rapidly achieved impressive results on entirely virtual tasks where interacting with the environment is cost-effective and scalable.
By contrast, robots are embodied entities and must ultimately interact with the real world.
#draft[Maybe one or two papers with examples of the scale of interactions. Even though I already gave such examples in Chap 2 and 5.]
Therefore, most approaches adopt a hybrid strategy, in which the policy is first trained on a simulated replication of the environment and then transferred to the physical one.
The so-called _Sim-to-Real_ gap characterizes the challenges of deploying such virtually-trained policies to real robots.
Overall, #acr("DRL") is a powerful framework for robotics and numerous successful applications in this domain have been found.
However, it suffers from key limitations such as poor generalization, sample inefficiency, and a lack of explainability.

=== Acoustic Localization and Navigation to Enhance Perception

#draft[
Objective: optimize ASR
- Robots need to understand what humans say to interact with them.
- ASR systems are sensible to the position of the agent -> let's optimize the agent's position
]

Perceptually-motivated navigation is an interesting example of a complex multimodal robotics task.
It can be framed in various ways, depending on the context and the targeted application.
Ultimately, robots are tasked to perform complex actions, requiring gathering information and carefully planning actions with anticipation.
Furthermore, exhaustively observing the environment is often impossible as sensors are limited and context might be missing or hidden.
Hence, a robot must willingly explore its environment to collect the necessary information and enhance its overall perception.
For example, the _Move2Hear_ task @majumder_move2hear_2021 requires a mobile robot to navigate in a realistic environment to enhance its ability to separate distinct speech sources.
Other different objectives could be used to motivate an agent's exploration strategy.