#import "/_misc/deps.typ"
#import deps.subpar
#import "/utils.typ": *
#import "../../_notations.typ": *

#subpar.grid(
  figure(
    image("doa_spectrum.svg", width: 80%),
    caption: [
      Averaged #_doa spectrum #averaged-spectrum.
    ],
  ),
  <fig:ssl:multi_source:sequence_processing:doa_spectrum>,

  figure(
    image("result.svg", width: 80%),
    //image("/assets/mountains.jpg"),
    caption: [
      Network output and extracted detections over time (top) and histogram of predictions (bottom).
    ],
  ),
  <fig:ssl:multi_source:sequence_processing:result>,

  columns: 1,
  caption: [
    Example of a sequence processing result.
  ],
  align: top,
  placement: fig-placement,
  gap: grid-fig-gap,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  label: <fig:ssl:multi_source:sequence_processing>,
)
