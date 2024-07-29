#import "/utils.typ": *

=== Experiments <sec:ssl:single_source:experiments>

==== Metrics

This task of single-source #acr("SSL") boils down to a one-dimensional regression problem.
The neural network comprises a single output neuron expected to estimate the value of $theta$.

We will now present the loss function used during training.\
First, consider the following angular distance.
Let $theta_1, theta_2 in RR$ two angle values expressed in radians.
$
d: #h(1cm) RR^2 &arrow.r.long [-pi, pi]\
 (theta_1, theta_2) &arrow.r.long.bar  (theta_1 - theta_2 + pi)[2pi] - pi
$ <eq:ssl:single_source:angle_dist>
The angular distance, defined as such, yields values wrapped in the $[-pi, pi]$ interval.

#block(breakable: false)[
  Also, one should note that $d$ is antisymmetric, i.e. $forall (theta_1, theta_2) in RR^2$,
  $
    d(theta_1, theta_2) = -d(theta_2, theta_1)
  $
]

#draft[
  Shouldn't we simply formulate the loss for a single sample and not bother with the summation over all elements of the dataset ?\
  Or maybe simply adding it at the end of the paragraph.
]

#draft[
$
  cal(L)_"DoA"(
    hat(theta), theta
  ) =
  d(hat(theta)_i, theta_i) ^ 2.
$
]

Let $hat(theta) = (hat(theta)_1, dots, hat(theta)_n)$ be the set of #acr("DoA") angles predicted by the network and $theta = (theta_1, dots, theta_n)$ the corresponding ground truth values.
The loss function expresses as
$
  cal(L)_"DoA"(
    hat(theta), theta
  ) = 1 / n
    sum_(i=1)^n
    d(hat(theta)_i, theta_i) ^ 2. // TODO should their be a period here ?
$ <eq:ssl:single_source:doa_loss>

The neural network is trained to minimize this objective.

When the model additionally estimates the distance to the source, the natural $l_2$ distance is used
$
  cal(L)_"dist" (hat(d), d) = norm(hat(d) - d)_2^2
$ <eq:ssl:single_source:dist_loss>
and the total loss then becomes
$
  cal(L) (
    (hat(theta), theta), (hat(d), d)
  ) =
  cal(L)_"DoA" (hat(theta), theta)
  + cal(L)_"dist" (hat(d), d)
$ <eq:ssl:single_source:total_loss>
#gaet[
 Wouldn't the following be even easier to read (although less accurate)
 
$
  cal(L) =
  cal(L)_"DoA" (hat(theta), theta)
  + cal(L)_"dist" (hat(d), d)
$ <eq:dsqkfjsdlkjf>

]
// $
//   cal(L) (
//     (d, hat(d)), (theta, hat(theta))
//   ) = 1 / n
//   sum_(i=1)^n
//   [
//     cal(L)_"DoA" (theta_i, hat(theta)_i)
//     + norm(d_i - hat(d)_i)_2^2
//   ]
// $
//where $d = (d_1, dots, d_n)$ is the set of predicted distances and $hat(d) = (hat(d)_1, dots, hat(d)_n)$ the ground truth data.

==== Impact of input signal representation

The the neural network is expected to extract the relevant localization information from the audio signal provided as input.
Hence, the choice of the encoding method for the acoustic data has a substantial impact on the difficulty of this task.

In this work, we focus on time-frequency representations.
// TODO: for STFT, we use |z| and Arg(z) as real tensors, not Re(z), Im(z)
When using #acr("STFT") features directly, they get converted to real values as following.
Each complex matrix translates to two real ones by splitting the modulus and the phase of each entry.
Thus, a $N$-channel #acr("STFT") $N times F times T$ complex tensor ends up as a $2N times F times T$ real array.
This choice allows the use for conventional real-valued 2D convolutions.

// Compare ILD/IPD performances


==== Sound Source Localization in noisy environments

Having succeeded at accurately estimating the #acr("DoA") in a reverberant but noiseless setting, we have attempted to add noise sources.
The latter has revealed to harden the task significantly.
We have focused on noises of basic nature: white noise and music.
Both share the property of noticeably differing from a speech signal in its fundamental acoustic nature.
// Having a parasite speech

// Which kinds of noises


=== Conclusion

// Limitations: single source (i.e., not more than one BUT ALSO always at least one)