#import "../3_ssl/3_multi_source/_notations.typ": header-prec, header-recall
#import "/_misc/acrostiche.typ": acr, acrpl

#let fov = acr("FoV")
#let fovs = acrpl("FoV")

// Aggregated Map
#let AM = $cal(M)_t$
// Target for AM
#let AM-targ = $cal(M)_t^*$
#let AM-targ-cont = $overline(cal(M))_t^*$
// Predicted sources locations
#let predictions = $hat(X)_t$

#let doa-t = $tau_o$
#let clip-t = $delta_min$

#let psi-avg = $Psi_"avg"$
#let psi-dnn = $Psi_("DNN"(theta))$
