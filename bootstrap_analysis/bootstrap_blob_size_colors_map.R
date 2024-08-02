### Code to generate antigenic map visualization with antigens colored based on bootstrap blob size, as in Data S3F. 
### Analysis described in supplementary text S3

rm(list = ls())
library(Racmacs)
library(dplyr)   
#files
ag_boot_vol <- read.csv("./tables/vol_ag.csv")
map <- read.acmap("./input/H5_map.ace") #edit based on input map Sina

#convert NA to 0
ag_boot_vol[is.na(ag_boot_vol)] <- 0

#convert volumes to radii
ag_boot_radius <- (ag_boot_vol[,c(2,3)]/(4/3*pi))^(1/3)
rownames(ag_boot_radius) <- ag_boot_vol[,1]

#make column of total radius (since some ag have 2 blobs)
ag_boot_radius <- ag_boot_radius %>% mutate(total = X0+X1)


#color pallete (generated using viridis::viridis(n=100, option = "rocket", direction = -1))
rocket_pal <- c("#FAEBDDFF", "#FAE7D7FF", "#F9E3D2FF", "#F9DFCBFF", "#F8DBC6FF", "#F8D7C0FF", "#F8D4BBFF", "#F7D0B5FF", "#F7CCB0FF", "#F7C9AAFF", "#F7C5A4FF",
                "#F6C09EFF", "#F6BC99FF", "#F6B894FF", "#F6B48FFF", "#F6B08AFF", "#F6AD85FF", "#F6A880FF", "#F6A47BFF", "#F6A077FF", "#F69B72FF", "#F5976EFF",
                "#F5936AFF", "#F58F66FF", "#F58A61FF", "#F4855EFF", "#F4815AFF", "#F47C56FF", "#F37852FF", "#F3734FFF", "#F26E4CFF", "#F26948FF", "#F16546FF",
                "#F06043FF", "#EF5B42FF", "#EF5640FF", "#ED513EFF", "#EC4B3EFF", "#EB463EFF", "#E8413EFF", "#E73D3FFF", "#E43841FF", "#E23442FF", "#DF2F44FF",
                "#DD2C45FF", "#D92847FF", "#D62549FF", "#D3214BFF", "#D01E4DFF", "#CD1C4EFF", "#C81951FF", "#C51852FF", "#C11754FF", "#BD1656FF", "#B91657FF",
                "#B41658FF", "#B01759FF", "#AB185AFF", "#A7185AFF", "#A3195BFF", "#9E1A5BFF", "#9A1B5BFF", "#961C5BFF", "#921C5BFF", "#8C1D5BFF", "#881E5BFF",
                "#841E5AFF", "#801E5AFF", "#7B1F59FF", "#761F58FF", "#721F58FF", "#6E1F57FF", "#6A1F56FF", "#661F54FF", "#621F53FF", "#5E1F52FF", "#591E50FF",
                "#551E4FFF", "#511E4DFF", "#4D1D4BFF", "#491D49FF", "#451C47FF", "#421B45FF", "#3D1A42FF", "#391A41FF", "#35193EFF", "#32183BFF", "#2E1739FF",
                "#2A1636FF", "#271534FF", "#221331FF", "#1F122DFF", "#1B112BFF", "#170F28FF", "#140E26FF", "#100B23FF", "#0D0A21FF", "#08081EFF", "#06071CFF",
                "#03051AFF")
ag_boot_radius$col <- rocket_pal[as.numeric(cut(ag_boot_radius$total, breaks = 100))]

map_bootstrap_cols <- map 
srOutline(map_bootstrap_cols) <- "black"
agSize(map_bootstrap_cols) <- 3
agFill(map_bootstrap_cols) <- ag_boot_radius$col[match(agNames(map), rownames(ag_boot_radius))] 

map_bootstrap_cols <- setLegend(map_bootstrap_cols, 
                                legend = rev(round(seq(min(ag_boot_radius$total), max(ag_boot_radius$total), length.out = 7), digits = 1)), 
                                fill   = rev(c("#FAEBDDFF", "#F6AA82FF", "#F06043FF", "#CB1B4FFF", "#841E5AFF", "#3F1B44FF", "#03051AFF"))) #using viridis::viridis(n=7, option = "rocket", direction = -1)

Racmacs::view(map_bootstrap_cols, options = RacViewer.options(point.opacity = 0.8))


