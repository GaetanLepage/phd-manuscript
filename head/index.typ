#import "/utils.typ": reset-acronym
#import "/_misc/acrostiche.typ": print-index

#include "cover_page/index.typ"

// Blank page after title
#pagebreak()

// Do not include abstracts and akwnoledgements in the ToC
#set heading(outlined: false)

#include "abstracts.typ"

#include "acknowledgements.typ"

#outline(
  title: "Contents",
  indent: auto,
  depth: 3,
)
#outline(
  title: "List of Figures",
  target: figure.where(kind: image)
)
#outline(
  title: "List of Tables",
  target: figure.where(kind: table)
)
//#outline(
//  title: "List of Equations",
//  target: math.equation
//)
//#outline(
//  title: "List of Listings",
//  target: figure.where(kind: raw)
//)

// List of Acronyms
#print-index(
  title: "List of Acronyms",
  outlined: false,
)