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

#let make_figure(caption_above: false, it) = {
  let body = {
    //set text(size: font.normal)
    // Caption (if above)
    if caption_above {
      v(1em, weak: true)  // Does not work at the block beginning.
      it.caption
    }

    // BODY
    v(1em, weak: true)
    it.body
    
    // Caption (if below)
    v(8pt, weak: true)  // Original 1em.
    if not caption_above {
      it.caption
      v(1em, weak: true)  // Does not work at the block ending.
    }
  }

  if it.placement == none {
    return body
  } else {
    return place(
      it.placement + center,
      body,
      float: true,
      clearance: 2.3em
    )
  }
}

#show figure: set block(breakable: false)

#show figure.where(kind: image): it => make_figure(it)
#show figure.where(kind: table): it => make_figure(it, caption_above: true)

// Table preferences
//#set table(align: left)
//#show table: set par(justify: false)
//#show figure.where(kind: table): it => {
//  let body = {
//    v(20pt, weak: true)  // Does not work at the block beginning.
//    it.caption
//    v(1em, weak: true)
//    it.body
//    v(20pt, weak: false)
//  }
//  return block(breakable: false)[
//    #body
//  ]
//}

#include "misc/acronyms.typ"
#set math.equation(numbering: "(1)")

// URL preferences
#show link: underline
#show link: set text(blue)

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
#gaet[How deep should the table of content go ?]

#include "misc/progress.typ"
// Figures table
#outline(
  title: "Table of figures",
  target: figure.where(kind: image)
)


// TODO
#print-index(numbering: none)
#include "sections/index.typ"
#include "misc/bibliography.typ"