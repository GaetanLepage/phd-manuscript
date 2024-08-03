#import "/utils.typ": *

=== Background <sec:simulator:background:reverb>

==== Problem formulation

#draft[
  Simulating received signal in a reverberant room
]

==== Acoustic reverberation

- Reverberation time ($T_60$)

#reset-acronym("RIR")
==== #acr("RIR")

$
  m_k (t) = sum_(i=1)^(n_s) ("RIR"_(i, k) * s_i)(t)
$ <eq:simulator:rir_listened_signal>

