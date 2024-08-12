#page(
  numbering: none,
  margin: (y: 6cm),
  {
    set text(font: "Latin Modern Sans")

    align(
      center,
      [
        #let v-skip = v(1em, weak: true)
        #let v-space = v(2em, weak: true)

        #text(size: 18pt)[
          Deep Probabilistic Reinforcement Learning\
          for Audio-Visual Human-Robot Interaction.
        ]

        #v-space

        #text(fill: gray)[
          THIS IS A TEMPORARY TITLE PAGE
        ]

        #v-space

        #v(1fr)

        #grid(
          columns: (1fr, 60%),
          align(horizon, image("logo_uga.svg", width: 75%)),
          align(left)[
            Thèse n. 1234 2011\
            présentée le XX décembre 2024\
            à la Faculté des Sciences de Base\
            laboratoire SuperScience\
            programme doctoral en SuperScience\
            Université Grenoble Alpes\
            #v-skip
            pour l’obtention du grade de Docteur ès Sciences\
            par\
            #h(2cm) Gaétan Lepage\
            #v-space
            acceptée sur proposition du jury:\
            #v-skip
            Prof Name Surname, président du jury\
            Dr. Xavier Alameda-Pineda, directeur de thèse\
            Pr. Laurent Girin, co-directeur de thèse\
            Dr. Chris Reinke, co-encadrant de thèse\
            Prof Name Surname, rapporteur\
            Prof Name Surname, rapporteur\
            Prof Name Surname, rapporteur
            #v-space
            Grenoble, UGA, 2024
          ],
        )
      ],
    )
  },
)
