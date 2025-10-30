#import "../../utils.typ": *

= Active Sound Source Localization
<chap:active_ssl>
#minitoc(indent: true)

#reset-acronym("ASSL")

@chap:ssl addressed the challenge of #acr("SSL") in static environments, where both the robot and the sources remained fixed.
While this formulation is useful for controlled experimentation, it does not adequately represent real-world scenarios encountered in social robotics.
In such contexts, robots operate in dynamic spaces and must leverage movement to refine their perception of surrounding sound sources.

This chapter introduces the problem of #acr("ASSL"), in which the agent actively moves through the environment and uses its accumulated observations to localize sound sources—without actively controlling its trajectories.
Unlike passive #acr("SSL"), #acr("ASSL") benefits from temporal and spatial integration, allowing the robot to resolve ambiguities and gather more informative observations over time.
This dynamic setup is more representative of practical robotic applications, including speaker tracking and human-robot interaction.

#acr("ASSL") presents new challenges: observations are temporally distributed, perception varies with position and orientation, and fusing noisy cues requires careful design.
In this work, we propose a modular learning-based approach to address these issues.
The method builds upon the static #acr("SSL") model introduced earlier, augmenting it with a mechanism to aggregate directional cues into egocentric 2D maps.
We explore two fusion strategies: a simple averaging method and a more advanced deep learning model trained to produce clean spatial heatmaps.
These maps are then post-processed to extract the estimated source positions.

The rest of the chapter is organized as follows.
@sec:active_ssl:background review related work on #acr("ASSL"), highlighting its challenges and the range of approaches explored in the literature.
@sec:active_ssl:problem_formulation formally defines the problem addressed in this chapter.
@sec:active_ssl:method presents our proposed method, detailing the full localization pipeline, including the generation and aggregation of egocentric maps and the detection strategy.
@sec:active_ssl:results reports experimental results and ablation studies, analyzing the influence of key design choices.
Finally, @sec:active_ssl:conclusion concludes the chapter and discusses possible extensions and future research directions.

#include "1_background.typ"
#include "2_problem_formulation.typ"
#include "3_method/0_index.typ"
#include "4_results/0_index.typ"
#include "5_conclusion.typ"
