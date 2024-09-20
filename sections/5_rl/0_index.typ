#import "/utils.typ": *

= Reinforcement Learning
<chap:rl>
#minitoc(indent: true)

#reset-acronym("RL")
#reset-acronym("DRL")
After having explored different acoustic challenges, this chapter will push further toward interactive robotics scenarios.
While supervised learning has shown to be very efficient for solving many robotic tasks, #acr("RL") constitutes an alternative framework for certain problems.
Its fundamental formulation targets interactive environments where an agent learns through trial and error.
We will explore the use of the modern #acr("DRL") paradigm for training an agent to navigate autonomously from auditory cues.
At first, the general framework of #acr("RL") will be introduced as well as how deep neural networks are leveraged as function approximators in this context.
Secondly, we will present a problem of perceptually motivated acoustic-based robot navigation and relevant literature.
This chapter also exposes a proof of concept of a complete pipeline to address this challenging task.
Finally, experimental results will demonstrate the capacity of the former solution.


#include "1_rl_intro.typ"
#include "2_problem.typ"
#include "3_method.typ"
#include "4_results.typ"