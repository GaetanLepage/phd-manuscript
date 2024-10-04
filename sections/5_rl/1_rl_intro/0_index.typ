#import "/utils.typ": *

== Introduction to Reinforcement Learning
<sec:rl:intro>

=== Reinforcement Learning

==== Brief history

Reinforcement Learning draws its origins in two formerly distinct fields.
On the one hand, psychology researchers have attempted to understand how humans and animals could learn.
The American psychologist Edward Lee Thorndike laid out foundational work on animal learning and behavior.
In his 1911 book _Animal Intelligence: Experimental studies_ @thorndike_animal_1911, Thorndike presented a collection of experiments involving animals solving different tasks.
He wanted to understand the core principles and mechanisms allowing the subjects to adapt and finally adapt to the problem they were facing.
Observing animal reactions and abilities, he inferred the fundamentals of behaviorism and the theory of trial and error.
For instance, he put hungry cats in cages, and in order to escape and reach food placed outside, they had to solve a puzzle.
He noticed that the animals did not overcome the difficulties through insight or understanding but rather through repeated trial and error.
He noticed that successful behaviors were reinforced, leading to quicker escapes over time, while unsuccessful behaviors were abandoned.
From these observations, Thorndike developed the _Law of Effect_, which states that behaviors that lead to satisfying outcomes are more likely to happen again.
On the contrary, actions leading to unpleasant consequences are discouraged and see their frequency decrease.
This law has two important aspects.
On the one hand, trial-and-error learning is _selectional_, as the subject tries different alternatives to identify the optimal one.
On the other hand, it is _associative_ as the selected decisions are associated with particular situations.
This principle stands as a core ingredient of modern theories of learning and behavior modification.
The idea of learning progressively and gradually from substantial experience contrasts with the theories stating that animals learn from higher-level reasoning, similar to humans.
In 1927, Ivan Pavlov detailed the concept of trial-and-error in _Conditioned reflexes: An investigation of the physiological activity of the cerebral cortex_ @pavlov_1927_conditioned_2010.
Pavlov described reinforcement as the strengthening of a pattern of behavior due
to an animal receiving a stimulus—a reinforcer—in an appropriate temporal relationship
with another stimulus or with a response @sutton_reinforcement_2018.
All in all, psychology, by observing animal behaviors has provided the intuition behind the formulation of #acr("RL") as a framework to solve complex decision problems.

On the other hand, #acr("RL") has been preceded by the older field of optimal control.
Its objective is to design a controller for a dynamic system that should minimize some cost function.
Richard Bellman has conducted essential work on this problem, notably by introducing dynamic programming @bellman_dynamic_1957 and the notorious Bellman equation.
Dynamic programming is the most general and feasible solution to optimal control problems but suffers from limitations.
For instance, when the number of dimensions of the involved control spaces grows too large, they suffer from the curse of dimensionality, which Bellman himself describes.
#reset-acronym("MDP")
He is also at the origin of the discrete stochastic version of the optimal control problem, called #acr("MDP") @bellman_markovian_1957.
Those concepts served as foundations of modern reinforcement learning theory and algorithms.

#acr("TD") learning can be seen as another building block of the #acr("RL") field.
#acr("TD") learning methods involve leveraging the difference between successive estimates of a given quantity.
Although this concept was first introduced by Arthur Samuel (1959) @samuel_studies_1959 and Hyman Minsky (1961) @minsky_steps_1961, it has not been directly applied in practice.
In 1972, Harry Klopf @klopf_brain_1972 combined #acr("TD") learning and trial-and-error in its theory of _heterostasis_.
Klopf's theory was pursued further by Richard Sutton.
For instance, in 1988, Sutton used temporal-difference learning as a standalone prediction method @sutton_learning_1988.
He also extended the principle of #acr("TD") learning by inventing the TD$(lambda)$ approach.
This extension bridges the gap between Monte Carlo methods (which wait until the end of an episode to update values) and one-step TD learning, providing a more flexible framework for #acr("RL").
Chris Watkins is responsible for a major breakthrough in #acr("RL") by having introduced Q-learning (1989) @watkins_learning_1989.
This algorithm constitutes a simple solution to the optimization of an #acr("MDP").
Its tabular approach consists of learning the expected future rewards for taking a particular action in a given state.
The definitive proof for the Q-learning algorithm @watkins_q-learning_1992 ensures its almost certain convergence to the optimal action-values.

