#import "/utils.typ": *

=== Components
<sec:simulator:simulator:components>

In this part, each component briefly introduced in @sec:simulator:simulator:overview will be detailed and motivated.
This offers a more in-depth description of the pipeline's inner workings.


==== Low Level Static Simulation
<sec:simulator:simulator:components:low_level>

First, the acoustic simulation aspect of the library will be explored.
This constitutes the starting point of the library and is responsible for its central feature: computing listened signals in a reverberant environment.

*#acr("RIR") Simulation*

The core component around which the simulation pipeline revolves is the #acr("RIR") simulation library.
We have chosen the #acr("RIR") framework for its simplicity and prevalence in the scientific literature.
@sec:simulator:reverb:methods introduced this approach's main concepts and fundamental aspects.

@fig:simulator:simulator:audio_pipeline illustrates how the audio processing occurs within the pipeline.
The different steps of this procedure will be detailed in the following sections.
The role of the #acr("RIR") simulation library consists in inferring, given the localization and properties of a set of sound sources and receivers (microphones), the pairwise #acr("RIR")s.


#figure(
  image("figures/audio_pipeline.svg"),
  caption:  [
    Schematic view of the audio processing pipeline.
  ],
)
<fig:simulator:simulator:audio_pipeline>


*Choice of the back-end library.*
Developing such a library was out of the scope of this work.
Members of the acoustic simulation community have conducted several notable efforts.
Multiple existing libraries have been enumerated in @sec:simulator:background:rir_libraries.
Motivated by a seamless operation within our Python code base, we have focused on the libraries providing bindings for this language.
Two libraries appeared mature and able to satisfy the requirements of the pipeline.
_Pyroomacoustics_ @scheibler_pyroomacoustics_2018 implements the #acr("ISM") and adds numerous advanced features (see @sec:simulator:background:rir_libraries for more details).
Its design has inspired the architecture of our pipeline, most specifically its own `Room` object.
_Pyroomacoustics_ is the original back-end library that we have been using for sound propagation simulation.
As we envisioned more intensive workloads where processing time could limit the simulator's usability, the recent _gpuRIR_ implementation by Diaz-Guerra et al. @diaz-guerra_gpurir_2021 has been integrated.
As seen in @sec:simulator:background:rir_libraries, the authors of this library have focused on achieving the best performance in #acr("RIR") estimation.
Our solution offers its users the choice between those two libraries for the backbone of the simulation.
Allowing this flexibility has required designing the `Room` module in an abstract manner.
This would allow for using other #acr("RIR") simulators while keeping the rest of the pipeline working accordingly.

To operate those libraries, the positions, patterns and orientations (when appropriate) of each source and microphone are provided.
Also, the room's dimensions and acoustic properties belong to the necessary parameters.
Both libraries offer a way to compute the wall's reflection coefficients from a target $T_60$ value by leveraging the inverse-Sabine estimator for the reverberation time (see @eq:simulator:background:sabine_inv).
The image source order in the $i$-th axis $N_i$ counts the number of virtual rooms that must be considered in this direction.
Those reflected rooms, stacked up, form a diamond with the real room in its center.
One way to approximate $N_i$ is to measure the distance that sound can travel in $T_60$ seconds:
$
  N_i = ceil(
    (2 T_60 times c)
    / L_i
  ),
$ <eq:simulator:simulator:components:rir_library:ism_order>
where $L_i$ is the room's length in the $i$-th direction.
All reflections happening closer than $T_60 times c$ meters
_GpuRIR_ computes three distinct number of images, according to @eq:simulator:simulator:components:rir_library:ism_order.

On the other hand, _Pyroomacoustics_ settles for a single maximum order $N_max$:
$
  N_"max" = ceil(
    (T_60 times c)
    / 
    (R_"min")
    - 1
  ),
$
where
$
  R_"min" =
    min_(i, j in [|1, 3|]\ i != j)
    
    (L_i times L_j)
    /
    sqrt(L_i^2 + L_j^2)
