#import "/utils.typ": clorem, acr

// English abstract
= Abstract

Social robotics is a diverse, multidisciplinary research field aiming to bring capable robotic agents to the physical world.
More specifically, this branch of robotics tackles the question of human-robot interactions in which robots are not in controlled isolated environments, but rather collaborating with humans on complex tasks.
It includes numerous challenges such as multi-modal perception, action planning, and operating safely in the physical world.
This thesis explores a selection of essential tasks for building effective social robots.
Our investigation is oriented toward the acoustic dimension of these tasks.

// Simulator
First, we introduce a capable yet flexible acoustic simulation environment.
This contribution builds on state-of-the-art sound rendering components to provide a featured sandbox for training and testing novel acoustic algorithms.
Deep Learning methods have allowed considerable breakthroughs in robotics.
Yet, they require extensive data, often scarce and costly when physical robotic systems are involved.
Hence, simulation can be crucial in generating a lot of data with excellent scaling.

// SSL
Auditory perception comprises multiple facets.
#acr("SSL") is a key ability for social robots and is grounded in a dense and long-lasting scientific literature.
It entails accurately identifying the location of one or multiple active speakers.
We study this problem from different angles and propose a collection of deep learning methods tackling its challenges.
After introducing an initial single-source solution, we implement a more capable multi-source deep learning localizer.
Extensive experimental studies are conducted to assess the performance of the proposed models in various configurations.

// Active SSL
In social robotics, sound source localization has to consider motion.
Multiple approaches exist to model dynamic scenarios in this regard.
We propose a novel approach for aggregating the predictions from our static multi-source localizer over time.
This framework leverages a robot's arbitrary motion to refine its estimate of speakers' locations.
The acoustic simulator was extended to synthesize complete trajectories in the virtual room, allowing for training and evaluating a deep neural network.

Perception and action are the two essential categories of robotics capabilities.
After exploring the acoustic perception aspect, we proposed to apply modern #acr("DRL") techniques to robot navigation.
Our research aimed to grant robots better hearing capabilities through motion.
Recent #acr("ASR") models offer strong capabilities and allow robots to automatically transcribe human speech.
However, their performance can degrade in reverberant environments.
We introduce a perceptually motivated navigation task where a robot should position itself to minimize speech recognition errors.
The agent's decisions are solely derived from the audio signal recorded by its microphone array.
This last contribution leverages our prior findings and methods in acoustic simulation and sound source localization.

*Keywords:* deep learning, robotic auditory perception, sound source localization, reverberation, human-robot interactions

// French abstract
= Résumé

#clorem(100)

#clorem(50)


Mots clefs: apprentissage profond, perception auditive en robotique, localisation de source sonore, reverberation, interaction humain robot