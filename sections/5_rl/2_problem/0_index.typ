#import "/utils.typ": *
#import "../_variables.typ": *

#reset-acronym("WER")

== Sound-Driven Robot Navigation: Problem Statement
<sec:rl:problem>

=== Motivation

Audio perception is an essential pillar of social robotics.
Achieving realistic human-robot interactions is conditioned on the ability to hear and understand the content of people's speech.
#acr("ASR") techniques have significantly progressed, mainly thanks to recent advances in deep learning @malik_automatic_2021.
However, some real-world settings remain challenging, and #acr("ASR") systems can struggle to extract the speech content properly.
Most solutions are trained on a clean speech dataset.
The literature has studied the impact of noise and reverberation on #acr("ASR") performance.
Wang et al. @wang_systematic_2025 explored different strategies to account for the challenges present in reverberant and noisy environments.

In this chapter, we propose to study this issue in the robotic context.
We aim to develop algorithms that improve robots' hearing ability in real-world interaction environments.
To tackle this issue, we target the design of navigation policies.
An agent will be placed in a reverberant environment with an active speech source.
Its goal is to position itself optimally to maximize the #acr("ASR") performance.
Our approach solely relies on the positioning of the robot.
The #acr("ASR") algorithm that we use is a pre-existing #acr("DNN")-based solution.
Our motivation relies on the observation that the microphone's position and orientation relative to the target source in a complex acoustic environment significantly impact the #acr("ASR") performance.
This insight results from an experimental study conducted within our simulated environment.
Other metrics exist to quantify auditory perception and could have been alternatives to the #acr("ASR") performance.
For instance, the #acr("PESQ") score, introduced by Rix et al. @rix_perceptual_2001, predicts the perceived audio quality of speech.
It primarily targets human perception by measuring how a degraded signal compares to its original counterpart.
#acr("ASR") performance is likely correlated to the #acr("PESQ") score, but directly quantifies how well the robot understands human speech.
In this sense, #acr("PESQ") would have been a more indirect proxy for robotic auditory perception.

// Why we use RL over MPCs
We use #acr("DRL") as a learning framework to tackle this navigation task.
Different solutions have been investigated in the literature for designing navigation policies.
#acr("MPC") @rawlings_model_2009 is a widely used mathematical framework in robotics.
It is an advanced control strategy used to determine the optimal control inputs for a robot by predicting future behavior over a finite time horizon.
While #acr("MPC") has been used extensively for navigation and motion planning in robotics
@piovesan_randomized_2009 @arul_unconstrained_2024, it is not quite suited for handling acoustic cues directly.
On the one hand, the #acr("WER") provides an informative reward signal and can thus be exploited by an #acr("RL") algorithm.
On the other hand, the combination of #acr("DNN") and #acr("RL") in the form of #acr("DRL") allows processing high-dimensional representations for the #acr("MDP") observations.


=== Background

The problem of perceptually-motivated audio-based navigation has not been studied much prior.
Nevertheless, this section will highlight some notable works that have already proven the relevance of this area of research.
Also, they provide advanced solutions to problems similar to the one tackled in this thesis.

Magassouba et al. @magassouba_aural_2018 proposed a novel framework for robotic audio-based navigation, _AuralServo_.
Although inspired by #acr("ASSL") pipelines similar to those presented in @chap:active_ssl, their approach differs significantly.
No explicit #acr("SSL") block is defined in their framework.
Indeed, the robot controls are directly inferred from the aural perception.
This system is architected around a direct feedback loop, allowing for low computational cost and, thus, response times.
Their contribution is a theoretical scheme for commanding a robot using auditory features and real-world experiments with audio-based control tasks.
Those tasks include automatic gaze adjustment to face the active speaker and a navigation task based on #acr("ILD").
The latter comprises following a sound source indoors, solely relying on audio perception.
Regarding the proposed methodology, the process involves computing relevant auditory features such as the #acr("ILD") and #acr("IPD").
These quantities are then interpreted geometrically to be linked to the task objective, thus defining an interaction matrix $bold(J_s)$ satisfying:
$
  bold(dot(s)) = bold(J_s) bold(u),