Although this short introduction is far from being exhaustive, it helps to put more recent advances in context.
Reinforcement Learning has indeed significantly evolved since its infancy.
Both new ideas and computational advances have allowed its use in more and more contexts and applications.
The book _Reinforcement Learning: An Introduction_ @sutton_reinforcement_2018 by Sutton and Barto is one of the most complete and recognized resources about the field.
It provides both a deep look at the theoretical grounds of #acr("RL") and a wide overview of modern algorithms.
The original 1998 edition was revisited in 2018 to reflect the important progress made during this period.
The present section draws substantial inspiration from this resource.


==== Core notions

#acr("RL") encompasses various techniques for solving stochastic sequential decision problems.
This framework leverages trial-and-error learning by making an agent evolve in its environment while rewarding it according to its performance.
This feedback loop constitutes the reinforcement aspect and permits the agent to self-improve.
At each time step $t$, the agent is offered to observe the environment's state $s_t$.
It then has to select an action so as to maximize the future accumulated rewards.
In response to this action, the environment communicates the reward signal $r_t$ to the agent and transitions to a new state $s_(t+1)$ (@fig:rl:rl_intro:rl_schema).
In this section, we briefly introduce the main concepts and notations required to further formalize this process and the relevant #acr("RL") algorithms.

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
*#acr("MDP")*
The stochastic sequential decision problems are modeled using the #acr("MDP") framework.
It is based on the work of Andrey Markov in the early 20th century about stochastic processes.
Notably, the Markov process defines a process in which future states only depend on the current state but not on the sequence that preceded it.
Bellman later extended Markov processes to add a decision aspect, leading to the introduction of the #acr("MDP") @bellman_dynamic_1957.
An #acr("MDP") consist of a tuple $<cal(S), cal(A), P, cal(R), gamma>$.
- $cal(S)$: The state space defines the set of all attainable states for the problem.
  Both discrete (finite or not) and continuous spaces are valid in this context.
