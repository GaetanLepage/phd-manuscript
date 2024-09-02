#import "/utils.typ": *
#import "utils.typ": *
#import "../../_notations.typ": *

#figure(
  tablex(
    // SETTINGS
    columns: 6,
    header-rows: 2,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    rowspanx(2)[Aggregation method],
    header-pred-spectrum,
    [#h(1em)],
    header-gt-spectrum,

    (),
    header-prec,        
    header-recall,  
    [],
    header-prec,        
    header-recall,  
    
    midrule,

    // ROWS
    // Blending             delta_min   Prec                  Recall                  ||    Prec      Recall
    [#psi-avg],  [72.33],  [46.60],    [],   [96.02],              [77.70],
    [#psi-dnn],  [*86.05*],  [*53.28*],    [],   [*99.74*],              [*90.54*],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Final performance of both aggregation methods
  ]
)
<table:active_ssl:results:blending_methods>