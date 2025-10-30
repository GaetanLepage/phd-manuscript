#import "../../utils.typ": *

= Deep Reinforcement Learning for Sound-Driven Navigation
<chap:rl>
#minitoc(indent: true)

#reset-acronym("RL")
#reset-acronym("DRL")
After having explored different acoustic challenges, this chapter will push further toward interactive robotics scenarios.
While supervised learning has been shown to be very effective for solving many robotic tasks, #acr("RL") constitutes an alternative framework for specific problems.
Its fundamental formulation targets interactive environments where an agent learns through trial and error.
We will use the modern #acr("DRL") paradigm to train an agent to navigate autonomously from auditory cues.
First, the general framework of #acr("RL") will be introduced, along with how deep neural networks are leveraged as function approximators in this context.
Secondly, we will present a problem of perceptually motivated acoustic-based robot navigation and relevant literature.
This chapter also exposes a proof of concept of a complete pipeline to address this challenging task.
Finally, experimental results will demonstrate the effectiveness of the proposed approach.


#include "1_rl_intro/0_index.typ"
#include "2_problem/0_index.typ"
#include "3_method/0_index.typ"
#include "4_results/0_index.typ"
#include "5_conclusion.typ"
