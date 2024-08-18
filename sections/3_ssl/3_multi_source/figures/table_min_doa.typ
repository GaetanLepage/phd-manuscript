#import "/utils.typ": *
#import "../_notations.typ": *


#figure(
  tablex(
    // SETTINGS
    columns: 5,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    [$tau_"DoA"$ (°)],
    header-mae,     
    header-acc,     
    header-prec,        
    header-recall,  
    
    midrule,

    // rdc "python rl_audio_nav/supervised_localization/bin/evaluate.py 60X 0"
    
    // ROWS
    //    MAE       Acc      Prec     Rec
    [0],   [],  [], [], [],
    [5],   [],  [], [], [],
    [10],   [],  [], [], [],
    [20],   [],  [], [], [],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
       
  ]
) <table:ssl:multi_source:experiments:min_doa>