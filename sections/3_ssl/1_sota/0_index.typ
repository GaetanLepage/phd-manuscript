#import "/utils.typ": *

== Background
<sec:ssl:background>

#reset-acronym("SSL")

=== Original Problem
// Very broad introduction
#acr("SSL") is part of the classic challenges in artificial audio processing.
This challenge requires identifying the relative position of one or several sound sources leveraging an audition device, typically a microphone array.
Localizing sound sources is fundamental and can serve many purposes across various fields.

// Applications
Although initially targeted to replicate human-like auditory perception, it has progressively found more diverse applications.
For instance, #acr("SSL") enables hands-free computer-human interaction, improving teleconferencing systems and advancing autonomous vehicles.
Overall, the ability to localize sound enriches machines' capabilities.
For instance, in robotics, #acr("SSL") aids navigation, situational awareness, and human-robot interaction by directing robots to key auditory cues in their environment.
Similarly, it helps amplify sounds from a specific direction in hearing aids, improving the user's experience in noisy environments.
#acr("SSL") plays a vital role in speech enhancement and recognition.
It enhances speech intelligibility in noisy environments by isolating and amplifying signals from specific directions.
This is critical in applications like teleconferencing and hearing aids @varzandeh_exploiting_2020.
In entertainment and #acr("AR"), #acr("SSL") contributes to the user's immersion by dynamically adjusting the audio environment based on the user's spatial orientation and movement @sodnik_spatial_2006 @keyrouz_binaural_2007.
In security systems, it can help identify the origin of specific sound events.
The detection and localization of such suspicious sounds can be achieved by combining audio and visual information @stachurski_sound_2013.
This allows for more robust detection and tracking of sound-emitting targets.
Interestingly, #acr("SSL") is also used in autonomous vehicle systems.
It facilitates environmental awareness and safety in those complex environments.
Here, too, leveraging audio, video, and information for radar sensors improves autonomous vehicles' overall capabilities to detect important external elements quickly.
Sun et al. @sun_emergency_2021 have demonstrated the effectiveness of using microphone arrays and machine learning algorithms to accurately localize such sounds, thereby improving the vehicle's decision-making capabilities.
They specifically focus on the detection and localization of emergency vehicles.
Using audio enables the gathering of crucial early spatial information.

The research on #acr("SSL") has evolved significantly, starting with classical signal processing methods.
Most of these techniques rely on geometric and physical principles, such as #acr("TDoA") or beamforming.
While such methods have contributed to significant progress, they remain limited in complex and noisy real-world environments.
The multiplicity of sources is another obstacle to traditional #acr("SSL") methods.
As in several similar application fields, the rise of deep learning has quickly shown impressive results.
Modern, data-driven approaches began leveraging neural networks to model complex acoustic environments, outperforming traditional methods in robustness and accuracy.
Recent advances focus on integrating #acr("SSL") with multimodal systems, such as robotics and autonomous vehicles, to achieve real-time localization in dynamic and complex settings.
Nevertheless, the fundamental concepts at the base of the more classical approaches remain considerably relevant today.
Indeed, they can help design feature extractors or pre-processing techniques to further boost the performance of deep-learning-based localizers.

This introduction explores the evolution of #acr("SSL"), starting with classical signal-processing approaches and their foundational principles. 
It then transitions to deep learning methods, highlighting key advances, architectures, and datasets.
Finally, the focus shifts to #acr("SSL") in robotics, where unique challenges and application-specific solutions are discussed, demonstrating the technology's real-world impact.
Notably, numerous dedicated researchers have explored this research area over several years, publishing thousands of academic articles.
Hence, this introduction does not aim to provide an exhaustive survey of the many methods and approaches addressing #acr("SSL").
Conversely, our objective here is to give an overall overview of the field and share its significant trends.
Alongside the multiple references cited in the following paragraphs, one may refer to Grumiaux et al. @grumiaux_survey_2021 for a more detailed picture of #acr("SSL") at the age of deep learning.
Notably, the active localization techniques dealing with moving sources and/or microphones will be presented in @chap:active_ssl in addition to our contribution to the topic.

Before providing details on the various methods proposed to address SSL, we devote the following section to describing the variability in problem formulation and experimental settings. 
Chronologically, the first steps were developed in simple settings, and as progress was made, scenarios of increasing complexity were proposed.
However, the next section is not structured chronologically but by properties (simulated vs. real data, single vs. multi-source) for clarity.

