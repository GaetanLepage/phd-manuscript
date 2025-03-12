#import "/utils.typ": *
#import "utils.typ": *

#figure(
  tablex(
    // SETTINGS
    columns: 3,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,
    [],
    [Number of channels],
    [#mae-theta-header],
    //[#mae-dist-header],
    
    midrule,

    // ROWS
    [Interaural (#acr("ILD")/#acr("IPD"))],     [2], [17.21],
    [#acr("STFT") (Cartesian)],                 [4], [17.05],
    [#acr("STFT") (polar)],                     [4], [63.18],
    midrule,// 
    [#acr("ILD") only],                         [1], [38.27],
    [#acr("IPD") only],                         [1], [22.74],
    [#acr("STFT") magnitude only],              [2], [#todo],
    [#acr("STFT") phase only],                  [2], [#todo],
    
    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the input features
  ]
)
<table:ssl:single_source:input_features>