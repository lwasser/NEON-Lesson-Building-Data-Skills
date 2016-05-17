#### Temperature Lesson Code ####
# This lesson uses 30 minute temperature data from the triple aspirated
# temperature sensors mounted above the canopy on the NEON tower.

# To set the working directory on the Mac, you need to first mount
# the remote drive onto your computer

# Set working directory
setwd("/Volumes/TOS/OSIS_dataLessons/temp_data/")

# Load required libraries
library(ggplot2)
library(dplyr)

site <- "HARV"

# Now that you have the data, let's take a look at the readme and understand 
# what's in the data. View readme and variables file. This will guide you
# on how to import the data.

# Read in data
temp30 <- read.csv(paste("NEON.D01.", site, 
                ".DP1.00003.001.00000.000.060.030.TAAT_30min_teaching.csv",
                sep=""), stringsAsFactors = FALSE, header=TRUE)

#temp30_orig <- read.csv(paste("NEON.D01.", site, 
#                         ".DP1.00003.001.00000.000.060.030.TAAT_30min.csv",
#                         sep=""), stringsAsFactors = FALSE, header=TRUE)


# Get a general feel for the data: View structure of data frame
str(temp30)

# Review the data quality (are these data you trust?)
  #1. Are there quality flags in your data? Count 'em up
  sum(temp30$finalQF==1)
  #2. Are there NA's in your data? Count 'em up
  sum(is.na(temp30$tempTripleMean) )
  #2. 

# View the date range
range(temp30$startDateTime)

# Convert to correct time zone, default for this code is MST
# assign time zone to just the first entry
temp30$startDateTime <- as.POSIXct(temp30$startDateTime,
format = "%Y-%m-%dT%H:%M", tz = "GMT")
# check that conversion worked
str(temp30$startDateTime)

# Limit dataset to dates of interest (4/1/2014-11/30/2014)
subset(temp30, )

