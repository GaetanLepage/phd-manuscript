#import "/utils.typ": *

== Method
<sec:rl:method>

=== Acoustic pipeline

The abstract environment defined previously in @sec:rl:problem:formulation:environment is implemented in practice thanks to our simulator @sec:simulator:simulator.

#draft[
  - Audio simulator (in continuous mode ?)
  - It implements the transition dynamics (geometrically, room)
  and the observability function (sources/simulator)
]

=== #acr("WER") maps as a reward
<sec:rl:method:wer_maps>

The reward signal introduced previously expects an oracle $w$ to provide an estimate of the #acr("WER") score for each possible state.
This is achieved by pre-computing an average #acr("WER") for every position on the grid.
Although the array might include several microphones, only one of them is used to provide the mono-channel signal required by the #acr("ASR") system.

Several #acr("ASR") frameworks have been made available by industrial and academic actors.
Kaldi @povey_kaldi_nodate stands as one of the most complete and established open-source projects for speech recognition.
The C++ code base includes an important variety of algorithms and helpers to process speech and perform speech-related tasks.
It includes feature extraction mechanisms, decoding algorithms, seq2ds #todo
PyKaldi @can_pykaldi_2018 offers a Python wrapper to interact with the Kaldi library easily.

Vosk @noauthor_vosk_nodate is 

Speechbrain @ravanelli_speechbrain_2021 is a more recent library, written around the widely used PyTorch @Ansel_PyTorch_2_Faster_2024 #acr("DL") framework.
It grants convenient implementations and weights of state of the art

#draft[
  - Present how we implement the WER oracle $w$
  - Motivation: Computation challenges: pre-compute maps instead of live computation
  
  - Also, WER does not make sense for a single position
  
  - Explain the different reward schemes
  
  - Motivation: use #acr("ASR") as objective
]


=== Deep Neural Agent

The multiple recent successes of #acr("DRL") in solving various tasks (Atari games @mnih_playing_2013, controlling plasma in fusion reactors @degrave_magnetic_2022, 

// TODO: add figure

==== Neural network architecture

==== Pre-trained acoustic feature extractor
