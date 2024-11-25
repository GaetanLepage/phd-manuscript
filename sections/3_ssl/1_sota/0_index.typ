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
  //===== #acr("GCC-PHAT")
  
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




#draft[
  - Survey paper @grumiaux_survey_2021
  - How to (virtually) train your speaker localizer @srivastava_how_2023
  - Sound Source Localization Using Deep Learning Models @yalta_sound_2017

  Romain Serizel's papers on SSL:
  - CRNN-based Joint Azimuth and Elevation Localization with the Ambisonics Intensity Vector @perotin_crnn-based_2018
  - CRNN-Based Multiple DoA Estimation Using Acoustic Intensity Features for Ambisonics Recordings @perotin_crnn-based_2019
  - Regression Versus Classification for Neural Network Based Audio Source Localization @perotin_regression_2019
]


=== Sound Source localization in robotics
<sec:ssl:sota:ssl_in_robotics>

As demonstrated above, although #acr("SSL") has been studied as a self-contained problem, it certainly has an important number of downstream applications.
Among those, robotics is a significant use case of #acr("SSL") algorithms.
Perception is an essential building block of a social robotics platform.
Besides exploiting visual features, which falls under the computer vision domain, leveraging audio cues may provide valuable information for a social robot.
Naturally, such an agent will use language as the primary means of communication with humans and will thus need to extract the meaning of its interlocutors' speech.
Sound information may have additional use cases besides #("ASR").

// Other uses of audio in robotics
For instance, human-robot interaction can be enhanced by having the agent adjust its gaze and look at the person it interacts with.
// TODO: cite study that backs this claim
This has been achieved through computer vision techniques but #acr("SSL") has also yielded positive results. // TODO cite some works that do this
A robot that is able to locate other sound sources accurately can also adjust its navigation policy to benefit from this knowledge.
Robot navigation is likewise complex and often relies on multi-modal perception.
LIDAR, or depth information, allows the robot to localize itself and other potentially moving subjects in the environment.
// TODO citations
However, identifying the position of currently speaking humans requires some sort of #acr("SSL") method.

// Constraint related to robotics
Robotics also challenges the #acr("SSL") task.
Indeed, a robotic platform implies dealing with several constraints mainly caused by interacting with the real world.
#draft[
// TODO:
- Reverberation
- Moving objects
- Intermittent sources
- Noise (motor noise, music, multiple concurrent sources)
]

// Classical approaches
#draft[Back in ..., researchers have intended to localize ...]
#draft[
  // TODO: cite some works
  // - Xavi+Radu's paper
  // - older perception work ?
  
  - Nakadai 2002 AV @nakadai_real-time_2002
  - #text(red)[Interesting reference for robotics:] Argentieri, Danès, Souères: _A Survey on Sound Source Localization in Robotics: from Binaural to Array Processing Methods_ (2015) @argentieri_survey_2015
    Not too much DL (less than Laurent's survey).
    However, their approach is interesting as they focus on SSL for robotics.
    They distinguish between binaural methods, imitating human's hearing, and array processing ($n_"mics" > 2$).

    *IMPORTANT (in the Conclusion):* About the fact that in robotics, _things move_ by definition.
    - This is a challenge and most static techniques do not take this into account (limitation).
    - On the other hand, this is an opportunity (active SSL):\
      _Actually, the Robotics Community has not extensively addressed this active audition topic, although it may constitute one of the most promising progress in embodied audition._:
    
  - @rascon_localization_2017
]

// Deep Learning
In robotics, Deep Learning methods have also been used to perform #("SSL").
#draft[
- @nguyen_autonomous_2018: Collecting a dataset and training a CNN to localize and face a sound source with a humanoid robot head.
]

// Using multi-modal information (audio-visual SSL)
// -> Not directly related to our topic though

// TODO: talk about HRTF