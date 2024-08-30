#import "/utils.typ": *
#import "../_notations.typ": *
#import "../../3_ssl/3_multi_source/_notations.typ": xi-doa

== Experiments and results
<sec:active_ssl:results>

#minitoc(indent: true)

This section summarizes the main experiments conducted to assess the performance of the proposed solution for #acr("ASSL").



=== Metrics

Overall, the goal of the #acr("ASSL") task as defined in this chapter consists in extracting sound sources positions after $H$ arbitrary steps in the environment.
The actual detection is performed at step $H$ where the method outputs a list of coordinates relative to the robot's position.
In this aspect, the #acr("ASSL") problem corresponds to a single-class detection task.
Precision and recall hence come as natural metrics to evaluate our method's performance.

Although, in this case, bounding boxes are not expected as only the sources positions should be provided.
An acceptable range of $delta$ meters defines a criteria for a correct detection.
For a detection to be considered valid, its estimated position needs to be closer than $delta$ meters from the ground truth.
A positive match is characterized by the following function:
#let dist = $norm(hat(X)_(i k) - X_(i k))_2$
$
  m(
    hat(X)_(i k),
    X_(i j)
  ) = cases(
    1
      &"if"
        #dist < delta\
        &"and" k = limits("argmin")_(k in {1, dots, hat(z_i)}) #dist,
    0 "otherwise"
  )
$
where $hat(X)_(i k) = (hat(x)_(i k), hat(y)_(i k))$ is the estimated position of the $j$-th detected source in sample $i$ and $X_(i k)$ is the ground truth position of the $k$-th real source in this sample.
$z_i$ denotes the number of real sources in sample $i$ while $hat(z)_i$ is the number of detections.
_Precision_ and _recall_ definitions remain the same as for the previously introduced static #acr("SSL") task:
$
  "Precision" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(phi.alt)_(i k),
      phi.alt_(i j)
    )
  ) / (sum_i hat(z)_i)
$
<eq:ssl:multi_source:prec>

$
  "Recall" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(phi.alt)_(i k),
      phi.alt_(i j)
    )
  ) / (sum_i z_i)
$
<eq:ssl:multi_source:recall>


=== Dataset collection
<sec:active_ssl:results:dataset>

In order to design, run and evaluate our method on the #acr("ASSL") task, the simulator is used to generate a synthetic dataset.
Specifically, we leverage the ability of our simulator to model _dynamic_ discrete-time environments (see @sec:simulator:simulator:features:dynamic_scenarios).
The latter consists in a repository of independent $H$-steps trajectories.

*Acoustic objects and movement policy.*
First, a random number of speech sources $z_i$ is sampled uniformly between one and four.
Those $z_i$ sources get randomly positioned in the reverberant room.
The reverberation time $T_60$ has been set to 0.5s and the room measures $4 times 7$ meters.
We pick a random starting side (top, bottom, left or right) and randomly place the agent equipped with a four-microphone array in a 50cm strip along the corresponding wall.
The agent aims at a random direction, yet ensuring that it turns its back to the wall it starts against.
The range of possible initial orientations can be observed on @fig:active_ssl:results:dataset_init.

#include "figures/dataset_setup/figure.typ"

Regarding the movement policy, at each step, the new orientation $theta_t+1$ of the agent is sampled from the following normal distribution of mean $theta_t$ and variance $sigma_theta^2$:
$
  theta_(t+1) tilde cal(N)(theta_t, sigma_theta^2)
$
In practice, we use a value of radians for $sigma_theta$.
The agent then moves forward in this new direction by a distance of 50cm.

When the robot happens to be less than 50cm from a wall, the orientation is instead sampled according to the initialization process so as to turn its back to this wall.

*Data gathering.*
The collected datasets will find two distinct uses: the evaluation of the global #acr("ASSL") pipeline as well as the training of the #psi-dnn combination operator.
Hence, exhaustive geometric and acoustic data is gathered.
For each step, the audio signal received by the agent is fed to the #acr("SSL") network so as to collect the estimated #doa spectrum $hat(o)_t$.
The oracle spectrum $o_t$ also gets saved for further comparisons.
Also, the absolute positions of the agent as well as the relative sources locations are saved at every step.
Finally, the relative movements performed by the robot are recorded in order to later perform the map shifting operation.
Local #doa maps do not get generated yet but all the necessary information for their creation is made available.
This choice allows for experimenting with the relevant hyperparameters such as the #fov $L$ and pixel resolution $p$.

