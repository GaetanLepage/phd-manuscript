#import "/utils.typ": *
#import "../../_variables.typ": *

#set text(size: 11pt)

#figure(
  table(
    // SETTINGS
    columns: 4,
    align: left + horizon,
    stroke: none,
    
    // HEADER
    toprule,

    table.header(
      [Type],
      [Name],
      [Description],
      [Value],
    ),
    
    midrule,

    table.cell(rowspan: 4)[Environment],
    [#env-horizon], [Horizon: number of steps per episode], [#env-horizon-value],
    [#n-source-pos], [Number of possible source positions], [#n-source-pos-value],
    [$gamma$], [Reward discount factor], [#discount-factor-value],
    [#delta-grid], [Grid spatial resolution], [0.5m],

    midrule,
    
    table.cell(rowspan: 2)[General],
    [#n-ppo-iter], [Number of #acr("PPO") iterations], [#n-ppo-iter-value],
    [#n-ppo-steps], [Number of transitions per batch], [2000],

    midrule,

    table.cell(rowspan: 5)[Loss],
    [$lambda_"GAE"$], [Bias–variance trade-off parameter for the #acr("GAE")], [0.95],
    [#ppo-loss-epsilon], [Clipping threshold for the clipped loss #_ppo-clipped-loss], [0.2],
    [#ppo-value-loss-epsilon], [Clipping threshold for the clipped value loss #ppo-value-loss-clipped], [0.1],
    [#coef-value], [Loss value coefficient], [0.5],
    [#coef-entropy], [Entropy coefficient], [$10^(-2)$],
    
    midrule,
    
    table.cell(rowspan: 4)[Learning],
    [mini-batch size], [Number of samples (transitions) in each mini-batch], [500],
    [#n-ppo-epochs], [Number of training epochs per iteration], [64],
    [Optimizer], [Used for optimizing the actor and critic networks], [Adam],
    [$eta$], [Learning rate], [$10^(-3)$],
    //[$T_max$], [Maximum number of iterations for learning rate cosine annealing], [$#n-ppo-iter = #n-ppo-iter-value$],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: text(size: 12pt)[
    Final hyperparameter values used to train the PPO algorithm.
  ]
)
<table:rl:method:hyperparameters>