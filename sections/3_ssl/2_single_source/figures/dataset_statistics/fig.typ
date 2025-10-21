#import "/utils.typ": *

#figure(
  move(
    image(
      "dataset_statistics.svg",
      height: 10cm,
    ),
    dx: 33pt,
  ),
  caption: flex-caption(
    short: [
      Statistics of ground-truth label pairs ($theta$, $D$) in the generated dataset.
    ],
    long: [
      Statistics of ground-truth label pairs ($theta$, $D$) in the generated dataset.
      Microphone and source positions are randomly sampled within a rectangular room, resulting in a uniform distribution of #doa values.
      Source-to-array distances range from 0 to 7 meters, with values around 2-3 meters being the most frequent.
    ],
  ),
)
<fig:ssl:single_source:dataset_statistics>
