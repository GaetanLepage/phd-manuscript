#import "/utils.typ": *

= Active Sound Source Localization
<chap:active_ssl>
#minitoc(indent: true)

In @chap:ssl, the problem of #acr("SSL") has been explored.
Several settings have been considered, underlining their respective challenges and specificities.
All discussed solutions amounted to localize one or several sound source in a static setup, where neither the microphones nor the sources were moving.

This chapter extends the previous framework by considering the problem of #acr("ASSL").
With the intention of approaching a task closer from real-world social robotics, we study a dynamic setting where the agent moves around the room and attempts at localizing multiple sources.

First, a brief overview of related works will be proposed in @sec:active_ssl:sota.
Then, the presentation of the exact task will follow in @sec:active_ssl:methods, along with our different approaches.
Finally, various experiments and the corresponding results will be summarized in @sec:active_ssl:results.

#include "1_sota.typ"
#include "2_method/0_index.typ"
#include "3_results.typ"
#include "4_conclusion.typ"