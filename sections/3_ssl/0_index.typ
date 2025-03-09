#import "/utils.typ": *

= Sound Source Localization
<chap:ssl>
#minitoc(indent: true)

#draft[
  // TODO: write general intro
  Disclaimer: This short intro might have to be adapted if we change the organization of the chapter.
]

Our intent to investigate #acr("SSL") was initially motivated by our exploratory work in Deep Reinforcement Learning (see @chap:rl).
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
This is essential to guarantee the reproducibility of the results, which is not guaranteed when stochastic approaches are used.
Although numerous works have been tackling #acr("SSL") successfully, our attempts at this task have not been as encouraging.
Our results are limited to simple acoustic scenarios in a simulated environment.
Such efforts were made to understand the localization problem better and develop a working solution.
Unfortunately, several challenges have not been overcome, and the solutions that have been developed remain significantly flawed.
Nonetheless, the overall experimentation framework developed and designed during this project might still be a positive contribution.
Also, a particular attention was directed to extensive experimental campaigns.
The influence of various aspects of #todo of the has been thoroughly studied in ablation .
It should allow future research efforts to try different training approaches without going through the expensive engineering task.