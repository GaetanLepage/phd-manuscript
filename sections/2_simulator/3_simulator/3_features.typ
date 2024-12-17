#import "/utils.typ": *
#import "2_components.typ": d-rec

=== Advanced features
<sec:simulator:simulator:features>


==== Simulation of dynamic scenarios
<sec:simulator:simulator:features:dynamic_scenarios>

The regular `step()` method of the simulator, presented in 
@sec:simulator:simulator:components allows to update the simulator and to generate new received signals.
At each call of this function, each audio source reloads an entirely new signal and the simulation is performed subsequently.
Regular speech sources, when asked to refresh their signal, draw a distinct sample from the clean speech corpus and outputs the corresponding signal.
The latter usually consists of a complete sentence pronounced by a speaker and lasts several seconds.
The duration of the resulting simulated audio #d-rec will differ from step to step
This process suits well use cases where each _step_ is independent of the others.

*Continuous sources.*
To allow for more realistic modeling, we introduce continuous speech sources.
The simulation still happens in discrete steps during which all audio objects remain static.
However, each segment now has a short, fixed, and pre-determined duration $d_"step"$.
Each active speech source in the room will progressively deliver the speech sentences from the corpus in chunks of approximately $d_"step"$ seconds.
Once a sentence has been exhausted, the source automatically loads a new one and starts yielding it.

*Bootstrapping reverberation.*
Although the simulator exposes this abstracted pseudo-continuous interaction framework, the actual audio propagation is still performed independently from each other at each step.
Consequently, as presented in @sec:simulator:reverb:background:reverb, the early moments of the received audio correspond to the direct path the source signal uses, and the reverberation's effect remains invisible.
When considering short steps, where $d_"step"$ might be even lower than $T_60$, naively extracting and returning the first $d_"step"$ seconds of the simulation would completely reduce the consequences of reverberation.
As such, each source loads longer audio chunks of $d_"input" = tau + d_"step"$ seconds leading to simulated received signals of $#d-rec = tau + d_"step" + T_60$.
The reverberation time $T_60$ is a sane default value for $tau$.
Finally, the simulator trims the first $tau$ and last $T_60$ seconds from the simulated signal to return the requested $d_"step"$.
The overall process is depicted in @fig:simulator:simultor:continuous_sim.

#figure(
  image("figures/continuous_simulation.svg"),
  caption: [
    Continuous simulation process
  ]
) <fig:simulator:simultor:continuous_sim>

Ultimately, the simulator can model dynamic interaction scenarios leveraging a static #acr("RIR") simulation library.
Thanks to our bootstrapping technique for reverberation, one may employ short simulation steps between which all objects in the room can be moved freely.
#acr("RL") environments represent discrete-time phenomenons with #acrpl("MDP") and figure as possible use cases for this framework.


//#reset-acronym("ASR")
//==== #acr("ASR") integration
//
//// Introduction
//#acr("ASR"),
//
//===== State of the Art
//
//===== #acr("ASR") pipeline in the simulator
//
//===== #acr("WER") maps
//
//// TODO: insert figures