#import "/utils.typ": *
#import "utils.typ": *
#import "../../_variables.typ": *


#figure(
  table(
    // SETTINGS
    columns: 5,
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

    [#pi-still], [], [], [], [],
    [#pi-random], [], [], [], [],
    [#pi-orient], [], [], [], [],
    [#pi-theta], [], [], [], [],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of three #acr("ASR") models provided by #speechbrain
  ]
)
<table:rl:results:wer_performance_vs_baselines>