---
layout: post
title: "Introduction to EML in R"
date:   2015-12-28
authors: [Carl Boettiger, Leah A. Wasser]
contributors: []
dateCreated: 2015-12-28
lastModified: 2015-12-29
tags: [spatio-temporal, time-series, phenology]
mainTag: time-series
packagesLibraries: [eml]
category: 
description: "This lesson will walk through the basic purpose and structure of metadata stored
in EML (Ecological Metadata Language) format. We will work with an EML file created
for an atmospheric dataset by the Harvard Forest LTER, using the R/OpenSci EML
library for R."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/EML
comments: false
---

{% include _toc.html %}

#About

This lesson will walk through the basic purpose and structure of metadata stored
in EML (Ecological Metadata Language) format. We will work with an EML file created
for an atmospheric dataset by the Harvard Forest LTER, using the R/OpenSci EML
library for `R`.

To begin, we will load the `EML`, `purrr` and `dplyr` libraries.


    #install R EML tools
    #library("devtools")
    #install_github("ropensci/EML", build=FALSE, dependencies=c("DEPENDS", "IMPORTS"))
    #devtools::install_github(c("hadley/purrr", "ropensci/EML"))
    
    
    #call package
    library("EML")
    library("purrr")
    library("dplyr")
    
    #data location
    #http://harvardforest.fas.harvard.edu:8080/exist/apps/datasets/showData.html?id=hf001
    #table 4 http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv

Next, we will read in the LTER EML file - directly from the online URL using
`eml_read`. This file documents multiple data products that can be downloaded.
<a href="http://harvardforest.fas.harvard.edu:8080/exist/apps/datasets/showData.html?id=hf001" target="_blank">
Check out the Harvard Forest Data Archive Page for Fisher Meteorological Station
for more on this dataset and to download the archive files directly.</a>



    #import EML from Harvard Forest Met Data
    eml_HARV <- eml_read("http://harvardforest.fas.harvard.edu/data/eml/hf001.xml")
    
    #view size of object
    object.size(eml_HARV)

    ## 287015216 bytes

    #view the object class
    class(eml_HARV)

    ## [1] "eml"
    ## attr(,"package")
    ## [1] "EML"

The `eml_read` function creates an `EML` class object. This object can be accessed
using `slots` in R (`@`) rather than a typical subset `[]` approach.

##Getting Started

Before we go too much further, let's get some basic terms out of the way. In the 
context of `EML`, a file documents a `dataset`. This `dataset` may consist of one
or more files that are documented in the `EML` document. In the case of our 
tabular meteorology data, the structure of our `EML` file includes:

1. The **dataset**. A dataset may contain
one or more data tables associated with it that may contain different types of related
information. For this Harvard meteorological data, the data tables contain tower
measurements including precipitation and temperature, that are aggregated
at various time intervales (15 minute, daily, etc) and that date back to 2001.
2. The **data tables**. Data tables refer to the actual data that make up the dataset. 
For the Harvard Data, each data table contains a suite of meterological metrics 
including precipiation and temperature (and associated quality flags), that are 
aggregated at a particular time interval. (e.g. one data table contains monthly
average data, another contains 15 minute averaged data, etc)


#Explore Basic EML Properties

We can begin to explore the contents of our EML file and associated data that it
describes. Let's start at the dataset level. We can use `eml_get` to view the 
contact information for the dataset, the keywords and it's associated temporal
and spatial (if relevant) coverage.



    #view the contact name listed in the file
    #this works well!
    eml_get(eml_HARV,"contact")

    ## [1] "Emery Boose <boose@fas.harvard.edu>"

    #grab all keywords in the file
    eml_get(eml_HARV,"keywords")

    ## $`LTER controlled vocabulary`
    ##  [1] "air temperature"                    
    ##  [2] "atmospheric pressure"               
    ##  [3] "climate"                            
    ##  [4] "relative humidity"                  
    ##  [5] "meteorology"                        
    ##  [6] "precipitation"                      
    ##  [7] "net radiation"                      
    ##  [8] "solar radiation"                    
    ##  [9] "photosynthetically active radiation"
    ## [10] "soil temperature"                   
    ## [11] "wind direction"                     
    ## [12] "wind speed"                         
    ## 
    ## $`LTER core area`
    ## [1] "disturbance"
    ## 
    ## $`HFR default`
    ## [1] "Harvard Forest" "HFR"            "LTER"           "USA"

    #figure out the extent & temporal coverage of the data
    eml_get(eml_HARV,"coverage")

    ## geographicCoverage:
    ##   geographicDescription: Prospect Hill Tract (Harvard Forest)
    ##   boundingCoordinates:
    ##     westBoundingCoordinate: '-72.18968'
    ##     eastBoundingCoordinate: '-72.18968'
    ##     northBoundingCoordinate: '42.53311'
    ##     southBoundingCoordinate: '42.53311'
    ##     boundingAltitudes:
    ##       altitudeMinimum: '342'
    ##       altitudeMaximum: '342'
    ##       altitudeUnits: meter
    ## temporalCoverage:
    ##   rangeOfDates:
    ##     beginDate:
    ##       calendarDate: '2001-02-11'
    ##     endDate:
    ##       calendarDate: '2014-11-30'

