#import "/utils.typ": *

== Presentation of the Acoustic Robot Simulator <sec:simulator:simulator>

The motivation to build a simulator from the ground up was to benefit from a capable yet flexible virtual platform for acoustic-based #acr("HRI") tasks.


#gaet[Should we mention that the simulator (along with the entire code base for this PhD) is available as open source ?]

==== Global architecture

#figure(
  image("figures/simulator_architecture.svg"),
  caption: [Simulator architecture]
)

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