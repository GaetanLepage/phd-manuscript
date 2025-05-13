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

#let pi-orient-mfc-wer-omni = 20.87
#let pi-orient-rew-wer-omni = 1495
#let pi-orient-mfc-wer-dir = 16.56
#let pi-orient-rew-wer-dir = 1789

#let exp-300-mfc-wer = 5.67 // omni
#let exp-300-rew-wer = 2336 // omni
#let exp-301-mfc-wer = 8.34 // dir
#let exp-301-rew-wer = 2278 // dir

#let exp-302-mfc-wer = 22.78 // dir
#let exp-302-rew-wer = 1473 // dir
#let exp-303-mfc-wer = 22.36 // dir
#let exp-303-rew-wer = 1480 // dir
#let exp-304-mfc-wer = 8.34 // dir
#let exp-304-rew-wer = 2278 // dir

#let exp-310-mfc-wer = 6.49 // omni
#let exp-310-rew-wer = 2023 // omni
#let exp-311-mfc-wer = 23.77 // dir
#let exp-311-rew-wer = 1212 // dir