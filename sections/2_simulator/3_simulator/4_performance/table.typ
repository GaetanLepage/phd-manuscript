#import "/utils.typ": *

#figure(
  table(
    // SETTINGS
    columns: 5,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      [],
      [$T_"sim"$ (s, (%))],
      [$t_"RIR"$ (s, (%))],
      [$t_"FFT"$ (s, (%))],
      [$t_"STFT"$ (s, (%))],
    ),
    
    midrule,

    // rdc "python rl_audio_nav/supervised_localization/bin/evaluate.py 60X 0"
    
    // ROWS
    [Pyroomacoustics],  [124 (100%)],    [109 (87.9%)],    [11.62 (9.37%)],  [2.28 (1.84%)],
    [gpuRIR],           [*21.69* (100%)],    [*3.69* (17.01%)],    [14.56 (67.1%)], [2.41 (11.1%)],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Relative performance of the simulator back-end #acr("RIR") libraries.
  ],
)
<table:simulator:simulator:performance:backends>