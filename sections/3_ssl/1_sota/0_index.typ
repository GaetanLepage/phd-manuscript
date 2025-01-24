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
This is critical in applications like teleconferencing and hearing aids @varzandeh_exploiting_2020.
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

The research on #acr("SSL") has evolved significantly, starting with classical signal processing methods.
Most of these techniques rely on geometric and physical principles, such as #acr("TDoA") or beamforming.
While such methods have contributed to significant progress, they remain limited in complex and noisy real-world environments.
The multiplicity of sources is another obstacle to traditional #acr("SSL") methods.
As in several similar application fields, the rise of deep learning has quickly shown impressive results.
Modern, data-driven approaches began leveraging neural networks to model complex acoustic environments, outperforming traditional methods in robustness and accuracy.
Recent advances focus on integrating #acr("SSL") with multimodal systems, such as robotics and autonomous vehicles, to achieve real-time localization in dynamic and complex settings.
Nevertheless, the fundamental concepts at the base of the more classical approaches remain considerably relevant today.
Indeed, they can help design feature extractors or pre-processing techniques that would further boost the performance of deep-learning-based localizers.

This introduction explores the evolution of #acr("SSL"), starting with classical signal-processing approaches and their foundational principles. 
It then transitions to deep learning methods, highlighting key advances, architectures, and datasets.
Finally, the focus shifts to #acr("SSL") in robotics, where unique challenges and application-specific solutions are discussed, demonstrating the technology's real-world impact.
Importantly, numerous dedicated researchers have explored this research area over several years, publishing thousands of academic articles.
Hence, this introduction does not aim to provide an exhaustive survey of the many methods and approaches addressing #acr("SSL").
Conversely, our objective here is to give an overall overview of the field and share its significant trends.
Alongside the multiple references cited in the following paragraphs, one may refer to Grumiaux et al. @grumiaux_survey_2021 for a more detailed picture of #acr("SSL") at the age of deep learning.
Notably, the active localization techniques dealing with moving sources and/or microphones will be presented in @chap:active_ssl in addition to our contribution to the topic.


=== Variations in the Sound Source Localization task
<sec:active_ssl:background:variations>

Localizing sound sources is a vague objective, and the exact formulation of the problem varies broadly across the literature.

*From simulated to real-world environments*
First and foremost, the targetted acoustic environment can be of different natures.
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
They also highlight the connections of multi-source localization with other acoustic problems such as speaker diarization (determining _who speaks when_) or speech source separation.
Indeed, those tasks are complementary as they can share information to enhance each one's results.
Transitioning from single-source to multi-source localization encompasses several challenges.
First, the overlapping signals can create ambiguities in determining which spectral features belong to which source.
Second, as the number of sources increases, the performance and/or algorithmic complexity of the method can be hard to scale.
For instance, the impact of noise and reverberation increases as the number of sources grows @woodruff_binaural_2012 @braun_acoustic_2019.
Finally, estimating the number of sources may also be challenging.
Some methods assume this number to be known as a working hypothesis.
Others develop tools to estimate how many sources are active at a given time.
In this context, the multi-source localization problem is not merely a straightforward regression task; somewhat, it resembles a hybrid challenge that combines detection and localization.
Even for single-source methods, determining whether the source is active is a problem of its own.
Some methods explicitly couple a #acr("VAD") system with their localization algorithm @li_voice_2016 @salvati_localization_2018.
This chapter will study both single-source and multi-source techniques for #acr("SSL").

*Angular or absolute localization*
The actual result of an #acr("SSL") method is another example of variations of this task.
Indeed, while specific techniques estimate the relative position of each source from the microphone array, some focus on the sole #acr("DoA") value.
In their survey @grumiaux_survey_2021, Grumiaux et al. exhaustively illustrate the variety of choices regarding the end result of the localization pipeline.
This distinction originates in the significant difficulty gap implied by predicting the source-microphone distance.
The time, phase or intensity differences can be exploited when several microphones are used to perform localization.
They allow for the deduction of angular information on source localization as they are closely related to the #acr("DoA").
Conversely, distance information is considerably more complex to gather.
It is not correlated to a direct cue.
It heavily depends on the acoustic properties of the environment, such as noise, reverberation, or even temperature.
Also, acoustic cues such as amplitude have a non-linear relationship with the distance and are thus harder to exploit.
Distance estimation may also need to rely on calibration, which hinders the flexibility and relevance of the #acr("SSL") system.
Furthermore, when considering angular-only #acr("SSL") systems, it is necessary to distinguish planar detectors, which predict the sole #acr("DoA") value, from 3D ones, which also estimate the elevation angle.
Although the #acr("DoA") is the most informative angle, elevation becomes important in more complex scenes or when there is a significant height difference between the microphone array and the sources.
The detection format also varies across the literature, with methods producing cartesian coordinates and others expressing the positions in polar or spherical coordinates.

