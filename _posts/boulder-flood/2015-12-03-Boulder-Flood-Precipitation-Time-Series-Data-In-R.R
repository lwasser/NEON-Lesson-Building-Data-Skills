## ----load-libraries------------------------------------------------------

library(lubridate) #work with time series data
library(ggplot2)  #create efficient, professional plots
library(plotly) #create cool interactive plots


## ----import-discharge-2--------------------------------------------------
#SOURCE
#http://nwis.waterdata.usgs.gov/co/nwis/uv/?cb_00065=on&cb_00060=on&format=rdb&site_no=06730200&period=&begin_date=2013-01-01&end_date=2013-12-31
#import data

discharge <- read.csv("precip-discharge/2013-discharge.txt",
                      sep="\t",
                      skip=25,
                      header=TRUE,
                      stringsAsFactors = FALSE)

#view first few lines
head(discharge)



## ----remove-second-header------------------------------------------------
#how many rows are in the R object
nrow(discharge)

#remove the first line from the data frame (which is a second list of headers)
#the code below selects all rows beginning at row 2 and ending at the total
#number of rows. 
boulderStrDis.2013 <- discharge[2:nrow(discharge),]

## ----rename-headers------------------------------------------------------

#view names
names(boulderStrDis.2013)

#rename the fifth column to disValue representing discharge value
names(boulderStrDis.2013)[5] <- "disValue"

#view names
names(boulderStrDis.2013)


## ----adjust-data-structure-----------------------------------------------
#view structure of data
str(boulderStrDis.2013)

#view class of the disValue column
class(boulderStrDis.2013$disValue)

#convert column to integer
boulderStrDis.2013$disValue <- as.integer(boulderStrDis.2013$disValue)

class(boulderStrDis.2013$disValue)
str(boulderStrDis.2013)


## ----plot-flood-data-example, echo=FALSE---------------------------------
#this plot takes FOREVER to create with all of the rows, so we will just 
#show them the output. OTherwise it could hang up machines.
ggplot(boulderStrDis.2013, aes(datetime, disValue)) +
  geom_point() +
  ggtitle("Plot Data With Time Field as a Character Class\nNotice the X Axis Labels") +
  xlab("Date Time (Character Class)") + ylab("Discharge (CFS)")


## ----convert-time--------------------------------------------------------
#view class
class(boulderStrDis.2013$datetime)

#convert to date/time class - POSIX
boulderStrDis.2013$datetime <- as.POSIXct(boulderStrDis.2013$datetime)

#recheck data structure
str(boulderStrDis.2013)


## ----no-data-values------------------------------------------------------
#make sure there are no null values in our datetime field
sum(is.na(boulderStrDis.2013$datetime ))


## ----plot-flood-data-----------------------------------------------------

ggplot(boulderStrDis.2013, aes(datetime, disValue)) +
  geom_point() +
  ggtitle("Stream Discharge (CFS) for Boulder Creek\nJan. 2013-Jan. 2014") +
  xlab("Date (POSIX Time Class)") + ylab("Discharge (Cubic Feet per Second")


## ----define-time-subset--------------------------------------------------

#Define Start and end times for the subset as R objects that are the time class
startTime <- as.POSIXct("2013-08-15 00:00:00")
endTime <- as.POSIXct("2013-10-15 00:00:00")

#create a start and end time R object
start.end <- c(startTime,endTime)
start.end

## ----plot-subset---------------------------------------------------------
#plot the data - September-October
ggplot(data=boulderStrDis.2013,
      aes(datetime,disValue)) +
      geom_point() +
      scale_x_datetime(limits=start.end) +
      xlab("Time") + ylab("Stream Discharge CFS") +
      ggtitle("Stream Discharge (CFS) for Boulder Creek\nAugust 2013 - October 2013")



## ----plotly-discharge-data, results="hide", eval=FALSE-------------------
## library(plotly)
## 
## #set username
## Sys.setenv("plotly_username"="yourUserNameHere")
## #set user key
## Sys.setenv("plotly_api_key"="yourUserKeyHere")
## 
## #subset out some of the data - July-November
## boulderStrDis.aug.oct2013 <- subset(boulderStrDis.2013,
##                         datetime >= as.POSIXct('2013-08-15 00:00',
##                                               tz = "America/Denver") &
##                         datetime <= as.POSIXct('2013-10-15 23:59',
##                                               tz = "America/Denver"))
## 
## #plot the data - September-October
## disPlot.plotly <- ggplot(data=boulderStrDis.aug.oct2013,
##         aes(datetime,disValue)) +
##         geom_point(size=3)
## 
## #add title and labels
## disPlot.plotly <- disPlot.plotly + theme(axis.title.x = element_blank()) +
##           xlab("Time") + ylab("Stream Discharge CFS") +
##           ggtitle("Stream Discharge - Boulder Creek 2013")
## 
## #view plotly plot in R
## ggplotly()
## 
## #publish plotly plot to your plot.ly online account if you want.
## #plotly_POST(disPlot.plotly)
## 

