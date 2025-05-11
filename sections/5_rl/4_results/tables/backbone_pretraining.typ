#import "/utils.typ": *
#import "utils.typ": *
#import "/_misc/notations.typ": *


#figure(
  table(
    // SETTINGS
    columns: 3,
    align: left + horizon,
    stroke: none,
    
    // HEADER
    toprule,

    table.header(
      [Backbone training strategy],
      [#todo],
      [#todo],
    ),

    midrule,

    [No pretraining], [#todo], [#todo],
    [Pretraining + fine-tuning], [#todo], [#todo],
    [Pretraining + frozen], [#todo], [#todo],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of three #acr("ASR") models provided by #speechbrain
  ]
)
<table:rl:results:backbone_pretraining>