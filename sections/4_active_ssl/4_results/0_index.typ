#import "/utils.typ": *
#import "../_notations.typ": *
#import "../../3_ssl/3_multi_source/_notations.typ": xi-doa

== Experiments
<sec:active_ssl:results>

This section presents the main experiments conducted to assess the proposed solution's performance for #acr("ASSL").



=== Metrics

Overall, for our agent, the goal of the #acr("ASSL") task, as defined in this chapter, is to extract the sound sources' positions after $H$ arbitrary steps in the environment.
The detection is only performed at step $H$, where the method outputs a list of coordinates relative to the robot's position.
In this aspect, the #acr("ASSL") problem can be compared to the object detection task in computer vision @zou_object_2023.
This problem involves finding the classes, positions, and sizes of semantic objects present in an image.
In our formulation, only the position of the sources should be inferred.
Bounding boxes and classes are not expected.
Yet, object detection's precision and recall are natural metrics that can be adapted to evaluate our method's performance.
A detection is considered correct if it falls within a $delta$-meter radius of the ground truth.
For a detection to be considered valid, its estimated position must be closer than $delta$ meters from the ground truth.
The following function thus characterizes a correct/incorrect detection:
#include "detection_equation.typ"
~_Precision_ and _recall_ definitions remain the same as for the previously introduced static #acr("SSL") task:
$
  "Precision" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(X)_(i, k),
      X_(i, k)
    )
  ) / (sum_i hat(z)_i),
$
<eq:ssl:multi_source:prec>

$
  "Recall" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(X)_(i, k),
      X_(i, k)
    )
  ) / (sum_i z_i).
$
<eq:ssl:multi_source:recall>


=== Dataset Collection
<sec:active_ssl:results:dataset>

To design, run, and evaluate our method on the #acr("ASSL") task, we generated a synthetic dataset using the simulator presented in Chapter 2.
Specifically, we leverage our simulator's ability to model _dynamic_ discrete-time environments (see @sec:simulator:simulator:dynamic_scenarios).
The latter consists of a repository of independent $H$-step trajectories.

*Acoustic objects and movement policy.*
First, a random number of speech sources $z_i$ is sampled uniformly between one and four.
Those $z_i$ sources get randomly positioned in the reverberant room.
The reverberation time $T_60$ has been set to 0.5s, and the room measures $4 times 7$ meters.
We pick a random starting side (top, bottom, left, or right) and randomly place the agent equipped with a four-microphone array in a 50cm strip along the corresponding wall.
The agent aims in a random direction, yet it is ensured to turn its back to the wall it starts from.
The range of possible initial orientations can be observed on @fig:active_ssl:results:dataset_init.

#include "figures/dataset_setup/fig.typ"

Regarding the movement policy, at each step, the new orientation $theta_t+1$ of the agent is sampled from the following normal distribution of mean $theta_t$ and variance $sigma_theta^2$:
$
  theta_(t+1) tilde cal(N)(theta_t, sigma_theta^2).
$
In practice, we use a value of $0.1$ radians ($approx 5.7°$) for $sigma_theta$.
The agent then moves forward in this new direction by a distance of 50cm.

A special case occurs when the robot is less than 50cm from a wall.
Instead, its orientation is sampled according to the initialization process to turn its back to this wall.

*Data gathering.*
The collected datasets will be used for two distinct purposes: evaluating the global #acr("ASSL") pipeline and training the #psi-dnn combination operator.
Hence, exhaustive geometric and acoustic data are gathered.
For each step, the audio signal received by the agent is fed to the #acr("SSL") network to collect the estimated #doa spectrum $hat(o)_t$.
The oracle spectrum $o_t$ also gets saved for further comparisons.
Also, the absolute positions of the agent and the relative source locations are saved at every step.
Finally, the robot's relative movements are recorded to perform the map shifting operation later.
Local #doa maps have not been generated at this point, but all the necessary information for their creation is available.
This choice allows for experimenting with the relevant hyperparameters, such as the #fov $L$ and pixel resolution $p$.

=== Performance Study

Both the #acr("ASSL") task and the proposed method admit variants and parameters.
In this section, an in-depth exploration of specific settings is conducted.


==== Likelihood Cutoff
<sec:active_ssl:results:likelihood_threshold>

To feed the aggregated heatmaps to the clustering algorithm, a set of points must first be extracted from the final 2D map #AM.
When building its clusters, DBSCAN does not consider the pixel values and only relies on the distance between the provided points.
Thus, the set of filtered coordinates should be carefully chosen.

We adopt a simple thresholding approach, selecting all points whose values are greater than a given target #clip-t.
This parameter should be high enough to let the clusters surface.
If it is too low, the resulting point cloud is fully connected, leading DBSCAN to find a single cluster.
Conversely, increasing #clip-t too much will result in local peaks being wholly filtered out, which will produce a missed detection.