Those fundamental differences are not the only one.
They highlight the diversity of existing approaches and show.
Most importantly, we have seen that the #acr("SSL") task has no unique and clear definition.
It refers to a complex problem that can be tackled with various levels of difficulty.

=== Classical approaches
<sec:ssl:sota:classical_approaches>

#acr("SSL") has long been a central problem in auditory processing, and foundational methods have emerged from signal processing principles.
These classical approaches primarily relied on analyzing multichannel audio data to extract spatial information about sound sources, leveraging the physics of wave propagation @grumiaux_survey_2021.

#acr("TDoA")-based methods are among the most widely used classical techniques for SSL.
Estimating the time delay between sound arrivals at different microphones can infer the source's spatial position.
A more detailed overview of the geometrical aspect of sound propagation has been given in @sec:simulator:background:binaural.
The #acr("GCC-PHAT") is a prominent algorithm in this category, known for its robustness in noisy environments @knapp_generalized_1976.
The seminal work by Knapp et al. @knapp_generalized_1976 describes the GCC framework and explores the application of the #acr("PHAT") weighting to improve time-delay estimation in noisy and reverberant environments.
The #acr("GCC-PHAT") remains a cornerstone technique in signal processing for sound source localization.
Alameda et al. @alameda-pineda_geometric_2014 developed a geometric formulation of the localization problem along with an optimization algorithm.
Their approach illustrates the relevance of time delays as powerful features to perform #acr("SSL").
However, reverberation and closely spaced microphones often degrade #acr("TDoA") accuracy.
Also, a well-known issue of binaural systems is the front-back ambiguity.
It directly comes from the symmetry of such setups in the sagittal plane.
A sound arriving from a direction in front of the listener produces similar #acr("ITD")s and #acr("ILD")s as a sound from behind the listener.
For sounds coming from the front and back, the paths to the left and right microphones (or ears) differ by the same amount of time but from opposite directions.
This symmetry means that the #acr("TDoA") measurement alone cannot distinguish whether the source is in front or behind.

Beamforming approaches focus on spatial filtering by steering the microphone array to maximize the energy from a specific direction.
Methods such as the steered response power with phase transform (SRP-PHAT) are commonly employed to construct acoustic energy maps, identifying source directions as peaks in the map.
Van Veen et al. @van_veen_beamforming_1988 provide a comprehensive overview of beamforming techniques, discussing their applications in spatial filtering and signal enhancement.
The book by Brandstein et al. @brandstein_microphone_2001 gives a more in-depth exploration of microphone array signal processing.
While effective in simple environments, beamforming techniques struggle with real-world conditions involving diffuse noise and multiple overlapping sources.

Subspace methods such as #acr("MUSIC") @schmidt_multiple_1986 and #acr("ESPRIT") @roy_esprit-estimation_1989 rely on the decomposition of the microphone covariance matrix to estimate signal and noise subspaces.
#acr("MUSIC"), in particular, identifies source directions by projecting steering vectors onto the noise subspace and detecting peaks in the resulting pseudo-spectrum.
These methods are computationally intensive and sensitive to reverberation, but they provide high localization accuracy under controlled conditions.

Probabilistic methods model the spatial distribution of sound sources using generative frameworks like #acrpl("GMM") @flam_gaussian_2011 @bross_multiple_2021.
These approaches combine statistical inference with signal sparsity in the time-frequency domain, providing robust #acr("SSL") performance in scenarios with multiple sources.
Extensions to these models include Gaussian mixture regression for single and multi-source localization, highlighting their adaptability @deleforge_co-localization_2015 @deleforge_acoustic_2015.

// Limitations of classical methods
Classical #acr("SSL") methods exhibit several limitations despite their utility.
Their reliance on simplifying assumptions, such as free-field propagation or the absence of significant noise and reverberation, restricts their real-world applicability @grumiaux_survey_2021. // TODO double-check
#draft[Maybe the following should go to the next section]
Furthermore, many classical techniques fail to generalize across varying microphone array configurations and acoustic environments.
Those shortcomings have catalyzed the development of data-driven techniques, particularly those leveraging deep learning.
These modern methods excel in handling complex, nonlinear relationships in audio data, offering greater robustness in diverse and dynamic environments.
The evolution of #acr("SSL") from classical to deep learning approaches marks a significant leap in addressing real-world challenges.



