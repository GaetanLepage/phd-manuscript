#import "/utils.typ": *

== Single-source localization
<sec:ssl:single_source>
#minitoc(indent: true)

As a first experiment, we investigate the single-source localization problem.
The goal is to design and train a deep learning model to localize a source in a reverberant environment precisely.
This project involves programming a data collection pipeline from the earlier developed simulator.
Generating custom synthetic datasets has allowed us to test our approach in various conditions.
This section details the adopted deep-learning-based approach along with the technical choices that have been made.


#include "1_problem_statement.typ"
#include "2_method.typ"
#include "3_experiments.typ"


=== Conclusion

// TODO
// Limitations: single source (i.e., not more than one BUT ALSO always at least one)
Single-source localization is a fundamental problem of acoustics and plays an important role in robotics applications.
//In this first 