## ----import-precip-------------------------------------------------------

#import precip data into R data.frame
precip.boulder <- read.csv("precip-discharge/2013-precip-data-640457.csv",
                           stringsAsFactors = FALSE,
                           header = TRUE)
#view first 6 lines of the data
head(precip.boulder)
#view structure of data
str(precip.boulder)


## ------------------------------------------------------------------------
#convert date time
precip.boulder$DATE <- as.POSIXct(precip.boulder$DATE,
                                  format="%Y%m%d %H:%M")

#clean up no data values
precip.boulder$HPCP[precip.boulder$HPCP==99999] <- NA

#plot the data - September-October
precPlot <- ggplot(data=precip.boulder,
      aes(DATE,HPCP)) +
      geom_bar(stat="identity") +
      scale_x_datetime(limits=limits) +
      scale_y_continuous(limits = c(0, 300))
      
#add title and labels
precPlot + theme(axis.title.x = element_blank()) +
          xlab("Time") + ylab("Precipitation (100th of an inch)") +
          ggtitle("Hourly Precipitation - Boulder - Station\n Boulder Creek 2013")


## ----daily-summaries-----------------------------------------------------

library(plyr)
#add a day column in the data frame
precip.boulder$daily <- floor_date(precip.boulder$DATE, "day")

#summarize by day
dailyPrecip.boulder <- ddply(precip.boulder, "daily",summarise, x=sum(HPCP))

names(dailyPrecip.boulder)

#let's create a more meaningful column header for the precip value
names(dailyPrecip.boulder) <- c("day","prec_100In")

# view names
names(dailyPrecip.boulder)

#are there no data values?
sum(is.na(dailyPrecip.boulder))

#remove rows with no data
dailyPrecip.boulder.cln <- na.omit(dailyPrecip.boulder)

#plot the data - September-October
precPlot <- ggplot(data=dailyPrecip.boulder.cln,
      aes(day,prec_100In)) +
       geom_bar(stat="identity") +
      scale_x_datetime(limits=limits) +
      scale_y_continuous(limits = c(0, 800))
      
#add title and labels
precPlot + theme(axis.title.x = element_blank()) +
          xlab("Time") + ylab("Precipitation (100th of an inch)") +
          ggtitle("DAILY Precipitation - Boulder- Station\n Boulder Creek 2013")



## ----convert-units-------------------------------------------------------


#convert to inches
dailyPrecip.boulder.cln$prec_in <- dailyPrecip.boulder.cln$prec_100In / 100

head(dailyPrecip.boulder.cln)

#plot the data - September-October
precPlot_2013 <- ggplot(data=dailyPrecip.boulder.cln,
      aes(day,prec_in)) +
      geom_bar(stat="identity") +
      scale_x_datetime() +
      scale_y_continuous(limits = c(0, 8))
      
#add title and labels
precPlot_2013 <- precPlot_2013 + theme(axis.title.x = element_blank()) +
          xlab("2013") + ylab("Precipitation (Inches)") +
          ggtitle("Daily Total Precipitation (Inches) - Boulder- Station\n Boulder Creek 2013")


precPlot_2013

#plot the data - September-October
precPlot <- ggplot(data=dailyPrecip.boulder.cln,
      aes(day,prec_in)) +
      geom_bar(stat="identity") +
      scale_x_datetime(limits=limits) +
      scale_y_continuous(limits = c(0, 8))
      
#add title and labels
precPlot <- precPlot + theme(axis.title.x = element_blank()) +
          xlab("Time") + ylab("Precipitation (inches)") +
          ggtitle("Daily Total Precipitation (Inches) - Boulder- Station\n Boulder Creek 2013")


precPlot

## ----plotly-precip-data--------------------------------------------------

library(plotly)
#setup your plot.ly credentials
Sys.setenv("plotly_username"="your.user.name.here")
Sys.setenv("plotly_api_key"="your.key.here")

#subset out some of the data - July-November
dailyPrec.sub <- subset(dailyPrecip.boulder.cln, 
                        day >= as.POSIXct('2013-08-15 00:00',
                        tz = "America/New_York") & day <=
        as.POSIXct('2013-10-15 23:59', tz = "America/Denver"))


#create new plot
new <- ggplot(data=dailyPrec.sub, aes(day,prec_in)) +
  geom_bar(stat="identity") +
  xlab("Time") + ylab("Precipitation (inches)") +
  ggtitle("Daily Total Precipitation (Inches) - Boulder Creek 2013") 

#view plotly plot in R
ggplotly()

#publish plotly plot to your plot.ly online account when you are happy with it
plotly_POST(new)



