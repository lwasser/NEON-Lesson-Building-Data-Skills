###This code is tailored to moving all template items from one repo to another
## use this with CAUTION!! It's designed mostly to update existing data lessons repos

##note - this won't clean up the directory - rather it just copies files over
## so there's a chance of duplicate files

# 1. it moves all RMD files to _posts/ whatever the sub dir is in the repo
# 2. it moves all code files to the code dir
# 3. it moves all md files from the data-lessons posts dir to the same location in the prod repo

#Inputs - Where the base template files are located on your computer
baseTemplatePath <-"~/Documents/GitHub/NEON-Data-Skills-Development/"

#this is where you want to move files to
#updatePath <-"~/Documents/GitHub/NEON-R-Spatial-Vector/"
updatePath <-"~/Documents/GitHub/NEON-R-Spatial-Raster/"
#updatePath <-"~/Documents/GitHub/NEON-R-Tabular-Time-Series/"
#updatePath <-"~/Documents/GitHub/NEON-R-Spatio-Temporal-Data-and-Management-Intro/"

#copy org dir over - this contains the md home page files for categories, tags, etc
file.copy(paste0(baseTemplatePath,"/org"), updatePath, recursive=TRUE)

#copy data dir - this contains the YAML lists
file.copy(paste0(baseTemplatePath,"/_data"), updatePath, recursive=TRUE)

#copy data dir - this contains the YAML lists
file.copy(paste0(baseTemplatePath,"/assets"), updatePath, recursive=TRUE)

#copy data dir - this contains the YAML lists
file.copy(paste0(baseTemplatePath,"/_layouts"), updatePath, recursive=TRUE)

#copy data dir - this contains the YAML lists
file.copy(paste0(baseTemplatePath,"/_includes"), updatePath, recursive=TRUE)