=== Variations in the Sound Source Localization Task
<sec:ssl:background:variations>

Localizing sound sources is a vague objective, and the exact formulation of the problem varies broadly across the literature.

*From simulated to real-world environments*
First and foremost, the targeted acoustic environment can be of different natures.
Some methods are solely tested in a simulation where the fidelity to the real world is inherently imperfect.
As motivated in @chap:simulator, simulation provides several benefits.
In particular, it offers a cost-effective data source that is particularly relevant when using data-based approaches.
Naturally, the ability for a method to be applied in real-world conditions is more appealing.
Conversely, techniques only tested in a simulator will most likely perform subpar when deployed in the physical world.

*Single or multiple sources*
Furthermore, some works aim to handle multiple sources, while others are limited to a single one.
This distinction significantly influences the complexity of the task, the choice of algorithms, and the expected performance.
Single-source localization is the most straightforward setting, assuming that precisely one sound source is active.
It served as the foundation for many initial developments in the field.
Thanks to its simplified formulation, single-source localization allows for robust and performant trackers that can achieve high accuracy in ideal conditions.
Those solutions can leverage the single-source assumption to provide a unique source position estimate.
On the other hand, handling multiple sources inherently makes the localization problem more difficult.
It addresses the challenging scenarios where several sources might be active simultaneously.
This introduces additional complexities, such as separating overlapping signals, distinguishing sources from one another, and determining the number of active sources.
Methods in this category often employ advanced signal processing or deep learning techniques to handle these challenges, relying on spatial and spectral differences between sources.
Multi-source localization is crucial for speech separation, auditory scene analysis, and collaborative robotics applications.
Grumiaux et al. @grumiaux_survey_2021 insist on the difficulty of the multi-source problem.
They also highlight the connections of multi-source localization with other acoustic problems such as speaker diarization (determining _who speaks when_) or speech source separation @jenrungrot_cone_2020.
Indeed, those tasks are complementary as they can share information to enhance each one's results.
Transitioning from single-source to multi-source localization encompasses several challenges.
First, the overlapping signals can create ambiguities in determining which spectral features belong to which source.
Second, as the number of sources increases, the method's performance and/or algorithmic complexity can be difficult to scale.
For instance, the impact of noise and reverberation increases as the number of sources grows @woodruff_binaural_2012 @braun_acoustic_2019.
Finally, estimating the number of sources may also be complex.
Some methods assume this number to be known as a working hypothesis.
Others develop tools to estimate how many sources are active at a given time.
In this context, the multi-source localization problem is not merely a straightforward regression task; somewhat, it resembles a hybrid challenge that combines detection and localization.
Even for single-source methods, determining whether the source is active is a problem of its own.
Some methods explicitly couple a #acr("VAD") system with their localization algorithm @li_voice_2016 @salvati_localization_2018.
This chapter will study both single-source and multi-source techniques for #acr("SSL").

*Angular or absolute localization*
The actual result of an #acr("SSL") method is another example of variations of this task.
Indeed, while specific techniques estimate the relative position of each source from the microphone array, some focus on the sole #doa value.
In their survey @grumiaux_survey_2021, Grumiaux et al. exhaustively illustrate the variety of choices regarding the end result of the localization pipeline.
This distinction originates in the significant difficulty gap implied by predicting the source-microphone distance.
The time, phase, or intensity differences can be exploited when several microphones are used to perform localization.
They allow for the deduction of angular information on source localization as they are closely related to the #doa.
Conversely, distance information is considerably more complex to gather.
It is not directly correlated to a single cue.
It heavily depends on the acoustic properties of the environment, such as noise, reverberation, or even temperature.
Also, acoustic cues such as amplitude have a non-linear relationship with the distance and are thus harder to exploit.
Distance estimation may furthermore need to rely on calibration, which hinders the flexibility and relevance of the #acr("SSL") system.
Moreover, when considering angular-only #acr("SSL") systems, it is necessary to distinguish planar detectors, which predict the sole #doa value, from 3D ones, which also estimate the elevation angle.
Although the #doa is the most informative angle, elevation becomes relevant in more complex scenes or when there is a significant height difference between the microphone array and the sources.
The detection format also varies across the literature, with methods producing Cartesian coordinates and others expressing the positions in polar or spherical coordinates.

