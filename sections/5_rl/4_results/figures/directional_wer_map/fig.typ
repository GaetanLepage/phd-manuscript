#import "/utils.typ": *

#figure(
  image(
    "directional_map.svg",
    width: 80%,
  ),
  caption: flex-caption(
    short: [
      Example of a directional WER cost map.
    ],
    long: [
      Example of a directional WER cost map.
      The four sub-figures correspond to the four cardinal agent orientations.
      The average #acr("WER") was computed from recordings at each position and cardinal orientation of a cardioid microphone.
      Hence, the obtained cost depends on both the agent's position and orientation.
    ],
  ),
)
<fig:rl:results:directional_map>
