#import "/utils.typ": *

== Custom Acoustic Simulation Pipeline
<sec:simulator:simulator>
#minitoc(indent: true)

The motivation to build a simulator from the ground up was to benefit from a capable yet flexible virtual platform for acoustic-based #acr("HRI") tasks.
Indeed, while existing audio simulation libraries offer a wide range of functionalities, they are generally designed as focused components dedicated to sound propagation, and are often integrated into larger ecosystems such as game engines (see @sec:simulator:background:rir_libraries).
Their scope is understandably limited to audio rendering rather than interaction modeling.
In contrast, the design of a custom, extensible platform for simulating diverse interaction scenarios, with support for varied audio sensors and acoustic representations, constitutes a central contribution of this work.
Its goal is to allow the simulation of various interaction scenarios involving a diverse array of audio sensors and acoustic representations.

Also, its implementation has evolved throughout the project, leading to an organic development process.
The feature set reflects the various downstream use cases encountered across this thesis.
The Python code for this pipeline has been published under an open-source license.

In this section, we will provide an overview of our simulator's main functionalities and use-case examples.


#include "1_overview.typ"
#include "2_components.typ"
#include "3_features.typ"
#include "4_performance/index.typ"

=== Conclusion

This section has presented our custom implementation of a complex acoustic pipeline.
The solution has been architected from scratch while naturally employing existing open-source building blocks.
This significant engineering effort is a central contribution of this thesis.
It aims to allow researchers to test algorithms in diverse acoustic scenarios.
The #acr("API") has been optimized to be as complete as possible while remaining user-friendly.
The code base is entirely written in Python to be directly integrated into new or existing research code bases.
Nevertheless, performance has been considered, and efficient specialized libraries have been used for the key computational features.

While the library has been enhanced and completed throughout the research project, it could be extended.
New features could later be added thanks to a very modular architecture.
Most notably, more visualization features could be added.
For instance, the current plotting features are based on the _Matplotlib_ library @hunter_matplotlib_2007 and remain limited.
They only offer a rudimentary step-by-step preview of the room.
Ultimately, the simulator could offer a more pleasant dynamic visualization of the movement of sources and sensors.
Furthermore, the handling of dynamic scenes follows a simple step-based approach that discretizes the movement of objects over time.
The addition of modern dynamic simulation techniques (@rosen_interactive_2020, @cao_interactive_2016, @schissler_interactive_2017) could make this pipeline even more relevant to robotics.
Finally, the simulator's scope has been delimited to auditory cues and sound processing.
The incorporation of a 3D visual rendering engine could transform the existing platform into a true multi-modal platform for a more complete simulation.
Such an endeavor would, however, require a significant additional engineering effort.
The entire code base of our simulator is freely available under the GPLv3 license #footnote[#link("https://github.com/GaetanLepage/acoustix")].
