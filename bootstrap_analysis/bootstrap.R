# Setup workspace
rm(list = ls())
library(Racmacs)
set.seed(Sys.time())

bootstrap_repeats = 1000
optimizations_per_repeat = 150
gs = 0.1
conf = 0.68
smoothing = 8
method = "bayesian"

map_path = "./inputs/H5_merge_n3_march_2025.ace"
save_path = "./outputs/bootstrapped_map_bayesian.ace"

map = read.acmap(map_path)
map_with_bootstrap_data = bootstrapMap(
                            map,
                            method=method,
                            bootstrap_repeats = bootstrap_repeats,
                            bootstrap_ags = TRUE,
                            bootstrap_sr = TRUE,
                            reoptimize = TRUE,
                            optimizations_per_repeat = optimizations_per_repeat,
                            ag_noise_sd = 0.7,
                            titer_noise_sd = 0.7,
                            options = list()
                          )
save.acmap(map_with_bootstrap_data, save_path)
