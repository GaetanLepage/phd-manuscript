#import "/utils.typ": *
#import "/_misc/notations.typ": *
#import "../_variables.typ": *

== Method
<sec:rl:method>

=== Acoustic Pipeline

The abstract environment defined previously in @sec:rl:problem:formulation:environment is implemented in practice thanks to our simulator @sec:simulator:simulator.
More precisely, its capacity to operate in discrete time steps makes it particularly convenient for use in an #acr("RL") framework.
The specific implementation details of the dynamic features of the simulator have been described in @sec:simulator:simulator:dynamic_scenarios.
It allows us to place our microphone array and the target source at the beginning of each episode.
The #acr("RL") environment wraps the simulator's `step` function and moves the agent according to the action selected from the policy.
The simulator loads the next chunk of audio and sets it as the source's input.
The source clean speech recordings are sampled from the _LibriSpeech_ @panayotov_librispeech_2015 corpus.
When transitioning from one step to the next, the source keeps playing the same recording to improve realism.
After loading the source's input signal, the simulator refreshes the cached #acr("RIR")s if necessary, i.e., if the agent has moved, and computes the next chunk of recorded audio.
Finally, the resulting multi-channel signal is further processed into an interaural spectral representation.
Specifically, we use the #acr("IPD") and #acr("ILD") features.
The final environment is Gym-compliant.
OpenAI _Gym_ @brockman_openai_2016 was created to define the standard way of interacting with #acr("RL") environments.
_Gymnasium_ @towers_gymnasium_2024 by Towers et al. has since replaced it and was used in this project.
This precaution ensures compatibility with the rest of the #acr("RL") ecosystem and would allow other researchers to use the designed environment.
A three-microphone array is used to model the agent's sensors.
Each microphone has a cardioid pattern.


=== #acr("WER") as a Reward Signal
<sec:rl:method:wer_maps>
#minitoc(indent: true)

#draft[
  - Present how we implement the WER oracle $w$
  - Motivation: Computation challenges: pre-compute maps instead of live computation

  - Say that even though our environment is theoretically a POMDP, we have used a normal RL method and not accounted for the PO aspect of it.
]

This section presents the design and implementation details of the #acr("WER") cost function (#wer-cost).
The reward signal introduced previously expects an oracle to provide an estimate of the #acr("WER") score for each possible state.
This is achieved by pre-computing an average #acr("WER") for every position on the grid, and possibly every orientation of the agent.
The obtained #acr("WER") cost function is given by:
#let asr-net = $T_psi$
#let asr-dataset = $cal(D)$
#func-def(
  $#wer-cost$,
  $cal(S)$,
  $RR_+$,
  $(
    #agent-pos,
    #agent-ori
    //bold(x)_s
  )$,
  $
    EE_((v, t) in cal(D))
    lr(
      [
        1/100
        "WER"lr(
          (
            #asr-net
            lr(
              (
                "listened"(
                  v,
                  #agent-pos,
                  #agent-ori,
                  #source-pos
                )
              ),
              size: #120%,
            ),
            t
          ),
          size: #120%,
        )
      ],
      size: #100%,
    ),
  $
)
where:
- $v$ and $t$ are clean speech recordings, respectively, and their associated transcripts are drawn from a corpus #asr-dataset.
- $"listened"(v, #agent-pos, #agent-ori, #source-pos)$ is the signal recorded by the agent's primary microphone when it is located at #agent-pos and oriented by #agent-ori while the speech source, located at #source-pos, plays the recording $v$.
  This operator encompasses the reverberation properties of the room.
- #asr-net denotes a deep #acr("ASR") model parametrized by parameters $phi$.
  Given a recorded signal, it outputs a prediction for the transcript $hat(t)$.
- $"WER"(hat(t), t)$ is the #acr("WER") (in %) between predicted transcript $hat(t)$ and ground truth transcript $t$.

Although the array might include several microphones, the #acr("ASR") measurements only employ a single microphone.
Eventual techniques to combine the signal from multiple microphones are out of the scope of this work.
The following paragraphs discuss the #wer-cost's computing and caching implementation.

#draft[
  Actually, no need to introduce this as a theoretical stuff. It is actually the formula for the cached cost.
  -> Make the wording simpler.
]

