#import "/utils.typ": *
#import "../_variables.typ": *

=== Policy Gradient Algorithms
<sec:rl:intro:policy_gradient_algorithms>

Early reinforcement learning algorithms primarily focused on value-based methods, where the agent learns to estimate a value function that guides action selection.
A notable example is Q-learning @watkins_learning_1989, which iteratively approximates the Q-function (as defined in @eq:rl:intro:q_function) and derives a policy by acting greedily with respect to it.

In contrast, policy gradient methods aim to optimize the policy directly by maximizing a differentiable objective function with respect to the policy parameters.
Rather than relying on value estimates to induce a policy, these methods treat the policy itself as a parameterized function $pi_theta$​ and compute gradients of the expected return with respect to $theta$.
The objective is typically to maximize the expected return $J(theta)$, defined as:
$
  J(theta)
  &= EE_(tau ~ pi_theta) [R(tau)]\
  &= sum_(s in cal(S)) d_(pi_theta) (s) V_pi (s)\
  &= sum_(s in cal(S)) d_(pi_theta) (s) pi_theta (a  | s) Q_(pi_theta) (s, a),
$
<eq:rl:intro:pg_algorithms:expected_return>
This decomposition expresses the expected return as a weighted sum over states and actions, where $d_pi_theta (s)$ is the stationary state distribution under policy $pi_theta$​.
$R(tau)$ denotes the return of the trajectory $tau$, also referred to as the cumulative reward.
The final line expands the value function using the policy and Q-function, which will be instrumental in deriving the policy gradient.
Most policy gradient algorithms rely on maximizing this objective using gradient ascent algorithms.
This process results in an optimal set of weights $theta^*$ leading to the highest return.
However, computing the gradient of $J$ directly can be complex.
The policy gradient theorem offers a tractable expression for this gradient that avoids the need to differentiate through the environment's dynamics.

Several policy gradient algorithms have been developed and successfully used in conjunction with deep neural networks.
Our main focus will be on the #acr("PPO") algorithm @schulman_proximal_2017, but other notable methods include #acr("DDPG") @lillicrap_continuous_2019, #acr("SAC") @haarnoja_off-policy_2018 and #acr("TRPO") @schulman_trust_2017.
A key advantage of policy gradient approaches over value-based methods like Q-learning is their ability to handle both discrete and continuous action spaces naturally.

In the next section, we present the Policy Gradient Theorem, which underpins all such algorithms and provides the theoretical foundation for computing policy updates via gradient ascent.

==== Policy Gradient Theorem

//#draft[Lilian Weng @noauthor_policy_2018]
Sutton & Barto @sutton_reinforcement_2018 present the Policy Gradient theorem as a fundamental result enabling policy gradient algorithms.
It provides a tractable expression for the gradient of the expected return under a differentiable stochastic policy.
Let $pi_theta (a | s)$ be a differentiable policy and $J(theta)$ the expected return (@eq:rl:intro:pg_algorithms:expected_return).
Then:
$
  nabla_theta J(theta) =
    EE_(s~ d_(pi_theta), a~pi_theta) [
      nabla_theta log pi_theta (a | s) Q_(pi_theta)(s, a)
    ]
$
<eq:rl:intro:policy_gradient_theorem>

#include "policy_gradient_theorem_proof.typ"

This result shows that policy gradients can be estimated using samples from the environment without requiring gradients through the environment's dynamics.
In practice, $#q-pi-theta (s, a)$ is often replaced by the empirical return $G_t$​, an advantage estimate, or a separately learned value function


==== Advantage Estimation
<sec:rl:intro:policy_gradient_algos:gae>

In the policy gradient expression given by the theorem (@eq:rl:intro:policy_gradient_theorem), the expected return is weighted by the Q-function.
However, estimating $#q-pi (s, a)$ directly can be challenging in practice due to its high variance, especially when using sample-based estimates.
To address this, many policy gradient algorithms rely on advantage functions, which capture how much better (or worse) an action is compared to the average action at a given state.

*Advantage function.*
The advantage function is defined as:
$
  A^pi (s_t, a_t) := Q^pi (s_t, a_t) - V^pi (s_t),
$
This formulation provides a more targeted signal for learning: instead of reinforcing actions that are merely good in absolute terms, it favors those that are better than expected.
The use of advantage estimates has become standard in modern actor-critic algorithms.

