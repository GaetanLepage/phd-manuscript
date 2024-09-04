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
    rowspanx(2)[Horizon],
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
    // Blending             horizon   Prec        Recall      ||    Prec        Recall
    rowspanx(5)[#psi-avg],  [1],      [12.28],    [4.83],     [],   [9.03],     [3.61],
    (),                     [2],      [39.19],    [17.86],    [],   [62.26],    [45.47],
    (),                     [4],      [55.50],    [35.06],    [],   [88.15],    [67.45],
    (),                     [6],      [65.56],    [43.42],    [],   [94.29],    [73.89],
    (),                     [8],      [*72.33*],  [*46.60*],  [],   [*96.02*],  [*77.70*],
    midrule,                                              
    rowspanx(5)[#psi-dnn],  [1],      [],               [],                [],   [],              [],
    (),                     [2],      [],              [],                [],   [],              [],
    (),                     [4],      [],  [],  [],   [],              [],
    (),                     [6],      [],              [],                [],   [],              [],
    (),                     [8],      [],              [],                [],   [],              [],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Evolution of localization performance for different horizon values
  ]
)
<table:active_ssl:results:horizon>