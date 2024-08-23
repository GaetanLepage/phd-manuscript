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
    ),
    {
      // INPUTS
      Cmt[
        #prev-maps:
        $H$ previous #acr("DoA") maps
      ]
      Cmt[
        #prev-deltas:
        $H$ previous relative movements.\
        #h(1em) $delta_t' = (d_t', theta_t')$ is the relative movement performed from $t'$ to $t' + 1$.
      ]
      State[]
      
      Cmt[Transpose all maps to current frame]
      For(
        cond: [$t'$ in $[|t-H, t|]$],
        {
          Cmt[Compute resulting displacement from past step $t'$ to current step $t$]
          Assign[
            $Delta_(t' -> t)$
          ][
            #smallcaps[Combine]$(delta_(t-H), dots, delta_(t' - 1))$
          ]
          Cmt[Project the #acr("DoA") map to the current robot frame]
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
        $MM_t$
      ][
        $Psi(tilde(M)_(t-H), dots, tilde(M)_(t-1))$
      ]
      
      State[]
      Cmt[Extract detections]
      Assign[
        $X = lr(
          [
            (x_1, y_1),
            dots,
            (x_K, y_K)
          ],
          size: #150%
        )$
      ][
        #smallcaps[Cluster]$(MM_t)$
      ]

      State[]
      Return[$X$]
    }
  )
})

#figure(
  align(left)[#algo],
  kind: raw,
  caption: [
    Active-#acr("SSL") algorithm
  ]
)
<algo:active_ssl:algo>