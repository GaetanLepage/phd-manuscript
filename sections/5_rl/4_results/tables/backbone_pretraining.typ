#import "/utils.typ": *
#import "utils.typ": *
#import "/_misc/notations.typ": *


#figure(
  table(
    // SETTINGS
    //columns: 3 * (1fr,),
    columns: 3,
    align: left + horizon,
    stroke: none,
    
    // HEADER
    toprule,

    table.header(
      [Feature extractor training strategy],
      mean-cum-reward-header,
      mfc-header,
    ),

    midrule,

    // exp 302
    [No pretraining], [#todo], [#todo],
    // exp 303
    [Pretraining + fine-tuning], [#todo], [#todo],
    // exp 304
    [Pretraining + frozen], [#todo], [#todo],

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
      In the first case, the model's convolutional backbone is initialized randomly and trained from scratch by the #acr("PPO") algorithm.
      The second network's backbone is pre-trained, but its weights are not frozen.
      In the last case, the backbone is frozen during the #acr("RL") training process.
    ],
  ),
)
<table:rl:results:backbone_pretraining>