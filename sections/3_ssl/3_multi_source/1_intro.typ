#import "/utils.typ": *

Complex human-robot interaction environments often imply a varying number of sound sources.
Hence, at a given time, the room might be completely silent.
On the other hand, multiple concurrent sources of different kinds could be active simultaneously.
The current section presents our investigation of a multi-source localization framework that will give our acoustic agent additional flexibility.
We showcase a deep neural network that was implemented and trained on a challenging customized dataset, which was collected thanks to our simulator.
This approach complements the initial investigation in single-source localization.

//TODO
//#gaet[
//  Maybe do not talk about them this soon.\
//  However, it might be important to clearly state that this paper was the main inspiration for that part of our work.\
//  Also, precise that we will mostly adopt the same notations as them on purpose.
//]
//Weipeng He et al. have proposed and explored an interesting framework for multi-source localization.
//#draft[
//  - @he_deep_2018
//  - @he_joint_2018
//  - @he_neural_2021
//]
// flexible