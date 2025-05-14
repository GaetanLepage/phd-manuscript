#import "/utils.typ": *
#import "../_notations.typ": *

#figure(
  table(
    // SETTINGS
    columns: 8,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      [Normalization layer],
      [`eval` mode],
      [Batch size],
      [],
      header-mae,     
      header-acc,     
      header-prec,        
      header-recall,  
    ),
    
    midrule,

    // ROWS
    // Norm                            Eval/Train mode                // BS                 # MAE     # Acc       # Prec      # Rec
    // [None],                 [True],               [-],    [],         [],       [],         [],         [],
    table.cell(rowspan: 6)[BatchNorm], table.cell(rowspan: 5)[False],   [1],    [#h(1em)],  [42.10],  [26.03],    [12.39],    [51.43],
                                                                        [50],   [],         [9.32],   [73.00],    [83.70],    [70.61],
                                                                        [100],  [],         [9.11],   [73.43],    [84.26],    [70.96],
                                                                        [200],  [],         [9.07],   [73.66],    [84.71],    [71.19],
                                                                        [500],  [],         [*8.95*], [*73.76*],  [*84.78*],  [*71.35*],
                                                             [True],    [-],    [],         [29.58],  [53.45],    [45.37],    [61.00],
    midrule,
    [LayerNorm],                                             [True],    [-],    [],         [9.37],  [70.35],    [80.21],    [68.26],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Final performance of SSL for different normalization/evaluation schemes.
  ]
)
<table:ssl:multi_source:experiments:normalization>