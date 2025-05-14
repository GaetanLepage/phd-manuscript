#import "/utils.typ": *

#figure(
  table(
    // SETTINGS
    columns: 3,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      [],
      [Dataset A],
      [Dataset B],
    ),
    
    midrule,

    // ROWS
    header-mae,     [9.13],  [14.05],
    header-acc,     [71.36], [61.76],
    header-prec,    [80.98], [76.96],
    header-recall,  [69.26], [58.53],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    SSL performance when trained with different number of sources.
  ]
)
<table:ssl:multi_source:experiments:n_sources_train>