##Figure Out Geographic Coverage
Above we were able to access the geographic coverage. Let's plot that quickly on 
a map for reference. We can access this information using the slots, which are
accessed in `R` using the `@` sign. 

<i class="fa fa-star"></i> **Data Tip:**  To figure out the full slot string, 
in `RStudio` we can use Tab Complete! 
{: .notice }




    #view geographic coverage
    eml_HARV@dataset@coverage@geographicCoverage

    ## geographicDescription: Prospect Hill Tract (Harvard Forest)
    ## boundingCoordinates:
    ##   westBoundingCoordinate: '-72.18968'
    ##   eastBoundingCoordinate: '-72.18968'
    ##   northBoundingCoordinate: '42.53311'
    ##   southBoundingCoordinate: '42.53311'
    ##   boundingAltitudes:
    ##     altitudeMinimum: '342'
    ##     altitudeMaximum: '342'
    ##     altitudeUnits: meter

##Identify & Map Data Location

Looking at the coverage for our data, there is only one unique x and y value. This 
suggests that our data were collected at one point location. We know this is a 
tower so a point makes sense. Let's grab the x and y coordinates and create a quick
context map. We will use `ggmap` to create our map.

**NOTE: if this were a rectangular extent we'd want the bounding BOX. this is important
if the data are for eample, raster format, in HDF5 or something. we need the extent
to properly geolocate and process the data.**

Nice cheatsheet
https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/ggmap/ggmapCheatsheet.pdf


    #
    XCoord <- eml_HARV@dataset@coverage@geographicCoverage@boundingCoordinates@westBoundingCoordinate
    
    YCoord <- eml_HARV@dataset@coverage@geographicCoverage@boundingCoordinates@northBoundingCoordinate
    
    
    library(ggmap)
    #map <- get_map(location='Harvard', maptype = "terrain")
    map <- get_map(location='massachusetts', maptype = "toner", zoom =8)

    ## maptype = "toner" is only available with source = "stamen".
    ## resetting to source = "stamen"...
    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=massachusetts&zoom=8&size=640x640&scale=2&maptype=terrain&sensor=false
    ## Information from URL : http://maps.googleapis.com/maps/api/geocode/json?address=massachusetts&sensor=false
    ## Map from URL : http://tile.stamen.com/toner/8/75/93.png
    ## Map from URL : http://tile.stamen.com/toner/8/76/93.png
    ## Map from URL : http://tile.stamen.com/toner/8/77/93.png
    ## Map from URL : http://tile.stamen.com/toner/8/78/93.png
    ## Map from URL : http://tile.stamen.com/toner/8/75/94.png
    ## Map from URL : http://tile.stamen.com/toner/8/76/94.png
    ## Map from URL : http://tile.stamen.com/toner/8/77/94.png
    ## Map from URL : http://tile.stamen.com/toner/8/78/94.png
    ## Map from URL : http://tile.stamen.com/toner/8/75/95.png
    ## Map from URL : http://tile.stamen.com/toner/8/76/95.png
    ## Map from URL : http://tile.stamen.com/toner/8/77/95.png
    ## Map from URL : http://tile.stamen.com/toner/8/78/95.png

    #map <- get_map(location='massachusetts', maptype = "roadmap")
    
    ggmap(map, extent=TRUE) +
      geom_point(aes(x=XCoord,y=YCoord), color="darkred",size=6, pch=18)

