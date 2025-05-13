#import "/utils.typ": *
#import "utils.typ": *

#figure(
  table(
    // SETTINGS
    columns: 5,
    align: left + horizon,
    stroke: none,
    
    // HEADER
    toprule,
    table.header(
      [Array],
      [\#mics],
      [microphone pattern],
      [],
      [#mae-theta-header],
      //[#mae-dist-header],
    ),
    
    midrule,

    // ROWS
    table.cell(rowspan: 2)[Binaural],     [2], [omnidirectional], [#h(1em)], [46.13],
                                          [2], [cardioid],        [],          [17.32],
    dashedrule,         
    table.cell(rowspan: 2)[Triangle],     [3], [omnidirectional], [],          [5.07],
                                          [3], [cardioid],        [],          [5.11],
    dashedrule,         
    [Square],                             [4], [omnidirectional], [],          [*3.8*],
    
    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance for different microphone arrays.
  ]
)
<table:ssl:single_source:mic_arrays>