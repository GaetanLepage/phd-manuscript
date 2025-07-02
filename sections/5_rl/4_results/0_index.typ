#import "/utils.typ": *
#import "../_variables.typ": *

== Experiments
<sec:rl:results>

Following the design and implementation of the complete #acr("RL") pipeline presented in the previous section, we now conduct an experimental study of its capabilities and performance.

=== ASR Performance in a Reverberant Room

First and foremost, we investigate how #acr("ASR") performance is impacted by reverberation. 
This study also explores the importance of the agent's position relative to the source, especially in highly reverberant environments.

*#acr("ASR") performance and reverberation.*
Several #acr("WER") cost maps were computed to visualize what the reward signal would be used to supervise the agent training.
@fig:rl:results:wer_maps_reverb provides high resolution ($#delta-grid = 10"cm"$) omnidirectional maps for different reverberation levels.
It must be noted that the obtained #acr("WER") values are entirely dependent on the #acr("ASR") model #asr-net used to approximate #wer-cost (@eq:rl:method:wer_cost).
It comes out that the microphone position does not affect #asr-net performance when reverberation is low.
For $T_60=100"ms"$ and $T_60=300"ms"$, the #acr("ASR") model achieves performance similar to what was measured in the clean-speech evaluation (see @table:rl:method:asr_models).
However, from $T_60=500"ms"$, reverberation starts to impact the #acr("WER") more, decreasing the transcript's fidelity globally.
Furthermore, the microphone's relative position from the source notably affects the mean #acr("WER").
This phenomenon amplifies as $T_60$ reaches $800"ms"$.
At such reverberation levels, the #acr("ASR") model can no longer provide reliable transcripts unless the agent is very close to the source.
Importantly, the model used in this study, `asr-crdnn-rnnlm-librispeech`, is trained exclusively on clean signal samples.
Reverberant conditions are therefore outside of its training distribution.
We do not report results for more advanced #acr("ASR") models, particularly those trained on reverberant or noisy data, which may perform better in such conditions.
Lastly, although informative, these sampled #acr("WER") cost maps remain noisy and do not provide a smooth reward signal.

This study confirms the relevance of developing a navigation policy that improves the agent's auditory perception.
More specifically, we focus on the $T_60=500"ms"$ case, which grants an interesting framework for this navigation task.


#include "figures/wer_maps/fig.typ"

*Cost Map Directionality*
The map is considered omnidirectional when the cost function is invariant in the agent orientation #agent-ori.
In the case of the #acr("WER") cost #wer-cost, this is when an omnidirectional microphone is used to record signals at each position on the grid.
When a directional microphone is used, separate recordings are made for all four cardinal orientations of the agent.
Directional maps add more challenge to the navigation task as the agent must optimize both its position #agent-pos and orientation #agent-ori to achieve the highest performance.
@fig:rl:results:directional_map displays an example of directional #acr("WER") cost map.
Each subfigure corresponds to a given agent orientation.
For a given agent position, the #acr("WER") cost can vary significantly depending on whether the agent is facing the source.
The following experiments investigate the agent's performance when trained with directional and omnidirectional costs.

#include "figures/directional_wer_map/fig.typ"


=== Reward Design
<sec:rl:results:reward_design>

Reward design is critical to training #acr("DRL") models.
Contrary to supervised learning, where clear ground truth labels are available for all training samples, the #acr("RL") training process relies only on the reward signal.
It is responsible for conveying information on the quality of the action sampled from the policy.
More specifically, framing a novel #acr("RL") task from scratch and developing an appropriate method for solving it necessitates meticulously adjusting the reward shape.
The following explains the key design decisions regarding our reward.

#include "figures/reward_function.typ"

*Exponential scaling.*
The base cost value is a scalar value between 0 and 1 (see @sec:rl:problem:formulation:environment).
For example, most experiments use the #acr("WER") maps values #wer-cost.
A custom function #f-reward is designed to derive a reward signal from the underlying cost.
Most importantly, #f-reward must be a decreasing function of #cost-t.
We choose an exponential base to ensure the reward smoothly decays as #cost-t decreases.
More precisely, we introduce two scaling parameters #reward-exp-alpha and #reward-exp-beta to control the final reward range:
//$
//  f(#cost-t) = #reward-exp-alpha exp[-#reward-exp-beta #cost-t]
//$
#func-def(
  f-reward,
  $[0, 1]$,
  $RR_+^*$,
  cost-t,
  f-reward-exp + ".",
)
@fig:rl:results:reward plots the value of $#f-reward (#cost-t)$ in function of the cost value #cost-t.
//$
//  r_t = & #reward-exp-alpha e^(-#reward-exp-beta C_t) \
//        & quad - #reward-forward-penalty bb(1) (a_t = #a-forward) \
//        & quad - #reward-wall-penalty bb(1) (a_t "invalid"),
//$
The final reward, introduced in @eq:rl:problem:reward, becomes:
$
  r_t = cases(
    #reward-wall-penalty &quad "if the agent tries to hit a wall",
    #f-reward-exp
      - #reward-movement-penalty bb(1) (a_t = #a-forward) &quad "otherwise,"
  )
