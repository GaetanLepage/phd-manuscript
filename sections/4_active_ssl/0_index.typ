#import "/utils.typ": *

= Active Sound Source Localization
<chap:active_ssl>
#minitoc(indent: true)


In @chap:ssl, the problem of #acr("SSL") has been explored.
Several settings have been considered, underlining their respective challenges and specificities.
All discussed solutions involved localizing one or several sound sources in a static setup, where neither the microphones nor the sources moved.

This chapter extends the previous framework by considering the problem of #acr("ASSL").
To move closer to real-world social robotics scenarios, we focus on a dynamic setting in which the agent actively moves through the environment to localize multiple simultaneous sources.

First, a brief overview of related works will be proposed in @sec:active_ssl:background.
The task will then be specified, and our different approaches will be presented in @sec:active_ssl:methods.
Finally, various experiments and the corresponding results will be summarized in @sec:active_ssl:results.

#include "1_background.typ"
#include "2_method/0_index.typ"
#include "3_results/0_index.typ"
#include "4_conclusion.typ"