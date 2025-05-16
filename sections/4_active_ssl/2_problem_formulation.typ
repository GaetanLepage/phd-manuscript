#import "/utils.typ": *

== Problem Formulation
<sec:active_ssl:problem_formulation>

As presented in @sec:active_ssl:background, experimenting with #acr("SSL") in mobile robotic settings presents challenges and opportunities.
In this work, we introduce and explore an #acr("ASSL") problem, motivated by the extension of the static #acr("SSL") methods developed in @chap:ssl to more realistic situations.
Indeed, estimating both distance and #doa from a single recording has been shown to be a challenging version of the #acr("SSL") problem.
Grumiaux et al. @grumiaux_survey_2021 insist on this difficulty in their survey by highlighting the relative scarcity of the literature in this specific area.
Neither the single-source nor the multi-source localizer introduced in the previous chapter supports accurate distance prediction.
Theoretically, though, aggregating solely angular information accumulated over time by a mobile robot could allow for predicting the actual location of sources in a room.

More precisely, a robotic agent moves in a room with one or several human speakers.
We adopt a step-based representation in which the robot performs movements at discrete time steps.
Each movement consists of a rotation of angle $theta_t$ and a translation of distance $d_t$ in the new direction.
The robot's movement at time step $t$ is thus written as $delta_t = (d_t, theta_t)$.
Its trajectory is assumed to be determined by an external policy that should not be affected.
Thus, the developed method aims to localize each source’s relative position over short time windows.
To emulate realistic timing constraints, each step duration is limited to a few hundred milliseconds.
The method is provided with the recorded signal at each microphone of the agent corresponding to this time frame.

*Horizon.*
A key distinction from the static #acr("SSL") formulation lies in the temporal dimension of the input.
In #acr("ASSL"), the agent gathers multiple observations over time as it moves through the environment, rather than relying on a single auditory snapshot.
While the movement policy itself is externally defined and not optimized, the agent's relative displacements are available to the localization module.
This sequential structure enables the model to accumulate spatial cues and refine its estimate of source positions.
The number of steps over which these observations are integrated is referred to as the horizon $H$.
Notably, only relative movement information may be leveraged to perform the task, as the absolute agent position remains unknown.
This formulation is simpler than active control schemes that explicitly optimize motion to reduce localization uncertainty, such as those developed by Bustamante et al. @bustamante_towards_2016 @bustamante_information_2017, but it retains the key benefit of leveraging egocentric movement for improved perception.
In our setup, sound sources represent human speakers positioned arbitrarily within the room.
Their positions are assumed to be static for an entire episode of $H$ steps.
This simplifying assumption is necessary for the development of our current work.
Future work may have to consider more complex source behaviors.