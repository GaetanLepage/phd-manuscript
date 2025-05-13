#import "/utils.typ": *
#import "../../../_variables.typ": *

#figure(
  image(
    "map.svg",
    width: 80%,
  ),
  caption: flex-caption(
    short: [
      Example of a directional analytical cost map.
    ],
    long: [
      Directional (east orientation) analytical cost map.
      Each pixel corresponds to the value of $#analytical-cost$ for a specific agent position.
      From this view, the agent's orientation is kept constant as it faces the right direction.
      The cost is significantly lower when the agent is located close to the source and is facing it.
    ],
  )
)
<fig:rl:results:analytical_map>