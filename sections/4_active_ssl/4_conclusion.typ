#import "/utils.typ": *

== Conclusion and discussion
<sec:active_ssl:conclusion>

This chapter presents a custom approach for performing a simple #acr("SSL") task in a dynamic multi-source context.

The proposed approach generally breaks the #acr("ASSL") task into several steps for which a specific solution is presented.
Although this allows for a high degree of explainability, an end-to-end solution could be explored.
Regarding the deep neural network trained to perform map aggregation, the target maps are defined artificially.
One could envisage directly learning to predict the source's positions from a batch of shifted #acr("DoA") maps.
No clustering algorithm would thus be needed.
Additionally, a deep learning approach could directly be fed with the #acr("DoA") spectrum instead of projecting them first as cones in 2D maps.
Both tracks might allow pushing detection performance by eliminating hand-crafting middle steps.
However, they would necessitate additional adaptations, such as the ability to localize an arbitrary number of sources.

The presented solution achieves convincing performance on this task.
Naturally, the precision of the final position estimation highly depends on the quality of the provided #acr("DoA") spectra.
Also, the agent trajectory and the relative position of sources significantly impact the detection.
For instance, cases where, on the one hand, the trajectory remains relatively straight and, on the other hand, the source lies on this line, happen to be challenging.
Indeed, the relative movement of the agent does not bring additional angular information.
This makes the implicit triangulation process fail almost certainly.
Also, when sources are very close to the agent, the produced aggregated map is difficult to cluster properly.

More generally, the chosen formulation for the #acr("ASSL") problem remains simplistic.
Several works have addressed more complex variations of this task.
Performing source localization and providing an optimized movement policy constitutes a more complete and relevant problem.
Also, including a multimodal approach to this framework would constitute a noticeable improvement to this audio-based solution.
Indeed, most social robots incorporate audio and vision sensors, allowing for broader perceptual capabilities.
Exploiting visual information could certainly strengthen the agent's ability to localize speakers despite imperfect observations.