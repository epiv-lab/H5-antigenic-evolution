### Code to generate antigenic map visualization with antigens colored based on piecewise procrustes distance, as in Data S3A (one piece) and Data S3B (two pieces). 
### Analysis described in supplementary text S3
rm(list = ls())
library(Racmacs)
map <- read.acmap("input/map.ace") #edit based on input map Sina

#read in files
ag_ppc_1 <- read.csv("./output/ag_ppc_data_1.csv", row.names = 1)
ag_ppc_2 <- read.csv("./output/ag_ppc_data_2.csv", row.names = 1)


#compute proc length/norm
ag_ppc_1 <- cbind(ag_ppc_1,  
                  dist = NA)
for (i in 1:nrow(ag_ppc_1)) {
  ag_ppc_1[i,6] <- norm(ag_ppc_1[i,1:4], type = "2") #distance proc in 4D
}

ag_ppc_2 <- cbind(ag_ppc_2,  
                  dist = NA)
for (i in 1:nrow(ag_ppc_2)) {
  ag_ppc_2[i,6] <- norm(ag_ppc_2[i,1:4], type = "2") #distance proc in 4D
}


#two color pallets
rocket_pal <- c("#FAEBDDFF", "#F7CEB2FF", "#F6B089FF", "#F58F66FF", "#F26C4AFF", "#EB463EFF", "#D72649FF", "#BB1656FF", "#9A1B5BFF", "#791F59FF", "#591E50FF", "#3B1A41FF", "#1E122DFF", "#03051AFF") #made using viridis::viridis(n=14, option = "rocket", direction = -1)

mako_pal <- c("#DEF5E5FF", "#B6E5C4FF", "#81D8B0FF", "#50C6ADFF", "#3CB2ADFF", "#359BAAFF", "#3485A5FF", "#3670A0FF", "#3B589AFF", "#414184FF", "#3C3162FF", "#312141FF", "#201321FF", "#0B0405FF") #made using viridis::viridis(n=14, option = "mako", direction = -1)

ag_ppc_1$col <- rocket_pal[as.numeric(cut(ag_ppc_1$dist, breaks = seq(0, 6.5, 0.5)))]
ag_ppc_2$col0 <- rocket_pal[as.numeric(cut(abs(ag_ppc_2$dist), breaks = seq(0, 6.5, 0.5)))]
ag_ppc_2$col1 <- mako_pal[as.numeric(cut(abs(ag_ppc_2$dist), breaks = seq(0, 6.5, 0.5)))]



## Map colored by one piece (Data S3A)
map_ag_ppc_1 <- map
srOutline(map_ag_ppc_1) <- "black"
agSize(map_ag_ppc_1) <- 3

agFill(map_ag_ppc_1) <- ag_ppc_1$col[match(agNames(map), rownames(ag_ppc_1))] 

map_ag_ppc_1 <- setLegend(map_ag_ppc_1, 
                          legend = rev(seq(0, 6.5, 1)), 
                          fill   = rev(c("#FAEBDDFF", "#F6AA82FF", "#F06043FF", "#CB1B4FFF", "#841E5AFF", "#3F1B44FF", "#03051AFF"))) #made using viridis::viridis(n=7, option = "rocket", direction = -1)

Racmacs::view(map_ag_ppc_1, options = RacViewer.options(point.opacity = 0.8))

## Map colored by two pieces (Data S3B)
map_ag_ppc_2 <- map
srOutline(map_ag_ppc_2) <- "black"
agSize(map_ag_ppc_2) <- 3

agFill(map_ag_ppc_2)[ag_ppc_2$label == 0] <- ag_ppc_2$col0[ag_ppc_2$label == 0]
agFill(map_ag_ppc_2)[ag_ppc_2$label == 1] <- ag_ppc_2$col1[ag_ppc_2$label == 1]


map_ag_ppc_2 <- setLegend(map_ag_ppc_2, 
                          legend = c(rev(seq(0, 4, 1)),
                                     "",
                                     rev(seq(0, 4, 1))), 
                          fill   = c(rev(c("#FAEBDDFF", "#F6AA82FF", "#F06043FF", "#CB1B4FFF", "#841E5AFF", "#3F1B44FF", "#03051AFF")[1:5]), #made using viridis::viridis(n=7, option = "rocket", direction = -1)
                                     "transparent",
                                     rev(c("#DEF5E5FF", "#78D6AEFF", "#38AAACFF", "#357BA2FF", "#40498EFF", "#342346FF", "#0B0405FF"))[1:5])) #made using viridis::viridis(n=7, option = "mako", direction = -1)[1:5]

Racmacs::view(map_ag_ppc_2, options = RacViewer.options(point.opacity = 0.8))
