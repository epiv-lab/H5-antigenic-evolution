library(Racmacs)
library(r3js)
library(splines)
library(webshot2)
source('convert_map_to_data3js.R')
source('utils.R')

name = "map_3D_conservative_sd_1.5_n3"
path = paste0("../map_making/output/", name,".ace")
map_save_name = "./movie_images/temp.html"
map = read.acmap(path)

#movie starts with all the antigens from min_year to start_year
#and then after a 360 rotation displays all the antigens
#from min_year to start_year + window_length and increases
#it by windows_length after each 360 rotation. to make the rotation
#more smooth decrease angle step.

#if you just want to have a test run and not wait for a long time
#set max_year to 1994 and angle_step to 20

window_length = 5
min_year = 1959
max_year = 2022
start_year = 1989 
angle_step = 5
end_angle = 360
years_list = seq(start_year, max_year, by=window_length)

if (!(max_year  %in% years_list)){
  years_list[[length(years_list)]] = max_year
}

lims = list(x=c(-12,6), y=c(-10,8), z=c(-7,12))
do.call(file.remove, list(list.files("./movie_images/", full.names = TRUE)))
counter = 1

for (year in years_list){
  
  #in the next rotation take all the years from 1959 to year
  #alternatively you could provide years_list which would be a list of 
  #lists such as list()
  years = seq(1959, year)
  
  for (angle in seq(0, end_angle, angle_step)){
    rotated_map = rotateMap(map, angle, axis = 'z')
    map_data3js = convert_map_to_data3js(rotated_map, years_to_add=years,
                                         lims=lims)
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
    save3js(map_data3js, map_save_name)
    ss_save_name = paste0(paste0('./movie_images/',as.character(counter)), '.png')
    webshot(map_save_name, ss_save_name)
    counter = counter + 1
  }
}

if (file.exists("./movies/movie_byyear.mp4")) {
  file.remove("./movies/movie_byyear.mp4")
} 

img_dir = '\'/home/avicenna/Dropbox/data_analysis/H5/adinda/interactive_visualization/code/movie_images/'
cmd = 'ffmpeg -r 60 -f image2 -s 1920x1080 -i '
cmd = paste0(cmd, img_dir, '%d.png\'',' -vcodec libx264 -crf 25  -pix_fmt yuv420p -vf "setpts=2.0*PTS" ./movies/movie_byyear.mp4')

system(cmd)

