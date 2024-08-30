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
    rowspanx(2)[#doa-t],
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
    // Blending             doa_threshold   Prec      Recall    ||    Prec      Recall
    rowspanx(5)[#psi-avg],  [1.0],      [],  [],  [],   [],  [],
    (),                     [0.8],      [],  [],  [],   [],  [],
    (),                     [0.6],      [],  [],  [],   [],  [],
    (),                     [0.4],      [],  [],  [],   [],  [],
    (),                     [0.2],      [],  [],  [],   [],  [],
    midrule,
    rowspanx(5)[#psi-dnn],  [1.0],      [],  [],  [],   [],  [],
    (),                     [0.8],      [],  [],  [],   [],  [],
    (),                     [0.6],      [],  [],  [],   [],  [],
    (),                     [0.4],      [],  [],  [],   [],  [],
    (),                     [0.2],      [],  [],  [],   [],  [],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the ASSL performance for different #doa threshold (#doa-t) values
  ]
)
<table:active_ssl:results:doa_threshold>