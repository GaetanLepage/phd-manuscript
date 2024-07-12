#import "/utils.typ": *

== Sound source localization, State of the Art


=== Original problem
// Very broad introduction
Sound Source Localization (#acr("SSL")) is part of the classic challenges in artificial speech processing.
#chris("Example")
This challenge #chris("too causal, use for example requires") boils down to identifying the relative position of one or several sound sources leveraging an audition device.
A broad range of specific settings and methods have been investigated in the audio processing literature.


=== Classical approaches

// Handcrafted features

// Statistical methods

// Sharon's paper on estimators and their performance

=== Acoustic data representation <seq:ssl:sota:data_repr>

#chris[Do you use all of them? Concentrate at the the moment only on the methods you use. If you have later more time, then you can give others more place in a related work section.]
#gaet[No, but as this is the SotA section, I thought important to be more exhaustive.]

The numerical representation of the audio information is a crucial for achieving #acr("SSL").
Several pre-processing methods exist to ease the extraction of geometric information.

==== Waveform

==== Time-frequency representations

===== Short Term Fourier Transform

===== Interaural representation

As explained before, one want to leverage the delays between the signals listened by each microphone.

One of the motivation of using multiple microphones to perform Sound Source Localization is leveraging the delay at which the signal is listened 
In the case of a binaural microphone system,


=== Deep Learning for audio processing

=== Sound Source localization in robotics