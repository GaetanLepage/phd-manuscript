#import "/utils.typ": *
#import "../_notations.typ": *

#let prev-maps = $[
  M_(t-H),
  dots,
  M_(t-1)
]$
#let prev-deltas = $[
  delta_(t-H),
  dots,
  delta_(t-1)
]$


#let algo = algorithm({
  import algorithmic: *
  Function(
    "Active-SSL",
    args: (
      prev-maps,
      prev-deltas,
      $"STFT"_t$
    ),
    {
      // INPUTS
      Cmt[
        #prev-maps:
        $H$ previous #doa maps
      ]
      Cmt[
        #prev-deltas:
        $H$ previous relative movements.\
        //#h(1em) $delta_t' = (d_t', theta_t')$ is the relative movement performed from $t'$ to $t' + 1$.
      ]
      Cmt[
        $"STFT"_t$:
        The #acr("STFT") of the multi-channel audio received by the microphone array.
      ]
      State[]

      
      Cmt[Run the static #acr("SSL") model on the current received audio]
      Assign[$o_t$][#smallcaps[SSL]$("STFT"_t)$]
      Cmt[Compute the #doa map from the spectrum]
      Assign[$M_t$][#smallcaps[DoA-map]$(o_t)$]
      State[]
      
      Cmt[Transpose all maps to the current frame]
      For(
        cond: [$t'$ in $[|t-H, t|]$],
        {
          Cmt[Compute resulting displacement from past step $t'$ to current step $t$]
          Assign[
            $Delta_(t' -> t)$
          ][
            #smallcaps[Combine]$(delta_(t-H), dots, delta_(t' - 1))$
          ]
          Cmt[Project the #doa map to the current robot frame]
          Assign[
            $tilde(M)_t'$
          ][
            #smallcaps[Shift]$(M_t', Delta_(t' -> t))$
          ]
        }
      )

      State[]
      Cmt[Aggregate all shifted maps]
      Assign[
        #AM
      ][
        $Psi(tilde(M)_(t-H), dots, tilde(M)_(t-1))$
      ]
      
      State[]
      Cmt[Extract detections]
      Assign[
        $predictions = lr(
          [
            (x_1, y_1),
            dots,
            (x_K, y_K)
          ],
          size: #150%
        )$
      ][
        #smallcaps[Cluster]$(#AM)$
      ]

      State[]
      Return[#predictions]
    }
  )
})

#figure(
  align(left)[#algo],
  kind: raw,
  caption: [
    Active-SSL algorithm.
  ]
)
<algo:active_ssl:algo>