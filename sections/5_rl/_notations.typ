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

// Reward
#let reward-exp-alpha = $alpha_C$
#let reward-exp-beta = $beta_C$
#let reward-wall-penalty = $mu_W$
#let reward-forward-penalty = $mu_F$
#let reward-alpha-value = 100
#let reward-beta-value = 4

#let wer-map = $cal(W)$
#let cost = $C$
#let cost-t = $cost_t$
#let wer-cost = $cost_"WER"$
#let analytical-cost = $tilde(cost)$
#let delta-grid = $delta_"grid"$
#let n-ep = $n_"ep"$

