#import "/utils.typ": *
#import "../../../_variables.typ": *

#figure(
  image(
    "policy_collapsing.svg",
    width: 100%,
  ),
  caption: flex-caption(
    short: [
      Evolution of the training metrics demonstrating the policy collapsing phenomenon.
    ],
    long: [
      Evolution of the training metrics demonstrating the policy collapsing phenomenon.
      The behavior of two agents is monitored through the agent-to-source distance at the end of the episode #agent-source-final-dist and the average number of #a-forward actions performed per episode.
      The first agent is trained with an uninformative constant (purple) reward while the second one is trained with the #acr("WER") reward.
    ],
  ),
)
<fig:rl:experiments:policy_collapsing>