$
<eq:rl:results:reward>
where
- #reward-exp-alpha and #reward-exp-beta are the scaling factors for the exponential cost term;
- #reward-movement-penalty is the movement penalty;
- #reward-wall-penalty is the penalty for invalid movements.
  It corresponds to when the agent would hit a wall.
The values of these parameters were set after an empirical study of their impact.
The following paragraphs detail these investigations.

*Policy collapsing.*
Training a #acr("DRL") agent is significantly more intricate than classically supervised neural networks.
Training dynamics are complex, sensitive, and depend on multiple factors.
For instance, the numerous hyperparameters in the #acr("PPO") algorithm are pivotal.
Some turned out to be crucial for achieving proper training.
One example of the subtle instabilities encountered during our experimental study is the phenomenon of policy collapsing.
Due to the significant expressivity of the feature vector extracted by the localizer backbone, it is easy to learn to move towards the source.
Let us denote this specific policy #pi-optimal.
Our initial experiments with the pre-trained backbone showed excellent performance, and the agent could consistently learn #pi-optimal.
However, additional ablation studies demonstrated that setting the reward to a constant or random value did not change the learnt behavior, and the policy was still converging to #pi-optimal.
We interpret that the loss for the value function #ppo-value-loss (@eq:rl:intro:ppo:value_loss) and the entropy bonus #ppo-entropy-bonus prevailed in the training dynamics.
It was expected that instead of converging to #pi-optimal, the learnt policy #pi-theta would collapse to the static policy, denoted #pi-still.
Indeed, in the absence of an informative reward signal and because of the penalties for hitting the room's walls (#reward-wall-penalty) and moving (#reward-movement-penalty), the agent would be expected to remain still.

*Reward scaling.*
The reward design needed further elaboration to prevent this phenomenon and ensure the reward signal dictated the learning behavior.
On the one hand, scaling up the reward permitted increasing its relative importance during training.
It balances the reward weight in the overall loss values and its gradients.
In practice, experimentally tuning the shaping coefficients led to choosing $#reward-exp-alpha = #reward-alpha-value$ and $#reward-exp-beta = #reward-beta-value$.
On the other hand, scaling #reward-movement-penalty to #reward-movement-penalty-value was also needed to balance its value properly concerning $#f-reward (#cost-t)$.
Once these two parameters were adequately tuned, the experiments showed more exploitable results.
Agents trained with the #acr("WER") cost #wer-cost quickly learned the #pi-optimal policy, while agents trained with an uninformative reward learned #pi-still.

To illustrate the phenomenon of policy collapsing, we monitor the following two metrics:
- #n-forwards counts the number of forward actions during an episode:
$
  #n-forwards := sum_(t=1)^T bb(1) (a_t = #a-forward).