*Intermittency and nature of the sources*
#acr("SSL") solutions make different assumptions about the target sources.
First, the source signals' content significantly affects the difficulty of the task.
Initially, several approaches were restricted to localizing white-noise sources.
Those have the particularity of having the same energy at each time and each frequency.
Nevertheless, detecting more realistic speech sources has become the de facto framework for #acr("SSL").
Some works still use white-noise data for training deep neural networks, but their solution is evaluated using speech signals @nguyen_autonomous_2018 @deleforge_co-localization_2015.
Similarly, assumptions about the continuity of the sources can vary across the literature.
Dealing with intermittent sources is another difficulty that several approaches do not consider.
In this regard, handling sources that may become inactive is linked with the capacity to localize a variable number of sources.
Naturally, assuming a pre-defined number of constantly active sources is easier and more common across the #acr("SSL") literature.

*Event localization and detection*
The #acr("SELD") task is an extension of the #acr("SSL") problem.
It involves jointly performing #acr("SED") and localizing the detected events.
This research problem has several real-world applications in surveillance systems, robot hearing, and environmental monitoring.
Hence, the literature on #acr("SELD") methods is highly relevant for localization.
The #acr("DCASE") challenge, held annually, proposes various tasks ranging from pure localization to the more complex #acr("SELD").
Kapka et al. @kapka_sound_2019, Phan et al. @phan_audio_2020 @phan_multitask_2020, Adavane et al. @adavanne_sound_2019 are examples of #acr("DCASE") submissions for the #acr("SELD") task.

Those fundamental differences are not the only ones.
They highlight the diversity of existing approaches and show that the difficulty of #acr("SSL") can vary significantly.
Most importantly, we have seen that the #acr("SSL") task does not have a unique and clear definition.
It refers to a complex problem that can be tackled with various nuances and complexities.

=== Classical Approaches
<sec:ssl:background:classical_approaches>

#acr("SSL") has long been a central problem in auditory processing, and foundational methods have emerged from signal processing principles.
These classical approaches primarily relied on analyzing multichannel audio data to extract spatial information about sound sources, leveraging the physics of wave propagation @grumiaux_survey_2021.

#acr("TDoA")-based methods are among the most widely used classical techniques for #acr("SSL").
Estimating the time delay between sound arrivals at different microphones can infer the source's spatial position.
A more detailed overview of the geometrical aspect of sound propagation has been given in @sec:simulator:background:binaural.
The #acr("GCC-PHAT") is a prominent algorithm in this category, known for its robustness in noisy environments @knapp_generalized_1976.
The seminal work by Knapp et al. @knapp_generalized_1976 describes the GCC framework and explores the application of the #acr("PHAT") weighting to improve time-delay estimation in noisy and reverberant environments.
#acr("GCC-PHAT") remains a cornerstone technique in signal processing for sound source localization @gustafsson_source_2003.
Alameda et al. @alameda-pineda_geometric_2014 developed a geometric formulation of the localization problem along with an optimization algorithm.
Their approach illustrates the relevance of time delays as powerful features to perform #acr("SSL").
However, reverberation and closely spaced microphones often degrade #acr("TDoA") accuracy.
Also, a well-known issue of binaural systems is the front-back ambiguity @wightman_resolution_1999.
It directly comes from the symmetry of such setups in the sagittal plane.
A sound arriving from a direction in front of the listener produces similar #acr("ITD")s and #acr("ILD")s as a sound from behind the listener.
For sounds coming from the front and back, the paths to the left and right microphones (or ears) differ by the same amount of time, but from opposite directions.
This symmetry means that the #acr("TDoA") measurement alone cannot distinguish whether the source is in front or behind.

Beamforming approaches focus on spatial filtering by steering the microphone array to maximize the energy from a specific direction.
Methods such as the #acr("SRP-PHAT") are commonly employed to construct acoustic energy maps, identifying source directions as peaks in the map.
Van Veen et al. @van_veen_beamforming_1988 provide a comprehensive overview of beamforming techniques, discussing their applications in spatial filtering and signal enhancement.
The book by Brandstein et al. @brandstein_microphone_2001 explores microphone array signal processing more in-depth.
While effective in simple environments, beamforming techniques struggle with real-world conditions involving diffuse noise and multiple overlapping sources.

