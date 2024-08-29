#import "/utils.typ": *

#subpar.grid(
  figure(
    image("doa_map_spectrum.svg", height: 3cm),
    caption: [
      #acr("DoA") spectrum $o_t$
    ]
  ),
  <fig:active_ssl:methods:doa_map_spectrum>,
  
  figure(
    image("doa_map.svg", height: 8cm),
    //image("/assets/mountains.jpg"),
    caption: [
      Corresponding DoA map $M_t$
    ]
  ),
  //<fig:ssl:multi_source:sequence_processing:result>,
  columns: 1,
  caption: [
    Example of a DoA map
  ],
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  label: <fig:active_ssl:doa_map>,
)