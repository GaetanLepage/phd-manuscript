#import "/utils.typ": *
#import "/_misc/notations.typ": *

== Method
<sec:rl:method>

=== Acoustic pipeline

The abstract environment defined previously in @sec:rl:problem:formulation:environment is implemented in practice thanks to our simulator @sec:simulator:simulator.

#draft[
  - Audio simulator (in continuous mode ?)
  - It implements the transition dynamics (geometrically, room)
  and the observability function (sources/simulator)
]

=== #acr("WER") as a reward signal
<sec:rl:method:wer_maps>

#draft[
  - Present how we implement the WER oracle $w$
  - Motivation: Computation challenges: pre-compute maps instead of live computation
  
  - Also, WER does not make sense for a single position ?
  
  - Explain the different reward schemes
  
  - Motivation: use #acr("ASR") as objective
]


The reward signal introduced previously expects an oracle $w$ to provide an estimate of the #acr("WER") score for each possible state.
This is achieved by pre-computing an average #acr("WER") for every position on the grid.
Although the array might include several microphones, only one of them is used to provide the mono-channel signal required by the #acr("ASR") system.

==== #acr("ASR") frameworks

Several #acr("ASR") frameworks have been made available by industrial and academic actors.
Kaldi @povey_kaldi_nodate is one of the most complete and established open-source projects for speech recognition.
The C++ code base includes various algorithms and helpers to process speech and perform speech-related tasks.
It includes feature extraction mechanisms, decoding algorithms, seq2ds #todo
PyKaldi @can_pykaldi_2018 offers a Python wrapper that allows users to interact with the Kaldi library easily.

Vosk @noauthor_vosk_nodate is another open-source, popular speech recognition toolkit.
It aims to be a user-friendly product, employed in real-world use cases.
Bindings for several programming languages (Rust, Java, Go...).
Besides its open-source programs, professional licenses for Vosk can be purchased and provide additional features.

#let speechbrain = text[_SpeechBrain_]
#speechbrain @ravanelli_speechbrain_2021 is a more recent library based on the widely used PyTorch @Ansel_PyTorch_2_Faster_2024 #acr("DL") framework.
It grants convenient implementations of novel deep neural networks for speech recognition.
Its objective is to grant research and industrial actors an all-in-one speech toolkit.
It has been used as a building block in various research works #draft[insert examples].

Our final implementation uses the #speechbrain library, which has allowed us to choose from a substantial pool of state-of-the-art pre-trained models.
The specific pipeline that was used in this work involves three components:
//https://huggingface.co/speechbrain/asr-crdnn-rnnlm-librispeech
- The *tokenizer* that transforms each word into one or more tokens.
  This model has been trained on the #librispeech dataset @panayotov_librispeech_2015.
- The *neural language model* represents the dynamics of language.
  Here, we have chosen a #acr("RNNLM") @mikolov_recurrent_2010 provided by the #speechbrain library.
  This architecture applies the successful #acr("RNN") architecture to language modeling.
  In this case, the recurrent units act on word sequences
  It comprises an embedding layer that maps individual words to 128-dimensional vectors.
  Those vectors are then fed to the #acr("RNN"), which is followed by fully connected layers.
- Finally, the *acoustic model* performs the actual task of speech recognition.
  It employs a #acr("CRDNN") architecture for the encoder, which maps audio features (#acr("STFT"), #acr("MFCC")...) to tokens.
  #speechbrain applies an additional #acr("CTC") @graves_towards_2014 loss to the encoder.
  The #acr("CTC") cost function allows the training of recurrent architectures to perform speech recognition without requiring prior alignment between the input and target sequences.

We have integrated the #speechbrain #acr("ASR") library into the simulator.
The input signals used for each source are drawn from the #librispeech @panayotov_librispeech_2015 (@sec:simulator:simulator:components:sound_sources).
The simulator loads the ground truth transcripts along with the clean signal.
Thus, our #acr("ASR") module can be fed with the listened signal computed by the simulator, and the obtained transcription can then be compared with the ground-truth one.


==== Computing of #acr("WER")-maps
<sec:rl:method:wer_maps:computing>

*Motivation.*
We compute the #acr("WER") score using the _jiwer_ @vaessen_jitsijiwer_2024 library.
It itself wraps the fast C++ matching library _RapidFuzz_ @max_bachmann_2024_10938887 to compute the minimum-edit distance.
The calculation of the metric has no significant impact on performance.
However, running the #speechbrain #acr("ASR") model is highly computationally expensive.
When the model is run in inference mode to evaluate its performance on 100 samples from the #librispeech dataset, 96% of the time is spent on the speech recognition process.
On the contrary, less than 1% is spent computing the #acr("WER") score.
We perform this test on a RTX A6000 Nvidia GPU that gets fully utilized by this decoding task.
The _RapidFuzz_ library runs directly on the CPU.

Importantly, the decoding process remains slow as it takes approximately 2s to process 


==== WER on clean speech

As a sanity check for the #acr("ASR") module, we run the complete recognition pipeline on the clean speech signals from the #librispeech dataset.
The `ASR-CRDNN-RNNLM-LibriSpeech` model from #speechbrain that we have chosen yields an average #acr("WER") of #todo%.

==== Reward shaping

#draft[
 - Could go in the results section. (Not a lot of methodology)
 - References on reward shaping. Again, the impact can be quantified and discussed further.
]

$
  r_t = 10 e^(-w(s_t))
$


=== Deep Neural Agent

The multiple recent successes of #acr("DRL") in solving various tasks (Atari games @mnih_playing_2013, controlling plasma in fusion reactors @degrave_magnetic_2022, 

// TODO: add figure

==== Neural network architecture

#draft[
  - Backbone + 2 heads
  - talk about different strats for BB (fine-tuning, no pre-training, frozen)
]

==== Pre-trained acoustic feature extractor

#draft[
  - motivation
  - Link with the SSL work
  - Supervised pipeline
]

The main difficulty of the sound-driven navigation problem lies in the agent's ability to map sound cues to spatial information.
The partial observability aspect of the environment prevents the agent from directly and transparently observing neither its own nor the sources' positions.