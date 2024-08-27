#import "../3_ssl/3_multi_source/_notations.typ": header-prec, header-recall

// Aggregated Map
#let AM = $cal(M)_t$
// Target for AM
#let AM-targ = $cal(M)_t^*$
// Predicted sources locations
#let predictions = $hat(X)_t$

#let psi-avg = $Psi_"avg"$
#let psi-dnn = $Psi_("DNN"(theta))$