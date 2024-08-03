#import "/utils.typ": *

== Presentation of the Acoustic Robot Simulator <sec:simulator:simulator>

The motivation to build a simulator from the ground up was to benefit from a capable yet flexible virtual platform for acoustic-based #acr("HRI") tasks.
Also, its implementation has evolved along the project and has lead to an organic development process.
The set of features reflects the various downstream usages that have been made in the course of several years.

In this section, we will provide an overview of the main functionalities offered by our simulator as well as use case examples.


#gaet[Should we mention that the simulator (along with the entire code base for this PhD) is available as open source ?]

==== Overview

The acoustic simulator is composed of several blocks that interact with each other.

#figure(
  image("figures/simulator_architecture.svg"),
  caption: [Simulator architecture]
)

// Room
// AudioSimulator


==== Features
===== Sound sources

- Speech: Librispeech
- Noise: Music + white noise

===== Room

====== #acr("RIR") simulation

// Two backends:
// - GPU RIR
// - PyroomAcoustics

====== Generation of listened signals

===== Microphone arrays

// Support for various arrays

===== Feature extraction

- Geometric information
  - Absolute position of all elements
- Audio data
  - STFT: Talk about the STFT module
  - ILD/IPD: we introduce those only in chap.2, but maybe we could do it here.


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