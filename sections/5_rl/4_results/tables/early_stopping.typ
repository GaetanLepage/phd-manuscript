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
      [Reward strategt],
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
      
    ],
    long: [
  
    ],
  ),
)
<table:rl:results:early_stopping>