Subspace methods such as #acr("MUSIC") @schmidt_multiple_1986 and #acr("ESPRIT") @roy_esprit-estimation_1989 rely on the decomposition of the microphone covariance matrix to estimate signal and noise subspaces.
#acr("MUSIC"), in particular, identifies source directions by projecting steering vectors onto the noise subspace and detecting peaks in the resulting pseudo-spectrum.
These methods are computationally intensive and sensitive to reverberation, but they provide high localization accuracy under controlled conditions.

Probabilistic methods model the spatial distribution of sound sources using generative frameworks like #acrpl("GMM") @flam_gaussian_2011 @bross_multiple_2021.
These approaches combine statistical inference with signal sparsity in the time-frequency domain, providing robust #acr("SSL") performance in scenarios with multiple sources.
Extensions to these models include Gaussian mixture regression for single and multi-source localization, highlighting their adaptability @deleforge_co-localization_2015 @deleforge_acoustic_2015 @mandel_model-based_2010.
In his PhD thesis @mandel_binaural_2010, Michael I. Mandel proposes a model-based #acr("EM") approach for sound source separation and localization.
This system can handle challenging scenarios involving reverberation and the presence of an adversarial _masker_ sound source.

// Limitations of classical methods
Despite their utility, classical #acr("SSL") methods exhibit several limitations.
Furthermore, many classical techniques fail to generalize across varying microphone array configurations and acoustic environments.
Those shortcomings have catalyzed the development of data-driven techniques, particularly those leveraging deep learning.
These modern methods excel in handling complex, nonlinear relationships in audio data, offering greater robustness in diverse and dynamic environments.
The evolution of #acr("SSL") from classical to deep learning approaches marks a significant leap in addressing real-world challenges.

=== Deep Learning Methods for #acr("SSL")
<sec:ssl:background:deep_learning>

The advent of deep learning has brought transformative changes to #acr("SSL"), enabling robust performance in real-world conditions involving noise, reverberation, and multi-source scenarios.
Unlike classical methods that rely on handcrafted features and simplified models, deep learning techniques harness large datasets and performant neural network architectures to learn complex spatial and spectral relationships directly from audio data.
Today, the vast majority of research efforts on #acr("SSL") leverage deep-learning-based solutions.

Let us first describe the typical workflow process of such approaches.
Deep-learning-based #acr("SSL") systems typically involve three primary components.
// Input processing
First, *input feature extraction* consists of computing acoustic features from the raw audio data.
// DNN processing
Secondly, the most crucial step is *feeding the pre-processed input data into a #acr("DNN")*.
While approaches differ, their task generally consists of mapping the sound signal to the sound source(s) location(s).
The network is often trained in a supervised fashion on a collected offline dataset containing numerous pairs of sound recordings and source positions.
After training, the model is supposed to be able to predict the sound source location from unheard recordings resulting from new situations.
The third and final aspect of the workflow consists of choosing the right *output strategy*.
Grumiaux et al. @grumiaux_survey_2021 highlight the wide variety of possible choices in this matter.
As noted previously, not all methods share the same capacities (@sec:ssl:background:variations).
Some can handle the detection of multiple sources @he_joint_2018, @bross_multiple_2021 @woodruff_binaural_2012, while others are limited to single-source scenarios @perotin_crnn-based_2018 @hirvonen_classification_2015 @chakrabarty_broadband_2017.

*Input Data*

The _Wav2Vec_ method initially proposed by Schneider et al. @schneider_wav2vec_2019 and refined by Baevski et al. @baevski_wav2vec_2020 directly learns from raw audio data in a self-supervised fashion.
This work demonstrates that deep neural networks can directly learn helpful representations of audio signals, given enough data.
A few works have trained #acr("DNN")s to perform #acr("SSL") from the waveform domain
@vera-diaz_towards_2018
@suvorov_deep_2018
@vecchiotti_end--end_2019
@he_sounddet_2021
@jenrungrot_cone_2020.
Although conceptually elegant, such raw-audio-based approaches remain scarce in the literature.
Spectral representations are significantly more popular.
Most notably, the #acr("STFT") is used to compute acoustic signals' magnitude, power, and phase spectra.
For example, Chakrabarty et al. @chakrabarty_broadband_2017 have used the phase spectrogram to localize multiple speakers.
Additionally, interaural (or interchannel) features are commonly used across the literature, such as the aforementioned #acr("ILD"), #acr("IPD"), and #acr("ITD") @viste_binaural_2004 @chakrabarty_broadband_2017 @nguyen_autonomous_2018 @roden_sound_2015.
Please refer to @sec:simulator:background:binaural for more details on such features.
Also, the acoustic representations introduced by the classical localization methods remain popular in the deep learning era.
For instance, Diaz-Guerra @diaz-guerra_robust_2021 @diaz-guerra_direction_2022 proposes to feed #acr("SRP-PHAT") power maps to a #acr("CNN") for performing localization.
In @boztas_sound_2023, Boztas has explored wavelet transforms for pre-processing the raw audio data.

