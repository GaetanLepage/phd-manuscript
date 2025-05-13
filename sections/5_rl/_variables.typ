#import "/utils.typ": colMath

// RL
#let v-pi = $V^pi$
#let v-pi-theta = $V^(pi_theta)$
#let q-pi = $Q^pi$
#let q-pi-theta = $Q^(pi_theta)$

// Environment
#let a-stay = `STAY`
#let a-forward = `FORWARD`
#let a-left = `TURN_LEFT`
#let a-right = `TURN_RIGHT`
#let env-horizon = $T$
#let env-horizon-value = 32
#let n-source-pos = $n_"source pos"$
#let n-source-pos-value = 12
#let dim-features-value = 128

// PPO loss
#let _ppo-clipped-loss = $L_t^"CLIP"$
#let ppo-clipped-loss = $colMath(#_ppo-clipped-loss, #maroon)$
#let ppo-clipped-loss-theta = $colMath(#_ppo-clipped-loss (theta), #maroon)$
#let _ppo-value-loss = $L_t^"VF"$
#let ppo-value-loss = $colMath(#_ppo-value-loss, #olive)$
#let ppo-value-loss-theta = $colMath(#_ppo-value-loss (theta), #olive)$
#let ppo-value-loss-clipped = $L_t^"VF, CLIPPED"$
#let ppo-value-loss-clipped-theta = $#ppo-value-loss-clipped (theta)$
#let v-theta
#let ppo-entropy-bonus = $colMath(S[pi_theta](s_t) , #eastern)$
//#let ppo-loss = $L_t ^("CLIP" + "VF" + "S")$
#let ppo-loss = $L^"PPO"$
#let ppo-loss-epsilon = $epsilon$
#let ppo-value-loss-epsilon = $epsilon_V$
#let coef-value = $c_V$
#let coef-entropy = $c_S$
#let policy-ratio = $rho_t$
#let policy-ratio-exp = $(pi_theta (a_t | s_t)) / (pi_theta_"old" (a_t | s_t))$

#let wer-map = $cal(W)$
#let L-x = $L_x$
#let L-y = $L_y$
#let delta-grid = $delta_"grid"$
#let n-x-exp = $floor(L_x/#delta-grid)$
#let n-y-exp = $floor(L_y/#delta-grid)$
#let source-pos = $bold(x)_s$
#let agent-pos = $bold(x)_a$
#let agent-ori = $alpha_a$
#let agent-source-doa = $"DoA"(bold(x)_a, #agent-ori, #source-pos)$
#let agent-source-dist = $D_"source" (#agent-pos, #source-pos)$
#let agent-source-dist-expr = $norm(#source-pos - #agent-pos)_2^2$
#let agent-source-final-dist = $D_F$
#let cost = $C$
#let cost-t = $cost_t$
#let wer-cost = $cost_"WER"$
#let asr-net = $T_psi$
#let asr-dataset = $cal(D)$
#let analytical-cost = $tilde(cost)$
#let analytical-cost-t = $tilde(cost)$

// Reward
#let f-reward = $f$
#let reward-exp-alpha = $eta_C$
#let reward-alpha-value = 100
#let reward-exp-beta = $xi_C$
#let reward-beta-value = 4
#let f-reward-exp = $#reward-exp-alpha exp[- #reward-exp-beta #cost-t]$
// wall-penalty
#let reward-wall-penalty = $mu_W$
#let reward-wall-penalty-value = 1000
// Forward penalty
#let reward-movement-penalty = $mu_m$
#let reward-movement-penalty-value = 10

// Hyperparameters
#let n-ep = $n_"ep"$
#let n-rep = $n_"rep"$
#let n-ppo-iter = $n_"iter"$
#let n-ppo-iter-value = 100
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
#let mfd = $hat(D)_F$
#let mfae = $hat(theta)_F$
#let mean-cum-reward = $macron(R)$