@fig:active_ssl:results:clipping_threshold shows a given aggregated map after filtering with different values of #clip-t.
The top row depicts the map obtained from the averaging aggregation (#psi-avg) while the bottom one exposes the neural network output (#psi-dnn).
In this example, both blending strategies have provided a solid result that is not particularly challenging to cluster.
While the neural network could directly yield distinct blobs, the obtained averaged map has been shown to be more impacted by the thresholding.
Indeed, values of #clip-t that are too low do not manage to disconnect the various clusters and would link to a single prediction from the detection pipeline.
On the contrary, the network output suffers from too aggressive filtering as the blob with the lowest intensity eventually disappears for $#clip-t >= 0.8$.

#figure(
  image(
    "figures/clipping_threshold.svg",
  ),
  caption: [
    Effect of the clipping threshold on the aggregated maps.
  ],
)
<fig:active_ssl:results:clipping_threshold>

@table:active_ssl:results:clipping_threshold gathers the result of an experimental campaign on the impact of #clip-t on the final #acr("ASSL") performance.
All four combinations of blending methods and #doa spectrum providers have been tested to ensure completeness.
It shows that a single optimal value for #clip-t does not exist.
As both the aggregation process and the source #doa data significantly impact #AM, the threshold needs to be chosen accordingly.
Thus, for each scenario, we identify the best precision-recall tradeoff and select the corresponding #clip-t value.
Those pairs are underlined in @table:active_ssl:results:clipping_threshold and do not always coincide with the highest values of individual metrics (highlighted in bold).
Those optimal #clip-t values will be used in later experiments to extract the best performance from each method.

#include "tables/clipping_threshold.typ"

Finally, another factor might be brought into consideration: computational cost.
DBSCAN's time complexity is $O(n log n)$ when the data layout is favorable and $O(n^2)$ in the worst-case @ester_density-based_1996 ($n$ denotes the number of points).
In the use made of this algorithm here, the number of provided points is highly impacted by the choice of #clip-t.
For instance, the value of 0 is not tested.
This case indeed often translates to none of the pixels getting filtered.
For a resolution of $p=256$, the number of points forwarded to DBSCAN amounts to $p^2 = 65,536$.
Also, the algorithm output is a single cluster containing all points.

@fig:active_ssl:results:n_points_cluster plots the number of points remaining after the filtering process.
Blue lines correspond to using the naive averaging strategy to aggregate the maps and orange lines relate to the use of the neural network.
Also, dashed plots allow differentiation of which #doa spectra have been employed from the start.
This shows that the inferred likelihood map should be as sparse as possible, with peak values approaching 1.
Those properties allow for better separability and fewer points being fed into the clustering algorithm.

#figure(
  image(
    "figures/n_points_cluster.svg",
    width: 80%,
  ),
  caption: [
    Number of points remaining after the filtering operation with respect to #clip-t.
  ]
)
<fig:active_ssl:results:n_points_cluster>


==== Impact of the Upstream #acr("SSL") Model
<sec:active_ssl:results:impact_of_ssl_model>

The upstream static #acr("SSL") model features are a core part of the #acr("ASSL") pipeline.
The quality of #doa spectra it provides plays a significant role in the final performance of the method.
Hence, two scenarios are compared to isolate the behavior of the #acr("ASSL") method itself.
On the one hand, the neural network implemented and trained in @sec:ssl:multi_source predicts the #doa spectra $hat(o)_t$ from the listened audio.
This scenario is the most realistic as it can be used directly in a real-world scenario and does not rely on an oracle.
On the other hand, the #acr("ASSL") framework is also evaluated directly using the ground truth spectra $o_t$.
Here, the potential of our method can be explored under ideal conditions.

#figure(
  image(
    "figures/doa_spectra.svg",
  ),
  caption: flex-caption(
    short: [
      Comparison of ground-truth and predicted #_doa spectra
    ],
    long: [
      Comparison of ground-truth (blue) and predicted (red) #doa spectra obtained from our trained model.
    ],
  ),
)
<fig:active_ssl:results:doa_spectra>

@fig:active_ssl:results:doa_spectra shows instances of #doa spectra.
Although the #acr("SSL") model correctly infers most peaks, failed detections can still be observed across the trajectory dataset.
Most detection failures consist of false negatives in which the network outputs either a too-low peak or no activation at all.
In those cases, the averaged maps might still include local maxima in the correct locations, but those often get filtered when thresholding the final map.
Samples where several sources stand particularly close with respect to #doa also represent challenging cases.

From a performance point of view, @table:active_ssl:results:clipping_threshold, for instance, highlights an important gap between using ground-truth spectra and predicted ones.
For instance, the obtained recall on real data, peaking at around 55%, clearly appears to be a weakness of the proposed pipeline.
The leading cause lies in the shortcomings of the angular localization method.
Nonetheless, leveraging the static model across multiple distinct agent positions still permits recovery from partial misses and provides precise 2D localization.
This observation further validates the relevance of the proposed approach.