// Ambisonics
Ambisonics is a format for representing acoustic signals as a spherical harmonic decomposition of the sound field.
This multi-channel representation is agnostic to the microphone array configuration and encodes the spatial properties of a sound field @grumiaux_survey_2021.
Those properties are relevant in the context of #acr("SSL").
Applying the #acr("STFT") to an ambisonic signal can express it in the time-frequency domain.
Adavanne et al. @adavanne_localization_2019, @adavanne_sound_2019 employ spectrograms of first-order ambisonics to localize and track multiple sound events.
Perotin et al. have conducted a series of works on ambisonics and its application to #acr("SSL")
@perotin_regression_2019
@perotin_crnn-based_2018
@perotin_crnn-based_2019
@perotin_localisation_2019.
In @varanasi_deep_2020, Varanasi et al. derive novel spherical harmonic magnitude and phase features for #doa estimation.
These features allow for the separate estimation of the elevation and azimuth, lowering the method's computational cost.
Compared to #acr("FOA"), which are more common in the literature, the proposed format uses higher-order spherical harmonics (up to the third order), granting an enhanced spatial resolution.


*Dataset Collection*

Most modern solutions adopt a supervised approach to the #acr("SSL") task.
They thus require gathering numerous data samples from which they can learn.
The two main approaches for data gathering consist of acoustic simulation and recording in real environments.
The former is naturally a more cost-effective solution and scales significantly better with the amount of collected data.
As presented in @chap:simulator, a large ecosystem of acoustic simulation environments exists.
They are constantly improved to reach higher levels of fidelity and accuracy.
A typical data generator for #acr("SSL") is the association of a bank of #acr("RIR")s computed by simulation software and a set of clean speech signals from an existing corpus.
Speech signals are then convoluted with the clean recordings to obtain simulated listened-to signals.
The ground-truth source and microphone positions are known from the start, and no further labeling work is required.
Generating a dataset from an acoustic simulator does not require recording equipment and allows for collecting arbitrarily large amounts of data @srivastava_how_2023.
Nonetheless, the real-world performance of networks trained on such datasets is generally lower than in simulation.
Transferring those methods to the physical world is an important research area.
For instance, some works, such as Chakrabaty et al. @chakrabarty_broadband_2017 @chakrabarty_multi-speaker_2019, Xiao et al. @xiao_learning-based_2015, and Grumiaux et al. @grumiaux_improved_2021, have tested their system on real-world recordings after an initial training phase on synthetic data.
Commonly, modern #acr("SSL") research combines both data sources.
Inexpensive synthetic datasets are often used to train deep neural networks.
Once trained, the performance of the obtained systems is evaluated in real scenarios using microphone arrays or microphone-equipped robotic heads @nguyen_autonomous_2018 @nguyen_robust_2020 @moing_learning_2020.
Also, the simulation of moving sources remains an obstacle for simulation software.
Publicly available acoustic datasets have been used to train or evaluate #acr("SSL") methods @cristoforetti_dirha_2014 @thiemann_multiple_2019.
Finally, the #acr("DCASE") challenge @mesaros_decade_2024 has historically integrated #acr("SELD") and pure localization tasks.
It provides the datasets that all participants can use to train and evaluate the performance of their approaches.

*Network Architecture*

Grumiaux et al. @grumiaux_survey_2021 discuss the various popular choices regarding neural network architectures.
The network topology design is a fundamental property of deep-learning-based #acr("SSL") systems.

