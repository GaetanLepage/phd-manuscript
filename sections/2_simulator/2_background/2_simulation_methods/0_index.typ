#import "/utils.typ": *
#import "../../_notations.typ": *

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
Nonetheless, the efficiency of geometrical acoustics methods has led them to be widely adopted.


==== Numerical simulation of sound propagation
<sec:simulator:background:simulation:wave-based>

#block(breakable: false)[
  A natural approach to acoustic rendering is numerically solving the acoustic wave equation.
  The wave equation is a second-order partial differential equation characterizing the propagation of acoustic wave in a given medium (Feynman @feynman_lectures_2010, Volume I, Chapter 47):
  $
    (partial^2 p) / (partial x^2) = 1 / (#c^2) (partial^2 p) / (partial t^2)
  $
  <eq:simulator:background:acoustic_wave_eq>
  where $p: RR^3 times RR_+ -> RR$ is the acoustic pressure as a function of position $bold(x) in RR^3$ and time $t in RR_+$.
]
This strategy is the most faithful to the physical reality.
Theoretically, it accurately represents complex mechanisms such as diffraction, interference, scattering or modal resonances @cao_interactive_2016.
However, tackling this second-order partial differential equation is challenging.
No closed-form solution is readily available, and one must fall back to approximating a numerical solution.
Botteldooren @botteldooren_acoustical_1994 has proposed using the #acr("FDTD") method to obtain a practical solution to the acoustic wave equation.
In general, methods from this family discretize space and time to apply numerical integration techniques.
Kirkup @kirkup_boundary_2007 proposed an in-depth investigation of the application of the #acr("BEM") to acoustics.
It allows solving the Helmholtz equation by reformulating it into a boundary integral equation.
The #acr("BEM") method is less computationally expensive than the volume-based formulation.
Additionally, Thompson @thompson_review_2006 provides an overview of other #acrpl("FEM") for solving the Helmholtz equation.

More recently, Raghuvanshi et al. @raghuvanshi_efficient_2016 developed a new method to lower the computing cost of numerical simulation.
They introduce an adaptive rectangular description of 3D scenes, unlocking 100-fold speedups compared to traditional techniques.
This approach allows for rendering complex acoustic 3D scenes without requiring more than commodity hardware.
They can model large and challenging environments such as a cathedral.
However, high-frequency support is limited as they simulate only up to 1-2kHz.
Finally, their #acr("FDTD") scheme is not adapted to moving objects.

Rosen et al. @rosen_interactive_2020 tackle the problem of rendering acoustic scenes as efficiently as possible.
Also, they target dynamic situations where the geometry can evolve over time.
To achieve this, they restrict the solving to a 2D slice of the environment at the height of the listener's head.
They use a second order #acr("FDTD") scheme, operating at a frequency of 275Hz.
This approach shows compelling results in terms of performance and supported features.
The ability to run on a limited computing budget, such as a single CPU core, demonstrates its relevance for applications such as video games or virtual reality.
Limiting the model to two dimensions grants a significant performance uplift.
It must be noted that this approximation can affect the reproduction accuracy of certain phenomena, such as reflections and reverberations.
The C++ implementation is available as the _Planeverb_ open-source library @rosen_themattrosenplaneverb_2024.


==== Geometrical Acoustics

#reset-acronym("GA")
#acr("GA") denotes a broad class of methods partly motivated to circumvent the initial limitations of the wave-based methods.
More particularly, they aimed at providing more computationally efficient alternatives.
Its main principle resides in considering that sound propagates as rays @savioja_overview_2015.
This is an immediate parallel of the ray-based rendering techniques used for light (ray tracing).
Each ray travels in a straight line in the air until it hits a wall.
It then deviates by following a simplistic specular reflection model.
The assumption that all reflections are specular boils down to supposing the walls' surface being ideally rigid.
This implies that all sound wave properties are neglected, and thus, diffraction effects are entirely neglected.
There are two main categories of #acr("GA") methods: the image source techniques and the ray tracing ones.
Rindel @rindel_computer_1995 gives a clear overview of those two families of methods along with their respective advantages and drawbacks.
Both categories are further explained in the next two paragraphs.
// Room acoustics equation
Siltanen et al. @siltanen_room_2007 propose a general formulation for the #acr("GA") approach to sound rendering.
They introduce the _room acoustic rendering equation_, which aims to provide a unifying framework for the diverse #acr("GA") techniques (beam tracing, ray tracing, image source, etc.).
They can then all be expressed as particular cases of this general rendering equation.
They draw their inspiration from the optics and computer graphics literature.
Thanks to its generality, this formulation can model both specular and diffuse reflections.


