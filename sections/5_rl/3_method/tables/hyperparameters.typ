#import "/utils.typ": *
#import "../../_notations.typ": *


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
    [$n_"iter"$], [Number of #acr("PPO") iterations], [100],
    [$n_"steps"$], [Number of transitions per batch], [2000],

    midrule,

    table.cell(rowspan: 3)[Loss],
    [#coef-value], [Loss value coefficient], [],
    [#coef-entropy], [Entropy coefficient], [#todo],
    [Value clipping], [], [Yes],
    
    midrule,
    
    table.cell(rowspan: 5)[Learning],
    [mini-batch size], [], [500],
    [$n_"epochs"$], [Number of epochs per iteration], [64],
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