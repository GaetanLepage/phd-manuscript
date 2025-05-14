#import "/utils.typ": *
#import "utils.typ": *
#import "../../_notations.typ": *

#figure(
  table(
    // SETTINGS
    columns: 7,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      table.cell(rowspan: 2)[Aggregation method],
      table.cell(rowspan: 2)[#clip-t],
      header-pred-spectrum,
      [#h(1em)],
      header-gt-spectrum,
  
      header-prec,        
      header-recall,  
      [],
      header-prec,        
      header-recall,  
    ),

    
    midrule,

    // ROWS
    // Blending             delta_min   Prec                  Recall                  ||    Prec      Recall
    table.cell(rowspan: 9)[#psi-avg],  [0.1],      [78.0],               [32.43],                [],   [94.92],              [37.38],
                            [0.2],      [69.25],              [40.05],                [],   [84.25],              [45.58],
                            [0.3],      [#underline[72.33]],  [#underline[*46.60*]],  [],   [91.73],              [54.85],
                            [0.4],      [75.71],              [42.09],                [],   [94.18],              [64.19],
                            [0.5],      [79.46],              [26.42],                [],   [95.62],              [72.91],
                            [0.6],      [*84.08*],            [10.99],                [],   [#underline[96.02]],  [#underline[*77.70*]],
                            [0.7],      [81.82],              [2.12],                 [],   [*96.39*],            [74.48],
                            [0.8],      [-],                [0.0],                  [],   [96.23],              [68.20],
                            [0.9],      [-],                [0.0],                  [],   [95.53],              [54.50],
    midrule,                                              
    table.cell(rowspan: 9)[#psi-dnn],  [0.1],      [75.02],              [47.27],                [],   [99.48],              [67.92],
                            [0.2],      [75.59],              [51.67],                [],   [99.30],              [72.91],
                            [0.3],      [77.27],              [53.91],                [],   [99.39],              [76.91],
                            [0.4],      [80.03],              [*54.61*],              [],   [99.46],              [80.29],
                            [0.5],      [82.62],              [54.14],                [],   [99.63],              [83.59],
                            [0.6],      [#underline[86.05]],  [#underline[53.28]],    [],   [99.59],              [86.26],
                            [0.7],      [87.89],              [51.00],                [],   [99.56],              [88.50],
                            [0.8],      [89.73],              [47.66],                [],   [#underline[99.74]],  [#underline[*90.54*]],
                            [0.9],      [*90.01*],            [42.09],                [],   [*99.91*],            [90.11],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the ASSL performance for different clipping threshold (#clip-t) values.
  ]
)
<table:active_ssl:results:clipping_threshold>