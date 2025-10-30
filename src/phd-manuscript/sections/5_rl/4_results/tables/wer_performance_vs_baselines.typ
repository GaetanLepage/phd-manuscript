#import "../../../../utils.typ": *
#import "utils.typ": *
#import "../../_variables.typ": *
#import "_data.typ": *

#figure(
  table(
    // SETTINGS
    columns: 5 * (1fr,),
    align: left + horizon,
    stroke: none,

    // HEADER
    toprule,

    table.header(
      table.cell(rowspan: 2)[Policy],
      table.cell(colspan: 2)[Omnidirectional cost],
      table.cell(colspan: 2)[Directional cost],
      mean-cum-reward-header,
      mfc-header,
      mean-cum-reward-header,
      mfc-header,
    ),

    midrule,

    // Omnidirection: exp300
    // Directional: exp301

    [#pi-random],
    [#pi-random-rew-wer-omni],
    [#pi-random-mfc-wer-omni],
    [#pi-random-rew-wer-dir],
    [#pi-random-mfc-wer-dir],

    [#pi-safe-random],
    [#pi-safe-random-rew-wer-omni],
    [#pi-safe-random-mfc-wer-omni],
    [#pi-safe-random-rew-wer-dir],
    [#pi-safe-random-mfc-wer-dir],

    [#pi-still], [#pi-still-rew-wer-omni], [#pi-still-mfc-wer-omni], [#pi-still-rew-wer-dir], [#pi-still-mfc-wer-dir],

    [#pi-still-orient],
    [#pi-still-orient-rew-wer-omni],
    [#pi-still-orient-mfc-wer-omni],
    [#pi-still-orient-rew-wer-dir],
    [#pi-still-orient-mfc-wer-dir],

    [#pi-theta], [*#exp-300-rew-wer*], [*#exp-300-mfc-wer*], [*#exp-301-rew-wer*], [*#exp-301-mfc-wer*],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: flex-caption(
    short: [
      Benchmark of various policies' performance on the navigation task.
    ],
    long: [
      Benchmark of various policies' performance on the navigation task.
      Both omnidirectional and directional WER cost environments have been tested.
      #pi-random samples actions randomly;
      #pi-safe-random does the same, but never hits the room's walls;
      #pi-still has the robot remaining immobile;
      #pi-still-orient never has the agent moving but ensures it faces the source;
      and #pi-theta is our deep neural agent policy trained with PPO.
    ],
  ),
)
<table:rl:results:wer_performance_vs_baselines>
