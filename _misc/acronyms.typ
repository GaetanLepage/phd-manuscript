#import "acrostiche.typ": init-acronyms

#init-acronyms((
  // Misc
  "EM": ("expectation-maximization"),
  "API": ("Application Programming Interface"),
  "HRI": ("Human-Robot Interaction"),
  "RMSE": ("Root Mean Square Error"),
  "GT": ("Ground Truth"),
  "MKF": ("mixture Kalman filter"),
  "HMM": ("Hidden Markov Model", "Hidden Markov Models"),
  "MCTS": ("Monte Carlo tree search"),
  
  // Deep Learning
  "BN": ("Batch Normalization"),
  "CRDNN": ("Convolutional Recurrent Deep Neural Network"),
  "DL": ("Deep Learning"),
  "DNN": ("Deep Neural Network"),
  "GRU": ("Gated Recurrent Unit", "Gated Recurrent Units"),
  "LLM": ("Large Language Model", "Large Language Models"),
  "LN": ("Layer Normalization"),
  "RNNLM": ("Recurrent Neural Network Language Model"),
  "MSE": ("Mean Squared Error"),
  "MLP": ("Multi-Layer Perceptron"),
  "ReLU": ("Rectified Linear Unit"),
  "RNN": ("Recurrent Neural Network"),
  
  // ASR
  "ASR": ("Automatic Speech Recognition"),
  "LM": ("Language Model"),
  "CTC": ("Connectionist Temporal Classification"),
  "WER": ("Word Error Rate"),

  // SSL
  "DCASE": ("Detection and Classification of Acoustic Scenes and Events"),
  "DoA": ("Direction of Arrival"),
  "SSL": ("Sound Source Localization"),
  "SSLR": ("Sound Source Localization for Robots"), // dataset by He et al.
  // Metrics
  "ACC": ("Accuracy"),
  "MAE": ("Mean Absolute Error"),

  // Active SSL
  "ASSL": ("Active Sound Source Localization"),
  "FoV": ("Field of View"),

  // Audio
  "DFT": ("Discrete Fourier Transform"),
  "GA": ("Geometrical Acoustics"),
  "GCC-PHAT": ("Generalized Cross-Correlation function with Phase Transform"),
  "HRTF": ("head-related transfer function"),
  "ILD": ("Interaural Level Difference"),
  "IPD": ("Interaural Phase Difference"),
  "ISM": ("Image Source Model"),
  "MFCC": ("Mel-Frequency Cepstral Coefficients"),
  "RIR": ("Room Impulse Response"),
  "RTF": ("Related Transfer Function"),
  "SNR": ("Signal to Noise Ratio"),
  "STFT": (
    "Short-Term Fourier Transform",
    "Short-Term Fourier Transforms"
  ),
  "TDoA": ("time difference of arrival"),
  
  // RL
  "DQN": ("Deep Q Learning"),
  "DRL": ("Deep Reinforcement Learning"),
  "GAE": ("Generalized Advantage Estimation"),
  "MDP": (
    "Markov Decision Process",
    "Markov Decision Processes"
  ),
  "POMDP": ("Partially Observable Markov Decision Process"),
  "PPO": ("Proximal Policy Optimization"),
  "RL": ("Reinforcement Learning"),
  "RLHF": ("Reinforcement Learning from Human Feedback"),
  "TD": ("Temporal-difference"),
  "TRPO": ("Trust Region Policy Optimization")
))