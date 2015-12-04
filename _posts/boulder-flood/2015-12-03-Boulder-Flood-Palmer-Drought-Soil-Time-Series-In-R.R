## ----load-libraries------------------------------------------------------

library(lubridate) #work with time series data
library(ggplot2)  #create efficient, professional plots
library(plotly) #create interactive plots


## ----import-drought-data-------------------------------------------------
#Import State Wide index data
drought <- read.csv("drought/CDODiv8721376888863_CO.txt", header = TRUE)
head(drought)

#view data structure
str(drought)

## ----convert-year-month--------------------------------------------------
#view structure of date field
str(drought$YearMonth)

#convert to date
drought$YearMonth <- as.Date(drought$YearMonth, format="%Y%m%d")


## ----convert-palmer-date-------------------------------------------------
#convert date field (YearMonth) to date class

#add a day of the month to each year-month combination
drought$YearMonth <- paste0(drought$YearMonth,"01")

#convert to date
drought$YearMonth <- as.Date(drought$YearMonth, format="%Y%m%d")

## ----create-quick-palmer-plot--------------------------------------------

#plot Palmer Drought Index
palmer.drought <- ggplot(data=drought,
       aes(YearMonth,PDSI)) +
       geom_bar(stat="identity",position = "identity") +
       xlab("Year / Month") + ylab("Palmer Drought Severity Index") +
       ggtitle("Palmer Drought Severity Index - Colorado\nNA values included")

palmer.drought


## ----summary-stats-------------------------------------------------------
#viw summary stats of the Palmer Drought Severity Index
summary(drought$PDSI)

#view histogram of the data
hist(drought$PDSI,
     main="Histogram of PDSI value",
     col="wheat3")


## ------------------------------------------------------------------------
#assign -99.99 to NA in the PDSI column
#note: you may want to do this across the entire data.frame or with other columns.
drought[drought$PDSI==-99.99,] <-  NA

#view the histogram again - does the range look reasonable?
hist(drought$PDSI,
     main="Histogram of PDSI value with -99.99 removed",
     col="springgreen4")

#plot Palmer Drought Index
ggplot(data=drought,
       aes(YearMonth,PDSI)) +
       geom_bar(stat="identity",position = "identity") +
       xlab("Year") + ylab("Palmer Drought Severity Index") +
       ggtitle("Palmer Drought Severity Index - Colorado\n1990 to 2015")



## ----create-plotly-drought-plot1-----------------------------------------

#plot Palmer Drought Index
ggplot(data=drought,
       aes(YearMonth,PDSI)) +
       geom_bar(stat="identity",position = "identity") +
       xlab("Year") + ylab("Palmer Drought Severity Index") +
       ggtitle("Palmer Drought Severity Index - Colorado\n1990 to 2015")

#view plotly plot in R
#note - plotly doesn't recognize \n to create a second title line
ggplotly()

#publish plotly plot to your plot.ly online account when you are happy with it
#plotly_POST(droughtPlot.plotly)

## ----plotly-drought------------------------------------------------------

#subset out date between 2005 and 2015 
drought2005.2015 <- subset(drought, 
                        YearMonth >= as.Date('2005-01-01', tz = "America/Denver") &
                        YearMonth <= as.Date('2015-11-01', tz = "America/Denver"))

#plot the data - September-October
droughtPlot.2005.2015 <- ggplot(data=drought2005.2015,
        aes(YearMonth,PDSI)) +
         geom_bar(stat="identity",position = "identity") +
       xlab("Year / Month") + ylab("Palmer Drought Severity Index") +
       ggtitle("Palmer Drought Severity Index - Colorado\n2005 - 2015")
     
droughtPlot.2005.2015 

#view plotly plot in R
ggplotly()

#publish plotly plot to your plot.ly online account when you are happy with it
#plotly_POST(droughtPlot.plotly)


