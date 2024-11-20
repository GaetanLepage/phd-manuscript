#import "/utils.typ": *
#import "../_notations.typ": *

== Methods
<sec:active_ssl:methods>

=== Problem formulation

#gaet[
  Mention that distance estimation was a missing feature from the static SSL framework.
]

As presented in @sec:active_ssl:background, experimenting with #acr("SSL") in a dynamic robotic context presents challenges and opportunities.
In this work, we introduce and explore an #acr("ASSL") problem, motivated by the extension of the static #acr("SSL") methods developed in @chap:ssl to more realistic situations.
Indeed, estimating both distance and #doa from a single recording has shown to be a challenging version of the #acr("SSL") problem.
Grumiaux et al. @grumiaux_survey_2021 insist on this difficulty in their survey by highlighting the scarcity of 
#draft[
  Maybe, this is expressed in Laurent's SSL survey @grumiaux_survey_2021.
]
Theoretically, though, aggregating purely angular information accumulated over time by a mobile robot could allow for predicting the actual location of sources in a room.


More precisely, a robotic agent moves in a room with one or several human speakers.
We adopt a step-based representation in which the robot performs discrete movements denoted as $delta_t = (d_t, theta_t)$.
Its trajectory is assumed to be determined by an external policy which should not be affected.
Thus, the developed method aims to localize, in real time, the relative position of each source.
To enforce the real-time constraint in this modeling, each step's duration is limited to a few hundred milliseconds.
The method is provided with the recorded signal at each microphone of the agent corresponding to this time frame.

*Horizon.*
This framework appears similar to the previously used static formulation of #acr("SSL").
However, the input data also encompasses information about the last relative movement of the robot.
Although the #acr("ASSL") solution should not dictate the movement policy, its output is accessible to the localization module.
This data allows the model to accumulate knowledge along several consecutive steps to refine its prediction for the current sources' positions.
The number of steps after which the method's output is evaluated will be denoted as the horizon $H$.
Notably, only relative movement information may be leveraged to perform the task as the absolute agent position remains unknown.
In this aspect, this formulation differs from problems where the robot's localization is also available.

Sound sources model talking humans present at arbitrary positions within the room.
Their positions are assumed to be static for an entire episode of $H$ steps.


=== Pipeline Overview

We explore leveraging the previously developed multi-source static localizer to tackle the #acr("ASSL") problem.
The method's central concept is building and refining a 2D egocentric map that encodes the relative positions of each source.
They are built to model the likelihood of the sources' presence in the surroundings of the robot.

To build such a map, we start by running the #acr("SSL") model (@sec:ssl:multi_source) which provides an estimated #doa spectrum.
This detection is then transformed into a _#doa map_ projecting the one-dimensional localization result to an egocentric 2D map containing the same information.
Then, this map is combined with the ones from previous steps after having been transposed to the current robot frame.
Different ways of operating this aggregation have been proposed.
Finally, the 2D relative positions of the sources are extracted from this estimated egocentric map.

The overall procedure for performing one step of active-#acr("SSL") is illustrated in @fig:active_ssl:method:pipeline and described in @algo:active_ssl:algo.
The individual steps of the process will be detailed in the following sections.

#include "algorithm.typ"

#figure(
  image(
    "figures/pipeline.svg",
    width: 100%,
  ),
  caption: [
    Active-#acr("SSL") pipeline
  ]
)
<fig:active_ssl:method:pipeline>

=== Egocentric #acr("SSL") maps

At each step, a _#doa map_ $M_t$ is built from the #doa spectrum for the corresponding audio recording (line 9 in @algo:active_ssl:algo).
The latter solely provides angular information.
At this stage, no distance knowledge has been gathered yet.
The choice was made not explicitly to extract a set of detections from the spectrum but to preserve the raw 360-long vector.
Generating the #doa map $M_t$ involves projecting this spectrum on the egocentric 2D space.

