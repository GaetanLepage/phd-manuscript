#import "/utils.typ": *

== Sound-driven robot navigation <sec:rl:method>

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

==== #acr("WER") maps as a reward

// Explain the different reward schemes

// Motivation: use #acr("ASR") as objective