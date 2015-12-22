---
layout: post
title: "Visualize Precipitation & Stream Discharge Data in 
R to Better Understand - the 2013 Colorado Floods"
date: 2015-12-04
authors: [Leah A. Wasser, Mariela Perignon]
dateCreated: 2015-05-18
lastModified: 2015-12-14
categories: [Coding and Informatics]
category: coding-and-informatics
tags: [R, time-series]
mainTag: GIS-Spatial-Data
scienceThemes: [phenology, disturbance]
description: "This lesson walks through the steps need to download and visualize
Precipitation Data and USGS Stream Discharge data in R 
to better understand the Drivers and Impacts of the 2013 Colorado floods."
image:
  feature: TeachingModules.jpg
  credit: A National Ecological Observatory Network (NEON) - Teaching Module
  creditlink: http://www.neoninc.org
permalink: /R/Boulder-Flood-Precipitation-Stream-Discharge-Data-R/
code1: Boulder-Flood-Data.R
comments: false
---

{% include _toc.html %}

Several factors contributed to extreme flooding that occured in Boulder, Colorado 
in 2013. In this lesson, we will explore two key variables including:

* Precipitation (rainfall) data collected by ???NDCD?? 
* Stream discharge (or flow) that occured due to combination of the drought 
conditions and extreme rainfall.


<div id="objectives" markdown="1">

###Goals / Objectives
After completing this activity, you will:

* 

###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and, preferably,
R studio to write your code.
####R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`
* **lubridate:** `install.packages("lubridate")`

####Data to Download


<a href="#" class="btn btn-success"> 
#</a> 


... processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the 
<a href="http://www.neoninc.org/data-resources/get-data/airborne-data" target="_blank"> NEON 
website.</a>

####Recommended Pre-Lesson Reading


#### Lesson Series 

</div>

#R Libraries

We will be working with time-series data in this lesson so we will load the `lubridate`
library. We will use `ggplot2` to efficiently plot our data.


    library(lubridate) #work with time series data
    library(ggplot2)  #create efficient, professional plots
    library(plotly) #create cool interactive plots


#About the Data - USGS Stream Discharge Data

The USGS has a distributed network of aquatic sensors located in streams across
the United States. These network monitors a suit of variables that are important
to stream morphology and health. One of the metrics that this sensor network monitors is 
**Stream Discharge**, a metric which quantifies the volume of water moving down
a stream. Discharge is an ideal metric to quantify flow, which increases significantly
during a flood event.

> As defined by USGS: Discharge is the volume of water moving down a stream or 
> river per unit of time, 
> commonly expressed in cubic feet per second or gallons per day. In general, 
> river discharge is computed by multiplying the area of water in a channel cross 
> section by the average velocity of the water in that cross section.
> 
> <a href="http://water.usgs.gov/edu/streamflow2.html" target="_blank">
More on stream Discharge by USGS.</a>

<figure>
<a href="{{ site.baseurl }}/images/dist-co-flood/USGS-Peak-discharge.gif">
<img src="{{ site.baseurl }}/images/dist-co-flood/USGS-Peak-discharge.gif"></a>
    
<figcaption>
The USGS tracks stream discharge through time at locations across the United 
States. Note the pattern observed in the plot above. The Peak recorded discharge 
value in 2013 was significantly larger than what was observed in other years.
</figcaption>
</figure>

More on USGS streamflow measurements and data:

* <a href="http://maps.waterdata.usgs.gov/mapper/index.html" target="_blank">
View interactive map of all USGS stations</a>
* <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank">
More on peak streamflow. </a>
* <a href="http://water.usgs.gov/edu/measureflow.html" target="_blank">part 2 - USGS overview
of measuring streamflow</a>
* <a href="http://water.usgs.gov/edu/streamflow2.html" target="_blank">part 2 - USGS overview
of measuring streamflow</a>


NOTE: USGS data can be downloaded via an API (using a command line interface). 
<a href="http://help.waterdata.usgs.gov/faq/automated-retrievals#RT">
More on API downloads of USGS data </a>.
{: .notice }


#note: it's unclear from this how the data were actually measursed given it seems
there are diferent sensors. ASK Aquatics.


## Getting USGS Stream Gauge Data

For this lesson, we are using data collected by USGS stream guage 06730200 which 
is located in Boulder Creek at North 75TH ST. This guage is one of the few the 
was able to collect data throughout the 2013 Boulder Floods. The data were that we
will use were downloaded from USGS's 
<a href="http://waterdata.usgs.gov/nwis" target="_blank"> National 
Water Information System portal </a>.

