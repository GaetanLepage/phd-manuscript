#import "/utils.typ": print-index

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
  indent: true,
  //depth: 2,
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

// List of Acronyms
#print-index(
  title: "List of Acronyms",
  outlined: true,
  numbering: none,
)