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
      [\#channels],
      [\#epochs],
      [#mae-theta-header],
      //[#mae-dist-header],
    ),
    
    midrule,

    // ROWS
    [Interaural (#acr("ILD")/#acr("IPD"))],     [2], [100], [17.21],
    [#acr("STFT") (Cartesian)],                 [4], [200], [17.05],
    [#acr("STFT") (polar)],                     [4], [200], [25.7],
    dashedrule,
    [#acr("ILD") only],                         [1], [100], [38.27],
    [#acr("IPD") only],                         [1], [100], [22.74],
    [#acr("STFT") magnitude only],              [2], [100], [31.17],
    [#acr("STFT") phase only],                  [2], [100], [27.97],
    
    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    #acr("SSL") performance depending on the input features
  ]
)
<table:ssl:single_source:input_features>