#draft[
  Insist about the difficulty of certain samples:
  - Very close sources
  - straight trajectories with source aligned with the trajectory (no real triangulation possible)
]


=== Impact of the upstream #acr("SSL") model
<sec:active_ssl:results:impact_of_ssl_model>

The upstream static #acr("SSL") model features as a core part of the #acr("ASSL") pipeline.
The quality of #doa spectra it provides plays a significant impact role in the final performance of the method.

#include "tables/ssl_model.typ"

#todo


The upstream static #acr("SSL") model used to infer the #doa spectrum at each step plays a significant role in the final performance.
Hence, to isolate the behavior of the #acr("ASSL") method itself, two scenarios are compared.
On the one hand, the neural network implemented and trained in @sec:ssl:multi_source predicts the #doa spectra $hat(o)_t$ from the listened audio.
This scenario is the more realistic and unites all the developed blocks into a single end-to-end pipeline.
On the other hand, the #acr("ASSL") framework is also evaluated directly using the ground truth spectra $o_t$ at each step.
Here, the potential of our method can be explored under ideal conditions.

// TODO: image of prediction VS GT spectrum

// Basically, gap caused by detections going missing.
// -> Final map value at intersection is lower
// Also, peaks in the sptrum are often lower than 1.0 and thus also contribute to lower values in the likelihood map.


=== Comparison of blending methods
<sec:active_ssl:results:blending_methods>

Two alternatives have been compared for the map blending operation: naive averaging $Psi_"avg"$ and learnt #psi-dnn (see @sec:active_ssl:methods:blending_methods).
The former was introduced as a baseline, offering an explainable advantage while the second aims at offering the best performance.

#include "figures/blending_comparison/figure.typ"

Qualitatively,

// NN rightfully infers the presence of a source in the front, but predicts an inacurrate distance leading to missing the detection in the end.

=== Performance optimization

Both the #acr("ASSL") task and the proposed method admit variants and parameters.
In this section, an in-depth exploration of certain settings is conducted.

// Ablation studies / sensitivity analysis

==== #doa spectrum amplification

As seen in @sec:active_ssl:results:impact_of_ssl_model, the #acr("ASSL") process works significantly better when provided with the ground truth #doa spectra instead of using the pre-trained #acr("SSL") model.
One of the reasons leading to poorer performance lies in the peaks present in those heatmaps being lower.
This does not necessarily impact static the #acr("SSL") metrics as any local maximum above the detection threshold #xi-doa would be counted as a #doa prediction (see @sec:ssl:multi_source:method:detection_decoding).
However, this threshold does not intervene in the #acr("ASSL") pipeline and the #doa spectrum is directly converted into a 2D #doa map.
When using the deep neural network #psi-dnn for combining the maps, the output is normalized to the $[0, 1]$ range.
Although this would help amplifying too dim localization heatmaps, it cannot compensate for a relative differences coming from uneven peaks in the #doa spectra.

To account for this phenomenon we introduce the #doa amplification trick.
Its concept remains simple as it solely consists in clipping all the portions of a #doa spectrum that are higher than a given threshold #doa-t to one.
As such, a #doa spectrum $hat(o)$ is transformed in the following way:
$
  hat(o)' = max(hat(o), bb(1)_(hat(o) > #doa-t))
$

@fig:active_ssl:results:doa_spectrum_amplif displays the amplification behavior on an arbitrary example.

#include "figures/doa_spectrum_amplif/figure.typ"


In @fig:active_ssl:results:doa_spectrum_amplif_maps, one can see the consequence of this process on the #doa maps.
Each row corresponds to a different value for threshold.
Qualitatively, a too high #doa-t will lead to lower peaks being left unamplified.
However, decreasing this parameter causes larger, oversaturated cones that loose their localization information.

#figure(
  image(
    "figures/doa_spectrum_amplif_maps.svg",
    width: 80%,
  ),
  caption: [
    Effect of #doa spectrum amplification on the local maps
  ],
)
<fig:active_ssl:results:doa_spectrum_amplif_maps>

#include "tables/doa_threshold.typ"

#draft[
  TODO: add quantitative study + analysis
]


==== Likelihood cutoff

In order to feed the aggregated heatmaps to the clustering algorithm, it is first needed to extract a set of points from the 2D map.
DBSCAN does not take the pixel values into account for building its clusters and only relies on the distance between two provided points.
The set of filtered coordinates should thus be carefully chosen.

