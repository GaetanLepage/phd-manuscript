#import "/utils.typ": *

=== Background
<sec:simulator:background:reverb>

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
  #area = sum_(i=1)^6 e_("abs", i) s_i
$
where $e_("abs", i)$ and $s_i$ are respectively the absorption coefficients and areas of each surface.
The Sabine equation can be inverted to infer the overall absorption coefficient $e_"abs"$ of the room from a reverberation time $T_60$:
$
  e_"abs" = (
    24 ln(10) times V
  ) / (
    c times S times T_60
  )
$ <eq:simulator:background:sabine_inv>
Here, all surfaces are assumed to behave the same, and the _equivalent absorption surface_ #area may then be written as $#area = S times e_"abs"$, with $S$ being the total surface area.

==== Room Impulse Response

#draft[TODO: introduce the concept of #acr("RIR")]


#figure(
  image("figures/rir_plot.svg", height: 10em),
  caption: [
    Plot of an #acr("RIR") filter
  ],
) <fig:simulator:background:rir_plot>


Once the pairwise $n_m times n_s$ #acr("RIR") filters have been computed, the resulting signal received at microphone $k$ is obtained by convolving it with the source signal:
$
  m_k [t] = sum_(i=1)^(n_s) (h_(i, k) * s_i)[t]  #h(2em) forall k in [|1, n_m|]
$ <eq:simulator:rir_listened_signal>