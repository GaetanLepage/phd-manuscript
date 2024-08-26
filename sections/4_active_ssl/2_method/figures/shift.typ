#import "/utils.typ": *

#subpar.grid(
  figure(
    image(
      "traj_map_step_02.svg",
      width: 70%,
    ),
    caption: [
      Local #acr("DoA") map $M_t$, expressed in $cal(F)_t$
    ]
  ),
  figure(
    image(
      "traj_shifted_map_step_02.svg",
      width: 70%,
    ),
    caption: [
      Same map shifted to $cal(F)_t'$
    ]
  ),
  columns: (1fr, 1fr,),
  align: top,
  numbering: fig-numbering,
  caption: [Shifting process for local #acr("DoA") maps],
  label: <fig:active_ssl:method:shift>,
)