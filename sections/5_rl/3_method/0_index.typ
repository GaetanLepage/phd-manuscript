#import "/utils.typ": *
#import "/_misc/notations.typ": *
#import "../_variables.typ": *

== Proposed Approach
<sec:rl:method>

=== Acoustic Pipeline

The abstract environment defined previously in @sec:rl:problem:formulation:environment is implemented in practice thanks to our simulator @sec:simulator:simulator.
More precisely, its capacity to operate in discrete time steps makes it particularly convenient for use in an #acr("RL") framework.
The specific implementation details of the simulator's dynamic features have been described in @sec:simulator:simulator:dynamic_scenarios.
It allows us to place our microphone array and the target source at the beginning of each episode.
The #acr("RL") environment wraps the simulator's `step` function and moves the agent according to the action selected from the policy.
The simulator loads the next chunk of audio and sets it as the source's input.
The source clean speech recordings are sampled from the _LibriSpeech_ @panayotov_librispeech_2015 corpus.
When transitioning from one step to the next, the source keeps playing the same recording to improve realism.
After loading the source's input signal, the simulator refreshes the cached #acr("RIR")s if necessary, i.e., if the agent has moved, and computes the next chunk of recorded audio.
Finally, the resulting multi-channel signal is further processed into an interaural spectral representation.
Specifically, we use the #acr("IPD") and #acr("ILD") features.
A three-microphone array is used to model the agent's sensors.
Each microphone has a cardioid pattern.
Therefore, the observations materialize as #shape(6, "F", "T") multi-channel spectral features.

The final environment is Gym-compliant.
OpenAI _Gym_ @brockman_openai_2016 was created to define the standard way of interacting with #acr("RL") environments.
_Gymnasium_ @towers_gymnasium_2024 by Towers et al. has since replaced it and was used in this project.
This precaution ensures compatibility with the rest of the #acr("RL") ecosystem and would allow other researchers to use the designed environment.


=== WER as a Reward Signal
<sec:rl:method:wer_maps>
#minitoc(indent: true)

