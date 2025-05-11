#import "/utils.typ": colMath

// Environment
#let a-stay = `STAY`
#let a-forward = `FORWARD`
#let a-left = `TURN_LEFT`
#let a-right = `TURN_RIGHT`
#let env-horizon = $T$

// PPO loss
#let ppo-clipped-loss = $colMath(L_t^"CLIP" (theta), #maroon)$
#let ppo-value-loss = $colMath(L_t^"VF" (theta), #olive)$
#let ppo-entropy-bonus = $colMath(S[pi_theta](s_t) , #eastern)$
//#let ppo-loss = $L_t ^("CLIP" + "VF" + "S")$
#let ppo-loss = $L^"PPO"$
#let coef-value = $c_V$
#let coef-entropy = $c_S$
#let policy-ratio = $rho_t$
#let policy-ratio-exp = $(pi_theta (a_t | s_t)) / (pi_theta_"old" (a_t | s_t))$

#let wer-map = $cal(W)$
#let source-pos = $bold(x)_s$
#let agent-pos = $bold(x)_a$
#let agent-ori = $theta_a$
#let agent-source-doa = $"DoA"(bold(x)_a, #agent-ori, #source-pos)$
#let agent-source-dist = $D_"source"$
#let agent-source-dist-expr = $norm(#source-pos - #agent-pos)_2^2$
#let agent-source-final-dist = $D_F$
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
#let reward-wall-penalty-value = 1000
// Forward penalty
#let reward-movement-penalty = $mu_m$
#let reward-movement-penalty-value = 10

// Hyperparameters
#let delta-grid = $delta_"grid"$
#let n-ep = $n_"ep"$
#let n-ppo-iter = $n_"iter"$
#let n-ppo-steps = $n_"steps"$
#let n-ppo-epochs = $n_"epochs"$
#let n-ppo-minibatch = $n_"mini-batch"$
#let ppo-mini-batch = $T$
//#let ppo-mini-batch-size = $abs(#ppo-mini-batch)$
#let ppo-mini-batch-size = $b_"size"$

#let ppo-traj-buffer = $cal(T)$
#let n-forwards = $n_"forwards"$

// Policies
#let pi-theta = $pi_theta$
#let pi-optimal = $pi^*$
#let pi-still = $pi_"still"$
#let pi-orient = $pi_"orient"$
#let pi-random = $pi_"random"$

// Metrics
#let mfc = $hat(C)_F$
#let mean-cum-reward = $macron(R)$