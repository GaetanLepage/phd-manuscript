#import "/utils.typ": *
#import "../_variables.typ": *

=== Policy Gradient Algorithms
<sec:rl:intro:policy_gradient_algorithms>

The first widely used #acr("RL") algorithms consisted of learning to approximate a value function.
For instance, the notable Q-value algorithm @watkins_learning_1989 introduced the $Q$ function which gives a score to each state-action pair:
$
  Q^(pi_theta) (s, a) := EE[G_t | s_t = s, a_t = a].
$ #draft[répétition avec l'eq and 5.1.2]
On the contrary, policy gradient algorithms optimize the policy directly, through a differentiable objective function depending on its parameters.
The cost function is expressed as: #draft[TODO Isn't there a log in the formula?]
$
  J(theta)
  &= EE_(tau ~ pi_theta) [R(tau)]\
  &= sum_(s in cal(S)) d_(pi_theta) (s) V_pi (s)\
  &= sum_(s in cal(S)) d_(pi_theta) (s) pi_theta (a  | s) Q_(pi_theta) (s, a),
$
where $d_pi_theta (s)$ corresponds to the stationary distribution of Markov chain for $pi_theta$, i.e., the on-policy state distribution under $pi_theta$.
Most policy gradient algorithms rely on maximizing this objective using gradient ascent algorithms.
This process results in an optimal set of weights $theta^*$ leading to the highest return.
However, computing the gradient of $J$ is not trivial and can become intractable as the action space grows in dimensionality.

Several policy gradient have been developped and used in conjunction with deep learning models.
Our main focus will remain on the #acr("PPO") algorithm @schulman_proximal_2017, but #acr("DDPG") @lillicrap_continuous_2019, #acr("SAC") @haarnoja_off-policy_2018 and #acr("TRPO") @schulman_trust_2017 are other notable examples.
The core advantage of policy gradient algorithms over Q-learning is their ability to handle both discrete and continuous action spaces.

==== Policy Gradient Theorem

//#draft[Lilian Weng @noauthor_policy_2018]
Sutton & Barto @sutton_reinforcement_2018 present the Policy Gradient theorem as a fundamental result enabling policy gradient algorithms.
It rewrites the gradient of the objective $J(theta)$ as:
$
  nabla_theta J(theta)
    &= nabla_theta
      sum_(s in cal(S)) d_(pi_theta) (s)
      sum_(a in cal(A)) Q^(pi_theta) (s, a) pi_theta (a | s)\
    &prop
      sum_(s in cal(S)) d_(pi_theta) (s)
      sum_(a in cal(A)) Q^(pi_theta) (s, a) nabla_theta pi_theta (a | s),
$
<eq:rl:intro:policy_gradient_theorem>
where:
- $pi_theta$ is the policy parametrized by the set of parameters $theta$;
- $tau$ is a trajectory, i.e., a sequence of states, actions, and rewards;
- $R(tau)$ is the return of the trajectory $tau$, also referred to as the cumulative reward.

