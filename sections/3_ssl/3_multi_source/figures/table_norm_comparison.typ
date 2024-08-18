#import "/utils.typ": *
#import "../_notations.typ": *


#figure(
  tablex(
    // SETTINGS
    columns: 7,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [Normalization layer],
    [`eval` mode],
    [],
    header-mae,     
    header-acc,     
    header-prec,        
    header-recall,  
    
    midrule,

    // ROWS
    //                                                          MAE         Acc         Prec        Rec
    rowspanx(2)[Batch norm],  [False, BS=500],  [#h(1em)],      [*8.95*],   [*73.76*],  [*84.78*],  [*71.35*],
    (),                       [True],           [],             [29.58],    [53.45],    [45.37],    [61.00],
    midrule,
    [Layer norm],             [True],           [],             [9.37],     [70.35],    [80.21],    [68.26],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Final performance of #acr("SSL") for different normalization/evaluation schemes
  ]
)
<table:ssl:multi_source:experiments:norm_comparison>