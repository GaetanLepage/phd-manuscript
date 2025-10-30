#import "../../../utils.typ": *

#let sample_index = $i$

// #let pos(char, index) = $char^(#sample_index)_index)$
// #let pos(char, index) = $char_(#sample_index index)$
#let pos(char, index) = $char_(#sample_index, index)$

#let gt(index) = $#pos($X$, index)$
#let pred(index) = $#pos($hat(X)$, index)$
#let dist(index) = $norm(#pred(index) - #gt(index))_2$
$
  m(
    hat(X)^i_k,
    X^i_j
  ) = cases(
    1
    #h(2em) && "if" #dist($k$) < delta \
    // estimation is "close enough"
    && #h(1em)"and" k = limits("argmin")_(k' in {1, dots, hat(z_i)}) #dist($k'$), // it is the closest of all
    0 && "otherwise,"
  )
$
where $#pred($k$) = (#pos($hat(x)$, $k$), #pos($hat(y)$, $k$))$ is the estimated position of the $k$-th detected source in sample $i$ and #gt($j$) is the ground truth position of the $j$-th real source in this sample.
$z_i$ denotes the number of real sources in sample $i$ while $hat(z)_i$ is the number of detections.
