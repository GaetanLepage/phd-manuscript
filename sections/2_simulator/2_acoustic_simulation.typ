#import "/utils.typ": *

== Acoustic simulation of reverberant environments


=== State of the Art

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