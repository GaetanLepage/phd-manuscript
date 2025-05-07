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
      [Reward function],
      [mean #acr("WER")]
    ),
    
    midrule,

    // ROWS
    [$r_t = - w(s_t)$],               [#todo],
    [$r_t = alpha e^(-beta w(s_t))$], [*#todo*],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: flex-caption(
    short: [
      #todo
    ],
    long: [
      #todo
    ],
  ),
)
<table:rl:results:reward_shaping>