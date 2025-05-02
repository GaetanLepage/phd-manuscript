#import "/utils.typ": *

= Sound Source Localization
<chap:ssl>

Auditory perception is a fundamental aspect of social robotics.
In their interactions, humans and robots convey information through speech for effective and natural communication.
As such, a robot must, inter alia, be able to listen and transcribe human speech.
This is achieved by #acr("ASR") systems.
Besides simply hearing, a robot needs to be able to localize the  active speaker.
#acr("SSL") is a central challenge in speech processing.
Although several formulations of this problem coexist, its essence consists in inferring the position of one or more active sources solely from the audio signal received by a microphone.
Our interest in exploring #acr("SSL") is two-fold.
First, we aim at studying how robots achieve this spatial aspect of auditory perception.
Our second motivation was to design effective models to later investigate more specific tasks.
Hence, along with @chap:simulator, this chapter servers as a building block for our next contributions.

First, this chapter provides an overview of the state-of-the-art in #acr("SSL").
It depicts the main trends of research in this domain.
Diverse and advanced approaches have successfully been applied to this challenging acoustic problem.
Also, we discuss the relevance of the #acr("SSL") task for the robotics research area and highlight essential works made in this field.
We then present our methodological and experimental work on this topic.
Single-source and multi-source formulations of the localization problem have been explored in distinct ways.
The proposed solutions are tested and implemented in the simulator introduced in the previous chapter.
  
#include "1_sota/0_index.typ"
#include "2_single_source/0_index.typ"
#include "3_multi_source/0_index.typ"

== Conclusion
<sec:ssl:conclusion>

This chapter exposes our investigations of the #acr("SSL") task.
Implementing different methods for this classic acoustic challenge constituted a significant engineering effort.
The empirical aspect of training deep neural networks leads to numerous experiments being conducted.
This is essential to guarantee the reproducibility of the results, which is not granted when stochastic approaches are used.
Although numerous works have been tackling #acr("SSL") successfully, our attempts at this task have not been as encouraging.
Our results are limited to simple acoustic scenarios in a simulated environment.
Such efforts were made to understand the localization problem better and develop a working solution.
Unfortunately, several challenges have not been overcome, and the solutions that have been developed remain significantly flawed.
Nonetheless, the overall experimentation framework developed and designed during this project might still be a positive contribution.
Also, particular attention was directed to extensive experimental campaigns.
The influence of various aspects of #todo of the has been thoroughly studied in ablation .
It should allow future research efforts to try different training approaches without going through the expensive engineering task.