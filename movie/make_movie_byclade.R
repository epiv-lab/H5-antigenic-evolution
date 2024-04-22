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


#if you want to have a test run but dont want to wait too much
#set clade_list to list('C','0') and angle_step to 10
clade_list = list('C','0','1','2-1','2-2','2-3','2-3-4-4','7', '9')
counter = 0
clade_counter = 0
lims = list(x=c(-12,6), y=c(-10,8), z=c(-7,12))
angle_step = 5
do.call(file.remove, list(list.files("./movie_images/", full.names = TRUE)))

for (clade in clade_list){
  clade_counter = clade_counter + 1
  
  for (angle in seq(0,360,angle_step)){
    rotated_map = rotateMap(map, angle, axis = 'z')
    map_data3js = convert_map_to_data3js(rotated_map, clades_to_add=clade_list[1:clade_counter],
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

if (file.exists("./movies/movie_byclade.mp4")) {
  file.remove("./movies/movie_byclade.mp4")
} 


img_dir = '\'/home/avicenna/Dropbox/data_analysis/H5/adinda/interactive_visualization/code/movie_images/'
cmd = 'ffmpeg -r 60 -f image2 -s 1920x1080 -i '
cmd = paste0(cmd, img_dir, '%d.png\'',' -vcodec libx264 -crf 25  -pix_fmt yuv420p -vf "setpts=2.0*PTS" ./movies/movie_byclade.mp4')

system(cmd)

