#import "/utils.typ": *

== Background
<sec:active_ssl:background>

In the original #acr("SSL") task, as defined by the signal processing community, every source in the room are assumed to be static.
However, the robotics field gave birth to original acoustic problems with different motivations and specificities.

First, several works addressing #acr("SSL") in its static formulation do address challenges related to robotics systems.
For instance, the physical aspect of a robotic head needs to be properly modeled from an acoustic perspective.
An overview of #acr("SSL") in robotics has been proposed in @sec:ssl:sota:ssl_in_robotics.
Conversely, this chapter will focus on problems involving explicitly moving entities.
No single well-defined task could be labeled as _active sound source localization_; thus, researchers have studied a wide range of diverse problems of this kind.
The common characteristic of active #acr("SSL") problems is considering a mobile robot operating in an acoustic environment that includes one or several sound sources.
In this dynamic context, the method then requires the agent to determine the relative positions of the sources.
The most significant difference is whether the robot's movement policy is explicitly optimized for this task.

In 2000, Nakadai et al. @nakadai_active_2000 designed a complex robotic system to perform _active audition_.
This innovative work consists of a physical robotic prototype equipped with microphones and cameras for sensing the environment.
The _active audition_ task aims to identify the #doa of the present sources accurately.
To achieve this objective, both vision and audio signals are processed to enhance the robustness of the prediction.
Also, the robot's head movement automatically adjusts to face the currently active source.
Visual data plays an essential role in refining the angular estimation.
Authors use the framework of Epipolar Geometry to compute an angle from both the camera images and the spectrums of the signals received by left and right external microphones.
Thanks to this angle, a directional band-pass filter is constructed, which permits dampening noise sounds coming from the robot's motors.
This method circumvents the use of #acr("HRTF"), which is challenging to access in real-world scenarios.
They test this pipeline within a relatively simple experimental scenario.
Two loudspeakers play a monotone sound at a given, distinct frequency.
They do so sequentially such that only a single source is active at a given time.
The robotic head is expected to progressively face the active source so that it lands in its cameras' field of view.
// split ?
Nakadai's work is among the first attempts to perform #acr("SSL") in a dynamic context.
However, it presents a few limitations.
On the one hand, the considered setting remains very simple.
No real speech signals are employed, and the sources remain in fixed positions.
On the other hand, the agent is not moving in the room, contrary to what this chapter will present.
Finally, their system does not estimate the distance to the active source.



// Nguyen + Emmanuel Vincent
#let nguyen = [
  @nguyen_localizing_2016
  @nguyen_van_long-term_2017
  // @nguyen_autonomous_2018 -> There is no movement in this work (learning to face the sound source)
  @nguyen_motion_2019
]
More recently, Nguyen et al. conducted a series of works #nguyen that tackle motion planning for robot audition.
They designed different probabilistic algorithms that attempt to localize an eventually moving sound source from a mobile robot.
In @nguyen_localizing_2016, the authors propose an #acr("MKF") to model the system's evolution.
While angular #acr("SSL") methods yield satisfying results, estimating the robot-source distance has proven significantly harder.
Hence, this study focuses on fusing movement information with #acr("DoA") estimation to predict the distance to the source.
The state vector consists of the absolute position of the robot, the one of the sound source, and the source's activity (whether it is active or not).
The provided theoretical derivation of the #acr("MKF") allows the estimation to be updated. 
The experiments illustrate the importance of the robot movements in achieving successful localization.
Indeed, at the beginning of the trajectories, the estimation suffers from the front-back ambiguity.
As the robot can move and accumulate information, the accuracy of the prediction increases.
Although the proposed method outperforms existing solutions, the robot's trajectory is not being optimized.
In @nguyen_van_long-term_2017, the authors improve their framework by proposing a long-term motion planning algorithm to localize a sound source.
They introduce a #acr("MCTS") method to compute the optimal robot trajectory.
The optimization objective is to reduce the entropy of the belief on the source localization.
Shannon entropy measures uncertainty and drives the exploration of the #acr("MCTS").
This framework allows the motion planning algorithm to run on a predefined limited computational budget.
Experimental results show that the #acr("MCTS") planning successfully minimizes the entropy during the trajectory compared to greedy or random algorithms.
Furthermore, the average estimation error also sees an improvement using this approach.
This complete pipeline has been subsequently extended in @nguyen_motion_2019.
First, the #acr("MKF") formulation is extended to handle intermittent sound sources better and to be more robust to erroneous measurements of sound activity and #acr("DoA").
In addition to the entropy objective introduced in @nguyen_van_long-term_2017, the standard deviation of the estimated belief on the source location may now also be used to compute the optimal trajectory.
Both criteria are compared in a thorough experimental study and are shown to reduce the source location estimation error successfully.


// Bustamante
#let bustamante = [
  @bustamante_three-stage_2015
  @bustamante_towards_2016
  @bustamante_information_2017
  @bustamante_multi-step-ahead_2017
]
//TODO: limited to a single sound source + absolute position of the robot is known
In the same period,  Bustamante et al. developed a similar pipeline across a collection of articles #bustamante.
In their foundational paper @bustamante_three-stage_2015, they introduce a three-stage strategy to combine a mobile robot control scheme and the associated source location estimator.
The first stage consists of the short-term detection of azimuth and activity.
This step solely leverages the most recent binaural features.
The #acr("DoA") estimator is a maximum likelihood estimator derived directly from the #acr("DFT") of the listened signal.
Both the single-source and multi-source cases are handled.
The latter is addressed by an #acr("EM") algorithm that iteratively performs source separation (E-step) and source localization (M-step).
Conversely, the second stage aggregates these data over time and combines them with past motor commands.
This provides a progressively finer estimate of the source's relative location.
Finally, the third stage is computing the following control command by implementing a feedback loop.
The first two phases were tested in an anechoic room, and the results were promising.
A technical solution for the third stage is provided in @bustamante_towards_2016.
They model the posterior distribution of the source localization as Gaussian mixture and use a Kalman filter to predict the the next state posterior pdf.
The control commands are computed by solving an optimization problem that maximizes the mutual information between the predicted sensor position and the sound source's measurement.
This ensures that the sensor moves in a way that yields the most informative measurement at the next time step.
This method was evaluated both in simulation and on a physical system.
The complete pipeline is further detailed and tested in @bustamante_information_2017.
Bustamante et al. @bustamante_multi-step-ahead_2017 extended the control command optimization to a multi-step ahead process to enhance their three-staged approach.
The optimization problem now consists of determining the sequence of controls that minimizes a cost function at each iteration.
This objective directly incorporates the expected uncertainty on the source's position over multiple future steps.
#draft[TODO: Conclude on this work].

#draft[
  // Classic method to move and localize a source (no Deep Learning)
  @bustamante_multi-step-ahead_2017
]

In conclusion, active #acr("SSL") has been a topic of interest in the robotic literature.
Indeed, static localization approaches suffer from limitations such as the front-back ambiguity or distance non-observability. #todo