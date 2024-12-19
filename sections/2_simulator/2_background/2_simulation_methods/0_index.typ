#import "/utils.typ": *

=== Overview of acoustic reverberation simulation methods
<sec:simulator:reverb:methods>

Simulating the acoustic reverberation phenomenon has a broad range of applications.
Reverberation must be considered when a scene happens indoors to obtain a realistic render.
Thus, diverse communities have explored this problem, from physicists and roboticists to the video game industry and the signal processing community.
// Historic context
This task has been referred to as computational room acoustic modeling or auralization.
The first works mentioning the acoustic rendering concept  originate from the 1960s @schroeder_natural_1962.
This second term was coined in 1993 by Kleiner et al. @kleiner_auralization-overview_1993, inspired by the concept of visualization for visual rendering.
In 1992, Takala et @takala_sound_1992 proposed a thorough description of a general methodology for sound rendering.
Savioja et al. @savioja_introduction_2019 highlight the diversity of the existing methods for sound rendering despite the field's relative youth.

Several approaches have been employed to tackle the auralization task.
They differ on which underlying physical model and equation they use.
Hence, a taxonomy can be derived from those differences.
We may first consider rigorous methods that explicitly attempt to solve the acoustic wave equation using numerical methods.
Indeed, closed-form analytic solutions do not exist in the general case.
The different existing practical strategies are presented later in this section.

Geometrical acoustics denotes a family of methods that adopt another approach to this problem.
Instead of adhering to strict physical modeling of the sound propagation phenomenon, they assume that sound behaves as rays.
This choice implies the neglect of the wave nature of sound and is, therefore, less accurate.
Nonetheless, the efficiency of geometrical acoustics methods has made them widely adopted.


==== Numerical simulation of sound propagation

A natural approach to acoustic rendering is to numerically solve the acoustic wave equation.
This strategy is the most faithful to the physical reality.
Theoretically, it accurately represents complex mechanisms such as diffraction, interference, or modal resonances.
However, tackling this second-order partial differential equation is challenging.
No closed-form solution is readily available, and one must fall back to approximating a numerical solution.
Botteldooren @botteldooren_acoustical_1994 has proposed using the finite-difference time-domain method to obtain a practical solution to the acoustic wave equation.
In general, methods from this family discretize space and time to apply numerical integration techniques.

More recently, Raghuvanshi et al. @raghuvanshi_efficient_2016 developed a new method to lower the computing cost of numerical simulation.
They introduce an adaptive rectangular description of 3D scenes, unlocking 100-fold speedups compared to traditional techniques.
This approach allows for rendering complex acoustic 3D scenes while not requiring more than commodity hardware to run.
They are able to model difficult and large environments such as a cathedral.
However, high frequency support is limited as only 
- @rosen_interactive_2020 + Planeverb library
- @benhamou_numerical_2023

#reset-acronym("ISM")
==== #acr("ISM")

The #acr("ISM") principle was one of the first methods to simulate sound propagation in reverberant environments.
Initially introduced by Lothar Cremer in 1948 @cremer_wissenschaftlichen_1948, this concept still stands today as an efficient way of modeling the reverberation phenomenon.
Allen and Berkley significantly expanded this idea in 1979 by developing a more comprehensive and computationally effective version of the image source method @allen_image_nodate.
Their paper came with a FORTRAN implementation of the proposed algorithm.
At first, the #acr("ISM") was limited to rectangular _shoebox_ room.
In 1984, Jeffrey Borish extended the technique to arbitrary polyhedral rooms @borish_extension_1984.

#draft[
  - Assumptions

  Resources: Waveverb (https://reuk.github.io/wayverb/image_source.html)
  - @srivastava_how_2023 has some info on ISM ('Method' section)
]

// OG paper:



==== Geometrical Acoustics

Geometrical Acoustics

Path/ray tracing
- @savioja_overview_2015
- Krokstad et al. The early history of ray tracing in acoustics
- @cao_interactive_2016,
- @schissler_interactive_2017

==== Other methods
// Neural network
@tang_learning_2020,


==== Simulation of dynamic environments

Most of the works previously cited focus on static environments where neither sources nor microphones are moving across time.
This ideal situation is not representative of real-world scenarios.
Especially in robotics, modeling moving humans and agents can 

#draft[
  - Acoustic Simulation in Dynamic Environments for Robot Audition @zhang_acoustic_2019
  - Also, Gpu-RIR @diaz-guerra_gpurir_2021 have hacked a way to simulate on trajectories
]