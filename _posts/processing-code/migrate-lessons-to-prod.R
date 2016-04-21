
########## MOVE FILES TO DEV AND THEN PRODUCTION SERVER ############ 

# This code is tailored to moving posts from the data-lessons repos to the 
# dev or prod server. it does the following

# 1. it moves all RMD files to _posts/ whatever the sub dir is in the repo
# 2. it moves all code files to the code dir
# 3. it moves all md files from the data-lessons posts dir to the same location in the prod repo
###################################################################### 

# Inputs - Where the base files are saved on your computer (which repo)
basePath <-"~/Documents/GitHub/NEON-R-Spatial-Vector/"
# basePath <-"~/Documents/GitHub/NEON-R-Spatial-Raster/"
# basePath <-"~/Documents/GitHub/NEON-R-Tabular-Time-Series/"


# this is where you want to move files to
prodPath <-"~/Documents/GitHub/NEON-Data-Skills-Development/"
# prodPath <-"~/Documents/GitHub/NEON-Data-Skills/"

# get subdir in _posts
# NOTE: this assumes there is only one set of posts in the post directory that is 
# relevant
postSubDir <- list.dirs(paste0(basePath,"_posts"), recursive=TRUE,full.names = FALSE)

# grab the full path of the subdir in the repo - this is not operational code but
# it works as a hack for now
length(postSubDir)
subDirPath <- postSubDir[length(postSubDir)]


########################## COPY Code files, md and images to prod #############

# copy _posts file to the rmd directory on git
file.copy(paste0(basePath,"_posts"), prodPath, recursive=TRUE)

# copy knitr produced images dir same dir location on prod
file.copy(paste0(basePath,"images"), prodPath, recursive=TRUE)

# copy R code over to prod
file.copy(paste0(basePath,"code"), prodPath, recursive=TRUE)

# grab all rmd files and copy to posts/R/ directory  
rmd.files <- list.files(basePath, pattern="*.Rmd", full.names = TRUE )
file.copy(rmd.files, paste0(prodPath, "_posts/", subDirPath))