==== Comparison of Blending Methods
<sec:active_ssl:results:blending_methods>

Two alternatives have been compared for the map blending operation: naive averaging $Psi_"avg"$ and learned #psi-dnn (see @sec:active_ssl:methods:blending_methods).
The former serves as a baseline, offering the advantage of being explainable and straightforward, while the latter aims to provide superior performance.

#figure(
  image(
    "figures/blending_comparison.svg",
  ),
  caption: flex-caption(
    short: [
      Visual comparison of the two aggregation methods.
    ],
    long: [
      Visual comparison of the two aggregation methods (#psi-avg top and #psi-dnn bottom).
      Each column represents an example from the dataset.
      The first three use the ground-truth #doa spectrum, while the last two use the one estimated by the pre-trained SSL network.
    ],
  ),
)
<fig:active_ssl:results:blending_comparison>

@fig:active_ssl:results:blending_comparison discloses a selection of 2D heatmaps produced by the two proposed methods.
Naturally, when significantly precise #doa spectra are extracted at each step, even the naive averaging method suffices for accurately estimating the 2D heatmap.
However, when more imperfect and challenging #doa maps are considered, the neural network shows a greater capacity to ignore the noise and provide a sharp likelihood estimation.
Also, as #psi-dnn has been trained with localized 2D Gaussian blobs as targets, it has learned to properly filter the unnecessary parts of the original cones.
Its output successfully concentrates on the actual position of the sources.
The network facilitates clustering by precisely separating and isolating the different local peaks in the map.
This decreases the sensitivity to the hyperparameters of DBSCAN.

#include "tables/blending_methods.typ"

@table:active_ssl:results:blending_methods summarizes the best performance achieved by each aggregation strategy.
In particular, the most efficient value of the #clip-t parameter has been used.
Unsurprisingly, employing the neural network offers a tangible advantage over simply averaging the #doa maps.
Those results confirm the qualitative observations made above.
When provided with the ground-truth #doa spectra, #psi-dnn achieves an almost perfect precision.
However, the recall score slightly lags, with a value of 90.54%.
The few missed detections involve situations in which at least one of the sources remains strictly in front of or behind the agent during the entire trajectory.
The indirect triangulation phenomenon leveraged by our method becomes almost infeasible, and the distance cannot be accurately estimated.
Nonetheless, even in challenging cases where no clear cone intersection can be visually distinguished, the network sometimes manages to perform correct detections by relying on the prior it has learned during training.
During training, the network learns the statistical distributions of sound sources.
This can therefore help it to guess were a source can be, even when the actual map appears to be lacking the necessary information.

In summary, the proposed deep neural architecture has been shown to be a robust and powerful method for performing the aggregation step of the #acr("ASSL") pipeline.

// NN rightfully infers the presence of a source in the front, but predicts an inacurrate distance leading to missing the detection in the end.



==== A Tentative for #_doa Spectrum Amplification

As seen in @sec:active_ssl:results:impact_of_ssl_model, the #acr("ASSL") process works significantly better when provided with the ground-truth #doa spectra instead of using the pre-trained #acr("SSL") model.
One reason for this decrease in performance is that the peaks present in those estimated heatmaps are lower.
This does not necessarily impact the static #acr("SSL") metrics as any local maximum above the detection threshold #xi-doa would be counted as a #doa prediction (see @sec:ssl:multi_source:method:doa_repr).
However, this threshold does not intervene in the #acr("ASSL") pipeline, and the #doa spectrum is directly converted into a 2D #doa map.
When the deep neural network #psi-dnn is used to combine the maps, its output is normalized to the $[0, 1]$ range.
Although this would help amplify localization heatmaps that are too dim, it cannot compensate for relative differences caused by uneven peaks in the #doa spectra.

To account for this phenomenon, we have attempted to artificially adjust the spectra with an amplification trick.
Its concept remains simple: It simply consists of clipping all the portions of a #doa spectrum higher than a given threshold #doa-t to one.
In other words, a #doa spectrum $hat(o)$ is transformed in the following way:
$
  hat(o)' = max(hat(o), bb(1)_(hat(o) > #doa-t)).
$
#include "figures/doa_spectrum_amplif/fig.typ"

@fig:active_ssl:results:doa_spectrum_amplif displays this peak amplification process on an arbitrary example.
In @fig:active_ssl:results:doa_spectrum_amplif_maps, one can see the consequence of this process on the #doa maps.
Each row corresponds to a different value for the threshold.
Qualitatively, a too-high #doa-t will lead to lower peaks being left unamplified.
However, decreasing this parameter causes bigger, oversaturated cones that lose their localization information.

