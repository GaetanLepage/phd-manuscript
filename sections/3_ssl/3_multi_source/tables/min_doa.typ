#import "/utils.typ": *
#import "../_notations.typ": *


#figure(
  table(
    // SETTINGS
    columns: 5,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      [$tau_"DoA"$ (°)],
      header-mae,     
      header-acc,     
      header-prec,        
      header-recall,  
    ),
    
    midrule,

    // rdc "python rl_audio_nav/supervised_localization/bin/evaluate.py 60X 0"
    
    // ROWS
    //    MAE         Acc         Prec        Rec
    [0],  [20.05],    [50.55],    [71.29],    [46.11],
    [5],  [20.85],    [51.08],    [*72.17*],  [50.45],
    [10], [*21.81*],  [52.64],    [72.10],    [52.82],
    [20], [21.56],    [*57.17*],  [71.68],    [*57.38*],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
      #acr("SSL") performance for different values of #tau-doa.
  ]
)
<table:ssl:multi_source:experiments:min_doa>