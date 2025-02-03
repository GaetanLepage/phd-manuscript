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
The proposed solutions are tested and implemented in the simulator presented in the previous chapter.
  
#include "1_sota/0_index.typ"
#include "2_single_source/0_index.typ"
#include "3_multi_source/0_index.typ"