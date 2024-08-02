# A(H5) antigenic map and antigenically central antigen design, Kok et al. 2024

Custom code supporting the study by Kok et al., "A vaccine antigen central in influenza A(H5) virus antigenic space confers subtype-wide immunity", in which the first global characterization of the antigenic evolution of A(H5) influenza viruses using antigenic cartography and a unique dataset of over 100 A(H5) antigens and 30 ferret sera was performed. This novel knowledge was then leveraged to design of a broadly protective A(H5) vaccine antigen covering widely antigenic space.

Most of the analyses performed in the study, including the map making and map testing, is available through the R Racmacs library available at https://acorg.github.io/Racmacs/. Additional analyses using code not directly available in the Racmacs libray were performed. Code written for these analyses is available in this repository.

## Bootstrap analysis, piecewise procrustes analysis, movie of antigenic evolution over time

Work flow is to upload a seperate folder for each type of analysis which contains subfolders input, output, visuals.
For instance in the map_making folder input folder would contain titer tables, output folder would contain maps, visuals 
would contain html/png map visuals. Codes for making these would be in the map_making folder directly. So the folder 
tree would look like

```
map_making
 ├───input
 │   └───titer_table1.ace
 ├───output
 │   └───map1.ace
 ├───visuals
 │   └───map1.html
 ├───make_maps.R
 └───visualize_maps.R
```

Other projects can directly use the maps existing in output of map_making to prevent redundant and outdated data floating around.
Keeping only best optimizations for maps since file size limitation < 25MB


## Antibody profiles

Code to make antibody profiles, showing the raw hemagglutination inhibition (HI) reactivity of a serum to antigens in the A(H5) antigenic map. Lines connect the position of the serum with the antigens against which a titer above the assay’s detection limit is observed (i.e. ≥ 10). Antigens and connecting lines are colored by the HI titer as indicated in the bottom-left legend. 
R code using, amongst others, Racmacs and r3js libraries.
