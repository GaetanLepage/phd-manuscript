#import "/utils.typ": *

#subpar.grid(
  figure(
    image("doa_map_spectrum.svg", height: 3cm),
    caption: [
      DoA spectrum
    ]
  ),
  <fig:active_ssl:methods:doa_map_spectrum>,
  
  figure(
    image("doa_map.svg", height: 8cm),
    //image("/assets/mountains.jpg"),
    caption: [
      Corresponding DoA map
    ]
  ),
  //<fig:ssl:multi_source:sequence_processing:result>,
  columns: 1,
  caption: [
    Example of a DoA map
  ],
  numbering: fig-numbering,
  label: <fig:active_ssl:doa_map>,
)