$
is the radius of the largest sphere fitting in the diamond of virtual rooms.
The higher the image source order, the more detailed the simulation will be.

Finally, a sampling frequency must be  provided.
This parameter affects the computed #acr("RIR") 's time resolution and, thus, its ability to capture high-frequency phenomena.
A higher sampling frequency will increase the computational cost of the simulation.
In most cases, using the same frequency as that of the audio signals involved is a safe and practical choice.


*Room, Static Acoustic Simulation*

The _Room_ module is a wrapper around the #acr("RIR") simulation library.
It brings some additional features, among which is the computation of listened signals.
Although originally inspired from _Pyroomacoustics_ @scheibler_pyroomacoustics_2018, our _Room_ module has been grown for improved interoperability with the rest of our pipeline.

We consider a _shoebox_ room defined by its dimensions ($L_x$, $L_y$ and $L_z$) as well as the desired reflection time $T_60$ and sampling frequency $f_s$.
Individual point-wise sources and microphones can then be positioned in the 3D space.
Each change in the audio objects' localization leads to a new simulation that updates the ($n_m times n_s times L_"RIR"$) #acr("RIR") tensor.
Our implementation ensures the caching of the #acr("RIR") and solely re-computes it when necessary.
As stated in the previous @sec:simulator:simulator:components:low_level, the Room can use both the _Pyroomacoustics_ and _gpuRIR_ back ends interchangeably.

To actually compute the signal received at each microphone, the input signal from all active sources is gathered.
Then, the listened signals are estimated by convolving the sources' signals with the corresponding #acr("RIR") vector as described in @eq:simulator:rir_listened_signal_multi_source_multi_mic.

Additionally, the _Room_ module provides a convenient interface for dynamically adding and positioning both sources and microphones.
It ensures the validity of all locations at any time.
The different audio objects have the ability to be pinned to a grid of arbitrary resolution.
Such a feature permits, for instance, the ability to effortlessly compute the listened signal at all possible positions in the room.
Contrarily, one could fix the microphone position and collect the received audio for evenly distributed source localizations.

Lastly, a plotting helper has been implemented to handily visualize the state of the room and its content.

==== Ergonomic Simulation of Complex Scenarios
<sec:simulator:simulator:components:sim_scenarios>

Although our _room_ abstraction extends the capabilities of the core #acr("RIR") simulation library, it still lacks abstraction power to allow for conveniently experimenting complex dynamic scenarios.
Providing this user experience required introducing more powerful objects.

*Sound Sources*

The core motivation for developing this acoustic pipeline was experimenting with #acr("HRI") scenarios.
In this sense, the most important type of sound source to consider was speech sources, mimicking humans speaking in the room.
However, other kinds of sources have also been implemented, such as music sources or white noise sources.

All sources have a position in the room, a polar pattern (see @fig:ssl:single_source:polar_patterns) that affect their directivity and most importantly the ability to generate an audio signal.
This latter property differs across source types.

For white noise sources, the waveform is randomly generated from a standard normal distribution.
To adjust the gain relevantly, some speech signal as well as a target #acr("SNR") value can be provided.
This allowed for conducting experiments in the presence of adversarial noise sources and controlling precisely the #acr("SNR") parameter.

Speech sources pull their signal from the _LibriSpeech_ @panayotov_librispeech_2015 dataset.
The latter is an #acr("ASR") corpus of 1000 hours worth of audiobooks, sampled at 16 kHz.
Each time a speech source is required to produce a signal, a random sample is pulled from _LibriSpeech_ and outputted.


*Microphone Arrays*

// Support for various arrays
Microphone arrays provide a convenient abstraction to use pre-defined multiple microphone arrays in the environment as well as defining custom ones.

They offer an upgrade from the limited `Room` #acr("API"), which only considers individual microphones independently.
Each array variation defines its geometry and the properties of each of its microphones.
Grouping microphones as such makes the process of experimenting with different array configurations fast and convenient for the user.
The simulator can access the array's position, orientation and footprint, but more importantly can move it as a single entity, without the need for considering each of its microphones.
The array maintains its own geometrical consistency when being translated or rotated.

