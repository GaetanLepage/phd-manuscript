#import "/utils.typ": *

#pagebreak()  // TODO: remove
=== Components <sec:simulator:simulator:features>

In this part, each component briefly introduced in @sec:simulator:simulator:overview will be detailed and motivated.
This offers a more in-depth description of the pipeline's inner workings.


==== Low level static simulation

In a first time, the acoustic simulation aspect of the library will be explored.
This constitutes the starting point of the library and is responsible for its central feature: computing listened signals in a reverberant environment.

===== #acr("RIR") simulation

The core component around which the simulation pipeline revolves is the #acr("RIR") simulation library.
We have chosen the framework of #acr("RIR") filters for its simplicity and prevalence in the scientific literature.
@sec:simulator:background introduced the main concepts and fundamental aspects of this approach.

@fig:simulator:simulator:audio_pipeline illustrates how the audio processing takes place within the pipeline.
The different steps of this procedure will be detailed in the following sections.
The role of the #acr("RIR") simulation library consists in inferring, given the localization and properties of a set of sound sources and receivers (microphones), the pairwise #acr("RIR") filters.


#figure(
  image("figures/audio_pipeline.svg"),
  caption: [
    Audio processing pipeline
  ]
) <fig:simulator:simulator:audio_pipeline>


*Choice of the back end library.*
Developing such a library was out of the scope of this work.
Several efforts have been conducted by members of the acoustic simulation community.
Multiple existing libraries have been enumerated in @sec:simulator:background:rir_libraries.
Motivated by a seamless operation within our Python code base, we have focused on the libraries providing bindings for this language.
Two libraries appeared mature and able to satisfy the requirements of the pipeline.
_Pyroomacoustics_ @scheibler_pyroomacoustics_2018 implements the #acr("ISM") and adds numerous advanced features (see @sec:simulator:background:rir_libraries:pyroomacoustics for more details).
Its design has been the inspiration for our pipeline's architecture and most specifically its own `Room` object.
_Pyroomacoustics_ is the original back end library that we have been using for sound propagation simulation.
As we envisioned more intensive workloads where processing time could limit the usability of the simulator, the recent _gpuRIR_ implementation by Diaz-Guerra et al. @diaz-guerra_gpurir_2021 has been integrated.
As seen in @sec:simulator:background:rir_libraries:gpurir, the authors of this library have focused on achieving the best performance in #acr("RIR") estimation.
Our solution offers its users to choose between those two libraries for the backbone of the simulation.
Allowing this flexibility has required to architect the `Room` module in an abstract manner.
This would allow for using other #acr("RIR") simulators while keeping the rest of the pipeline working accordingly.

To operate those libraries, the positions, patterns and orientations (when appropriate) of each source and microphone are provided.
Also, the room's dimensions and acoustic properties belong to the necessary parameters.
Both libraries offer a way to compute the wall's reflection coefficients from a target $T_60$ value by leveraging the inverse-Sabine estimator for the reverberation time (see .


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

@scheibler_pyroomacoustics_2018 (we took inspiration for the audio simulation part)

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

The simulator constitutes the center piece of the interactive pipeline.
It serves as en engine coordinating all the components mentioned above.

At a high level, it serves as an orchestrator of the overall simulation process.
Both the microphone agent, also referred as the _agent_, and the various sound sources (speech and non-speech) get managed by the simulator.

Although the room, representing the spatial and acoustic properties of the environment, and the microphone array have to be provided to the simulator at initialization, the latter can take care of creating the different sound sources.
Once configured, the simulator may be interacted with.
This process takes place in discrete time steps that each resemble the following execution:
- The audio objects (agent and sources) might first be relocated
- The acoustic simulation is then performed by the `Room` module, itself using the #acr("RIR") simulation library.
  The simulator ensures to propagate the positions and orientations of all elements as well as setting the right input signal of each source.
- Finally, acoustic features can be collected in multiple representations: raw multi-channel waveforms, #acr("STFT") or #acr("ILD")/#acr("IPD").
  The user may also access spatial data in convenient formats: distance from the microphone to a specific source, #acr("DoA"), absolute position and orientation of the agent and sources, etc.

*Spatial domain.*
The sound propagation libraries used for simulation model a three-dimensional scene.
Thus we have built the rest of the pipeline to allow for full control of audio objects in the 3D space.
Besides, as the conducted downstream task involved mostly planar problems, most implemented features focus on 2D movements and spatial measures.
No artificial limitation prevent the use of our library for 3D problems.

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
#draft[TODO]

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
@fig:simulator:simulator:audio_pipeline outlines those steps visually.
First and foremost, each source exposes its current raw signal.
This is how the simulator fetches the audio from the different sources before forwarding them to the #acr("RIR") simulation library.
Once the simulation has been conducted, both the #acr("RIR") filters and the audio signal received at each microphone become accessible.
Additionally to the raw multi-channel listened audio provided by the `Room` module, the simulator proposes further audio processing tools.
The #acr("STFT") of the received acoustic data can thus be computed and recovered for direct use in a Neural Network or any method operating in the time-frequency plane.
Finally, another function has been added to calculate the #acr("ILD") and #acr("IPD") of the signal given a pair of microphones.

All those features partly removes the post-processing burden of the downstream user, allowing for the most direct and practical usage possible.


====== Visualization