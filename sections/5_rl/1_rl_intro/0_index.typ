#import "/utils.typ": *

== Introduction to Reinforcement Learning
<sec:rl:intro>

=== Reinforcement Learning

#draft[
  @sutton_reinforcement_2018 (the book)
]

#acr("MDP")

=== Deep Reinforcement Learning

@li_deep_2018 (#acr("DRL"), An overview)

=== #acr("RL") for robotics

// TODO Cite Jordan&Dimiter's survey paper


=== Policy gradient algorithms

#draft[
  Introduce PG algorithms:
  The concept, the theorem and give a few examples
]

==== Policy Gradient Theorem

Sutton & Barto @sutton_reinforcement_2018
Lilian Weng @noauthor_policy_2018

$
  nabla_theta J(theta) &=
    nabla_theta
      sum_(s in cal(S)) d^pi (s)
      sum_(a in cal(A)) Q^pi (s, a) pi_theta (a | s)\
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
