#import "/utils.typ": *

== Conclusion and discussions
<sec:active_ssl:conclusion>

In this chapter, we have presented a custom approach for performing a simple task of #acr("SSL") in a dynamic multi-source context.

#draft[

  In general, the proposed approach breaks the #acr("ASSL") task into several steps for which a specific solution is presented.
  Although this allows for a high degree of explainability, an end-to-end solution could be explored.
  Regarding the deep neural network trained to perform map aggregation, the target maps are defined artificially.
  One could envisage directly learning to predict the source's positions from a batch of shifted #acr("DoA") maps.
  No clustering algorithm would thus be needed.
  Additionally, a deep learning approach could directly be fed with the #acr("DoA") spectrum instead of projecting them first as cones in 2D maps.
  Both of those tracks might allow pushing detection performance by eliminating hand-crafting middle steps.
  However, they would necessitate additional adaptations, inter alia, being able to localize an arbitrary number of sources.
  
  More generally, the chosen formulation for the #acr("ASSL") problem itself remains quite simplistic.
  Several works have addressed more complex variations of this task.
  Performing both the source localization as well as providing an optimized movement policy constitutes a more complete and relevant problem.
  Also, including a multimodal approach to this framework would constitute an obvious improvement to this audio-based solution.
  Indeed, most social robots incorporate both audio and vision sensors to allow for broader perceptual capabilities.
  Exploiting visual information could certainly strengthen the ability of the agent to localize speakers even in the presence of imperfect observations.
]

#draft[
  Insist on the difficulty of certain samples:
  - Very close sources
  - straight trajectories with source aligned with the trajectory (no real triangulation possible)
]
