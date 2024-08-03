#import "/utils.typ": *

=== Components <sec:simulator:simulator:features>

In this part, each component briefly introduced in @sec:simulator:simulator:overview will be detailed and motivated.
This offers a more in-depth description of the pipeline's inner workings.

==== Low level static simulation

===== #acr("RIR") simulation

// Two backends:
// - GPU RIR
// - PyroomAcoustics

// We can set the frequency and the T60

===== Room, static acoustic simulation

- Audio simulation
- RIR caching
- Individual object movement
- plotting
- Check for validity of the positions 
- Grid (for #acr("ASR"))


==== Ergonomic simulation of complex scenarios

Although our _room_ abstraction extends the capabilities of the core #acr("RIR") simulation library, it still lacks abstraction power to allow for conveniently experimenting complex dynamic scenarios.
Providing this user experience required introducing more powerful objects.

===== Sound sources

The core motivation for developing this acoustic pipeline was to experiment with #acr("HRI") scenarios.
In this sense, the most important type of sound sources to consider was speech sources, mimicking humans speaking in the room.
However, other kinds of sources have also been implemented, such as music sources or white noise sources.

All sources have a position in the room, a polar pattern (see @fig:ssl:single_source:polar_patterns) that affect their directivity and most importantly the ability to generate an audio signal.
This latter property is what differs accross source types.

For white noise sources, the waveform is randomly generated from a standard normal distribution.
To adjust the gain relevantly, some speech signal as well as a target #acr("SNR") value can be provided.
This allowed for conducting experiments in the presence of adversarial noise sources and controlling precisely the #acr("SNR") parameter.

Speech sources pull their signal from the _LibriSpeech_ @noauthor_librispeech_nodate dataset.
The latter is an #acr("ASR") corpus of 1000 hours worth of audiobooks, sampled at 16kHz.
Each time a speech source is required to produce a signal, a random sample is pulled from _LibriSpeech_ and outputed.


===== Microphone arrays

// Support for various arrays
Microphone arrays provide a convenient abstraction to use pre-defined multiple microphone arrays in the environment as well as defining custom ones.

They offer an upgrade from the limited `Room` #acr("API") which only consider individual microphones independantly.
Each array variation defines its geometry and the properties of each of its microphone.
Grouping microphones as such #draft[TODO]

===== The simulator interface

#draft[
  - step
  - move stuff around
  - listen to signals
]

====== Audio objects movement

====== Feature extraction

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


