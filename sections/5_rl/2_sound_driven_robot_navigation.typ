#import "/utils.typ": *

== Sound-driven robot navigation
<sec:rl:method>

=== Motivation

Social robotics imply various technical and scientific problems involving computer vision, mechatronics, sociology, natural language processing or speech processing.
Robot navigation stands as one of such crucial tasks.
Numerous formulations of this question exist and they encompass different goals, sensory information and target robotics platforms.
Although processing


#draft[Should we talk about MPC ?]

=== Problem formulation

$
  cal(A) = {
    "STAY",
    "FORWARD",
    "TURN_LEFT",
    "TURN_RIGHT"
  }
$

=== State of the Art

- _SoundSpaces_ @chen_soundspaces_2020
- _Move2Hear_ @majumder_move2hear_2021

=== Method

#reset-acronym("PPO")
==== The #acr("PPO") algorithm

@schulman_proximal_2017

#let l-clip = $colMath(L_t^"CLIP" (theta), #maroon)$
#let l-vf = $colMath(L_t^"VF" (theta), #olive)$
#let entropy = $colMath(S[pi_theta](s_t) , #eastern)$
$
  L_t ^("CLIP" + "VF" + "S") (theta) = 
  hat(EE)_t lr([
    #l-clip
    - c_1 #l-vf
    + c_2 #entropy
  ], size: #140%)
$ <eq:rl:ppo_loss>

where:
- #l-clip
- #l-vf
- #entropy

#draft[ /!\\ This is the objective (to *maximize*)]

==== #acr("WER") maps as a reward

// Explain the different reward schemes

// Motivation: use #acr("ASR") as objective