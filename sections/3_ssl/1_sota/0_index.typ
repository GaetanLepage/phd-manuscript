#import "/utils.typ": *

== Sound source localization background
<sec:ssl:sota>

#reset-acronym("SSL")

=== Original problem
// Very broad introduction
#acr("SSL") is part of the classic challenges in artificial speech processing.
This challenge requires identifying the relative position of one or several sound sources leveraging an audition device, typically a microphone array.
The ability to localize sound sources is fundamental and can serve many purposes across various fields.

// Applications
Although initially targeted to replicate human-like auditory perception, it has progressively found more diverse applications.
For instance, #acr("SSL") enables hands-free computer-human interaction, improving teleconferencing systems and advancing autonomous vehicles.
Overall, the ability to localize sound enriches machines' capabilities.
For instance, in robotics, #acr("SSL") aids navigation, situational awareness, and human-robot interaction by directing robots to key auditory cues in their environment.
Similarly, it helps amplify sounds from a specific direction in hearing aids, improving the user's experience in noisy environments.
#acr("SSL") plays a vital role in Speech Enhancement and Recognition.
It helps enhance speech intelligibility in noisy environments by isolating and amplifying signals from specific directions.
This is critical in applications like teleconferencing, and hearing aids @varzandeh_exploiting_2020.
In entertainment and #acr("AR"), #acr("SSL") helps enhance the user's immersion by dynamically adjusting the audio environment based on the user's spatial orientation and movement @sodnik_spatial_2006 @keyrouz_binaural_2007.
In security systems, it can help identify the origin of specific sound events.
The detection and localization of such suspicious sounds can be achieved by combining audio and visual information @stachurski_sound_2013.
This allows for more robust detection and tracking of sound-emitting targets.
Interestingly, #acr("SSL") is also used in autonomous vehicle systems.
It helps enhance environmental awareness and safety in those complex environments.
Here, too, leveraging audio, video, and information for radar sensors improves autonomous vehicles' overall capabilities to detect important external elements quickly.
Sun et al. have demonstrated the effectiveness of using microphone arrays and machine learning algorithms to accurately localize such sounds, thereby improving the vehicle's decision-making capabilities @sun_emergency_2021.
They specifically focus on the detection and localization of emergency vehicles.
Using audio enables the gathering of crucial early spatial information.

The research on #acr("SSL") has evolved significantly over time, starting with classical signal processing methods.
Most of these techniques rely on geometric and physical principles, such as #acr("TDoA") or beamforming.
While such methods have contributed to significant progress, they remain limited in complex and noisy real-world environments.
The multiplicity of sources is another obstacle to traditional #acr("SSL") methods.
As in several similar application fields, the rise of deep learning has quickly shown impressive results.
Modern, data-driven approaches began leveraging neural networks to model complex acoustic environments, outperforming traditional methods in robustness and accuracy.
Recent advances focus on integrating #acr("SSL") with multimodal systems, such as robotics and autonomous vehicles, to achieve real-time localization in dynamic and complex settings.
Nevertheless, the fundamental concepts at the base of the more classical approaches remain considerably relevant today.
Indeed, they can help design feature extractors or pre-processing techniques that would further boost the performance of deep-learning-based localizers.

// Variation in task definition
Localizing sound sources is a vague objective, and the exact formulation of the problem varies broadly across the literature.
First and foremost, the targetted acoustic environment can be of different natures.
Some methods are solely tested in a simulation where the fidelity to the real world is inherently imperfect.
As motivated in @chap:simulator, simulation provides several benefits.
In particular, it offers a cost-effective data source that is particularly relevant when using data-based approaches.
Naturally, the ability for a method to be applied in real-world conditions is more appealing.
Conversely, techniques only tested in a simulator will have a priori subpar performance when deployed in the physical world.
Furthermore, some works aim to handle multiple sources, while others are limited to a single one.

