#import "/utils.typ": clorem, acr

// English abstract
= Abstract

// TODO: Try to remove 1 sentence instead
#v(-1em)

Social robotics is a diverse, multidisciplinary research field aiming to bring capable robotic agents to the physical world.
In particular, it addresses the challenges of human-robot interaction, in which robots operate not in isolated, controlled environments but alongside humans in dynamic and complex tasks.
This domain involves numerous challenges, including multi-modal perception, action planning, and safe real-world operation.
This thesis explores a selection of essential tasks involved in building effective social robots.
Our investigation is oriented toward the acoustic dimension of these tasks.

// Simulator
First, we introduce a flexible and powerful acoustic simulation environment.
Built upon state-of-the-art sound rendering components, this environment serves as a feature-rich sandbox for training and evaluating novel auditory algorithms.
Deep learning has enabled major advances in robotics, but such methods require large volumes of data—data that is often costly or impractical to collect in physical settings. Simulation thus plays a key role in scaling data generation for learning.

// SSL
Auditory perception encompasses several core abilities, among which #acr("SSL") is critical for social robots.
#acr("SSL") involves identifying the location of one or more active speakers and draws from a long-standing body of research.
We examine this problem from multiple angles and introduce a series of deep learning-based methods to address its key challenges.
After presenting a single-source solution, we implement a more advanced multi-source localizer and conduct extensive experiments to evaluate its performance across varied conditions.

// Active SSL
In social robotics, sound source localization must account for motion.
Multiple approaches exist to model dynamic scenarios in this regard.
We propose a novel method for aggregating predictions from our static multi-source localizer over time.
This framework leverages arbitrary robot motion to refine speaker position estimates.
The acoustic simulator is extended to synthesize full trajectories in virtual environments, enabling effective training and evaluation of this dynamic localization model.

Perception and action are the two pillars of robotic capability.
After exploring the acoustic perception aspect, we turn to action by applying modern #acr("DRL") techniques to robot navigation.
Our goal is to grant robots better hearing capabilities through movement.
Recent #acr("ASR") models offer strong performance, enabling robots to transcribe human speech.
However, #acr("ASR") systems are sensitive to reverberation, which can significantly degrade recognition accuracy.
To address this, we introduce a perceptually motivated navigation task in which a robot learns to position itself to minimize speech recognition errors.
The agent’s decisions are based solely on the audio captured by its microphone array.
This final contribution builds on our previous work in acoustic simulation and sound source localization, integrating perception and action to improve embodied auditory intelligence.

*Keywords:*
deep learning,
robotic auditory perception,
sound source localization,
acoustic simulation,
robot navigation,
deep reinforcement learning,

// French abstract
= Résumé

La robotique sociale est un domaine de recherche vaste et multidisciplinaire, visant à faire émerger des agents robotiques capables d'interagir dans le monde physique.
Elle traite notamment des enjeux liés à l'interaction homme-robot, où les robots ne sont plus confinés à des environnements contrôlés et isolés, mais évoluent aux côtés des humains dans des contextes dynamiques et complexes.
Ce domaine soulève de nombreux défis, notamment la perception multimodale, la planification d'action et l'opération sécurisée en conditions réelles.
Cette thèse explore un ensemble de tâches essentielles pour la conception de robots sociaux efficaces, avec un intérêt particulier porté sur leur dimension acoustique.

Nous introduisons tout d'abord un environnement de simulation acoustique à la fois flexible et puissant.
Reposant sur des technologies de rendu sonore avancées, cet environnement constitue une plateforme d'expérimentation riche en fonctionnalités pour l'entraînement et l'évaluation de nouveaux algorithmes auditifs.
L'apprentissage profond a permis des avancées majeures en robotique, mais ces méthodes nécessitent de grandes quantités de données — souvent coûteuses ou difficiles à obtenir dans des environnements physiques.
La simulation joue donc un rôle clé dans la génération de données à grande échelle pour l'apprentissage.

La perception auditive regroupe plusieurs capacités fondamentales, parmi lesquelles la localisation de sources sonores, cruciale pour les robots sociaux.
Cette tâche consiste à estimer la position d'un ou plusieurs locuteurs actifs, et s'appuie sur un important corpus de travaux scientifiques.
Nous abordons ce problème sous différents angles et proposons une série de méthodes basées sur l'apprentissage profond pour relever ses principaux défis.
Après avoir présenté une solution pour une seule source, nous développons un localisateur multi-sources plus performant, que nous évaluons de manière approfondie dans divers contextes expérimentaux.

Dans le cadre de la robotique sociale, la localisation sonore doit également prendre en compte le mouvement.
Plusieurs approches existent pour modéliser ces scénarios dynamiques.
Nous proposons une méthode originale d’agrégation temporelle des prédictions issues de notre localisateur statique multi-sources.
Ce cadre permet d’exploiter les déplacements arbitraires du robot afin d’affiner l'estimation des positions des locuteurs.
Le simulateur acoustique a été étendu pour générer des trajectoires complètes dans un environnement virtuel, permettant ainsi l'entraînement et l'évaluation efficaces de ce modèle dynamique.

La perception et la prise d'actions représentent les deux piliers des capacités robotiques.
Après avoir exploré la dimension perceptive, nous abordons la capacité des robots à agir en appliquant des techniques modernes d'apprentissage par renforcement profond à la navigation robotique.
Notre objectif est de doter les robots d’une meilleure capacité d'écoute grâce à leur mouvement.
Les modèles récents de reconnaissance automatique de la parole offrent des performances remarquables et permettent aux robots de transcrire la parole humaine.
Cependant, ces systèmes restent sensibles aux réverbérations, ce qui peut nuire à leur précision.
Pour y remédier, nous introduisons une tâche de navigation guidée par la perception, où le robot apprend à se positionner de manière à minimiser les erreurs de transcription automatique.
Les décisions de l'agent reposent uniquement sur les signaux audio captés par sa matrice de microphones.
Cette dernière contribution s'appuie sur nos travaux antérieurs en simulation acoustique et en localisation sonore, intégrant perception et action pour améliorer l'intelligence auditive embarquée.

*Mots-clés:*
apprentissage profond,
perception auditive en robotique,
localisation de sources sonores,
simulation acoustique,
navigation robotique,
apprentissage par renforcement profond.