![ ]({{ site.baseurl }}/images/rfigs/2015-12-12-Intro-to-EML/map-location-1.png) 

We now have identified and mapped the point location where our data were collected. 
We know the data are close enough to our study area to be useful.

Next, let's dig into the dataset structure to figure out what metrics that data 
contain.

##Accessing dataset structure using EML

To understand the data that are available for us to work with, let's first explore
the `dataset` structure as outline in our `EML` file. We can access key components
of the dataset metadata structure using slots which are accessed via the `@`.

For example `eml_HARV@dataset` will return the entire dataset metadata structure.
Let's view the description of abstract for the dataset.


    #view dataset abstract (description)
    eml_HARV@dataset@abstract

    ## [1] "The Fisher Meteorological Station became operational on 11 Feb 2001. The Station is located in an open field 200 m north of the Shaler Station, in a site chosen to minimize the angle of surrounding trees above the horizon (currently 15-25 degrees from the station at breast height). The Fisher Station records air temperature, relative humidity, dew point, precipitation (water equivalent of snow), global solar radiation, PAR radiation, net radiation, barometric pressure, scalar wind speed, vector wind speed, peak gust speed (1-second), vector wind direction, standard deviation of wind direction (wind measurements at 10 m height), and soil temperature (10 cm depth). Instruments are scanned once per second, and 15-minute (hourly before 2005) and daily values are calculated and stored by a datalogger. Data for the current month are available online, updated every 15 minutes, with out-of-range values replaced by NA but values not otherwise checked. Earlier data are checked and archived with missing, questionable, and estimated values flagged, following methods of the LTER ClimbDB project. A log of events affecting station measurements (e.g., instrument repair and recalibration, ice storms, lightning) and selected monthly and annual values are also posted.For current data, please see: http://harvardforest.fas.harvard.edu/meteorological-hydrological-stations. For a complete set of archived data, please see: http://harvardforest.fas.harvard.edu:8080/exist/xquery/data.xq?id=hf001."

# View description and name of each data table in file

Let's generate a clean list of all data tables and associated data table descriptions
described in our `EML` file. To access this information we will using the following 
syntax:

`eml_HARV@dataset`

* we will add `@dataTable`
* we can access each dataTable element using index values: `[[1]]`
* we can access the name of each dataTable using `@entityName`
* we can access the description of each dataTable using `@entityDescription`

Let's try this next!

**NOTE: rbind warning - what does that mean? **


    #we can view the data table name and description as follows
    eml_HARV@dataset@dataTable[[1]]@entityName

    ## [1] "hf001-01-station-log.csv"

    eml_HARV@dataset@dataTable[[1]]@entityDescription

    ## [1] "station log"

    #create an object that just contains dataTable level attributes
    all.tables <- eml_HARV@dataset@dataTable
    
    #use purrrr to generate a data.frame that contains the attrName and Def for each column
    dataTable.desc <- purrr::map_df(all.tables, 
                  function(x) 
                  data.frame(attribute = x@entityName, 
                            description = x@entityDescription))

    ## Warning in rbind_all(x, .id): Unequal factor levels: coercing to character

    ## Warning in rbind_all(x, .id): Unequal factor levels: coercing to character

    #view table descriptions
    dataTable.desc

    ## Source: local data frame [11 x 2]
    ## 
    ##                   attribute                    description
    ##                       (chr)                          (chr)
    ## 1  hf001-01-station-log.csv                    station log
    ## 2     hf001-02-annual-m.csv     annual (metric) since 2002
    ## 3     hf001-03-annual-e.csv    annual (english) since 2002
    ## 4    hf001-04-monthly-m.csv    monthly (metric) since 2001
    ## 5    hf001-05-monthly-e.csv   monthly (english) since 2001
    ## 6      hf001-06-daily-m.csv      daily (metric) since 2001
    ## 7      hf001-07-daily-e.csv     daily (english) since 2001
    ## 8     hf001-08-hourly-m.csv      hourly (metric) 2001-2004
    ## 9     hf001-09-hourly-e.csv     hourly (english) 2001-2004
    ## 10     hf001-10-15min-m.csv  15-minute (metric) since 2005
    ## 11     hf001-11-15min-e.csv 15-minute (english) since 2005

    #how many rows (data tables) are in the list?
    nrow(dataTable.desc)

    ## [1] 11