The *feed-forward neural network* is the simplest form of #acrpl("DNN")s.
It was also the first deep neural architecture used to perform #acr("SSL") @ling_direction_2011 @youssef_learning-based_2013.
These networks typically map preprocessed spatial audio features, such as #acr("IPD"), #acr("ILD"), or #acr("GCC") @xiao_learning-based_2015, to the #doa of a sound source.
In @xiao_learning-based_2015, a single-hidden-layer #acr("MLP") is trained on #acr("GCC-PHAT")-based features.
Takeda et al. @takeda_sound_2016 use a #acr("DNN") to learn from the eigenvectors of the recorded signal interchannel correlation matrix.
The feed-forward networks' simplicity and efficiency make them suitable for single-source localization in controlled environments.
However, their lack of temporal modeling capabilities limits their performance in dynamic scenarios or multi-source settings.

*Convolutional neural networks* have also been employed widely for #acr("SSL").
As seen previously, it is typical for the recorded signal to first be forwarded to the time-frequency domain.
The Fourier representations of temporal signals share several properties with images.
Most notably, they are often represented as multi-channel images expressed in the time-frequency plane.
As such, the acoustic community has leveraged the vast computer vision literature that has designed numerous deep neural networks for processing images.
#acrpl("CNN")s have shown promising results for #acr("SSL").
The inherent ability of such networks to process an arbitrary number of channels allows for the leverage of recordings from several microphones.
The convolutional kernels are responsible for combining this information.
Hirvonen et al. @hirvonen_classification_2015 are among the first to apply a #acr("CNN") to #acr("SSL").
Multiple works have followed, adopting a similar approach and trying to learn from different types of input features @chakrabarty_broadband_2017 @chakrabarty_multi-speaker_2019 @adavanne_sound_2019 @tan_sound_2021.
In @chakrabarty_multi-speaker_2019, Chakrabarty et al. empirically show that the optimal number of convolutional layers for a microphone array with $M$ microphones is $M-1$.
Diaz-Guerra et al. @diaz-guerra_direction_2022 demonstrate the relevance of icosahedral #acrpl("CNN")s for #doa estimation.
This architecture has the advantage of being equivariant to the 60 rotational symmetries of the icosahedron.
The method achieves state-of-the-art results, even in highly reverberant environments.
The authors attribute this success to using a model that encodes the properties of the problem in its architecture.

Primarily used in the #acr("NLP") community, *#acrpl("RNN")* are a popular choice for processing sequential data and time series in general.
They can inherently propagate information along a sequence to leverage global context to perform a task.
The principal advantage of those architectures is their capacity to model temporal phenomena, which can help localize sound sources in more complex settings.
The main #acr("RNN") architectures are the #acr("LSTM") and #acr("GRU") designs.
Some works, such as @cao_event-independent_2020, @adavanne_localization_2019, @kapka_sound_2019 and @comminiello_quaternion_2019 have used a combination of a #acr("CNN") and a #acr("RNN"), referred to as a #acr("CRNN") for #acr("SSL").

Vaswani et al. @vaswani_attention_2017 famously introduced the *transformer architecture*, which has become the de facto neural network design for numerous complex tasks.
Attention-based neural networks were first employed by the #acr("NLP") community to replace #acrpl("LSTM")s @radford_improving_nodate.
They share with #acrpl("RNN")s the ability to propagate information along a sequence of tokens, which can then be used to make a decision.
In vision tasks, the transformer architecture has been successful as an alternative to the well-established convolutional design @dosovitskiy_carla_nodate.
Some approaches have employed transformers for #acr("SSL") as well.
Phan et al. @phan_audio_2020 @phan_multitask_2020 have coupled a #acr("CRNN") architecture with the self-attention mechanism.
Experiments by Grumiaux et al. @grumiaux_saladnet_2021 and He et al. @he_neural_2021 concluded that self-attention could be used to improve a baseline #acr("CRNN") network.

Other architectures have also been successfully used to achieve localization.
Encoder-decoder neural networks, for example, are designed to learn a lower-dimensional compressed representation of some input data.
Various forms of this architecture served in #acr("SSL") methods.
Le Moing et al. @moing_learning_2020 employed an encoder-decoder-style network to predict 2D Cartesian coordinates of multiple sound sources.
Variational auto-encoders @bianco_semi-supervised_2020 and U-net architectures @jenrungrot_cone_2020 are other examples of encoder-decoder networks used for #acr("SSL").

*Output Format*

