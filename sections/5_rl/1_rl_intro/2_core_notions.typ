#import "/utils.typ": *
#import "../_variables.typ": *

=== Core Notions
<sec:rl:intro:core_notions>

#acr("RL") encompasses various techniques for solving stochastic sequential decision problems.
It leverages trial-and-error learning by making an agent evolve in its environment while rewarding it according to its performance.
This feedback loop constitutes the reinforcement aspect and permits the agent to self-improve.
At each time step $t$, the agent observes the current state $s_t$ of the environment.
It then has to select an action so as to maximize the future accumulated rewards.
In response to this action, the environment communicates the reward signal $r_t$ to the agent and transitions to a new state $s_(t+1)$ (@fig:rl:rl_intro:rl_schema).
This section briefly introduces the main concepts and notations required to formalize this process further and the relevant #acr("RL") algorithms.

#figure(
  image(
    "figures/rl_schema.svg",
    width: 50%,
  ),
  caption: [
    Reinforcement Learning framework.
  ]
)
<fig:rl:rl_intro:rl_schema>


#reset-acronym("MDP")
*#acr("MDP").*
The stochastic sequential decision problems are modeled using the #acr("MDP") framework @sutton_reinforcement_2018.
It is based on the work of Andrey Markov in the early 20th century about stochastic processes.
Notably, the Markov process defines a process in which future states only depend on the current state, but not on the sequence that preceded it.
Bellman later extended Markov processes to add a decision aspect, introducing the #acr("MDP") @bellman_dynamic_1957.
An #acr("MDP") consists of a tuple $<cal(S), cal(A), P, r, gamma>$.
- $cal(S)$: The state space defines the set of all attainable states for the problem.
  Both discrete (finite or not) and continuous spaces are valid in this context.
- $cal(A)$: The action space is the mathematical space in which the agent's actions are defined. It may be discrete or continuous, and either bounded or unbounded. It can also be multi-dimensional, in which case it is typically expressed as the Cartesian product of simpler subspaces.
- $P$ defines the one-step dynamics of the environment.
  It denotes the probability that the agent will transition to state $s'$ while in state $s$ and taking action $a$.
  $P(s_(t+1) = s' mid(|) s_t = s, a_t = a)$ denotes the _transition probabilities_.
- $r$: The reward real-valued function $r: cal(S) times cal(A) times cal(S) -> RR$ maps each state-action pair to its reward $r(s, a, s')$.
  In some environments, the reward might solely depend on the next state: $r(s')$.
  The reward may also be non-deterministic, in which case we take its expectation.
  //When this reward is non-deterministic, we write $R_t$ for its expectation:
  //$
  //  R_t = EE[r_(t+1) mid(|) s_t = s, a_t = a, s_(t+1) = s'].
  //$
- $gamma$: The discount factor in $[0, 1)$ dampens the impact of future rewards.

*Expected Return Maximization.*
The agent seeks to maximize the cumulative discounted rewards it collects over time.
This objective is formalized as the return:
$
  G_t = sum_(k=0)^infinity gamma ^k r_(t+k+1).
$
Here, $r_(t+k+1)$ is the reward obtained after taking action $a_(t+k)$ in state $s_(t+k)$, leading to state $s_(t+k+1)$.
Discounting models the idea that immediate rewards are more valuable than distant ones, and helps prioritize short-term gains while still accounting for long-term outcomes.
It also ensures that the return remains bounded as long as the reward function is bounded too.
The agent's goal is to learn a policy $pi$ that maximizes the expected return $EE_pi [G_t]$, averaged over trajectories it generates through interaction with the environment.
$gamma$ denotes the previously introduced #acr("MDP") discount factor.

*Policy.*
The policy denotes a function or algorithm that maps each state to a probability distribution over the action space.
//#func-def(
//  $pi(dot|dot)$,
//  $cal(A) times cal(S)$,
//  $[0, 1]$,
//  $(a, s)$,
//  $P(a_t = a | s_t = s).$,
//)
#func-def(
  $pi$,
  $cal(S)$,
  $cal(P)(cal(A))$,
  $s$,
  $pi(dot | s).$,
)

As a distribution over the action space, the policy can take various forms.
For finite #acrpl("MDP")s, i.e., when both the action and state spaces are finite, the policy is a $abs(cal(S)) times abs(cal(A))$ matrix:
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
When dealing with continuous action spaces, most methods use classical probability distributions for which they learn the parameters.
Finding a policy amounts to learning a mapping from the state space to the distribution's parameter space.
A common choice in modern #acr("RL") is the Gaussian distribution, where the policy assigns a mean vector and covariance matrix to each state.
A probabilistic policy can be used in two ways.
During reinforcement learning algorithms' training, the action is often selected by sampling the policy #box($a tilde pi (dot | s)$).
This ensures exploration during training.
At test time, the agent picks the optimal action, i.e., the one with the highest probability:
$
  a^* = op("argmax", limits: #true)_(a in cal(A)) pi (a | s).
$
<eq:rl:intro:action_selection>


*Value function.*
The value function is a fundamental quantity in #acr("RL").
Given a policy $pi$, it measures the _quality_ of being in a specific state and following this policy.
It is the expectation of future gains starting from the state $s$:
$
  #v-pi (s) &:= EE_pi [G_t | s_t = s]\
    &= EE_pi [sum_(k=0)^infinity gamma^k r_(t+k+1) mid(|) s_t = s].
$
<eq:rl:intro:value_function>
Naturally, this quantity depends on the considered policy $pi$.
The value function is central to #acr("RL").
It quantifies the long-term desirability of being in a particular state under a given policy.
A state with high value is one from which the agent expects to collect large cumulative rewards in the future.
This notion underlies many #acr("RL") algorithms, especially those that evaluate and improve policies by estimating how good it is to visit certain states.

*Q-function.*
The action-value function or Q-function quantifies the expected return for taking action $a$ in state $s$, and thereafter following policy $pi$:
$
  #q-pi (s, a) &:= EE_pi [G_t | s_t = s, a_t = a]\
    &= EE_pi [sum_(k=0)^infinity gamma^k r_(t+k+1) mid(|) s_t = s, a_t = a].
$
<eq:rl:intro:q_function>
The Q-function extends the concept of value by also conditioning on the action taken in the current state.
This provides a more fine-grained assessment of decision quality, as it reflects not just the quality of a state but also the quality of a specific action within that state.
Q-functions are particularly useful in algorithms that seek to learn optimal policies directly from action-value estimates, such as Q-learning @watkins_learning_1989 and many actor-critic methods @haarnoja_off-policy_2018.
Together, the value function and Q-function offer complementary perspectives: the former evaluates states globally, while the latter provides localized guidance for action selection because we can define a policy based on it: $a^* = "argmax"_(a in cal(A)) Q(s, a)$.

These foundational concepts — the #acr("MDP") formalism, return maximization, policies, and value functions — form the theoretical basis for modern reinforcement learning algorithms.
The following section examines how these ideas scale through deep function approximation and lead to robust learning systems capable of solving complex, high-dimensional tasks.