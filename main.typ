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

// Table preferences
#set table(align: left)
#show table: set par(justify: false)

#include "misc/acronyms.typ"
#set math.equation(numbering: "(1)")

#show outline: it => {
  in-outline.update(true)
  // This hides the citation in outlines (mostly for the table of figures)
  show cite: none
  it
  in-outline.update(false)
}
#outline(
  title: "Table of Contents",
  indent: true,
  depth: 2
)

#include "misc/planning.typ"
// Figures table
#outline(
  title: "Table of figures",
  target: figure.where(kind: image)
)


// TODO
#print-index(numbering: none)
#include "sections/index.typ"
#include "bibliography/main.typ"