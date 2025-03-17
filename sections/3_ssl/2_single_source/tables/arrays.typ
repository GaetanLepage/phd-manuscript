#import "/utils.typ": *
#import "utils.typ": *

#figure(
  table(
    // SETTINGS
    columns: 4,
    align: left + horizon,
    stroke: none,
    
    // HEADER
    toprule,
    table.header(
      [],
      [Number of microphones],
      [microphone pattern],
      [#mae-theta-header],
      //[#mae-dist-header],
    ),
    
    midrule,

    // ROWS
    [Binaural #todo merge cells],     [2], [omnidirectional], [46.13],
    [Binaural],                       [2], [cardioid],        [],
    [Triangle],                       [3], [omnidirectional], [],
    [Triangle],                       [3], [cardioid],        [5.15],
    [Square],                         [4], [omnidirectional], [3.8],
    
    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the input features
  ]
)
<table:ssl:single_source:mic_arrays>