$
where $bold(dot(s))$ is the variation of the feature set and $bold(u)$ denotes the control signal.
$bold(u)$ is then inferred so as to minimize the error $bold(e)(t)$ to the target state $bold(s)^*$:
$
  bold(e)(t) = bold(s)(t) - bold(s)^*.
$
The paper provides a detailed theoretical derivation of the auditory features, interaction matrices, and solving schemes.
This work thus adopts a feedback loop strategy to control the robot and does not involve any learning algorithm.
Finally, _AuralServo_ provides an interesting formulation for active robotic navigation problems and an analytical solution that could be demonstrated in real-world experiments.

Furthermore, a research group from UT Austin, led by Kirsten Grauman, has conducted pioneering work in perceptually-motivated robotic navigation and achieved impressive results.
In their paper _SoundSpaces_ @chen_soundspaces_2020, Chen et al. define and solve the task of audio-visual navigation towards a sound source in complex environments.
Their contribution is twofold.
On the one hand, they introduce _SoundSpaces_, a dataset that extends existing realistic 3D environments with simulated audio renderings.
The environment uses the _Habitat_ simulator @savva_habitat_2019 alongside the _Matterport3D_ @chang_matterport3d_2017 and _Replica_ @straub_replica_2019 datasets that it includes.
This simulator provides only visual cues from its 3D representation of indoor spaces.
Chen et al. leveraged a geometrical acoustic method for room acoustic simulations consisting of bidirectional path tracing @cao_interactive_2016 to add auditory information to the simulator.
On the other hand, they designed a #acr("DRL") agent that can navigate these challenging environments.
Its neural network architecture receives the RGB and depth frames from the virtual camera, the #acr("STFT") of the listened signal, and the relative displacement vector pointing from the agent to the goal.
Following feature-specific, then shared layers are two heads modelling the actor and the critic, respectively.
The authors trained the system to navigate to a source in previously unknown environments.
Audio is shown to improve navigation performance substantially.
Mixing audio and visual information allows the agent to extract more spatial knowledge from its environment and, thus, navigate more efficiently towards the source.
This study has also further demonstrated the capacity of neural networks to exploit the reverberation phenomenon to achieve a navigation task.
This proposal illustrates how #acr("DRL") can be used with multi-modal agents to solve complex navigation tasks.

Grauman's team has expanded on their framework in a follow-up paper by Majumder et al. called _Move2Hear_ @majumder_move2hear_2021.
The task tackled here consists of navigating a complex 3D environment with the motivation to enhance audio perception.
More precisely, the agent's objective is to adjust its position with respect to several sound sources to perform optimal audio separation.
The agent starts at a random position in a 3D scene from the _Habitat_ simulator.
One is designated as the target source among the active sound sources in the environment.
The performance obtained on the audio separation task is the primary reward signal available for learning the policy.
Besides, the agent is also rewarded for reducing the geodesic distance to the target source.
The neural network that implements it is split into two main blocks.
The first takes the #acr("STFT") of the binaural signal listened to by the agent and the identifier of the target speech.
It is trained to output the isolated target speech signal's #acr("STFT") and thus performs the actual source separation.
The second component of the agent is the active audio-visual controller.
It is responsible for implementing the navigation policy.
A common feature extraction backbone uses #acrpl("GRU") @cho_learning_2014 to perform the core perception work.
It is followed by two heads implementing the actor and the critic, optimized by the #acr("PPO") algorithm.
The policy comprises two sub-policies: one for improving the separation quality when relatively close to the target source, and an audio-visual navigation policy to get closer to it.
Both networks are trained in a cyclic pattern, ensuring continuous and synchronous overall performance improvement.
A convincing experimental study is also conducted to demonstrate the approach's effectiveness.
They propose two different benchmarks.
In the _near-target_ task, the agent starts relatively  close to the target sound source.
Here, it has to adjust its position to optimize for the separation score.
In the _far-target_ setting, the agent is initially placed further from the source of interest and has to navigate the environment to eventually get close to it.
This task variant targets leveraging audio-visual information to plan the shortest possible trajectory.
Overall, the _Move2Hear_ framework successfully applies #acr("DRL") to a robotic navigation problem where the objective is motivated by audio perception.
This work does not specifically optimize for the #acr("ASR") performance.
Also, the proposed method makes use of visual information.



