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


==== Fundamentals of Sound Propagation

Sound is a mechanical wave phenomenon.
Sound waves propagate in various mediums, such as air, water, and solids.
Naturally, sound is represented as a real-valued temporal signal $x(t)$.
While physical recording devices are analogic and capture a continuous signal, this representation is often quantized and sampled to obtain a discrete signal $x[n]$.
Discrete representations allow the numerical processing and saving of sound signals.

While many modern algorithms, especially #acr("DNN")-based solutions, process sound as purely statistical data, the physical reality of acoustic phenomena is a central aspect of this thesis.
Indeed, this work aims to tackle various audio-related tasks in reverberant environments.
Thus, it is necessary to highlight the impact of the physical reality on recorded signals to study how they will affect the performance of the proposed methods later.

Let us first consider the ideal case of a single receiver in the free field.
Free field denotes an idealized environment that can be considered anechoic.
Hence, no sound reflections are considered; thus, the reverberation phenomenon is ignored.

The signal $x$ received by the microphone can be expressed as a function of the source signal $s$ by the following equation (@vincent_audio_2018 - Chapter 3, @leglaive_multichannel_2016):

$
  x(t) = 1 / (sqrt(4 pi) #d) s (t - #d/#c),
$ <eq:simulator:background:single_mic_continuous>

where
- #d is the source-to-microphone distance (in m)
- $#c approx 343$ is the speed of sound (in m/s at 20°C)
- $#d/#c$ is the time of arrival (in s)
In this simple case, the received signal corresponds to a delayed and attenuated version of the source signal.

When considering digital signals, @eq:simulator:background:single_mic_continuous becomes
$
  x[n] = 1 / (sqrt(4 pi) #d) s [n - #d/#c #freq],
$ <eq:simulator:background:single_mic_discrete>
where #freq ​is the sampling rate (in Hz), neglecting sampling and quantization issues.

The microphone signal can be rewritten as
$
  x[n] = (h * s)[n]
$
<eq:simulator:background:single_mic_signal_freefield>
where $h[n] =  1 / (sqrt(4 pi) #d) delta [n - #d/#c #freq]$ characterizes the acoustic path from the source to the microphone. $delta$ denotes the Dirac delta function.


==== Acoustic Reverberation
<sec:simulator:reverb:background:reverb>

Most realistic scenarios do not behave so simply, and other physical phenomena must be modeled.
In a closed environment, such as an indoor room, sound will reflect on walls and cause reverberation.
A reverberant room can be modeled as a #acr("LTI") causal system by neglecting secondary effects such as temperature and pressure changes.
Hence, expressing the listened signal as a convolution remains possible, similarly to @eq:simulator:background:single_mic_signal_freefield:
$
  x[n] = (#rir * s)[n],
$
<eq:simulator:background:reverb_convolution>

#reset-acronym("RIR")
The filter #rir is called the *#acr("RIR")*.
It depends on the positions of the microphone and source, the walls' acoustic properties, and the room's dimensions.
Hence, the #acr("RIR") is defined for each source-microphone pair.
It characterizes how the sound travels between their positions and is thus sufficient to reconstruct the listened signal.
As its name suggests, the #acr("RIR") depicts the room's acoustic response to an impulse, modeled by a Dirac delta function:
$
  x[n] = (#rir * delta)[n] = #rir [n].
$
The #acr("RIR") encodes the multiple propagation paths between the source and the microphone.
Each path has a specific delay and attenuation factor.

#figure(
  image("figures/rir_schema.svg", height: 16em),
  caption: flex-caption(
    short: [
      Schematic representation of an RIR.
      @savioja_overview_2015
    ],
    long: [
      Schematic representation of an RIR.
      It can be decomposed in three sections:
        #text(fill: rgb("#cc0000"))[direct path],
        #text(fill: rgb("#7f00ff"))[early reflections]
        and #text(fill: rgb("#006633"))[late reverberation].
    ]
  ),
) <fig:simulator:background:rir_schema>


@fig:simulator:background:rir_schema gives a schematic illustration of an #acr("RIR").
It can be decomposed into three sections.
The plot of a real #acr("RIR") recording is visible in @fig:simulator:background:rir_plot.
The first is the _direct path_, which corresponds to the signal reaching the microphone directly from the source without reflecting on any surface.
This corresponds to @eq:simulator:background:single_mic_continuous describing sound propagation in an anechoic room.
The delay amounts to $tau_r = #d / #c$.
Secondly, follow the _early echoes_, which are the first reflections on the walls.
Finally, the late reflections correspond to the echoes bouncing several times before reaching the microphone.
They form the long and dense tail of the #acr("RIR").
The boundary between early echoes and late reflections is called the _mixing time_ and depends on the room's acoustic characteristics.

// TODO: remove if we agree that this is too much
//*Model limitations*

#figure(
  image("figures/reflection_types.svg", width: 100%),
  caption: flex-caption(
    short: [
      Illustration of the different ways sound interacts with surfaces.
    ],
    long: [
      Illustration of the different ways sound interacts with surfaces @di_carlo_echo-aware_2020.
    ],
  ),
)
<fig:simulator:background:reflection_types>


The #acr("RIR") model does not account for all the existing reflection phenomena.
Sound will interact in various, potentially simultaneous, ways with the surface it encounters (@fig:simulator:background:reflection_types).
It might reflect from the surface, leading to reverberation, but it can also be partly diffracted (in the presence of a small aperture), refracted, or absorbed.
Besides, the reflection can be of two kinds.
On the one hand, smooth surfaces lead to specular reflections that behave similarly to light reflecting on a mirror.
This is the only phenomenon modeled by the #acr("RIR") approach.
On the other hand, diffuse reflections occur when the surface is imperfect or rough.
In this case, the trajectories of the reflected waves are entirely unpredictable.
The #acr("RIR") paradigm solely accounts for specular reflections.

//*Multiple sources and microphones*

#block(breakable: false)[
When several sources are active in the room, the sound received by a microphone is the sum of each source's contribution.
This formulation is known as a mixture model (@vincent_audio_2018 - Chapter 3)
These individual contributions are the convolution between each source signal $s_i$ and the corresponding #acr("RIR") $h_i$.
The final received signal can be expressed as:
$
  x[n] = sum_(i=1)^(n_s) (h_i * s_i)[n].
$
<eq:simulator:rir_listened_signal_multi_source>
]

@eq:simulator:rir_listened_signal_multi_source can be straightly generalized to multiple microphones ${m_1, dots, m_(n_m)}$.
The signal recorded by the $k$-th receiver is:
$
  m_j [t] = sum_(i=1)^(n_s) (h_(i, j) * s_i)[t]  #h(2em) forall j in [|1, n_m|],
$
<eq:simulator:rir_listened_signal_multi_source_multi_mic>
where $h_(i, j)$ is the #acr("RIR") corresponding to the pair of positions of source $s_i$ and microphone $m_j$.
Hence, $n_s times n_m$ #acr("RIR")s must be computed for a scene involving $n_s$ active sources and $n_m$ receivers.


==== Characterizing Reverberant Rooms

This section introduces essential quantities that depict the reverberation properties of a room.
They will be essential in the interface of our simulator as they allow specifying how the environment should behave acoustically.

// *Reverberation time ($T_60$)*

#figure(
  image("figures/rir_echogram.svg", height: 16em),
  caption: flex-caption(
    short: [
      Plots of an impulse response and time-energy response recorded in a room.
    ],
    long: [
      #acr("RIR") plot.
      (a) An impulse response recorded in a room.
      It represents the propagation of sound pressure from the sound source to the receiver.
      (b) The associated time-energy response plots the propagation of sound energy.
      @savioja_overview_2015
    ],
  ),
) <fig:simulator:background:rir_plot>

The reverberation time noted $T_60$ or RT60 denotes the time before the sound pressure decreases by 60 dB after the source signal is abruptly stopped.
It can be estimated from the room's dimensions and has been empirically expressed by Wallace Clement Sabine @sabine_collected_1922 as:
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
  #area = sum_(i=1)^6 e_("abs", i) s_i,
$
where $e_("abs", i)$ and $s_i$ are each surface's absorption coefficient and area, respectively.
The Sabine equation can be inverted to infer the overall absorption coefficient $e_"abs"$ of the room from a reverberation time $T_60$:
$
  e_"abs" = (
    24 ln(10) times #volume
  ) / (
    #sound-speed times S times T_60
  ).
$ <eq:simulator:background:sabine_inv>
Here, all surfaces are assumed to behave the same, and the _equivalent absorption surface_ #area may then be written as $#area = S times e_"abs"$, with $S$ being the total surface area.
Srivastava's PhD thesis @srivastava_realism_2023 investigates the role of acoustic parameters in simulation and how to estimate them.

==== Spectral Representations of Audio Signals
<sec:simulator:background:spectral-features>

*Fourier Transform, from Continuous to Discrete*

Although the waveform rendering of an audio signal is a raw and natural representation of the information, the acoustic literature has studied several alternative higher-level transforms.
A popular way of representing audio signals is to project the temporal signal in the Fourier domain.
The Fourier transform stands as the core concept of this category of encoding.
Several resources, such as Oppenheim et al. @oppenheim_discrete-time_1989 (Chapter 2) and Bracewell @ronald_bracewell_fourier_2000 (Chapter 2), propose extensive descriptions of the Fourier Transform and its properties.

// FT -> DFT -> STFT
#reset-acronym("DFT")
#reset-acronym("STFT")
As acoustic signals are stored and processed numerically, the continuous framing of the Fourier transform cannot be directly employed.
In contrast, the signal processing community has turned to the #acr("DFT") to process discrete signals (see Smith @smith_scientist_1997 Chapter 8).
The #acr("STFT") is a tool for representing the temporal real-valued signal as a two-dimensional complex form.
This target domain is often referenced as the time-frequency plan.
It consists of computing the signal's #acr("DFT") on short overlapping smoothed windows.
The #acr("STFT") has been partly motivated by the non-stationarity characteristic of speech.
The signal can be assumed to be locally stationary when using short analysis frames.

Let us first define an #acr("STFT") frame for a given time index $m in ZZ$:
$
  x_m [n] = x[n + m #H] #w [n],
$
where
- $x[n]$ is any sampled real-valued signal ($n in ZZ$);
- $#w [n]$ denotes the analysis window with compact support $[|0, N-1|]$, where $N$ is assumed to be even.
  Several choices can be employed for the shape of #w.
  While, in theory, any function with compact support can be employed, it significantly impacts the result.
  Popular choices include the rectangular, Hamming, and Hann window functions.
- #H is an increment, also called hop size.
  It should remain lower than $N$ to ensure a non-zero overlap $N - H$ between successive frames;
The support of the #acr("STFT") frame $x[n]$ is also $[|0, N-1|]$.
The discrete #acr("STFT") of the signal $x$ is defined as the set of #acrpl("DFT")s of the frames $x_m$, $m in ZZ$:
$
  X[m, k] = 1/sqrt(N) sum_(n=0)^(N-1) x_m [n] e^(-2i pi (k n) / N),
$ <eq:ssl:sota:stft_inf>
where $k$ denotes the frequency index in $[|-N/2 + 1, N/2|]$.
In this definition, both the time and frequency indices are integers.
In practice, the signal has a finite length $L >> N$, leading to approximately $M = ceil(L / H)$ total #acr("STFT") frames.
Hence, a finite-length signal's #acr("STFT") is a complex-valued matrix of size $M times N$.
As practical signals are real-valued, the #acr("STFT") is symmetric, and only positive frequencies ($k in [|0, N/2|]$) are considered.

The time-frequency resolution is a tradeoff directly impacted by the choice of the window size $N$.
Low values of $N$ will produce a wide-band spectrogram with a high time resolution at the cost of a lower frequency resolution.
On the contrary, high values of $N$ will give narrow-band spectrograms with a low time resolution but a high-frequency resolution.

*Spectrogram*

The spectrogram of a signal is a 2D real-valued representation of its #acr("STFT").
It displays the magnitude, phase, or power of the complex #acr("STFT").
The spectrogram allows visualizing a signal as a form of image.
In addition to this practical property, it quantifies the intensity of the signal at each time frame and frequency bin.
Different types of spectrograms can be defined:

- The magnitude spectrogram is the modulus of the #acr("STFT"):
$
  "spectrogram"{x}[m, k] = mabs(X[m, k]).
$
- The power spectrogram, or power spectral density, is its squared modulus:
$
  X_"power" [m, k] = |X[m, k]|^2.
$
- The power spectrogram can also be expressed in decibels (dB):
$
  X_("power", "dB") [m, k] = 20 log_(10) mabs(X[m, k]).
$
@fig:simulator:background:spectrogram is an example of a power spectrogram computed from a speech signal.

- The phase spectrogram is its argument:
$
  X_"phase" [m, k] = arg(X[m, k]).
$
The term spectrogram can also refer directly to the complex-valued result of the #acr("STFT").

#figure(
  image("figures/spectrogram.png", height: 14em),
  caption: [
    Power spectrogram of a two-second-long clean speech recording.
  ],
) <fig:simulator:background:spectrogram>

  
*Motivation for Using #acr("STFT") for Reverberant Signals*

The convolution theorem (Oppenheim et al. @oppenheim_discrete-time_1989 Section 2.9.6) grants one of the Fourier transform's fundamental properties.
#block(breakable: false)[
  It states that the Fourier transform of a convolution is the product of the Fourier transforms:
  $
    cal(F)(f * g) = cal(F)(f) times cal(F)(g).
  $
  <eq:simulator:background:conv_theorem>
]
<eq:simulator:conv_theorem>
#block(breakable: false)[
  Additionally, the transform of a product is the convolution of the transforms:
  $
    cal(F)(f times g) = cal(F)(f) * cal(F)(g).
  $
  <eq:simulator:bckground:conv_theorem_bis>
]
This result gives an intuitively compelling argument for using Fourier representations in problems involving reverberant environments.
Indeed, the reverberation phenomenon can be modeled as the convolution of a source signal with the #acr("RIR") in the time domain.
Hence, it translates into a product in the Fourier domain, making it easier to disentangle information from the raw signal from the listened one.
However, it must be noted that the convolution theorem does not hold for the #acr("STFT").
It can be verified for the general #acr("DFT") under certain conditions but is wrong when using short-term frames.
In practice, the length of the #acr("STFT") window function is often significantly shorter than the length of the convolution.