You can access these data and the full available data stream for the boulder 
guage using the link below. Notice that youare able to download the data at 
different time periods as well!

<a href="http://waterdata.usgs.gov/nwis/inventory?agency_code=USGS&site_no=06730200
" target="_blank">View USGS stream guage 06730200 page.</a>


#insert picture of guage! <PICTURE>>


#insert map of where the guage is located - leaflet?

Guage Data info:
USGS 06730200 BOULDER CREEK AT NORTH 75TH ST. NEAR BOULDER, CO
{ : .notice }

#Import USGS Stream Discharge Data Into R
Now that we better understand the data that we will work with, let's import it into
`R`. First, open up the `precip-discharge/2013-discharge.txt` file in a text editor.
What do you notice about the structure of the file?

The first 25 lines are descriptive text and not actual data. Also notice that 
this file is separated by tabs, not commas. We will need to specify the **Tab delimiter**
when we import our data.We will use the `read.csv` to import it into an `R` object. 

When we use `csv` we need to define several attributes of the file including:

1. The data are tab delimited. We will this tell R to use the `"/t"` **sep**arator. 
Which defines a tab delimited separation.
2. The first group of lines in the file are not data, we will tell `R` to skip
those lines when it imports the data using `skip=25`.
3. Our data have a header, which is similar to column names in a spreadsheet. We 
will tell `R` to set `header=TRUE` to ensure the headers are imported as column
names rather than data values.
4. Finally we will set `stringsAsFactors = FALSE` to ensure our data come in a 
individual values.

Let's import our data.


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

    ##   agency_cd  site_no         datetime tz_cd X04_00060 X04_00060_cd
    ## 1        5s      15s              20d    6s       14n          10s
    ## 2      USGS 06730200 2013-01-01 00:00   MST        22            A
    ## 3      USGS 06730200 2013-01-01 00:15   MST        22            A
    ## 4      USGS 06730200 2013-01-01 00:30   MST        22            A
    ## 5      USGS 06730200 2013-01-01 00:45   MST        22            A
    ## 6      USGS 06730200 2013-01-01 01:00   MST        22            A

When we import these data, it appears as if we have 2 header rows rather than one.
Let's create a new `R` object that removes the second row of header values. To do
this, we can use select all data beginning at row 2 and ending at the total number
or rows in the file. The `nrow` function will count the total number of rows in 
the object.

# LINK OUT TO DATA OR SOFTWARE CARPENTRY LESSONS THAT TEACH THIS??
* More on selecting a subset of a data.frame in R

Let's subset our `discharge` object to remove the first row.


    #how many rows are in the R object
    nrow(discharge)

    ## [1] 34257

    #remove the first line from the data frame (which is a second list of headers)
    #the code below selects all rows beginning at row 2 and ending at the total
    #number of rows. 
    boulderStrDis.2013 <- discharge[2:nrow(discharge),]

Now, we have an `R` object that contains only rows containing data values. Each 
column also has a unique column name. However the column names may not be descriptive
enough. In some cases, when we had useful metadata, we might keep the names as is.
In this case, let's rename column 5, which contains the discharge value, **disValue**
so it is more "human readable" as we work with it in `R`.


    #view names
    names(boulderStrDis.2013)

    ## [1] "agency_cd"    "site_no"      "datetime"     "tz_cd"       
    ## [5] "X04_00060"    "X04_00060_cd"

    #rename the fifth column to disValue representing discharge value
    names(boulderStrDis.2013)[5] <- "disValue"
    
    #view names
    names(boulderStrDis.2013)

    ## [1] "agency_cd"    "site_no"      "datetime"     "tz_cd"       
    ## [5] "disValue"     "X04_00060_cd"