This section presents the design and implementation details of the #acr("WER") cost function (#wer-cost).
The reward signal introduced previously expects an oracle to provide an estimate of the #acr("WER") score for each possible state.
This is achieved by pre-computing an average #acr("WER") for every position on the grid, and possibly every orientation of the agent.
The obtained #acr("WER") cost function is given by:
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
            underbrace(
            #asr-net
            lr(
              [
                "listened"(
                  v,
                  #agent-pos,
                  #agent-ori,
                  #source-pos
                )
              ],
              size: #120%,
            ),
            "predicted transcript" hat(t) 
            ),
            thick t
          ),
          size: #120%,
        )
      ],
      size: #100%,
    ),
  $
)
<eq:rl:method:wer_cost>
where:
- $v$ and $t$ are clean speech recordings, respectively, and their associated transcripts are drawn from a corpus #asr-dataset.
- $"listened"(v, #agent-pos, #agent-ori, #source-pos)$ is the signal recorded by the agent's primary microphone when it is located at #agent-pos and oriented by #agent-ori while the speech source, located at #source-pos, plays the recording $v$.
  This operator encompasses the reverberation properties of the room.
- #asr-net denotes a deep #acr("ASR") model parametrized by parameters $phi$.
  Given a recorded signal, it outputs a prediction for the transcript $hat(t)$.
- $"WER"(hat(t), t)$ is the #acr("WER") (in %) between predicted transcript $hat(t)$ and ground truth transcript $t$.

Although the array may comprise multiple microphones, #acr("ASR") measurements rely solely on a single one — namely, the microphone that is aligned with the agent's forward-facing direction.
Eventual techniques to combine the signal from multiple microphones are out of the scope of this work.
The following paragraphs discuss the #wer-cost's computing and caching implementation.


==== #acr("ASR") Frameworks

Several #acr("ASR") frameworks have been made available by industrial and academic actors.
Kaldi @povey_kaldi_nodate is one of the most complete and established open-source projects for speech recognition.
The C++ code base includes various algorithms and helpers to process speech and perform speech-related tasks.
It includes feature extraction mechanisms, decoding algorithms, seq2seq models for end-to-end training, and support for traditional HMM-GMM and modern #acr("DNN")-based approaches, making it a versatile toolkit for research—and production-grade #acr("ASR") systems.
PyKaldi @can_pykaldi_2018 offers a Python wrapper that allows users to interact with the Kaldi library easily.

Vosk @noauthor_vosk_nodate is another open-source, popular speech recognition toolkit.
It aims to be a user-friendly product that can be employed in real-world use cases.
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
  This model was trained on the #librispeech dataset @panayotov_librispeech_2015.
- The *neural language model* represents the dynamics of language.
  Here, we have chosen a #acr("RNNLM") @mikolov_recurrent_2010 provided by the #speechbrain library.
  This architecture applies the successful #acr("RNN") architecture to language modeling.
  In this case, the recurrent units act on word sequences.
  It comprises an embedding layer that maps individual words to #dim-features-value;-dimensional vectors.
  These vectors are then fed to the #acr("RNN"), which is followed by fully connected layers.
  #speechbrain also provides other architectures, such as a _TransformerLM_, based on the widespread Transformer architecture @vaswani_attention_2017.
- Finally, the *acoustic model* performs the actual task of speech recognition by mapping audio features to tokens.
  It employs a #acr("CRNN") architecture for the encoder, which maps audio features (e.g. #acr("STFT") or #acr("MFCC")) to tokens.
  #speechbrain applies an additional #acr("CTC") @graves_towards_2014 loss to the encoder.
  The #acr("CTC") cost function allows the training of recurrent architectures to perform speech recognition without requiring prior alignment between the input and target sequences.
  Alternatively, #speechbrain ships a Transformer-based encoder-decoder that also uses the #acr("CTC") training strategy.

To choose the best model for our use case, we empirically compared three models provided by the #speechbrain toolkit.
We evaluated them on the #librispeech training set, which contains 25,539 samples ranging from 3 to 16 seconds.
Each model's performance is measured through the #acr("WER").
@table:rl:method:asr_models summarizes the benchmarking results.
All three models provide distinct tradeoffs between inference speed and performance.
`asr-crdnn-rnnlm` has the fastest measured sample rate.
The transformer architecture allows the other two models to reach sub-1% #acr("WER"), but at the expense of being 2 to 7 times slower.
`asr-crdnn-transformerlm` has the lowest throughput while providing worse performance than `asr-transformer-transformerlm`.
As the absolute #acr("ASR") performance is not particularly relevant for this project, we adopted the `asr-crdnn-rnnlm` model to benefit from its higher throughput.




#include "asr_models_comparison.typ"


==== Computation of #acr("WER") Maps
<sec:rl:method:wer_maps:computing>

*ASR setup.*
We compute the #acr("WER") score using the _jiwer_ @vaessen_jitsijiwer_2024 library.
To compute the minimum edit distance, it wraps the fast C++ matching library _RapidFuzz_ @max_bachmann_2024_10938887.
The calculation of the metric has a negligible impact on runtime performance.
However, running the #speechbrain #acr("ASR") model is highly computationally expensive.
When the model is run in inference mode to evaluate its performance on 100 samples from the #librispeech dataset, approximately 96% of the total runtime is spent on the speech recognition process.
On the contrary, less than 1% is used for computing the #acr("WER").
We perform this test on an RTX A6000 NVIDIA GPU that gets fully utilized by this decoding task.
The _RapidFuzz_ library runs directly on the CPU.
Notably, the decoding process remains slow: It takes approximately 2s to process a single 16s sentence at 16kHz.

*Motivation.*
The setup mentioned above allows the computation of #acr("WER") scores on full simulated audio recordings.
However, the proposed #acr("RL") environment involves short steps of 1s, during which the agent is assumed to be immobile and gathers audio data.
Computing the #acr("WER") on such a small snippet would not make sense.
A complete sentence is the minimum necessary for the #acr("WER") to have meaning.
Additionally, as with every metric, this indicator is supposed to be averaged over a significant number of samples to purposefully assess the performance of the evaluated method.
Here, the cost $#wer-cost (s)$ is expected to provide an estimate for the average #acr("ASR") performance for a given state $s$.
For those reasons, the oracle cannot work in real-time and needs to rely on prior information.

*#acr("WER") maps.*
To solve this issue, we introduce the #acr("WER") map abstraction.
The core idea of #acr("WER") maps is to pre-compute an average #acr("WER") score for each attainable state of the #acr("MDP") and cache it for later use.
More precisely, a microphone is positioned sequentially in each cell of the 2D grid spanning the room.
If the microphone is not omnidirectional, the agent's orientation will also impact the received signal and, eventually, the recognition performance.
In this case, all four cardinal directions must be evaluated.
The #acr("WER") map materializes as a 2D matrix for an omnidirectional microphone and as a 3D tensor otherwise.

#include "wer_map_algorithm.typ"

@algo:rl:wer_map describes the algorithm used to compute those #acr("WER") maps.
It implements @eq:rl:method:wer_cost.
//Line 34 implements cost normalization, which ensures that $C_"WER"$ will scale over the entire $[0, 1]$ interval.
The computation time of the #acr("WER") map algorithm can quickly grow to several hours.
Its time complexity grows in the order of:
$
  O(#n-x-exp times #n-y-exp times abs(#asr-dataset)).
$
Hence, increasing the spatial resolution by lowering #delta-grid increases the computing time quadratically.
Moreover, if the #librispeech corpus (28,549 samples) were used as dataset #asr-dataset, computing a single #acr("WER") map would require over a year.
Naturally, distributing this algorithm over several nodes would help reduce the overall walltime and would be an interesting extension to our current implementation.
Finally, directional maps require four times more time to compute as the process has to be repeated for each possible agent orientation.
To balance spatial resolution and statistical significance, we settle on using $abs(#asr-dataset) = 40$ recordings and $#delta-grid = 50"cm"$.
With the $4 times 7$ meter room used in this study, this resolution translates to maps of dimension $14 times 8 (times 4)$.
Directional maps take approximately 17 hours to compute.
A #acr("WER") map needs to be computed for each source position considered.


=== Deep Neural Agent
<sec:rl:method:nn_architecture>

The multiple recent successes of #acr("DRL") in solving various tasks originate consequently in the use of #acr("DNN") as function approximators (@sec:rl:intro:deep_reinforcement_learning).
We propose a custom architecture for the neural network implementing the #acr("RL") agent.
@fig:rl:method:agent_architecture gives a schematic view of its core components.
The choice of #acr("PPO") as a training algorithm requires defining two models: the actor and the critic (@sec:rl:intro:ppo).
We have designed a common backbone between those two systems, allowing them to share a significant amount of  parameters.
This feature extractor is followed by two heads implemented as #acr("MLP").

The main difficulty of the sound-driven navigation problem lies in the agent's ability to map sound cues to spatial information.
The partial observability aspect of the environment prevents the agent from directly and transparently observing either its own or the source's position.
Therefore, we hypothesize that the agent will implicitly acquire localization capabilities while learning the #acr("RL") navigation task.
We propose to leverage a pre-trained deep sound-source localizer to bootstrap this capability in the agent's initial weights.
Specifically, we use the model introduced in the third chapter, trained to localize a single speech source randomly located in a reverberant room.
The architectures and the pre-trained weights are directly transferred to build the deep neural agent.
@fig:ssl:single_source:nn_architecture provides a more detailed representation of the feature extractor's architecture.
Its final regression layer is removed.
The obtained model outputs #dim-features-value;-dimensional feature vectors fed into the actor and critic heads.
The feature extractor's weights are kept frozen during the entire #acr("PPO") training process.
@sec:rl:results:backbone_init discusses different strategies regarding backbone initialization.

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



=== PPO Implementation and Training Strategy


*Environment.*
While the environment is defined initially as a #acr("POMDP"), we apply the standard #acr("PPO") algorithm, adopting a classical #acr("MDP") formulation.
The environment for the navigation task is parametrized with a horizon #env-horizon of $#env-horizon-value$ steps.
This value allows the agent to navigate the room in its entire span several times per episode.
The value of the discount factor $gamma$ is fixed at #discount-factor-value.
Furthermore, the incremental moving distance #forward-dist is set to $50"cm"$ to match the chosen grid spatial resolution #delta-grid.

*Source positions.*
As previously mentioned, computing a #acr("WER") map is computationally intensive.
Also, a map needs to be computed for each possible source position.
The final formulation for the environment involves $#n-source-pos = #n-source-pos-value$ possible starting positions deterministically spread across the room.
This choice is a tradeoff between the computational cost of #acr("WER") maps caching and the diversity and difficulty of the environment.
@fig:rl:method:source_positions shows the chosen distribution of source positions across the room.


#include "figures/source_positions/fig.typ"

*Implementation details and hyperparameters.*
Although #acr("PPO") has been successful at solving many complex #acr("RL") problems, it remains highly dependent on its hyperparameter values and implementation details.
In @mahmood_benchmarking_2018, Mahmood et al. study the sensitivity of #acr("RL") algorithms to their hyperparameters.
Mahmood et al. mention that #acr("PPO"), among other state-of-the-art algorithms, is highly sensitive to its hyperparameter values @mahmood_benchmarking_2018.
It thus requires careful fine-tuning on each new environment where it is tested.
Our experience corroborates those observations.
Extensive experimental campaigns were required to isolate a satisfying set of hyperparameter values.
We underscore how essential — and nontrivial — hyperparameter tuning can be.
@table:rl:method:hyperparameters summarizes the final hyperparameter values used for training our agent with #acr("PPO").

#include "tables/hyperparameters.typ"

In addition to careful hyperparameter tuning, a selection of implementation details was necessary to train the agent successfully.
Engstrom et al. @engstrom_implementation_2020 explicitly studied the "code-level optimizations" of the #acr("TRPO") and #acr("PPO") algorithms.
This work formalized the community's shared impression that #acr("PPO")'s promised performance was subject to subtle implementation details.
Huang et al. have also contributed to this practical investigation by publishing _The 37 Implementation Details of Proximal Policy Optimization_ @shengyi2022the37implementation.
We incorporate several of these optimizations in our custom #acr("PPO") implementation.
While the employed implementation details are not exhaustively listed here, the following are notable examples.
Most notably, value loss clipping effectively helped stabilize the critic's optimization.
The unclipped value loss function, introduced in @eq:rl:intro:ppo:value_loss is replaced by:
$
  L_t^"VF, clipped" (theta) := max[
    underbrace(
      (V_theta (s_t) - R_t)^2,
      "unclipped loss"
    ),
    (V^"clipped" (s_t) - R_t)^2
  ],
$
where $V^"clipped" (s_t))$ is the clipped value prediction:
$
  V^"clipped" (s_t) =
    V_theta_"old" (s_t)
    + "clip"[
      V_theta (s_t)
      - V_theta_"old" (s_t),
      - #ppo-value-loss-epsilon,
      #ppo-value-loss-epsilon
    ].
$
Here, $V_theta_"old"$ is the value network from the previous iteration, and #ppo-value-loss-epsilon controls the clipping range of the value update.
This new loss is inspired by the clipped loss #_ppo-clipped-loss used to optimize the actor network.
It prevents large updates to the value function while still allowing it to improve when it's confident.
Our experiments showed that using this clipped formulation of the value loss significantly helps stabilize training.
Furthermore, the final training process also progressively decays the learning rate during training.
This is achieved using a cosine annealing scheduler (see @sec:ssl:single_source:method:training_strategy, for example).

*Reward.*
The reward design was fundamental in achieving reliable training of the agent.
The general formulation of the reward function was given by @eq:rl:problem:reward.
Its final parameter values have been tuned empirically to ensure proper training dynamics and the convergence to satisfying policies.
This process is later discussed in the @sec:rl:results:reward_design, which also gives the final expression of the reward function.