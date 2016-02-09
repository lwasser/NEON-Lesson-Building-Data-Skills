###This code is tailored to moving posts from the data-lessons repos to the 
##dev or prod server. it does the following

# 1. it moves all RMD files to _posts/ whatever the sub dir is in the repo
# 2. it moves all code files to the code dir
# 3. it moves all md files from the data-lessons posts dir to the same location in the prod repo

#Inputs - Where the base files are on your computer
#basePath <-"~/Documents/GitHub/NEON-R-Spatial-Vector/"
basePath <-"~/Documents/GitHub/NEON-R-Spatial-Raster/"
#basePath <-"~/Documents/GitHub/NEON-R-Tabular-Time-Series/"


#this is where you want to move files to
#prodPath <-"~/Documents/GitHub/NEON-R-Spatial-Vector/"
prodPath <-"~/Documents/GitHub/deleteMe/"

#get subdir in _posts
#NOTE: this assums there is only one
postSubDir <- list.dirs(paste0(basePath,"_posts"), recursive=TRUE,full.names = FALSE)
#grab the last dir in the repo - again this assumes only one
length(postSubDir)

subDirPath <- postSubDir[length(postSubDir)]


########################## COPY Code files, md and images to prod #############
#copy _posts file to the rmd directory on git
file.copy(paste0(basePath,"/_posts"), prodPath, recursive=TRUE)

#copy knitr images dir sam dir  on prod
file.copy(paste0(basePath,"/images"), prodPath, recursive=TRUE)

#copy code over 
file.copy(paste0(basePath,"/code"), prodPath, recursive=TRUE)

#grab just the rmd files and copy those over  
rmd.files <- list.files(basePath, pattern="*.Rmd", full.names = TRUE )
file.copy(rmd.files, paste0(prodPath,"_posts/",subDirPath))
