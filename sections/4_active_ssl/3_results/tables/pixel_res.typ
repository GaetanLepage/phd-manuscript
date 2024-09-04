#import "/utils.typ": *
#import "utils.typ": *

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

    rowspanx(2)[pixel resolution],
    //colspanx(2)[#align(center)[$hat(o)_t$]],
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
    // FoV    Prec Recall ||  Prec  Recall
    [64],     [85.05], [45.35],     [], [97.14],   [8.01],
    [96],     [94.92], [68.24],     [], [99.45],   [71.61],
    [128],    [*86.34*], [50.88],   [], [99.54],   [85.67],
    [256],    [85.41], [*52.65*],   [], [*99.61*],   [*90.73*],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the ASSL performance for different pixel resolutions
  ]
)
<table:active_ssl:results:pixel_res>