#View Data Structure
Let's have a look at the structure of our data. It appears as if the discharge 
value is a `character` class. This is likely because we had an additional row in our
data. Let's convert the discharge column to a `numeric` class. In this case, we can 
reassign that column to be of class: `integer` given there are no decimal places.


    #view structure of data
    str(boulderStrDis.2013)

    ## 'data.frame':	34256 obs. of  6 variables:
    ##  $ agency_cd   : chr  "USGS" "USGS" "USGS" "USGS" ...
    ##  $ site_no     : chr  "06730200" "06730200" "06730200" "06730200" ...
    ##  $ datetime    : chr  "2013-01-01 00:00" "2013-01-01 00:15" "2013-01-01 00:30" "2013-01-01 00:45" ...
    ##  $ tz_cd       : chr  "MST" "MST" "MST" "MST" ...
    ##  $ disValue    : chr  "22" "22" "22" "22" ...
    ##  $ X04_00060_cd: chr  "A" "A" "A" "A" ...

    #view class of the disValue column
    class(boulderStrDis.2013$disValue)

    ## [1] "character"

    #convert column to integer
    boulderStrDis.2013$disValue <- as.integer(boulderStrDis.2013$disValue)
    
    class(boulderStrDis.2013$disValue)

    ## [1] "integer"

    str(boulderStrDis.2013)

    ## 'data.frame':	34256 obs. of  6 variables:
    ##  $ agency_cd   : chr  "USGS" "USGS" "USGS" "USGS" ...
    ##  $ site_no     : chr  "06730200" "06730200" "06730200" "06730200" ...
    ##  $ datetime    : chr  "2013-01-01 00:00" "2013-01-01 00:15" "2013-01-01 00:30" "2013-01-01 00:45" ...
    ##  $ tz_cd       : chr  "MST" "MST" "MST" "MST" ...
    ##  $ disValue    : int  22 22 22 22 22 22 22 22 22 22 ...
    ##  $ X04_00060_cd: chr  "A" "A" "A" "A" ...


#Converting Time Stamps
We have converted our discharge data to an `integer` class However the time stamp
field, `datetime` is still a `character` class. We could try to plot the data however, 
if we do, it will confuse R. It will read in the dates as character strings and
get confused. Your plot will take a LONG time to render!


![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Precipitation-Time-Series-Data-In-R/plot-flood-data-example-1.png) 

To efficiently plot time series data, let's convert the `datetime` column to a 
`time` class for efficient plotting and analysis.


    #view class
    class(boulderStrDis.2013$datetime)

    ## [1] "character"

    #convert to date/time class - POSIX
    boulderStrDis.2013$datetime <- as.POSIXct(boulderStrDis.2013$datetime)
    
    #recheck data structure
    str(boulderStrDis.2013)

    ## 'data.frame':	34256 obs. of  6 variables:
    ##  $ agency_cd   : chr  "USGS" "USGS" "USGS" "USGS" ...
    ##  $ site_no     : chr  "06730200" "06730200" "06730200" "06730200" ...
    ##  $ datetime    : POSIXct, format: "2013-01-01 00:00:00" "2013-01-01 00:15:00" ...
    ##  $ tz_cd       : chr  "MST" "MST" "MST" "MST" ...
    ##  $ disValue    : int  22 22 22 22 22 22 22 22 22 22 ...
    ##  $ X04_00060_cd: chr  "A" "A" "A" "A" ...

#No Data Values
Next, let's query our data to check whether there are no data values (`NA`) in it.



    #make sure there are no null values in our datetime field
    sum(is.na(boulderStrDis.2013$datetime ))

    ## [1] 0

#Plot The Data
Finally, we are ready to plot our data. We will use `GGPLOT` to create our plot.



    ggplot(boulderStrDis.2013, aes(datetime, disValue)) +
      geom_point() +
      ggtitle("Stream Discharge (CFS) for Boulder Creek\nJan. 2013-Jan. 2014") +
      xlab("Date (POSIX Time Class)") + ylab("Discharge (Cubic Feet per Second")

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Precipitation-Time-Series-Data-In-R/plot-flood-data-1.png) 

#Plot Data Time Subsets With GGplot 

We can plot a subset of our data using `GGPLOT`. Let's plot data for the months 
directly around the boulder flood: August 2013 - October 2013.


    #Define Start and end times for the subset as R objects that are the time class
    startTime <- as.POSIXct("2013-08-15 00:00:00")
    endTime <- as.POSIXct("2013-10-15 00:00:00")
    
    #create a start and end time R object
    start.end <- c(startTime,endTime)
    start.end

    ## [1] "2013-08-15 MDT" "2013-10-15 MDT"

##Plot A Temporal Subset

Finally, we can use GGPLOT just like we did above to create a new plot. However, 
this time, we will use the `scale_x_datetime` method and define the limits to our
`limits` object.


