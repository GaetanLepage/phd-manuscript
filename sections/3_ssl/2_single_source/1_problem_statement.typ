#import "/utils.typ": *

=== Problem statement

A robotic agent is evolving in a reverberant room.
A single speech source is also present in the environment.
The task consists in determining the relative position a unique sound source.
Although the focus will be directed towards methods predicting solely the #acr("DoA"), solutions that also estimate the distance to the source have been evaluated.

#figure(
  image("figures/ssl_task.svg", height: 20em),
  caption: [
    Schema of the #acr("SSL") task
  ]
) <fig:ssl:single_source:task>

As seen in @sec:ssl:sota:ssl_in_robotics, multi-modal information can be leveraged to perform #acr("SSL") in a robotics context. // TODO: remove if we end up not talking about A/V SSL
However, in this chapter, we will focus on the exclusive use of audio information.
This choice is more representative of the classical formulation of the #acr("SSL") problem and although simpler to formulate constitutes a challenging task.

Furthermore, we expect to leverage our solution in active interaction scenarios of dynamic nature.
In a real-time context, we expect reduce the latency of our localization system to improve the responsiveness of the overall solution.
As a consequence, only a short recording should suffice to accomplish an accurate localization of the source.
// TODO Nature of the source


#draft[Needs transition]

The objective of this work is not to establish a state of the art solution for #acr("SSL").
Conversely, a proof of concept for a complete localization pipeline is proposed.
Our intention consists in studying the various determining factors of performance for a #acr("DL")-based #acr("SSL") system.
#draft[TODO...]