=== Problem Formulation

// RL
We adopt a #acr("DRL") approach to design such a navigation policy.
This policy will be modeled by a deep neural network trained in a simulated environment.
We develop a complete pipeline for solving the perceptually motivated audio-based navigation task.
The problem is cast as a sequential decision process, aligning naturally with the #acr("RL") framework.
This work's original contribution includes implementing the #acr("RL") environment, agents, algorithm, and evaluation setup.

// Sound only
Also, our solution tackles a challenging framework where only audio data can be used to perceive the environment.
The agent has neither visual cues nor direct spatial information, such as absolute or relative positions.
To address this limitation, we leverage the algorithms and knowledge obtained from our study of #acr("SSL").

In the following paragraphs, we will formalize the task we plan to solve.
The core novelty of this problem is to use the #acr("ASR") performance as the reward signal.
First, we will introduce the relevant metric and its relation to speech recognition.
Second, we will present the #acr("RL") environment and the justification for our different choices.


*#acr("WER") metric for #acr("ASR").*
The #acr("ASR") task involves transcribing the speech content from an audio recording.
It can be done using pre-recorded samples or in real-time from an audio stream.
The #acr("WER") metric measures the performance of #acr("ASR") systems.
It is computed as follows:
$
  "WER" = (s + d + i) / n,
$
where $s$ is the number of substitutions, $d$ is the number of deletions, and $i$ is the number of insertions needed to transform the true sentence into the predicted text.
$n$ counts the total number of words in the ground truth transcript.
The #acr("WER") quantifies the difference between the original and transcribed text.
The total number of errors $s + d + i$ is also called the Levenshtein or edit distance, which Vladimir Levenshtein proposed in 1965 @levenshtein_binary_1965.
Its default formulation considers comparing two strings at the character level.
Lets consider two strings $a$ and $b$ (of length $abs(a) = n + 1$ and $abs(b) = m + 1$ respectively).
#block(breakable: false)[
  The Levenshtein distance between $a$ and $b$ is computed as:
  $
    "lev"(a, b) = cases(
      abs(a) & "if" m = 0,
      abs(b) & "if" n = 0,
      "lev"(a_(1..n), b_(1..m)) & "if" a_0 = b_0,
      1 + min cases(
        "lev"(a_(1..n), b),
        "lev"(a, b_(1..m)),
        "lev"(a_(1..n), b_(1..m))
      ) & "otherwise,"
    )
  $
]
where $a_0$ is the first character of $a$ and $a_(1..n)$ is the string $a$ without its first character.
It counts the number of edits to turn string $a$ into string $b$.
As such, it is bounded by the length of the longest string:
$
  0 lt.eq "lev"(a, b) lt.eq max(abs(a), abs(b)).
$
The #acr("WER") score uses words instead of characters as the fundamental tokens.
//As its definition is recursive, most implementations leverage dynamic computing.

*Running of an episode.*
An episode starts with the agent and one or several sources randomly placed in the room.
One source is considered the target.
This means that the #acr("ASR") output will be evaluated against the actual transcript pronounced by this source.
Other sources might also be added and can act as adversarial sources.
The process is sequential and discrete.
At each time step, the agent will be offered to listen to the surrounding audio for a fixed duration (inferior to one second).
The robot will then be asked to select a movement action to enhance its relative position to the target source.
The simulator then applies this movement, after which the agent receives both a new observation and a reward signal computed from the #acr("WER") of its new position.
We choose to fix a maximum number of 32 steps per episode.
This environment thus has a finite horizon.
No specific event occurs at the final step.
The reward of the last state is computed using the same scheme as for the intermediary steps.
The following section will formalize the definition of the #acr("RL") environment.

==== Environment Definition
<sec:rl:problem:formulation:environment>

