library(Racmacs)
library(r3js)
library(splines)

source('convert_map_to_data3js.R')

name = "H5_full_new_ck_nl"
path = paste0(name,".ace")
save_name = paste0(paste0("../",name),".html")
map = read.acmap(path)

map_data3js = convert_map_to_data3js(map)
#convert racmap to data3js so one can add objects to it via r3js. some options
#which might be useful are:
#show.map.antigens = TRUE,
#show.map.sera = TRUE,
#show.axis = FALSE,
#show.sidegrid = FALSE,
#show.basegrid = FALSE,
#antigen_radius = 0.75,
#antigen_opacity = 0.4,
#antigen_shineness = 10,
#antigen_shadow_opacity = 0.1,
#antigen_shadow_color = NULL,
#serum_width = 2.5,
#serum_opacity = 1,
#serum_linewidth = 0.2,
r3js(map_data3js)
save3js(map_data3js, save_name)