In practice, this theoretical cost is untractable for several reasons.

detail the reward implementation and the relevant technical choices made.


==== #acr("ASR") Frameworks

Several #acr("ASR") frameworks have been made available by industrial and academic actors.
Kaldi @povey_kaldi_nodate is one of the most complete and established open-source projects for speech recognition.
The C++ code base includes various algorithms and helpers to process speech and perform speech-related tasks.
It includes feature extraction mechanisms, decoding algorithms, seq2seq models for end-to-end training, and support for traditional HMM-GMM and modern #acr("DNN")-based approaches, making it a versatile toolkit for research—and production-grade #acr("ASR") systems.
PyKaldi @can_pykaldi_2018 offers a Python wrapper that allows users to interact with the Kaldi library easily.

Vosk @noauthor_vosk_nodate is another open-source, popular speech recognition toolkit.
It aims to be a user-friendly product, employed in real-world use cases.
Bindings for several programming languages (Rust, Java, Go...).
Besides its open-source programs, professional licenses for Vosk can be purchased and provide additional features.

#speechbrain @ravanelli_speechbrain_2021 is a more recent library based on the widely used PyTorch @Ansel_PyTorch_2_Faster_2024 #acr("DL") framework.
It grants convenient implementations of novel deep neural networks for speech recognition.
Its objective is to grant research and industrial actors an all-in-one speech toolkit.
It has been used as a building block in various research works @zuluaga-gomez_commonaccent_2023 @mousavi_dasb_2024.

Our final implementation uses the #speechbrain library, which has allowed us to choose from a substantial pool of state-of-the-art pre-trained models.
The specific pipeline that was used in this work involves three components:
//https://huggingface.co/speechbrain/asr-crdnn-rnnlm-librispeech
//https://huggingface.co/speechbrain/asr-crdnn-transformerlm-librispeech
//https://huggingface.co/speechbrain/asr-transformer-transformerlm-librispeech
- The *tokenizer* that transforms each word into one or more tokens.
  This model has been trained on the #librispeech dataset @panayotov_librispeech_2015.
- The *neural language model* represents the dynamics of language.
  Here, we have chosen a #acr("RNNLM") @mikolov_recurrent_2010 provided by the #speechbrain library.
  This architecture applies the successful #acr("RNN") architecture to language modeling.
  In this case, the recurrent units act on word sequences.
  It comprises an embedding layer that maps individual words to 128-dimensional vectors.
  Those vectors are then fed to the #acr("RNN"), which is followed by fully connected layers.
  #speechbrain also provides other architectures, such as a _TransformerLM_, based on the widespread Transformer architecture @vaswani_attention_2017.
- Finally, the *acoustic model* performs the actual task of speech recognition by mapping audio features to tokens.
  It employs a #acr("CRNN") architecture for the encoder, which maps audio features (e.g. #acr("STFT") or #acr("MFCC")) to tokens.
  #speechbrain applies an additional #acr("CTC") @graves_towards_2014 loss to the encoder.
  The #acr("CTC") cost function allows the training of recurrent architectures to perform speech recognition without requiring prior alignment between the input and target sequences.
  Alternatively, #speechbrain ships a Transformer-based encoder-decoder that also uses the #acr("CTC") training strategy.

To choose the best model for our use case, we empirically compared three models provided in #speechbrain.
We evaluated them on the #librispeech training set, which contains 25,539 samples ranging from 3 to 16 seconds.
@table:rl:method:asr_models

We have integrated the #speechbrain #acr("ASR") library into the simulator.
The input signals used for each source are drawn from the #librispeech @panayotov_librispeech_2015 (@sec:simulator:simulator:components:sim_scenarios).
The simulator loads the ground truth transcripts along with the clean signal.
Thus, our #acr("ASR") module, can be fed with the listened signal computed by the simulator, and the obtained transcription can then be compared with the ground-truth one.


#include "asr_models_comparison.typ"


==== Computing of #acr("WER") Maps
<sec:rl:method:wer_maps:computing>