$
- $#agent-source-final-dist := norm(bold(x)_(a, T) - #source-pos)_2^2$ records the distance from the agent to the target source at the final step of each episode.
@fig:rl:experiments:policy_collapsing plots, along training, both metrics averaged on the $abs(#ppo-traj-buffer)$ trajectories collected during #acr("PPO")'s sampling phase.
These two metrics clearly translate the collapsing of each agent to a respective typical policy.
The policy of the agent trained with the uninformative constant cost function converges to #pi-still, the static policy.
On the contrary, the agent trained with the regular #acr("WER") cost successfully learns to navigate to the source.

#include "figures/policy_collapsing/fig.typ"


=== Agent Performance on the Navigation Task

We report qualitative and quantitative results to evaluate the proposed method on the main navigation task.
The goal is to assess how the model performs in the environment once trained with the #acr("PPO") algorithm.
The evaluation consists of running several episodes where the agent acts according to the learnt policy.
We record various metrics to evaluate the navigation performance later.
Furthermore, trajectories are also saved to assess the agent's behavior qualitatively.
Examples of trajectories are represented on @fig:rl:results:trajectories.
The agent can learn #pi-optimal, the policy of navigating to the source, thus minimizing the associated #wer-cost cost.

#include "figures/trajectories/fig.typ"

A quantitative study of the agent's navigation performance is also conducted.
After training, a series of #n-ep episodes are executed to assess the performance of the #acr("RL") pipeline.
The agent greedily selects which action to take at each step according to @eq:rl:intro:action_selection.
This selection technique differs from the training phase, where the action is sampled according to the policy probability distribution #pi-theta.

We define the primary performance metric for an episode as the cost value obtained at the final step.
The obtained final costs are averaged over the #n-ep episodes and give the _#acr("MFC")_:
$
  #mfc = 100 / #n-ep sum_(i=1)^#n-ep C(s_(i, #env-horizon)),
$
where #env-horizon is the environment horizon and $s_T^i$ is the final state of the $i$-th test episode.
When using the #acr("WER") cost, it corresponds to the #acr("ASR") performance after the agent is done moving.
We convert the normalized cost to a percentage for more intuitive interpretation, especially in the case of #wer-cost.
In addition to #acr("MFC"), we report the undiscounted cumulated reward #mean-cum-reward:
$
  #mean-cum-reward = 1 / #n-ep sum_(i=1)^#n-ep sum_(t=1)^#env-horizon r_(i, t),
$
where $r_(i, t)$ is the reward the agent received when transiting to state $s_t$ during episode $i$.
The performance of the trained policy (denoted #pi-theta) is compared to a selection of baseline deterministic policies:
- *#pi-still*, where the agent remains static and always chooses the #a-stay action;
- *#pi-random*, where the agent acts randomly, also disregarding the state value;
- *#pi-safe-random*, which additionally avoids hitting the walls;
- *#pi-orient* where the agent never moves, but orients itself to face the source.
Furthermore, we test both our directional and omnidirectional formulations of the #acr("WER") cost #wer-cost.
//The first group of columns display the policies' performance when tested on the environment with 
#pi-theta is trained and evaluated on both environments separately.
We use the reward function defined in @eq:rl:results:reward.
Results are reported in @table:rl:results:wer_performance_vs_baselines.
The number of test episodes is set to $#n-ep = 1000$ to ensure statistical significance.
Also, #pi-theta is trained $#n-rep = 8$ times from scratch on each environment, and the evaluation metrics are averaged across these #n-rep runs.
#pi-still and #pi-orient have the same performance on the omnidirectional environment, where the agent's orientation does not affect the cost value.
In contrast, the #acr("MFC") of #pi-orient is lower than that of #pi-still, with the directional cost as facing the source contributes to reducing the #acr("WER") on average.
The low cumulated reward achieved by #pi-random is caused by the agent repeatedly hitting the room walls and being penalized by the #reward-wall-penalty penalty.
By contrast, #pi-safe-random achieves a similar mean final cost, but does not see its reward impacted by the wall hit penalty.
The trained deep neural policy #pi-theta outperforms all baselines on the two environments.
It significantly improves the #acr("MFC") over other navigation strategies.
Reducing the #acr("WER") from around 20% to 5.69% in the omnidirectional case and 8.59% in the directional case would considerably help a real robot understand the human speaker.

#include "tables/wer_performance_vs_baselines.typ"


=== Importance of Localization Feature Extraction
<sec:rl:results:backbone_init>

The agent neural network's backbone is pre-trained on the supervised static #acr("SSL") task.
It outputs #dim-features-value;-dimensional feature vectors that are highly correlated with the source localization.
To assess the impact of this choice, we conduct an ablation study where different initialization strategies are tested.
In addition to our regular initialization strategy, we train an agent where the entire network is initialized from scratch, with no pre-training.
All three agents are trained on the directional #wer-cost;-based environment.
We include an extra variation in which the backbone is pre-trained on the localization task, but whose weights are not frozen during the #acr("RL") training phase.
The directional #acr("WER") cost is used to train and evaluate all agents.
@table:rl:results:backbone_pretraining reports the main evaluation metrics #mean-cum-reward and #mfc.
The performance of #pi-safe-random is also reported for reference.

#include "tables/backbone_pretraining.typ"

First, training the backbone from scratch does not succeed.
The end-to-end agent cannot learn directly from the raw acoustic observations.
Pre-training the feature extractor on a supervised localization task appears to be crucial to solving the present navigation problem.
Training the proposed architecture from scratch might be achievable, but would probably require more #acr("PPO") iterations and a slower learning rate.
Secondly, and more surprisingly, our attempt at fine-tuning the localizer's backbone has failed too.
Even though the backbone's weights were initialized from the pre-trained checkpoint, #acr("PPO") could not learn a satisfying navigation policy.
We hypothesize that the training hyperparameters that have been tuned for working with the frozen backbone cannot fine-tune the backbone stably.
More precisely, the learning rate of $10^-3$, coupled with #acr("PPO")'s highly chaotic early training regime, is probably altering the pre-trained backbone weights before learning a working policy.
A two-stage training process appears to be a plausible solution to this problem.
At first, its goal would be to prevent perturbing the feature extractor while the actor and critic are stabilized.
In a second time, it could be unfrozen and fine-tuned with a lower learning rate.

To conclude, this study confirms the relevance of pre-training the agent's feature extractor.
It permits rapid learning of a navigation policy by employing minimal #acr("MLP")-style actor and critic networks that ingest the localization feature vectors.


=== Alternative Cost Maps

Before using #acr("WER") cost maps to compute the reward, we have conducted experiments with alternative cost maps.
As highlighted in previous @sec:rl:method:wer_maps:computing, computing #wer-cost is very compute-intensive.
Furthermore, the #acr("WER") cost is noisy and has some artifacts.
The present study introduces an alternative formulation for the cost function #cost.
This _analytical cost_ #analytical-cost is a closed-form formula that directly maps a state $s in cal(S)$ to its normalized cost.
It was motivated to provide a replacement for the #acr("WER") cost maps, which are computationally heavy to create.
We question whereas this synthetic cost could permit the training of effective policy that perform satisfyingly on the #acr("WER")-based environment.
The analytical cost is defined over the state space $cal(S)$ as:
#func-def(
  analytical-cost,
  //$quad RR^2 times [0, 2pi] times RR^2$,
  $cal(S)$,
  $RR_+$,
  $(
    #agent-pos,
    #agent-ori
    //bold(x)_s
  )$,
  $
  #agent-source-dist + eta #agent-source-doa
  $
)
<eq:rl:results:analytical_cost>
where:
- #agent-pos and $theta_a$ are respectively the position and orientation of the agent in the room's frame;
- #source-pos is the source position and is fixed for a given episode;
- $#agent-source-dist = #agent-source-dist-expr$ is the source-array distance;
- $"DoA"(#agent-pos, theta_a, #source-pos)$ is the direction of arrival for this source-microphone positioning;
- $eta$ is a scaling factor, set to 1 in the conducted experiments.
This definition is naturally inspired by the shape of the #acr("WER") maps (see @fig:rl:results:directional_map for an example).
The obtained map is normalized to constrain its range in the $[0, 1]$ interval.
Setting $eta$ to 0 gives the omnidirectional formulation of the analytical cost.
@fig:rl:results:analytical_map plots the analytical cost $C$ for the east orientation, i.e., where the agent is facing right in this figure's frame.
As #analytical-cost has a closed-form definition, the resulting cost maps are considerably smoother and less noisy than #acr("WER") maps.

#include "figures/analytical_map/fig.typ"

To evaluate the impact of the cost function on the learned policy, we start by training the deep neural agent on both cost variants later to evaluate them on the same final target environment.
//Indeed, the average cumulated reward (#mean-cum-reward) and the mean final cost (#mfc) are not comparable across environments, as the same navigation policy would lead to different values.
Naturally, the target environment is based on the #acr("WER") cost function.
This study aims to see the benefits of using analytical maps for training the agent.
@table:rl:results:maps_comparison gathers the quantitative results from this experimental campaign.
For both omnidirectional and directional settings, we train a policy on the synthetic environment, using the #analytical-cost cost, and another one on the #wer-cost;-based environment.
We then evaluate the performance of the agent trained with the analytical cost map in the target environment, using the #wer-cost cost function.
Besides being considerably more efficient to compute, #analytical-cost;-based cost maps appear to help with the final #acr("WER") performance in the omnidirectional case.
Indeed, the policies trained to optimize the analytical cost yield a lower #mfc cost than those directly trained with the target cost.
Analytical maps provide a stronger reward signal and help achieve better policies thanks to their inherent consistency and smoothness.
However, training the agent on the directional analytical cost was not as successful.
The performance in the training environment is inconsistent with the omnidirectional case.
Although the underlying cost maps and thus optimal policies are different, the agent does not succeed in learning a robust policy.
The analytical directional environment is more challenging as the zone yielding the lowest cost is smaller.
Furthermore, if the agent is not facing the source, being at the proper position does not suffice.
Besides performing poorly in the training environment, the obtained policy compares unfavorably to the one trained directly on the target environment.
Therefore, transferring a policy trained using the directional analytical cost is not advantageous.


#include "tables/maps_comparison.typ"