Despite this theoretical result not transferring to the #acr("STFT")-based representations, they are still widely used in the literature when dealing with reverberating phenomena @gannot_signal_2001 @li_reverberant_2016 @cohen_relative_2004.
This assumption of multiplicative transfer functions is known as the narrow-band assumption.
It is made in various domains of audio processing despite the error being often large.

==== Beamforming and Interaual Cues
<sec:simulator:background:binaural>

*Motivation*

Using multiple microphones opens a wide range of possibilities in audio processing tasks.
Humans rely on their two ears to exploit the spatiality of their auditory environment.
Similarly, the signal processing community has exploited microphone arrays and developed algorithms to usefully aggregate signals from several sensors.
Array processing spans several downstream tasks, such as
speech enhancement @gannot_consolidated_2017,
dereverberation @gaubitch_analysis_2005 @nakatani_blind_2008,
sound source localization @alameda-pineda_geometric_2014 @grumiaux_survey_2021 @perotin_localisation_2019,
separation @parra_convolutive_2000
or acoustic scene analysis @imoto_spatial_2017.
Disposing of more than one microphone allows computing the #acr("TDoA")

Many array configurations have been experimented with.
Both the geometry (linear, polygons, spheres, or more complex arrangements) and the number of microphones (from two to several thousand) vary widely across applications.
Two families of arrays have emerged in the community.
On the one hand, researchers have increased the number of receivers in a single array to capture as much geometric information as possible.
The ambisonic format is an example of an approach that leverages high microphone-count arrays @perotin_localisation_2019 @zaunschirm_binaural_2018.
On the other hand, the binaural setup is one of the most studied configurations because it attempts to model human hearing.
In this case, specific signal representations have been proposed to ease extracting relevant information.
Some data representations have been introduced for the specific case of binaural devices.
This section focuses on motivating and deriving those representations.

