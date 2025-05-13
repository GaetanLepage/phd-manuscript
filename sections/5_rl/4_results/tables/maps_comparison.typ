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
    [omni.], [-], [-], [-], [#todo], [#todo],
    [dir.], [-], [-], [-], [#todo], [#todo],
    
    table.cell(rowspan: 2)[#pi-random],
    [omni.], [-], [-], [-], [#todo], [#todo],
    [dir.], [-], [-], [-], [#todo], [#todo],
    
    table.cell(rowspan: 2)[#pi-orient],
    [omni.], [-], [-], [-], [#todo], [#todo],
    [dir.], [-], [-], [-], [#todo], [#todo],
    
    midrule,
    
    // LEARNED POLICIES ----------------------------------------
    
    // exp 300
    table.cell(rowspan: 4)[#pi-theta],
    table.cell(rowspan: 2)[omni.],
    [#wer-cost], [#exp-300-rew-wer], [#exp-300-mfc-wer], [#exp-300-rew-wer], [#exp-300-mfc-wer],
    // exp 310
    [#analytical-cost], [#exp-310-rew-wer], [#exp-310-mfc-wer], [#todo], [#todo],
    
    midrule,
    
    // exp 301
    table.cell(rowspan: 2)[dir.],
    [#wer-cost], [#todo], [#todo], [#todo], [#todo],
    // exp 311
    [#analytical-cost], [#todo], [#todo], [#todo], [#todo],
    
    
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
      Navigation performance when using different reward strategies.
    ],
    long: [
      Navigation performance when using different reward strategies.
      In the first scenario, the episode is never stopped, no matter what the agent does.
      Early stopping, however, means stopping the episode when the agent is close enough to the source.
      In the last case, we additionally grant the agent a bonus in the final step's reward.
    ],
  ),
)
<table:rl:results:maps_comparison>