*ASR setup.*
We compute the #acr("WER") score using the _jiwer_ @vaessen_jitsijiwer_2024 library.
To compute the minimum edit distance, it wraps the fast C++ matching library _RapidFuzz_ @max_bachmann_2024_10938887.
The calculation of the metric has no significant impact on performance.
However, running the #speechbrain #acr("ASR") model is highly computationally expensive.
When the model is run in inference mode to evaluate its performance on 100 samples from the #librispeech dataset, 96% of the time is spent on the speech recognition process.
On the contrary, less than 1% is spent computing the #acr("WER") score.
We perform this test on an RTX A6000 NVIDIA GPU that gets fully utilized by this decoding task.
The _RapidFuzz_ library runs directly on the CPU.
Importantly, the decoding process remains slow: It takes approximately 2s to process a single 16s sentence at 16kHz.
#draft[
  Maybe add WER score on simulated/listened data.
]

*Motivation.*
The setup mentioned above allows the computation of #acr("WER") scores on full simulated audio recordings.
However, the proposed #acr("RL") environment involves short steps of 1s, during which the agent is assumed to be immobile and gathers audio data.
Computing the #acr("WER") on such a small snippet would not make sense.
A complete sentence is the minimum necessary for the #acr("WER") to have meaning.
Additionally, as with every metric, this indicator is supposed to be averaged over a significant number of samples to purposefully assess the performance of the evaluated method.
Here, the cost $#wer-cost (s)$ is expected to provide an estimate for the average #acr("ASR") performance for a given state $s$.
For those reasons, the oracle cannot work in real-time and needs to rely on prior information.

*#acr("WER") maps.*
To solve the previously mentioned issue, we introduce the _#acr("WER") map_ abstraction.
The core idea of #acr("WER") maps is to pre-compute an average #acr("WER") score for each attainable state of the #acr("MDP").
More precisely, a microphone will be positioned sequentially in each cell of the 2D grid spanning the room.
If the microphone is not omnidirectional, the agent's orientation will impact the received signal and, eventually, the recognition performance too.
In this case, all four cardinal directions must be evaluated.
The #acr("WER") map materializes as a 2D matrix for an omnidirectional microphone and as a 3D tensor otherwise.

#include "wer_map_algorithm.typ"

@algo:rl:wer_map describes the algorithm used to compute those #acr("WER") maps.
#draft[
  - Clearly introduce/differenciate #cost and #wer-cost
  - Say that we compute maps for a few starting positions
  - give numbers on compute time
  - Add the size of the speech sample: 40
]


==== WER on Clean Speech

#draft[
  TODO: merge with previous section
]

As a sanity check for the #acr("ASR") module, we run the complete recognition pipeline on the clean speech signals from the #librispeech dataset.
The `ASR-CRDNN-RNNLM-LibriSpeech` model from #speechbrain we have chosen yields an average #acr("WER") of 1.82% on this clean dataset.

@table:rl:method:asr_models shows the result of our benchmarking of three models provided by the #speechbrain library.
It highlights the performance-speed trade-off of each model.
`ASR-CRDNN-RNNLM-LibriSpeech` is the fastest model #todo
All three models share the same tokenizer, trained on #librispeech.

#draft[
  Ideally, we could compare three models:
  - `asr-transformer-transformerlm-librispeech`
  - `asr-crdnn-transformerlm-librispeech`
  - `asr-crdnn-rnnlm-librispeech`

  -> Done

  - In the table, we truncated the final `-librispeech` (say somewhere that they were all trained with this reward)

  However, the second one is broken
  -> Just say that the one we chose offers the best compromise between speed and quality.

]


=== Deep Neural Agent
<sec:rl:method:nn_architecture>

The multiple recent successes of #acr("DRL") in solving various tasks (Atari games @mnih_playing_2013, controlling plasma in fusion reactors @degrave_magnetic_2022, #todo) originate consequently in the use of #acr("DNN") as function approximators (@sec:rl:intro:deep_reinforcement_learning).

We propose a custom architecture for the neural network implementing the #acr("RL") agent.
@fig:rl:method:agent_architecture gives a schematic view of its core components.
The choice of #acr("PPO") as a training algorithm requires defining two models: the actor and the critic (@sec:rl:intro:ppo).
We have designed a common backbone between those two systems, allowing them to share a significant part of the model parameters.
This feature extractor is followed by two heads implemented as #acr("MLP").

