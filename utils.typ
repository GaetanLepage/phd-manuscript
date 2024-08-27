#import "@preview/minitoc:0.1.0": minitoc as _minitoc
#import "@preview/subpar:0.1.1"

#import "_misc/acrostiche.typ": *
#import "_misc/template/_index.typ": in-outline, fill-line
#import "_misc/notations.typ": *


// Different figure/table caption for ToC and actual caption
#let flex-caption(long, short) = context { if in-outline.get() { short } else { long } }

/* TABLES */
#import "@preview/tablex:0.0.8": tablex, colspanx, hlinex, rowspanx
#let toprule = hlinex(stroke: (thickness: 0.08em))
#let bottomrule = toprule
#let midrule = hlinex(stroke: (thickness: 0.05em))

// Common headers
#let header-mae = [MAE (°) #sym.arrow.b]
#let header-acc = [Accuracy (%) #sym.arrow.t]
#let header-prec = [Precision (%) #sym.arrow.t]
#let header-recall = [Recall (%) #sym.arrow.t]

/* ALGORITHMS */
//#import "@preview/algorithmic:0.1.0"
#import "/_misc/algorithmic.typ"
#import algorithmic: algorithm

/* MATHS */
#let colMath(x, color) = text(fill: color)[$#x$]
#let mabs = math.abs.with(size: 130%)
#let func-def(
  symbol,
  from,
  to,
  input,
  output,
) = $
   #symbol: && from & --> #to\
     
   && input & arrow.r.long.bar  output
$

/* FIGURES */
// Numbering
#let fig-numbering = fig_num => {
  let chap_num =  counter(heading).get().first()
  
  numbering(
    "1.1",
    chap_num,
    fig_num
  )
}
#let fig-numbering-sub-ref = (super_num, sub_num) => {
  let chap_num =  counter(heading).get().first()
  
  numbering(
    "1.1a",
    chap_num,
    super_num,
    sub_num
  )
}
// Grid figures
#let grid-fig-gap = 3em

#let clorem(words) = text(maroon, lorem(words))
#let shape(x, y, z) = $(#str(x), #str(y), #str(z))$

/* COMMENTING */
#let show-comments = true
//#let show-comments = false

#let minitoc(indent: true) = {
  if show-comments {
    _minitoc(indent: indent)
  } else {
    ""
  }
}
}
#let togglable(body) = {
  if show-comments { body } else { "" }
}
#let draft(body) = {
  set text(fill: maroon)
  togglable[_#body _]
}
#let todo = draft[TODO]

#let comment(name, body, color: red) = {
  set text(color)
  togglable[\ *>>> #name:* #body\ ]
}

#let chris(body) = {
  comment("Chris", body, color: red)
}
#let laurent(body) = {
  comment("Laurent", body, color: green)
}
#let xavi(body) = {
  comment("Xavi", body, color: orange)
}
#let gaet(body) = {
  comment("Gaétan", body, color: blue)
}