#import "/utils.typ": *
#import "../_notations.typ": *

== Sound-driven robot navigation
<sec:rl:problem>

=== Motivation

Audio perception is an essential pillar of social robotics.
Achieving realistic human-robot interactions is conditioned by the ability to hear and understand the content of people's speech.
#acr("ASR") techniques have significantly progressed, mainly thanks to recent advances in Deep Learning @malik_automatic_2021.
However, some real-world settings remain challenging, and #acr("ASR") systems can struggle to extract the speech content properly.
Most solutions are trained on a clean speech dataset.
The literature has studied the impact of noise and reverberation on #acr("ASR") performance.
Wang et al. @wang_systematic_2025 explored different strategies to account for the challenges present in reverberant and noisy environments.
#draft[Maybe add more references.]

In this chapter we propose to study this issue in the robotic context.
We aim to develop algorithms that improve robots' hearing ability in real-world interaction environments.

To tackle this issue, we target the design of navigation policies.
An agent will be placed in a reverberant environment with an active speech source.
Its goal is to position itself optimally to maximize the #acr("ASR") performance.
Our approach solely relies on the positioning of the robot.
The #acr("ASR") algorithm that we use is an existing solution based on a #acr("DNN").
Our motivation relies on the observation that in a complex acoustic environment, the microphone's position and orientation with respect to the target source significantly impact the #acr("ASR") performance.
This insight results from an experimental study conducted within our simulated environment.


#draft[
  - Should we talk about MPC ?
  - Perceptually motivated navigation
  -> Maximize WER
  PESQ, WER
]

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
These quantities are then interpreted geometrically to be linked to the task objective, thus defining an interaction matrix $bold(J_s)$ satisfying
$
  bold(dot(s)) = bold(J_s) bold(u)
$
where $bold(dot(s))$ is the variation of the feature set and $bold(u)$ denotes the control signal.
$bold(u)$ is then inferred so as to minimize the error $bold(e)(t)$ to the target state $bold(s)^*$:
$
  bold(e)(t) = bold(s)(t) - bold(s)^*
$
The paper provides a detailed theoretical derivation of the auditory features, interaction matrices, and solving schemes.
This work thus adopts a feedback loop strategy to control the robot and does not involve any learning algorithm.
Finally, _AuralServo_ provides an interesting formulation for active robotic navigation problems and an analytical solution that could be demonstrated in real-world experiments.

Furthermore, a research group from UT Austin, led by Kirsten Grauman, has conducted pioneer work in this direction and achieved impressive results.
In their paper _SoundSpaces_ @chen_soundspaces_2020, Chen et al. define and solve the task of audio-visual navigation towards a sound source in complex environments.
Their contribution is twofold.
On the one hand, they introduce _SoundSpaces_, a dataset that extends existing realistic 3D environments with simulated audio renderings.
The environment uses the _Habitat_ simulator @savva_habitat_2019 alongside the _Matterport3D_ @chang_matterport3d_2017 and _Replica_ @straub_replica_2019 datasets that it includes.
This simulator provides only visual cues from its 3D representation of indoor spaces.
Chen et al. leveraged a geometrical acoustic method for room acoustic simulation consisting of bidirectional path tracing @cao_interactive_2016 to add auditory information to the simulator.
On the other hand, they designed a #acr("DRL") agent that can navigate in these challenging environments.
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
It is followed by two heads implementing the actor and the critic optimized by the #acr("PPO") algorithm.
The policy comprises two sub-policies: one for improving the separation quality when relatively close to the target source and an audio-visual navigation policy to get closer to it.
Both networks are trained in a cyclic pattern, ensuring continuous and synchronous overall performance improvement.
A convincing experimental study is also conducted to demonstrate the approach's effectiveness.
They propose two different benchmarks.
In the _near-target_ task, the agent starts relatively  close to the target sound source.
Here, it has to adjust its position to optimize for the separation score.
In the _far-target_ setting, the agent is initially placed further from the source of interest and has to navigate the environment to get close to it eventually.
This task variant targets leveraging audio-visual information to plan the shortest possible trajectory.
Overall, the _Move2Hear_ framework successfully applies #acr("DRL") to a robotic navigation problem where the objective is motivated by audio perception.



