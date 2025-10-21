#import "/utils.typ": *
#import "utils.typ": *
#import "../../_notations.typ": *

#figure(
  table(
    // SETTINGS
    columns: 6,
    stroke: none,
    align: left + horizon,

    // HEADER
    toprule,

    table.header(
      table.cell(rowspan: 2)[#fov (m)],
      //colspanx(2)[#align(center)[$hat(o)_t$]],
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

    // ROWS
    // FoV    Prec        Recall      ||  Prec        Recall
    [2], [38.99], [19.12], [], [49.43], [22.30],
    [4], [72.26], [36.51], [], [91.10], [49.43],
    [8], [*85.84*], [49.98], [], [98.94], [84.02],
    [16], [85.36], [*52.65*], [], [*99.74*], [*90.50*],

    bottomrule,
  ),
  placement: top,
  kind: table,
  caption: [
    Comparison of the ASSL performance for different FoV values.
  ],
)
<table:active_ssl:results:fov>
