#import "/utils.typ": *

=== Related works
<sec:simulator:reverb:methods>

#reset-acronym("ISM")
==== #acr("ISM")

The #acr("ISM") principle was one of the first methods to simulate sound propagation in reverberant environments.
The concept, originally introduced by Lothar Cremer in 1948 @cremer_wissenschaftlichen_1948 still stands today as an efficient way of modeling this physical phenomenon.
Allen and Berkley significantly expanded this idea in 1979 by developing a more comprehensive and computationally effective version of the image source method @allen_image_nodate.
Their paper came with a FORTRAN implementation of the proposed algorithm.
At first, the #acr("ISM") was limited to rectangular _shoebox_ room.
In 1984, Jeffrey Borish extended the technique to arbitrary polyhedral rooms @borish_extension_1984.

#draft[
  - Asumptions

  Resources: Waveverb (https://reuk.github.io/wayverb/image_source.html)
]

// OG paper:

// @srivastava_how_2023 has some info on ISM ('Method' section)


==== Numerical simulation of sound propagation

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
