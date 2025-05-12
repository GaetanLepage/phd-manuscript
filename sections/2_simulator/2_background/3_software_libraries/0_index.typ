#import "/utils.typ": *

=== RIR Simulation Libraries
<sec:simulator:background:rir_libraries>

This section presents an overview of implementations of room acoustics simulation methods.
As for simulation techniques, the software landscape is broad.
Implementations can be motivated by different reasons.
Some serve the only purpose of demonstrating a research idea.
Others may be industry-grade libraries integrated into commercial products.
This diversity in the state-of-the-art for auralization reflects the numerous directions investigated by the scientific communities in this domain.

The popularity of the #acr("ISM") makes it the most common implementation approach.
First and foremost, the very first computer programs for simulating room acoustics were leveraging #acr("ISM") techniques.
In 2005, Campbell et al. published the popular _RoomSim_ MATLAB implementation of the original #acr("ISM") method proposed by Allen et al. @allen_image_1979.
It aimed to provide researchers with a simple yet efficient method to simulate sound propagation in rectangular rooms.
Schimmel et al. @schimmel_fast_2009 iterated on their approach in 2009, implementing the _RoomSim_ program in C.
This new code was claimed to be faster and thus address the main limitation of the MATLAB version, computational performance.
They evaluated their library against the latter and obtained a 40x improvement in terms of speed.
Also, they implemented the diffuse rain algorithm to better model the high-order and diffuse reflections.
_Pyroomacoustics_ @scheibler_pyroomacoustics_2018 is a modern and feature-rich implementation by Scheibler et al.
It also relies on the #acr("ISM") method to compute the #acr("RIR")s.
Their formulation allows for handling arbitrary polyhedral rooms, which were not handled by the classic #acr("ISM") implementations.
The core simulation algorithms are written in C to achieve good performance.
Yet, they also provide a user-friendly Python API to make the library easy to learn and use.
In addition to its primary #acr("RIR") computation capability, this project ships various additional features such as beamforming algorithms, direction finding, and adaptive filtering.
Rathnayake et al. @rathnayake_image_2019 proposed a 3D room simulation library with an additional _OpenGL_ visualization feature.
It allows observing all the reflection paths from the source to the receiver.
Also, the library permits to plot the #acr("RIR") graph, similar to @fig:simulator:background:rir_schema and @fig:simulator:background:rir_plot.

The community has also explored using #acrpl("GPU") to speed up the computation of the #acr("RIR")s.
In their 2011 paper, Savioja et al. @savioja_audio_2011 explored the potential of #acrpl("GPU")s for performing several audio signal processing tasks.
Significant speedups are identified in various algorithms and computations.
For example, computing a two-million-point #acr("FFT") in real-time has been achieved on a #acr("GPU").
Furthermore, the accelerator substantially accelerated operations such as time-domain convolution or multichannel #acrpl("FIR").
Some early works on room acoustic modeling are mentioned in this article.
They rely primarily on wave-based methods and adapt #acr("GPU") implementation of differential equation solvers.
To our knowledge, Fu et al. @fu_gpu-based_2016 were the first to parallelize the #acr("ISM") algorithm on numerous #acr("GPU") cores.
Their performance benchmarks identified a 20 to 120-fold improvement over the CPU implementation.
This effort was broadened by Diaz-Guerra et al. with the _gpuRIR_ library @diaz-guerra_gpurir_2021.
This implementation provides performant custom CUDA kernels for parallelizing the #acr("ISM") technique on the #acr("GPU").
This open-source implementation, in particular, leverages the mixed precision capabilities of modern #acr("GPU") accelerators.
Also, this method innovates by introducing #acrpl("LUT") to avoid unnecessarily re-running costly trigonometric functions.
While not as feature-rich as _Pyroomacoustics_, _gpuRIR_ provides easy-to-use Python bindings to the CUDA code which helps embed it in a more complete pipeline.
The authors have conducted performance testing and found that the #acr("GPU") code was 100x faster than alternative CPU implementations.
This efficient library is thus efficient enough to be used in real-time applications such as virtual or augmented reality.

Although #acr("ISM")-based methods represent a large share of available room acoustic simulation implementations, other approaches have also been used.
Rosen et al. @rosen_interactive_2020 have employed a wave-based modeling technique in their _planeverb_ @rosen_themattrosenplaneverb_2024 library.
Their approach has been described previously in more detail (see @sec:simulator:background:simulation:wave-based).
They relaxed the 3D simulation problem to a planar 2D domain, allowing for significant performance gains.
This method indeed targets real-time applications and is, therefore, implemented in C++.
The authors demonstrate the software's capabilities in challenging, static, and dynamic scenes.
They highlight an eventual porting of the code to #acr("GPU") accelerators as an interesting direction for future works.
The #acr("BST") algorithm @cao_interactive_2016 by Cao et al. illustrates how ray tracing #acr("GA") techniques can also achieve good real-world performance.
The exhaustive testing of their library seem to demonstrate fast and accurate rendering of complex acoustic scenes.
It is also capable of handling dynamic scenes as well as geometries more complex than limited rectangular rooms.
Unfortunately, the implementation is not open-source.

Finally, the ecosystem of room acoustic simulation libraries is rich and vibrant.
Several alternatives coexist and provide various tradeoffs.
Some solutions target the research community and attempt to provide easy-to-use software tools for conducting experiments.
Others focus on more integrated scenarios where performance is crucial.
In this regard, multiple works investigate adapting classical algorithms to modern #acr("GPU") hardware accelerators to achieve state-of-the-art simulation speeds.