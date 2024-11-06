#import "/utils.typ": *

== Background
<sec:active_ssl:background>

In the original #acr("SSL") task, as defined by the signal processing community, every source in the room are assumed to be static.
However, the robotics field gave birth to original acoustic problems with different motivations and specificities.

First, several works addressing #acr("SSL") in its static formulation do address challenges related to robotics systems.
For instance, the physical aspect of a robotic head needs to be properly modeled from an acoustic perspective.
An overview of #acr("SSL") in robotics has been proposed in @sec:ssl:sota:ssl_in_robotics.
Conversely, this chapter will focus on problems involving explicitly moving entities.
No single well-defined task could be labeled as _active sound source localization_ and thus, researchers have studied a broad range of diverse problems of this kind.
The common characteristic of active #acr("SSL") problem stands in considering a mobile robot, operating in an acoustic environment which includes one or several sound sources.
The method then needs, in this dynamic context, for the agent to determine the relative positions of the sources.
Where most differences arise is about whether the robot's movement policy also gets optimized explicitly to perform this task.

In 2000, Nakadai et al. @nakadai_active_2000 designed a complex robotic system to perform _active audition_.
This innovative work consists in a physical robotic prototype equipped with microphones and cameras for sensing the environment.
The goal of the _active audition_ task lies in accurately identifying the #doa of the present sources.
To achieve this objective, both vision and audio signals are processed to enhance the robustness of the prediction.
Also, the robot's head movement automatically adjusts to face the currently active source.
Visual data plays an important role in refining the angular estimation.
Authors use the framework of Epipolar Geometry to compute an angle from both the camera images and the spectrums of the signals received by both left and right external microphones.
A directional band-pass filter is constructed thanks to this angle and permits dampening noise sounds coming from the robot's motors.
This method allows circumventing the use of #acr("HRTF") which is challenging to access in real-world scenarios.
They test this pipeline within a relatively simple experimental scenario.
Two loudspeakers play a monotone sound at a given, distinct frequency.
They do so sequentially such that only a single source is active at a given time.
The robotic head is expected to progressively face the active source so that it lands in its cameras' field of view.
// split ?
Nakadai's work is among the first attempts to perform #acr("SSL") in a dynamic context.
However, it presents a few limitations.
On the one hand, the considered setting remains very simple.
No real speech signals are employed, and the sources remain in fixed positions.
On the other hand, the agent is not moving in the room, contrary to what will be presented in this chapter.
Finally, their system does not estimate the distance to the active source.

// Nguyen + Emmanuel Vincent
#let nguyen = [
  @nguyen_localizing_2016
  @nguyen_van_long-term_2017
  @nguyen_autonomous_2018
  @nguyen_motion_2019
]
More recently, Nguyen et al. conducted a series of work #nguyen tackling motion planning for robot audition.
They designed different probabilistic algorithms that attempt to localize an eventually moving sound source from a mobile robot.
In @nguyen_localizing_2016, the authors propose an #acr("MKF") to model the system's evolution.
The absolute position of the robot, the one of the sound source, and the latter's activity (whether it is active or not) constitute the state vector.
The provided theoretical derivation of the #acr("MKF") allows for the estimation to be updated. 

//TODO: limited to a single sound source + absolute position of the robot is known

#let bustamente = [
  @bustamante_three-stage_2015
  @bustamante_multi-step-ahead_2017
  @bustamante_information_2018
]
#draft[
- Bustamante #bustamente

// Classic method to move and localize a source (no Deep Learning)
@bustamante_multi-step-ahead_2017
]