All maps have a resolution of $p$ pixels and are thus represented by $p times p$ matrices.
They represent a $L times L$ square area around the robot.

// TODO: illustration ?
First, each point $bold(p) = (x, y) in [-L/2, L/2]^2$ in the robot frame is mapped to the corresponding #doa value $theta(bold(p)) in [-pi, pi]$.\
This allows to associate all pixels $(i, j) in [|1, p|]^2$ of the map to the corresponding angle $theta_(i, j)$.\
Finally, the associated #doa spectrum value can be recovered by computing the index $k_(i, j) in [|1, d|]$ corresponding to the angle $theta_(i, j)$:
$
  M_(t(i, j)) = o[k_(i, j)] #h(2em) forall (i, j) in [|1, p|]^2
$
Hence, the intensity of a pixel equals the value of the spectrogram at the corresponding angle.

@fig:active_ssl:doa_map presents an example of such a #doa map along with the originating spectrum.
By construction, the value of this 2D function remains constant along lines where $theta = arctan(x/y)$ is constant.
This leads to a mixture of cone shapes originating at the center of the egocentric map.

#include "figures/doa_map/figure.typ"

*Shifting.*
At each step, the method gets the #doa maps $(M_(t-H+1), dots, M_(t-1))$ from the $H-1$ previous steps.
All those maps need to be _shifted_ from their original frame $cal(F)_t'$ to the current robot frame $cal(F)_t$ to be combined with the current #doa map $M_t$.
This operation uses the relative movement $Delta_(t_1 -> t_2)$ between two steps $t_1$ and $t_2$.
It encodes the position and orientation of the previous map in the current frame $cal(F)_t$.
This movement is computed from the robot movement at each step $delta_t'$ with $t' in [|t_1, t_2|]$.
The result of this operation will be denoted as $tilde(M)_t'$.
@fig:active_ssl:method:shift provides an example of a #doa map along with its shifted version.
Of course, we have $tilde(M)_t = M_t$ as the current map does not need to be shifted.

This corresponds to the lines 12-16 of @algo:active_ssl:algo.
The #fov parameter $L$ has to be chosen carefully.
Its impact will be studied in a later section.

#include "figures/shift/figure.typ"


=== Aggregation strategies
<sec:active_ssl:methods:blending_methods>

Once the collection of $H-1$ previous #doa maps has been correctly shifted to $cal(F)_t$, they will be _combined_, along with the current map $M_t$.
The intuition behind this approach for #acr("ASSL") lies in combining those step-maps into a single aggregate that models a 2D likelihood of source presence around the robot.

Such a mapping is defined as:
#func-def(
  $Psi$,
  $RR^(H times p times p)$,
  $RR^(p times p)$,
  $
  bold(tilde(M))_t = (
    tilde(M)_(t-H+1),
    dots,
    tilde(M)_t
  )$,
  AM,
)
where #AM denotes the obtained estimate for the likelihood.

Designing a reliable process to aggregate the maps is crucial.
Indeed, the resulting #AM likelihood will be used to extract the positions of each source.
The cleaner the combined map can be, the easier the detection task becomes.

In this section, two methods are proposed to perform map blending.


==== Deterministic averaging

On the one hand, a naive approach has been attempted.
It simply consists in averaging the maps:
$
  #psi-avg (
    tilde(M)_(t-H+1),
    dots,
    tilde(M_t)
  ) := 1 / H sum_(t'=0)^(H-1) tilde(M)_(t-t')
$

As all maps are correctly expressed in the same local frame $cal(F)_t$, a given pixel in each one corresponds to the same position.
The idea of averaging #doa maps means that each time step provides equal information about the presence of sources.
Thus, the intersection of the different cones will have the highest scores, which appears reasonable.

However, in particular trajectories, averaging leads to artifacts that harden the clustering task performed to extract the final detection results.

The performance of this blending approach is discussed further in @sec:active_ssl:results:blending_methods.

==== Deep Neural Network

*Motivation*