**NOTE: the above code is complex given the length of the slot calls. it would be 
VERY NICE to have a function to help the user along with quickly generating / accessing
data table attributes and descriptions.**


Sweet! We now know that are 11 total data tables in this dataset. From the descriptions,
we have a sense of the temporal coverage (date range) and associated temporal
scale (15 min average, daily average, monthly average, etc). This is a lot of 
information to get us going. 

The data table of most interest to us now, is hourly average, in metric units.
`hf001-08-hourly-m.csv`. Let's explore that particular table next.

#Data Table Metadata
Let's next explore the attributes of Data Table 8. We can explore it's name,
a description of the data, it's physical characteristics and it's identifier.


    #create an object that contains metadata for table 8 only
    EML.hr.dataTable <- obj@dataset@dataTable[[8]]
    
    #Check out the table's name - make sure it's the right table!
    EML.hr.dataTable@entityName

    ## [1] "hf001-08-hourly-m.csv"

    #what information does this data table contain?
    EML.hr.dataTable@entityDescription

    ## [1] "hourly (metric) 2001-2004"

    #how is the text file delimited?
    EML.hr.dataTable@physical

    ## objectName: hf001-08-hourly-m.csv
    ## dataFormat:
    ##   textFormat:
    ##     numHeaderLines: '1'
    ##     recordDelimiter: \r\n
    ##     attributeOrientation: column
    ##     simpleDelimited:
    ##       fieldDelimiter: ','
    ## distribution:
    ##   online:
    ##     url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-08-hourly-m.csv

    #view table id
    EML.hr.dataTable@id

    ##         id 
    ## "hf001-08"

    #this is the download URL for the file.
    EML.hr.dataTable@physical@distribution@online@url

    ## [1] "http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-08-hourly-m.csv"


##View Data Table Fields (attributes)
We can access the attributes of a data table using similar syntax to the dataset 
access.

However: 

* Instead of using `entityName` we will use `attributeName`
* Instead of using `entityDescription` we will use `attributeDescription`

Let's explore the dataTable attributes


    #get list of measurements for the 10th data table in the EML file
    EML.hr.attr <- EML.hr.dataTable@attributeList@attribute
    #the first column is the date field
    EML.hr.attr[[1]]

    ## attributeName: datetime
    ## attributeDefinition: date and time at end of sampling period
    ## measurementScale:
    ##   dateTime:
    ##     formatString: YYYY-MM-DDThh:mm
    ## .attrs: '1184527243653'

    #view the column name and description for the first column
    EML.hr.attr[[1]]@attributeName

    ## [1] "datetime"

    EML.hr.attr[[1]]@attributeDefinition

    ## [1] "date and time at end of sampling period"


#View All Data Table Attributes 

We can create an automated list of all data table attributes and associated
descriptions as we did with our data set too. 

We will generate a summary of fields in our data table that includes:

1. The field names (metrics measured or columns) `attributeName`
2. The description of each field `attributeDefinition`

Let's do that next.


    #list of all attribute description and metadata
    #EML.15min.attr
    
    # use a split-apply-combine approach to parse the attribute data
    # and create a data.frame with only the attribute name and description
    
    #dplyr approach
    #do.call(rbind, 
    #        lapply(EML.15min.attr, function(x) data.frame(column.name = x@attributeName, 
    #                                             definition = x@attributeDefinition)))
    
    #use purrrr to generate a data.frame that contains the attrName and Def for each column
    EML.hr.attr.dt8 <- purrr::map_df(EML.hr.attr, 
                  function(x) 
                    data.frame(attribute = x@attributeName, 
                                         description = x@attributeDefinition))

    ## Warning in rbind_all(x, .id): Unequal factor levels: coercing to character

    ## Warning in rbind_all(x, .id): Unequal factor levels: coercing to character

    EML.hr.attr.dt8

    ## Source: local data frame [30 x 2]
    ## 
    ##    attribute
    ##        (chr)
    ## 1   datetime
    ## 2         jd
    ## 3       airt
    ## 4     f.airt
    ## 5         rh
    ## 6       f.rh
    ## 7       dewp
    ## 8     f.dewp
    ## 9       prec
    ## 10    f.prec
    ## ..       ...
    ## Variables not shown: description (chr)

##Download Data Table

We've now successfully explored our data. From our data.frame generated above, we
can see that this data table contains air temperature and precipitation - two 
key drivers of phenology. Thus, let's go ahead and download the data.

