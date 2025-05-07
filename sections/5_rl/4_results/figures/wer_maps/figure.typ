#import "/utils.typ": *

#subpar.grid(
  figure(
    image("wer_map_100ms.svg", width: 100%),
    caption: [
      $T_(60) = 100"ms"$
    ]
  ),
  <fig:rl:results:wer_maps_reverb:100>,
  
  figure(
    image("wer_map_300ms.svg", width: 100%),
    caption: [
      $T_(60) = 300"ms"$
    ]
  ),
  <fig:rl:results:wer_maps_reverb:300>,
  
  figure(
    image("wer_map_500ms.svg", width: 100%),
    //image("/assets/mountains.jpg"),
    caption: [
      $T_(60) = 500"ms"$
    ]
  ),
  <fig:rl:results:wer_maps_reverb:500>,
  
  figure(
    image("wer_map_800ms.svg", width: 100%),
    caption: [
      $T_(60) = 800"ms"$
    ]
  ),
  <fig:rl:results:wer_maps_reverb:800>,
  
  columns: 2,
  caption: [
    #acr("WER") cost maps for different reverberation levels.
    They were computed by averaging the #acr("WER") obtained for a selection of recorded sample at each position (see @algo:rl:wer_map).
  ],
  align: top,
  placement: fig-placement,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  gap: grid-fig-gap,
  label: <fig:rl:results:wer_maps_reverb>,
)