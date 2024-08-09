#import "/utils.typ": *

== Sound source localization background <sec:ssl:sota>

#reset-acronym("SSL")

=== Original problem
// Very broad introduction
#acr("SSL") is part of the classic challenges in artificial speech processing.
This challenge requires to identify the relative position of one or several sound sources leveraging an audition device.

// TODO: motivate this problem: why is it relevant, give examples in robotics

// DoA - only vs dist + DoA
The exhaustivity of the
Importantly, one may attempt at determining both the angle

A broad range of specific settings and methods have been investigated in the audio processing literature.


// TODO: not sure that this "motivation" paragraph belongs here. Maybe more in the chapter intro ?
Our intent at exploring #acr("SSL") was initially motivated by our exploratory work in Deep Reinforcement Learning (see @chap:rl).



=== Acoustic data representation <sec:ssl:sota:data_repr>

#chris[Do you use all of them? Concentrate at the the moment only on the methods you use. If you have later more time, then you can give others more place in a related work section.]
#gaet[No, but as this is the SotA section, I thought important to be more exhaustive.]

The numerical representation of the audio information is a crucial for achieving #acr("SSL").
Several pre-processing methods exist to ease the extraction of geometric information.

==== Waveform

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

==== Time-frequency representations

Although the waveform rendering of an audio signal is a raw and natural representation of the information, several alternative higher-level transforms have been studied in the acoustic literature.
// TODO: Fourier 'Transfom' or 'transform'
A popular way of representing audio signals is to project the temporal signal in the Fourier domain.
The Fourier transform stands as the core concept of this category of encoding.
#gaet[Should we go as far as giving the definition of the Fourier Transform ?]
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


===== Binaural cues

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

======= Definition

When considering a pair of microphones, it becomes possible to define interaural features.
Those quantities and techniques have been introduced in the context of understanding and modelling binaural hearing.

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
- The #acr("IPD") denotes the phase of $I$:
$
  "IPD"(omega, t) = arg(I(omega, t))
$

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
In the case of a binaural microphone system,

@uragun_discrimination_2013 (About the #acr("ILD") feature)

// TODO: Nice stuff about ILD/IPD in "Binaural Hearing for Robots - Methodological Foundations" (see zotero)

// TODO schemas
//- #acr("ILD")
//$ "ILD"(S_1, S_2) = 20 log_10 abs(S_1/S_2) $
//
//- #acr("IPD")
//$ "IPD"(S_1, S_2) = arg(S_1/S_2) $

#subpar.grid(
  figure(
    square(size: 10em, stroke: 2pt),
    caption: [
      Spectrogram
    ]
  ), <fig:ssl:sota:tf_representations:spectrogram>,
  figure(
    square(size: 10em, stroke: 2pt),
    caption: [
      #reset-acronym("ILD")
      #acr("ILD")
    ]
  ), <fig:ssl:sota:tf_representations:ild>,
  figure(
    square(size: 10em, stroke: 2pt),
    //image("/assets/mountains.jpg"),
    caption: [
      #reset-acronym("IPD")
      #acr("IPD")
    ]
  ), <fig:ssl:sota:tf_representations:ipd>,
  columns: (1fr, 1fr, 1fr),
  align: top,
  caption: [Illustration of time-frequency representations of a speech signal],
  label: <fig:ssl:sota:tf_representations>,
)

A binaural array has been placed in a room along with a speech source. 
@fig:ssl:sota:tf_representations displays different representations of the audio signal received by the array:
- @fig:ssl:sota:tf_representations:spectrogram shows the spectrogram of the signal received by the left microphone: $20 log abs(L(omega, t))$.

#reset-acronym("GCC-PHAT")
===== #acr("GCC-PHAT")

// https://dsp.stackexchange.com/questions/74574/understanding-gcc-phat-as-a-feature


=== Classical approaches <sec:ssl:sota:classical_approaches>

// Handcrafted features

// Statistical methods
@alameda-pineda_geometric_2014

// Sharon's paper on estimators and their performance



=== Deep Learning methods for #acr("SSL") <sec:ssl:sota:deep_learning>

// Survey paper
@grumiaux_survey_2021


=== Sound Source localization in robotics <sec:ssl:sota:ssl_in_robotics>

Although, as demonstrated above, #acr("SSL") has been studied as a self-contained problem, it certainly have an important number of downstream applications.
Among those, robotics is a major use case of #acr("SSL") algorithms.
Perception is an essential building block of a social robotics platform.
Besides the exploitation of visual features which falls under the computer vision domain, leveraging the audio cues may provide valuable information for a social robot.
Naturally, such an agent will use language as the primary mean of communication with humans and will thus need to extract the meaning of the speech of its interlocutors.
Besides #("ASR"), sound information may have additional use cases.

// Other uses of audio in robotics
For instance, human-robot interaction can be enhanced by having the agent adjust its gaze and look at the person it is interacting with.
// TODO: cite study that backs this claim
This has been achieved by the mean of computer vision techniques but #acr("SSL") also yields positive results. // TODO cite some works that do this
A robot being able to accurately locate other sound sources can also adjust its navigation policy to benefit from this knowledge.
Robot navigation is likewise complex and often relies on multi-modal perception.
The use of LIDAR or depth information are used for the robot to localize itself as well as other potentially moving subjects in the environment.
// TODO citations
However, identifying the position of currently speaking humans requires some sort of #acr("SSL") method.

// Constraint related to robotics
Robotics also brings additional challenges to the #acr("SSL") task.
Indeed, a robotic platform implies to deal wit several constraints mainly caused by interacting with the real world.
#draft[
// TODO:
- Reverberation
- Moving objects
- Intermittent sources
- Noise (motor noise, music, multiple concurrent sources)
]

// Classical approaches
#draft[Back in ..., researchers have intended to localize ...]
// TODO: cite some works
// - Xavi+Radu's paper
// - older perception work ?

// Deep Learning
Deep learning methods have been used as well to perform #("SSL") in robotics.

// Using multi-modal information (audio-visual SSL)
// -> Not directly related to our topic though