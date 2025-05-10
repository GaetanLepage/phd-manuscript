#import "/utils.typ": *
#import "../../_variables.typ": *


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
    
    table.cell(rowspan: 2)[General],
    [#n-ppo-iter], [Number of #acr("PPO") iterations], [100],
    [#n-ppo-steps], [Number of transitions per batch], [2000],

    midrule,

    table.cell(rowspan: 3)[Loss],
    [#coef-value], [Loss value coefficient], [],
    [#coef-entropy], [Entropy coefficient], [#todo],
    [Value clipping], [], [Yes],
    
    midrule,
    
    table.cell(rowspan: 5)[Learning],
    [mini-batch size], [Number of samples (transitions) in each mini-batch], [500],
    [#n-ppo-epochs], [Number of epochs per iteration], [64],
    [Optimizer], [], [Adam @kingma_adam_2017],
    [$eta$], [Learning rate], [$10^(-3)$],
    [Learning rate annealing], [], [Yes],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    #todo
  ]
)
<table:rl:method:hyperparameters>