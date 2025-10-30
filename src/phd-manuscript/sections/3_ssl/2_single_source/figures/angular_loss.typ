#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.2": plot
#import "../_notations.typ": l-color, l-doa
#import "../../../../utils.typ": *

#let offset = 3 * calc.pi / 4

#let loss(x) = 1.0 - calc.cos(x)
#let loss-offset(x) = (
  1.0
    - (
      calc.cos(offset) * calc.cos(x) + calc.sin(offset) * calc.sin(x)
    )
)

#figure(
  cetz.canvas({
    import cetz.draw: *
    plot.plot(
      size: (14, 4),
      x-tick-step: none,
      x-ticks: ((-calc.pi, $-pi$), (0, $0$), (calc.pi, $pi$)),
      y-tick-step: 1,
      y-max: 2.1,
      y-label: $#l-doa (theta, hat(theta))$,
      x-label: $theta$,
      {
        plot.add(
          style: (
            stroke: blue,
          ),
          domain: (-calc.pi, calc.pi),
          loss,
          samples: 1000,
        )
        plot.add(
          style: (
            stroke: green,
          ),
          domain: (-calc.pi, calc.pi),
          loss-offset,
          samples: 1000,
        )
      },
    )
  }),
  caption: flex-caption(
    short: [
      Plot of the angular loss.
    ],
    long: [
      Angular loss plots for $colMath(hat(theta)=0, #blue)$ and $colMath(hat(theta)=(3pi) / 4, #green)$.
      The x axis corresponds to the predicted #doa value $hat(theta)$.
    ],
  ),
)
<fig:ssl:single_source:angular_loss>
