---
layout: post
title: "Introduction to EML in R"
date:   2016-01-04
authors: [Carl Boettiger, Leah A. Wasser]
contributors: []
dateCreated: 2015-12-28
lastModified: 2016-01-05
tags: [metadata-eml]
mainTag: metadata-eml
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
library for `R`. The EML format can us used to document a suite of different
objects including shapefiles & raster data (spatial data), software, hierarchical
data sets and more. However in this lesson we will focus on an EML file that 
documents a tablular data.

##Introduction to EML
The Ecological Metadata Language (EML) is a data specification developed specifically
to document ecological data. An EML file is created using a `XML` based format.
This means that content is embedded within hierarchical tags. For example
the title of a dataset might be embedded in a `<title>` tag as follows:

`<title>Fisher Meteorological Station at Harvard Forest since 2001</title>`

Similarly, the creator of a dataset is also be found in a hierarchical tag
structure.

NOTE: EML BELOW WITH CODE TAGS
<pre><code class="xml">
	<creator>
		  <individualName>
		    <givenName>Emery</givenName>
		    <surName>Boose</surName>
		  </individualName>
	</creator>
</code></pre>

NOTE: EML BELOW JUST INDENTED

    <creator>
      <individualName>
        <givenName>Emery</givenName>
        <surName>Boose</surName>
      </individualName>
    </creator>


The `EML` package for `R` is designed to read and allow users to work with `EML`
format metadata. In this lesson, we will overview the basics of how to access
key metadata that we might need to understand, in order to work with a particular
dataset.

##Work With EML

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

Next, let's view the abstract that describes the data.


    #view dataset abstract (description)
    eml_HARV@dataset@abstract

    ## [1] "The Fisher Meteorological Station became operational on 11 Feb 2001. The Station is located in an open field 200 m north of the Shaler Station, in a site chosen to minimize the angle of surrounding trees above the horizon (currently 15-25 degrees from the station at breast height). The Fisher Station records air temperature, relative humidity, dew point, precipitation (water equivalent of snow), global solar radiation, PAR radiation, net radiation, barometric pressure, scalar wind speed, vector wind speed, peak gust speed (1-second), vector wind direction, standard deviation of wind direction (wind measurements at 10 m height), and soil temperature (10 cm depth). Instruments are scanned once per second, and 15-minute (hourly before 2005) and daily values are calculated and stored by a datalogger. Data for the current month are available online, updated every 15 minutes, with out-of-range values replaced by NA but values not otherwise checked. Earlier data are checked and archived with missing, questionable, and estimated values flagged, following methods of the LTER ClimbDB project. A log of events affecting station measurements (e.g., instrument repair and recalibration, ice storms, lightning) and selected monthly and annual values are also posted.For current data, please see: http://harvardforest.fas.harvard.edu/meteorological-hydrological-stations. For a complete set of archived data, please see: http://harvardforest.fas.harvard.edu:8080/exist/xquery/data.xq?id=hf001."

    #the above might be easier to read if we force line breaks!
    #we can use strwrap to do this
    #write out abstract - forcing line breaks
    strwrap(eml_HARV@dataset@abstract, width = 80)

    ##  [1] "The Fisher Meteorological Station became operational on 11 Feb 2001. The"       
    ##  [2] "Station is located in an open field 200 m north of the Shaler Station, in a"    
    ##  [3] "site chosen to minimize the angle of surrounding trees above the horizon"       
    ##  [4] "(currently 15-25 degrees from the station at breast height). The Fisher Station"
    ##  [5] "records air temperature, relative humidity, dew point, precipitation (water"    
    ##  [6] "equivalent of snow), global solar radiation, PAR radiation, net radiation,"     
    ##  [7] "barometric pressure, scalar wind speed, vector wind speed, peak gust speed"     
    ##  [8] "(1-second), vector wind direction, standard deviation of wind direction (wind"  
    ##  [9] "measurements at 10 m height), and soil temperature (10 cm depth). Instruments"  
    ## [10] "are scanned once per second, and 15-minute (hourly before 2005) and daily"      
    ## [11] "values are calculated and stored by a datalogger. Data for the current month"   
    ## [12] "are available online, updated every 15 minutes, with out-of-range values"       
    ## [13] "replaced by NA but values not otherwise checked. Earlier data are checked and"  
    ## [14] "archived with missing, questionable, and estimated values flagged, following"   
    ## [15] "methods of the LTER ClimbDB project. A log of events affecting station"         
    ## [16] "measurements (e.g., instrument repair and recalibration, ice storms, lightning)"
    ## [17] "and selected monthly and annual values are also posted.For current data, please"
    ## [18] "see: http://harvardforest.fas.harvard.edu/meteorological-hydrological-stations."
    ## [19] "For a complete set of archived data, please see:"                               
    ## [20] "http://harvardforest.fas.harvard.edu:8080/exist/xquery/data.xq?id=hf001."


