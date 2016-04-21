# file=Temperature_Lesson_Prep.R
# This file prepares the HARV 2015 temperature data set for use in 
# phenology data lesson: 1) changes dates from 2015 to 2014;
# 2) adds a 'remarks' field notifying that the data set is for 
# teaching purposes only.

### Set working directory
setwd("/Volumes/TOS/OSIS_dataLessons/temp_data/")
library(lubridate)

site <- "HARV"

# Read in data
temp30 <- read.csv(paste("NEON.D01.", site, 
                         ".DP1.00003.001.00000.000.060.030.TAAT_30min.csv",
                         sep=""), stringsAsFactors = FALSE, header=TRUE)

### Find and replace years with 2014 (for 2015) or 2015 (for 2016)
temp30$startDateTime <- gsub("2015","2014", temp30$startDateTime)
temp30$startDateTime <- gsub("2016","2015", temp30$startDateTime)

temp30$endDateTime <- gsub("2015","2014", temp30$endDateTime)
temp30$endDateTime <- gsub("2016","2015", temp30$endDateTime)

## Add a remarks field
temp30$remarks <- "Teaching data only. Do not use for other purposes"


## Export data set with re-jiggered years
write.csv(temp30, paste("NEON.D01.", site, 
                        ".DP1.00003.001.00000.000.060.030.TAAT_30min_teaching.csv",
                        sep=""), row.names=FALSE)





# Convert to correct time zone, default for this code is MST when code
# is run in Boulder. Assign time zone to date time fields
temp30$startDateTime <- as.POSIXct(temp30$startDateTime,
                                format = "%Y-%m-%dT%H:%M", tz = "GMT")
temp30$endDateTime <- as.POSIXct(temp30$endDateTime,
                                format = "%Y-%m-%dT%H:%M", tz = "GMT")

# Move all dates for startDateTime back 1 year
yr2015 <- which(year(temp30$startDateTime)==2015)
yr2016 <- which(year(temp30$startDateTime)==2016)

year(temp30$startDateTime[yr2015]) <- 2014
year(temp30$startDateTime[yr2016]) <- 2015

# Move all dates for endDateTime back 1 year
yr2015 <- which(year(temp30$endDateTime)==2015)
yr2016 <- which(year(temp30$endDateTime)==2016)

year(temp30$endDateTime[yr2015]) <- 2014
year(temp30$endDateTime[yr2016]) <- 2015


temp30$startDateTime <- as.character(temp30$startDateTime)
temp30$endDateTime <- as.character(temp30$endDateTime)


