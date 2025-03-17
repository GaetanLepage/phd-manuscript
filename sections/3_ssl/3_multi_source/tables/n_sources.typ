#import "/utils.typ": *
#import "../_notations.typ": *

// Same training with different number of sources
#figure(
  table(
    // SETTINGS
    columns: 5,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,
    table.header(
      [],
      header-mae,     
      header-acc,     
      header-prec,        
      header-recall,  
    ),
    
    midrule,

    // ROWS
    [1 source], [2.59],  [88.58], [87.70], [88.70],
    [2 sources], [7.26],  [70.78], [79.56], [68.07],
    [3 sources], [15.89], [58.18], [74.99], [54.73],
    [4 sources], [21.95], [50.21], [72.08], [46.22],
    [Scenario A\ (0-4 sources)], [9.13],   [71.36],  [80.99],  [69.26], 
    [Scenario B\ (1-4 sources)], [15.24], [60.52], [76.73], [57.36],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the number of active sources
  ]
)
<table:ssl:multi_source:experiments:n_sources>