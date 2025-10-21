#import "/utils.typ": *
#import "../../_notations.typ": *

#subpar.grid(
  figure(
    image("train.svg", width: 120%),
    caption: [
      Training loss.
    ],
  ),
  <fig:ssl:single_source:input_features:train>,

  figure(
    image("validation.svg", width: 120%),
    caption: [
      Validation loss.
    ],
  ),
  <fig:ssl:single_source:input_features:validation>,

  columns: 2,
  caption: flex-caption(
    short: [
      Evolution of the training and validation #_doa loss #l-doa-raw for different input features.
    ],
    long: [
      Evolution of the training and validation #_doa loss #l-doa for different input features.
    ],
  ),
  placement: fig-placement,
  align: top,
  gap: grid-fig-gap,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  label: <fig:ssl:single_source:input_features>,
)
