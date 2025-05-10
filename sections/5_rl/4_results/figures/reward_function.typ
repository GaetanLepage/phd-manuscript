#import "@preview/cetz:0.3.2"
#import "@preview/cetz-plot:0.1.1": plot
#import "../../_variables.typ": *
#import "/utils.typ": *

#let reward(x) = reward-alpha-value * calc.exp(- reward-beta-value * x)

#let y-max = reward-alpha-value + 2
#figure(
  cetz.canvas(
    {
      import cetz.draw: *
      plot.plot(
        size: (14, 4),
        //x-tick-step: none,
        //x-ticks: ((0, 1), (0, $0$), (calc.pi, $pi$)),
        x-min: 0,
        x-max: 1.0,
        y-tick-step: 20,
        y-max: y-max,
        y-label: $f(#cost-t)$,
        x-label: cost-t,
        {
          plot.add(
            style: (
              stroke: blue,
            ),
            domain: (-calc.pi, calc.pi),
            reward,
            samples: 1000,
          )
        }
      )
    }
  ),
  caption: flex-caption(
    short: [
      Plot of the main reward component as a function of the cost #cost-t.
    ],
    long: [
      Plot of the main reward component #f-reward-exp as a function of the cost #cost-t.
    ],
  ),
)
<fig:rl:results:reward>