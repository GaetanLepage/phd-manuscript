#import "/utils.typ": *
#import "utils.typ": *

#figure(
  tablex(
    // SETTINGS
    columns: 5,
    header-rows: 2,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

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
    // Prec Recall ||  Prec  Recall
       [], [],     [], [],   [],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the #acr("ASSL") performance for two sources of #doa spectrum
  ]
)
<table:active_ssl:results:ssl_model>