*Proof:*
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
      + pi (a | s) nabla_theta sum_(s' in S, r in cal(R) #todo) P(s', r | s, a) (r + V^pi (s'))
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

==== Advantage Estimation
<sec:rl:intro:policy_gradient_algos:gae>

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
#draft[TODO: remove when I will have added the definition in a previous section]


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
While all those quantities approximate $A_t$, they offer different tradeoffs.
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
  ),
$
where $gamma$ is the #acr("MDP")'s discount factor and $lambda$ is a hyperparameter that controls the estimator's bias-variance tradeoff.
It can be shown that this expression simplifies to:
$
  hat(A)_t^("GAE"(gamma, lambda))
    = sum_(k=0)^(infinity)
    (lambda gamma)^k delta_(t + k) ^V.
$
The #acr("GAE") estimator is therefore the exponentially-decayed sum of rewards.



#reset-acronym("PPO")
==== The #acr("PPO") Algorithm
<sec:rl:intro:ppo>

The #acr("PPO") algorithm has been used extensively in the #acr("RL") field since its invention in 2017 @schulman_proximal_2017.
#draft[give examples]
Its main advantages are its relative simplicity and efficiency.
It is claimed to be more stable than other algorithms, especially for continuous action spaces @schulman_proximal_2017.
#todo

*#acr("TRPO").*
Schulman et al. @schulman_trust_2017 introduced the concept of trust region policy optimization.
Their observation was that too brutal policy updates were causing instabilities in training #acr("PG") algorithms.
The #acr("TRPO") algorithm seeks to constrain the policy to a _trust region_, preventing it from evolving too drastically at each step.
The notion of distance for policy updates is the #acr("KL") divergence.
The #acr("TRPO") objective is to maximize the expected advantage while keeping the #acr("KL") divergence between the old and new policy below a certain threshold.
This translates to maximizing:
$
  L^"TRPO" (theta) = hat(EE)_t [
      (pi_theta (a_t | s_t))
      /
      (pi_theta_"old" (a_t | s_t))
    
    hat(A)_t
  ]
$
subject to
$
  hat(EE)_t lr(
    [
      "KL" [
        pi_theta_"old" (dot | s_t),
        pi_theta (dot | s_t),
      ]
    ],
    size: #140%
  ) lt.eq delta,
$
for a given threshold $delta$.
$hat(A)_t$ is the advantage estimate at timestep $t$.
This objective can be rewritten using a penalty term.
It boils down to maximizing
$
  hat(EE)_t [
    (pi_theta (a_t | s_t))
    /
    (pi_theta_"old" (a_t | s_t))
    hat(A)_t

    - beta "KL" [
      pi_theta_"old" (dot | s_t),
      pi_theta (dot | s_t)
    ]
  ]
$
for some coefficient $beta$.

In practice, #acr("TRPO") approximates the #acr("KL") constraint with its second-order Taylor expansion.
This requires computing the Fisher Information Matrix, translating into a quadratic optimization problem.
Because it is a constrained problem, first-order optimizers like Adam or #acr("SGD") cannot be used, and the objective is thus optimized using conjugate gradient optimization.
These practical limitations make #acr("TRPO") training computationally expensive.



*#acr("PPO").*
In @schulman_proximal_2017, Schulman et al. iterate on #acr("TRPO") by proposing the #acr("PPO") algorithm, which solves most of the original algorithm's shortcomings.
Its main innovation is replacing the #acr("KL") divergence constraint with a clipped surrogate objective, which prevents too-large policy updates without second-order optimization.
This choice slightly loosens the constraint that #acr("TRPO") imposes but significantly decreases the optimization's computational complexity.

The #acr("PPO") objective combines three components: a clipped policy loss, a value function loss, and an optional entropy bonus.
The *clipped policy loss* is defined as:
$
  #ppo-clipped-loss-theta = min lr([
    #policy-ratio (theta) hat(A)_t,
    "clip"(
      #policy-ratio (theta),
      1 - epsilon,
      1 + epsilon,
    ) hat(A)_t
  ], size: #140%),
$
<eq:rl:intro:ppo:policy_loss>
where $#policy-ratio (theta)$ is the ratio between the old and new policy for the state $s_t$:
$
  #policy-ratio (theta) = #policy-ratio-exp.
$
The clipping function prevents large updates when the new policy diverges too far from the old one, thus preserving stability.
This constitutes the primary innovation of #acr("PPO") over #acr("TRPO") as it enforces a constraint on the policy update size without the need to deal with an explicitly constrained optimization problem.

The second component of the loss is the *value function loss*, typically a squared error between the predicted value and the empirical return:
$
  #ppo-value-loss-theta = lr(
    [
      V_theta (s_t) - R_t
    ],
    size: #140%
  )^2,
$
<eq:rl:intro:ppo:value_loss>
where $V_theta (s_t)$ is the predicted state value and $R_t$ is the estimated return.
$R_t$ can be derived via the aforementioned #acr("GAE") estimator.

Finally, the #acr("PPO") loss entails an *entropy bonus*, which encourages exploration by maximizing the policy's entropy:
$
  #ppo-entropy-bonus = sum_(a in cal(A)) pi_theta (a | s_t) log [pi_theta (a | s_t)].
$

#block(breakable: false)[
The final #acr("PPO") loss can finally be expressed as:
$
  #ppo-loss _t (theta) = 
  hat(EE)_t lr([
    #ppo-clipped-loss-theta
    - #coef-value #ppo-value-loss-theta
    + #coef-entropy #ppo-entropy-bonus
  ], size: #140%),
$ <eq:rl:ppo_loss>
where #coef-value and #coef-entropy are coefficients that weight the value function loss and entropy bonus, respectively, relative to the policy loss.
These are treated as hyperparameters.
This formulation is the most common in the literature and software implementations of #acr("PPO").
Although often denoted as the #acr("PPO") _loss_, this function quantifies the objective and should thus be maximized.
]

*Algorithm.*
To optimize the #acr("PPO") objective, the algorithm involves iteratively sampling training data by running the policy in the environment and training the actor and critic networks.
While
Each iteration starts by freezing the neural network parameters $theta$ and collecting a set of trajectories #ppo-traj-buffer by running the current policy $pi_theta$ in the environment.
This sampling phase ends with the computation of the advantages $hat(A)_t$ with the #acr("GAE") process presented in @sec:rl:intro:policy_gradient_algos:gae, and the returns $R_t$.
The second part of the iteration is where the learning occurs.
The actor and critic networks are optimized by maximizing the overall #acr("PPO") objective #ppo-loss (@eq:rl:ppo_loss).
This is most often done with a stochastic gradient optimizer such as Adam @kingma_adam_2017 or #acr("SGD"). @algo:rl:ppo gives the pseudo-code for the #acr("PPO") algorithm.

#include "ppo_algorithm.typ"