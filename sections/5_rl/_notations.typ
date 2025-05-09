#import "/utils.typ": colMath

#let a-stay = `STAY`
#let a-forward = `FORWARD`
#let a-left = `TURN_LEFT`
#let a-right = `TURN_RIGHT`

// PPO loss
#let ppo-clipped-loss = $colMath(L_t^"CLIP" (theta), #maroon)$
#let ppo-value-loss = $colMath(L_t^"VF" (theta), #olive)$
#let ppo-entropy-bonus = $colMath(S[pi_theta](s_t) , #eastern)$
#let coef-value = $c_V$
#let coef-entropy = $c_S$

#let wer-map = $cal(W)$
#let cost = $C$
#let cost-t = $cost_t$
#let wer-cost = $cost_"WER"$
#let analytical-cost = $tilde(cost)$
#let analytical-cost-t = $tilde(cost)$

// Reward
#let f-reward = $f$
#let reward-exp-alpha = $alpha_C$
#let reward-alpha-value = 100
#let reward-exp-beta = $beta_C$
#let reward-beta-value = 4
#let f-reward-exp = $#reward-exp-alpha exp[- #reward-exp-beta #cost-t]$
// wall-penalty
#let reward-wall-penalty = $mu_W$
#let reward-wall-penalty-value = $mu_W$
// Forward penalty
#let reward-forward-penalty = $mu_F$
#let reward-forward-penalty-value = 10

// Hyperparameters
#let delta-grid = $delta_"grid"$
#let n-ep = $n_"ep"$
