#import "@preview/acrostiche:0.3.2": *
#import "@preview/minitoc:0.1.0": *
#import "@preview/subpar:0.1.1"

/* TABLES */
#import "@preview/tablex:0.0.8": tablex, colspanx, hlinex
#let toprule = hlinex(stroke: (thickness: 0.08em))
#let bottomrule = toprule
#let midrule = hlinex(stroke: (thickness: 0.05em))

/* ALGORITHMS */
#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

/* MATHS */
#let colMath(x, color) = text(fill: color)[$#x$]
#let mabs = math.abs.with(size: 130%)

/* CAPTIONS */
#let in-outline = state("in-outline", false)
#let flex-caption(long, short) = context if in-outline.get() { short } else { long }

/* FIGURES numbering */
#let fig-numbering = fig_num => {
  let chap_num =  counter(heading).get().first()
  
  numbering("1.1", chap_num, fig_num)
}

#let clorem(words) = text(maroon, lorem(words))
#let shape(x, y, z) = $(#str(x), #str(y), #str(z))$

/* COMMENTING */
#let draft(body) = {
  set text(fill: maroon)
  [_#body _]
}

#let comment(name, body, color: red) = {
  set text(color)
  [\ *>>> #name:* #body\ ]
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