#draft[
  TODO: cite
- Source Localization in Reverberant Environments: Modeling and Statistical Analysis @gustafsson_source_2003
]



=== Deep Learning methods for #acr("SSL")
<sec:ssl:sota:deep_learning>

The advent of deep learning has brought transformative changes to #acr("SSL"), enabling robust performance in real-world conditions involving noise, reverberation, and multi-source scenarios.
Unlike classical methods that rely on handcrafted features and simplified models, deep learning techniques harness large datasets and powerful neural network architectures to learn complex spatial and spectral relationships directly from audio data​.
Today, the vast majority of research efforts on #acr("SSL") leverage deep learning-based solutions.

Let us first describe the typical workflow process of such approaches.
Deep learning-based #acr("SSL") systems typically involve three primary components.
// Input processing
First, *input feature extraction* consists in computing acoustic features from the raw audio data.
Spectrograms, #acr("ITD")s, #acr("IPD")s or the aforementioned #acr("GCC-PHAT")s are popular examples.
Please refer to @sec:simulator:background:binaural for more details on such features.
More originally, Perotin et al. have conducted a series of work investigating the use of the ambisonics format for performing #acr("SSL") @perotin_crnn-based_2018, @perotin_crnn-based_2019, @perotin_regression_2019 @perotin_localisation_2019.
#draft[Add about Wav2vec for direct mapping (contrast with classical methods)]
// DNN processing
Secondly, the most important step consists of processing the pre-processed input data by a #acr("DNN").
While approaches differ, their task generally consists of mapping the sound signal to the sound source(s) location(s).
The network is often trained in a supervised fashion on a collected offline dataset containing numerous pairs of sound recordings and source positions.
After training, the model is supposed to be able to predict the sound source location from unheard recordings resulting from new situations.
The third and final aspect of the workflow consists of choosing the right *output strategy*.
Grumiaux et al. @grumiaux_survey_2021 highlight the wide variety of possible choices in this matter.
As noted previously, not all methods share the same capacities (@sec:active_ssl:background:variations).
Some can handle the detection of multiple sources @he_joint_2018, @bross_multiple_2021 @woodruff_binaural_2012 while others are limited to single-source scenarios @perotin_crnn-based_2018 @hirvonen_classification_2015 @chakrabarty_broadband_2017.

*Input data*
The _Wav2Vec_ method initially proposed by Schneider et al. @schneider_wav2vec_2019 and refined by Baevski et al. @baevski_wav2vec_2020 directly learns from raw audio data in a self-supervised fashion.
This work demonstrates that deep neural networks, given enough data, are able to learn useful representations of audio signals directly.
Although this work shows impressive results, such raw-audio-based approaches remain scarce in the acoustic literature.
Spectral representations stand as the most popular format from which to learn.
Most notably, the #acr("STFT") can be used to extract the magnitude, power, and phase spectrums of acoustic signals.
Additionally, interaural features are commonly used across the literature, such as the aforementioned #acr("ILD"), #acr("IPD"), and #acr("ITD").

*Dataset collection*

Most modern solutions adopt a supervised approach to the #acr("SSL") task.
They thus require gathering numerous data samples from which they can learn.
The two main approaches for data gathering consist of acoustic simulation and recording in real environments.
The former naturally comes as a cheaper solution and especially scales well with the amount of collected data.
As presented in @chap:simulator, there exists a large ecosystem of acoustic simulation environments.
They are constantly improved to reach higher levels of fidelity and accuracy.
Generating a dataset from an acoustic simulator does not require any recording equipment and allows for collecting arbitrary large amounts of data. #todo
Nonetheless, real-world performance of networks trained on such datasets is generally lower than in simulation.
The transfer of those methods to the physical world is an important research area.
For instance, some works such as #todo have fine-tuned their system on real recordings after an initial training phase on simulating data.
Also, the simulation of moving sources remain an obstactle for simulation software.

*Network architecture*

Grumiaux et al. @grumiaux_survey_2021 discuss the various popular choices regarding the neural network architectures.
The design of the network topology is one of the fundamental property of deep-learning-based #acr("SSL") systems.

The *Feed-forward neural network* is the simplest form of #acrpl("DNN")s.
#todo

