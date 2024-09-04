#import "_misc/template/_index.typ": template, front-matter, main-matter, back-matter
#import "/utils.typ": *

#show: template.with(author: "Gaétan Lepage")

#set page(numbering: none)

#include "_misc/acronyms.typ"


/*---------*/
/* CONTENT */
/*---------*/

#include "_misc/progress.typ"

// FRONT
#show: front-matter
#include "head/index.typ"

// MAIN
#show: main-matter
#include "sections/index.typ"

// TAIL
#show: back-matter
#include "tail/index.typ"