#reset-acronym("ISM")
*Image source methods.*
The image source method is among the most notable and popular #acr("GA") approaches.
It was also one of the first methods to simulate sound propagation in reverberant environments.
Initially introduced by Lothar Cremer in 1948 @cremer_wissenschaftlichen_1948, this concept still stands today as an efficient way of modeling the reverberation phenomenon.
It constructs specular reflections by mirroring each sound source in the plane of the reflecting surface.
This process can be repeated recursively to model reflection up to a given order.
@fig:simulator:background:image_source shows the virtual image sources for an example setup.
According to Savioja @savioja_overview_2015, Gibbs et al. @gibbs_simple_1972 were the first to propose an implementation for computing image-source positions and sound pressure levels in a rectangular room.
Borish et al. @borish_extension_1984 extended the model from rectangular _shoe-box_ rooms to arbitrary polyhedra.
Allen and Berkley significantly expanded this idea back in 1979 by developing a more comprehensive and computationally effective version of the #acr("ISM") @allen_image_1979.
Their paper came with a FORTRAN implementation of the proposed algorithm.
The significant popularity of the #acr("ISM") is partly due to its simplicity and efficiency.

#figure(
  image("figures/image_source.svg"),
  caption: flex-caption(
    [
      Representation of the first-order virtual image sources @schimmel_fast_2009.
      The physical source $S$ leads to 4 virtual sources $S_i$, i.e. one per reflective surface.
      The black arrow represents the direct path from the source to the receiver.
      The grey arrows depict the paths corresponding to the first-order reflections.
    ],
    [
      Representation of the first-order virtual image sources
    ]
  )
)
<fig:simulator:background:image_source>


*Ray tracing methods.*
The second family of #acr("GA") methods consists of the ray tracing approaches.
This paradigm considers that sound behaves similarly to light particles.
More precisely, sound is supposed to travel as rays along straight paths.
As soon as a ray hits a wall, its direction is updated according to Snell's law from geometrical optics.
Hence, ray tracing methods historically only account for specular reflections.
A small volume is delimited around the receiver to obtain the resulting signal.
Then, all rays traversing this volume will contribute to the final response.
Krokstad et al. @krokstad_early_2015 overview the early history of ray tracing methods in acoustics.
Cao et al. @cao_interactive_2016 propose an advanced algorithm based on bidirectional path tracing: #acr("BST").
It addresses the drawbacks of existing ray-tracing #acr("GA") methods.
They reformulate Silken's _room acoustic rendering equation_ @siltanen_room_2007.
Schissler et al. @schissler_interactive_2017 propose an innovative hybrid algorithm handling complex scenes with numerous sources.
It combines a ray-tracing approach with sound source clustering to accurately model both indoor and outdoor environments.
The clustering of distant sound sources allows their algorithm to efficiently scale with the number of sources while keeping the processing time low.
// Neural network
Tang et al. @tang_learning_2020 combine a ray-tracing algorithm with a deep neural network to render dynamic acoustic scenes at high refresh rates.
The dataset to train the network was generated using an accurate wave-based method.
This work is motivated to provide a hybrid approach combining high fidelity and responsiveness.
Their approach can represent multiple reflection patterns (specular and diffuse reflections and diffraction).
During training, the network learns to predict the scattering fields of objects.
At inference time, the network achieves real-time performance and can handle dynamic scenes where objects are moving.


==== Simulation of dynamic environments

The original methods for acoustic simulation were limited to static scenes where neither sources nor microphones move across time.
This ideal situation is not representative of real-world scenarios.
Especially in robotics, modeling moving humans and agents is an essential requirement.
Historical techniques such as the #acr("ISM") solely account for a given static layout of the sources and sensors.
The result of the #acr("ISM") process is a set of #acr("RIR") filters, one for each microphone-source pair.
The resulting listened signal is computed by convolving the source's input signals with those filters.
However, the filters must be recomputed as soon as a source or microphone moves.
Chen et al. @chen_soundspaces_2020 pre-compute the #acr("RIR") filters for each attainable configuration of their simulated environment.
This upfront computation moves the substantial simulation effort from training to a prior pre-processing step.
#todo limitation has been explored in the literature in various ways.

#draft[
  - Acoustic Simulation in Dynamic Environments for Robot Audition @zhang_acoustic_2019
  - Also, Gpu-RIR @diaz-guerra_gpurir_2021 have hacked a way to simulate on trajectories
]