*Convolutional neural networks* have also been employed widely for #acr("SSL").
As seen previously, it is typical for the recorded signal to first be forwarded to the time-frequency domain.
The Fourier representations of temporal signals share several properties with images.
Most notably, they are often represented as multi-channel images expressed in the time-frequency plane.
As such, the acoustic community has leveraged the vast computer vision literature which designed numerous deep neural networks for processing images.
#acrpl("CNN")s have shown promising results for #acr("SSL") #todo.
The inherent ability of such networks to process an arbitrary number of channels allows to leverage recordings from several microphones.
The convolutional kernels are responsible for combining this information.
#todo

Primarily used in the #acr("NLP") community, *#acrpl("RNN")* are a popular choice for processing sequential data and time series in general.
They can inherently propagate information along a sequence so as to leverage global context to perform a task.
The main #acr("RNN") architectures are the #acr("LSTM") and #acr("GRU") designs.

Vaswani et al. @vaswani_attention_nodate famously introduced the transformer architecture, which has become the de facto neural network design for numerous complex tasks.
Attention-based neural networks have first been employed by the #acr("NLP") community in replacement for #acrpl("LSTM")s @radford_improving_nodate.
They share with #acr("RNN") the ability to propagate information along a sequence of tokens, which can then be used to make a decision.
In vision tasks, the transformer architecture has been successful as an alternative to the well-established convolutional design @dosovitskiy_carla_nodate.
Some approaches have employed transformers for #acr("SSL") as well.
Phan et al. @phan_audio_2020 @phan_multitask_2020 have achieved #todo

Some works, such as @cao_event-independent_2020 and @comminiello_quaternion_2019 have used a combination of #acr("CNN") and #acr("RNN"), refered to as #acrpl("CRNN") for #acr("SSL").

#draft[
  - How to (virtually) train your speaker localizer @srivastava_how_2023
  - Sound Source Localization Using Deep Learning Models @yalta_sound_2017

  Romain Serizel's papers on SSL:
]

*Output format*
As previously explained in @sec:active_ssl:background:variations, the output formats of #acr("SSL") detectors vary considerably across methods.
On the one hand, all solutions do not estimate the same values.
Some systems are limited to #acr("DoA") estimation, while others can additionally predict the distance.
On the other hand, the coordinate system used to express the detections is not always the same.
The vast majority of works compute the source position with respect to the microphone array.
Computing an absolute position would require additional knowledge about the environment, the microphones's positions, and the choice of a global frame for reference.
Nonetheless, different relative coordinate systems are used.
Spherical and polar systems consist of providing a #acr("DoA") value and, optionally, the elevation angle and/or the distance to the source.
Alternatively, other works choose to write the estimated detections in cartesian coordinates.
The latter choice involves predicting the distance, too.
Additionally, some works can be further distinguished from the usual regression formulation of #acr("SSL").
In fact, specific approaches have framed the localization problem as a classification task where the system is expected to select a region of space instead of producing one or more scalar values.
#todo


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
As depicted in this condensed overview, there have been multiple and diverse research efforts focused at solving the #acr("SSL") task.
Although this challenge has been explored extensively for decades, the ecosystem remains vibrant, and new solutions are constantly being proposed.
The evolution of the field demonstrates valuable progress as methods handle more and more complex variations of the problem.
Classical methods like #acr("TDoA"), beamforming, and subspace algorithms have provided foundational approaches, particularly in controlled settings. 
They also leveraged foundational physical and statistical characteristics of the recorded signals.
Researchers have gained a deep understanding of the underlying mechanism that could be used to infer sources' positions.
Then, as in the majority of information-processing fields, deep-learning methods have permitted significant advances.
They allowed pushing the boundaries of existing #acr("SSL") systems by leveraging large volumes of training data.
Many limitations of the classical methods were circumvented thanks to the expressiveness of deep neural networks.
Current research efforts try to optimize and enhance those data-based approaches by making them more efficient, robust, and performant.
The design of network architectures and pre-processing pipelines are examples of amelioration axes for such systems.
Despite its utility, #acr("SSL") remains a complex problem due to real-world constraints.
Deep learning-based SSL methods often require large, annotated datasets and face difficulties in generalizing across unseen environments and array geometries.
Issues such as scalability in multi-source settings and real-time processing constraints further underline the need for ongoing innovation.
Also, robotics is a vibrant application of #acr("SSL") systems, putting them in challenging environments.
In conclusion, #acr("SSL") research continues to evolve, balancing the precision of classical methods with the adaptability and robustness of modern deep learning techniques.
As advancements in hardware, algorithms, and datasets continue, #acr("SSL") systems are poised to play an increasingly integral role in enabling intelligent, perceptive machines to interact seamlessly with their acoustic environments.