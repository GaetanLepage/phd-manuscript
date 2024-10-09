#import "/utils.typ": *

=== Background
<sec:simulator:reverb:background>

#gaet[
  If the _Background_ section becomes more general, we should maybe rename @sec:simulator:reverb
]

==== Problem formulation

#draft[
  Simulating received signal in a reverberant room
]

==== Acoustic reverberation
<sec:simulator:reverb:background:reverb>

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
    24 ln(10) times #volume
  ) / (
    #sound-speed times S times T_60
  )
$ <eq:simulator:background:sabine_inv>
Here, all surfaces are assumed to behave the same, and the _equivalent absorption surface_ #area may then be written as $#area = S times e_"abs"$, with $S$ being the total surface area.

==== Room Impulse Response

#draft[TODO: introduce the concept of #acr("RIR")]


#figure(
  image("figures/rir_plot.svg", height: 10em),
  caption: [
    Plot of an #acr("RIR") filter @fu_gpu-based_2016
  ],
) <fig:simulator:background:rir_plot>


Once the pairwise $n_m times n_s$ #acr("RIR") filters have been computed, the resulting signal received at microphone $k$ is obtained by convolving it with the source signal:
$
  m_k [t] = sum_(i=1)^(n_s) (h_(i, k) * s_i)[t]  #h(2em) forall k in [|1, n_m|]
$ <eq:simulator:rir_listened_signal>



==== Spectral representations of audio signals
<sec:simulator:background:spectral-features>

#gaet[
  Not sure that this section will actually end up in *Simulator\/Background*.\
  Originally, it was in the #acr("SSL") chapter but I was referring to those notions as soon as in the Simulator chapter.
]


#draft[
  The numerical representation of the audio information is a crucial for achieving #acr("SSL").
  Several pre-processing methods exist to ease the extraction of geometric information.
  
  #figure(
    image("figures/waveform.svg", height: 5cm),
    caption: [
      An example of a waveform acoustic signal
    ],
  ) <fig:ssl:sota:waveform>
  
  #draft[
    - Talk about discretization/sampling
    - Cite wave2vec as a method that directly operates on waveforms
  ]
]

*Fourier transform, from continuous to discrete*

Although the waveform rendering of an audio signal is a raw and natural representation of the information, several alternative higher-level transforms have been studied in the acoustic literature.
// TODO: Fourier 'Transfom' or 'transform'
A popular way of representing audio signals is to project the temporal signal in the Fourier domain.
The Fourier transform stands as the core concept of this category of encoding.
#gaet[Should we go as far as giving the definition of the Fourier Transform ?]
#xavi[In my opinion no.]
#chris[It is a well-known process and you do not really modify it, so only reference it. Only in case you have more time then you could think about explaining it in detail.]
// TODO FT -> STFT (continuous) -> STFT (discrete)
#draft[TODO cite @smith_scientist_1997]
As acoustic signals are stored and processed numerically, the continuous framing of the Fourier transform cannot be directly employed.
Instead, the #acr("STFT") algorithm allows to convert the temporal real-valued signal into a two-dimensional complex form.
$ "STFT"(x) in CC^(F times T) $

$
  X[n, f] = sum_(m=-infinity)^(infinity) w[n-m] x[m] e^(-2i pi f m)
$ <eq:ssl:sota:stft_inf>

$
  X[n, f] &= sum_(m=n-(N_w - 1))^n w[n-m] x[m] e^(-2i pi f_k m)\
   &= sum_(m=n-(N_w - 1))^n w[n-m] x[m] e^((-2i pi m k) / N)
$ <eq:ssl:sota:stft_inf>

// TODO Introduce the notations. Maybe x(t) is defined in the above section
//TODO: give the actual definition
// #figure(
//   square(size: 10em, stroke: 2pt),
//   caption: [
//   ],
// ) <fig:ssl:sota:spectrogram>
This target domain is often referenced as the time-frequency plan.


*Binaural cues #draft[(Interaural ?)]*
<sec:simulator:background:spectral-features:binaural>

====== Motivation

#draft[Single microphone]


Let us first consider the ideal case of a single receiver in the free-field.
The latter means that the environment can be considered as anechoic.
Hence, no sound reflections are considered and thus the reverberation phenomenon is ignored.

The signal $x$ received by the microphone can be expressed as a function of the source signal $s$ by the following equation:

#let d = $colMath(d, #olive)$
#let c = $colMath(c, #maroon)$
$
  x(t) = 1 / (sqrt(4 pi) #d) s (t - #d/#c)
$ <eq:ssl:background:binaural_cues:single_mic_continuous>

where
- #d is the source-to-microphone distance (in m)
- $#c approx 343$ is the speed of sound (in m/s at 20°C)
- $#d/#c$ is the time of arrival (in s)

When considering digital signals, @eq:ssl:background:binaural_cues:single_mic_continuous becomes
$
  x[n] = 1 / (sqrt(4 pi) #d) s [n - #d/#c F_s]
$ <eq:ssl:background:binaural_cues:single_mic_discrete>
where Fs ​is the sampling rate (in Hz), neglecting sampling and quantization issues.

The microphone signal can be rewritten as
$
  x[n] = (h * s)[n]
$
where $h[n] =  1 / (sqrt(4 pi) #d) delta [n - #d/#c F_s]$ characterizes the acoustic path from the source to the microphone. $delta$ denotes the Dirac delta function.

====== Definition

When considering a pair of microphones, it becomes possible to define interaural features.
Those quantities and techniques have been introduced in the context of understanding and modeling binaural hearing.

Let us assume a setting with a single speech source outputting the input signal $s(t)$ and a binaural microphone array.
The signal received by the left and right microphones can be expressed as:
$
  cases(
    l(t) = s(t - tau_l) * h_l(t),
    r(t) = s(t - tau_r) * h_r(t)
  )
$ <eq:ssl:background:binaural_cues:binaural_signals>
where $s$ is the source signal produce by the sound source and $h_l$ and $h_r$ are the #acr("RIR") relative to the left and right microphones.
#draft[TODO: ensure that we have introduced the $*$ operator already.]

We may now consider the ratio of the Fourier transforms of those two signals, called the *interaural spectrogram* 
//We may now consider the ratio of the Fourier transforms of the two #acr("RIR"), called the #acr("RTF"):
$
  I(omega, t) = L(omega, t) / R(omega, t)
  //L(omega, t) / R(omega, t) = alpha(omega, t) e^(j phi.alt(omega, t))
  //L(omega, t) / R(omega, t) = abs(H(omega, t)) e^(-)
$

#reset-acronym("ILD")
#reset-acronym("IPD")
This complex-valued ratio allows to define two fundamental binaural cues: the *#acr("ILD")* and the *#acr("IPD")*.

- The #acr("ILD") is the magnitude of the interaural spectrogram:
$
  "ILD"(omega, t) = 20 log mabs(I(omega, t))
$
<eq:simulator:ild_def>
- The #acr("IPD") denotes the phase of $I$:
$
  "IPD"(omega, t) = arg(I(omega, t))
$
<eq:simulator:ipd_def>

#draft[
  TODO: this might not be useful
  
  which can be modelled by the as:
  $
    L(omega, t) / R(omega, t) approx abs(H(omega)) e^(-j omega tau(omega))
  $
  where $tau(omega) = tau_l - tau_r + angle H(omega)$ is assumed to be smaller than the length of the employed #acr("STFT") window.
  // $
  //   H_"rel"(omega, t) = (H_l (omega)) / (H_r (omega)) = abs(L(omega, t)) / abs(R(omega, t)) e^(alpha(omega, t))
  // $
]

Interaural features, and especially #acr("IPD") has been successfully used in #acr("SSL") as it directly relates to the #acr("DoA").
As @eq:ssl:background:binaural_cues:binaural_signals illustrates, the times at which each microphone of the array receives the signal differ by some short delay $tau$.
Under ideal circumstances, meaning in the absence of reverberation and perturbations such as noise, the phase of the interaural spectrogram explicitly corresponds to the value of $tau$.



// TODO: rephrase the following as this was originally written in the SSL chapter
As explained before, one want to leverage the delays between the signals listened by each microphone.
One of the motivation of using multiple microphones to perform #acr("SSL") is leveraging the delay at which the signal is listened
In the case of a binaural microphone system, #draft[TODO]

@uragun_discrimination_2013 (About the #acr("ILD") feature)

// TODO: Nice stuff about ILD/IPD in "Binaural Hearing for Robots - Methodological Foundations" (see zotero)

// TODO schemas
//- #acr("ILD")
//$ "ILD"(S_1, S_2) = 20 log_10 abs(S_1/S_2) $
//
//- #acr("IPD")
//$ "IPD"(S_1, S_2) = arg(S_1/S_2) $

#include "figures/tf_rep.typ"

A binaural array has been placed in a room along with a speech source. 
@fig:ssl:sota:tf_representations displays different representations of the audio signal received by the array:
- @fig:ssl:sota:tf_representations:spectrogram shows the spectrogram of the signal received by the left microphone: $20 log abs(L(omega, t))$.
- @fig:ssl:sota:tf_representations:ild and @fig:ssl:sota:tf_representations:ipd show the binaural cues, computed from @eq:simulator:ild_def and @eq:simulator:ipd_def respectively 