=== Problem formulation

// RL
We adopt a #acr("DRL") approach to design such a navigation policy.
This policy will be modeled by a Deep Neural Network trained in a simulated environment.
We develop a complete pipeline for solving the task of perceptually-motivated audio-based navigation.
The problem is framed as a sequential decision process, which suits the use of #acr("RL") well.
The implementation of the #acr("RL") environments, agents, algorithm and testing setup are an original contribution of this work.

// Sound only
Also, our solution tackles a challenging framework where only audio data can be used to perceive the environment.
The agent has neither visual cues nor direct spatial information, such as absolute or relative positions.
To address this limitation, we leverage the algorithms and knowledge obtained from our study of #acr("SSL").

In the following paragraphs, we will formalize the task that we plan to solve.
The core novelty of this problem is to use the #acr("ASR") performance as the reward signal.
First, we will introduce the relevant metric and its relation to speech recognition.
Second, the #acr("RL") environment will be presented, along with the justification for our different choices.


#reset-acronym("WER")
*#acr("WER") metric for #acr("ASR").*
The #acr("ASR") task consists of recognizing the words pronounced by a speaker from an audio record.
The #acr("WER") metric measures the performance of #acr("ASR") systems.
It is computed as follows:
$
  "WER" = (s + d + i) / n
$
where $s$ is the number of substitutions, $d$ of deletions, and $i$ of insertions needed to transform the true sentence into the predicted text.
$n$ counts the total number of words of the ground truth.
Hence, the #acr("WER") quantifies the original and transcribed text difference.
The total number of errors $s + d + i$ is also called the Levenshtein or edit distance, which Vladimir Levenshtein proposed in 1965 @levenshtein_binary_1965.
Its default formulation considers comparing two strings at the character level.
Besides, the #acr("WER") score uses words as the fundamental tokens.
As its definition is recursive, most implementations leverage dynamic computing.

*Running of an episode.*
An episode starts with the agent and one or several sources randomly placed in the room.
One source is considered as the target.
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
We will formalize the definition of the #acr("RL") environment in the following section.

==== Environment definition
<sec:rl:problem:formulation:environment>

The #acr("RL") environment corresponds to the #acr("MDP") formulation and implementation for the task.
In this section, we present those characteristics and the motivations that led to this final specification.

*#acr("POMDP").*
The original #acr("MDP") model is insufficient to represent our environment.
Instead, we rely on the #acr("POMDP") framework where the entirety of the state cannot be observed directly.
This choice allows the decoupling of the environment logic from the sensory observation available to the agent.
A #acr("POMDP") can be described as a tuple $lr(angle.l cal(S), cal(A), P, cal(R), Omega, O, gamma angle.r)$ where:
- $cal(S), cal(A), P$, $cal(R)$ and $gamma$ describe the underlying #acr("MDP");
- $Omega$ is the observation space; and
- $O: cal(S) times cal(A) -> Pi (Omega)$ is the _observability function_ which maps all state-action pairs to a probability distribution over the observation space $Omega$.
  $O(s', a, o)$ denotes the probability of making observation $o$ given that the agent took action $a$ and landed in state $s'$.
This definition and its notations have been borrowed from Leslie Kaelbling et al. @kaelbling_planning_1998.
She, along with her research group, has conducted groundbreaking work related to the comprehension and use of #acr("POMDP"), in particular in robotics.
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
Also, its orientation is restricted to be aligned with the grid, i.e. being either _up_, _down_, _left_, or _right_.
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
  )
