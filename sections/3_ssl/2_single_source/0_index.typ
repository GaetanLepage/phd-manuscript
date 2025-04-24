#import "/utils.typ": *

== Single-source localization
<sec:ssl:single_source>
#minitoc(indent: true)

As a first experiment, we investigate the single-source localization problem.
The goal is to design and train a deep learning model that can precisely localize a source in a reverberant environment.
This project involves programming a data collection pipeline from the earlier developed simulator.
Generating custom synthetic datasets has allowed us to test our approach in various conditions.
This section details the adopted deep-learning-based approach and the technical choices made.


#include "1_problem_statement.typ"
#include "2_method.typ"
#include "3_experiments.typ"


=== Conclusion

// TODO
// Limitations: single source (i.e., not more than one BUT ALSO always at least one)
Single-source localization is a fundamental problem of acoustics and plays an important role in robotics applications.
In this first section, we have developed a deep neural network sound source localizer.
Our solution has been designed and trained from scratch and is inspired by the vast deep-learning-based #acr("SSL") literature.
Original datasets were synthesized using our audio simulation library.
They allowed us to train and evaluate the proposed network architecture on various scenarios.
An extensive experimental campaign assessed the relative importance of different parameters in the localization performance.
// Limitations
Additional questions could be further investigated.
For instance, this work has not studied the impact of adversarial noise sources.
Although accounting for acoustic reverberation is essential to properly model the physical world, noise sources should ideally also be included.
While our simulator handles several sources and can use various noise signals as inputs, we have not been able to dedicate enough time to its inclusion in the #acr("SSL") pipeline.
// Transition
This project was essential to understand better the #acr("SSL") problem.
Also, the deep neural network trained for this occasion is used as a feature extractor in our #acr("RL") pipeline for acoustic-based navigation (see @chap:rl).
The rest of this chapter will study the more complex case of multi-source localization.