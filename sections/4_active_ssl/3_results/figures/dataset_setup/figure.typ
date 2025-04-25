#import "/utils.typ": *

#figure(
  move(
    image(
      "dataset_setup.svg",
      width: 100%,
    ),
    dx: 6.5em,
  ),
  caption: flex-caption(
    [
      Agent at start and intermediary position for a generated trajectory.
      The initial orientation is sampled in the cone delimited by dotted lines.
    ],
    [Agent position initialization for the dataset collection]
  )
)
<fig:active_ssl:results:dataset_init>