#import "/utils.typ": *
#import "utils.typ": *
#import "../../_variables.typ": *
#import "_data.typ": *

#set text(size: 10pt)

#figure(
  table(
    // SETTINGS
    columns: 7,
    stroke: none,
    align: left + horizon,
    
    // HEADER
    toprule,

    table.header(
      table.cell(rowspan: 2)[Policy],
      table.cell(rowspan: 2)[Directionality],
      table.cell(colspan: 3)[Performance on the training environment],
      table.cell(colspan: 2)[Performance on the #wer-cost environment],

      midrule,
      [Cost function],
      mean-cum-reward-header,
      mfc-header,
      
      mean-cum-reward-header,
      mfc-header,
    ),
    
    midrule,

    // ROWS

    // BASELINE POLICIES ----------------------------------------
    table.cell(rowspan: 2)[#pi-still],
    [omni.], [-], [-], [-], [#pi-still-rew-wer-omni], [#pi-still-mfc-wer-omni],
    [dir.], [-], [-], [-], [#pi-still-rew-wer-dir], [#pi-still-mfc-wer-dir],
    
    table.cell(rowspan: 2)[#pi-random],
    [omni.], [-], [-], [-], [#pi-random-rew-wer-omni], [#pi-random-mfc-wer-omni],
    [dir.], [-], [-], [-], [#pi-random-rew-wer-dir], [#pi-random-mfc-wer-dir],
    
    table.cell(rowspan: 2)[#pi-safe-random],
    [omni.], [-], [-], [-], [#pi-safe-random-rew-wer-omni], [#pi-safe-random-mfc-wer-omni],
    [dir.], [-], [-], [-], [#pi-safe-random-rew-wer-dir], [#pi-safe-random-mfc-wer-dir],
    
    table.cell(rowspan: 2)[#pi-orient],
    [omni.], [-], [-], [-], [#pi-orient-rew-wer-omni], [#pi-orient-mfc-wer-omni],
    [dir.], [-], [-], [-], [#pi-orient-rew-wer-dir], [#pi-orient-mfc-wer-dir],
    
    midrule,
    
    // LEARNED POLICIES ----------------------------------------
    
    // exp 300
    table.cell(rowspan: 4)[#pi-theta],
    table.cell(rowspan: 2)[omni.],
    [#wer-cost], [#exp-300-rew-wer], [#exp-300-mfc-wer], [#exp-300-rew-wer], [#exp-300-mfc-wer],
    // exp 310
    [#analytical-cost], [#exp-310-rew-analytical], [#exp-310-mfc-analytical], [*#exp-310-rew-wer*], [*#exp-310-mfc-wer*],
    
    midrule,
    
    // exp 301
    table.cell(rowspan: 2)[dir.],
    [#wer-cost], [#exp-301-rew-wer], [#exp-301-mfc-wer], [*#exp-301-rew-wer*], [*#exp-301-mfc-wer*],
    // exp 311
    [#analytical-cost], [#exp-311-rew-analytical], [#exp-311-mfc-analytical], [#exp-311-rew-wer], [#exp-311-mfc-wer],
    
    
    //table.cell(rowspan: 2)[WER map], [omnidirectional], [#todo],
    //[oriented], [#todo],
    //table.cell(rowspan: 2)[WER map], [omnidirectional], [#todo],
    //[oriented], [#todo],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: flex-caption(
    short: [
      Navigation performance when using different cost functions.
    ],
    long: [
      Navigation performance when using different cost functions.
      The agent is trained with the two variants of the cost #wer-cost and #analytical-cost.
      All policies are then evaluated on the same #wer-cost;-based target environment.
      #gaet[
        Is it interesting to keep the "baseline" policies? I don't think so.
      ]
    ],
  ),
)
<table:rl:results:maps_comparison>