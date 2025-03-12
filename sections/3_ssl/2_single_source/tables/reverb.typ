#import "/utils.typ": *
#import "utils.typ": *

#figure(
  tablex(
    // SETTINGS
    columns: 2,
    header-rows: 1,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,
    [$T_60$],
    [#mae-theta-header],
    //[#mae-dist-header],
    
    midrule,

    // ROWS
    [100ms],  [2.78],
    [200ms],  [9.08],
    [400ms],  [15.42],
    [500ms],  [17.18],
    [700ms],  [21.67],
    [900ms],  [24.71],
    [1s],     [#todo],
    
    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Reverberation impact on #acr("SSL") performance
  ]
)
<table:ssl:single_source:reverb>