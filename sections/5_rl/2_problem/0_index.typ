#import "/utils.typ": *
#import "../_notations.typ": *

== Sound-driven robot navigation
<sec:rl:problem>

=== Motivation

Social robotics imply various technical and scientific problems involving computer vision, mechatronics, sociology, natural language processing or speech processing.
Robot navigation stands as one of such crucial tasks.
Numerous formulations of this question exist and they encompass different goals, sensory information, and target robotics platforms.
//Although processing


#draft[
  - Should we talk about MPC ?
  - Perceptually motivated navigation
  -> Maximize WER
  PESQ, WER
]

=== Background

- _SoundSpaces_ @chen_soundspaces_2020
- _Move2Hear_ @majumder_move2hear_2021


=== Problem formulation

#draft[
  - We solve is using RL -> need for an environment\
    TODO: justify why we use RL. Isn't that weird to talk about RL in 5.1 and then to justify using it after in 5.2 ?
  - discrete step-based stochastic process.
  - Agent moves, listens to audio, and decides where to go next.
]

#reset-acronym("WER")
*#acr("WER") metric for #acr("ASR").*
The #acr("ASR") task consists of recognizing the words pronounced by a speaker from an audio record.
The performance of #acr("ASR") systems is evaluated by the #acr("WER") metric.
It is computed as follows:
$
  "WER" = (s + d + i) / n
$
where $s$ is the number of substitutions, $d$ of deletions, and $i$ of insertions needed to transform the true sentence into the predicted text.
$n$ counts the total number of words of the ground truth.
Hence, the #acr("WER") quantifies the difference between the original and transcribed text.
The total number of errors $s + d + i$ is also called the Levenshtein or edit distance, proposed by Vladimir Levenshtein in 1965 @levenshtein_binary_1965.
Its default formulation considers comparing two strings at the character level.
Besides, the #acr("WER") score uses words as the fundamental tokens.
As its definition is recursive, most implementations leverage dynamic computing.

*Running of an episode.*
An episode starts with the agent and one or several sources randomly placed in the room.
#todo #draft[the running of an episode]

==== Environment definition
<sec:rl:problem:formulation:environment>

The #acr("RL") environment corresponds to the #acr("MDP") formulation and implementation for the task.
In this section, we present those characteristics and the motivations that led to this final specification.

*#acr("POMDP").*
The original #acr("MDP") model is not sufficient to represent our environment.
Instead, we rely on the #acr("POMDP") framework where the entirety of the state cannot be observed directly.
This choice allows the decoupling of the environment logic from the sensory observation available to the agent.
A #acr("POMDP") can be described as a tuple $lr(angle.l cal(S), cal(A), P, cal(R), Omega, O, gamma angle.r)$ where:
- $cal(S), cal(A), P$, $cal(R)$ and $gamma$ describe the underlying #acr("MDP");
- $Omega$ is the observation space; and
- $O: cal(S) times cal(A) -> Pi (Omega)$ is the _observability function_ which maps all state-action pairs to a probability distribution over the observation space $Omega$.
  $O(s', a, o)$ denotes the probability of making observation $o$ given that the agent took action $a$ and landed in state $s'$.
This definition along with its notations have been borrowed from Kaelbling et al. @kaelbling_planning_1998.
Leslie Kaelbling has conducted groundbreaking work related to the comprehension and use of #acr("POMDP"), in particular in robotics.

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
  cal(A) = {
    #stay,
    #forward,
    #left,
    #right
  }
$
<eq:rl:action_space>
- #stay is the neutral action where the agent does not move away from its current location.
- #forward means moving by a distance of $d$ meters in the current direction $alpha$.
The step size $d$ must correspond to the distance between two adjacent grid points.
- `TURN_LEFT` and `TURN_RIGHT` correspond to a quarter-turn rotation. In this case, only the orientation of the agent changes but not its position.
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
The goal of the agent will be to learn a mapping $s -> pi(dot | s)$ from this space to the probabilities over actions.
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
Accounting for a continuously moving agent would participate to further improve the model's realism.
As the #acr("MDP") model remains fundamentally sequential, the agent would still be performing step-base decisions.
A hybrid solution consists of performing the audio simulation along a trajectory instead of assuming the position to be fixed.
Although such a feature is not supported by our simulator, the underlying _gpuRIR_ authors explain how it could be implemented (see section 3.4 @diaz-guerra_gpurir_2021).

*Algorithmic implications.*
The #acr("PPO") algorithm employed in this work is fully compatible with continuous state and action spaces.
Instead of predicting the probability $p_a$ of each discrete action, the actor neural network outputs the parameters $(bold(mu), bold(sigma) I)$ of a $dim(cal(A))$-dimensional normal distribution.
Petrazzini et al. @petrazzini_proximal_2021 alternatively propose to use the Beta distribution.
Its main benefit compared to a Gaussian distribution is having a finite support that naturally fits bounded action spaces.
They also found the Beta distribution to outperform the Gaussian one.

In conclusion, the simple discrete formulation of the sound-driven navigation problem can be generalized to represent real-world robotic scenarios better.