Although averaging #doa maps is a simple and explainable method for blending, we have developed a more advanced technique involving a Deep Neural Network.
Indeed, an oracle knowing the absolute positions of each source could be used to generate an ideal version of the 2D likelihood estimate #AM-targ,
This statement leads to the definition of the blending process as a regression task where a neural network $Psi^("DNN"(theta))$ is trained to blend real #doa maps in the ideal estimate #AM-targ.

*Ground truth encoding*

The target map $cal(M)_t^*$ is computed from a set of ground truth sources positions $cal(X)_s = lr(((x_1, y_1), dots, (x_n_s, y_n_s)), size: #150%)$ expressed in the current robot frame $cal(F)_t$.

A strategy similar to the spectrum encoding introduced for multi-source #acr("SSL") presented in @sec:ssl:multi_source:method:doa_repr has been chosen.
Each source is modeled by a 2D Gaussian blob centered at its position.
The envelope of those Gaussians leads to the continuous target map:
#func-def(
  $overline(#AM-targ)$,
  $[-L/2, L/2]^2$,
  $[0, 1]$,
  $X = (x, y)$,
  $display(
    max_(
      X_s = (x_s, y_s)
      in cal(X)_s)
    )
      {
        e^(
          -(norm(X - X_s)^2)
          / sigma^2
        )
      }$,
)
where $sigma$ affects the spread of each blob and has been set to 0.5m.

This continuous function is discretized in the final $p times p$ matrix #AM-targ.
@fig:active_ssl:methods:gt_encoding shows the ground truth value for our previous example.

#figure(
  image(
    "figures/gt_encoding.svg",
    height: 7cm
  ),
  caption: [Ground truth encoding #AM-targ of the localization map]
)
<fig:active_ssl:methods:gt_encoding>

Hence, we expect to achieve a finer filtering result by using a more advanced blending method such as a #acr("DNN").
The network should remove all noise in the input maps and underline the regions where sources are expected.



*Architecture*

The neural network #psi-dnn takes the $H$ shifted #doa maps $(tilde(M)_(t-H+1), dots, tilde(M)_(t))$ as a single $H$-channel image $bold(tilde(M))_t$.
It outputs a single-channel image #AM, which is expected to approximate the target map #AM-targ.

To design a model aimed at processing image-like information, conventional architectures from the computer vision literature are considered.
Although several solutions could probably fit this problem successfully, one has to pay attention to the receptive field of the network.
Indeed, designs purely based on small convolutional kernels would not be able to capture global information.
In this specific task, the intersecting rays present in each #doa map have to be considered from a sufficiently large scale.
What could appear locally as an intersection of rays, indicating the presence of a source, could be noisy artifacts caused by an earlier crossing.
This hypothesis may explain the failure of experimented networks with receptive fields that are too small.

To account for this problem, we propose a custom U-net architecture adapted from the original paper by Ronneberger et al. @ronneberger_u-net_2015.
This type of design suits the present task of image-to-image mapping well.
More specifically, it allows for multi-scale processing, thus allowing to leverage larger patterns.
We opt for a four stage layout (@fig:active_ssl:methods:nn_architecture) within which the #shape(8, 256, 256) input gets progressively downscaled to a #shape(512, 32, 32) latent representation.
The second half of the network scales the data back to the $p times p$ resolution, outputting a single-channel map.
Skip-connections permit incorporating data from various stages of the downscaling step into the upsampling process.
They explain the interesting multi-scale properties offered by the U-net architecture.

Each encoder block comprises two convolutional layers and a #acr("ReLU") activation function.
The first 2D convolution doubles the number of channels, while the second preserves its input dimension.
Those layers are followed by a 2D max-pooling operation (corresponding to downward arrows in @fig:active_ssl:methods:nn_architecture).
The latter downscales the images by a factor of two.
Regarding the decoding stage, data gets upsampled by transpose convolutions, also known as deconvolutions @zeiler_deconvolutional_2010 (upward arrows).
The resulting higher-resolution images are concatenated with the corresponding descending tensor from the downsampling stage before being fed into two more consecutive convolutional layers.
The process is repeated until the original dimension of the image is recovered.

#figure(
  image(
    "figures/nn_architecture.svg",
    width: 100%,
  ),
  caption: [
    Deep neural network architecture for 2D localization map aggregation
  ]
)
<fig:active_ssl:methods:nn_architecture>

