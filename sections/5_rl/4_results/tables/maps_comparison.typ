#import "/utils.typ": *
#import "utils.typ": *
#import "../../_notations.typ": *

#figure(
  table(
    // SETTINGS
    columns: 3,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      [Cost map type],
      [Directionality],
      [mean cost],
    ),
    
    midrule,

    // ROWS
    table.cell(rowspan: 2)[WER map], [omnidirectional], [#todo],
    [oriented], [#todo],
    table.cell(rowspan: 2)[WER map], [omnidirectional], [#todo],
    [oriented], [#todo],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: flex-caption(
    short: [
      Navigation performance when using different reward strategies.
    ],
    long: [
      Navigation performance when using different reward strategies.
      In the first scenario, the episode is never stopped, no matter what the agent does.
      Early stopping, however, means stopping the episode when the agent is close enough to the source.
      In the last case, we additionally grant the agent a bonus in the final step's reward.
    ],
  ),
)
<table:rl:results:maps_comparison>