*Estimation.*
Estimation of the advantage function was discussed by Schulman et al. @schulman_high-dimensional_2018.
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
The variance increases with $k$, as each additional term $r_(t+k)$ introduces more uncertainty into the estimator.

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
<eq:rl:intro:gae_def>
where $gamma$ is the #acr("MDP")'s discount factor and $lambda$ is a hyperparameter that controls the estimator's bias-variance tradeoff.
When $lambda=0$, #acr("GAE") reduces to a one-step temporal difference estimate (similar to $"TD"(0)$), which has low variance but may be biased due to relying heavily on the learned value function.
When $lambda=1$, it approximates a Monte Carlo return by summing full future rewards, yielding an unbiased but high-variance estimate.
By tuning $lambda$, one can interpolate between these extremes, making #acr("GAE") a versatile and effective estimator.

It can be shown that @eq:rl:intro:gae_def simplifies to:
$
  hat(A)_t^("GAE"(gamma, lambda))
    = sum_(k=0)^(infinity)
    (lambda gamma)^k delta_(t + k) ^V.
$
Therefore, the #acr("GAE") estimator is the exponentially-decayed sum of rewards.
In practice, it has become a standard component in modern actor-critic methods, such as #acr("PPO") @schulman_proximal_2017 and A3C @mnih_asynchronous_2016.

#reset-acronym("PPO")
==== The #acr("PPO") Algorithm
<sec:rl:intro:ppo>

#acr("PPO") is a widely adopted reinforcement learning algorithm known for its balance between implementation simplicity and robust performance.
It has been effectively applied in various domains, including robotics and autonomous navigation @taheri_deep_2024.
For instance, PPO has been utilized to train mobile robots for safe navigation in complex environments, demonstrating improved stability and obstacle avoidance capabilities.
Additionally, PPO has been employed in multi-robot systems to optimize path planning and reduce navigation time through effective conflict resolution strategies.

*#acr("TRPO").*
Schulman et al. @schulman_trust_2017 introduced the concept of trust region policy optimization.
They observed that overly aggressive policy updates were causing instabilities in training #acr("PG") algorithms.
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
  ) lt.eq xi,
$
for a given threshold $xi$.
$hat(A)_t$ is the advantage estimate at time step $t$.
This objective can be rewritten using a penalty term.
It boils down to maximizing:
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
Bick @bick_towards_2021 offers a comprehensive and accessible dissection of #acr("PPO"), bridging theoretical foundations with practical implementation details.

The #acr("PPO") objective combines three components: a clipped policy loss, a value function loss, and an optional entropy bonus.
The clipped policy loss is defined as:
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

The second component of the loss is the value function loss, typically a squared error between the predicted value and the empirical return:
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

Finally, the #acr("PPO") loss entails an entropy bonus, which encourages exploration by maximizing the policy's entropy:
$
  #ppo-entropy-bonus = sum_(a in cal(A)) pi_theta (a | s_t) log [pi_theta (a | s_t)].
$

The final #acr("PPO") loss can finally be expressed as:
$
  #ppo-loss _t (theta) = 
  hat(EE)_t lr(
    [
      #ppo-clipped-loss-theta
      - #coef-value #ppo-value-loss-theta
      + #coef-entropy #ppo-entropy-bonus
    ],
    size: #140%
  ),
$ <eq:rl:ppo_loss>
where #coef-value and #coef-entropy are coefficients that weight the value function loss and entropy bonus, respectively, relative to the policy loss.
These are treated as hyperparameters.
This formulation is the most common in the literature and software implementations of #acr("PPO").
Although often denoted as the #acr("PPO") _loss_, this function quantifies the objective and should thus be maximized.

*Algorithm.*
To optimize the #acr("PPO") objective, the algorithm involves iteratively sampling training data by running the policy in the environment and training the actor and critic networks.
While
Each iteration starts by freezing the neural network parameters $theta$ and collecting a set of trajectories #ppo-traj-buffer by running the current policy $pi_theta$ in the environment.
This sampling phase ends with the computation of the advantages $hat(A)_t$ with the #acr("GAE") process presented in @sec:rl:intro:policy_gradient_algos:gae, and the returns $R_t$.
The second part of the iteration is where the learning occurs.
The actor and critic networks are optimized by maximizing the overall #acr("PPO") objective #ppo-loss (@eq:rl:ppo_loss).
This is most often done with a stochastic gradient optimizer such as Adam @kingma_adam_2017 or #acr("SGD"). @algo:rl:ppo gives the pseudo-code for the #acr("PPO") algorithm.

#include "ppo_algorithm.typ"