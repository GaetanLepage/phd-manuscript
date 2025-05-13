#import "/utils.typ": *

== Background
<sec:active_ssl:background>


The problem of #acr("SSL") has been extensively studied in both the robotics and acoustic signal processing communities.
While their research overlaps significantly, the two domains approach the problem from different perspectives.
In signal processing, #acr("SSL") is typically framed in terms of static microphone arrays and occasionally moving sound sources — a scenario often referred to as sound source tracking.
In contrast, the robotics perspective introduces additional considerations due to the physical embodiment of robots.
Even in the static case, robot-specific challenges arise, such as the need to acoustically model the material and geometry of the robot’s head or body (see Skaf et al. @skaf_optimal_2011 for example).
@sec:ssl:background:ssl_in_robotics provides an overview of #acr("SSL") in robotics, focusing on these specific challenges.

#acr("ASSL") is a natural extension of #acr("SSL") in the context of robotics, where the agent is not static but mobile.
The #acr("ASSL") problem does not follow a single, well-defined formulation; rather, its definition varies across studies and application domains.
When the robot is capable of movement, the problem space expands significantly, and different research communities may adopt distinct perspectives.
In all cases, the robot’s motion influences its acoustic perception — either by affecting the signals it receives or by enabling additional observations over time.
This mobility introduces both challenges and opportunities for improved localization.
A key factor distinguishing #acr("ASSL") approaches is how the robot’s motion is handled: in some cases, it is explicitly optimized to enhance localization performance; in others, motion arises from external constraints or tasks, and the localization system must adapt accordingly.
Wightman et al. @wightman_resolution_1999 experimented on human listeners and identified movement as an effective way of dealing with front-back confusions in binaural hearing.
Naturally, researchers have explored how a robot's movements might help improve localization performance.
Regardless of the formulation, mobility plays a central role in designing and evaluating localization strategies.


Nakadai et al. @nakadai_active_2000 designed a complex robotic system to perform _active audition_.
This work consisted of a physical robotic prototype equipped with microphones and cameras for sensing the environment.
The _active audition_ task aims to estimate the #doa of the present sources accurately.
To achieve this objective, both vision and audio signals are processed to enhance the robustness of the prediction.
Also, the robot's head movement automatically adjusts to face the currently active source.
Visual data plays an essential role in refining the #doa estimation.
The authors use the framework of Epipolar Geometry to compute an angle from both the camera images and the spectra of the signals received by left and right external microphones.
Thanks to this angle, a directional band-pass filter is constructed, which permits dampening noise sounds produced by the robot's motors.
This method circumvents the use of #acr("HRTF"), which is challenging to access in real-world scenarios.
They test this pipeline within a relatively simple experimental scenario.
Two loudspeakers play a monotone sound at a given, distinct frequency.
They operate sequentially, ensuring that only one source is active at any given time.
The robotic head is expected to progressively face the active source so that it lands in its cameras' field of view.
This work was among the first attempts to perform #acr("SSL") in a dynamic context.
However, it presents a few limitations.
On the one hand, the considered setting remains very simple.
No authentic speech signals are employed, and the sources remain fixed.
On the other hand, contrary to what this chapter will present, the agent does not actually move in the room; only its head does.
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
In @nguyen_localizing_2016, the authors proposed a #acr("MKF") to model the system's evolution.
While angular #acr("SSL") methods yield satisfying results, estimating the robot-source distance has proven significantly harder.
Hence, this study focuses on fusing movement information with #acr("DoA") estimation to predict the distance to the source.
The state vector consists of the absolute position of the robot, the one of the sound source, and the source's activity (whether it is active or not).
The provided theoretical derivation of the #acr("MKF") allows the estimation to be updated. 
The experiments illustrate the importance of the robot's movements in achieving successful localization.
Indeed, at the beginning of the trajectories, the estimation suffers from the front-back ambiguity.
As the robot can move and accumulate information, the accuracy of the prediction increases.
Although the proposed method outperformed some existing solutions, the robot's trajectory was not optimized.
In @nguyen_van_long-term_2017, the authors improved their framework by proposing a long-term motion planning algorithm to localize a sound source.
They introduced a #acr("MCTS") method to compute the optimal robot trajectory.
The optimization objective is to reduce the entropy of the belief in the source localization.
Shannon's entropy measures uncertainty and drives the exploration of the #acr("MCTS").
This framework allows the motion planning algorithm to run on a predefined, limited computational budget.
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
In the same period, Bustamante et al. presented a similar pipeline in a collection of articles #bustamante.
In their foundational paper @bustamante_three-stage_2015, they introduced a three-stage strategy to combine a mobile robot control scheme and the associated source location estimator.
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
They model the source localization's posterior distribution as a Gaussian mixture and use a Kalman filter to predict the next state posterior pdf.
The control commands are computed by solving an optimization problem that maximizes the mutual information between the predicted sensor position and the sound source's measurement.
This ensures that the sensor moves in a way that yields the most informative measurement at the next time step.
This method was evaluated both in simulation and on a physical system.
The complete pipeline is further detailed and tested in @bustamante_information_2017.
To enhance their three-staged approach, Bustamante et al. @bustamante_multi-step-ahead_2017 extended the control command optimization to a multi-step ahead process.
The optimization problem now consists of determining the sequence of controls that minimizes a cost function at each iteration.
This objective directly incorporates the expected uncertainty on the source's position over multiple future steps.
Overall, Bustamante's work demonstrates another principled, complete, and performing approach to #acr("ASSL").
On the one hand, it aggregates #acr("DoA") estimations and robot movement over time to localize a sound source in 2D relative to the agent.
On the other hand, it provides a controlling scheme for the agent that optimizes the location performance in the long term.

