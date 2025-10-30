// EXPERIMENTS:
// - 300, WER, omni
// - 301, WER, dir
// - 302, WER, dir, BB from scratch
// - 303, WER, dir, BB pretrained + fine-tuned
// - 304, WER, dir, BB pretrained + frozen
// - 310, ANA, omni
// - 311, ANA, dir


#let pi-still-mfc-wer-omni = 21.13
#let pi-still-rew-wer-omni = 1481
#let pi-still-mfc-wer-dir = 21.37
#let pi-still-rew-wer-dir = 1512

#let pi-random-mfc-wer-omni = 21.16
#let pi-random-rew-wer-omni = -25
#let pi-random-mfc-wer-dir = 22.20
#let pi-random-rew-wer-dir = -22

#let pi-safe-random-mfc-wer-omni = 20.99
#let pi-safe-random-rew-wer-omni = 1420
#let pi-safe-random-mfc-wer-dir = 22.38
#let pi-safe-random-rew-wer-dir = 1408

#let pi-still-orient-mfc-wer-omni = 20.87
#let pi-still-orient-rew-wer-omni = 1495
#let pi-still-orient-mfc-wer-dir = 16.56
#let pi-still-orient-rew-wer-dir = 1789

#let exp-300-mfc-wer = 4.18 // omni
#let exp-300-rew-wer = 2432 // omni
#let exp-301-mfc-wer = 8.01 // dir
#let exp-301-rew-wer = 2302 // dir

#let exp-302-mfc-wer = 22.42 // dir
#let exp-302-rew-wer = 1485 // dir
#let exp-303-mfc-wer = 22.16 // dir
#let exp-303-rew-wer = 1485 // dir
#let exp-304-mfc-wer = 8.02 // dir
#let exp-304-rew-wer = 2302 // dir

// Analytical cost
#let exp-310-mfc-analytical = 6.47 // omni
#let exp-310-rew-analytical = 2033 // omni
#let exp-311-mfc-analytical = 22.53 // dir
#let exp-311-rew-analytical = 1234 // dir

#let exp-310-mfc-wer = "1.50" // omni
#let exp-310-rew-wer = 2586 // omni
#let exp-311-mfc-wer = 16.56 // dir
#let exp-311-rew-wer = 1789 // dir
