#import "/utils.typ": *

=== Problem statement

A robotic agent is evolving in a reverberant room.
A single speech source is also present in the environment.
The task consists in determining the relative position a unique sound source.
Although the focus will be directed towards methods predicting solely the #acr("DoA"), solutions that also estimate the distance to the source have been evaluated.
// TODO add a figure to illustrate the DOA + distance, basically a scheme of the problem
#figure(
  square(size: 10em, stroke: 2pt),
  caption: [
    Illustration of the #acr("SSL") problem setting
  ],
) <fig:ssl:single_source:ssl_schema>

As seen in @sec:ssl:sota:ssl_in_robotics, multi-modal information can be leveraged to perform #acr("SSL") in a robotics context. // TODO: remove if we end up not talking about A/V SSL
However, in this chapter, we will focus on the exclusive use of audio information.
This choice is more representative of the classical formulation of the #acr("SSL") problem and although simpler to formulate constitutes a challenging task.

Furthermore, we expect to leverage our solution in active interaction scenarios of dynamic nature.
In a real-time context, we expect reduce the latency of our localization system to improve the responsiveness of the overall solution.
As a consequence, only a short recording should suffice to accomplish an accurate localization of the source.
// TODO Nature of the source