As previously explained in @sec:ssl:background:variations, the output formats of #acr("SSL") detectors vary considerably across methods.
On the one hand, not all solutions estimate the same values.
Some systems are limited to #doa estimation, while others can additionally predict the distance.
On the other hand, the coordinate system used to express the detections is not always the same.
The vast majority of works compute the source's position with respect to the microphone array.
Computing an absolute position would require additional knowledge about the environment, the microphones' positions, and choosing a global frame for reference.
Nonetheless, different relative coordinate systems are used.
Choosing spherical or polar systems consists of predicting a #doa value and, optionally, the elevation angle and/or the distance to the source.
Alternatively, other works choose to write the estimated detections in Cartesian coordinates.
The latter choice can involve predicting the distance, too.
Adavanne et al. @adavanne_localization_2019, @adavanne_sound_2019 instead normalize their network's outputs so that estimated coordinates are restricted to the unit sphere.
Additionally, some works can be further distinguished from the usual regression formulation of #acr("SSL").
Specific approaches have framed the localization problem as a classification task where the system is expected to select a region of space instead of producing one or more scalar values @roden_sound_2015 @xiao_learning-based_2015.


=== Sound Source Localization in Robotics
<sec:ssl:background:ssl_in_robotics>

Although #acr("SSL") has been studied as a self-contained problem, it certainly has many notable downstream applications.
Among those, robotics is a significant use case of #acr("SSL") algorithms.
Indeed, perception is an essential building block of a social robotics platform.
Human abilities in this regard are robust and efficient.
We can detect, locate, extract, and recognize multiple sound events in complex scenes.
Research in acoustics has investigated ways to replicate such skills in automatic systems.
Robotics is a major application field for these acoustic challenges.
More specifically, social robotics focuses on designing agents that are able to interact with humans.
Besides exploiting visual features, which have been investigated in the computer vision domain, leveraging audio cues can provide valuable information for a social robot.
Naturally, such an agent will use language as the primary means of communication with humans and thus needs to extract the meaning of its interlocutors' speech.
Yet, sound information may have additional use cases besides #acr("ASR").
For instance, human-robot interaction can be enhanced by having the agent adjust its gaze and look at the person it interacts with.
A robot that can locate other sound sources accurately can also adjust its navigation policy to take advantage of this knowledge.
Robot navigation is likewise complex and often relies on multi-modal perception.
#acr("LIDAR"), or depth information, allows the robot to localize itself and other potentially moving subjects in the environment.
Visual information has also been used to perform #acr("SSL") @mo_closer_2022.
Regarding robotics, Naranag et al. @narang_auditory-aware_2014 have combined a sound source localizer with a visual #acr("SLAM") system for performing auditory-aware navigation.
Using both modalities helped improve overall performance, including the #acr("SSL") accuracy itself.
In @trifa_real-time_2007, Trifa et al. discuss the relevance of combining audio and visual cues for human-robot interaction tasks.
While solely limited to audio features, their experiments involve performing sound source localization on a physical robotic platform.
Li et al. @li_reverberant_2016 demonstrate a capable #acr("SSL") solution tested on the NAO robot.
Gala et al. @gala_realtime_2019 manage to predict both the orientation and distance to the source by rotating a self-rotating binaural microphone array.
Introducing movement is a common technique to eliminate front-back ambiguity.
In @sewtz_sound_2020, Sewtz et al. present an audio segmentation system.
It assigns speech phases to specific speakers in multi-party indoor environments.
The authors insist that, contrary to vision-based systems, sound source localization does not necessitate any movement from the robot.
This property helps with robot acceptance from humans.
Argentieri et al. @argentieri_survey_2015 provide an in-depth review of the state of the art as of 2014.
Naturally, their survey has not discussed more recent works applying modern deep-learning-based techniques.
For instance, Nguyen et al. @nguyen_autonomous_2018 designed a neural network to map audio features recorded by a binaural humanoid robot to the relative source direction.
The model is trained in a supervised fashion using white noise.
It is then tested in a realistic setup where the task is to localize speech sources.
Boztas @boztas_sound_2023 trains a deep neural network to perform #acr("SSL") with a four-microphone array integrated on the Nao robot's head.
Several neural network architectures are compared (#acr("MLP"), #acr("CNN"), #acr("LSTM")).
They evaluate the proposed method by having a TurtleBot3 mobile robot carrying a sound source around the fixed Nao robot.

// Constraint related to robotics
Robotics often brings additional challenges to the #acr("SSL") task.
Indeed, a robotic platform implies dealing with several constraints, mainly caused by interacting with the real world.
Realistic environments are dynamic, reverberant, and noisy. 
They involve intermittent, moving, and concurrent sources.
Furthermore, to be relevant, a robotic system must operate in real-time.
Contrary to some offline techniques, which can rely on computationally expensive techniques, #acr("SSL") methods are considerably constrained.
Additionally, #acr("SSL") is generally the first block of multi-step acoustic pipelines.
For instance, Asano et al. @asano_real-time_2001 combine a localization block, the results of which are used to separate the speech signal from ambient noise.
An online #acr("ASR") system finally processes the cleaned audio.
Nakadai et al. designed advanced systems for localization on actual robotics systems @nakadai_real-time_2002 @nakadai_applying_2003.
Argentieri et al. @argentieri_survey_2015 differentiate two categories of robotic acoustic frameworks.
On the one hand, binaural setups try to model human hearing.
Experimentation platforms involve a robotic head with one microphone on each side.
#reset-acronym("HRTF")
The #acr("HRTF") models how the physical head between the two microphones impacts the recorded signals.
It can be measured in an anechoic environment @algazi_cipic_2001 @wierstorf_free_2011 or simulated @otani_fast_2006.
On the other hand, efforts have been made to use more than two microphones.
Li et al. @li_estimation_2015 estimate the transfer function from recorded signals and use this information to localize a sound source with a real robotic head.
On the other hand, array processing involves using several receivers arranged in more complex geometries @alameda-pineda_geometric_2014 @ishi_using_2013.
They leverage the redundancy of the spatial information across the multiple recorded channels.

// Deep Learning
Deep learning methods have also been used in robotics to perform #("SSL").
Nguyen et al. @nguyen_autonomous_2018 have collected a dataset to train a #acr("CNN") for localizing and facing a sound source with a humanoid robot head.
#acr("SSL") can also be employed to enhance the #acr("ASR") performance of a robotic system.
Dávila-Chacón et al. @davila-chacon_enhanced_2019 designed such a system that infers the #doa to rotate a robotic head to maximize the speech recognition score.
After adjusting the head orientation, their algorithm selects the most appropriate channel to provide to the #acr("ASR") system.
They measure a 50% improvement in the recognition performance thanks to ideally orienting the humanoid head with respect to the speech source.
Interestingly, the optimal angle does not correspond to the sound entering one of the robot's microphones perpendicularly.
Instead, the angle maximizing the reverberation of the sound wave on the artificial pinna provides the best condition for accurate #acr("ASR").

=== Conclusion
<sec:ssl:background:conclusion>

As depicted in this condensed overview, multiple and diverse research efforts have been focused on solving the #acr("SSL") task.
Although this challenge has been explored extensively for decades, the ecosystem remains vibrant, and new solutions are constantly proposed.
The field's evolution demonstrates valuable progress as methods handle more and more complex variations of the problem.
Classical methods like #acr("TDoA"), beamforming, and subspace algorithms have provided foundational approaches, particularly in controlled settings. 
They also leveraged foundational physical and statistical characteristics of the recorded signals.
Researchers have gained a deep understanding of the underlying mechanism that could be used to infer sources' positions.
Then, as in most information-processing fields, deep learning methods have permitted significant advances.
They allowed pushing the boundaries of existing #acr("SSL") systems by leveraging large volumes of training data.
Many limitations of the classical methods were circumvented thanks to the expressiveness of deep neural networks.
Current research efforts try to optimize and enhance those data-based approaches by making them more efficient, robust, and performant.
The design of network architectures and pre-processing pipelines is an example of amelioration axes for such systems.
Despite its utility, #acr("SSL") remains a complex problem due to real-world constraints.
Deep-learning-based #acr("SSL") methods often require large, annotated datasets and face difficulties in generalizing across unseen environments and array geometries.
Issues such as scalability in multi-source settings and real-time processing constraints further underline the need for ongoing innovation.
Also, robotics is a vibrant application of #acr("SSL") systems, putting them in challenging environments.
In conclusion, #acr("SSL") research continues to evolve, balancing the precision of classical methods with the adaptability and robustness of modern deep learning techniques.
As advancements in hardware, algorithms, and datasets continue, #acr("SSL") systems are poised to play an increasingly integral role in enabling intelligent, perceptive machines to interact seamlessly with their acoustic environments.