#import "/utils.typ": *

= Sound Source Localization
<chap:ssl>

Auditory perception is a fundamental aspect of social robotics.
In their interactions, humans and robots convey information through speech for effective and natural communication.
As such, a robot must, inter alia, be able to listen and transcribe human speech.
This is achieved by #acr("ASR") systems.
Besides simply hearing, a robot needs to be able to localize the  active speaker.
#acr("SSL") is a central challenge in speech processing.
Although several formulations of this problem coexist, its essence consists in inferring the position of one or more active sources solely from the audio signal received by a microphone array.
Our interest in exploring #acr("SSL") is two-fold.
First, we aim to study how robots achieve this spatial aspect of auditory perception.
Our second motivation is to design effective models to investigate more specific tasks later.
Hence, along with @chap:simulator, this chapter will form the foundation for our following contributions.

First, this chapter provides an overview of the state-of-the-art in #acr("SSL").
It depicts the main trends of research in this domain.
Diverse and advanced approaches have successfully been applied to this challenging acoustic problem.
Also, we discuss the relevance of the #acr("SSL") task for the robotics research area and highlight essential works made in this field.
We then present our methodological and experimental work on this topic.
Single-source and multi-source statements of the localization problem have been explored in distinct ways.
The proposed solutions have been tested and implemented in the simulator introduced in the previous chapter.
  
#include "1_sota/0_index.typ"
#include "2_single_source/0_index.typ"
#include "3_multi_source/0_index.typ"

== Conclusion
<sec:ssl:conclusion>

This chapter exposes our investigations of the #acr("SSL") task.
Implementing different methods for this classic acoustic challenge constituted a significant engineering effort.
The empirical aspect of training deep neural networks leads to numerous experiments being conducted.
This is essential to guarantee the reproducibility of the results, which is not granted when stochastic approaches are used.
Our approach was not motivated by beating state-of-the-art #acr("SSL") techniques.
Conversely, sensible yet straightforward and robust models were designed and thoroughly tested to explore the intricacies of the localization task.
The acoustic simulator was leveraged to synthesize diverse datasets to study the limits of our solution.
An initial #acr("CNN") model handles single-source localization in reverberant environments.
It can handle multi-channel spectral data recorded by microphone arrays of different structures.
Next, a deeper architecture was implemented to tackle the more challenging problem of localizing several speech sources.
We adapted a multi-source localization method from recent works in the domain.
It was trained on large synthesized datasets generated for this purpose.
Our contribution includes an extensive experimental campaign to evaluate the performance of the proposed methods.
It also entails the complete pipeline to generate the datasets, train, and evaluate the network architectures.
This framework, combined with our acoustic simulator, may help the research community to easily and efficiently iterate on new ideas to improve #acr("SSL") methods.
It could alleviate future research efforts from going through an expensive engineering task.
Finally, both developed models were used as building blocks for this thesis's other contributions (see @chap:active_ssl and @chap:rl).

Yet, the proposed methods have some limitations.
Our models have been solely evaluated on synthetic data.
Testing the model's performance on real recordings would be a valuable addition.
Furthermore, embedding the localizers on a physical robotic platform would provide additional insight into their robustness to real-world constraints.
An additional study of localization performance in the presence of adversarial noise sources was initially planned.
Due to insufficient time, such experiments could not be satisfactorily conducted.
To conclude, #acr("SSL") is a diverse and challenging acoustic task that has benefited from extensive research effort.
Nevertheless, many amelioration paths are still worth pursuing, especially regarding their application in social robotics.
