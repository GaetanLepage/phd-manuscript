#import "/utils.typ": *

#let fig-width = 90%
#subpar.grid(
  // Source at the center
  figure(
    image(
      "traj_1.svg",
      width: fig-width,
    ),
    caption: [
      Source position $(6, 3)$
    ]
  ),
  <fig:rl:results:trajectories:1>,

  // Source at the center
  figure(
    image(
      "traj_2.svg",
      width: fig-width,
    ),
    caption: [
      Source position $(3, 2)$
    ],
  ),
  <fig:rl:results:trajectories:2>,
  
  columns: 1,
  caption: flex-caption(
    short: [
      Examples of agent trajectories after training.
    ],
    long: [
      Examples of agent trajectories after training.
      For a given 
    ],
  ),
  align: top,
  placement: fig-placement,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  gap: grid-fig-gap,
  label: <fig:rl:results:wer_maps_reverb>,
)