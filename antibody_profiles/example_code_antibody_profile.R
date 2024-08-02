rm(list = ls())

#load packages
library(Racmacs)
library(r3js)
#packages also needed: grDevices, viridis

#input code & data
source("antibody_profile.R")
h5_map <- read.acmap("input/H5_map.ace")

antibody_profile(map = h5_map, 
                 serum = 14, #the index number of the serum
                 na_titers = T) #show antigens for which the serum has no titer in transparent whitegrey 


antibody_profile(map = h5_map, 
                 serum = "A/IRAQ/755A/2006", #the serum name
                 na_titers = F) #show antigens for which the serum has no titer in transparent whitegrey 


save3jsWidget(antibody_profile(map = h5_map, 
                               serum = 14, 
                               na_titers = T),
              "output/example_antibody_profile.html")
