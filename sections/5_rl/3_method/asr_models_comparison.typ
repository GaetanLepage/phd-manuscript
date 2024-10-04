#import "/utils.typ": *
#import "/_misc/notations.typ": *
//#import "../../_notations.typ": *

#set text(size: 10pt)

#figure(
  tablex(
    // SETTINGS
    columns: 6,
    header-rows: 2,
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    
    // HEADER
    toprule,

    colspanx(3, align: center)[*Model*],
    [],
    colspanx(2, align: center)[*Performance*],

    [Name],
    [Language model],
    [Acoustic model],
    [#h(1em)],
    [Samples/s #sym.arrow.t],
    [#acr("WER") #sym.arrow.b],

    midrule,

    // ROWS
    // MODEL
    [`asr-crdnn-rnnlm-librispeech`],                [#acr("RNNLM")],          [#acr("CRDNN")],  [], [2.84],     [1.82],
    [`asr-crdnn-transformerlm-librispeech`],        [Transformer #acr("LM")], [#acr("CRDNN")],  [], [#todo], [#todo],
    [`asr-transformer-transformerlm-librispeech`],  [Transformer #acr("LM")], [Transformer],    [], [0.75], [0.05],

    bottomrule
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of three #acr("ASR") models provided by #speechbrain
  ]
)
<table:rl:method:asr_models>