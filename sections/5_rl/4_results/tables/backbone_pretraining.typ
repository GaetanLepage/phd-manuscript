#import "/utils.typ": *
#import "utils.typ": *
#import "/_misc/notations.typ": *

#set text(size: 10pt)

#figure(
  tablex(
    // SETTINGS
    columns: 3,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [Backbone training strategy],
    header-wer,
    header-reward,

    midrule,

    [No pretraining], [#todo], [#todo],
    [Pretraining + finetuning], [#todo], [#todo],
    [Pretraining + frozen], [#todo], [#todo],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of three #acr("ASR") models provided by #speechbrain
  ]
)
<table:rl:result:backbone_pretraining>