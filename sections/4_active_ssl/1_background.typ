#import "/utils.typ": *

== Background
<sec:active_ssl:background>

In the original #acr("SSL") task, as defined by the signal processing community, every source in the room are assumed to be static.
However, the robotics field gave birth to original acoustic problems with different motivations and specificities.

First, several works addressing #acr("SSL") in its static formulation do address challenges related to robotics systems.
For instance, the physical aspect of a robotic head needs to be properly modeled from an acoustic perspective.
An overview of #acr("SSL") in robotics have been proposed in @sec:ssl:sota:ssl_in_robotics.
Conversely, this chapter will focus on problems involving explicitly moving entities.
No single well-defined task could be labeled as _active sound source localization_ and thus, researchers have studied a broad range of diverse problems of this kind.
The common characteristic of active #acr("SSL") problem stands in considering a mobile robot, operating in an acoustic environment which includes one or several sound sources.
The method then needs, in this dynamic context, for the agent to determine the relative positions of the sources.
Where most differences arise is about whether the robot's movement policy also gets optimized explicitly to perform this task.

@nakadai_active_2000

// Classic method to move and localize a source (no Deep Learning)
@bustamante_multi-step-ahead_2017

// Nguyen + Emmanuel Vincent
@nguyen_localizing_2016
@nguyen_van_long-term_2017
@nguyen_autonomous_2018
@nguyen_motion_2019

// Nakadai