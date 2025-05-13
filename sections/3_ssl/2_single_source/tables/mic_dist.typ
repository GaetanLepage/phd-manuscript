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
      [microphone spacing (cm)],
      [#mae-theta-header],
      //[#mae-dist-header],
    ),
    
    midrule,

    // ROWS
    [1],  [17.71],
    [2],  [*17.28*],
    [4],  [18.75],
    [6],  [21.86],
    [8],  [22.58],
    
    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Reverberation impact on #acr("SSL") performance.
  ]
)
<table:ssl:single_source:mic_dist>