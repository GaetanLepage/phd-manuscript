#import "/utils.typ": *

=== Reinforcement Learning
<sec:rl:intro:rl>

Reinforcement Learning draws its origins in two formerly distinct fields.
On the one hand, psychology researchers have attempted to understand how humans and animals could learn.
The American psychologist Edward Lee Thorndike laid out foundational work on animal learning and behavior.
In his 1911 book _Animal Intelligence: Experimental studies_ @thorndike_animal_1911, Thorndike presented a collection of experiments involving animals solving different tasks.
He wanted to understand the core principles and mechanisms allowing the subjects to adapt and finally adapt to the problem they were facing.
Observing animal reactions and abilities, he inferred the fundamentals of behaviorism and the trial-and-error theory.
For instance, he put hungry cats in cages, and to escape and reach food placed outside, they had to solve a puzzle.
He noticed that the animals did not overcome the difficulties through insight or understanding but through repeated trial and error.
He noticed that successful behaviors were reinforced, leading to quicker escapes, while unsuccessful behaviors were abandoned.
From these observations, Thorndike developed the _Law of Effect_, which states that behaviors that lead to satisfying outcomes are more likely to happen again.
On the contrary, actions leading to unpleasant consequences are discouraged, and their frequency decreases.
This law has two essential aspects.
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