#import "/utils.typ": *
#import "/_misc/notations.typ": *
//#import "../../_notations.typ": *

#set text(size: 10pt)

#figure(
  table(
    // SETTINGS
    columns: 6,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      table.cell(colspan: 3, align: center)[*Model*],
      [],
      table.cell(colspan: 2, align: center)[*Performance*],
  
      [Name],
      [Language model],
      [Acoustic model],
      [#h(1em)],
      [Samples/s #sym.arrow.t],
      [#acr("WER") (%) #sym.arrow.b],
    ),

    midrule,

    // ROWS
    // MODEL
    [`asr-crdnn-rnnlm`],                [#acr("RNNLM")],          [#acr("CRNN")],  [], [2.84],     [1.82],
    [`asr-crdnn-transformerlm`],        [Transformer #acr("LM")], [#acr("CRNN")],  [], [0.24], [1.16],
    [`asr-transformer-transformerlm`],  [Transformer #acr("LM")], [Transformer],    [], [0.75], [0.05],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of three #acr("ASR") models provided by #speechbrain.
    #draft[TODO: caption font size is reduced too]
  ]
)
<table:rl:method:asr_models>