
###### Antibody profile #####

## Map includes the serum for which landscape should be plotted
## Serum should indicate serum number or name
## Na titers: show antigens with NA titer to serum in a transparant grey-ish color (TRUE) or don't display these (FALSE)


### Function to remove transformation
remove_transformation <- function(map){
  
  coords =   ptCoords(map) %*% t(mapTransformation(map)) %*% t(mapTransformation(map))
  ptCoords(map) = coords
  
  return (map)
}


### Function to plot map as r3js object
plot_acmap3js <- function(map){
  ### Subset map
  map <- subsetMap(
    map,
    antigens = which(!is.na(agCoords(map)[,1])),
    sera = which(!is.na(srCoords(map)[,1]))
  )
  
  ### Setup plot
  plot_margin <- 3
  xlim <- c(floor(min(agCoords(map)[,1])) - plot_margin, ceiling(max(agCoords(map)[,1])) + plot_margin)
  ylim <- c(floor(min(agCoords(map)[,2])) - plot_margin, ceiling(max(agCoords(map)[,2])) + plot_margin)
  zlim <- c(floor(min(agCoords(map)[,3])) - plot_margin, ceiling(max(agCoords(map)[,3])) + plot_margin)
  
  data3js <- r3js::plot3js.new()
  data3js <- r3js::plot3js.window(data3js,
                                  xlim = xlim,
                                  ylim = ylim,
                                  zlim = zlim,
                                  aspect = c(1, 1, 1))
  
  data3js <- r3js::box3js(data3js, col = "grey70")
  
  ### Add background grid
  data3js <- r3js::grid3js(data3js,
                           axes = "x",
                           at = list(x = min(xlim):max(xlim)),
                           col  = "grey90")
  data3js <- r3js::grid3js(data3js,
                           axes = "y",
                           at = list(y = min(ylim):max(ylim)),
                           col  = "grey90")
  data3js <- r3js::grid3js(data3js,
                           axes = "z",
                           at = list(z = min(zlim):max(zlim)),
                           col  = "grey90")
  
  
  ### Add antigens
  for(x in 1:length(agShown(map))){
    if(agShown(map)[x]){
      if(agFill(map)[x] != "transparent"){
        data3js <- r3js::points3js(data3js,
                                   x = agCoords(map)[x,1],
                                   y = agCoords(map)[x,2],
                                   z = agCoords(map)[x,3],
                                   col = agFill(map)[x],
                                   label = agNames(map)[x],
                                   highlight = list(size = agSize(map)[x]*1.2),
                                   size = agSize(map)[x]*0.75,
                                   shape = "sphere",
                                   shininess = 0.2, 
                                   lwd  = 0.01) 
      }
    }
  }
  
  ### Add sera - not used in antibody profiles
  for(x in 1:length(srShown(map))){
    if(srShown(map)[x]){
      
      if(srFill(map)[x] != "transparent"){
        data3js <- r3js::points3js(data3js,
                                   x = srCoords(map)[x,1],
                                   y = srCoords(map)[x,2],
                                   z = srCoords(map)[x,3],
                                   col = srFill(map)[x],
                                   label = srNames(map)[x],
                                   highlight = list(size = srSize(map)[x]*1.2),
                                   size = srSize(map)[x])
      }
      if(srOutline(map)[x] != "transparent"){
        data3js <- r3js::points3js(data3js,
                                   x = srCoords(map)[x,1],
                                   y = srCoords(map)[x,2],
                                   z = srCoords(map)[x,3],
                                   col = srOutline(map)[x],
                                   label = srNames(map)[x],
                                   highlight = list(size = srSize(map)[x]*1.2),
                                   size = srSize(map)[x]*0.5,
                                   lwd  = srOutlineWidth(map)[x]*0.4,
                                   shape = "cube open") 
      }
      
    }
  }
  
  # Return the plot data
  data3js
  
}

