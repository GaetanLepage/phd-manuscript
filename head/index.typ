#import "/utils.typ": gaet
#import "/_misc/acrostiche.typ": print-index

//#include "cover-page.typ"
//#pagebreak()
//#pagebreak()
//#include "head/dedication.typ"
#include "acknowledgements.typ"

// TODO
//#include "head/preface.typ"

#include "abstracts.typ"


#outline(
  title: "Contents",
  indent: auto,
  //depth: 2, // TODO
)
#outline(
  title: "List of Figures",
  target: figure.where(kind: image)
)
#outline(
  title: "List of Tables",
  target: figure.where(kind: table)
)
#outline(
  title: "List of Listings",
  target: figure.where(kind: raw)
)
#gaet[
  - Is this necessary ?
  - Is listing the correct word for those ?
]

// List of Acronyms
#print-index(
  title: "List of Acronyms",
  outlined: true,
  //numbering: none,
)