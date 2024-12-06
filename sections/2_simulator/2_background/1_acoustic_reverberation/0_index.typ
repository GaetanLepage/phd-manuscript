#import "/utils.typ": *
#import "../../_notations.typ": *

=== Background
<sec:simulator:reverb:background>

#minitoc(indent: true)

This section lays out a selection of acoustic and audio-processing core concepts.
Such notions are central to the scientific development of the rest of the manuscript.
More precisely, the physical modeling of acoustic signals will be recalled at first.
A description of the phenomenon of reverberation is provided next.
This phenomenon is a common theme in the different robotics problems explored in this thesis.
Our simulator explicitly models reverberant environments.
Finally, the spectral representations of audio signals are discussed in the last section.


==== Fundamentals of sound propagation

#gaet[
  Do we introduce propagation equations before talking about reverberation in general?

  For me, the idea is:
  + Sound propagation (in free-field)
  + Sound propagation in a room -> reflections
  + Concept of the RIR: modeling as a convolution filter
  + TF representations
    - FT, STFT
    - Binaural cues
      - Propagation with a multi-microphone setup (close field vs far field)
      - ILD, IPD (magnitude/phase of the ratio)
    - 
  + conv theorem not holding for STFT and why it still makes sense to use STFTs for this task

  - Maybe we should mention HRTFs as we do binaural for robotics.
    I would maybe get criticized for not mentioning it.
    However, we should insist that we have neglected it in this work.
  - Not sure in what order to put things though:\
    -> Should multi-mic be handled before or after introducing RIR/reverb ?
    Technically, we don't need multi-mic to introduce reverb...
]

#draft[
  Explain that this section uses Laurent's lecture notes @girin_fundamentals_nodate

  Other references to include:
  - Book by Vincent, Gannot and Virtanen and @vincent_audio_2018 -> Cite along with the chapter (@vincent_audio_2018 - Chapter 3)
  - Leglaive (on Speech Separation) @leglaive_multichannel_2016
  Introduces the essential tools for reverberation
  - Gustafsson et al. @gustafsson_source_2003: SSL in reverberant environments.
  - Lauri Savioja et al. _Introduction to the Special Issue on Room Acoustic Modeling and Auralization_ @savioja_introduction_2019\
    Only an introduction to a series of paper on room acoustic modeling.
]

Sound is a mechanical wave phenomenon.
Sound waves propagate in various mediums, such as air, water, and solids.
Naturally, sound is represented as a real-valued temporal signal $x(t)$.
While physical recording devices are analogic and capture a continuous signal, this representation is often quantized and sampled to obtain a discrete signal $x[n]$.
Discrete representations allow the numerical processing and saving of sound signals.

While many modern algorithms, especially #acr("DNN")-based solutions, process sound as purely statistical data, the physical reality of acoustic phenomena is a central aspect of this thesis.
Indeed, this work aims to tackle various audio-related tasks in reverberant environments.
Thus, it is necessary to highlight the impact of physical reality on recorded signals to study how they will affect the performance of the proposed methods later.

Let us first consider the ideal case of a single receiver in the free field.
Free field denotes an idealized environment that can be considered anechoic.
Hence, no sound reflections are considered; thus, the reverberation phenomenon is ignored.

The signal $x$ received by the microphone can be expressed as a function of the source signal $s$ by the following equation (@vincent_audio_2018 - Chapter 3):

