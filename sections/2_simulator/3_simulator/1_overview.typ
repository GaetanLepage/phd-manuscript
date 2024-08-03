#import "/utils.typ": *

=== Overview <sec:simulator:simulator:overview>

The acoustic simulator is composed of several blocks that interact with each other.
@fig:simulator:simulator:overview offers a global overview of the pipeline architecture.

#let rir-lib = text(fill: rgb("D6B656"))[_#acr("RIR") simulation library_]
The core of the platform resides in the #rir-lib.
The latter performs the actual computation of the several required #acr("RIR") filters.
However, those libraries work at a low level and only account for a given static scene involving different unrelated microphones and sources.
Also, not all options handle acoustic signals and some only provide the #acr("RIR") filter.

#let room = text(fill: rgb("23445D"))[_room_]
Thus, the #room component offers a higher abstraction for the static acoustic simulation.
Its main feature is to leverage the #rir-lib to compute the listened signal of each microphone.

#let simulator = text(fill: rgb("6C8EBF"))[_simulator_]
Finally, the #simulator adds multiple features relating to dynamic scenarios.
Also, it operates more advanced audio objects such as multi-microphone arrays and sound sources of different kinds.
This block provides the most important external #acr("API") to our pipeline.
It allows for defining a room, an agent (i.e. microphone array) and a set of sound sources with a very limited amount of code.
The user can then move the different audio objects with convenient movement primitives and fetching the resulting audio and geometric data in diverse forms.

#figure(
  image("figures/simulator_architecture.svg"),
  caption: [Overview of the simulator architecture]
) <fig:simulator:simulator:overview>

// Room
// AudioSimulator