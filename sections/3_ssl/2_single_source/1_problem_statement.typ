#import "/utils.typ": *

=== Problem statement

A robotic agent is evolving in a reverberant room.
A single speech source is also present in the environment.
The task consists of determining the relative position of a unique sound source (@fig:ssl:single_source:task).
Although the focus will be directed towards methods that predict solely the #acr("DoA"), solutions that estimate the distance to the source have been evaluated.

#figure(
  image("figures/ssl_task.svg", height: 20em),
  caption: [
    Schema of the #acr("SSL") task
  ]
)
<fig:ssl:single_source:task>

As seen in @sec:ssl:background:ssl_in_robotics, multi-modal information can be leveraged to perform #acr("SSL") in a robotics context.
However, this chapter will focus on the exclusive use of audio information.
This choice is more representative of the classical formulation of the #acr("SSL") problem, and although simpler to formulate, it constitutes a challenging task.

Furthermore, we expect to leverage our solution in dynamic, active interaction scenarios.
In a real-time context, we expect to reduce the latency of our localization system to improve the solution's overall responsiveness.
As a consequence, only a short recording should suffice to accomplish an accurate localization of the source.
This work is motivated by human-robot interaction and thus attempts to detect speech sources.
The framework aims to model a reverberant environment where a human speaker is located.
The robot is asked to estimate the person's position even if the geometric situation is challenging.

The objective of this work is not to establish a state-of-the-art solution for #acr("SSL").
Conversely, a proof of concept for a complete localization pipeline is proposed.
We intend to study the various performance-determining factors of a #acr("DL")-based #acr("SSL") system.
Solving this task will provide a base building block for integrating into our more complex #acr("RL") pipeline, as presented in @chap:rl.