No architectural element explicitly bounds the network output to a given numerical range.
Thus, when using the network at inference, the output is normalized to ensure that all pixel values lie in the $[0, 1]$ interval.


*Training strategy.*

The network is trained in a supervised manner on a synthetic dataset.
The latter was generated by simulating $H$-step-long random trajectories in the simulator.
The static #acr("SSL") model is called at each step and outputs an estimation of the #doa spectrum $o_t$.
The latter are converted to #doa maps $M_t$ which are finally shifted to the frame $cal(F)_H$, which corresponds to the last robot position.
We collect 10k such trajectories using this process, totaling 80k individual positions.
Each trajectory represents a training sample corresponding to the last position of the agent.
The dataset generation process will be detailed in @sec:active_ssl:results:dataset.

The loss function used is the #acr("MSE") between the predicted and expected likelihood maps is given by
$
  cal(L) (
    #AM,
    #AM-targ,
  ) = norm(
    #AM - #AM-targ,
  )_2 ^2
$
where $#AM = Psi^("DNN"(theta))(bold(tilde(M))_t)$ is the output of the network and #AM-targ is the target map.


We train the network using the Adam @kingma_adam_2017 optimizer with a $10^(-4)$ learning rate.
The training process uses mini-batches of 100 samples and lasts for 20 epochs.
20% of the complete training set is reserved as a validation set to ensure the model generalizes correctly to unseen samples.


=== Clustering for detection extraction

The detection process occurs once the aggregation function $Psi$ has been used to generate a single-channel 2D map.
The core principle of this step lies in extracting a set of source positions from the heatmap.
Naturally, the detection performance is highly correlated to the quality of the provided maps.

This task resembles the #doa spectrum post-processing performed for multi-source #acr("SSL") (@sec:ssl:multi_source:method:doa_repr).
Indeed, local maxima in the likelihood 2D maps are expected to encode potential sources' positions.
However, the simple algorithm implemented there remains impractical in the current case as the data is two-dimensional.

Therefore, we choose to formulate this decoding task as a clustering problem.
First, the coordinates of all pixels with a value higher than a pre-determined threshold $tau$ are extracted.
This set of 2D points is fed into the DBSCAN algorithm, introduced by Ester et al. @ester_density-based_1996.
The latter takes two parameters: $epsilon$ defining the radius of a neighborhood and $m_p$ the minimum number of samples in a neighborhood for a point to be considered as a _core_ point.
A distance compatible with the input samples also has to be specified.
In this case, as we deal with points in the plane, we use the conventional Euclidean distance.
DBSCAN categorizes all input points into three groups: _core_ points, reachable points, and outliers.
The latter are considered noise and do not belong to any cluster, while the other form connected groups of samples, the clusters.
Among its several benefits, DBSCAN does not require specifying an apriori number of clusters.
This limitation features amid other clustering algorithms such as $k$-means for instance.
DBSCAN by itself does not define a concept of center for clusters.
Here, the cluster center is the point with the highest value in the aggregated likelihood map.
One should note that the actual values of each point in the heat map only impact the center search.
Prior clustering happens without access to the estimated likelihood values and solely operates on the points' proximity to determine the clusters.
Each cluster is interpreted as one source.
One advantage of such a clustering formulation is that the proposed method can detect an arbitrary number of sources.

#gaet[
  Also, maybe elaborate more on why we have chosen DBSCAN.
  It has several important benefits that we could list out.
]

#xavi[This is a test]

#laurent[Nice test indeed]