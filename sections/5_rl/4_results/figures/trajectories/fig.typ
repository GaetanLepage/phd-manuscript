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
      Source position $(6, 3)$.
    ],
  ),
  <fig:rl:results:trajectories:1>,

  // Source at the center
  figure(
    image(
      "traj_2.svg",
      width: fig-width,
    ),
    caption: [
      Source position $(3, 2)$.
    ],
  ),
  <fig:rl:results:trajectories:2>,

  columns: 1,
  caption: flex-caption(
    short: [
      Examples of agent trajectories for two distinct source positions.
    ],
    long: [
      Examples of agent trajectories for two distinct source positions.
      Each sub-figure represents 10 different trajectories corresponding to a random agent starting position.
      In every case, the agent successfully learns to navigate to the source, minimizing the #acr("WER").
    ],
  ),
  align: top,
  placement: fig-placement,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  gap: grid-fig-gap,
  label: <fig:rl:results:trajectories>,
)
