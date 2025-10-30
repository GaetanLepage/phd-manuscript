#import "../../../../../utils.typ": *

#figure(
  move(
    image(
      "dataset_setup.svg",
      width: 100%,
    ),
    dx: 6.5em,
  ),
  caption: flex-caption(
    short: [
      Agent position initialization for the dataset collection
    ],
    long: [
      Agent at the start and intermediary positions for a generated trajectory.
      The initial orientation is sampled in the cone delimited by dotted lines.
    ],
  ),
)
<fig:active_ssl:results:dataset_init>
