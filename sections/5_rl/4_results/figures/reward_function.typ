#import "@preview/cetz:0.3.2"
#import "@preview/cetz-plot:0.1.1": plot
#import "../../_notations.typ": *
#import "/utils.typ": *

#let reward(x) = reward-alpha-value * calc.exp(- reward-beta-value * x)

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
        y-tick-step: reward-alpha-value / 5,
        y-max: reward-alpha-value,
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
      Plot of the main reward component $#reward-exp-alpha exp[-#reward-exp-beta #cost-t]$ as a function of the cost #cost-t.
    ],
  ),
)
<fig:rl:results:reward>