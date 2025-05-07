#import "/utils.typ": *
#import "utils.typ": *
#import "../../_notations.typ": *

#figure(
  table(
    // SETTINGS
    columns: 2,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      [Reward strategy],
      [mean #acr("WER")]
    ),
    
    midrule,

    // ROWS
    [No early stopping],               [#todo],
    [Early stopping],                  [#todo],
    [Early stopping + success bonus],  [*#todo*],

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
      In the last case, we additionally grant the agent a bonus as the final step reward.
    ],
  ),
)
<table:rl:results:early_stopping>