#draft[
  - Backbone + 2 heads
  - talk about different strats for BB (fine-tuning, no pre-training, frozen)
]

// TODO: add figure

#figure(
  image(
    "figures/rl_agent_architecture.svg"
  ),
  caption: flex-caption(
    short: [
      Neural network architecture for the #acr("DRL") agent.
    ],
    long: [
      Neural network architecture for the #acr("DRL") agent.
      The feature extractor is the backbone of a pre-trained #acr("SSL") model.
      The actor and critic-specific approximators are implemented as downstream #acr("MLP") heads.
    ],
  ),
)
<fig:rl:method:agent_architecture>

==== Pre-Trained Acoustic Feature Extractor

#draft[
  - motivation
  - Link with the SSL work
  - Supervised pipeline
]

The main difficulty of the sound-driven navigation problem lies in the agent's ability to map sound cues to spatial information.
The partial observability aspect of the environment prevents the agent from directly and transparently observing either its own or the source's position.



=== #acr("PPO") Implementation and Training Strategy

*Backbone pretraining.*
The feature extractor maps the audio spectral observations into a lower 16-dimensional embedding vector.
We hypothesize that the agent will implicitly acquire localization capabilities while learning the #acr("RL") navigation task.
We supervisedly train the feature extractor to perform the #acr("SSL") task to improve performance and bootstrap the learning process.
The exact training methodology is detailed in @sec:ssl:single_source:method.
The agent architecture (@fig:rl:method:agent_architecture) extends our single-source localizer.
Please, refer to @fig:ssl:single_source:nn_architecture for a more detailed representation of the feature extractor's architecture.
#draft[
  TODO: this is redundant with @sec:rl:method:nn_architecture.
]



*Reward*
#draft[
  - Differenciate between the base cost used
  - Reward scaling
  - Early stopping and big reward
]
$
  r (s_t) = alpha e^(-beta w(s_t))
$

*Starting positions.*
As previously mentioned, computing a #acr("WER") map is computationally intensive.
Also, a map needs to be computed for each possible source position.
The final formulation for the environment involves 12 possible starting positions deterministically  spread across the room.
#draft[This is a trade off between computational cost for caching the WER maps and the diversity/difficulty of the environment.]

#include "figures/source_positions/fig.typ"

The #acr("WER") maps need to be co
#draft[
  - Add illustration of starting positions.
  - Give hyper-parameters used:
    - PPO
    - Training
    - etc.
]

*Implementation details and hyperparameters.*
Although it has been successful at solving many complex #acr("RL") problems, #acr("PPO") remains highly sensitive to implementation details.
Engstrom et al. @engstrom_implementation_2020 explicitly studied the "code-level optimizations" of the #acr("TRPO") and #acr("PPO") algorithms.
This work formalized the community's shared impression that #acr("PPO")'s promised performance was subject to subtle implementation details.
Huang et al. have also contributed to this practical investigation by publishing _The 37 Implementation Details of Proximal Policy Optimization_ @shengyi2022the37implementation.
In @mahmood_benchmarking_2018, Mahmood et al. study the sensitivity of #acr("RL") algorithms to their hyperparameters.
They mention that #acr("PPO"), along with other state-of-the-art algorithms (#acr("TRPO"), #acr("DDPG"), and Soft-Q), is highly sensitive to its hyperparameter values.
It thus requires careful fine-tuning on each new environment where it is tested.
Our experience corroborates those observations.
Extensive experimental campaigns were required to isolate a satisfying set of hyperparameter values.
We underscore how essential — and nontrivial — hyperparameter tuning can be.
@table:rl:method:hyperparameters summarizes the final hyperparameter values used for training our agent with #acr("PPO").

#include "tables/hyperparameters.typ"

In addition to careful hyperparameter tuning, a selection of implementation details was necessary to train the agent successfully.
For instance, the use of *value loss clipping*



#draft[
  - Add loss clipping
  - We use cosine annealing
  
  Insist on the fact that we implemented the complete pipeline:
  - RL environment (with the simulator)
  - PPO algorithm
  - NN architecture
  - Training code, evaluation, validation
  or maybe in the conclusion...
]