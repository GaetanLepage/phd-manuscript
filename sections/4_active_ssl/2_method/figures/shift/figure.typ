#import "/utils.typ": *

#subpar.grid(
  figure(
    image(
      "traj_map_step_02.svg",
      width: 5cm,
    ),
    caption: [
      Local #acr("DoA") map $M_t$, expressed in $cal(F)_t$
    ]
  ),
  figure(
    image(
      "traj_shifted_map_step_02.svg",
      width: 5cm,
    ),
    caption: [
      Same map shifted to $cal(F)_t'$
    ]
  ),
  columns: (1fr, 1fr,),
  align: top,

  // TODO: I have manually put this one at the bottom because there were 3 figures on the same page and it was not looking that good.
  //placement: fig-placement,
  placement: bottom,
  
  numbering: fig-numbering,
  numbering-sub-ref: fig-numbering-sub-ref,
  caption: [Shifting process for local #acr("DoA") maps],
  label: <fig:active_ssl:method:shift>,
)