This introduction explores the evolution of #acr("SSL"), starting with classical signal-processing approaches and their foundational principles. 
It then transitions to deep learning methods, highlighting key advances, architectures, and datasets.
Finally, the focus shifts to #acr("SSL") in robotics, where unique challenges and application-specific solutions are discussed, demonstrating the technology's real-world impact.
Importantly, numerous dedicated researchers have explored this research area over several years, publishing thousands of academic articles.
Hence, this introduction does not aim to provide an exhaustive survey of the many methods and approaches addressing #acr("SSL").
Conversely, our objective here is to give an overall overview of the field and share its significant trends.
Alongside the multiple references cited in the following paragraphs, one may refer to Grumiaux et al. @grumiaux_survey_2021 for a more detailed picture of #acr("SSL") at the age of deep learning.


#draft[
// TODO: motivate this problem: why is it relevant, give examples in robotics

// DoA - only vs dist + DoA
The exhaustivity of the
Importantly, one may attempt to determine both the angle

A broad range of specific settings and methods have been investigated in the audio processing literature.
]


// TODO: not sure that this "motivation" paragraph belongs here. Maybe more in the chapter intro ?
Our intent at exploring #acr("SSL") was initially motivated by our exploratory work in Deep Reinforcement Learning (see @chap:rl).



#draft[
#reset-acronym("GCC-PHAT")
  TODO: remove ?
  //===== #acr("GCC-PHAT")
  
  // https://dsp.stackexchange.com/questions/74574/understanding-gcc-phat-as-a-feature
]


=== Classical approaches
<sec:ssl:sota:classical_approaches>

#acr("SSL") has long been a central problem in auditory processing, and foundational methods have emerged from signal processing principles.
These classical approaches primarily relied on analyzing multichannel audio data to extract spatial information about sound sources, leveraging the physics of wave propagation @grumiaux_survey_2021.

#acr("TDoA")-based methods are among the most widely used classical techniques for SSL.
Estimating the time delay between sound arrivals at different microphones can infer the source's spatial position.
A more detailed overview of the geometrical aspect of sound propagation has been given in @sec:simulator:background:binaural.
The #acr("GCC-PHAT") is a prominent algorithm in this category, known for its robustness in noisy environments @knapp_generalized_1976.
The seminal work by Knapp et al. @knapp_generalized_1976 describes the GCC framework and explores the application of the #acr("PHAT") weighting to improve time-delay estimation in noisy and reverberant environments.
The #acr("GCC-PHAT") remains a cornerstone method in signal processing for sound source localization.
Alameda et al. @alameda-pineda_geometric_2014 developed a geometric formulation of the localization problem along with an optimization algorithm.
Their approach illustrates the relevance of time delays as powerful features to perform #acr("SSL").
However, reverberation and closely spaced microphones often degrade #acr("TDoA") accuracy.
Also, a well-known issue of binaural systems is the front-back ambiguity.
It directly comes from the symmetry of such setups in the sagittal plane.
A sound arriving from a direction in front of the listener produces similar #acr("ITD")s and #acr("ILD")s as a sound from a direction behind the listener.
For sounds coming from the front and back, the paths to the left and right microphones (or ears) differ by the same amount of time but from opposite directions.
This symmetry means that the #acr("TDoA") measurement alone cannot distinguish whether the source is in front or behind.

Beamforming approaches focus on spatial filtering by steering the microphone array to maximize the energy from a specific direction.
Methods such as the steered response power with phase transform (SRP-PHAT) are commonly employed to construct acoustic energy maps, identifying source directions as peaks in the map​.
Van Veen et al. @van_veen_beamforming_1988 provide a comprehensive overview of beamforming techniques, discussing their applications in spatial filtering and signal enhancement.
The book by Brandstein et al. @brandstein_microphone_2001 gives a more in-depth exploration of microphone array signal processing.
While effective in simple environments, beamforming techniques struggle with real-world conditions involving diffuse noise and multiple overlapping sources.

