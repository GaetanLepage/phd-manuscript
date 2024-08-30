#import "/utils.typ": *
#import "utils.typ": *
#import "../../_notations.typ": *

#figure(
  tablex(
    // SETTINGS
    columns: 7,
    header-rows: 2,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    rowspanx(2)[Aggregation method],
    rowspanx(2)[#clip-t],
    header-pred-spectrum,
    [#h(1em)],
    header-gt-spectrum,

    (),
    (),
    header-prec,        
    header-recall,  
    [],
    header-prec,        
    header-recall,  
    
    midrule,

    // ROWS
    // Blending             delta_min   Prec      Recall    ||    Prec      Recall
    rowspanx(5)[#psi-avg],  [0.0],      [80.70],  [31.68],  [],   [94.90],  [37.26],
    (),                     [0.2],      [69.25],  [40.05],  [],   [84.25],  [45.58],
    (),                     [0.4],      [75.71],  [42.09],  [],   [94.18],  [64.19],
    (),                     [0.6],      [84.08],  [10.99],  [],   [96.02],  [77.70],
    (),                     [0.8],      [NaN],    [0.0],    [],   [96.23],  [68.20],
    midrule,
    rowspanx(5)[#psi-dnn],  [0.0],      [],   [],     [],   [],   [],
    (),                     [0.2],      [],   [],     [],   [],   [],
    (),                     [0.4],      [],   [],     [],   [],   [],
    (),                     [0.6],      [],   [],     [],   [],   [],
    (),                     [0.8],      [],   [],     [],   [],   [],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the ASSL performance for different clipping threshold (#clip-t) values
  ]
)
<table:active_ssl:results:clipping_threshold>