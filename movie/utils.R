
clade_order = list('C','0','1','2-1','2-2','2-3','2-3-4-4','7',
                   '9')
color_to_clade <- list(
                      '#00AFFF' = '2-3-4-4',
                      '#A208BD' = '2-3',
                      '#00FF00' = '2-1',
                      '#FF0000' = '2-2',
                      '#0000FF' = 'C',
                      '#F894F8' = '0',
                      '#F9D004' = '1',
                      '#00FFE1' = '9',
                      '#000000' = '7'
                      )

sr_name_to_clade <- list(
  'A/CHICKEN/WESTJAVA/119A/2010' = '2-1',
  'A/GOOSE/EASTERNCHINA/1112A/2011' = '2-3-4-4',
  'A/CHICKEN/EASTJAVA/121B/2010' = '2-1',
  'A/CAMBODIA/X0810301B/2013' = '1',
  'A/CHICKEN/SOUTHSULAWESI/157A/2011' = '2-1',
  'A/DUCK/BANGLADESH/19097B/2013' = '2-3',
  'A/DUCK/HONGKONG/205B/1977' = 'C',
  'A/TURKEY/TURKEY/1A/2005' = '2-2',
  'A/CHICKEN/NORTHSUMATRA/072A/2010' = '2-1',
  'A/CHICKEN/CHIPING/0321B/2014' = '7',
  'A/CHICKEN/CENTRALJAVA/051B/2009' = '2-1',
  'A/HONGKONG/156A/1997' = '0',
  'A/HONGKONG/483B/1997' = '0',
  'A/VIETNAM/1194D/2004' = '1',
  'A/ANHUI/1C/2005' = '2-3',
  'A/INDONESIA/5F/2005' = '2-1',
  'A/IRAQ/755A/2006' = '2-2',
  'A/GUIZHOU/1A/2013' = '2-3',
  'A/EGYPT/NO1753B/2014' = '2-2',
  'A/GUANGZHOU/39715A/2014' = '2-3-4-4',
  'A/MALLARD/NETHERLANDS/3A/1999' = 'C',
  'A/MALLARD/SWEDEN/49B/2002' = 'C',
  'A/SICHUAN/26221A/2014' = '2-3-4-4',
  'A/GYRFALCON/WASHINGTON/41088-6B/2014' = '2-3-4-4',
  'A/CHICKEN/NETHERLANDS/EMC-3A/2014' = '2-3-4-4',
  'A/CHICKEN/WESTJAVA/EURRG30A/2007' = '2-1',
  'A/CHICKEN/JIANGSU/K0101B/2010' = '2-3',
  'A/DUCK/VIETNAM/NCVD-1283A/2012' = '2-3'
)

calc_map_lims <- function(lims, padding = 1, round_even = TRUE){
  lims[1] <- lims[1] - padding
  lims[2] <- lims[2] + padding
  if(round_even){
    d  <- diff(lims)
    dd <- ceiling(d) - d
    lims[1] <- lims[1] - dd/2
    lims[2] <- lims[2] + dd/2
  }
  lims
}


setup <- function(
    xlim,
    ylim,
    zlim,
    aspect.z,
    show.grid = TRUE,
    show.box = TRUE,
    options
){
  

  # Open a new r3js plot
  data3js <- r3js::plot3js.new()
  
  ## Set plot window
  data3js <- r3js::plot3js.window(
    data3js,
    xlim = xlim,
    ylim = ylim,
    zlim = zlim,
    aspect = c(1, 1, aspect.z)
  )
  
  ## Set box
  if (show.box) {
    data3js <- r3js::box3js(
      data3js,
      col   = "grey80",
      sides = c("x","y","z")
    )
  }
  
  ## Add a side grid
  if (show.grid) {
    data3js <- r3js::grid3js(
      data3js,
      sides = c("x", "y", "z"),
      axes = c("x", "y", "z"),
      at = list("z"=zlim[1]:zlim[2],"x"=xlim[1]:xlim[2], "y"=ylim[1]:ylim[2] ),
      lwd = 1,
      col = "grey95",
    )
  }
  

  # Return the data
  
  data3js = light3js(
    data3js,
    position = c(0,0,10),
    intensity=1,
  )

  
  data3js
  
}

construct_plane <- function(basis, center, data3js, name)
{
  
  N = 7
  coords = matrix(nrow = (2*N+1)*(2*N+1), ncol = 3)
  counter = 1
  
  for (i in -N:N){
    for (j in -N:N){
      coords[counter,] <- i*basis[,1] + j*basis[,2] + center
      counter = counter + 1
    }
  }
  
  x = coords[,1]
  y = coords[,2]
  z = matrix(coords[,3], nrow=2*N+1, ncol=2*N+1)

  
  for (i in seq(from=-N, to=N)){
    p0 = center - N*basis[,1] + i*basis[,2]
    p1 = center + N*basis[,1] + i*basis[,2]

    data3js <- lines3js(
      data3js = data3js,
      x = c(p0[1], p1[1]),
      y = c(p0[2], p1[2]),
      z = c(p0[3], p1[3]),
      lwd=1,
      col='black',
      toggle=name
    )
    
    p0 = center - N*basis[,2] + i*basis[,1]
    p1 = center + N*basis[,2] + i*basis[,1]
    
    data3js <- lines3js(
      data3js = data3js,
      x = c(p0[1], p1[1]),
      y = c(p0[2], p1[2]),
      z = c(p0[3], p1[3]),
      lwd=1,
      col='black',
      toggle=name
    )
    
  }
  
  return (data3js)
  
  
}
  

get_year <- function(name){
  
  if (grepl('_',name)){
    name = strsplit(name,'_')[[1]]
  }
  
  year = strsplit(name, '/')[[1]]
  year = year[[length(year)]]
  
  if (nchar(year)==4){
    return (as.integer(year))
    
  }
  else if (nchar(year)==2){
    if (as.integer(year)<=20){
      return (as.integer(paste0('20',year)))}
    else{
      return (as.integer(paste0('19',year)))}
    
  }
  
}