- $cal(A)$: 
- $P$ defines the one-step dynamics of the environment.
  It denotes the probability that the agent will transition to state $s'$ while in state $s$ and taking action $a$.
  $P(s_(t+1) = s' mid(|) s_t = s, a_t = a)$ denotes the _transition probabilities_.
- $r$: The reward real-valued function $r: cal(S) times cal(A) -> cal(R)$ maps each state-action pair to its reward $r(s, a) in cal(R) subset RR$.
  When this reward is non-deterministic, we write $R_t$ its expectation:
  $
    R_t = EE[r_(t+1) mid(|) s_t = s, a_t = a, s_(t+1) = s']
  $
- $gamma$: The discount factor in $[0, 1[$ dampens the impact of future rewards and ensures that the gain $G_t = sum_(k=0)^(infinity) gamma^k R_(t+k)$ remains bounded as long as $abs(R_t)$ is bounded as well.


*Policy.*
The problem of Reinforcement Learning is to design a policy that maximizes the average expected return in a given #acr("MDP").
A policy denotes a function or algorithm that maps each state to a probability distribution over the action space.
#func-def(
  $pi(dot|dot)$,
  $cal(A) times cal(S)$,
  $[0, 1]$,
  $(a, s)$,
  $P(a_t = a | s_t = s)$,
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
  )
$
When dealing with continuous action spaces, most methods use a canonical distribution for which they learn the parameters.
Finding a policy amounts to learning a mapping from the state space to the parameter space of the distribution.
For instance, the Gaussian distribution is often used in modern reinforcement learning for this purpose.
Then, the method would associate a mean vector and, eventually, a covariance matrix to each state.
A probabilistic policy can be used in two ways.
During the training of reinforcement learning algorithms, the action is often selected by sampling the policy $a tilde pi (dot | s)$.
At test time, the most common choice is to pick the optimal action, i.e. the mode of the distribution $a^* = "argmax"_(a in cal(A)) pi (a | s)$


*Value function.*
The value function is a fundamental quantity in #acr("RL").
Given a policy $pi$, it measures the _quality_ of being in a certain state.

$
  V_pi (s) &:= EE[R_t | s_t = s]\
    &= EE[sum_(k=0)^infinity gamma^k r_(t+k+1) mid(|) s_t = s]
$


=== Deep Reinforcement Learning
<sec:rl:intro:deep_reinforcement_learning>

@li_deep_2018 (#acr("DRL"), An overview)

@mnih_playing_2013 (Deep Q-networks)

=== #acr("RL") for robotics

// TODO Cite Jordan&Dimiter's survey paper


=== Policy gradient algorithms

The first widely used #acr("RL") algorithms consisted of learning to approximate a value function.
For instance, the notable Q-value algorithm @watkins_learning_1989 introduced the $Q$ function which gives a score to each state-action pair:
$
  Q_pi (s, a) := EE[r_t | s_t = s, a_t = a]
$


#draft[
  Introduce PG algorithms:
  - Handles both discrete and continuous spaces
  - The concept, the theorem and give a few examples
]

==== Policy Gradient Theorem

#draft[Lilian Weng @noauthor_policy_2018]
Presented by Sutton & Barto @sutton_reinforcement_2018, the Policy Gradient theorem is a fundamental result enabling policy gradient algorithms.

$
  nabla_theta J(theta)
    //&= nabla_theta
    //  sum_(s in cal(S)) d^pi (s)
    //  sum_(a in cal(A)) Q^pi (s, a) pi_theta (a | s)\
    &prop
      sum_(s in cal(S)) d^pi (s)
      sum_(a in cal(A)) Q^pi (s, a) nabla_theta pi_theta (a | s)\
$

Proof:

$
  nabla_theta V^pi (s)
  &= nabla_theta
    (sum (a in cal(A)) pi (a | s) Q^pi (s, a))\
    
  &= sum_(a in cal(A)) lr(
    [
      nabla_theta pi (a | s) Q^pi (s, a)
      + pi (a | s) nabla_theta Q^pi (s, a)
    ],
    size: #200%
  )\
  
  &= sum_(a in cal(A)) [
      nabla_theta pi (a | s) Q^pi (s, a)
      + pi (a | s) nabla_theta sum_(s' in S, r in cal(R)) P(s', r | s, a) (r + V^pi (s'))
  ]\
  
  &= sum_(a in cal(A)) [
      nabla_theta pi (a | s) Q^pi (s, a)
      + pi (a | s) sum_(s' in S, r in cal(R)) P(s', r | s, a) nabla_theta V^pi (s')
  ]\
  
  &= sum_(a in cal(A)) [
      nabla_theta pi (a | s) Q^pi (s, a)
      + pi (a | s) sum_(s' in S) P(s' | s, a) nabla_theta V^pi (s')
  ]\
$

==== Advantage estimation

Policy gradient methods

Schulman et al. @schulman_high-dimensional_2018

*Advantage function.*
The advantage function is defined as:
$
  A^pi (s_t, a_t) := Q^pi (s_t, a_t) - V^pi (s_t)
$
where,
- $V^pi (s_t) := EE_(s_(t+1:infinity), \ a_(t:infinity)) [ sum_(i=0)^(+infinity) r_(t+i) ]$
- $Q^pi (s_t, a_t) := EE_(s_(t+1:infinity), \ a_(t+1:infinity)) [ sum_(i=0)^(+infinity) r_(t+i) ]$


*Estimation.*

*#acr("GAE").*

#reset-acronym("PPO")
==== The #acr("PPO") algorithm
<sec:rl:intro:ppo>

*#acr("TRPO").*
Schulman et al. @schulman_trust_2017

*#acr("PPO").*
@schulman_proximal_2017

#let l-clip = $colMath(L_t^"CLIP" (theta), #maroon)$
#let l-vf = $colMath(L_t^"VF" (theta), #olive)$
#let entropy = $colMath(S[pi_theta](s_t) , #eastern)$
$
  L_t ^("CLIP" + "VF" + "S") (theta) = 
  hat(EE)_t lr([
    #l-clip
    - c_1 #l-vf
    + c_2 #entropy
  ], size: #140%)
$ <eq:rl:ppo_loss>

where:
- #l-clip
- #l-vf
- #entropy

#draft[ /!\\ This is the objective (to *maximize*)]

#draft[
  Examples of application, success stories
]