$
  x(t) = 1 / (sqrt(4 pi) #d) s (t - #d/#c)
$ <eq:simulator:background:single_mic_continuous>

where
- #d is the source-to-microphone distance (in m)
- $#c approx 343$ is the speed of sound (in m/s at 20°C)
- $#d/#c$ is the time of arrival (in s)
In this simple case, the received signal corresponds to a delayed and attenuated version of the source signal.

When considering digital signals, @eq:simulator:background:single_mic_continuous becomes
$
  x[n] = 1 / (sqrt(4 pi) #d) s [n - #d/#c #freq]
$ <eq:simulator:background:single_mic_discrete>
where #freq ​is the sampling rate (in Hz), neglecting sampling and quantization issues.

The microphone signal can be rewritten as
$
  x[n] = (h * s)[n]
$
<eq:simulator:background:single_mic_signal_freefield>
where $h[n] =  1 / (sqrt(4 pi) #d) delta [n - #d/#c #freq]$ characterizes the acoustic path from the source to the microphone. $delta$ denotes the Dirac delta function.


==== Acoustic reverberation
<sec:simulator:reverb:background:reverb>

*Reverberant environments*

Most realistic scenarios do not behave so simply, and other physical phenomena must be modeled.
In a closed environment, such as an indoor room, sound will reflect on walls and cause reverberation.
A reverberant room can be modeled as a #acr("LTI") causal system by neglecting secondary effects such as temperature and pressure changes.
Hence, expressing the listened signal as a convolution remains possible, similarly to @eq:simulator:background:single_mic_signal_freefield:
$
  x[n] = (#rir * s)[n]
$

*Room Impulse Response*

#reset-acronym("RIR")
The filter #rir is called the *#acr("RIR")*.
It depends on the positions of the microphone and source, the walls' acoustic properties, and the room's dimensions.
Hence, the #acr("RIR") is defined for each source-microphone pair.
It characterizes how the sound travels between their positions and is thus sufficient to reconstruct the listened signal.
As its name suggests, the #acr("RIR") depicts the room's acoustic response to an impulse, modeled by a Dirac delta function:
$
  x[n] = (#rir * delta)[n] = #rir [n]
$
The #acr("RIR") filter encodes the multiple propagation paths between the source and the microphone.
Each path has a specific delay and attenuation factor.

#figure(
  image("figures/rir_schema.svg", height: 16em),
  caption: flex-caption(
    [
      Schematic representation of an RIR filter.
      It can be decomposed in three sections:
        #text(fill: rgb("#cc0000"))[direct path],
        #text(fill: rgb("#7f00ff"))[early reflections]
        and #text(fill: rgb("#006633"))[late reverberation].
    ],
    // Short caption for the TOC
    [
      Schematic representation of an RIR filter.
    ]
  ),
) <fig:simulator:background:rir_schema>


@fig:simulator:background:rir_schema gives a schematic illustration of an #acr("RIR") filter.
It can be decomposed into three sections.
The first is the _direct path_, which corresponds to the signal reaching the microphone directly from the source without reflecting on any surface.
This corresponds to @eq:simulator:background:single_mic_continuous describing sound propagation in an anechoic room.
The delay amounts to $tau_r = #d / #c$.
Secondly, follow the _early echoes_, which are the first reflections on the walls.
Finally, the late reflections correspond to the echoes bouncing several times before reaching the microphone.
They form the long and dense tail of the #acr("RIR") filter.
The boundary between early echoes and late reflections is called the _mixing time_ and depends on the room's acoustic characteristics.

// TODO: add real plot of an RIR (simulated one)
// #figure(
//   image("figures/rir_schema.svg", height: 16em),
//   image("figures/rir_plot.svg", height: 16em),
//   caption: [
//     Plot of an #acr("RIR") filter @fu_gpu-based_2016
//   ],
// ) <fig:simulator:background:rir_plot>


*Model limitations*

#figure(
  image("figures/reflection_types.svg", width: 100%),
  caption: [Illustration of the different ways sound interacts with surfaces @di_carlo_echo-aware_2020],
)

The #acr("RIR") model does not account for all the existing reflection phenomena.
Sound will interact in various, potentially simultaneous, ways with the surface it encounters.
It might reflect from the surface, leading to reverberation, but it can also be partly diffracted (in the presence of a small aperture), refracted, or absorbed.
Besides, the reflection can be of two kinds.
On the one hand, smooth surfaces lead to specular reflections that behave similarly to light reflecting on a mirror.
This is the only phenomenon modeled by the #acr("RIR") approach.
On the other hand, diffuse reflections occur when the surface is imperfect or rough.
In this case, the trajectories of the reflected waves are entirely unpredictable.
The #acr("RIR") paradigm solely accounts for specular reflections.

*Multiple sources and microphones*

When several sources are active in the room, the sound received by a microphone is the sum of each source's contribution.
This formulation is known as a mixture model (@vincent_audio_2018 - Chapter 3)
These individual contributions are the convolution between each source's signal $s_i$ and the corresponding #acr("RIR") $h_i$.
The final received signal can be expressed as:
$
  x[n] = sum_(i=1)^(n_s) (h_i * s_i)[t]
$
<eq:simulator:rir_listened_signal_multi_source>

@eq:simulator:rir_listened_signal_multi_source can be straightly generalized to multiple microphones ${m_1, dots, m_(n_m)}$.
The signal recorded by the $k$-th receiver is:
$
  m_j [t] = sum_(i=1)^(n_s) (h_(i, j) * s_i)[t]  #h(2em) forall j in [|1, n_m|]
$
<eq:simulator:rir_listened_signal_multi_source_multi_mic>
where $h_(i, j)$ is the #acr("RIR") filter corresponding to the pair of positions of source $s_i$ and microphone $m_j$.
Hence, $n_s times n_m$ #acr("RIR") filters must be computed for a scene involving $n_s$ active sources and $n_m$ receivers.
Unfor


*Reverberation time ($T_60$)*

The reverberation time noted $T_60$ or RT60 can be estimated from the room's dimensions and has been empirically expressed by Wallace Clement Sabine as
#let volume = $colMath(V, #maroon)$
#let area = $colMath(A, #olive)$
#let sound-speed = $colMath(c, #eastern)$
$
  T_60 = (24 ln(10))/#sound-speed #volume/#area
    approx 0.16 #volume/#area.
$ <eq:simulator:background:sabine>

where #sound-speed is the speed of sound in the air at 20°C, #volume is the volume of the room (in $m^3$), and #area is the _equivalent absorption surface_ (in sabins).
The latter can be obtained by summing the weighted surface area of each wall (including floor and ceiling):
$
  #area = sum_(i=1)^6 e_("abs", i) s_i
$
where $e_("abs", i)$ and $s_i$ are each surface's absorption coefficient and area, respectively.
The Sabine equation can be inverted to infer the overall absorption coefficient $e_"abs"$ of the room from a reverberation time $T_60$:
$
  e_"abs" = (
    24 ln(10) times #volume
  ) / (
    #sound-speed times S times T_60
  )
$ <eq:simulator:background:sabine_inv>
Here, all surfaces are assumed to behave the same, and the _equivalent absorption surface_ #area may then be written as $#area = S times e_"abs"$, with $S$ being the total surface area.


==== Spectral representations of audio signals
<sec:simulator:background:spectral-features>

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

#draft[
  - Brief mention of the continuous Fourier transform
  - Definition and motivation of the STFT
  - Limitations and hypotheses:
    - Allows to process short windows where speech is considered stationary. (Although, this is not really useful for #acr("SSL") itself)
    - Convolution theorem not holding anymore.
]

Although the waveform rendering of an audio signal is a raw and natural representation of the information, the acoustic literature has studied several alternative higher-level transforms.
A popular way of representing audio signals is to project the temporal signal in the Fourier domain.
The Fourier transform stands as the core concept of this category of encoding.

// TODO FT -> STFT (continuous) -> STFT (discrete)
#draft[TODO cite @smith_scientist_1997]
As acoustic signals are stored and processed numerically, the continuous framing of the Fourier transform cannot be directly employed.
Instead, the #acr("STFT") algorithm allows converting the temporal real-valued signal into a two-dimensional complex form.
$
  "STFT"(x) in CC^(F times T)
$

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



#draft[
  -> To be written after the introduction of the TF representations.
  Intuitively, we work in the TF domain as, there, the listened signal is supposed to be the product of the clean signal with the RIR filter.
  However, this is not theoretically true (even not true in practice).
  Indeed, the convolution theorem (i.e. conv \<-> product) does not apply with the STFT.
  See slide \#184 of Laurent's slides _Fundamentals of Audio Processing_.
  Although this is not true, the TF representations have been widely used in the literature and are a powerful tool for audio processing, especially with DL.
]
  
*Motivation for using #acr("STFT") for reverberant signals.*
The convolution theorem grants one of the fundamental properties of the Fourier transform.
It states that the Fourier transform of a convolution is the product of the Fourier transforms:
$
  cal(F)(f * g) = cal(F)(f) times cal(F)(g) \
$
<eq:simulator:conv_theorem>
Additionally, the transform of a product is the convolution of the transforms:
$
  cal(F)(f times g) = cal(F)(f) * cal(F)(g)
$
This result gives an intuitively compelling argument for using Fourier representations in problems involving reverberant environments.
Indeed, the reverberation phenomenon can be modeled as the convolution of a source signal with the #acr("RIR") filter in the time domain.
Hence, it translates into a product in the Fourier domain, making it easier to disentangle information from the raw signal from the listened one.
However, it must be noted that the convolution theorem does not hold for the #acr("STFT").
It can be verified for the general #acr("DFT") under certain conditions but is wrong when using short-term frames.
In practice, the length of the #acr("STFT") window function is often significantly shorter than the length of the convolution.

Despite this theoretical result not transferring to the #acr("STFT")-based representations, they are still widely used in the literature when dealing with reverberating phenomena.


*Binaural cues*
<sec:simulator:background:spectral-features:binaural>

*Motivation*

Using multiple microphones opens a wide range of possibilities in audio processing tasks.
Humans rely on their two ears to exploit the spatiality of their auditory environment.
Similarly, the signal processing community has exploited microphone arrays and developed algorithms to usefully aggregate signals from several sensors.
Array processing spans several downstream tasks, such as speech enhancement @gannot_consolidated_2017, dereverberation @gaubitch_analysis_2005 @nakatani_blind_2008, sound source localization @alameda-pineda_geometric_2014 @grumiaux_survey_2021 @perotin_localisation_2019 or acoustic scene analysis @imoto_spatial_2017.
Disposing of more than one microphone allows computing the #acr("TDoA")

Many array configurations have been experimented with.
Both geometries (linear, polygons, spheres, or more complex arrangements) and the number of microphones (from two to several thousand) vary widely across applications.
The binaural setup is one of the most studied configurations as it is an effort to model human hearing.
In this case, specific signal representations have been proposed to ease extracting relevant information.

Some data representations have been introduced for the specific case of binaural devices.
This section focuses on those.

// Beamforming ?

*Sound propagation with multi-microphone setting*

#figure(
  image(
    "figures/multi_mic_schema.svg",
    height: 10em,
  ),
  //square(size: 10em, stroke: 2pt),
  caption: [
    Two-microphone setup
  ],
)
<fig:simulator:background:multi_mic_schema>

#draft[
  For Reverb: Free field vs Room -> Reverb vs not reverb\
    direct path / higher order reflections
  For SSL: far field vs close field:\
    This is more for SSL
]

