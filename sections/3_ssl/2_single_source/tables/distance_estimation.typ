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
      [Mic. array],
      [Distance prediction],
      [#mae-theta-header],
      [#mae-dist-header],
    ),
    
    midrule,

    // ROWS
    table.cell(rowspan: 2)[Binaural array],     [No], [17.51], [-],
                                                [Yes], [21.99], [88.53],
    dashedrule,
    table.cell(rowspan: 2)[Triangle array],     [No], [*5.17*], [-],
                                                [Yes], [8.49], [*74.44*],
    
    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: flex-caption(
    short: [
      #acr("SSL") performance when estimating the source-microphone distance.
    ],
    long: [
      #acr("SSL") performance when estimating the source-microphone distance.
      #todo   
    ],
  )
)
<table:ssl:single_source:distance_estimation>