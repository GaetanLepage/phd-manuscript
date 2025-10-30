#import "../../../../utils.typ": *
#import "utils.typ": *
#import "../../_notations.typ": *

#figure(
  table(
    // settings
    columns: 7,
    stroke: none,
    align: left + horizon,

    // header
    toprule,

    table.header(
      table.cell(rowspan: 2)[aggregation method],
      table.cell(rowspan: 2)[#doa-t],
      header-pred-spectrum,
      [#h(1em)],
      header-gt-spectrum,

      header-prec,
      header-recall,
      [],
      header-prec,
      header-recall,
    ),

    midrule,

    // rows
    // blending                        doa_threshold   prec        recall      ||    prec        recall
    table.cell(rowspan: 5)[#psi-avg], [0.2], [55.40], [28.78], [], [54.40], [36.87],
    [0.4], [66.00], [39.03], [], [61.43], [45.47],
    [0.6], [67.31], [43.97], [], [68.59], [53.32],
    [0.8], [71.09], [45.86], [], [77.72], [62.03],
    [1.0], [*72.33*], [*46.60*], [], [*96.02*], [*77.70*],
    midrule,
    table.cell(rowspan: 5)[#psi-dnn], [0.2], [83.27], [*50.02*], [], [99.07], [88.30],
    [0.4], [86.34], [49.86], [], [99.43], [88.89],
    [0.6], [*86.60*], [46.68], [], [99.57], [90.46],
    [0.8], [84.89], [44.33], [], [99.70], [90.18],
    [1.0], [83.70], [43.74], [], [*99.74*], [*90.69*],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the ASSL performance for different #_doa threshold (#doa-t) values.
  ],
)
<table:active_ssl:results:doa_threshold>
