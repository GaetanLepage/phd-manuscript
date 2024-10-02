#import "/utils.typ": *

#subpar.grid(
  figure(
    image("mic_array_binaural.svg", width: 100%),
    caption: [
      Binaural array
    ]
  ),
  <fig:rl:results:wer_maps_reverb:100>,
  
  figure(
    image("mic_array_triangle.svg", width: 100%),
    caption: [
      Triangle array
    ]
  ),
  <fig:rl:results:wer_maps_reverb:300>,
  
  figure(
    image("mic_array_square.svg", width: 100%),
    //image("/assets/mountains.jpg"),
    caption: [
      Square array
    ]
  ),
  <fig:rl:results:wer_maps_reverb:500>,
  columns: 2,
  caption: [
    #acr("WER") maps for different reverberation levels
  ],
  align: top,
  placement: fig-placement,
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  gap: grid-fig-gap,
  label: <fig:rl:results:wer_maps_reverb>,
)