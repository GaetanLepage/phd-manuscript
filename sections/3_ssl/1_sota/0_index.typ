#import "/utils.typ": *

== Sound source localization background
<sec:ssl:sota>

#reset-acronym("SSL")

=== Original problem
// Very broad introduction
#acr("SSL") is part of the classic challenges in artificial speech processing.
This challenge requires to identify the relative position of one or several sound sources leveraging an audition device.

// TODO: motivate this problem: why is it relevant, give examples in robotics

// DoA - only vs dist + DoA
The exhaustivity of the
Importantly, one may attempt at determining both the angle

A broad range of specific settings and methods have been investigated in the audio processing literature.


// TODO: not sure that this "motivation" paragraph belongs here. Maybe more in the chapter intro ?
Our intent at exploring #acr("SSL") was initially motivated by our exploratory work in Deep Reinforcement Learning (see @chap:rl).



#draft[
#reset-acronym("GCC-PHAT")
  TODO: remove ?
  ===== #acr("GCC-PHAT")
  
  // https://dsp.stackexchange.com/questions/74574/understanding-gcc-phat-as-a-feature
]


=== Classical approaches
<sec:ssl:sota:classical_approaches>

// Handcrafted features

// Statistical methods
@alameda-pineda_geometric_2014

// Sharon's paper on estimators and their performance



=== Deep Learning methods for #acr("SSL")
<sec:ssl:sota:deep_learning>

// Survey paper
@grumiaux_survey_2021


=== Sound Source localization in robotics
<sec:ssl:sota:ssl_in_robotics>

Although, as demonstrated above, #acr("SSL") has been studied as a self-contained problem, it certainly have an important number of downstream applications.
Among those, robotics is a major use case of #acr("SSL") algorithms.
Perception is an essential building block of a social robotics platform.
Besides the exploitation of visual features which falls under the computer vision domain, leveraging the audio cues may provide valuable information for a social robot.
Naturally, such an agent will use language as the primary mean of communication with humans and will thus need to extract the meaning of the speech of its interlocutors.
Besides #("ASR"), sound information may have additional use cases.

// Other uses of audio in robotics
For instance, human-robot interaction can be enhanced by having the agent adjust its gaze and look at the person it is interacting with.
// TODO: cite study that backs this claim
This has been achieved by the mean of computer vision techniques but #acr("SSL") also yields positive results. // TODO cite some works that do this
A robot being able to accurately locate other sound sources can also adjust its navigation policy to benefit from this knowledge.
Robot navigation is likewise complex and often relies on multi-modal perception.
The use of LIDAR or depth information are used for the robot to localize itself as well as other potentially moving subjects in the environment.
// TODO citations
However, identifying the position of currently speaking humans requires some sort of #acr("SSL") method.

// Constraint related to robotics
Robotics also brings additional challenges to the #acr("SSL") task.
Indeed, a robotic platform implies to deal wit several constraints mainly caused by interacting with the real world.
#draft[
// TODO:
- Reverberation
- Moving objects
- Intermittent sources
- Noise (motor noise, music, multiple concurrent sources)
]

// Classical approaches
#draft[Back in ..., researchers have intended to localize ...]
// TODO: cite some works
// - Xavi+Radu's paper
// - older perception work ?

// Deep Learning
Deep learning methods have been used as well to perform #("SSL") in robotics.

// Using multi-modal information (audio-visual SSL)
// -> Not directly related to our topic though