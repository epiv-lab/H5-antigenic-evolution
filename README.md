# A(H5) antigenic map and antigenically central antigen design, Kok et al. 2024

Custom code supporting the study by Kok et al., "A vaccine antigen central in influenza A(H5) virus antigenic space confers subtype-wide immunity", in which the first global characterization of the antigenic evolution of A(H5) influenza viruses was performed using antigenic cartography and a unique dataset of over 100 A(H5) antigens and 30 ferret sera. This novel knowledge was then leveraged to design of a broadly protective A(H5) vaccine antigen covering antigenic space widely.

Most of the analyses performed in the study, including the map making and map testing, are available through the [Racmacs](https://acorg.github.io/Racmacs/) library. Additional analyses using code not directly available in the Racmacs libray were performed. Code written for these analyses is available in this repository.

## Antibody profiles

R code to make antibody profiles, showing the raw hemagglutination inhibition (HI) reactivity of a serum to antigens in the A(H5) antigenic map. Lines connect the position of the serum with the antigens against which a titer above the assay’s detection limit is observed (i.e. ≥ 10). Antigens and connecting lines are colored by the HI titer as indicated in the bottom-left legend. The R code uses Racmacs and r3js libraries.

## Bootstrap analysis

Code to calculate the volumes of Bayesian bootstrap blobs, computed through the ‘bootstrapBlobs’ function in Racmacs. Python code using [PyRacmacs](https://github.com/iAvicenna/PyRacmacs) and fitting a triangular mesh to each bootstrap point using the package [trimesh](https://trimsh.org/) (version 3.2.0). R code used in Kok et al. 2024 to color-code antigens in the A(H5) antigenic map according to bootstrap volume radii (Data S3F) is also provided. 

## Movie of antigenic evolution over time

R code to generate a movie where antigens and sera appear chronologically in the A(H5) antigenic map, allowing to retrace the evolution of A(H5) antigenic space over time. Used in Kok et al. 2024 for Movie 1. The R code uses, amongst others, Racmacs and r3js libraries.

## Piecewise procrustes analysis

Given two maps and n the number of pieces, piecewise Procrustes aims to find the optimal partition of the coordinates into n pieces such that the sum of Procrustes errors is minimized. In essence, the different pieces of the map are allowed to move freely relative to each other when transitioning between dimensions. If one can obtain a lower Procrustes error between a lower and higher dimensional map when using few pieces, the lower dimensional map can be embedded in the higher dimensions by a relatively simple transformation such that it would look like the higher dimensional map, i.e. the two maps are geometrically similar. Here, we have used this method to compare the antigenic map in three and four dimensions. Python code using [PyRacmacs](https://github.com/iAvicenna/PyRacmacs) to calculate the piecewise Procrustes between the four dimensional and three dimensional antigenic maps is provided. R code used in Kok et al. 2024 to color-code antigens in the antigenic map according to the Procrustes length and number of pieces (Data S3A and S3B) is also provided. 



