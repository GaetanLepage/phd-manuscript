#import "/utils.typ": *

=== Overview
<sec:simulator:simulator:overview>

The acoustic simulator is composed of several blocks that interact with each other.
@fig:simulator:simulator:overview offers a global overview of the pipeline architecture.

#let room = text(fill: rgb("23445D"))[_room_]
#let rir-lib = text(fill: rgb("D6B656"))[_#acr("RIR") simulation library_]
#let simulator = text(fill: rgb("6C8EBF"))[_simulator_]
#figure(
  image(
    "figures/simulator_architecture.svg",
  ),
  caption: flex-caption(
    short: [
      Overview of the simulator architecture.
    ],
    long: [
      Overview of the simulator architecture.
      The principal elements involved in the simulator are depicted.
      The #room wraps the #rir-lib and renders the acoustic signals.
      The #simulator provides an additional abstraction and operates the sources and microphones movements across time.
    ]
  )
) <fig:simulator:simulator:overview>

The core of the platform resides in the #rir-lib.
The latter performs the actual computation of the several required #acr("RIR")s.
However, those libraries work at a low level and only account for a given static scene involving different unrelated microphones and sources.
Also, not all options handle acoustic signals.
Some only provide the #acr("RIR")s.

Thus, the #room component offers a higher abstraction for the static acoustic simulation.
Its main feature is to leverage the #rir-lib to compute the listened signal of each microphone.

Finally, the #simulator adds multiple features relating to dynamic scenarios.
Also, it operates more advanced audio objects such as multi-microphone arrays and sound sources of different kinds.
This block provides our pipeline with the most important external #acr("API").
It allows for defining a room, an agent (i.e. microphone array) and a set of sound sources with a very limited amount of code.
The user can then move the different audio objects with convenient movement primitives and fetch the resulting audio and geometric data in diverse forms.

@code:simulator:simulator:basic_usage demonstrates a basic example of how our library can be operated.
The following section will present the software blocks required to run this type of operation.

#figure(
  ```python
  from rl_audio_nav.audio_simulator import GpuRirRoom, SquareArray, AudioSimilator
  
  # Initialization
  room = GpuRirRoom(size_x=4, size_y=7, rt_60=0.3)
  mic_array = SquareArray(
    position=np.array([3.0, 3.0, 1.0]),
    orientation=np.array([-1.0, 1.0, 0.0]),
  )
  audio_simulator = AudioSimulator(room, mic_array, n_speech_sources=3)

  # Load speech signals and perform simulation
  audio_simulator.step()
  
  # (4, F, T) complex tensor
  stft = audio_simulator.get_agent_stft()
  
  # Compute the DoA with respect to the "speech_1" source
  doa_source_1 = audio_simulator.get_doa("speech_1")
  ```,
  caption: [
    Example of basic usage of the simulator.
  ]
)
<code:simulator:simulator:basic_usage>
