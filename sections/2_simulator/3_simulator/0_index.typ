#import "/utils.typ": *

== Custom acoustic simulation pipeline
<sec:simulator:simulator>
#minitoc(indent: true)

The motivation to build a simulator from the ground up was to benefit from a capable yet flexible virtual platform for acoustic-based #acr("HRI") tasks.
Indeed, although audio simulation libraries offer a wide range of possibilities, they are mostly proof of concepts (see @sec:simulator:background:rir_libraries).
Their goal is rightfully limited to the sole sound simulation, and are used as building blocks of larger software or ecosystems like video games for example.
The conception of a custom and extensible interaction platform represents a core contribution of this work.
Its goal is to allow the simulation of various interaction scenarios involving a diverse array of audio sensors and acoustic representations.

Also, its implementation has evolved along the project and has lead to an organic development process.
The set of features reflects the various downstream usages made for several years.
The Python code for this pipeline has been published under an open-source license #footnote[#link("https://gitlab.inria.fr/robotlearn/rl-audio-nav")].

In this section, we will provide an overview of our simulator's main functionalities and use-case examples.


#include "1_overview.typ"
#include "2_components.typ"
#include "3_features.typ"
#include "4_performance.typ"

=== Conclusion

#draft[
  - Possible addition of visual information
]
This section presented our custom implementation of a complex acoustic pipeline.
The solution has been architectured from scratch while naturally employing existing open-source building blocks.
This significant engineering effort is a central contribution of this thesis.
It aims to allow researchers to test algorithms in diverse acoustic scenarios.
The #acr("API") has been optimized to be as complete as possible while remaining user-friendly.
The code base is entirely written in Python to be straightly integrated into new or existing research code bases.
Nevertheless, performance has been considered, and efficient specialized libraries have been used for the key computational features.

While the library has been enhanced and completed throughout the research project, it could be extended.
New features could later be added thanks to a very modular architecture.
Most notably, more visualization features could be added.
For instance, the current plotting features are based on the _Matplotlib_ library @hunter_matplotlib_2007 and remain limited.
They only offer a rudimentary step-by-step preview of the room.
Ultimately, the simulator could offer a more pleasant dynamic visualization of the movement of sources and sensors.
Furthermore, the handling of dynamic scenes follows a simple step-based approach that discretizes the movement of objects in time.
The addition of modern dynamic simulation techniques (@rosen_interactive_2020, @cao_interactive_2016, @schissler_interactive_2017) could make this pipeline even more relevant to robotics.

The entire code base of our simulator is freely available under the GPLv3 license #footnote[#link("https://gitlab.inria.fr/robotlearn/rl-audio-nav")].