# EMC-H5-Code-Repo
Code for the EMC H5 Project

Work flow is to upload a seperate folder for each type of analysis which contains subfolders input, output, visuals.
For instance in the map_making folder input folder would contain titer tables, output folder would contain maps, visuals 
would contain html/png map visuals. codes for making these would be in the map_making folder directly. So the folder 
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
