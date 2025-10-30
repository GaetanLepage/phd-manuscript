#import "../../../../utils.typ": *
#import "utils.typ": *
#import "../../../../_misc/notations.typ": *
#import "_data.typ": *


#figure(
  table(
    // SETTINGS
    //columns: 3 * (1fr,),
    columns: 3,
    align: left + horizon,
    stroke: none,

    // HEADER
    toprule,

    table.header([Feature extractor training strategy], mean-cum-reward-header, mfc-header),

    midrule,

    [#pi-safe-random], [#pi-safe-random-rew-wer-dir], [#pi-safe-random-mfc-wer-dir],

    // exp 302
    [No pretraining], [1473], [22.78],

    // exp 303
    [Pretraining + fine-tuning], [1480], [22.36],

    // exp 304
    [Pretraining + frozen], [*#exp-301-rew-wer*], [*#exp-301-mfc-wer*],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: flex-caption(
    short: [
      Comparison of the agent's performance for different feature extractor training strategies.
    ],
    long: [
      Comparison of the agent's performance for different feature extractor training strategies.
      In the first case, the model's convolutional backbone is initialized randomly and trained from scratch by the PPO algorithm.
      The second network's backbone is pre-trained, but its weights are not frozen.
      In the last case, the backbone is frozen during the RL training process.
    ],
  ),
)
<table:rl:results:backbone_pretraining>