Subspace methods such as #acr("MUSIC") @schmidt_multiple_1986 and #acr("ESPRIT") @roy_esprit-estimation_1989 rely on the decomposition of the microphone covariance matrix to estimate signal and noise subspaces.
#acr("MUSIC"), in particular, identifies source directions by projecting steering vectors onto the noise subspace and detecting peaks in the resulting pseudo-spectrum​.
These methods are computationally intensive and sensitive to reverberation, but they provide high localization accuracy under controlled conditions.

Probabilistic methods model the spatial distribution of sound sources using generative frameworks like #acrpl("GMM") @flam_gaussian_2011 @bross_multiple_2021.
These approaches combine statistical inference with signal sparsity in the time-frequency domain, providing robust #acr("SSL") performance in scenarios with multiple sources​.
Extensions to these models include Gaussian mixture regression for single and multi-source localization, highlighting their adaptability @deleforge_co-localization_2015 @deleforge_acoustic_2015.

// Limitations of classical methods
Despite their utility, classical #acr("SSL") methods exhibit several limitations.
Their reliance on simplifying assumptions, such as free-field propagation or the absence of significant noise and reverberation, restricts their real-world applicability @grumiaux_survey_2021. // TODO double-check
#draft[Maybe the following should go to the next section]
Furthermore, many classical techniques fail to generalize across varying microphone array configurations and acoustic environments.
Those shortcomings have catalyzed the development of data-driven techniques, particularly those leveraging deep learning.
These modern methods excel in handling complex, nonlinear relationships in audio data, offering greater robustness in diverse and dynamic environments.
The evolution of #acr("SSL") from classical to deep learning approaches marks a significant leap in addressing real-world challenges.



#draft[
  TODO: cite
- Source Localization in Reverberant Environments: Modeling and Statistical Analysis @gustafsson_source_2003
- Sharon's paper on estimators and their performance
]



=== Deep Learning methods for #acr("SSL")
<sec:ssl:sota:deep_learning>

The advent of deep learning has brought transformative changes to #acr("SSL"), enabling robust performance in real-world conditions involving noise, reverberation, and multi-source scenarios.
Unlike classical methods that rely on handcrafted features and simplified models, deep learning techniques harness large datasets and powerful neural network architectures to learn complex spatial and spectral relationships directly from audio data​.
Today, the overwhelming majority of research efforts on #acr("SSL") leverage deep learning-based solutions.

Let us first describe the typical workflow process of such approaches.
Deep learning-based #acr("SSL") systems typically involve three primary components.
// Input processing
First, *input feature extraction* consists in computing acoustic features from the raw audio data.
Spectrograms, #acr("ITD")s, #acr("IPD")s or the aforementioned #acr("GCC-PHAT")s are popular examples.
Please refer to @sec:simulator:background:binaural for more details on such features.
More originally, Perotin et al. have conducted a series of work investigating the use of the ambisonics format for performing #acr("SSL") @perotin_crnn-based_2018, @perotin_crnn-based_2019, @perotin_regression_2019 @perotin_localisation_2019.
#draft[Add about Wav2vec for direct mapping (contrast with classical methods)]
// DNN processing
Secondly, the most important step consists of the processing of the pre-processed input data by a #acr("DNN").
While approaches differ, its task generally consists in mapping the sound signal to sound source(s) location(s).
The network is often trained in a supervised fasion on a collected offline dataset containing numerous pairs of sound recordings and source positions.
After training, the model is supposed to be able to predict the sound source location from unheard recordings resulting from new situations.
The third and final aspects of the workflow consists of choosing the right *output strategy*.
Grumiaux et al. @grumiaux_survey_2021 highlight the rich variety of possible choices in this matter.
As noted previously, all methods do not share the same capacities.
Some can handle the detection of multiple sources @he_joint_2018, #draft[add others]
#draft[
  We should add a paragraph on the possible output formats
]

*Dataset collection*

#draft[#lorem(50)]

