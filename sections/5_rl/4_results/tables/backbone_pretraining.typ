#import "/utils.typ": *
#import "utils.typ": *
#import "/_misc/notations.typ": *

#set text(size: 10pt)

#figure(
  table(
    // SETTINGS
    columns: 3,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      [Backbone training strategy],
      header-wer,
      header-reward,
    ),

    midrule,

    [No pretraining], [#todo], [#todo],
    [Pretraining + finetuning], [#todo], [#todo],
    [Pretraining + frozen], [#todo], [#todo],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of three #acr("ASR") models provided by #speechbrain
  ]
)
<table:rl:result:backbone_pretraining>