##Determine Geographic Coverage
Above we were able to view the geographic coverage. Let's plot the x, y values
on a map for reference to ensure that the data are within our study area region of
interest. We can access geographic extent using the slots, which are
accessed in `R` using the `@` sign. 

<i class="fa fa-star"></i> **Data Tip:**  To figure out the full slot string, 
in `RStudio` we can use Tab Complete as we type.
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
suggests that our data were collected at (x,y) one point location. We know this is a 
tower so a point location makes sense. Let's grab the x and y coordinates and 
create a quick context map. We will use `ggmap` to create our map.

**NOTE: if this were a rectangular extent we'd want the bounding BOX. this is important
if the data are for example, raster format, in HDF5 or something. we need the extent
to properly geolocate and process the data.**

<a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/ggmap/ggmapCheatsheet.pdf" target="_blank">Learn More: A nice cheatsheet for GGMAP created by NCEAS</a>


    # grab x coordinate
    XCoord <- eml_HARV@dataset@coverage@geographicCoverage@boundingCoordinates@westBoundingCoordinate
    #grab y coordinate
    YCoord <- eml_HARV@dataset@coverage@geographicCoverage@boundingCoordinates@northBoundingCoordinate
    
    
    library(ggmap)
    #map <- get_map(location='Harvard', maptype = "terrain")
    map <- get_map(location='massachusetts', maptype = "toner", zoom =8)
    
    ggmap(map, extent=TRUE) +
      geom_point(aes(x=XCoord,y=YCoord), 
                 color="darkred", size=6, pch=18)

![ ]({{ site.baseurl }}/images/rfigs/2015-12-12-Intro-to-EML/map-location-1.png) 

We now have identified and mapped the point location where our data were collected. 
We know the data are close enough to our study area to be useful. Next, let's 
dig into the dataset structure to figure out what metrics that data contain.

##Accessing dataset structure using EML

To understand the data that are available for us to work with, let's first explore
the `data table` structure as outlined in our `EML` file. We can access key components
of the dataset metadata structure using slots via the `@` symbol.

For example `eml_HARV@dataset` will return the entire dataset metadata structure.
Let's view the description of abstract for the dataset.

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


    #we can view the data table name and description as follows
    eml_HARV@dataset@dataTable[[1]]@entityName

    ## [1] "hf001-01-station-log.csv"

    eml_HARV@dataset@dataTable[[1]]@entityDescription

    ## [1] "station log"

    #view download path
    eml_HARV@dataset@dataTable[[1]]@physical@distribution@online@url

    ## [1] "http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-01-station-log.csv"


To create a data frame with the 3 pieces of information abouve listed for each
data table, we first can create  an object that contains EML information for
just the data tables. Then we can use `purrr` to efficiently extract the 
information for each data table. 


    #create an object that just contains dataTable level attributes
    all.tables <- eml_HARV@dataset@dataTable
    
    #use purrrr to generate a data.frame that contains the attrName and Def for each column
    dataTable.desc <- purrr::map_df(all.tables, 
                  function(x) data_frame(attribute = x@entityName, 
                            description = x@entityDescription,
                            download.path = x@physical@distribution@online@url))
    
    #view table descriptions
    dataTable.desc

    ## Source: local data frame [11 x 3]
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
    ## Variables not shown: download.path (chr)

    #view just the paths (they are too long to render in the output above)
    head(dataTable.desc[3])

    ## Source: local data frame [6 x 1]
    ## 
    ##                                                                 download.path
    ##                                                                         (chr)
    ## 1 http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-01-station-log.cs
    ## 2   http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-02-annual-m.csv
    ## 3   http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-03-annual-e.csv
    ## 4  http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv
    ## 5  http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-05-monthly-e.csv
    ## 6    http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-06-daily-m.csv

    #how many rows (data tables) are in the data_frame?
    nrow(dataTable.desc)

    ## [1] 11

**NOTE: the above code is complex given the length of the slot calls. It would be 
VERY NICE to have a function to help the user along with quickly generating / accessing
data table attributes and descriptions.**


Sweet! We now know there are 11 total data tables in this dataset. From the descriptions,
we have a sense of the temporal coverage (date range) and associated temporal
scale (15 min average, daily average, monthly average, etc). We also have the 
path to download each file directly if we'd like to. This is a lot of 
information to get us going!

The data table of most interest to us now, is hourly average, in metric units.
`hf001-08-hourly-m.csv`.