*Network architecture*

#draft[#lorem(50)]

#draft[
  - Survey paper @grumiaux_survey_2021
  - How to (virtually) train your speaker localizer @srivastava_how_2023
  - Sound Source Localization Using Deep Learning Models @yalta_sound_2017

  Romain Serizel's papers on SSL:
]


=== Sound Source localization in robotics
<sec:ssl:sota:ssl_in_robotics>

#draft[
 TODO: There is a paragraph in SoundSpaces with litterature on SSL for robotics
]

As demonstrated above, although #acr("SSL") has been studied as a self-contained problem, it certainly has an important number of downstream applications.
Among those, robotics is a significant use case of #acr("SSL") algorithms.
Perception is an essential building block of a social robotics platform.
Besides exploiting visual features, which falls under the computer vision domain, leveraging audio cues may provide valuable information for a social robot.
Naturally, such an agent will use language as the primary means of communication with humans and will thus need to extract the meaning of its interlocutors' speech.
Sound information may have additional use cases besides #("ASR").

// Other uses of audio in robotics
For instance, human-robot interaction can be enhanced by having the agent adjust its gaze and look at the person it interacts with.
// TODO: cite study that backs this claim
This has been achieved through computer vision techniques but #acr("SSL") has also yielded positive results. // TODO cite some works that do this
A robot that is able to locate other sound sources accurately can also adjust its navigation policy to take advantage of this knowledge.
Robot navigation is likewise complex and often relies on multi-modal perception.
LIDAR, or depth information, allows the robot to localize itself and other potentially moving subjects in the environment.
// TODO citations
However, identifying the position of currently speaking humans requires some sort of #acr("SSL") method.

// Constraint related to robotics
Robotics also challenges the #acr("SSL") task.
Indeed, a robotic platform implies dealing with several constraints mainly caused by interacting with the real world.
#draft[
// TODO:
- Reverberation
- Moving objects
- Intermittent sources
- Noise (motor noise, music, multiple concurrent sources)
]

// Classical approaches
#draft[Back in ..., researchers have intended to localize ...]
#draft[
  // TODO: cite some works
  // - Xavi+Radu's paper
  // - older perception work ?
  
  - Nakadai 2002 AV @nakadai_real-time_2002
  - #text(red)[Interesting reference for robotics:] Argentieri, Danès, Souères: _A Survey on Sound Source Localization in Robotics: from Binaural to Array Processing Methods_ (2015) @argentieri_survey_2015
    Not too much DL (less than Laurent's survey).
    However, their approach is interesting as they focus on SSL for robotics.
    They distinguish between binaural methods, imitating human's hearing, and array processing ($n_"mics" > 2$).

    *IMPORTANT (in the Conclusion):* About the fact that in robotics, _things move_ by definition.
    - This is a challenge and most static techniques do not take this into account (limitation).
    - On the other hand, this is an opportunity (active SSL):\
      _Actually, the Robotics Community has not extensively addressed this active audition topic, although it may constitute one of the most promising progress in embodied audition._:
    
  - @rascon_localization_2017

  - Li et al. _Reverberant sound localization with a robot head based on direct-path relative transfer function_ @li_reverberant_2016
]

// Deep Learning
In robotics, Deep Learning methods have also been used to perform #("SSL").
#draft[
- @nguyen_autonomous_2018: Collecting a dataset and training a CNN to localize and face a sound source with a humanoid robot head.
]

// Using multi-modal information (audio-visual SSL)
// -> Not directly related to our topic though

// TODO: talk about HRTF

//--------------------------------------
// Challenges
Despite its utility, #acr("SSL") remains a complex problem due to real-world constraints.
Environmental noise, reverberations, and occlusions can distort signals, complicating the localization process.
Moreover, multiple overlapping sound sources introduce additional difficulty layers, requiring sophisticated separation and localization strategies.
Real-time performance is also a crucial requirement in many applications, further constraining the design of SSL systems.
//