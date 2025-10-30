#import "../../../../../utils.typ": *
#import "../../../../../_misc/notations.typ": *

#subpar.grid(
  figure(
    image("doa_map_spectrum.svg", height: 3cm),
    caption: [
      #_doa spectrum $o_t$.
    ],
  ),
  <fig:active_ssl:methods:doa_map_spectrum>,

  figure(
    image("doa_map.svg", height: 5cm),
    //image("/assets/mountains.jpg"),
    caption: [
      Corresponding #_doa map $M_t$.
    ],
  ),
  //<fig:ssl:multi_source:sequence_processing:result>,
  columns: 1,
  caption: [
    Example of a #_doa map.
  ],
  align: top,
  placement: fig-placement,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  label: <fig:active_ssl:doa_map>,
)