$
<eq:rl:state_space>
where $x_i$ and $y_j$ denote the 2D position of the agent and $alpha$ its orientation with respect to the room global frame.
The position and orientation restrictions are enforced by the following action space $cal(A)$:
$
  cal(A) = {#stay, #forward, #left, #right}
$
<eq:rl:action_space>
- #stay is the neutral action where the agent does not move away from its current location.
- #forward means moving by a distance of $d$ meters in the current direction $alpha$.
The step size $d$ must correspond to the distance between two adjacent grid points.
- `TURN_LEFT` and `TURN_RIGHT` correspond to a quarter-turn rotation. In this case, only the orientation of the agent changes, not its position.
A learned policy for this problem will be a probabilistic distribution $pi(dot | dot): cal(A) times Omega -> [0, 1]$ over this finite set of four actions.

Although a continuous formulation would have been permitted by our audio simulator, choosing a discrete setting provides important benefits.
The most crucial one of them is the ability to pre-compute the reward.
Indeed, having a discrete state space allows for caching the reward function for all possible states.
As will be explained later in @sec:rl:method:wer_maps, our reward function is very computationally expensive.
On the other hand, having a finite action space enables working with equally finite policies $pi(a | s) = pi_a (s)$.
This choice permits the use of #acr("RL") algorithms modeling the Q-value such as #acr("DQN") methods @mnih_playing_2013.
Also, such a framing is both computationally and conceptually simpler.
#draft[
  Survey explaining differences between discrete and continuous action spaces: @zhu_overview_2021
]

*Observation space.*
The agent's perception of its environment is limited to the audio signal received by its microphones and does not know its current position.
This acoustic information consists of a one-second-long recorded signal mapped to the time-frequency domain.
Practically, the observations are #shape("C", "F", "T") real tensors where $C$ is the number of output channels, $F$ of frequency bins, and $T$ of temporal indices.
Formally, the observation space is $Omega = RR^(C times F times T)$.
The agent's goal is to learn a mapping $s -> pi(dot | s)$ from this space to the probabilities over actions.
This represents the essence of the audio-based navigation task: learning to decide how to move depending on what is heard.
The observability function translates the listening process.
Sound sources speak continuously.
At each step, the robot listens for $tau_"step"$ seconds while remaining immobile.
The random nature of the speech content delivered by each speech source accounts for the position-agnostic stochasticity of the observability function.
The rest of the process consists of the sound propagation and reverberation simulation.
By nature, there is no analytical closed-form expression of $O$.
It is directly embedded in the environment implementation.


*Reward function.*
The main originality of our approach lies in the perceptually motivated objective.
The agent should be trained to navigate to the optimal location regarding the #acr("ASR") performance.
Naturally, the reward function should be a decreasing function, $f: [0, 1] -> RR$, of the #acr("WER") metric so that the highest reward would correspond to the lowest possible #acr("WER").
For now, we assume having access to an oracle $w: cal(S) -> [0, 1]$ that maps each possible state to a #acr("WER") score.
The practical implementation of this mapping will be discussed later in @sec:rl:method:wer_maps.
The reward function can then be written as follows
$
  r_t = cases(
    -10  #h(3em) &"if the movement is invalid",
    f(w(s_t)) &"otherwise"
  )
$
The first case allows penalizing movements that would lead the robot to collide with a wall.
When the policy samples such an impossible action, it will be ignored by the environment, the agent will remain immobile for this step, and a fixed reward of $-10$ will be returned.
In practice, this only occurs for the for the forward action.

