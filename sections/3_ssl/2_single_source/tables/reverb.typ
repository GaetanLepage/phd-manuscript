#import "/utils.typ": *
#import "utils.typ": *

#figure(
  table(
    // SETTINGS
    columns: 2,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,
    table.header(
      [$T_60$],
      [#mae-theta-header],
      //[#mae-dist-header],
    ),
    
    midrule,

    // ROWS
    [100ms],  [2.78],
    [200ms],  [9.08],
    [400ms],  [15.42],
    [500ms],  [17.18],
    [700ms],  [21.67],
    [900ms],  [24.71],
    [1s],     [26.71],
    
    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Reverberation impact on #acr("SSL") performance.
  ]
)
<table:ssl:single_source:reverb>