The signal received by microphone $i$ can be expressed as:
$
  x_i [n] = 1 / (sqrt(4 pi) d_i) s[n - d_i/#c #freq]
$
@gustafsson_source_2003
#draft[Maybe add more references]
where $d_i$ is the distance from the the source $i$ to the source (see @fig:simulator:background:multi_mic_schema)

One can write signal $x_2$ recorded by microphone $2$ as a function of the one recorded by microphone $1$ by combining their expressions:
$
  x_2[n] = d_1 / d_2 x_1 [n - (d_2 - d_1)/(#c) #freq]
$

On the other hand one could imagine setting this value to


#draft[
  TODO: Originally, here was the explanation about how sound propagates in anechoic/reverberant environments.
  This has been moved to the beginning of the _Background_ section.
  Maybe we should move the multi-mic approach to this paragraph...
  - Single-mic stays at the beginning
  - Multi-mic moves here

  ~
  - Two types of approach:
    - Many microphones to maximize the amount of (geometrical) information collected
    - Binaural setups to mimic human hearing
]

*Relative Transfer Function*

#reset-acronym("RTF")
The #acr("RTF") is the ratio of the receiver acoustic transfer functions of a microphone $h_i$ and that of a reference microphone $h_1$ @gannot_signal_2001 @li_estimation_2015.
This conc


#draft[
  - @cohen_relative_2004 - Relative transfer function identification using speech signals. Cohen et al.
  - @li_reverberant_2016 - Reverberant sound localization with a robot head based on direct-path relative transfer function
  - @li_estimation_2015 - Estimation of Relative Transfer Function in the Presence of Stationary Noise Based on Segmental Power Spectral Density Matrix Subtraction
]

*Definition*

When considering a pair of microphones, defining interaural features becomes possible.
Those quantities and techniques have been introduced in the context of understanding and modeling binaural hearing.

Let us assume a setting with a single speech source outputting the input signal $s(t)$ and a binaural microphone array.
The signal received by the left and right microphones can be expressed as the following convolutions:
$
  cases(
    l(t) = s(t - tau_l) * h_l(t),
    r(t) = s(t - tau_r) * h_r(t)
  )
$ <eq:ssl:background:binaural_cues:binaural_signals>
where $s$ is the source signal produce by the sound source and $h_l$ and $h_r$ are the #acr("RIR") relative to the left and right microphones.

We may now consider the ratio of the Fourier transforms of those two signals, called the *interaural spectrogram* 
//We may now consider the ratio of the Fourier transforms of the two #acr("RIR"), called the #acr("RTF"):
$
  I(omega, t) = L(omega, t) / R(omega, t)
  //L(omega, t) / R(omega, t) = alpha(omega, t) e^(j phi.alt(omega, t))
  //L(omega, t) / R(omega, t) = abs(H(omega, t)) e^(-)
$

#reset-acronym("ILD")
#reset-acronym("IPD")
This complex-valued ratio defines two fundamental binaural cues: the *#acr("ILD")* and the *#acr("IPD")*.

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

Interaural features, and especially #acr("IPD") have been successfully used in #acr("SSL") as it directly relates to the #acr("DoA").
As @eq:ssl:background:binaural_cues:binaural_signals illustrates, the times at which each microphone of the array receives the signal differ by some short delay $tau$.
Under ideal circumstances, meaning in the absence of reverberation and perturbations such as noise, the phase of the interaural spectrogram explicitly corresponds to the value of $tau$.



#draft[
  TODO: rephrase the following as this was originally written in the SSL chapter
  As explained before, one want to leverage the delays between the signals listened by each microphone.
  One of the motivations for using multiple microphones to perform #acr("SSL") is leveraging the delay #acr("TDoA")
  In the case of a binaural microphone system, #draft[TODO]
]

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