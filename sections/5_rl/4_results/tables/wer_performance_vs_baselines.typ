#import "/utils.typ": *
#import "utils.typ": *
#import "../../_variables.typ": *
#import "_data.typ": *

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

    // Omnidirection: exp300
    // Directional: exp301

    [#pi-still], [1481], [21.13], [1512], [21.37],
    [#pi-random], [38], [21.27], [37], [22.32],
    [#pi-safe-random], [], [], [], [],
    [#pi-orient], [1484], [21.02], [1783], [16.75],
    [#pi-theta], [*2341*], [*5.69*], [*2272*], [*8.59*],

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
      #pi-still has the robot remaining immobile;
      #pi-random samples actions randomly;
      #pi-safe-random does the same, but never hits the room's walls;
      #pi-orient never has the agent moving but ensures it faces the source;
      and #pi-theta is our deep neural agent policy trained with #acr("PPO").
    ],
  ),
)
<table:rl:results:wer_performance_vs_baselines>