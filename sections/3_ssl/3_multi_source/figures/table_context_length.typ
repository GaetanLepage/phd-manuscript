#import "/utils.typ": *
#import "../_notations.typ": *

#figure(
  tablex(
    // SETTINGS
    columns: 8,
    header-rows: 2,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    colspanx(3, align: center)[*Settings*],
    [],
    colspanx(4, align: center)[*Metrics*],
    
    [$bold(T_"eval") space (d_"eval")$],
    [#T-train],
    [$N_"pass"$],
    [#h(1cm)],
    header-mae,     
    header-acc,     
    header-prec,        
    header-recall,  
    
    //midrule,
    toprule,

    // rdc "python rl_audio_nav/supervised_localization/bin/eval_sequence_processing.py 20X 0"
    
    // ROWS
    //                  SETTINGS              ||                 METRICS
    //          Fe    Te         Ft    Np     ||     MAE       Acc      Prec     Rec
               [*2*  (21ms) ],  [2],  [1],    [],   [29.31],  [39.11],   [58.83],   [38.04],
    midrule,        
          
    rowspanx(2)[*4*  (64ms) ],  [4],  [1],    [],   [21.28],  [50.73],   [68.83],   [49.37],
    (),                         [2],  [2],    [],   [24.51],  [47.34],   [68.87],   [46.47],
    midrule,                
          
    rowspanx(3)[*8*  (149ms)],  [8],  [1],    [],   [12.84],  [62.05],   [75.33],   [61.18],
    (),                         [4],  [2],    [],   [15.13],  [58.76],   [75.10],   [57.21],
    (),                         [2],  [4],    [],   [19.76],  [54.40],   [76.18],   [52.95],
    midrule,        
          
    rowspanx(4)[*16* (320ms)],  [16], [1],    [],   [8.71],   [72.99],   [83.35],   [71.73],
    (),                         [8],  [2],    [],   [9.92],   [69.51],   [82.26],   [67.76],
    (),                         [4],  [4],    [],   [13.85],  [63.99],   [82.84],   [62.15],
    (),                         [2],  [8],    [],   [19.56],  [58.86],   [83.64],   [56.92],
    midrule,                
          
    [           *32* (661ms)],  [16], [2],    [],   [6.20],   [80.15],   [89.46],   [78.03],
    midrule,                
          
    [           *64* (1.34s)],  [16], [4],    [],   [5.43],   [83.64],   [92.88],   [80.83],
    midrule,          
    
    [           *512* (10.9s)], [16], [32],   [],   [4.18],   [*86.83*], [*95.48*], [*83.93*],
    midrule,          
    
    [           *full*       ], [16], [-],    [],   [*4.14*], [86.35],   [95.25],   [83.54],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the input duration
  ]
)
<table:ssl:multi_source:experiments:context_length>