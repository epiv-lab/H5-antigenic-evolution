library(Racmacs)
library(r3js)
library(splines)
library(webshot2)
source('convert_map_to_data3js.R')
source('utils.R')

# disable opengl if not linux (thanks to Mathis)
if (!grepl('linux', version$os)) {
  library(chromote)
  m <- Chromote$new(browser = Chrome$new(args = "--use-angle=gl"))
  set_default_chromote_object (m)
}


name = "map_3D_conservative_sd_1.5_n3"
path = paste0("../map_making/output/", name,".ace")
map_save_name = "./movie_images/temp.html"
map = read.acmap(path)

#movie starts with all the antigens from min_year to start_year
#and then after a 360 rotation displays all the antigens
#from min_year to start_year + window_length and increases
#it by windows_length after each 360 rotation. to make the rotation
#more smooth decrease angle step.

#determines the grid and box limits
#axis on plot: x=< y=^ z=.
lims = list(x=c(-14,12), y=c(-12,14), z=c(-10,16))

#if you just want to have a test drive set below to TRUE
test_drive = TRUE #default FALSE
window_length = 2 #default 5
start_year = 1996 #default 1989
end_year = 2022 #default 2022
angle_step = 2 #default 5
end_angle = 360 #default 360
zoom =4 #default 4, increase if res or video is bad

frame_rate = 50 #lower is slower, combined with angle step below which determines
#total number of frames, this will effect how fast the rotation
#looks. default 50

if (test_drive){
  start_year = 2017
  angle_step = 90
  frame_rate = 1
}

years_list = seq(start_year, end_year, by=window_length)
#angles = seq(0, end_angle, angle_step) #for 360 degree rotation
angles = c(seq(0, 180, 2), rev(seq(2, 178, 2))) #for oscillating movement
do.call(file.remove, list(list.files("./movie_images/", full.names = TRUE)))
counter = 1
pb = txtProgressBar(min = 0, max = length(years_list)*length(angles), 
                    initial = 0, title="Generating Scenes", style=3) 

#### to fix webshot after mac standby
f <- chromote::default_chromote_object()
f$close() 

for (year in years_list){
  
  #in the next rotation take all the years from 1959 to year
  #alternatively you could provide years_list which would be a list of 
  #lists such as list()
  years = seq(1959, year)
  
  for (angle in angles){
    rotated_map = rotateMap(map, angle, axis = 'y')
    map_data3js = convert_map_to_data3js(rotated_map, years_to_add=years,
                                         lims=lims,
                                         antigen_radius = 0.4,
                                         serum_width = 0.8)
   map_data3js <- legend3js(map_data3js,
                             legend = maplegend[,1],
                             fill   = maplegend[,2])

    #convert racmap to data3js so one can add objects to it via r3js. some options
    #which might be useful are:
    #show.map.antigens = TRUE,
    #show.map.sera = TRUE,
    #show.grid = TRUE,
    #show.box = TRUE,
    #antigen_radius = 0.75,
    #antigen_opacity = 0.4,
    #antigen_shineness = 10,
    #antigen_shadow_opacity = 0.1,
    #antigen_shadow_color = NULL,
    #serum_width = 2.5,
    #serum_opacity = 1,
    #serum_linewidth = 0.2,
    save3js(map_data3js, map_save_name, rotation=c(0,1,0)) #default rotation = c(0,0,0)
    ss_save_name = paste0(paste0('./movie_images/',as.character(counter)), '.png')
    webshot(map_save_name, ss_save_name, quiet=TRUE, zoom=zoom, vwidth = 744) #vwidth to make it square
    
    setTxtProgressBar(pb,counter)
    counter = counter + 1
  }
}

if (file.exists("./movies/movie_byyear.mp4")) {
  file.remove("./movies/movie_byyear.mp4")
} 

img_dir = '\'./movie_images/'
cmd = paste0('ffmpeg -r ', as.character(frame_rate), ' -f image2 -s 1920x1080 -i ')
extra_args = ' -vcodec libx264 -crf 25  -pix_fmt yuv420p -vf "setpts=2.0*PTS" -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2"' 
cmd = paste0(cmd, img_dir, '%d.png\'', extra_args, ' ./movies/movie_byyear.mp4')

system(cmd)