#figure(
  image(
    "figures/doa_spectrum_amplif_maps.svg",
    width: 80%,
  ),
  caption: [
    Effect of #_doa spectrum amplification on the local maps.
  ],
)
<fig:active_ssl:results:doa_spectrum_amplif_maps>

#include "tables/doa_threshold.typ"

Our experiments show that #doa spectrum thresholding fails to bring tangible benefits (see @table:active_ssl:results:doa_threshold).
Our #psi-dnn network has been retrained on a dataset of maps corresponding to each #doa-t value to obtain those results.
The #psi-avg technique, however, does not require any form of training.
Performance is often best for $#doa-t = 1$.
Employing this process when using the ground-truth #doa spectra was not expected to bring any additional performance, as all peaks precisely maximize at $1.0$ and thus do not need to be any further amplified.
In contrast, when using the #doa spectra estimated by the #acr("SSL") model combined with the neural network for map blending, #doa amplification slightly boosts the overall performance.
Conversely, the naive averaging approach does not benefit from more saturated spectra.

Finally, the marginal and situational advantages of clipping #doa spectra are insufficient to justify including them in the final method.
However, this tentative result further illustrates the pipeline's sensitivity to the quality and processing of the input #doa information.

==== Horizon
<sec:active_ssl:results:horizon>

The #acr("ASSL") task, as defined in this work, requires the agent to provide an estimate of the sources' locations after a fixed number of $H$ steps.
The proposed method shows promising performance when $H=8$ consecutive maps can be combined and analyzed.
To further explore the informative content of each step, we perform an ablation study on the horizon parameter.
The base dataset gathers trajectories of $H_0=8$ steps and is the only one used in this experiment.
To train or evaluate our method on a shorter horizon $H'$, we ignore the first $H-H'$ steps.
The final frame remains the same across all the experiments.

#include "tables/horizon.typ"

@table:active_ssl:results:horizon shows the final performance of the pipeline for different horizons.
The neural network #psi-dnn is retrained for each horizon to get the best possible performance.
As anticipated, the highest detection scores are achieved when using all eight steps.
Besides granting better absolute performance, the neural network demonstrates a greater robustness to lower horizons.
The performance drop is less pronounced than for the averaging approach.



==== Visual Encoding

The choice to model the 2D localization problem with heatmaps involves exploring hyperparameters related to this 2D representation.
As #doa maps are generated from the projection of #doa spectra, we can define the output domain without prior constraints.
Two parameters influence the synthesized maps: the #fov $L$ and the pixel resolution $p$.

*Field of View.*
The #fov ($L$) determines the size of the range covered by the egocentric map, which is an $L times L$ square centered around the robot agent.

Its value must be chosen diligently as it bounds the information available once the shifting and aggregation have occurred at the final position.
One has to consider the maximum distance $d_"max"$ traveled by the robot at each step and the horizon $H$.
If the characteristic value $H times d_"max"$ significantly overpasses $L/2$, information from the oldest steps might be at least partly out of scope and thus useless.
In practice, there is no particular reason to keep $L$ small, and choosing it greater than the room's dimensions ensures that most of the available knowledge is captured in the shifted maps $tilde(M)_t'$.
To quantify this parameter's impact, the neural network is trained on various #fovs, ranging from 2 to 16 meters.
Results are summarized in @table:active_ssl:results:fov, confirming the abovementioned expectation overall.
Performance indeed suffers from a reduction of the #fov.
The value of 16 meters is used in the rest of our experiments as it provides the most favorable conditions.

#include "tables/fov.typ"

*Pixel resolution.*
As opposed to the #fov, pixel resolution stands solely as a representation hyperparameter and does not fundamentally change the maps' informative content.
Naturally, a higher resolution would limit any loss caused by the spatial discretization process.
During our experiments, we noticed that imprecision would arise within the map-shifting process when using a too-low resolution.
The latter is performed directly on the discrete heatmap thanks to the _OpenCV_ @opencv_library software library.
On the other hand, increasing the resolution induces a larger image fed into the neural network.
As our U-net architecture is fully convolutional, the number of parameters remains identical when the input size changes.
However, the computational cost is still impacted by such modifications.
We have once more trained the neural network on maps of different resolutions between 64 and 256 pixels.
The results, presented in @table:active_ssl:results:pixel_res, suggest that a finer resolution helps with the localization process.
Although this parameter does not strongly impact precision, the recall is shown to be sensitive to pixel resolution.
Training time grows from 5 minutes when using $p=64$ to 30 minutes for $p=256$.
Inference time scales similarly, ranging from 30s to 2min 15s for the largest maps.
As those constraints remain acceptable for real-world use cases, the most favorable resolution ($p=256$) is used in the rest of our experiments.

#include "tables/pixel_res.typ"