ggtitle("Stream Discharge (CFS) for Boulder Creek\nJan. 2013-Jan. 2014") +
  xlab("Date") + ylab("Discharge (Cubic Feet per Second")
  

    #plot the data - September-October
    ggplot(data=boulderStrDis.2013,
          aes(datetime,disValue)) +
          geom_point() +
          scale_x_datetime(limits=start.end) +
          xlab("Time") + ylab("Stream Discharge CFS") +
          ggtitle("Stream Discharge (CFS) for Boulder Creek\nAugust 2013 - October 2013")

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Precipitation-Time-Series-Data-In-R/plot-subset-1.png) 

#Publish to Plot.ly
We have now successfully created a plot. We can turn that plot into an interactive
plot using `Plot.ly` if we want. Note, for this to be successful you need to 
set your Plot.ly API key which you will get from your free online account, once 
you create it.

Set your username: `Sys.setenv("plotly_username"="yourUserNameHere")`
Set your user key: `Sys.setenv("plotly_api_key"="yourUserKeyHere")`

##Time subsets in plot.ly

Note that plot.ly doesn't accept the ggplot time subset method. Thus we will
have to manually subset out our data.


    library(plotly)
    
    #set username
    Sys.setenv("plotly_username"="yourUserNameHere")
    #set user key
    Sys.setenv("plotly_api_key"="yourUserKeyHere")
    
    #subset out some of the data - July-November
    boulderStrDis.aug.oct2013 <- subset(boulderStrDis.2013, 
                            datetime >= as.POSIXct('2013-08-15 00:00',
                                                  tz = "America/Denver") & 
                            datetime <= as.POSIXct('2013-10-15 23:59', 
                                                  tz = "America/Denver"))
    
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
    
    #publish plotly plot to your plot.ly online account if you want. 
    #plotly_POST(disPlot.plotly)

#Challenge ???
* Maybe have them grab data from another location - possibly another guage that
survived the flood in another area??

#LEFT TO DO IN THIS LESSSON
1. Create Plot.ly plot in a neondataskills account and embed it as a graphic
2. Create challenge?


#Visualize Precipitation Data - 2013 Boulder Flood 

The heavy precipitation (rain) that occurred in September 2013 drove the many of 
the flood impacts including increased **stream discharge (flow)**. Let's explore
precipitation data collected during this time to better understand this important 
flood driver.

#About the Precipitation Data

These data were collected by the National Climatic Data Center - another data provider
that, like USGS has a network of sensors located across the United States collecting
climatic data including temperature and precipitation.

#More about the data - where to get it, how to get it, etc.

#Import Precipitation Data

We will use the `precip-discharge/2013-precip-data-640457.csv` file in this activity.
These data were downloaded from the NCDC portal... more

After quickly looking at our data, we see that they are separated or delimited by
a comma `,`. We can use `read.csv` to import comma separated data. After we import
the data, let's have a look at the `head` (which defaults to the first 6 lines) 
of the `data.frame`. Then, let's explore the object structure.


    #import precip data into R data.frame
    precip.boulder <- read.csv("precip-discharge/2013-precip-data-640457.csv",
                               stringsAsFactors = FALSE,
                               header = TRUE)
    #view first 6 lines of the data
    head(precip.boulder)

    ##       STATION    STATION_NAME ELEVATION LATITUDE LONGITUDE           DATE
    ## 1 COOP:050843 BOULDER 2 CO US    1650.5  40.0338 -105.2811 20130101 01:00
    ## 2 COOP:050843 BOULDER 2 CO US    1650.5  40.0338 -105.2811 20130128 16:00
    ## 3 COOP:050843 BOULDER 2 CO US    1650.5  40.0338 -105.2811 20130129 01:00
    ## 4 COOP:050843 BOULDER 2 CO US    1650.5  40.0338 -105.2811 20130201 01:00
    ## 5 COOP:050843 BOULDER 2 CO US    1650.5  40.0338 -105.2811 20130214 16:00
    ## 6 COOP:050843 BOULDER 2 CO US    1650.5  40.0338 -105.2811 20130220 18:00
    ##   HPCP
    ## 1    0
    ## 2   10
    ## 3   10
    ## 4    0
    ## 5   10
    ## 6   10

    #view structure of data
    str(precip.boulder)

    ## 'data.frame':	233 obs. of  7 variables:
    ##  $ STATION     : chr  "COOP:050843" "COOP:050843" "COOP:050843" "COOP:050843" ...
    ##  $ STATION_NAME: chr  "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" ...
    ##  $ ELEVATION   : num  1650 1650 1650 1650 1650 ...
    ##  $ LATITUDE    : num  40 40 40 40 40 ...
    ##  $ LONGITUDE   : num  -105 -105 -105 -105 -105 ...
    ##  $ DATE        : chr  "20130101 01:00" "20130128 16:00" "20130129 01:00" "20130201 01:00" ...
    ##  $ HPCP        : int  0 10 10 0 10 10 10 10 10 10 ...

