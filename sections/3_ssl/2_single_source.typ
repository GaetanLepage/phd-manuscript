#import "/utils.typ": *

== Single-source localization
#minitoc(indent: true)

=== Problem statement

A robotic agent is evolving in a reverberant room.
A single speech source is also present in the environment.
The task consists in finding an


=== Method


==== Data

===== Custom dataset for #acr("SSL")

The objective of this study was to adapt State of the Art #acr("SSL") methods to diverse challenging setups.
The capable simulator presented in the previous chapter has let us put up different datasets to experiment with.

// Each training sample is a one second long audio recorded by the microphone array in the presence of a speech source.
// The latter is also randomly situated in the room.
// The label consists of the angle (Direction of Arrival, DOA) and the distance to the source.
// The network is trained to infer the location of the speech source solely from the audio signal it perceives.
// The sound source localization task stands as one of the core problems of the signal processing community.
// Numerous deep learning based approaches have been used to tackle this challenge.
// % TODO cite SSL study of Laurent
// In the context of this work, by obtaining reasonable performance on this supervised task ensures that the chosen convolutional backbone is able to extract spatial cues from the audio signal.


===== Microphone arrays

// Binaural
// Triangle
// Square

==== Neural Network Architectures

// TODO: figure of the architecture

=== Experiments

==== Impact of input signal representation

// Compare ILD/IPD performances


==== Sound Source Localization in noisy environments

// Which kinds of noises