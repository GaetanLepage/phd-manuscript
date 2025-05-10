#import "/utils.typ": *
#import "../_variables.typ": *

// TODO (this is a copy-paste)

#let algo = algorithm({
  import algorithmic: *
  Function(
    "PPO",
    args: (
      todo,
    ),
    {
      // INPUTS
      Cmt[
        *delta-grid:*
        spatial resolution
      ]
      Cmt[
        *$bold((L_x, L_y))$:*
        dimensions of the room
      ]
      Cmt[
        *$bold(cal(D))$:*
        dataset of $n_"samples"$ clean speech samples
      ]
      Cmt[
        *directional (boolean):*
        whether the microphone is directional or omnidirectional
      ]
      State[]

      
      //Cmt[Initialize the agent positions]
      //Assign[$cal(Y)$][${j 2 mid(|) j in [|0, floor(L_y/2)|]}$]
      //State[]


      For(cond: $i "in" 1 dots #n-ppo-iter$, { // TODO check how to write this properly

        State[
          Initialize the network parameters $theta$ randomly.
        ]
        State[
          Collect a set of trajectories $#ppo-traj-buffer = {tau_k}$ by running policy $pi_theta$ in the environment.
        ]
        State[
          Compute rewards $hat(R)_t$
        ]
        State[
          Compute advantage estimates $hat(A)_t$ using #acr("GAE") based on the current value function $V_theta$.
        ]
      
        //Cmt[Collect trajectories]
        //Assign[#ppo-traj-buffer][[]]
        //Assign[$s_t$][#smallcaps[Reset-Environment()]]
        //For(
        //  cond: $t "in" 1 dots #n-ppo-steps$,
        //  {
        //    //Assign[$a_t$][#smallcaps[Sample]$(pi_theta (dot | s_t))$]
        //    State[$a_t ~ pi_theta (dot | s_t)$]
        //    Assign[
        //      $s_t, r_t$
        //    ][#smallcaps[Step-Environment$(a_t)$]]
        //    Assign[$V_t$][$V_(pi_theta)(s_t)$]
        //    Assign[
        //      $#ppo-traj-buffer [t]$
        //    ][
        //      $lr(
        //        (
        //          s_t,
        //          a_t,
        //          r_t,
        //          pi_theta (a_t | s_t),
        //          V_t
        //          //V_(pi_theta) (s_t)
        //        ),
        //        size: #120%
        //      )$
        //    ]
        //  }
        //)
        //State[]
        //Cmt[Compute advantages and returns]
        ////Assign[
        ////  $(hat(A)_t)_(t in (1 dots #n-ppo-steps))$
        ////][
        ////  GAE$(cal(B)$)
        ////]
        //State[
        //  ${hat(A)_t}_(t in (1 dots #n-ppo-steps))
        //  <-
        //  "GAE"(#ppo-traj-buffer)$
        //]
        //State[
        //  ${R_t}_(t in (1 dots #n-ppo-steps))
        //  <-
        //  {hat(A)_t + V_t}_(t in (1 dots #n-ppo-steps))$
        //]

        State[]
        Cmt[Optimize the actor and critic networks]
        For(
          cond: [$k "in" 1 dots #n-ppo-epochs$],
          {
            State[Split #ppo-traj-buffer in #n-ppo-minibatch]
            For(
              cond: $b subset #ppo-traj-buffer$,
              {
                State[
                  $#policy-ratio <- #policy-ratio-exp$
                ]
                State[]
                Assign[
                  #ppo-loss
                ][
                  $1/abs(b) sum_(t = 1)^abs(b)[
                    #todo
                  ]$
                ]
                Assign[$theta_"old"$][$theta$]
                Assign[
                  $theta$
                ][
                  #smallcaps[Optimize]
                  ($theta$, $nabla #ppo-loss$)
                ]
              }
            )
          }
        )
      })

      State[]
      
      Assign[$A$][$1/abs(cal(D)) B$]
      Return[C]
    }
  )
})

#figure(
  align(left)[#algo],
  kind: raw,
  caption: [
    #acr("PPO") algorithm
  ]
)
<algo:rl:ppo>