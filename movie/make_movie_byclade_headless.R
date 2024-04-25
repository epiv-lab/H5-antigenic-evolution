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

#determines the grid and box limits
#axis on plot: x=< y=^ z=.
lims = list(x=c(-14,12), y=c(-12,14), z=c(-10,16))

#if you just want to have a test drive set below to TRUE
test_drive = TRUE #default FALSE
clade_list = list('C','0','1','2-1','2-2','2-3','2-3-4-4','7', '9') #default list('C','0','1','2-1','2-2','2-3','2-3-4-4','7', '9')
angle_step = 5 #default 5
frame_rate = 50 #default 50
end_angle = 360 #default 360
zoom =4 #default 4, increase if res or video is bad

if (test_drive){
  clade_list = list('C','2-2','2-3-4-4')
  angle_step = 90
  frame_rate = 1
}

do.call(file.remove, list(list.files("./movie_images/", full.names = TRUE)))
clade_counter = 0
counter = 0
angles = seq(0, end_angle, angle_step)

pb = txtProgressBar(min = 0, max = length(clade_list)*length(angles), 
                    initial = 0, title="Generating Scenes", style=3) 


for (clade in clade_list){
  clade_counter = clade_counter + 1
  
  for (angle in seq(0,360,angle_step)){
    rotated_map = rotateMap(map, angle, axis = 'y')
    map_data3js = convert_map_to_data3js(rotated_map, clades_to_add=clade_list[1:clade_counter],
                                         lims=lims)
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
    save3js(map_data3js, map_save_name, rotation=c(0,0,0))
    ss_save_name = paste0(paste0('./movie_images/',as.character(counter)), '.png')
    webshot(map_save_name, ss_save_name, quiet=TRUE, zoom=zoom)
    
    setTxtProgressBar(pb,counter)
    counter = counter + 1
  }
}

if (file.exists("./movies/movie_byclade.mp4")) {
  file.remove("./movies/movie_byclade.mp4")
} 


img_dir = '\'./movie_images/'
cmd = paste0('ffmpeg -r ', as.character(frame_rate), ' -f image2 -s 1920x1080 -i ')
extra_args = ' -vcodec libx264 -crf 25  -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2"' 
cmd = paste0(cmd, img_dir, '%d.png\'', extra_args, ' ./movies/movie_byclade.mp4')

system(cmd)

