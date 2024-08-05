#import "/utils.typ": *

#pagebreak()  // TODO: remove
=== Components <sec:simulator:simulator:features>

In this part, each component briefly introduced in @sec:simulator:simulator:overview will be detailed and motivated.
This offers a more in-depth description of the pipeline's inner workings.


==== Low level static simulation

===== #acr("RIR") simulation

@fig:simulator:simulator:audio_pipeline illustrates how the audio processing takes place within the pipeline.

#figure(
  image("figures/audio_pipeline.svg"),
  caption: [
    Audio processing pipeline
  ]
) <fig:simulator:simulator:audio_pipeline>

// Two backends:
// - GPU RIR
// - PyroomAcoustics

// We can set the frequency and the T60

===== Room, static acoustic simulation

#draft[
  - Audio simulation
  - RIR caching
  - Individual object movement
  - plotting
  - Check for validity of the positions 
  - Grid (for #acr("ASR"))
]

@eq:simulator:rir_listened_signal


==== Ergonomic simulation of complex scenarios

Although our _room_ abstraction extends the capabilities of the core #acr("RIR") simulation library, it still lacks abstraction power to allow for conveniently experimenting complex dynamic scenarios.
Providing this user experience required introducing more powerful objects.

===== Sound sources

The core motivation for developing this acoustic pipeline was to experiment with #acr("HRI") scenarios.
In this sense, the most important type of sound sources to consider was speech sources, mimicking humans speaking in the room.
However, other kinds of sources have also been implemented, such as music sources or white noise sources.

All sources have a position in the room, a polar pattern (see @fig:ssl:single_source:polar_patterns) that affect their directivity and most importantly the ability to generate an audio signal.
This latter property is what differs across source types.

For white noise sources, the waveform is randomly generated from a standard normal distribution.
To adjust the gain relevantly, some speech signal as well as a target #acr("SNR") value can be provided.
This allowed for conducting experiments in the presence of adversarial noise sources and controlling precisely the #acr("SNR") parameter.

Speech sources pull their signal from the _LibriSpeech_ @noauthor_librispeech_nodate dataset.
The latter is an #acr("ASR") corpus of 1000 hours worth of audiobooks, sampled at 16kHz.
Each time a speech source is required to produce a signal, a random sample is pulled from _LibriSpeech_ and outputted.


===== Microphone arrays <sec:simulator:simulator:components:mic_arrays>

// Support for various arrays
Microphone arrays provide a convenient abstraction to use pre-defined multiple microphone arrays in the environment as well as defining custom ones.

They offer an upgrade from the limited `Room` #acr("API") which only consider individual microphones independently.
Each array variation defines its geometry and the properties of each of its microphone.
Grouping microphones as such makes the process of experimenting different array configurations fast and convenient for the user.
The simulator can access the array's position, orientation and footprint, but more importantly can move it as a single entity, without the need for considering each of its microphones.
The array maintains its own geometrical consistency when being translated or rotated.

@fig:simulator:simulator:mic_arrays illustrates some of the currently included arrays.
They all offer a degree of configurability.
Especially, the pattern of the microphones can be adjusted.
Also, the relative microphones distance and orientation are alterable.

#subpar.grid(
  figure(
    image("figures/mic_array_binaural.svg", width: 100%),
    caption: [
      Binaural array
    ]
  ),
  <fig:simulator:simulator:mic_arrays:binaural>,
  
  figure(
    image("figures/mic_array_triangle.svg", width: 100%),
    caption: [
      Triangle array
    ]
  ),
  <fig:simulator:simulator:mic_arrays:triangle>,
  
  figure(
    image("figures/mic_array_square.svg", width: 100%),
    //image("/assets/mountains.jpg"),
    caption: [
      Square array
    ]
  ),
  <fig:simulator:simulator:mic_arrays:square>,
  columns: 3,
  caption: [
    Examples of microphone arrays available in the simualator
  ],
  align: top,
  label: <fig:simulator:simulator:mic_arrays>,
)