In addition to the works mentioned above, we subsequently mention other relevant references.
Roman et al. @roman_binaural_2008 designed a binaural tracking system to localize several moving sources.
They use a probabilistic model to predict the sources' locations from interaural cues (#acr("ILD") and #acr("IPD")).
The solution's tracking capability relies on an #acr("HMM") formulation.
It ensures that sources are tracked across time and imposes continuity constraints on the detections.
The challenge of reverberant environments has not been considered in the methodology.
However, the authors do test their system in the presence of reverberation.
Performance is shown to suffer from increasing the $T_60$.
Working on the robustness of localization systems to reverberation is a key area for future improvement.
Kneip et al. @kneip_binaural_2008 claim that combining rotation and translation movements from a robot significantly enhances localization performance.
Argentieri et al.'s survey on #acr("SSL") in robotics @argentieri_survey_2015 includes additional references to works in #acr("ASSL").
Yet, the authors conclude that _active audition_ would benefit from additional research effort.
The #acr("BINAAHR") project was a French-Japanese collaboration on robotic auditory perception.
It allowed for several publications on active audition (see Markovic et al. @markovic_active_2013 and Portello et al. @portello_active_2012, for example).
In @gala_realtime_2019, Gala et al. derive a mathematical model for predicting both the #acr("DoA") and distance to a single static sound source solely from the #acr("ITD").
They achieve this by using a robotic head that can rotate.
It can thus leverage the recorded #acr("ITD") at different angular positions.
Adavanne et al. @adavanne_localization_2019 handle multiple sound sources' localization, detection, and tracking.
The framework is tested in both anechoic and reverberant environments.
Their #acr("CRNN") architecture successfully aggregates information over time, allowing for strong tracking performance.

In conclusion, active #acr("SSL") has been a topic of interest in the robotic literature.
Indeed, static localization approaches suffer from limitations such as the front-back ambiguity or distance non-observability.
The literature contains successful examples of #acr("ASSL") approaches.
Most existing strategies rely on probabilistic and information-theoretic frameworks and derive analytical schemes.
No deep learning-based solutions have been identified.
This chapter introduces a novel framework for #acr("ASSL") leveraging an original #acr("DNN") architecture.