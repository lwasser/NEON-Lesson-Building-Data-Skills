## ----load-libraries------------------------------------------------------
library(lubridate)
library(ggplot2)


## ----drought-data--------------------------------------------------------
#Import State Wide index data
drought <- read.csv("drought/CDODiv8721376888863_CO.txt", header = TRUE)
head(drought)

#convert date field (YearMonth) to date class
drought$YearMonth <- paste0(substr(drought$YearMonth,0,4),"-",substr(drought$YearMonth,5,6),"-01")

#convert to date
drought$YearMonth <- as.Date(drought$YearMonth, format="%Y-%m-%d")

#remove NA values (-9999 and -99.99)
drought <- drought[!drought$PDSI==-99.99,]

#plot Palmer Drought Index
palmer.drought <- ggplot(data=drought,
       aes(YearMonth,PDSI)) +
       geom_bar(stat="identity",position = "identity") +
       xlab("Year / Month") + ylab("Palmer Drought Severity Index") +
       ggtitle("Palmer Drought Severity Index - Colorado")

palmer.drought  


## ----plotly-drought------------------------------------------------------

library(plotly)

#subset out some of the data - July-November
drought2005.2015 <- subset(drought, 
                        YearMonth >= as.Date('2005-01-01', tz = "America/Denver") &
                        YearMonth <= as.Date('2015-11-01', tz = "America/Denver"))

#plot the data - September-October
droughtPlot.plotly <- ggplot(data=drought2005.2015,
        aes(YearMonth,PDSI)) +
         geom_bar(stat="identity",position = "identity") +
       xlab("Year / Month") + ylab("Palmer Drought Severity Index") +
       ggtitle("Palmer Drought Severity Index - Colorado")
      

#view plotly plot in R
ggplotly()

#publish plotly plot to your plot.ly online account when you are happy with it
#plotly_POST(droughtPlot.plotly)


## ----import-discharge, echo=FALSE----------------------------------------
#SOURCe
#http://nwis.waterdata.usgs.gov/co/nwis/uv/?cb_00065=on&cb_00060=on&format=rdb&site_no=06730200&period=&begin_date=2013-01-01&end_date=2013-12-31
#import data
discharge <- read.table("precip-discharge/2013-discharge.txt",
                        sep="\t",
                        stringsAsFactors = FALSE,
                        skip=25,
                        header=TRUE)

#view first few lines
head(discharge)

#remove the first line from the data frame (which is a second list of headers)
boulderStrDis.2013 <- discharge[2:nrow(discharge),]

#view names
names(boulderStrDis.2013)

#rename headers so they are more meaningful
names(boulderStrDis.2013)[5] <- "disValue"

#view names
names(boulderStrDis.2013)

## ----adjust-data-structure-----------------------------------------------
#view structure of data
str(boulderStrDis.2013)

#convert column to integer
boulderStrDis.2013$disValue <- as.integer(boulderStrDis.2013$disValue)

class(boulderStrDis.2013$disValue)
str(boulderStrDis.2013)


## ----convert-time--------------------------------------------------------
#view class
class(boulderStrDis.2013$datetime)

#convert to date/time class - POSIX
boulderStrDis.2013$datetime <- as.POSIXct(boulderStrDis.2013$datetime)

#recheck data structure
str(boulderStrDis.2013)

#make sure there are no null values in our datetime field
sum(is.na(boulderStrDis.2013$datetime ))


## ----plot-flood-data-----------------------------------------------------

ggplot(boulderStrDis.2013, aes(datetime, disValue)) +
  geom_point()


## ----define-time-subset--------------------------------------------------

#just subset the plot to the month of Aug15-oct15
startTime <- as.POSIXct("2013-08-15 00:00:00")
endTime <- as.POSIXct("2013-10-15 00:00:00")

limits <- c(startTime,endTime)


## ----plot-subset---------------------------------------------------------
#plot the data - September-October
disPlot <- ggplot(data=boulderStrDis.2013,
       aes(datetime,disValue)) +
      geom_point() +
      scale_x_datetime(limits=limits)
      
#add title and labels
disPlot + theme(axis.title.x = element_blank()) +
          xlab("Time") + ylab("Stream Discharge CFS") +
          ggtitle("Stream Discharge - Station\n Boulder Creek 2013")



## ----plotly-discharge-data-----------------------------------------------
library(plotly)

#subset out some of the data - July-November
boulderStrDis.aug.oct2013 <- subset(boulderStrDis.2013, 
                        datetime >= as.POSIXct('2013-08-15 00:00',
                        tz = "America/New_York") & datetime <=
        as.POSIXct('2013-10-15 23:59', tz = "America/Denver"))

#plot the data - September-October
disPlot.plotly <- ggplot(data=boulderStrDis.aug.oct2013,
        aes(datetime,disValue)) +
        geom_point(size=3) 
      
#add title and labels
disPlot.plotly <- disPlot.plotly + theme(axis.title.x = element_blank()) +
          xlab("Time") + ylab("Stream Discharge CFS") +
          ggtitle("Stream Discharge - Boulder Creek 2013")

#view plotly plot in R
ggplotly()

#publish plotly plot to your plot.ly online account when you are happy with it
plotly_POST(disPlot.plotly)


## ----import-precip-------------------------------------------------------

precip.boulder <- read.csv("precip-discharge/2013-precip-data-640457.csv",
                           stringsAsFactors = FALSE)


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



