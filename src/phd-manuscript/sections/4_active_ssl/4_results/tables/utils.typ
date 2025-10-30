#import "../../../../utils.typ": *

#let mk-header(text) = table.cell(colspan: 2)[#align(center)[#text]]
#let header-pred-spectrum = mk-header[Estimated #doa spectrum $hat(o)_t$]
#let header-gt-spectrum = mk-header[Ground truth #doa spectrum $o_t$]
//colspanx(2)[#align(center)[$o_t$]],
