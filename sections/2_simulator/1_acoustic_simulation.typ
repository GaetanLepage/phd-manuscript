#import "/utils.typ": *

== Acoustic simulation of reverberant environments

=== State of the Art

==== Image Source Model
// OG paper: 
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
- Pyroom Acoustics @scheibler_pyroomacoustics_2018
- Planeverb @rosen_interactive_2020
- GPU RIR 2016 @fu_gpu-based_2016
- gpuRIR 2020 @diaz-guerra_gpurir_2021


=== Overview of the simulator features

==== Global architecture

// TODO insert diagram of the architecture

// Room
// AudioSimulator


==== Sound sources

- Speech: Librispeech
- Noise: Music + white noise

==== Room

===== #acr("RIR") simulation

// Two backends:
// - GPU RIR
// - PyroomAcoustics

===== Generation of listened signals

==== Microphone arrays

// Support for various arrays

==== Feature extraction

- Geometric information
  - Absolute position of all elements
- Audio data
  - 


==== Simulation of dynamic scenarios

Movement

// Discrete step process
// Objects are static in the room


===== #acr("RIR") filtering in dynamic simulation

// The caution we take with the RIR filter stabilization when simulating short consecutive samples
// TODO: diagram of the superposition of speech samples
// [-----------]
//     [------------]
//          [------------]