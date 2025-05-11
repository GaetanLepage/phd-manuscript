#import "/utils.typ": *
#import "utils.typ": *
#import "../../_variables.typ": *


#figure(
  table(
    // SETTINGS
    columns: 5 * (1fr,),
    align: left + horizon,
    stroke: none,
    
    // HEADER
    toprule,

    table.header(
      table.cell(rowspan: 2)[Policy],
      table.cell(colspan: 2)[Omnidirectional cost],
      table.cell(colspan: 2)[Directional cost],
      mean-cum-reward-header,
      mfc-header,
      mean-cum-reward-header,
      mfc-header,
    ),

    midrule,

    [#pi-still], [#todo], [#todo], [#todo], [#todo],
    [#pi-random], [#todo], [#todo], [#todo], [#todo],
    [#pi-orient], [#todo], [#todo], [#todo], [#todo],
    [*#pi-theta*], [#todo], [#todo], [#todo], [#todo],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: flex-caption(
    short: [
      Benchmark of various policies' performance on the navigation task.
    ],
    long: [
      Benchmark of various policies' performance on the navigation task.
      Both omnidirectional and directional #acr("WER") cost environments have been tested.
      #pi-theta is our deep neural agent policy trained with #acr("PPO").
      #todo
    ],
  ),
)
<table:rl:results:wer_performance_vs_baselines>