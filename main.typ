#import "misc/template.typ": *
#import "/utils.typ": *

#show: project.with(
  // TODO, this is a more accurate title
  title: "Deep Learning for Dynamic Acoustic Robot Interactions",
  authors: (
    (name: "Gaétan Lepage", affiliation: "RobotLearn Team, Inria Grenoble Alpes"),
  ),
  // date: "March 27, 2024",
)

#include "misc/acronyms.typ"
#set math.equation(numbering: "(1)")

#outline(title: "Table of Contents", indent: true, depth: 2)

#include "misc/planning.typ"

// TODO
#print-index(numbering: none)
#include "sections/index.typ"
#include "bibliography/main.typ"