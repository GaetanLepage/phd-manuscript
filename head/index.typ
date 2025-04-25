#import "/utils.typ": gaet, draft
#import "/_misc/acrostiche.typ": print-index

#include "cover_page/index.typ"

#include "abstracts.typ"

#include "acknowledgements.typ"

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
#draft[
  List of equations?
]
//#outline(
//  title: "List of Listings",
//  target: figure.where(kind: raw)
//)

// List of Acronyms
#print-index(
  title: "List of Acronyms",
  outlined: true,
  //numbering: none,
)