The #acr("RL") environment corresponds to the #acr("MDP") formulation and implementation for the task.
In this section, we present those characteristics and the motivations that led to this final specification.

*#acr("POMDP").*
The original #acr("MDP") model lacks expressivity to model our environment accurately.
Instead, we rely on the #acr("POMDP") framework, which does not allow direct observation of the state.
The agent can probe its environment through observations distinct from the underlying states.
This choice decouples the environment logic from the sensory observation available to the agent.
A #acr("POMDP") can be described as a tuple $lr(angle.l cal(S), cal(A), P, cal(R), Omega, O, gamma angle.r)$ where:
- $cal(S), cal(A), P$, $cal(R)$ and $gamma$ describe the underlying #acr("MDP");
- $Omega$ is the observation space; and
- $O: cal(S) times cal(A) -> Pi (Omega)$ is the _observability function_ which maps all state-action pairs to a probability distribution over the observation space $Omega$.
  $O(s' | a, o)$ denotes the probability of making observation $o$ given that the agent took action $a$ and landed in state $s'$.
This definition and its notations have been borrowed from Leslie Kaelbling et al. @kaelbling_planning_1998.
She and her research group have conducted groundbreaking work related to the comprehension and use of #acr("POMDP")s, particularly in robotics.
From her original work on this topic, _Acting Optimally in Partially Observable Stochastic Domains_ @cassandra_acting_1994 in 1994 Kaelbling has published several papers exploring how to efficiently solve partially observable environments problems
@cassandra_acting_1996
@theocharous_approximate_2003
@brunskill_continuous-state_2008
@meuleau_learning_2013
@meuleau_solving_2013.
Those works are not strictly limited to the #acr("RL") domain.
More recently, Azizzadenesheli et al. @azizzadenesheli_policy_2020 investigated how policy gradient algorithms could be adapted to #acrpl("POMDP").

*State and action spaces.*
We chose a spatially discrete setting for modeling the environment.
The agent evolves along a virtual $n_x times n_y$ grid spanning the entire room.
Also, its orientation is restricted to be aligned with the grid, i.e., being either _up_, _down_, _left_, or _right_.
The discrete state space $cal(S)$ can then be expressed as follows:
$
  cal(S) = lr(
    {
      (x_i, y_j, alpha)
      #h(1em) mid(|) #h(1em)
      (i, j, alpha) in
      [|1, n_x|]
      times [|1, n_y|]
      times {0, pi/2, pi, (3 pi) / 2}
    },
    size: #120%
  )","
$
<eq:rl:state_space>
where $x_i$ and $y_j$ denote the 2D position of the agent and $alpha$ its orientation with respect to the room global frame.
The position and orientation restrictions are enforced by the following action space $cal(A)$:
$
  cal(A) = {#a-stay, #a-forward, #a-left, #a-right}.
$
<eq:rl:action_space>
- #a-stay is the neutral action where the agent does not move away from its current location.
- #a-forward means moving by a distance of #forward-dist meters in the current direction $alpha$.
The step size #forward-dist must correspond to the distance #delta-grid between two adjacent grid points.
- `TURN_LEFT` and `TURN_RIGHT` correspond to a quarter-turn rotation. In this case, only the orientation of the agent changes, not its position.
A learned policy for this problem will be a probabilistic distribution $pi(dot | dot): cal(A) times Omega -> [0, 1]$ over this finite set of four actions.

Although our audio simulator would have permitted a continuous formulation, choosing a discrete setting provides important benefits.
The most crucial one of them is the ability to pre-compute the reward.
Indeed, having a discrete state space allows for caching the reward function for all possible states.
As will be explained later in @sec:rl:method:wer_maps, our reward function is very computationally expensive.
On the other hand, having a finite action space enables working with equally finite policies $pi(a | s) = pi_a (s)$.
This choice permits the use of #acr("RL") algorithms modeling the Q-value, such as #acr("DQN") methods @mnih_playing_2013.
Also, such a framing is both computationally and conceptually simpler.
Zhu et al. @zhu_overview_2021 survey the role of action spaces in #acr("RL") and its applications.
They notably explore the differences between continuous, discrete, and discrete-continuous hybrid action spaces.

*Observation space.*
The agent's perception of its environment is limited to the audio signal received by its microphones.
It does not know its current position.
This acoustic information consists of a one-second-long recorded signal mapped to the time-frequency domain.
Practically, the observations are #shape("C", "F", "T") real tensors where $C$ is the number of output channels, $F$ is the number of frequency bins, and $T$ is the number of temporal indices.
Formally, the observation space is $Omega = RR^(C times F times T)$.
The agent aims to learn a mapping $s -> pi(dot | s)$ from this space to the probabilities over actions.
This represents the essence of the audio-based navigation task: learning to decide how to move depending on what is heard.
The observability function translates the listening process.
Sound sources speak continuously.
At each step, the robot listens for $tau_"step"$ seconds while remaining immobile.
The random nature of the speech content delivered by each source accounts for the position-agnostic stochasticity of the observation function.
The rest of the process consists of the sound propagation and reverberation simulation.
By nature, there is no analytical closed-form expression of $O$.
It is directly embedded in the environment implementation.


*Reward function.*
The main originality of our approach lies in the perceptually motivated objective.
The agent should be trained to navigate to the optimal location regarding the #acr("ASR") performance.
Naturally, the reward function should be a decreasing function, $f: [0, 1] -> RR$, of the #acr("WER") metric so that the highest reward would correspond to the lowest possible #acr("WER").
For now, we assume having access to an oracle cost function $C: cal(S) -> [0, 1]$ that maps each possible state to a penalty that should be minimized.
It quantifies how undesirable it is to be in this specific state.
Although we explored alternative formulations for the cost function $C$, the primary cost used in the task is #wer-cost, which represents the estimated average Word Error Rate (WER) that the #acr("ASR") system would produce if the agent were located at that specific position.
The practical implementation of this mapping will be discussed later in @sec:rl:method:wer_maps.
The reward function can then be written as follows:
$
  r_t = cases(
    -#reward-wall-penalty & quad "if the movement is invalid",
    #f-reward (#cost-t) - #reward-movement-penalty bb(1) (a_t = #a-forward) & quad "otherwise,"
  )
$
<eq:rl:problem:reward>
where:
- $#cost-t = #cost (s_t)$ is the cost value of the state $s_t$;
//- $#cost-t = (#cost (s_t)) / (max_(s in cal(S)) C(s)) $ is the normalized cost value of the state $s_t$;
- #reward-wall-penalty is a positive scalar that can be adjusted according to #f-reward's magnitude;
  It allows penalizing movements that would lead the robot to collide with a wall.
  When the policy samples such an impossible action, the environment ignores it, the agent remains immobile for this step, and a fixed reward of $-#reward-wall-penalty$ is returned.
  This can only occur for the forward action.
- #reward-movement-penalty is a movement penalty that disincentivizes the agent from moving uselessly.
  It encourages the policy to remain static when it can, while solely moving when it serves a meaningful purpose.
  Combined with the standard cost reward $#f-reward (#cost-t)$, it entices the agent to position itself optimally as efficiently as possible.

*Environment initialization*
When an episode starts, the initial state is drawn randomly according to the probability distribution $rho: cal(S) -> [0, 1]$.
In our environment, we randomly draw the agent's starting position and orientation when an episode begins.
Therefore, the initial state distribution is the uniform distribution over the state space: $s_0 ~ rho = cal(U) (cal(S))$.

*Transition dynamics.*
Finally, we must provide the transition dynamics to fully define our #acr("MDP").
More precisely, we refer to the conditional probability $P(s' | s, a)$ of being in the state $s'$ when coming from the state $s$ and performing action $a$.
Those dynamics are implemented by the simulator along with the observability function $O$.
In our case, they are completely deterministic due to their purely geometric nature.
Indeed, each action leads to a predictable change of the agent's position $(x_a, y_a, #agent-ori)$.
The transition dynamics can be expressed as the following deterministic function $t$, which maps a state-action pair to the next state:
#let x(content: $x_a$) = $colMath(content, #olive)$
#let y(content: $y_a$) = $colMath(content, #orange)$
#let agent-ori-colored(content: agent-ori) = $colMath(content, #maroon)$
#func-def(
  $t$,
  $cal(S) times cal(A)$,
  $cal(S)$,
  $lr(((#x(), #y(), #agent-ori-colored()), a), size: #130%)$,
  $
    cases(
      (#x(content: $x_a + d cos(#agent-ori)$), #y(content: $y_a + d sin(#agent-ori)$), #agent-ori-colored())
      quad & "if" a=#a-forward,
      (#x(), #y(), #agent-ori-colored(content: $(#agent-ori + pi/2 )[2pi]$))
      quad & "if" a=#a-left,
      (#x(), #y(), #agent-ori-colored(content: $(#agent-ori - pi/2 )[2pi]$))
      quad & "if" a=#a-right,
      (#x(), #y(), #agent-ori-colored())
      quad & "if" a = #a-stay \
           & quad| (a = #a-forward and a "is invalid").
    )
  $,
)
The collisions are detected before execution so that the environment can deny the action.

Finally, the environment's horizon is finite.
No event can terminate the environment before this time limit.
Therefore, each episode lasts a fixed number of steps, denoted as the horizon #env-horizon.


==== Alternative Continuous Formulation

A spatially discrete solution was proposed, where the state and action spaces are finite.
Such a choice grants various benefits, such as an easier implementation and the possibility of using #acr("RL") methods that cannot handle continuous spaces.

*Alternative #acr("POMDP").*
On the other hand, a more general continuous formulation can be described.
It would offer a more realistic modeling of the real-world problem.
Indeed, restricting a real robot to move exclusively on a grid is not sensible.
Alternatively, one could change the previously defined #acr("POMDP").
First, the state space would become $cal(S)_c = [0, L_x] times [0, L_y] times [0, 2pi] subset RR^3$.
Several choices are possible regarding the action space.
Although it would be possible to employ the original finite action space $cal(A)$, this solution would still restrict the set of reachable positions to a same-size 2D grid.
It would be rotated and translated accordingly to the initial position.
A more sensible choice would be sampling a distance and a rotation angle to parametrize a straight translation.
This would amount to the continuous action space $cal(A)_c = [0, d_max] times [0, 2pi]$.
Entirely freeform movements would still not be possible, but this new space would allow for more expressive trajectories.
The current implementation of the simulator allows for easily extending the existing discrete environment to continuous variants.
The distinctions exposed here only impact the spatial properties of the #acr("MDP").
Audio aspects of the environment may remain the same.

*Reward computation.*
The reward computation is another obstacle to handling the problem's continuous form.
Currently, it is fully pre-computed and cached using the #acr("WER") maps solution.
Keeping this paradigm is possible by interpolating the grid-evaluated reward function to compute the reward for arbitrary positions.

*Continuous audio simulation.*
Besides, the proposed framework assumes that movements are instantaneous and that listening happens strictly statically.
Accounting for a continuously moving agent would contribute to improving the model's realism further.
As the #acr("MDP") model remains fundamentally sequential, the agent would still make step-based decisions.
A hybrid solution entails performing the audio simulation along a trajectory instead of assuming the position to be fixed.
Although our simulator does not support such a feature, the underlying _gpuRIR_ authors explain how it could be implemented (see section 3.4 of Diaz-Guerra et al. @diaz-guerra_gpurir_2021).

*Algorithmic implications.*
The #acr("PPO") algorithm employed in this work is fully compatible with continuous state and action spaces.
Instead of predicting the probability $p_a$ of each discrete action, the actor neural network outputs the parameters $(bold(mu), bold(sigma) I)$ of a $dim(cal(A))$-dimensional normal distribution.
Petrazzini et al. @petrazzini_proximal_2021 alternatively propose to use the Beta distribution.
Compared to a Gaussian distribution, its primary benefit is having a finite support that naturally fits bounded action spaces.
They also found the Beta distribution to outperform the Gaussian one.

In conclusion, the simple discrete formulation of the sound-driven navigation problem can be generalized to better represent real-world robotic scenarios.
