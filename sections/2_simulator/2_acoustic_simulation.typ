#import "/utils.typ": *

== Acoustic simulation of reverberant environments

In this section, the core concepts of acoustic reverberation will be explained.
Also, we will present important works regarding the problem of realistically simulating sound propagation in reverberant environments.

=== Background

==== Problem formulation

#draft[
  Simulating received signal in a reverberant room
]

==== Acoustic reverberation

- Reverberation time ($T_60$)

#reset-acronym("RIR")
==== #acr("RIR")

$
  m_k (t) = sum_(i=1)^(n_s) ("RIR"_(i, k) * s_i)(t)
$ <eq:simulator:rir_listened_signal>

=== Related works

==== Image Source Model
// OG paper: 

@allen_image_nodate

// @srivastava_how_2023 has some info on ISM ('Method' section)

==== Sound propagation numerical simulation

- @raghuvanshi_efficient_2016
- @rosen_interactive_2020 + Planeverb library
- @benhamou_numerical_2023

==== Other methods

Path/ray tracing
- @cao_interactive_2016,
- @schissler_interactive_2017

// Neural network
@tang_learning_2020,

=== #acr("RIR") simulation libraries

//draft
Libraries:
- RoomSim @campbell_roomsim_nodate
- _Pyroomacoustics_ @scheibler_pyroomacoustics_2018
- Planeverb @rosen_interactive_2020
- GPU RIR 2016 @fu_gpu-based_2016
- gpuRIR 2020 @diaz-guerra_gpurir_2021