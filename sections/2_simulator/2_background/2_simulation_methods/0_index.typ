#import "/utils.typ": *

=== Overview of acoustic reverberation simulation methods
<sec:simulator:reverb:methods>

@savioja_introduction_2019

Simulating the acoustic reverberation phenomenon has a broad range of applications.
Reverberation must be considered when a scene happens indoors to obtain a realistic render.
This section provides an overview of the existing methods for rendering acoustic scenes.
The literature is diverse, as several communities have been interested in solving this problem.
The video game industry is motivated by rendering realistic environments and computing the appropriate room's response to every audio event.
#draft[Add references to papers in this regard]
In robotics


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


==== Numerical simulation of sound propagation

Another approach to acoustic rendering is to solve the physical equation of sound propagation numerically.

- @raghuvanshi_efficient_2016
- @rosen_interactive_2020 + Planeverb library
- @benhamou_numerical_2023

==== Geometrical Acoustics

Path/ray tracing
- @savioja_overview_2015
- @cao_interactive_2016,
- @schissler_interactive_2017

==== Other methods
// Neural network
@tang_learning_2020,


==== Simulation of dynamic environments

#draft[
  - Acoustic Simulation in Dynamic Environments for Robot Audition @zhang_acoustic_2019
  - Also, Gpu-RIR @diaz-guerra_gpurir_2021 have hacked a way to simulate on trajectories
]