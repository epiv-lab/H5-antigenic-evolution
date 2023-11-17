library(Racmacs)

colors = list("#1f77b4","#d62728","#9467bd","#8c564b",
              "#7f7f7f","#bcbd22","#17becf")

  
map = read.acmap("../map_making/output/map_3D_conservative_sd_1.5_n4.ace")
compare_sera = TRUE

for (npieces in list(1,2,3,4,5)){
  
  ag_table = read.csv(paste0("./output/ag_ppc_data_",
                              as.character(npieces),".csv"))
  sr_table = read.csv(paste0("./output/sr_ppc_data_",
                              as.character(npieces),".csv"))
  
  ag_labels = ag_table[,6]
  sr_labels = sr_table[,6]
  
  ag_fills = list()
  sr_outlines = list()
  
  for (i in 1:numAntigens(map)){
    ag_fills = append(ag_fills, colors[[ag_labels[[i]]+1]])
  }
  
  if (compare_sera){
    for (i in 1:numSera(map)){
      sr_outlines = append(sr_outlines, colors[[sr_labels[[i]]+1]])
    }
    srOutline(map) <- unlist(sr_outlines)
    srFill(map) <- unlist(sr_outlines)
  }
  
  agFill(map) <- unlist(ag_fills)
  agSize(map) <- 4
  srSize(map) <- 4
  
  export_viewer(map, paste0("./visuals/ppc_", as.character(npieces), ".html"))
  save.acmap(map, paste0("./output/ppc_", as.character(npieces), ".ace"))
  
}