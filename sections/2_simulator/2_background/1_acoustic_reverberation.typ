#import "/utils.typ": *

=== Background <sec:simulator:background:reverb>

==== Problem formulation

#draft[
  Simulating received signal in a reverberant room
]

==== Acoustic reverberation

- Reverberation time ($T_60$)


The reverberation time can be estimated from the room's dimensions has been empirically expressed by Wallace Clement Sabine as
#let volume = $colMath(V, #maroon)$
#let area = $colMath(A, #olive)$
#let sound-speed = $colMath(c, #eastern)$
$
  T_60 = (24 ln(10))/#sound-speed #volume/#area
    approx 0.16 #volume/#area.
$ <eq:simulator:background:sabine>

where #sound-speed is the speed of sound in the air at 20°C, #volume is the volume of the room (in $m^3$) and #area is the _equivalent absorption surface_ (in sabins).
The latter can be obtained by summing the weighted surface area of each wall (including floor and ceiling):
$
  #area = sum alpha_i s_i
$
where $alpha_i$ and $s_i$ are respectively the absorption coefficients and areas of each surface.
The Sabine equation can be inverted to infer the absorption

#reset-acronym("RIR")
==== #acr("RIR")



#figure(
  image("figures/rir_plot.svg"),
  caption: [
    Plot of an #acr("RIR") filter
  ],
) <fig:simulator:background:rir_plot>



$
  m_k (t) = sum_(i=1)^(n_s) ("RIR"_(i, k) * s_i)(t)
$ <eq:simulator:rir_listened_signal>