*Transition dynamics.*
Finally, to fully define our #acr("MDP") we need to provide the transition dynamics.
More precisely, we refer to the conditional probability $P(s' | s, a)$ of being in the state $s'$ when coming from the state $s$ and having performed action $a$.
Those dynamics are implemented by the simulator along with the observability function $O$.
In our case, they are completely deterministic due to their purely geometric nature.
Indeed, each action leads to a predictable change of the agent position $(x, y, alpha)$.
The transition dynamics can be expressed as the following deterministic function $t$ which maps a state-action pair to the next state:
#let x(content: $x$) = $colMath(content, #olive)$
#let y(content: $y$) = $colMath(content, #orange)$
#let s-alpha(content: $alpha$) = $colMath(content, #maroon)$
#func-def(
  $t$,
  $cal(S) times cal(A)$,
  $cal(S)$,
  $lr(((#x(), #y(), #s-alpha()), a), size: #130%)$,
  $
    cases(
      (#x(), #y(), #s-alpha())
        quad & "if" a = "STAY" | (a = "FORWARD" and a "is invalid"),
        
      (#x(content: $x + d cos(alpha)$), #y(content: $y + d sin(alpha)$), #s-alpha())
        quad & "if" a="TURN_RIGHT",
        
      (#x(), #y(), #s-alpha(content: $(alpha + pi/2 )[2pi]$))
        quad & "if" a="TURN_LEFT",
        
      (#x(), #y(), #s-alpha(content: $(alpha - pi/2 )[2pi]$))
        quad & "if" a="TURN_RIGHT",
    )
  $,
)
The collisions are detected before their execution so that the action can be denied.


==== Alternative continuous formulation

A spatially discrete solution has been proposed, where both the state and action spaces were finite.
Such a choice grants various benefits, such as an easier implementation and the possibility to use #acr("RL") methods unable to handle continuous spaces.

*Alternative #acr("POMDP").*
On the other hand, a more general continuous formulation can be described.
It would offer a more realistic modelization of the real-world problem.
Indeed, restricting a real robot to move exclusively on a grid is not sensible.
As an alternative, one could change the previously defined #acr("POMDP") as follows.
First, the state space would become $cal(S)_c = [0, L_x] times [0, L_y] times [0, 2pi] subset RR^3$.
Several choices are possible regarding the action space.
Although it would be possible to employ the original finite action space $cal(A)$, this solution would still restrict the set of reachable positions to a same-size 2D grid.
It would be rotated and translated accordingly to the initial position.
A more sensible choice would consist of sampling a distance and a rotation angle to parametrize a straight translation.
This would amount to the continuous action space $cal(A)_c = [0, d_max] times [0, 2pi]$.
Fully freeform movements would still not be possible, but this new space would allow for more expressive trajectories.
The current implementation of the simulator allows for easily extending the existing discrete environment to continuous variants.
The distinctions exposed here only impact the spatial properties of the #acr("MDP").
Audio aspects of the environment may remain the same.

*Reward computation.*
An additional obstacle to handling the continuous form of the problem lies in the reward computation.
Currently, it is fully pre-computed and cached using the #acr("WER") maps solution.
Keeping this paradigm is possible by interpolating the grid-evaluated reward function to compute the reward for arbitrary positions.

*Continuous audio simulation.*
Besides, the proposed framework makes the strong assumption that movements are instantaneous and that listening happens strictly statically.
Accounting for a continuously moving agent would participate to improve the model's realism further.
As the #acr("MDP") model remains fundamentally sequential, the agent would still make step-based decisions.
A hybrid solution consists of performing the audio simulation along a trajectory instead of assuming the position to be fixed.
Although such a feature is not supported by our simulator, the underlying _gpuRIR_ authors explain how it could be implemented (see section 3.4 @diaz-guerra_gpurir_2021).

*Algorithmic implications.*
The #acr("PPO") algorithm employed in this work is fully compatible with continuous state and action spaces.
Instead of predicting the probability $p_a$ of each discrete action, the actor neural network outputs the parameters $(bold(mu), bold(sigma) I)$ of a $dim(cal(A))$-dimensional normal distribution.
Petrazzini et al. @petrazzini_proximal_2021 alternatively propose to use the Beta distribution.
Compared to a Gaussian distribution, its main benefit is having a finite support that naturally fits bounded action spaces.
They also found the Beta distribution to outperform the Gaussian one.

In conclusion, the simple discrete formulation of the sound-driven navigation problem can be generalized to represent real-world robotic scenarios better.