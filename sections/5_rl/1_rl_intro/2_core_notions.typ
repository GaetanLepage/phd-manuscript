#import "/utils.typ": *
#import "../_variables.typ": *

=== Core Notions
<sec:rl:intro:core_notions>

#acr("RL") encompasses various techniques for solving stochastic sequential decision problems.
This framework leverages trial-and-error learning by making an agent evolve in its environment while rewarding it according to its performance.
This feedback loop constitutes the reinforcement aspect and permits the agent to self-improve.
At each time step $t$, the agent is offered to observe the environment's state $s_t$.
It then has to select an action so as to maximize the future accumulated rewards.
In response to this action, the environment communicates the reward signal $r_t$ to the agent and transitions to a new state $s_(t+1)$ (@fig:rl:rl_intro:rl_schema).
This section briefly introduces the main concepts and notations required to further formalize this process and the relevant #acr("RL") algorithms.

#figure(
  image(
    "figures/rl_schema.svg",
    width: 50%,
  ),
  caption: [
    Reinforcement Learning framework
  ]
)
<fig:rl:rl_intro:rl_schema>


#reset-acronym("MDP")
*#acr("MDP").*
The stochastic sequential decision problems are modeled using the #acr("MDP") framework.
It is based on the work of Andrey Markov in the early 20th century about stochastic processes.
Notably, the Markov process defines a process in which future states only depend on the current state, but not on the sequence that preceded it.
Bellman later extended Markov processes to add a decision aspect, introducing the #acr("MDP") @bellman_dynamic_1957.
An #acr("MDP") consist of a tuple $<cal(S), cal(A), P, cal(R), gamma>$.
- $cal(S)$: The state space defines the set of all attainable states for the problem.
  Both discrete (finite or not) and continuous spaces are valid in this context.
- $cal(A)$: The action space is the mathematical space in which the agent's actions are defined. It may be discrete or continuous, and either bounded or unbounded. It can also be multi-dimensional, in which case it is typically expressed as the Cartesian product of simpler subspaces.
- $P$ defines the one-step dynamics of the environment.
  It denotes the probability that the agent will transition to state $s'$ while in state $s$ and taking action $a$.
  $P(s_(t+1) = s' mid(|) s_t = s, a_t = a)$ denotes the _transition probabilities_.
- $r$: The reward real-valued function $r: cal(S) times cal(A) -> cal(R)$ maps each state-action pair to its reward $r(s, a) in cal(R) subset RR$.
  When this reward is non-deterministic, we write $R_t$ its expectation:
  $
    R_t = EE[r_(t+1) mid(|) s_t = s, a_t = a, s_(t+1) = s'].
  $
- $gamma$: The discount factor in $[0, 1[$ dampens the impact of future rewards and ensures that the gain #box($G_t = sum_(k=0)^(infinity) gamma^k r_(t+k+1)$) remains bounded as long as $abs(R_t)$ is bounded as well.
  #chris[You should introduce the gain more properly instead of just in the discount factor. Optimizing the gain is the final goal of RL and it is the basis of the Value function.]


*Policy.*
The problem of Reinforcement Learning is to learn a policy that maximizes the average expected discounted return in a given #acr("MDP").
A policy denotes a function or algorithm that maps each state to a probability distribution over the action space.
#func-def(
  $pi(dot|dot)$,
  $cal(A) times cal(S)$,
  $[0, 1]$,
  $(a, s)$,
  $P(a_t = a | s_t = s).$,
)

The policy, being a distribution over the action space, can take various forms.
For finite #acrpl("MDP"), i.e. when both the action and state spaces are finite, the policy is a $abs(cal(S)) times abs(cal(A))$ matrix:
$
  lr(
    (
      P(a_t = a_i | s_t = s_j)
    ),
    size: #150%
  )_(
    1 <= i <= abs(cal(A)),\
    1 <= j <= abs(cal(S))
  ).
$
When dealing with continuous action spaces, most methods use a canonical distribution for which they learn the parameters.
Finding a policy amounts to learning a mapping from the state space to the distribution's parameter space.
For instance, the Gaussian distribution is often used in modern reinforcement learning.
Then, the method would associate a mean vector and a covariance matrix with each state.
A probabilistic policy can be used in two ways.
During reinforcement learning algorithms' training, the action is often selected by sampling the policy #box($a tilde pi (dot | s)$).
At test time, the most common choice is to pick the optimal action, i.e., the mode of the distribution:
$
  a^* = op("argmax", limits: #true)_(a in cal(A)) pi (a | s).
$
<eq:rl:intro:action_selection>


*Value function.*
The value function is a fundamental quantity in #acr("RL").
Given a policy $pi$, it measures the _quality_ of being in a specific state.
It is the expectation of future gains starting from the state $s$:
$
  #v-pi (s) &:= EE_pi [R_t | s_t = s]\
    &= EE_pi [sum_(k=0)^infinity gamma^k r_(t+k+1) mid(|) s_t = s].
$
<eq:rl:intro:value_function>
Naturally, this quantity depends on the considered policy $pi$.

*Q-function.*
#draft[We also introduce it in the PGA section]
$
  #q-pi (s, a) &:= EE_pi [R_t | s_t = s, a_t = a]\
    &= EE_pi [sum_(k=0)^infinity gamma^k r_(t+k+1) mid(|) s_t = s, a_t = a].
$
<eq:rl:intro:q_function>