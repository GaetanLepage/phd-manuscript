#import "../../../../utils.typ": *
#import "../_notations.typ": *

#figure(
  table(
    // SETTINGS
    columns: 5,
    stroke: none,
    align: left + horizon,

    // HEADER
    toprule,
    table.header([], header-mae, header-acc, header-prec, header-recall),

    midrule,

    // ROWS
    [$diameter$], [9.36], [70.56], [*81.04*], [68.36],
    [$epsilon=0.1$], [8.17], [71.68], [67.86], [*70.62*],
    [$epsilon=0.2$], [8.29], [71.02], [70.36], [69.86],
    [$epsilon=0.4$], [*8.13*], [*71.99*], [75.96], [70.28],
    [$epsilon=0.6$], [8.32], [71.60], [76.94], [69.88],
    [$epsilon=1.0$], [8.49], [71.38], [76.87], [69.61],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Performance of the SSL model trained with the $epsilon$-loss.
  ],
)
<table:ssl:multi_source:experiments:epsilon_loss>