The arrows depict each microphone's orientation.
The position of the array, although virtual, is represented by a diamond ($colMath(diamond.filled, #rgb(128, 0, 128))$).
Naturally, a single-microphone array is also provided.

A user of this library could easily implement a microphone array of its own and benefit from all the features of the simulator.


===== The simulator interface

#draft[Note on 2D-3D difference]

The simulator constitutes the center piece of the interactive pipeline.
It serves as en engine coordinating all the components mentioned above.

At a high level, it serves as an orchestrator of the overall simulation process.
Both the microphone agent, also referred as the _agent_, and the various sound sources (speech and non-speech) get managed by the simulator.

Although the room, representing the spatial and acoustic properties of the environment, and the microphone array have to be provided to the simulator at initialization, the latter can take care of creating the different sound sources.
Once configured, the simulator may be interacted with.
This process takes place in discrete time steps that each resemble the following execution:
- The audio objects (agent and sources) might first be relocated
- The acoustic simulation is then performed by the Room, itself using the #acr("RIR") simulation library.
  The simulator ensures to propagate the positions and orientations of all elements as well as setting the right input signal of each source.
- Finally, acoustic features can be collected in multiple representations: raw multi-channel waveforms, #acr("STFT") or #acr("ILD")/#acr("IPD").
  The user may also access spatial data in convenient formats: distance from the microphone to a specific source, #acr("DoA"), absolute position and orientation of the agent and sources, etc.

====== Audio objects movement

Audio objects are of two kinds: sound sources and microphone arrays.
Sound sources are modeled by a point in space, with an orientation.
Thus, a position and direction vector suffice to properly localize a source.
Microphone arrays are constituted of possibly several microphones.
To ease their manipulation, the array provides an abstraction allowing to define a single position and orientation for the whole array.
Also, the array object itself can be _moved_ by the simulator while internally ensuring the consistency between its microphone positions.

To allow for modelling flexible interactive scenarios, the simulator provides a set of various movement primitives.
The positions of all objects might be randomized to start from an arbitrary setup.
Everything is placed so that all sources and microphones are within the borders of the room.

Apart from random positioning of objects, the interface permits relative motions of the agent.
Basic movements such as moving forward by a given distance, rotating left or right by 90° find their relevance in the context of #acr("RL") environments with a discrete action space.
Besides, the ```python move_agent_polar(angle, distance)``` method gives more control to perform relative movements.
Finally, the user has the freedom to place both the microphone array and the sources at any arbitrary position.

An additional benefit of operating motions through the simulator is that it guarantees correctness of positions at all time.
If an arrival position lays at the exterior of the room, an exception is raised and the movement is not performed.

In conclusion, the simulator furnishes a convenient and safe interface for moving both the microphone arrays and the sound sources in the room.
This facilitates the flexible implementation of numerous acoustic #acr("HRI") use cases.


====== Simulation process

#draft[
  - The `step` function. We should maybe talk about how each source "steps" and yields a new signal
  - Duration management (we detail that in the "advanced features" section)
]

*Duration control.*

====== Feature extraction

Observing the state of the simulator represents an essential feature set of our library.
Potential downstream usages may require different kinds of monitoring.

*Spatial information.*
First, because the user does not always dictate the absolute position of each element, gathering information about the current layout can be useful.
Manifestly, the raw positions of both the agent and the sources are conveniently accessible.
Also, relative data such as the #acr("DoA") or the distance from the agent to a given source can be extracted.
This egocentric information can be used in multiple situations, such as training an #acr("RL") agent or collecting a #acr("SSL") dataset.

*Audio data.*
Recording acoustic information is the main purpose of the simulator.
Following the same principles of flexibility and convenience, audio data has been made accessible in various formats, at the different stages of the simulation.
First and foremost, each source exposes its current raw signal.
This is how the simulator fetches the audio from the different sources before forwarding them to the #acr("RIR") simulation library.
Once the simulation has been conducted, both the #acr("RIR") filters and the audio signal received at each microphone become accessible.
Additionally to the raw multi-channel listened audio provided by the `Room` module, the simulator proposes further audio processing tools.
The #acr("STFT") of the received acoustic data can thus be computed and 


- Geometric information
  - Absolute position of all elements
- Audio data
  - STFT: Talk about the STFT module
  - ILD/IPD: we introduce those only in chap.2, but maybe we could do it here.

Here is a basic examples
```python
# Initialization
room = GpuRirRoom(size_x=4, size_y=7, rt_60=0.3)
mic_array = SquareArray(
  position=np.array([3.0, 3.0, 1.0]),
  orientation=np.array([-1.0, 1.0, 0.0]),
)
audio_simulator = AudioSimulator(room, mic_array, n_speech_sources=3)

audio_simulator.step()

# (4, F, T) complex tensor
stft = audio_simulator.get_agent_stft()

# Compute the DoA with respect to the "speech_1" source
doa_source_1 = audio_simulator.get_doa("speech_1")
```

====== Visualization