We adopt a simple thresholding approach that consists in selecting all points which value is greater than a given target #clip-t.
This parameter should be high enough to let the clusters surface.
If too low, the resulting point cloud ends up fully connected leading to DBSCAN finding a single cluster.
Conversely, increasing #clip-t too significantly will result in local peaks being completely filtered out which would produce a missed detection.

@fig:active_ssl:results:clipping_threshold shows a given aggregated map after having been filtered with different values of #clip-t.
The top row depicts the map obtained from the averaging aggregation (#psi-avg) while the bottom one exposes the output of the neural network (#psi-dnn).
In this example, both blending strategies have provided a solid result which are not particularly challenging to cluster.
While the neural network was able to directly yield distinct blobs, the obtained averaged map shows to be more impacted by the thresholding.
Indeed, too low values of #clip-t do not manage to disconnect the various clusters and would link to a single prediction from the detection pipeline.
On the contrary, the network output suffers from too aggressive filtering as the blob with the lowest intensity eventually disappears for $#clip-t >= 0.8$.

#gaet[
  Maybe PR curves will be more visual for illustrating this.
  Also, if we keep a table, do we include more values of $delta_min$ ? I feel like we can miss the trend/evolution of the perf with a too wide grid.
]


#figure(
  image(
    "figures/clipping_threshold.svg",
  ),
  caption: [
    Effect of the clipping threshold on the aggregated maps
  ],
)
<fig:active_ssl:results:clipping_threshold>

@table:active_ssl:results:clipping_threshold gathers the result of an experimental campaign on the impact of this parameter on the final #acr("ASSL") performance.
#draft[
  TODO analyze results
]

#include "tables/clipping_threshold.typ"

Finally, another factor might be brought into consideration: computational cost.
DBSCAN's time complexity is $O(n log n)$ when the data layout is favorable and $O(n^2)$ in the worst-case @ester_density-based_1996 ($n$ denotes the number of points).
In the use made of this algorithm here, the number of provided points is highly impacted by the choice of #clip-t.
More precisely, the case where $#clip-t = 0$ leads to a very high number of points included in the final 

The value of $#clip-t = 0$ is not tested.
This case indeed often translates in none of the pixels getting filtered.
For a resolution of $p=256$, the number of points forwarded to DBSCAN amounts to $p^2 = 65,536$.
Also, the algorithm output consists in a single cluster containing all points.
@fig:active_ssl:results:n_points_cluster plots the number of points remaining after the filtering process.
Blue lines correspond to using the naive averaging strategy to aggregate the maps and orange lines relate to the use of the neural network.
Also, dashed plots allow to differentiate which #doa spectra have been employed from the start.
#draft[
  Deepen the analysis ?
]

#figure(
  image(
    "figures/n_points_cluster.svg",
    width: 80%,
  ),
  caption: [
    Number of points remaining after the filtering operation with respect to #clip-t
  ]
)
<fig:active_ssl:results:n_points_cluster>



#draft[
  Show the importance of the clipping threshold:
  - PR curve
  - Qualitative comparison
]

==== Visual encoding

The choice to model the 2D localization problem with heatmaps involves exploring hyperparameters related to this visual encoding.
As #doa maps are generated from the projection of #doa spectra, we are free to define the output domain without prior constraints.
Two parameters influence the synthetised maps: the #fov $L$ and the pixel resolution $p$.

*Field of View.*
The #fov ($L$) determines how wide is the range covered by the egocentric map.
The latter is a $L times L$ square centered around the robot agent.

Its value must be chosen diligently as it bounds the information available once the shifting and aggregation have occurred at the final position.
One has to consider the maximum distance $d_"max"$ travelled by the robot at each step and the horizon $H$.
If the characteristic value $H times d_"max"$ significantly overpasses $L/2$, information from the oldest steps might be at least partly out of scope and thus useless.
In practice, there are no strong reason to keep $L$ small and choosing it greater than the dimensions of the room ensures to capture most available knowledge in the shifted maps $tilde(M)_t'$.
#draft[
  Well, a small $L$ could make smaller details "bigger" and help with the detection.
  Let us see what the experiments give.
]

#include "tables/fov.typ"

*Pixel resolution.*
As opposed to the #fov, pixel resolution stands solely as a representation hyperparameter and does not fundamentally change the informative content of the maps.
Naturally, a higher resolution would limit any loss caused by the spatial discretization process.
We have noticed during our experiments that when using too low resolutions, imprecisions would arise within the map shifting process.
In fact, the latter consists in a 

#include "tables/pixel_res.typ"