#import "/utils.typ": *

== Custom acoustic simulation pipeline <sec:simulator:simulator>
#minitoc(indent: true)

The motivation to build a simulator from the ground up was to benefit from a capable yet flexible virtual platform for acoustic-based #acr("HRI") tasks.
Indeed, although audio simulation libraries offer a wide range of possibilities, they are mostly proof of concepts (see @sec:simulator:background:rir_libraries).
Their goal is rightfully limited to the sole sound simulation and are used as building blocks of larger software or ecosystem like video games for example.
The conception of a custom and extensible interaction platform represents a core contribution of this work.
Its goal is to allow for simulating various interaction scenarios involving a diverse array of audio sensors and acoustic representations.

Also, its implementation has evolved along the project and has lead to an organic development process.
The set of features reflects the various downstream usages that have been made in the course of several years.
The Python code for this pipeline has been published under an open source license #footnote[#link("https://gitlab.inria.fr/robotlearn/rl-audio-nav")].

In this section, we will provide an overview of the main functionalities offered by our simulator as well as use case examples.


#gaet[Should we mention that the simulator (along with the entire code base for this PhD) is available as open source ?]

#include "1_overview.typ"
#include "2_components.typ"
#include "3_features.typ"

== Conclusion

#draft[
  - Possible addition of visual information
]