#import "_misc/template/_index.typ": back-matter, front-matter, main-matter, template
#import "/utils.typ": *

#show: template.with(
  title: "From Sound to Action: Deep Learning for Audio-Based Localization and Navigation in Robotics",
  author: "Gaétan Lepage",
  include-outlines-in-contents: false,
  boxed-refs: true,
  highlight-external-links: true,
)

#set page(numbering: none)

#include "_misc/acronyms.typ"


/*---------*/
/* CONTENT */
/*---------*/

// FRONT
#show: front-matter
#include "head/index.typ"

// MAIN
#show: main-matter
#include "sections/index.typ"

// TAIL
#show: back-matter
#include "tail/index.typ"
