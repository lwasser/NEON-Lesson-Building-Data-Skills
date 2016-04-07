#### Temperature Lesson Code ####
# This lesson uses 30 minute temperature data from the triple aspirated
# temperature sensors mounted above the canopy on the NEON tower.

# To set the working directory on the Mac, you need to first mount
# the remote drive onto your computer

# Set working directory
setwd("/Volumes/TOS/OSIS_dataLessons/temp_data/")

# Read in data
harv.temp30 <- read.csv("NEON.D01.HARV.DP1.00003.001.00000.000.060.030.TAAT_30min.csv",
                        stringsAsFactors = FALSE)
scbi.temp30 <- read.csv("NEON.D02.SCBI.DP1.00003.001.00000.000.060.030.TAAT_30min.csv",
                        stringsAsFactors = FALSE)

## Format dateTime
harv.temp30$startDateTime[1]

## Convert the entire date/time values in format y-m-d h:m:s
as.POSIXct(harv.temp30$startDateTime[2],format="%Y-%m-%dT%H:%M")
new.date.time <- as.POSIXct(harv.temp30$startDateTime, format="%Y-%m-%dT%H:%M")

# Convert to correct time zone, default for this code is MST
# assign time zone to just the first entry
harv.temp30$startDateTime <- as.POSIXct(harv.temp30$startDateTime,
           format = "%Y-%m-%dT%H:%M", tz = "America/New_York")
# check that conversion worked
str(harv.temp30$startDateTime)

