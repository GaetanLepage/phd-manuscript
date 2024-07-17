#import "@preview/acrostiche:0.3.2": *
#import "@preview/minitoc:0.1.0": *

#let comment(name, body, color: red) = {
  set text(color)
  [\ *>>> #name:* #body\ ]
}

#let chris(body) = {
  comment("Chris", body, color: red)
}
#let laurent(body) = {
  comment("Laurent", body, color: green)
}
#let xavi(body) = {
  comment("Xavi", body, color: orange)
}
#let gaet(body) = {
  comment("Gaétan", body, color: blue)
}