@fig:simulator:simulator:mic_arrays illustrates some currently included arrays.
They all offer a degree of configurability.
The pattern of the microphones can be adjusted, especially.
Also, the relative distances and orientations of the microphones are alterable.

#include "figures/mic_arrays/fig.typ"

The arrows depict each microphone's orientation.
The position of the array, although virtual, is represented by a diamond ($colMath(diamond.filled, #rgb(128, 0, 128))$).
Naturally, a single-microphone array is also provided.

A user of this library could easily implement a microphone array of their own and benefit from all the simulator's features.


*The Simulator Interface*

The simulator constitutes the centerpiece of the interactive pipeline.
It serves as an engine coordinating all the components mentioned above.

At a high level, it serves as an orchestrator of the overall simulation process.
The simulator manages both the microphone agent, also referred to as the _agent_, and the various sound sources (speech and non-speech).

Although the room, representing the spatial and acoustic properties of the environment, and the microphone array have to be provided to the simulator at initialization, the latter can take care of creating the different sound sources.
Once configured, the simulator may be interacted with.
This process takes place in discrete time steps that each resemble the following execution:
- The audio objects (agent and sources) might first be relocated.
- The acoustic simulation is then performed by the `Room` module, itself using the #acr("RIR") simulation library.
  The simulator ensures to propagate the positions and orientations of all elements as well as setting the right input signal of each source.
- Finally, acoustic features can be collected in multiple representations: raw multi-channel waveforms, #acr("STFT") or #acr("ILD")/#acr("IPD").
  The user may also access spatial data in convenient formats: distance from the microphone to a specific source, #doa, absolute position and orientation of the agent and sources, etc.

*Spatial domain.*
The sound propagation libraries used in the simulation model three-dimensional scenes.
Thus, we have built the rest of the pipeline to allow for full control of audio objects in the 3D space.
Besides, as this thesis's downstream tasks predominantly involved planar problems, most implemented features focus on 2D movements and spatial measures.
No artificial limitation prevents the use of our library for 3D problems.

*Sources and Microphones Movement*

Audio objects are of two kinds: sound sources and microphone arrays.
Sound sources are modeled by a point in space with an orientation.
Thus, a position and direction vector suffice to localize a source unambiguously.
Microphone arrays are constituted of possibly several microphones.
To ease their manipulation, the array provides an abstraction allowing the definition of a single position and orientation for the whole array.
Also, the array object itself can be _moved_ by the simulator while internally ensuring consistency between its microphone positions.

To allow for modeling flexible interactive scenarios, the simulator provides a set of various movement primitives.
The positions of all objects might be randomized to start from an arbitrary setup.
Everything is placed so that all sources and microphones are within the borders of the room.

Apart from the random positioning of objects, the interface permits the agent to perform relative motions.
Basic movements, such as moving forward by a given distance or rotating left or right by 90°, are relevant in the context of #acr("RL") environments with a discrete action space.
Besides, the ```python move_agent_polar(angle, distance)``` method gives more control to perform relative movements.
Finally, the user can place the microphone array and the sources at any arbitrary position.

An additional benefit of operating motions through the simulator is that it guarantees the correctness of positions at all times.
If an arrival position lies at the room's exterior, an exception is raised, and the movement is not performed.

In conclusion, the simulator furnishes a convenient and safe interface for moving both the microphone arrays and the sound sources in the room.
This facilitates the flexible implementation of numerous acoustic #acr("HRI") use cases.


*Simulation Process*
//====== Simulation process
//<sec:simulator:simulator:components:sim_process>

Most downstream tasks leveraging the simulator involved some iteration through a discrete time step simulation.
More precisely, the typical workflow when using the simulator includes an initialization phase, during which the _Room_, microphone array, and _AudioSimulator_ are created.
@code:simulator:simulator:basic_usage gives an overview of the corresponding code snippet.

Once the different components have been set up, the actual simulation process may occur.
The procedure involves positioning all audio objects in the room.
This can be done directly by the simulator in a random fashion.
Subsequently, each source is individually asked to provide a new sound sample (see @sec:simulator:simulator:components:sim_scenarios).
The actual sound propagation simulation can then happen and the embedded _Room_ module returns the multi-channel audio signal received.
Either the raw waveform or further processed time-frequency features can be produced.
The user can also listen to the produced signal directly.
In practice, those steps are abstracted and automated by the `step()` method.
Lastly, the agent might be moved using the exposed displacement helpers presented in @sec:simulator:simulator:components:sim_scenarios.
@fig:simulator:simulator:simulator_workflow illustrates this routine.

#figure(
  image(
    "figures/simulator_workflow.svg",
    //height: 40%,
  ),
  caption: flex-caption(
    short: [
      Typical simulator execution workflow.
    ],
    long: [
      This figure illustrates the typical simulator execution flow.
      After an initialization phase, the simulator proceeds in discrete steps, during which microphones and sources may move.
    ],
  ),
)
<fig:simulator:simulator:simulator_workflow>

*Duration control.*
By default, given $n_s$ input signals of durations $(d_s^1, dots, d_s^(n_s))$, the received signal at each microphone will last
#let d-rec = $d_"rec"$
$
  #d-rec = ( max_(i=1 dots n_s) d_s^i ) + T_60
$
seconds.
After #d-rec seconds, the energy of the received signal becomes negligible.
In practice, the simulator allows for artificially reducing the time of the simulation.
This may happen by first shortening the input signals to a given duration $d_s^"lim"$, thus leading to having $#d-rec = d_s^"lim" + T_60$.
Alternatively, the resulting audio can be trimmed to any desired duration.
The duration control feature gives a fine-grained control of the computational time.


*Feature Extraction*

Observing the simulator's state represents an essential feature set of our library.
Potential downstream usages may require different kinds of monitoring.

*Spatial information.*
First, because the user does not always dictate the absolute position of each element, gathering information about the current layout can be useful.
Manifestly, the raw positions of both the agent and the sources are conveniently accessible.
Also, relative data such as the #doa or the distance from the agent to a given source can be extracted.
This egocentric information can be used in multiple situations, such as training an #acr("RL") agent or collecting a #acr("SSL") dataset.

*Audio data.*
Recording acoustic information is the main purpose of the simulator.
Following the same principles of flexibility and convenience, audio data has been made accessible in various formats at different stages of the simulation.
@fig:simulator:simulator:audio_pipeline outlines those steps visually.
First and foremost, each source exposes its current raw signal.
This is how the simulator fetches the audio signals from the different sources before forwarding them to the #acr("RIR") simulation library.
Once the simulation has been conducted, both the #acr("RIR")s and the audio signal received at each microphone become accessible.
In addition to the raw multi-channel listened audio provided by the `Room` module, the simulator proposes further audio processing tools.
Thus, the received acoustic data's #acr("STFT") can be computed and recovered for direct use in a neural network or any method operating in the time-frequency plane.
Finally, another function has been added to calculate the signal's #acr("ILD") and #acr("IPD") given a pair of microphones.

All those features partly remove the downstream user's post-processing burden, allowing for the most direct and practical usage possible.

*Visualization*

For development purposes, it may come in handy to graphically render the simulator's state.
The pipeline includes a basic yet efficient way of visualizing the different objects in the room.
Each available microphone array can be shown in the room, according to its geometry.
The orientation of microphones and directional sources is also displayed.

@fig:simulator:simulator:components:simulator_plot provides a demonstration of the renderer.

#figure(
  image("figures/simulator_plot.svg", height: 20em),
  caption: [
    Screenshot of the simulator renderer.
  ],
)
<fig:simulator:simulator:components:simulator_plot>