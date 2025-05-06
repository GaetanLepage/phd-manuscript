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
- $cal(A)$: The action space is the mathematical space in which the agent's actions are defined. It may be discrete or continuous, and either bounded or unbounded. It can also be multi-dimensional, in which case it is typically expressed as the Cartesian product of simpler subspaces.
- $P$ defines the one-step dynamics of the environment.
  It denotes the probability that the agent will transition to state $s'$ while in state $s$ and taking action $a$.
  $P(s_(t+1) = s' mid(|) s_t = s, a_t = a)$ denotes the _transition probabilities_.
- $r$: The reward real-valued function $r: cal(S) times cal(A) -> cal(R)$ maps each state-action pair to its reward $r(s, a) in cal(R) subset RR$.
  When this reward is non-deterministic, we write $R_t$ its expectation:
  $
    R_t = EE[r_(t+1) mid(|) s_t = s, a_t = a, s_(t+1) = s'].
  $
- $gamma$: The discount factor in $[0, 1[$ dampens the impact of future rewards and ensures that the gain #box($G_t = sum_(k=0)^(infinity) gamma^k r_(t+k)$) remains bounded as long as $abs(R_t)$ is bounded as well.


*Policy.*
The problem of Reinforcement Learning is to design a policy that maximizes the average expected return in a given #acr("MDP").
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
Finding a policy amounts to learning a mapping from the state space to the parameter space of the distribution.
For instance, the Gaussian distribution is often used in modern reinforcement learning for this purpose.
Then, the method would associate a mean vector and, eventually, a covariance matrix to each state.
A probabilistic policy can be used in two ways.
During reinforcement learning algorithms' training, the action is often selected by sampling the policy #box($a tilde pi (dot | s)$).
At test time, the most common choice is to pick the optimal action, i.e. the mode of the distribution:
$
  a^* = op("argmax", limits: #true)_(a in cal(A)) pi (a | s).
$


*Value function.*
The value function is a fundamental quantity in #acr("RL").
Given a policy $pi$, it measures the _quality_ of being in a certain state.
It is defined as the expectation of future gains when starting from the state $s$.
$
  V_pi (s) &:= EE[G_t | s_t = s]\
    &= EE[sum_(k=0)^infinity gamma^k r_(t+k+1) mid(|) s_t = s].
$
Naturally, this quantity depends on the considered policy $pi$.




=== Deep Reinforcement Learning
<sec:rl:intro:deep_reinforcement_learning>

Although #acr("RL") has existed since the 1970s, it has experienced a more recent and considerable surge in popularity @arulkumaran_deep_2017.
As supervised learning and the machine learning field in general, #acr("RL") has benefited from the possibilities offered by Deep Neural Networks.
Traditionally, #acr("RL") leveraged simpler methods such as tabular methods @watkins_learning_1989 @sutton_learning_1988, linear function approximators, or shallow neural networks @barto_neuronlike_1983 @tesauro_temporal_nodate.
The main problem of those approaches for policy modeling is their limited capacity to handle larger state and action spaces.
Hence, #acr("RL") has been mainly limited to low-dimensional problems @arulkumaran_deep_2017.
As #acrpl("MDP") become more intricate, the memory, computation, and, more importantly, sample complexities grow significantly.
#acrpl("DNN") offered a capable scaling method and have been successfully used as function approximators @arulkumaran_deep_2017 @wang_deep_2024.

The first applications of artificial neural networks to #acr("RL") occurred in the 1990s.
For instance, the popular REINFORCE algorithm by Williams @williams_simple_1992 employed a shallow network that is optimized using gradient descent.
However, the major success awaited Deep Learning's boom pf the 2010s.
Mnih et al. @mnih_playing_2013 have famously demonstrated the capacity of those more modern models.
They combined Watkin's Q-value algorithm @watkins_learning_1989 to a deep convolutional neural network.
To showcase the capabilities of their method, the authors tackled seven Atari 2600 games from the Arcade Learning Environment @bellemare_arcade_2013.
Performance surpassed existing benchmarks and, notably, human performance in six of those games.
This work acted as a foundation for the entire #acr("RL") domain and started the highly dynamic era of #acr("DRL").
Since then, larger and larger networks have been combined with advances made on the algorithmic aspects.

Nevertheless, scaling #acr("DRL") models up requires significant amounts of training data.
This translates into the need for environments that can provide tens of thousands of interactions at a tractable cost.
Mnih et al. used around 10 million frames of each game to train their #acr("DQN") agents.
The OpenAI Five @berner_dota_nodate project consists of training an agent to play the game Dota 2.
In total, their agent has played for an approximate duration of 180 years.
Similarly, when applying #acr("DRL") to autonomous driving, collecting a high amount of interactive experience is necessary to achieve decent performance.
Bansal et al. @bansal_chauffeurnet_2018 have used a dataset of 30 million samples to train their policy.
They stated that their initial attempts at imitation learning on this data were unsuccessful.
Finally, it required more advanced techniques to train a working system.



#draft[TODO: give an example in autonomous driving]
Sample efficiency has been 

#draft[
  Cite more papers (if possible that I have not yet cited in the intro)
]

*Games.*
Board games or video games are suitable candidates for #acr("DRL") techniques.
They are intrinsically operated virtually, allowing for scalable training data generation.
Contrary to applications in robotics, they do not require any special transfer techniques to a real target environment.
Also, some games are by nature easy, constrained problems were achieving an optimal policy is sometimes easily feasible.
As such, they have been used as toy examples or benchmark tasks to evaluate #acr("RL") algorithms.
The Atari #todo


*#acr("RLHF").*
Finally, #acr("RLHF") helps turning #acrpl("LLM") into conversational agents @ouyang_training_2022 @bai_training_2022 @deepseek-ai_deepseek-r1_2025.
At first, large-scale auto-regressive models such as GPT-3 @brown_language_2020 are trained on massive datasets in a supervised manner.
Then, human agents interact with the resulting _chat bot_ and express their preferences between several answers generated by the chatbot.
These preference expressions are used to generate a reward signal.
The initial model then gets fine-tuned using a #acr("DRL") algorithm such as #acr("PPO") @schulman_proximal_2017 to account for the obtained feedback.



=== #acr("RL") for robotics

By its very nature, robotics has always been one of the main applications of #acr("RL").
Robots are fundamentally incarnated as they interact with the real physical world.
As such, trial-and-error learning strategies have been a logical, human-inspired approach to robotics.

*Earlier works.*
Historically, robotics has been studied from the perspective of control theory.
This area of research involves designing a controller for a given system.
This involves formally modeling the said system first.

Before #acr("RL") to 

Robotics has been one of the domains targeted by A.I. researchers to apply Deep Reinforcement Learning

// "Navigating the Practical Pitfalls of Reinforcement Learning for Social Robot Navigation"
@pikuli_navigating_2024


- @kober_reinforcement_2013, Kober et al., Reinforcement Learning in Robotics: A Survey (Jan Peters)
- Ibarz et al. @ibarz_how_2021
- Sünderhauf et al. @sunderhauf_limits_2018: The Limits and Potentials of Deep Learning for Robotics
- Lathuillière RL for AV gaze-control @lathuiliere_neural_2019

#draft[
  Benchmarks on real-world robotics tasks
  @mahmood_benchmarking_2018

  How to Train Your Robot with Deep Reinforcement Learning – Lessons We’ve Learned
  @ibarz_how_2021
]


=== Policy gradient algorithms

The first widely used #acr("RL") algorithms consisted of learning to approximate a value function.
For instance, the notable Q-value algorithm @watkins_learning_1989 introduced the $Q$ function which gives a score to each state-action pair:
$
  Q_pi (s, a) := EE[G_t | s_t = s, a_t = a].
$
On the contrary, policy gradient algorithms directly optimize the policy itself through a differentiable objective function depending on its parameters.
#todo

In 2001, Kakade et al. @kakade_natural_2001 improved the traditional policy gradient framework by introducing the concept of _Natural Gradient_.
It uses the Fisher information matrix in the policy update rule.
This choice is supposed to take into account the curvature of the parameter space and thus allow more efficient training.
In addition to the theoretical arguments advanced by the authors, this schema has been shown to be empirically superior to the more conventional gradient optimization 
It has shown to be 



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
      sum_(a in cal(A)) Q^pi (s, a) nabla_theta pi_theta (a | s).
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
    ].
    #todo
$

==== Advantage estimation

Policy gradient methods

Schulman et al. @schulman_high-dimensional_2018

*Advantage function.*
The advantage function is defined as:
$
  A^pi (s_t, a_t) := Q^pi (s_t, a_t) - V^pi (s_t),
$
where,
- $V^pi (s_t) := EE_(s_(t+1:infinity), \ a_(t:infinity)) [ sum_(i=0)^(+infinity) r_(t+i) ]$,
- $Q^pi (s_t, a_t) := EE_(s_(t+1:infinity), \ a_(t+1:infinity)) [ sum_(i=0)^(+infinity) r_(t+i) ]$.


*Estimation.*
Estimation of the advantage function has been discussed by Schulman et al. @schulman_high-dimensional_2018.
To estimate the advantage function, we may consider the following class of estimators $hat(A)_t^((k))$:
$
  &hat(A)_t^((1))
    &&:= delta_t^V
    &&= r_t + gamma   V(s_(t+1)) - V(s_t)\
  
  &hat(A)_t^((2))
    &&:= delta_t^V + gamma delta_(t+1)^V
    &&= r_t + gamma r_(t+1) + gamma^2 V(s_(t+2)) - V(s_t)\
  
  & dots
    &&:= dots
    &&= dots\
  
  &hat(A)_t^((infinity)) &&:= sum_(l=0)^(infinity) gamma^l delta_(t+l)^V &&= r_t + gamma r_(t+1) + gamma^2 r_(t+2) + dots - V(s_t),
$
where $delta_t^V$ estimates the #acr("TD") error.
While all of those quantities do approximate $A_t$, they offer different tradeoffs.
Indeed, as $V(s_t)$ is not the exact value function $V^(pi, gamma)$ for this policy, the estimator is biased.
However, this bias decreases when $k -> + infinity$ as the term $V(s_(t+k))$ becomes increasingly dampened.
$V(s_t)$ remains constant among the class of estimators and thus does not affect the relative bias of $hat(A)_t^((k))$.
Although being asymptotically unbiased, $hat(A)_t^((infinity))$ has a high variance.
The estimator's variance is an increasing function of $k$ as more and more terms $r_(t+k)$ are summed as $k$ grows.

*#acr("GAE").*
Schulman et al. @schulman_high-dimensional_2018 proposed a novel estimation method by combining all the estimators $hat(A)_t^((k))$ into a single one.
More precisely, the #acr("GAE") is an exponentially weighted average of the aforementioned $k$-step estimators.
$
  hat(A)_t^("GAE"(gamma, lambda)) :=
  (1 - lambda) (
    hat(A)_t^((1))
    + hat(A)_t^((2))
    + hat(A)_t^((3))
    + dots
  ).
$
#block(breakable: false)[
  It can be shown that this expression simplifies as:
  $
    hat(A)_t^("GAE"(gamma, lambda))
      = sum_(k=0)^(infinity)
      (lambda gamma)^k delta_(t + k) ^V.
  $
]
#todo



#reset-acronym("PPO")
==== The #acr("PPO") algorithm
<sec:rl:intro:ppo>

The #acr("PPO") algorithm has been used extensively in the #acr("RL") field since its invention in 2017 @schulman_proximal_2017.
#draft[give examples]
Its main advantages are its _apparent_ simplicity and efficiency.
Although it has been successful at solving many complex #acr("RL") problems, #acr("PPO") remains highly sensitive to implementation details.
Engstrom et al. @engstrom_implementation_2020 explicitly studied the "code-level optimizations" of the #acr("TRPO") and #acr("PPO") algorithms.
This work formalized the shared impression among the community #draft[insert refs] that #acr("PPO")'s promised performance was subject to subtle implementation details.
Huang et al. have also contributed to this practical investigation by publishing _The 37 Implementation Details of Proximal Policy Optimization_ @shengyi2022the37implementation.
#draft[Maybe this should go in the results/discussion section.]
#draft[@mahmood_benchmarking_2018 talk about the sensitivity of #acr("RL") algorithms to their HP]

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
  ], size: #140%),
$ <eq:rl:ppo_loss>

where:
- #l-clip
- #l-vf
- #entropy

#draft[ /!\\ This is the objective (to *maximize*)]

#draft[
  Examples of application, success stories
]