#About the Data Structure
Viewing the structure of these data, we can see that a few potential issues with 
the data. The date field is in a character class.


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

    ## Warning: Removed 4 rows containing missing values (position_stack).

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Precipitation-Time-Series-Data-In-R/unnamed-chunk-1-1.png) 



    library(plyr)
    #add a day column in the data frame
    precip.boulder$daily <- floor_date(precip.boulder$DATE, "day")
    
    #summarize by day
    dailyPrecip.boulder <- ddply(precip.boulder, "daily",summarise, x=sum(HPCP))
    
    names(dailyPrecip.boulder)

    ## [1] "daily" "x"

    #let's create a more meaningful column header for the precip value
    names(dailyPrecip.boulder) <- c("day","prec_100In")
    
    # view names
    names(dailyPrecip.boulder)

    ## [1] "day"        "prec_100In"

    #are there no data values?
    sum(is.na(dailyPrecip.boulder))

    ## [1] 4

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

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Precipitation-Time-Series-Data-In-R/daily-summaries-1.png) 

## Units

It looks like our precipitation data are in 100th of an inch. Let's convert the 
data to inches - units that we might be a bit more accustomed to. And then let's
plot the data as a bar plot rather than a scatter plot.


    #convert to inches
    dailyPrecip.boulder.cln$prec_in <- dailyPrecip.boulder.cln$prec_100In / 100
    
    head(dailyPrecip.boulder.cln)

    ##          day prec_100In prec_in
    ## 1 2013-01-01          0     0.0
    ## 2 2013-01-28         10     0.1
    ## 3 2013-01-29         10     0.1
    ## 4 2013-02-01          0     0.0
    ## 5 2013-02-14         10     0.1
    ## 6 2013-02-20         20     0.2

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

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Precipitation-Time-Series-Data-In-R/convert-units-1.png) 

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

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Precipitation-Time-Series-Data-In-R/convert-units-2.png) 

#Interactive Plots - Plot.ly

Let's turn our plot into an interactive plot.ly plot




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

<!--html_preserve--><div id="htmlwidget-434" style="width:504px;height:504px;" class="plotly"></div>
<script type="application/json" data-for="htmlwidget-434">{"x":{"data":[{"x":[1377064800000,1377496800000,1378015200000,1378706400000,1378792800000,1378879200000,1378965600000,1379052000000,1379138400000,1379224800000,1379311200000,1379829600000,1379916000000,1380261600000,1380607200000,1380780000000,1380866400000,1381384800000],"y":[0.1,0.2,0,0.8,0.3,6.4,7.3,0.3,0.1,1.6,0.1,0.1,0.3,0.4,0,0.2,0.7,0.1],"type":"bar","text":[null],"name":{},"marker":{"color":{}},"xaxis":"x1","yaxis":"y1","showlegend":false,"bargap":"default","barmode":"stack"}],"layout":{"barmode":"stack","xaxis":{"tickcolor":"rgb(127,127,127)","gridcolor":"rgb(255,255,255)","showgrid":true,"ticks":"outside","showticklabels":true,"type":"date","title":"Time","zeroline":false,"showline":false},"yaxis":{"tickcolor":"rgb(127,127,127)","gridcolor":"rgb(255,255,255)","showgrid":true,"ticks":"outside","showticklabels":true,"type":"linear","title":"Precipitation (inches)","zeroline":false,"showline":false},"title":"Daily Total Precipitation (Inches) - Boulder Creek 2013","plot_bgcolor":"rgb(229,229,229)","margin":{"b":40,"l":60,"t":25,"r":10},"legend":{"bordercolor":"transparent","x":1.01,"y":0.4875,"xref":"paper","yref":"paper","xanchor":"left","yanchor":"top","font":{"family":""},"bgcolor":"rgb(255,255,255)"},"showlegend":false,"titlefont":{"family":""},"paper_bgcolor":"rgb(255,255,255)"},"world_readable":true},"evals":[]}</script><!--/html_preserve-->

    #publish plotly plot to your plot.ly online account when you are happy with it
    plotly_POST(new)

    ## Error in curl::curl_fetch_memory(url, handle = handle): Peer certificate cannot be authenticated with given CA certificates