### Color pallete for antibody profiles
col_range <- seq(from = -1, to = 7, length.out = 110)
#done using viridis::viridis(n=length(col_range), option = "rocket", direction = -1)
col_val <- c("#FAEBDDFF", "#FAE7D7FF", "#F9E4D3FF", "#F9E0CDFF", "#F9DDC8FF", "#F8D9C4FF", "#F8D6BEFF", "#F8D2B9FF", "#F7CFB4FF", "#F7CCAFFF",
              "#F7C8A9FF", "#F7C5A5FF", "#F6C19FFF", "#F6BD9AFF", "#F6B995FF", "#F6B691FF", "#F6B28CFF", "#F6AE87FF", "#F6AB83FF", "#F6A77FFF",
              "#F6A37AFF", "#F6A077FF", "#F69C72FF", "#F5976EFF", "#F5946BFF", "#F59067FF", "#F58B63FF", "#F58860FF", "#F4835CFF", "#F47F58FF",
              "#F47C55FF", "#F37751FF", "#F3734EFF", "#F26F4CFF", "#F26A48FF", "#F16646FF", "#F16244FF", "#F05D42FF", "#EF5840FF", "#EE543FFF",
              "#ED4F3EFF", "#EC4A3EFF", "#EB453EFF", "#E8413EFF", "#E73D3FFF", "#E53940FF", "#E23542FF", "#E03143FF", "#DE2D44FF", "#DB2A46FF",
              "#D82748FF", "#D62349FF", "#D2204CFF", "#CF1E4DFF", "#CC1C4EFF", "#C91951FF", "#C51852FF", "#C21753FF", "#BD1655FF", "#BA1656FF",
              "#B61657FF", "#B31758FF", "#AF1759FF", "#AB185AFF", "#A7195AFF", "#A3195BFF", "#9F1A5BFF", "#9B1B5BFF", "#971C5BFF", "#931C5BFF",
              "#8E1D5BFF", "#8B1D5BFF", "#871E5BFF", "#821E5AFF", "#7F1E5AFF", "#7B1F59FF", "#761F58FF", "#731F58FF", "#6F1F57FF", "#6B1F56FF",
              "#681F55FF", "#641F54FF", "#601F52FF", "#5C1E51FF", "#581E4FFF", "#541E4EFF", "#511E4DFF", "#4D1D4BFF", "#491D49FF", "#461C48FF",
              "#421B45FF", "#3F1B43FF", "#3C1A42FF", "#37193FFF", "#34193DFF", "#31183BFF", "#2D1738FF", "#2A1636FF", "#271534FF", "#231331FF",
              "#20122EFF", "#1C112CFF", "#190F29FF", "#160E27FF", "#120D25FF", "#0F0B22FF", "#0B0920FF", "#08081EFF", "#05061BFF", "#03051AFF")


### Function to generate antibody profiles

antibody_profile <- function(map, serum, na_titers = F){
  map <- remove_transformation(map)
  #### get serum index number if input is name
  if (is.character(serum)){ 
    serum <- grep(serum, srNames(map))
  }
  #### Don't plot sera
  srShown(map) <- F
  
  #### All antigens white-ish to start with
  agFill(map) <- "#FFFFFF80"
  
  #### Get log titers of serum for landscape
  logtiters <- logtiterTable(map)[,serum]
  
  #### Don't show antigens for which we don't have the titer if na_titer = F
  #### If na_titer = T, these antigens will be plotted in a transparant grey-ish color. 
  if (na_titers == F){
   agShown(map)[which(is.na(logtiters))] <- F
  }
  
  #### Color map antigens by (mean) log titer
  color_map <- function(map, 
                        log_titers){
    
    for(x in seq_along(log_titers)){
      if(!is.na(log_titers[x])){
        agFill(map)[x] <- col_val[which.min(abs(log_titers[x] - col_range))]
      }
    }
    
    map
    
  }  
  
  plotmap <- color_map(map, logtiters)
  
  #### serum position
  response_center <- srCoords(map)[serum,]
  
  #### make r3js object using function above
  data3js <- plot_acmap3js(plotmap)
  ag_measurable <- which(logtiters>= 0)
  
  for(agnum in ag_measurable){
    ag_coords <- agCoords(plotmap)[agnum,]
    ag_col    <- agFill(plotmap)[agnum]
    data3js <- lines3js(
                data3js,
                x = c(response_center[1], ag_coords[1]),
                y = c(response_center[2], ag_coords[2]),
                z = c(response_center[3], ag_coords[3]),
                col      = ag_col,
                geometry = TRUE,
                lwd = 2
              )}
  
  #### make legend
  max_val <- ceiling(max(logtiters, na.rm = T))
  data3js <- legend3js(
    data3js,
    legend = rev(c("<10", 2^(0:7)*10)),
    fill   = rev(sapply(-1:7, function(x){
      col_val[which.min(abs(x - col_range))]
    }))
  )
  
  ### adapt color and shading appearance
  data3js <- light3js(data3js, intensity = 1, type = "ambient")
  data3js <- light3js(data3js, position = c(1, -1, 0), intensity = -1.2)
  r3js(data3js, rotation = c(0,0,0)) #can adapt to rotation=c(0,1,0)
  
}


