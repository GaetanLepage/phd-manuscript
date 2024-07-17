#import "/utils.typ": *

== Sound source localization, State of the Art


=== Original problem
// Very broad introduction
#acr("SSL") is part of the classic challenges in artificial speech processing.
This challenge requires to identify the relative position of one or several sound sources leveraging an audition device.

// TODO: motivate this problem: why is it relevant, give examples in robotics

// 
A broad range of specific settings and methods have been investigated in the audio processing literature.


=== Acoustic data representation <seq:ssl:sota:data_repr>

#chris[Do you use all of them? Concentrate at the the moment only on the methods you use. If you have later more time, then you can give others more place in a related work section.]
#gaet[No, but as this is the SotA section, I thought important to be more exhaustive.]

The numerical representation of the audio information is a crucial for achieving #acr("SSL").
Several pre-processing methods exist to ease the extraction of geometric information.

==== Waveform

==== Time-frequency representations

===== Short Term Fourier Transform

===== Interaural representation

As explained before, one want to leverage the delays between the signals listened by each microphone.

One of the motivation of using multiple microphones to perform Sound Source Localization is leveraging the delay at which the signal is listened 
In the case of a binaural microphone system,

@uragun_discrimination_2013 (About the #acr("ILD") feature)

// TODO: Nice stuff about ILD/IPD in "Binaural Hearing for Robots - Methodological Foundations" (see zotero)

// TODO schemas
- #acr("ILD")
$ "ILD"(S_1, S_2) = 20 log_10 abs(S_1/S_2) $

- #acr("IPD")
$ "IPD"(S_1, S_2) = arg(S_1/S_2) $

#reset-acronym("GCC-PHAT")
===== #display-def("GCC-PHAT")

// https://dsp.stackexchange.com/questions/74574/understanding-gcc-phat-as-a-feature


=== Classical approaches <seq:ssl:sota:classical_approaches>

// Handcrafted features

// Statistical methods
@alameda-pineda_geometric_2014

// Sharon's paper on estimators and their performance



=== Deep Learning methods for #acr("SSL") <seq:ssl:sota:deep_learning>

// Survey paper
@grumiaux_survey_2021


=== Sound Source localization in robotics <seq:ssl:sota:ssl_in_robotics>

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
// TODO:
- Reverberation
- Moving objects
- Intermittent sources
- Noise (motor noise, music, multiple concurrent sources)

// Classical approaches
Back in ..., researchers have intended to localize ...
// TODO: cite some works
// - Xavi+Radu's paper
// - older perception work ?

// Deep Learning
Deep learning methods have been used as well to perform #("SSL") in robotics.