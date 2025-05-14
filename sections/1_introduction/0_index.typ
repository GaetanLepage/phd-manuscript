#import "/utils.typ": *

= Introduction
<chap:intro>


#include "1_motivations.typ"
#include "2_outline_and_contributions.typ"
#include "3_thesis_structure.typ"



#draft[

  An interesting point is the limitation to audio.
  - On the one hand, it is a limit as we didn't have the time to explore visual perception.
  - On the other hand, learning from audio only is harder (less information)

  Critic evaluation:
  *Positives:*
  - Decent engineering effort
    - Capable simulator, with various simulation
    - All the software has been developped from scratch:
      - Deep Networks;
      - Algorithms (supervised, RL...)
      - Data collection
    -> We do not fork an existing code base.
  
  *Negatives / Limits (Why this work might be completely useless):*
  - Better simulators exist. Ours is very simplistic
  - No novelty on the (static) SSL part.
    - We haven't used transformers
    - Not trained/evaluated on a physical real-world setup
  - Active SSL is fairly new...
  - Our RL policy is not really useful as:
    - Better ASR that are less sensible to position might exist
    - other similar works exist and are more capable
  - In general, no attention to adversarial noise sources
  - *More specifically, this is basically _Move2Hear_ but worse.*
]

// == Funding
// 
// The SPRING H2020 project @alameda-pineda_socially_2024 aimed at bringing socially capable robots to gerontological healthcare.
// It brought together eight European academic and industrial partners to develop the algorithms, models, and software components necessary for the ARI robot to successfully perform complex social tasks (@fig:intro:ari).
// This PhD project was funded as a component of the SPRING project.