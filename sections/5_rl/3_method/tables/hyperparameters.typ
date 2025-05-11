#import "/utils.typ": *
#import "../../_variables.typ": *

#set text(size: 10pt)

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

    table.cell(rowspan: 2)[Environment],
    [#env-horizon], [Horizon: number of steps per episode], [#env-horizon-value],
    [#n-source-pos], [Number of possible source positions], [#n-source-pos-value],

    midrule,
    
    table.cell(rowspan: 2)[General],
    [#n-ppo-iter], [Number of #acr("PPO") iterations], [100],
    [#n-ppo-steps], [Number of transitions per batch], [2000],

    midrule,

    table.cell(rowspan: 3)[Loss],
    [#ppo-loss-epsilon], [Clipping threshold for the clipped loss #ppo-clipped-loss], [#todo],
    [#coef-value], [Loss value coefficient], [],
    [#coef-entropy], [Entropy coefficient], [$10^(-2)$],
    [Value clipping], [], [Yes],
    
    midrule,
    
    table.cell(rowspan: 5)[Learning],
    [mini-batch size], [Number of samples (transitions) in each mini-batch], [500],
    [#n-ppo-epochs], [Number of epochs per iteration], [64],
    [Optimizer], [Used for optimizing the actor and critic networks], [Adam @kingma_adam_2017],
    [$eta$], [Learning rate], [$10^(-3)$],
    [Learning rate annealing], [Progressively decay the learning rate during training], [cosine annealing ($T_"max"=#n-ppo-epochs$)],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Final hyperparameter values used to train the #acr("PPO") algorithm.
  ]
)
<table:rl:method:hyperparameters>