*Sound Propagation within the Multi-Microphone Setting*

#figure(
  image(
    "figures/multi_mic_schema.svg",
    width: 80%,
  ),
  caption: flex-caption(
    short: [
      Two-microphone configuration in the near-field and far-field cases.
    ],
    long: [
      Two-microphone configuration in the near-field and far-field cases.
      In the far-field approximation, sound propagation directions can be assumed to be parallel.
    ],
  ),
)
<fig:simulator:background:multi_mic_schema>

By adapting the single-microphone case (@eq:simulator:background:single_mic_discrete), the signal received by microphone $i$ can be expressed as (Vincent et al. @vincent_audio_2018 Chapter 3 or Gustafsson et al. @gustafsson_source_2003):
$
  x_i [n] = 1 / (sqrt(4 pi) d_i) s[n - d_i/#c #freq].
$
<eq:simulator:background:propagation_multi_mic>
where $d_i$ is the distance from the the source $i$ to the source (see @fig:simulator:background:multi_mic_schema)

One can write signal $x_2$ recorded by microphone $2$ as a function of the one recorded by microphone $1$ by combining their expressions:
$
  x_2[n] = d_1 / d_2 x_1 [n - (d_2 - d_1)/(#c) #freq].
$
<eq:simulator:background:propagation_multi_mic_relative>

#reset-acronym("TDoA")
$d_1 / d_2$ is called the level ratio, while $(d_2 - d_1)/#c$ is the #acr("TDoA").
Those quantities encode relative information on the source position.

The situation is described as far-field when the source is significantly far from the microphone array @girin_fundamentals_nodate.
The far-field situation is when the source-to-microphone distances $d_i$ are large compared to the inter-receiver distance $l$.
In this case, the level ratio is almost equal to 1:
$
  d_1 / d_2 approx 1.
$
<eq:simulator:background:multi_mic_far_field_level_ratio>
Also, the far-field assumption implies that the #acr("TDoA") is fully determined by the #acr("DoA") and its corresponding angle $theta$:
$
  (d_2 - d_1) / #c = l/#c cos(theta).
$
<eq:simulator:background:multi_mic_far_field_doa>
Hence, theoretically, a measure of the #acr("TDoA") can be sufficient to infer the value of $theta$.
Increasing the number of microphones brings redundancy and, thus, robustness when the measures of the #acr("TDoA") are noisy.


*Relative Transfer Function*

When considering a pair of microphones, defining interaural features becomes possible.
Those quantities and techniques have been introduced to help understand and model binaural hearing and beamforming in general.

#reset-acronym("RTF")
In practice, the aforementioned geometrical observations are leveraged by computing specific features from the input signal.
Then, one computes the #acr("RTF") to express the interchannel information.
It corresponds to the ratio between two microphones' #acrpl("ATF") @gannot_signal_2001.
The value of the #acr("RTF") at a given time can be obtained by computing the ratio of the #acr("STFT") received by two microphones: the interaural spectrogram.
More precisely, the #acr("RTF") of the $i$-th microphone is obtained by dividing the #acr("STFT") of the signal it receives by the one of the signals recorded by a reference microphone (the first one for instance):
$
  "RTF"_i [m, k] = (X_i [m, k]) / (X_1 [m, k]) in CC,
$
where $m$ and $k$ are the time and frequency indices, respectively.
By construction, we have $"RTF"_1 [m, k] = 1$.

Cohen @cohen_relative_2004 is developing a way to use speech signals to identify an acoustic system's #acr("RTF").
Markovich-Golan et al. @markovich-golan_performance_2015 thoroughly evaluate two statistical estimators for the #acr("RTF").
Li et al. @li_estimation_2015 propose an estimation method based on segmental power spectral density matrix subtraction.
In a later work, Li et al. @li_reverberant_2016 explore methods to accurately estimate the #acr("RTF") to enhance #acr("SSL") methods.

In the specific case of binaural hearing on a humanoid robot platform, the device's physical head will introduce additional acoustic perturbations between the two microphones.
The simple propagation model derived in
@eq:simulator:background:propagation_multi_mic - @eq:simulator:background:multi_mic_far_field_doa[]
is not valid anymore.
Here, the ratio of #acrpl("ATF") is called the #acr("HRTF") (Vincent et al. @vincent_audio_2018 Chapter 4).
The modeling and simulation of #acrpl("HRTF") are outside the scope of this thesis but are nevertheless central to the field of acoustic robotics.


//*#acr("ILD") and #acr("IPD")*


// Let us assume a setting with a single speech source outputting the input signal $s(t)$ and a binaural microphone array.
// The signal received by the left and right microphones can be expressed as the following convolutions:
// $
//   cases(
//     l(t) = s(t - tau_l) * h_l(t),
//     r(t) = s(t - tau_r) * h_r(t)
//   )
// $ <eq:ssl:background:binaural_cues:binaural_signals>
// where $s$ is the source signal produce by the sound source and $h_l$ and $h_r$ are the #acr("RIR") relative to the left and right microphones.

#reset-acronym("ILD")
#reset-acronym("IPD")
The #acr("RTF") is a complex-valued function.
It is often projected to real quantities, namely its argument and phase, for practical use.
Let us consider a binaural array with microphones $m_1$ and $m_2$.
- The modulus of the #acr("RTF"), expressed in decibels, is called the #acr("ILD")
$
  "ILD"[m, k]
    = 20 log_(10) mabs("RTF"[m, k])
    = 20 log_(10) mabs((X_2 [m, k]) / (X_1 [m, k])).
$
<eq:simulator:background:def_ild>
- The phase is called the #acr("IPD"):
$
  "IPD"[m, k]
    = arg("RTF"[m, k])
    = arg((X_2 [m, k]) / (X_1 [m, k])).
$
<eq:simulator:background:def_ipd>

Interaural features, especially #acr("IPD"), have been successfully used in #acr("SSL") as they directly relate to the #acr("DoA").
As @eq:simulator:background:propagation_multi_mic_relative illustrates, the times at which each microphone of the array receives the signal differ by some short delay $tau = (d_2 - d_1) / #c$.
Under ideal circumstances, meaning in the absence of reverberation and perturbations such as noise, the phase of the interaural spectrogram is an explicit and deterministic function of the #acr("TDoA") $tau$.
Mandel et al. @mandel_probability_2006 derived a probability model to estimate the #acr("IPD") from binaural recordings.
They test their framework on an #acr("SSL") task and compare it against an approach based on the #acr("GCC-PHAT") @knapp_generalized_1976 estimator.
#acr("GCC-PHAT") provides an estimator of the #acr("TDoA").
The proposed approach achieves better results than the baseline and shows robustness to noise and reverberation.
By monitoring rats' brain activity, Uragun et al. @uragun_discrimination_2013 studied how animal brains were sensitive to #acr("ILD") functions.
They discovered that the rat uses the #acr("ILD") as a critical cue to localize sounds in space.
This highlights the biological motivation of interaural features and confirms its relevance.


#include "figures/spectral_features/fig.typ"


@fig:ssl:sota:tf_representations provides example of each aforementioned spectral representations.
A binaural array and a speech source have been placed in a simulated room.
The omnidirectional source plays a 1-second section of speech recording sampled from the _LibriSpeech_ @panayotov_librispeech_2015 corpus.
The features were then extracted from the inferred microphone signal:
- @fig:ssl:sota:tf_representations:spectrogram shows the power spectrogram of the signal received by the left microphone: $20 log abs(X_1 [m, k])$.
- @fig:ssl:sota:tf_representations:ild and @fig:ssl:sota:tf_representations:ipd show the binaural cues, computed from @eq:simulator:background:def_ild and @eq:simulator:background:def_ipd respectively.