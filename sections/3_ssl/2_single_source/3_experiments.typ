#import "/utils.typ": *
#import "2_method.typ": d

=== Experiments <sec:ssl:single_source:experiments>

==== Metrics

*#acr("DoA") metric.*
In this first formulation of the #acr("SSL") problem, each situation includes exactly one source to localize.
Naturally, the performance of the method is characterized by how far the estimate $hat(theta)$ lays from the real #acr("DoA") value $theta$.
For this, we compute the $l_1$ angular pseudo-distance #d between $hat(theta)$ and $theta$.
This measure will be refered to as the *Mean Absolute Error*:
$
  "MAE"_theta = 1 / n_"test" sum_(i=1) ^  n_"test" #d (hat(theta)_i, theta_i)
$ <eq:ssl:single_source:mae>
where $n_"test"$ counts the number of samples in the test set.


*Source-array distance metric.*
When predicting the source-array distance, the #acr("RMSE") distance between predicted $hat(d)$ and ground truth $d$ serves as the performance criteria:
$
  "RMSE"_d = sqrt(
    1 / n_"test"
    sum_(i=1) ^ n_"test" norm(hat(d)_i - d_i)_2^2
  )
$ <eq:ssl:single_source:dist_metricc>
The choice of #acr("RMSE") benefits from being expressed in length units.

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


==== Sound Source Localization in noisy environments <sec:ssl:single_source:experiments:noise>

Having succeeded at accurately estimating the #acr("DoA") in a reverberant but noiseless setting, we have attempted to add noise sources.
The latter has revealed to harden the task significantly.
We have focused on noises of basic nature: white noise and music.
Both share the property of noticeably differing from a speech signal in its fundamental acoustic nature.
// Having a parasite speech

// Which kinds of noises


=== Conclusion

// Limitations: single source (i.e., not more than one BUT ALSO always at least one)