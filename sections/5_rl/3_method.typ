#import "/utils.typ": *

== Method
<sec:rl:method>

=== Acoustic pipeline

The abstract environment defined previously in @sec:rl:problem:formulation:environment is implemented in practice thanks to our simulator @sec:simulator:simulator.

#draft[
  - Audio simulator (in continuous mode ?)
  - It implements the transition dynamics (geometrically, room)
  and the observability function (sources/simulator)
]

=== #acr("WER") maps as a reward
<sec:rl:method:wer_maps>

The reward signal introduced previously expects an oracle $w$ to provide an estimate of the #acr("WER") score for each possible position on the grid.

==== 

#draft[
  - Present how we implement the WER oracle $w$
  - Motivation: Computation challenges: pre-compute maps instead of live computation
  
  - Also, WER does not make sense for a single position
  
  - Explain the different reward schemes
  
  - Motivation: use #acr("ASR") as objective
]


=== Deep Neural Agent

// TODO: add figure

==== Pre-trained acoustic feature extractor