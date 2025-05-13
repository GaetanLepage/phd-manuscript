#import "/utils.typ": *
#import "../_variables.typ": *

#let angle-space = $Theta$
#let algo = algorithm({
  import algorithmic: *
  Function(
    "Compute-WER-Map",
    args: (
      delta-grid,
      $(#L-x, #L-y)$,
      //$n_"samples"$,
      $cal(D)$,
      "directional",
    ),
    {
      // INPUTS
      Cmt[
        *#delta-grid:*
        spatial resolution
      ]
      Cmt[
        *$bold((#L-x, #L-y))$:*
        dimensions of the room
      ]
      //Cmt[
      //  *$n_"samples"$:*
      //  number of speech samples to use at each position to compute the average #acr("WER")
      //]
      Cmt[
        *$bold(cal(D))$:*
        dataset of $n_"samples"$ clean speech samples and their associated transcripts
      ]
      Cmt[
        *directional (boolean):*
        whether the microphone is directional or omnidirectional
      ]
      State[]

      // ----------------------------------------------------------------------
      // Positions
      // ----------------------------------------------------------------------
      
      Cmt[Initialize the agent positions]
      // X
      Assign[$cal(X)$][${i #delta-grid mid(|) i in [|0, #n-x-exp|]}$]
      State[]
      // Y
      Assign[$cal(Y)$][${j #delta-grid mid(|) j in [|0, #n-y-exp|]}$]
      State[]

      If(cond: "directional", {
        // Θ <- {0, pi/2, pi, 3pi/2}
        Assign[#angle-space][${0, pi/2, pi, (3pi)/2}$]
        // Z <- X x Y x Θ
        Assign[$Z$][$cal(X) times cal(Y) colMath(times #angle-space, #maroon)$]
      })
      Else({
        // Z <- X x Y
        Assign[$Z$][$cal(X) times cal(Y)$]
      })
      
      State[]
      //Assign[#wer-map][$bold(0)_(cal(M)_(abs(cal(Z)))(RR))$]
      Cmt[Initialize the 2D/3D #acr("WER") map tensor]
      Assign[#wer-map][
        $bold(0)_(
          RR^(
            abs(cal(X)) times abs(cal(Y)) colMath(times abs(#angle-space), #maroon)
          )
        )$
      ]
      State[]
      
      // ----------------------------------------------------------------------
      // Loop
      // ----------------------------------------------------------------------
      
      Cmt[Loop through positions]
      For(cond: $z in cal(Z)$, {
        State[#smallcaps[Move-Microphone]$(z)$]
        State[]
        
        Cmt[Loop through speech samples]
        For(cond: $(x_i, t) in cal(D)$, {
          State[]
          Cmt[Call the simulator and get the received audio signal]
          Assign[$x_r$][#smallcaps[Simulate-Audio]$(x_i)$]
          State[]
          Cmt[Transcribe the recording]
          Assign[$hat(t)$][$#asr-net (x_r)$]

          Assign[$#wer-map [z]$][$#wer-map [z]$ + #smallcaps("WER")$(t, hat(t))$]
        })
      })

      State[]
      
      Assign[$#wer-map$][$1/abs(cal(D)) #wer-map$]
      Return[#wer-map]
    }
  )
})

#figure(
  align(left)[#algo],
  kind: raw,
  caption: [
    WER map computation algorithm.
  ]
)
<algo:rl:wer_map>