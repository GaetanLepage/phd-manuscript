#import "/utils.typ": *

== Thesis Structure


#figure(
  image("figures/diagram.svg", width: 80%),
  caption: flex-caption(
    short: [
      Overview of the thesis organization.
    ],
    long: [
      Overview of the thesis organization.
      Each chapter, represented by a block, outlines a specific contribution.
    ],
  ),
)
<fig:intro:thesis_structure>

@fig:intro:thesis_structure  provides a graphical overview of the thesis organization, which is structured around four technical chapters, each corresponding to a specific contribution.

@chap:simulator introduces key acoustic principles and reviews the state of the art in room acoustic simulation.
It presents the custom simulation library developed for this thesis, detailing its architecture, capabilities, and performance.
This simulator supports both static and dynamic scenarios and serves as the foundation for all subsequent experiments.

@chap:ssl addresses the task of #acr("SSL").
After reviewing relevant literature, we present deep learning-based models for both single- and multi-source localization.
These models are evaluated within our simulated environment, with a focus on their robustness and limitations.

@chap:active_ssl extends the #acr("SSL") problem to dynamic settings.
We define an active localization task in which the robot moves to improve spatial awareness.
A deep-learning-based pipeline is introduced to accumulate localization evidence over time, leveraging motion as a source of information.

#reset-acronym("DRL")
@chap:rl applies #acr("DRL") to a perceptually motivated navigation task.
Here, the robot learns to reposition itself in order to improve #acr("ASR") performance, using only acoustic feedback.
We describe the task design, learning setup, and policy evaluation.

@chap:conclusion concludes the thesis by summarizing the main contributions, highlighting limitations, and proposing future research directions.


This structure reflects a gradual progression: from simulation tools (@chap:simulator) to perception (@chap:ssl and @chap:active_ssl) and finally, learned control and behavior (@chap:rl).
Each stage builds upon the previous one to address the overarching challenge of embodied auditory intelligence in robotics.