#Data Table Metadata
Let's next explore the attributes of Data Table 8 - `hf001-08-hourly-m.csv`. We 
can explore its name, description, physical characteristics and identifier.


    #create an object that contains metadata for table 8 only
    EML.hr.dataTable <- obj@dataset@dataTable[[8]]

    ## Error in eval(expr, envir, enclos): object 'obj' not found

    #Check out the table's name - make sure it's the right table!
    EML.hr.dataTable@entityName

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found

    #what information does this data table contain?
    EML.hr.dataTable@entityDescription

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found

    #how is the text file delimited?
    EML.hr.dataTable@physical

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found

    #view table id
    EML.hr.dataTable@id

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found

    #this is the download URL for the file.
    EML.hr.dataTable@physical@distribution@online@url

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found


##View Data Table Fields (attributes)
We can access the attributes of a data table using similar syntax to the dataset 
access.

However: 

* Instead of using `entityName` we will use `attributeName`
* Instead of using `entityDescription` we will use `attributeDescription`

Let's explore the dataTable attributes


    #get list of measurements for the 10th data table in the EML file
    EML.hr.attr <- EML.hr.dataTable@attributeList@attribute

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found

    #the first column is the date field
    EML.hr.attr[[1]]

    ## Error in eval(expr, envir, enclos): object 'EML.hr.attr' not found

    #view the column name and description for the first column
    EML.hr.attr[[1]]@attributeName

    ## Error in eval(expr, envir, enclos): object 'EML.hr.attr' not found

    EML.hr.attr[[1]]@attributeDefinition

    ## Error in eval(expr, envir, enclos): object 'EML.hr.attr' not found


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
    # and create a data_frame with only the attribute name and description
    
    #dplyr approach
    #do.call(rbind, 
    #        lapply(EML.15min.attr, function(x) data.frame(column.name = x@attributeName, 
    #                                             definition = x@attributeDefinition)))
    
    #use purrrr to generate a dplyr data_frame that contains the attrName 
    #and Def for each column
    EML.hr.attr.dt8 <- purrr::map_df(EML.hr.attr, 
                  function(x) data_frame(attribute = x@attributeName, 
                              description = x@attributeDefinition))

    ## Error in map(.x, .f, ...): object 'EML.hr.attr' not found

    EML.hr.attr.dt8

    ## Error in eval(expr, envir, enclos): object 'EML.hr.attr.dt8' not found

    #view first 6 rows for each column 
    head(EML.hr.attr.dt8$attribute)

    ## Error in head(EML.hr.attr.dt8$attribute): object 'EML.hr.attr.dt8' not found

    head(EML.hr.attr.dt8$description)

    ## Error in head(EML.hr.attr.dt8$description): object 'EML.hr.attr.dt8' not found

From our data.frame generated above, we can see that this data table contains 
air temperature and precipitation - two key drivers of phenology. 

##Download Data Table

We've now have:

* successfully explored the dataset described in our `EML` file
* identified the location where the data was collected and determined it is in the 
desired range of our study area.
* Identified the sub data tables described in the data set
* Explored the data contained in the data tables and identified a table that we'd 
like to work with

Thus, let's go ahead and download the data table of interest. Using the EML
file, we identified the URL where Table "8" can be downloaded:

`EML.hr.dataTable@physical@distribution@online@url`

We can use that output, with the base R `read.csv()` function to import the data
table into a `dplyr data_frame`.



    #view url
    EML.hr.dataTable@physical@distribution@online@url

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found

    #Read in csv (data table 8)
    month.avg.m.HARV <- read.csv(EML.hr.dataTable@physical@distribution@online@url,
                                 stringsAsFactors = FALSE)

    ## Error in read.table(file = file, header = header, sep = sep, quote = quote, : object 'EML.hr.dataTable' not found

    str(month.avg.m.HARV)

    ## Error in str(month.avg.m.HARV): object 'month.avg.m.HARV' not found

    # view table structure
    EML.hr.dataTable@physical

    ## Error in eval(expr, envir, enclos): object 'EML.hr.dataTable' not found

We are now ready to work with the data!

<div id="challenge" markdown="1">
Questions

1. How many header lines does the csv contain?
2. What is the field delimiter (e.g. comma, tab, etc)
3. What time zone is the data in (we will need this to convert the date time field)
4. Is there a `noData` value? If so, what is it?

HINT: it may be easier to skim the metadata using search to discover answers to 
some of the questions above. Why?
</div>



#OTHER STUFF

`eml_get(obj,"csv_filepaths")`

**NOTE - THESE PATHS ARE NOT THE CORRECT PATHS TO THE DATA - what are they??**


    ###THIS IS THE WRONG OUTPUT FOR SOME REASON??
    #what are the names of those tables?
    data.paths <- eml_get(obj,"csv_filepaths")

    ## Error in is(eml, "eml"): object 'obj' not found

    data.paths

    ## Error in eval(expr, envir, enclos): object 'data.paths' not found

    data.paths[4]

    ## Error in eval(expr, envir, enclos): object 'data.paths' not found