**note** I'd like to directly download the 4th data table. Can I use `eml_get` to
accomplish this?



    #tried to subset out the dataTable component of the eml obj
    dat <- eml_get(obj@dataset@dataTable[[4]], "data.frame")

    ## Error in eml_get(obj@dataset@dataTable[[4]], "data.frame"): object 'eml' must be of class 'eml'

    dat <- eml_get(EML.hr.dataTable@physical@distribution@online@url,
                   "data.frame")

    ## Error in eml_get(EML.hr.dataTable@physical@distribution@online@url, "data.frame"): object 'eml' must be of class 'eml'

    #in theory the code below should work but it throws a URL error
    library(RCurl)
    x <- getURL(EML.hr.dataTable@physical@distribution@online@url)
    y <- read.csv(text = x)
    
    #the url below does work, why can't R access it but my browser can?
    url <- month.avg.desc@physical@distribution@online@url
    getURL(url)

    ## [1] "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>301 Moved Permanently</title>\n</head><body>\n<h1>Moved Permanently</h1>\n<p>The document has moved <a href=\"http://harvardforest.fas.harvard.edu/sites/harvardforest.fas.harvard.edu/files/data/p00/hf001/hf001-04-monthly-m.csv\">here</a>.</p>\n<hr>\n<address>Apache/2.2.15 (Red Hat) Server at harvardforest.fas.harvard.edu Port 80</address>\n</body></html>\n"

    y

    ##                                                                                                                     X..DOCTYPE.HTML.PUBLIC....IETF..DTD.HTML.2.0..EN.
    ## 1                                                                                                                                                        <html><head>
    ## 2                                                                                                                                <title>301 Moved Permanently</title>
    ## 3                                                                                                                                                       </head><body>
    ## 4                                                                                                                                          <h1>Moved Permanently</h1>
    ## 5 <p>The document has moved <a href=http://harvardforest.fas.harvard.edu/sites/harvardforest.fas.harvard.edu/files/data/p00/hf001/hf001-08-hourly-m.csv>here</a>.</p>
    ## 6                                                                                                                                                                <hr>
    ## 7                                                                          <address>Apache/2.2.15 (Red Hat) Server at harvardforest.fas.harvard.edu Port 80</address>
    ## 8                                                                                                                                                      </body></html>

    #x <- getURL("http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv")
    
    #the url below works.
    #http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv


#OTHER STUFF


We can determine how many data tables are described in this EML document. We can
also view a list of all data tables referenced in the EML document using:

`eml_get(obj,"csv_filepaths")`

**NOTE - THESE PATHS ARE NOT THE CORRECT PATHS TO THE DATA - what are they??**


    ###THIS IS THE WRONG OUTPUT FOR SOME REASON??
    #what are the names of those tables?
    data.paths <- eml_get(obj,"csv_filepaths")
    data.paths

    ##  [1] "http://harvardforest.fas.harvard.edu/data/eml/hf001-01-station-log.csv"
    ##  [2] "http://harvardforest.fas.harvard.edu/data/eml/hf001-02-annual-m.csv"   
    ##  [3] "http://harvardforest.fas.harvard.edu/data/eml/hf001-03-annual-e.csv"   
    ##  [4] "http://harvardforest.fas.harvard.edu/data/eml/hf001-04-monthly-m.csv"  
    ##  [5] "http://harvardforest.fas.harvard.edu/data/eml/hf001-05-monthly-e.csv"  
    ##  [6] "http://harvardforest.fas.harvard.edu/data/eml/hf001-06-daily-m.csv"    
    ##  [7] "http://harvardforest.fas.harvard.edu/data/eml/hf001-07-daily-e.csv"    
    ##  [8] "http://harvardforest.fas.harvard.edu/data/eml/hf001-08-hourly-m.csv"   
    ##  [9] "http://harvardforest.fas.harvard.edu/data/eml/hf001-09-hourly-e.csv"   
    ## [10] "http://harvardforest.fas.harvard.edu/data/eml/hf001-10-15min-m.csv"    
    ## [11] "http://harvardforest.fas.harvard.edu/data/eml/hf001-11-15min-e.csv"

    data.paths[4]

    ## [1] "http://harvardforest.fas.harvard.edu/data/eml/hf001-04-monthly-m.csv"





