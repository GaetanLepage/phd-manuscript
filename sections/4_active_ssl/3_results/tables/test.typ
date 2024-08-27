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

    rowspanx(2)[FoV (m)],
    //colspanx(2)[#align(center)[$hat(o)_t$]],
    header-pred-spectrum,
    [#h(1em)],
    header-gt-spectrum,
    
    header-prec,        
    header-recall,  
    [],
    header-prec,        
    header-recall,  
    
    midrule,

    // ROWS
    // FoV    Prec Recall ||  Prec  Recall
    [2],      [], [],     [], [],   [],
    [4],      [], [],     [], [],   [],
    [8],      [], [],     [], [],   [],
    [16],     [], [],     [], [],   [],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the ASSL performance for different FoV
  ]
)
<table:active_ssl:results:test>