#import "/utils.typ": *
#import "../_variables.typ": *

#set text(size: 11pt)

#let algo = algorithm({
  import algorithmic: *
  Function(
    "PPO",
    args: (
      n-ppo-iter,
      n-ppo-epochs,
      ppo-mini-batch-size,
    ),
    {
      // INPUTS
      Cmt[
        *#n-ppo-iter:*
        The number of #acr("PPO") iterations
      ]
      Cmt[
        *#n-ppo-epochs:*
        The number of training epochs done in each iteration
      ]
      Cmt[
        *#ppo-mini-batch-size:*
        The number of samples (transitions)
      ]
      State[]

      For(cond: $i "in" 1 dots #n-ppo-iter$, {

        State[
          Initialize the network parameters $theta$ randomly.
        ]
        State[
          Collect a set of trajectories $#ppo-traj-buffer = {tau_k}$ by running policy $pi_theta$ in the environment.
        ]
        State[
          Compute advantage estimates $hat(A)_t$ using #acr("GAE") based on the current value function $V_theta$.
        ]
        State[
          Compute returns $hat(R)_t = V_(pi_theta)(s_t) - hat(A)_t$
        ]

        State[]
        Cmt[Optimize the actor and critic networks]
        State[
          Split #ppo-traj-buffer in mini-batches of #ppo-mini-batch-size transitions each.
        ]
        For(
          cond: [$k "in" 1 dots #n-ppo-epochs$],
          {
            For(
              cond: [
                each mini-batch in #ppo-traj-buffer
              ],
              {
                State[
                  Update the actor's and critic's parameters by maximizing the #acr("PPO") objective $#ppo-loss (theta)$ using a stochastic optimizer (e.g. Adam, #acr("SGD")).
                ]
              }
            )
          }
        )
      })

      State[]
      
      Return[#pi-theta]
    }
  )
})

#figure(
  align(left)[#algo],
  kind: raw,
  caption: flex-caption(
    short: [
      Simplified #acr("PPO") algorithm.
    ],
    long: [
      Simplified #acr("PPO") algorithm.
      It iterates between a data sampling phase where trajectories are collected by running the agent in the environment, and a learning phase where the neural network is optimized according to the #acr("PPO") objective #ppo-loss.
    ],
  ),
)
<algo:rl:ppo>