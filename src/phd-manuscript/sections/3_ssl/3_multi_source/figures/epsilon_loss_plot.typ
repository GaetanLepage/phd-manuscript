#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.2": plot

#let d(x) = calc.pi - calc.abs(calc.abs(x) - calc.pi)
#let sigma_2 = calc.pow(
  (8 * calc.pi / 180),
  2,
)
#let gaussian(x, sigma_2) = calc.exp(
  -(calc.pow(d(x), 2) / sigma_2),
)
#let gt-func(x) = calc.max(
  gaussian(x + 0.2, sigma_2),
  gaussian(x + 2.2, sigma_2),
)
#let network(x) = (
  0.8
    * gaussian(
      x - (calc.pi / 2),
      2 * sigma_2,
    )
)

#cetz.canvas({
  import cetz.draw: *
  plot.plot(
    size: (10, 3),
    x-tick-step: none,
    x-ticks: ((-calc.pi, $-pi$), (0, $0$), (calc.pi, $pi$)),
    y-tick-step: 1,
    y-max: 1.2,
    y-label: $o(theta)$,
    x-label: $theta$,
    {
      plot.add(
        hypograph: true,
        style: (
          fill: rgb(0, 0, 200, 75),
          stroke: black,
        ),
        domain: (-calc.pi, calc.pi),
        gt-func,
        samples: 10000,
      )
      plot.add(
        hypograph: true,
        style: (
          fill: red,
          stroke: black,
        ),
        domain: (-calc.pi, calc.pi),
        network,
        samples: 10000,
      )
    },
  )
})

// #canvas(length: 1cm, {
//   plot.plot(size: (10, 3),
// })
