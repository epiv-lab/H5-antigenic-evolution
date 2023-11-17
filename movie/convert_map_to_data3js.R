source('./utils.R')
library(ablandscapes)


convert_map_to_data3js <- function(
    map,
    xlim,
    ylim,
    zlim,
    show.map.antigens = TRUE,
    show.map.sera = TRUE,
    show.sidegrid = TRUE,
    show.basegrid = TRUE,
    show.toggle = TRUE,
    antigen_radius = 0.75,
    antigen_opacity = 0.5,
    antigen_shineness = 10,
    antigen_shadow_opacity = 0.1,
    antigen_shadow_color = NULL,
    serum_width = 2.5,
    serum_opacity = 1,
    serum_linewidth = 0.2,
    aspect.z = 1,
    padding = 1,
    clades_to_add = NULL,
    years_to_add = NULL,
    lims = NULL,
    options = list()
) {

  map_coords <- rbind(
    Racmacs::agCoords(map),
    Racmacs::srCoords(map)
  )

  if (is.null(lims)){
    xlim <- calc_map_lims(range(map_coords[,1]), padding = padding)
    ylim <- calc_map_lims(range(map_coords[,2]), padding = padding)
    zlim <- calc_map_lims(range(map_coords[,3]), padding = padding)
  }
  else{
    xlim = unlist(lims['x'])
    ylim = unlist(lims['y'])
    zlim = unlist(lims['z'])
  }
  
  data3js <- setup(
    xlim     = xlim,
    ylim     = ylim,
    zlim     = zlim,
    aspect.z = aspect.z,
    show.sidegrid = show.sidegrid,
    show.basegrid = show.basegrid,
    options  = options
  )


  # Get the map data
  map_ag_coords  <- Racmacs::agCoords(map)
  map_sr_coords  <- Racmacs::srCoords(map)
  map_ag_fill    <- Racmacs::agFill(map)
  map_sr_outline <- Racmacs::srOutline(map)
  map_ag_names   <- Racmacs::agNames(map)
  map_sr_names   <- Racmacs::srNames(map)
  map_ag_shown   <- Racmacs::agShown(map)
  map_sr_shown   <- Racmacs::srShown(map)
  
  # Get clades and years
  ag_clades = lapply(agFill(map), 
                     function(elem) { return(color_to_clade[[elem]])})
                     
  sr_clades = lapply(srNames(map), 
                     function(elem) {return(sr_name_to_clade[[elem]])})

  ag_years = lapply(lapply(agNames(map), get_year), as.integer)
  
  sr_years = lapply(lapply(srNames(map), get_year), as.integer)
                    
  # Get the plot pars
  pars <- do.call(ablandscape.par, options)
  ## Add antigens and sera
  
  if (is.null(clades_to_add) && (is.null(years_to_add))){
    stop("clade_to_add or years_to_add must be supplied.")
  }
  else if(! is.null(clades_to_add)){
    to_add = clades_to_add
    to_check_ag = ag_clades
    to_check_sr = sr_clades
  }
  else if (! is.null(years_to_add)){
    to_add = years_to_add
    to_check_ag = ag_years
    to_check_sr = sr_years
  }
  
  if(show.map.antigens){
    
    for (level in to_add){
      
      I = which(to_check_ag == level)
      
      for (n in I){
        data3js <- r3js::sphere3js(
          data3js,
          x          = map_ag_coords[n,1],
          y          = map_ag_coords[n,2],
          z          = map_ag_coords[n,3],
          radius     = antigen_radius,
          col        = map_ag_fill[n],
          opacity    = antigen_opacity,
          shininess = antigen_shineness,
          toggle     = paste0(to_add[[1]], "-", tail(to_add,n=1)),
          depthWrite = FALSE,
          label = agNames(map)[[n]]
        )  
        
      }
      
    }
  }
    
    if(show.map.sera){
      
      for (level in to_add){
        
        I = which(to_check_sr == level)
        
        if (show.toggle){
          toggle = paste0(to_add[[1]], "-", tail(to_add,n=1))
        }
        else{toggle=NA}
        
        for (n in I){
          data3js <- r3js::points3js(
            data3js,
            x          = map_sr_coords[n,1],
            y          = map_sr_coords[n,2],
            z          = map_sr_coords[n,3],
            size       = serum_width,
            col        = map_sr_outline[n],
            opacity    = serum_opacity,
            lwd        = serum_linewidth,
            highlight  = list(col = "red"),
            label      = map_sr_names[n],
            toggle     = toggle,
            depthWrite = FALSE,
            shape      = "cube open"
          )  
          
        }
        
      }
    }
  
  # Return new plot data
  return (data3js)
}
