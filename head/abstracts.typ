#import "/utils.typ": clorem, acr

// English abstract
= Abstract

// TODO: Try to remove 1 sentence instead
//#v(-1em)

Social robotics is a diverse, multidisciplinary research field aiming to design capable robotic agents.
In particular, it addresses the challenges of human-robot interaction, in which robots operate not in isolated, controlled environments but alongside humans in performing dynamic and complex tasks.
This domain poses numerous challenges, including multi-modal perception and action planning.
This thesis explores a selection of essential tasks involved in building effective social robots, with a particular focus on their acoustic dimension.
Specifically, we investigate #acr("SSL") in both static and active contexts, as well as perceptually motivated robot navigation.

// Simulator
To support this investigation, we first introduce a flexible and powerful acoustic simulation environment.
It enables the virtual recording of signals in reverberant rooms, with the ability to model various microphone arrays, room geometries, and sound source configurations.
Built upon state-of-the-art sound rendering libraries, this environment serves as a feature-rich sandbox for training and evaluating novel auditory algorithms.
Since deep learning has enabled major advances in robotics but requires large volumes of data, often costly or impractical to collect with physical systems, simulation plays a key role in enabling scalable data generation.

// SSL
Within this simulated framework, we focus on auditory perception as a foundational capability.
Among its various facets, #acr("SSL") is especially critical for social robots.
#acr("SSL") involves identifying the location of one or more active speakers and is grounded in a long-standing body of research. 
We examine this problem from multiple perspectives and introduce a series of deep-learning-based methods to address its main challenges.
After presenting a solution for the single-source case, we propose a more advanced multi-source localizer.
Both models are thoroughly evaluated through extensive experiments conducted under varied conditions.

// Active SSL
However, in real-world social settings, robots rarely remain stationary.
Their movement introduces new dimensions to the localization problem.
To address this, we extend our #acr("SSL") approach to dynamic scenarios, where motion is explicitly considered.
We propose a novel method for aggregating predictions from our static multi-source localizer over time.
This framework leverages the robot’s motion to refine its estimates of speaker positions.
To support this, we extend our simulator to synthesize complete trajectories in virtual environments, enabling effective training and evaluation of this dynamic localization model.

Having addressed perception, we then turn to action, the second pillar of robotic capability.
We explore how modern #acr("DRL") techniques can be applied to robot navigation, specifically to enhance auditory perception through movement.
Recent #acr("ASR") models enable robots to transcribe human speech with high accuracy, but their performance can degrade significantly in reverberant environments.
To mitigate this, we introduce a perceptually motivated navigation task in which a robot learns to position itself to minimize speech recognition errors.
The agent’s decisions are based solely on audio captured by its microphone array.
This final contribution builds directly upon our previous work in acoustic simulation and #acr("SSL"), integrating perception and action to advance embodied auditory intelligence.

*Keywords:*
deep learning,
robotic auditory perception,
sound source localization,
acoustic simulation,
robot navigation,
deep reinforcement learning,

// French abstract
= Résumé

La robotique sociale est un domaine de recherche vaste et multidisciplinaire, visant à concevoir des agents robotiques capables d'interagir efficacement.
Elle traite notamment des défis posés par les interactions homme-robot, où les robots ne sont plus confinés à des environnements isolés, mais évoluent aux côtés des humains dans des contextes dynamiques et complexes.
Ce domaine soulève de nombreux enjeux, notamment en perception multimodale et planification d'actions.
Cette thèse explore un ensemble de tâches essentielles à la conception de robots sociaux efficaces, avec un accent particulier sur leur dimension acoustique.
Plus précisément, nous étudions la localisation de sources sonores dans des contextes statiques et dynamiques, ainsi qu’une tâche de navigation robotique guidée par la perception auditive.

Pour cela, nous introduisons un environnement de simulation acoustique flexible et performant.
Il permet d'enregistrer virtuellement de signaux dans des pièces réverbérantes, en modélisant différentes configurations de microphones, de géométries de pièces et de sources sonores.
Basé sur des bibliothèques de synthèse sonore de pointe, cet environnement constitue un espace d'expérimentation riche pour l'apprentissage et l'évaluation de nouveaux algorithmes auditifs.
L'apprentissage profond a permis des avancées majeures en robotique, mais ces méthodes nécessitent de grandes quantités de données, souvent coûteuses ou difficiles à collecter dans des environnements physiques.
La simulation joue ainsi un rôle clé dans la génération de données à grande échelle.

Dans ce cadre virtuel, nous nous concentrons sur la perception auditive, considérée comme une capacité fondamentale.
Parmi ses composantes, la localisation de sources sonores est essentielle pour les robots sociaux.
Elle consiste à estimer la position d'un ou plusieurs locuteurs actifs, et repose sur une littérature scientifique riche et mature.
Nous abordons ce problème sous plusieurs angles et proposons une série de méthodes fondées sur l’apprentissage profond pour en relever les principaux défis.
Après une solution pour le cas à source unique, nous proposons un localisateur multi-sources plus avancé.
Les deux modèles sont rigoureusement évalués au moyen d’expériences approfondies dans des conditions variées.

Dans des contextes sociaux réels, les robots sont rarement immobiles.
Leur mouvement introduit de nouvelles particularités dans le problème de localisation.
Pour y répondre, nous étendons notre approche à des scénarios dynamiques, en tenant explicitement compte du déplacement du robot.
Nous proposons une méthode d’agrégation temporelle des prédictions issues du localisateur multi-sources.
Ce cadre exploite les déplacements du robot pour affiner les estimations de position des locuteurs.
Le simulateur a été étendu pour générer des trajectoires complètes dans des environnements virtuels, facilitant un apprentissage et une évaluation efficaces de nos algorithmes dans ce contexte dynamique.

Enfin, nous abordons l'action, second pilier des capacités robotiques.
Nous appliquons des techniques d’apprentissage par renforcement profond à la navigation, afin d'améliorer la perception auditive par le mouvement.
Les modèles récents de reconnaissance automatique de la parole permettent aux robots de transcrire la parole humaine avec précision, mais leurs performances peuvent se dégrader en présence de réverbération.
Pour y remédier, nous introduisons une tâche de navigation guidée par la perception auditive, dans laquelle le robot apprend à se positionner pour minimiser les erreurs de reconnaissance.
Les décisions de l'agent reposent uniquement sur les signaux audio captés par sa matrice de microphones.
Cette dernière contribution s'appuie sur nos travaux précédents en simulation acoustique et en localisation, intégrant perception et action pour faire progresser l'intelligence auditive embarquée.


*Mots-clés:*
apprentissage profond,
perception auditive en robotique,
localisation de sources sonores,
simulation acoustique,
navigation robotique,
apprentissage par renforcement profond.