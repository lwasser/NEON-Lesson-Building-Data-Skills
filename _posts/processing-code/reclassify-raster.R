library(raster)
# reclassify raster

setwd("~/Documents/data/1_DataPortal_Workshop/1_WorkshopData")

# open raster

dem <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
dem

brk <- c(250, 300, 350, 400,450,500)

# reclass matrix
newClass.m <- matrix(c(250, 300, 1,300, 350,2,350, 400,3), nrow=3, ncol=3, byrow = TRUE)
newClass.m
newDEM <- reclassify(x = dem, rcl=newClass.m)
plot(newDEM)