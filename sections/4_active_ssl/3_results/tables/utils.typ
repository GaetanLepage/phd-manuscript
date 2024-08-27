#import "/utils.typ": *

#let mk-header(text) = colspanx(2)[#align(center)[#text]]
#let header-pred-spectrum = mk-header[Estimated #acr("DoA") spectrum $hat(o)_t$]
#let header-gt-spectrum = mk-header[other]
//colspanx(2)[#align(center)[$o_t$]],