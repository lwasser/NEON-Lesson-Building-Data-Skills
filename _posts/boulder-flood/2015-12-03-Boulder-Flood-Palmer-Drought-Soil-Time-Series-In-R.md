---
layout: post
title: "Visualize Palmer Drought Index & Soil Moisture Data in 
R to Better Understand - the 2013 Colorado Floods"
date: 2015-12-07
authors: [Leah A. Wasser, Mariela Perignon]
dateCreated: 2015-05-18
lastModified: 2015-12-14
categories: [Coding and Informatics]
category: coding-and-informatics
tags: [R, time-series]
mainTag: GIS-Spatial-Data
scienceThemes: [phenology, disturbance]
description: "This lesson walks through the steps need to download and visualize
Palmer Drought Index Data in R 
to better understand the Drivers and Impacts of the 2013 Colorado floods."
image:
  feature: TeachingModules.jpg
  credit: A National Ecological Observatory Network (NEON) - Teaching Module
  creditlink: http://www.neoninc.org
permalink: /R/Boulder-Flood-Palmer-Drought-Soil-Moisture-Data-R/
code1: Boulder-Flood-Data.R
comments: false
---

{% include _toc.html %}

Several factors contributed to extreme flooding that occured in Boulder, Colorado 
in 2013. In this lesson, we will explore several key variables including:

* precipipitation (rainfall) data collected by ???NDCD?? 
* measures of drought prior to the flooding that explain ...
* increased stream discharge (or flow) that occured due to combination of the drought 
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

The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard</a> and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin</a> field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
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
    library(plotly) #create interactive plots

#Soil Moisture

** we could get this from NDCD as well
Boulder station w Soil Moisture:
https://www.drought.gov/drought/content/tools/crn-soil-data#

CRN Station
ID: 1045
LAT:40.0354
LON:-105.54090000000001
Name: BOULDER 14 W
View Data

#Drought Data - the Palmer Drought Index
The Palmer Drought Severity Index is an overall index of drought that is
useful to understand drought associated with agriculture. It uses temperature and 
precipitation data and soil moisture to calculate water supply and demand.

#About downloading the data...
Get the data here:
http://www7.ncdc.noaa.gov/CDO/CDODivisionalSelect.jsp
Metrics:

| Abbreviation | Metric                                 |
|--------------|----------------------------------------|
| PCP          | Precipitation Index                    |
| TAVG         | Temperature Index                      |
| TMIN         | Minimum Temperature Index              |
| TMAX         | Maximum Temperature Index              |
| PDSI         | Palmer Drought Severity Index          |
| PHDI         | Palmer Hydrological Drought Index      |
| ZNDX         | Palmer Z-Index                         |
| PMDI         | Modified Palmer Drought Severity Index |
| CDD          | Cooling Degree Days                    |
| HDD          | Heating Degree Days                    |
| SPnn         | Standard Precipitation Index           |

01 - Ar Drainage Baisin
02 - CO Drainage Basin
03 - KS Drainage Basin
04- Platte Drainage
05 Rio Grand
Stuff about the index will go here

https://www.drought.gov/drought/content/products-current-drought-and-monitoring-drought-indicators/palmer-drought-severity-index

We are interested in looking at the general state of drought in Colorado before
the 2013 floods. The data are in the drought directory of your download here:
`drought/CDODiv8721376888863_CO.txt`. To begin, we will read the data into `R`.

Our data have a header - the first row repsents the variable name for each column.
Thus we will use `header=TRUE` when we import the data to tell `R` to use that row
as a column name rather than a row of data.


    #Import State Wide index data
    drought <- read.csv("drought/CDODiv8721376888863_CO.txt", header = TRUE)
    head(drought)

    ##   StateCode Division YearMonth  PCP TAVG  PDSI  PHDI  ZNDX  PMDI CDD  HDD
    ## 1         5        0    199001 0.96 26.4 -3.42 -3.42 -1.69 -3.42   0 1144
    ## 2         5        0    199002 1.08 27.7 -3.65 -3.65 -1.74 -3.65   0 1038
    ## 3         5        0    199003 1.99 36.6 -3.65 -3.65 -1.12 -3.65   0  903
    ## 4         5        0    199004 2.08 45.1 -3.37 -3.37 -0.31 -3.37   0  609
    ## 5         5        0    199005 1.97 50.5 -3.02 -3.02  0.01 -2.96   0  446
    ## 6         5        0    199006 0.74 65.3 -3.59 -3.59 -2.64 -3.59  97   73
    ##    SP01  SP02  SP03  SP06  SP09  SP12  SP24 TMIN TMAX  X
    ## 1 -0.03 -0.59 -1.40 -1.13 -0.98 -1.34 -1.38 13.8 39.1 NA
    ## 2  0.06 -0.08 -0.55 -1.22 -0.78 -1.45 -1.26 15.5 39.9 NA
    ## 3  0.90  0.74  0.52 -0.89 -0.76 -1.07 -1.08 24.7 48.5 NA
    ## 4  0.51  0.80  0.73 -0.21 -0.51 -0.56 -0.95 31.8 58.3 NA
    ## 5  0.09  0.32  0.59  0.25 -0.42 -0.33 -1.02 36.6 64.5 NA
    ## 6 -1.26 -0.62 -0.26 -0.01 -0.76 -0.75 -1.31 48.9 81.6 NA

    #view data structure
    str(drought)

    ## 'data.frame':	311 obs. of  21 variables:
    ##  $ StateCode: int  5 5 5 5 5 5 5 5 5 5 ...
    ##  $ Division : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ YearMonth: int  199001 199002 199003 199004 199005 199006 199007 199008 199009 199010 ...
    ##  $ PCP      : num  0.96 1.08 1.99 2.08 1.97 0.74 3.25 1.76 2.1 1.61 ...
    ##  $ TAVG     : num  26.4 27.7 36.6 45.1 50.5 65.3 66 64.8 61.2 46.7 ...
    ##  $ PDSI     : num  -3.42 -3.65 -3.65 -3.37 -3.02 -3.59 -2.54 -2.45 -1.83 -1.39 ...
    ##  $ PHDI     : num  -3.42 -3.65 -3.65 -3.37 -3.02 -3.59 -2.54 -2.45 -1.83 -1.39 ...
    ##  $ ZNDX     : num  -1.69 -1.74 -1.12 -0.31 0.01 -2.64 2.06 -0.53 1.11 0.75 ...
    ##  $ PMDI     : num  -3.42 -3.65 -3.65 -3.37 -2.96 -3.59 -1.67 -1.75 -0.67 0.04 ...
    ##  $ CDD      : int  0 0 0 0 0 97 74 62 35 0 ...
    ##  $ HDD      : int  1144 1038 903 609 446 73 45 55 141 563 ...
    ##  $ SP01     : num  -0.03 0.06 0.9 0.51 0.09 -1.26 1.84 -0.36 0.95 0.48 ...
    ##  $ SP02     : num  -0.59 -0.08 0.74 0.8 0.32 -0.62 0.43 0.95 0.48 0.87 ...
    ##  $ SP03     : num  -1.4 -0.55 0.52 0.73 0.59 -0.26 0.38 0.12 1.25 0.56 ...
    ##  $ SP06     : num  -1.13 -1.22 -0.89 -0.21 0.25 -0.01 0.63 0.46 0.56 0.53 ...
    ##  $ SP09     : num  -0.98 -0.78 -0.76 -0.51 -0.42 -0.76 0.05 0.21 0.68 0.77 ...
    ##  $ SP12     : num  -1.34 -1.45 -1.07 -0.56 -0.33 -0.75 -0.26 -0.31 -0.04 0.31 ...
    ##  $ SP24     : num  -1.38 -1.26 -1.08 -0.95 -1.02 -1.31 -0.85 -0.81 -0.77 -0.39 ...
    ##  $ TMIN     : num  13.8 15.5 24.7 31.8 36.6 48.9 52.2 50.1 47.1 32.1 ...
    ##  $ TMAX     : num  39.1 39.9 48.5 58.3 64.5 81.6 79.8 79.5 75.3 61.2 ...
    ##  $ X        : logi  NA NA NA NA NA NA ...

##Date Fields

Let's have a look at the date field in our data. Viewing the structure, it appears
as if it is not in a standard format. It imported into R as an integer.

`$ YearMonth: int  199001 199002 199003 199004 199005  ...`

We want to convert these numbers into a date field. We can use the `as.Date` 
function to convert our string of numbers into a date that `R` will recognize.


    #view structure of date field
    str(drought$YearMonth)

    ##  int [1:311] 199001 199002 199003 199004 199005 199006 199007 199008 199009 199010 ...

    #convert to date
    drought$YearMonth <- as.Date(drought$YearMonth, format="%Y%m%d")

    ## Error in as.Date.numeric(drought$YearMonth, format = "%Y%m%d"): 'origin' must be supplied

When we tried to convert our numeric string to a date, `R` returned an origin error.
`R` needs a day of the month in order to properly convert this to a date class.

We can add this using the `paste0` function. Let's add `01` to each field so `R`
thinks each date represents the first of the month.


    #convert date field (YearMonth) to date class
    
    #add a day of the month to each year-month combination
    drought$YearMonth <- paste0(drought$YearMonth,"01")
    
    #convert to date
    drought$YearMonth <- as.Date(drought$YearMonth, format="%Y%m%d")

We've now successfully converted our `YearMonth` column into a date class. Next, 
let's plot the data using ggplot.


    #plot Palmer Drought Index
    palmer.drought <- ggplot(data=drought,
           aes(YearMonth,PDSI)) +
           geom_bar(stat="identity",position = "identity") +
           xlab("Year / Month") + ylab("Palmer Drought Severity Index") +
           ggtitle("Palmer Drought Severity Index - Colorado\nNA values included")
    
    palmer.drought

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Palmer-Drought-Soil-Time-Series-In-R/create-quick-palmer-plot-1.png) 

Great - we've successfully created a plot, but what is going on with the Y axis?
It appears as if we have values that extend to -100.
Let's look at a quick summery of our data.


    #viw summary stats of the Palmer Drought Severity Index
    summary(drought$PDSI)

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -99.9900  -2.1900  -0.0600  -0.7354   1.6300   5.0200

    #view histogram of the data
    hist(drought$PDSI,
         main="Histogram of PDSI value",
         col="wheat3")

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Palmer-Drought-Soil-Time-Series-In-R/summary-stats-1.png) 

It appears as if we have a negative value `-99.99` that is throwing off our plot. 
This value is a `no data` value. We need to assign this value to `NA`, which is `R`'s 
representation of a null or no data value. 

Then we can plot again!


    #assign -99.99 to NA in the PDSI column
    #note: you may want to do this across the entire data.frame or with other columns.
    drought[drought$PDSI==-99.99,] <-  NA
    
    #view the histogram again - does the range look reasonable?
    hist(drought$PDSI,
         main="Histogram of PDSI value with -99.99 removed",
         col="springgreen4")

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Palmer-Drought-Soil-Time-Series-In-R/unnamed-chunk-1-1.png) 

    #plot Palmer Drought Index
    ggplot(data=drought,
           aes(YearMonth,PDSI)) +
           geom_bar(stat="identity",position = "identity") +
           xlab("Year") + ylab("Palmer Drought Severity Index") +
           ggtitle("Palmer Drought Severity Index - Colorado\n1990 to 2015")

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Palmer-Drought-Soil-Time-Series-In-R/unnamed-chunk-1-2.png) 

##Plot.ly - Free Online Interactive Plots

We can create an interactive version of our plot using `plot.ly`.


    #plot Palmer Drought Index
    ggplot(data=drought,
           aes(YearMonth,PDSI)) +
           geom_bar(stat="identity",position = "identity") +
           xlab("Year") + ylab("Palmer Drought Severity Index") +
           ggtitle("Palmer Drought Severity Index - Colorado\n1990 to 2015")

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Palmer-Drought-Soil-Time-Series-In-R/create-plotly-drought-plot1-1.png) 

    #view plotly plot in R
    #note - plotly doesn't recognize \n to create a second title line
    ggplotly()

<!--html_preserve--><div id="htmlwidget-1164" style="width:504px;height:504px;" class="plotly"></div>
<script type="application/json" data-for="htmlwidget-1164">{"x":{"data":[{"x":[631152000000,633830400000,636249600000,638928000000,641520000000,644198400000,646790400000,649468800000,652147200000,654739200000,657417600000,660009600000,662688000000,665366400000,667785600000,670464000000,673056000000,675734400000,678326400000,681004800000,683683200000,686275200000,688953600000,691545600000,694224000000,696902400000,699408000000,702086400000,704678400000,707356800000,709948800000,712627200000,715305600000,717897600000,720576000000,723168000000,725846400000,728524800000,730944000000,733622400000,736214400000,738892800000,741484800000,744163200000,746841600000,749433600000,752112000000,754704000000,757382400000,760060800000,762480000000,765158400000,767750400000,770428800000,773020800000,775699200000,778377600000,780969600000,783648000000,786240000000,788918400000,791596800000,794016000000,796694400000,799286400000,801964800000,804556800000,807235200000,809913600000,812505600000,815184000000,817776000000,820454400000,823132800000,825638400000,828316800000,830908800000,833587200000,836179200000,838857600000,841536000000,844128000000,846806400000,849398400000,852076800000,854755200000,857174400000,859852800000,862444800000,865123200000,867715200000,870393600000,873072000000,875664000000,878342400000,880934400000,883612800000,886291200000,888710400000,891388800000,893980800000,896659200000,899251200000,901929600000,904608000000,907200000000,909878400000,912470400000,915148800000,917827200000,920246400000,922924800000,925516800000,928195200000,930787200000,933465600000,936144000000,938736000000,941414400000,944006400000,946684800000,949363200000,951868800000,954547200000,957139200000,959817600000,962409600000,965088000000,967766400000,970358400000,973036800000,975628800000,978307200000,980985600000,983404800000,986083200000,988675200000,991353600000,993945600000,996624000000,999302400000,1001894400000,1004572800000,1007164800000,1009843200000,1012521600000,1014940800000,1017619200000,1020211200000,1022889600000,1025481600000,1028160000000,1030838400000,1033430400000,1036108800000,1038700800000,1041379200000,1044057600000,1046476800000,1049155200000,1051747200000,1054425600000,1057017600000,1059696000000,1062374400000,1064966400000,1067644800000,1070236800000,1072915200000,1075593600000,1078099200000,1080777600000,1083369600000,1086048000000,1088640000000,1091318400000,1093996800000,1096588800000,1099267200000,1101859200000,1104537600000,1107216000000,1109635200000,1112313600000,1114905600000,1117584000000,1120176000000,1122854400000,1125532800000,1128124800000,1130803200000,1133395200000,1136073600000,1138752000000,1141171200000,1143849600000,1146441600000,1149120000000,1151712000000,1154390400000,1157068800000,1159660800000,1162339200000,1164931200000,1167609600000,1170288000000,1172707200000,1175385600000,1177977600000,1180656000000,1183248000000,1185926400000,1188604800000,1191196800000,1193875200000,1196467200000,1199145600000,1201824000000,1204329600000,1207008000000,1209600000000,1212278400000,1214870400000,1217548800000,1220227200000,1222819200000,1225497600000,1228089600000,1230768000000,1233446400000,1235865600000,1238544000000,1241136000000,1243814400000,1246406400000,1249084800000,1251763200000,1254355200000,1257033600000,1259625600000,1262304000000,1264982400000,1267401600000,1270080000000,1272672000000,1275350400000,1277942400000,1280620800000,1283299200000,1285891200000,1288569600000,1291161600000,1293840000000,1296518400000,1298937600000,1301616000000,1304208000000,1306886400000,1309478400000,1312156800000,1314835200000,1317427200000,1320105600000,1322697600000,1325376000000,1328054400000,1330560000000,1333238400000,1335830400000,1338508800000,1341100800000,1343779200000,1346457600000,1349049600000,1351728000000,1354320000000,1356998400000,1359676800000,1362096000000,1364774400000,1367366400000,1370044800000,1372636800000,1375315200000,1377993600000,1380585600000,1383264000000,1385856000000,1388534400000,1391212800000,1393632000000,1396310400000,1398902400000,1401580800000,1404172800000,1406851200000,1409529600000,1412121600000,1414800000000,1417392000000,1420070400000,1422748800000,1425168000000,1427846400000,1430438400000,1433116800000,1435708800000,1438387200000,1441065600000,1443657600000],"y":[-3.42,-3.65,-3.65,-3.37,-3.02,-3.59,-2.54,-2.45,-1.83,-1.39,-1.16,-1.19,-1.37,-1.95,-1.77,-1.89,-2.11,0.11,0.6,1.03,0.95,0.67,1.76,1.59,1.35,1.19,1.4,-0.99,-1.04,0.54,1.17,2.19,1.52,1.02,1.52,1.51,1.98,2.99,3.14,2.98,2.84,2.68,2.04,2.7,2.48,2.86,3.1,-0.19,-0.29,-0.1,-0.58,-0.09,-0.48,-0.78,-1.65,-1.55,-1.68,0.54,1.08,0.73,0.69,0.56,0.84,1.7,3.83,4.81,5.02,4.5,4.57,3.68,2.89,2.14,2.25,2.15,1.78,1.22,0.86,0.82,0.89,0.73,1.43,1.6,1.72,1.73,2.24,2.36,1.47,2.18,1.92,2.39,2.57,3.83,4.38,4.8,4.81,4.51,4.24,4.26,4.58,4.36,3.12,2.62,3.62,3.32,2.4,3.07,2.85,-0.28,-0.21,-0.57,-1.52,1.93,2.39,2.51,3.13,4.29,4.16,-0.5,-1.48,-1.74,-1.61,-1.69,-1.12,-1.51,-2.22,-2.61,-3.13,-3.22,-3.15,-2.54,-2.42,-2.55,-2.58,-2.55,-2.74,-2.86,-2.29,-2.68,-2.47,-2.4,-2.64,-2.94,-2.9,-3.19,-3.57,-4.23,-4.75,-5.75,-6.79,-7.85,-9.01,-9.09,-7.85,-6.66,-6.12,-6.05,-6.28,-5.83,-5.31,-5.15,-5.01,-4.22,-4.87,-4.89,-4.44,-4.98,-4.29,-4.12,-4.04,-3.72,-4.74,-3.65,-4.48,0.04,0.18,0.16,0.75,0.83,1.27,0.95,1.65,1.79,1.79,1.81,1.24,1.74,-0.63,-0.41,-0.56,0.7,-0.35,-0.45,-0.58,-1.18,-1.3,-2.16,-3.2,-4.17,-0.04,0.3,1,2.16,1.67,1.95,1.89,1.83,-0.55,-0.29,-0.22,-0.32,-0.39,0.19,0.38,-0.2,-1.09,1.04,1.42,1.8,0.01,-0.19,-0.36,-0.55,-1.05,0.89,-0.24,-0.28,-0.73,-0.2,-0.3,-0.61,-1.16,0.4,0.18,1.12,1.63,1.11,1.1,1.94,1.28,1.41,1.25,1.38,1.53,1.69,1.23,1.06,1.19,1.37,-0.7,-0.67,-0.73,-0.28,-0.56,-0.52,-1.01,0.18,0.8,0.45,0.85,-0.38,-0.5,-0.19,-0.32,-0.53,-0.95,-0.89,-2.31,-3.04,-4.15,-5.67,-5.99,-6.75,-6.46,-6.28,-6.73,-6.27,-6.23,-6.35,-6.67,-6.09,-6.03,-6.71,-6.4,-5.9,1.74,1.99,1.82,1.43,1.34,1.31,0.84,0.44,0.47,0.18,0.65,1.24,1.63,-0.28,0.08,0.28,-0.29,-0.06,-0.92,-0.98,2.56,2.71,3.1,2.77,1.8,1.71],"type":"bar","text":[null],"name":{},"marker":{"color":{}},"xaxis":"x1","yaxis":"y1","showlegend":false,"bargap":"default","barmode":"stack"}],"layout":{"barmode":"stack","xaxis":{"tickcolor":"rgb(127,127,127)","gridcolor":"rgb(255,255,255)","showgrid":true,"ticks":"outside","showticklabels":true,"type":"date","title":"Year","zeroline":false,"showline":false},"yaxis":{"tickcolor":"rgb(127,127,127)","gridcolor":"rgb(255,255,255)","showgrid":true,"ticks":"outside","showticklabels":true,"type":"linear","title":"Palmer Drought Severity Index","zeroline":false,"showline":false},"title":"Palmer Drought Severity Index - Colorado\n1990 to 2015","plot_bgcolor":"rgb(229,229,229)","margin":{"b":40,"l":60,"t":25,"r":10},"legend":{"bordercolor":"transparent","x":1.01,"y":0.4875,"xref":"paper","yref":"paper","xanchor":"left","yanchor":"top","font":{"family":""},"bgcolor":"rgb(255,255,255)"},"showlegend":false,"titlefont":{"family":""},"paper_bgcolor":"rgb(255,255,255)"},"world_readable":true},"evals":[]}</script><!--/html_preserve-->

    #publish plotly plot to your plot.ly online account when you are happy with it
    #plotly_POST(droughtPlot.plotly)

#NOTE: we will have to manually present the plot.ly plot here as an embed as R won't 
knit it out.

##Subsetting our data

Once we have a column of data defined as a date, class in R, we can quickly subset
the data to view portions of the data. We can subset the data directly in our
`ggplot` command however that will not translate to `plot.ly`. So let's create a 
new `r` object that is represents drought data from 2005-2015.

We will then plot that using `ggplot` and `plot.ly`.

To subset, we use the `subset` function, and specify:

1. the R object that we wish to subset
2. the date column and start date of the subset
3. the date column and end date of the subset

Let's subset our data.


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

![ ]({{ site.baseurl }}/images/rfigs/2015-12-03-Boulder-Flood-Palmer-Drought-Soil-Time-Series-In-R/plotly-drought-1.png) 

    #view plotly plot in R
    ggplotly()

<!--html_preserve--><div id="htmlwidget-5382" style="width:504px;height:504px;" class="plotly"></div>
<script type="application/json" data-for="htmlwidget-5382">{"x":{"data":[{"x":[1104537600000,1107216000000,1109635200000,1112313600000,1114905600000,1117584000000,1120176000000,1122854400000,1125532800000,1128124800000,1130803200000,1133395200000,1136073600000,1138752000000,1141171200000,1143849600000,1146441600000,1149120000000,1151712000000,1154390400000,1157068800000,1159660800000,1162339200000,1164931200000,1167609600000,1170288000000,1172707200000,1175385600000,1177977600000,1180656000000,1183248000000,1185926400000,1188604800000,1191196800000,1193875200000,1196467200000,1199145600000,1201824000000,1204329600000,1207008000000,1209600000000,1212278400000,1214870400000,1217548800000,1220227200000,1222819200000,1225497600000,1228089600000,1230768000000,1233446400000,1235865600000,1238544000000,1241136000000,1243814400000,1246406400000,1249084800000,1251763200000,1254355200000,1257033600000,1259625600000,1262304000000,1264982400000,1267401600000,1270080000000,1272672000000,1275350400000,1277942400000,1280620800000,1283299200000,1285891200000,1288569600000,1291161600000,1293840000000,1296518400000,1298937600000,1301616000000,1304208000000,1306886400000,1309478400000,1312156800000,1314835200000,1317427200000,1320105600000,1322697600000,1325376000000,1328054400000,1330560000000,1333238400000,1335830400000,1338508800000,1341100800000,1343779200000,1346457600000,1349049600000,1351728000000,1354320000000,1356998400000,1359676800000,1362096000000,1364774400000,1367366400000,1370044800000,1372636800000,1375315200000,1377993600000,1380585600000,1383264000000,1385856000000,1388534400000,1391212800000,1393632000000,1396310400000,1398902400000,1401580800000,1404172800000,1406851200000,1409529600000,1412121600000,1414800000000,1417392000000,1420070400000,1422748800000,1425168000000,1427846400000,1430438400000,1433116800000,1435708800000,1438387200000,1441065600000,1443657600000],"y":[1.65,1.79,1.79,1.81,1.24,1.74,-0.63,-0.41,-0.56,0.7,-0.35,-0.45,-0.58,-1.18,-1.3,-2.16,-3.2,-4.17,-0.04,0.3,1,2.16,1.67,1.95,1.89,1.83,-0.55,-0.29,-0.22,-0.32,-0.39,0.19,0.38,-0.2,-1.09,1.04,1.42,1.8,0.01,-0.19,-0.36,-0.55,-1.05,0.89,-0.24,-0.28,-0.73,-0.2,-0.3,-0.61,-1.16,0.4,0.18,1.12,1.63,1.11,1.1,1.94,1.28,1.41,1.25,1.38,1.53,1.69,1.23,1.06,1.19,1.37,-0.7,-0.67,-0.73,-0.28,-0.56,-0.52,-1.01,0.18,0.8,0.45,0.85,-0.38,-0.5,-0.19,-0.32,-0.53,-0.95,-0.89,-2.31,-3.04,-4.15,-5.67,-5.99,-6.75,-6.46,-6.28,-6.73,-6.27,-6.23,-6.35,-6.67,-6.09,-6.03,-6.71,-6.4,-5.9,1.74,1.99,1.82,1.43,1.34,1.31,0.84,0.44,0.47,0.18,0.65,1.24,1.63,-0.28,0.08,0.28,-0.29,-0.06,-0.92,-0.98,2.56,2.71,3.1,2.77,1.8,1.71],"type":"bar","text":[null],"name":{},"marker":{"color":{}},"xaxis":"x1","yaxis":"y1","showlegend":false,"bargap":"default","barmode":"stack"}],"layout":{"barmode":"stack","xaxis":{"tickcolor":"rgb(127,127,127)","gridcolor":"rgb(255,255,255)","showgrid":true,"ticks":"outside","showticklabels":true,"type":"date","title":"Year / Month","zeroline":false,"showline":false},"yaxis":{"tickcolor":"rgb(127,127,127)","gridcolor":"rgb(255,255,255)","showgrid":true,"ticks":"outside","showticklabels":true,"type":"linear","title":"Palmer Drought Severity Index","zeroline":false,"showline":false},"title":"Palmer Drought Severity Index - Colorado\n2005 - 2015","plot_bgcolor":"rgb(229,229,229)","margin":{"b":40,"l":60,"t":25,"r":10},"legend":{"bordercolor":"transparent","x":1.01,"y":0.4875,"xref":"paper","yref":"paper","xanchor":"left","yanchor":"top","font":{"family":""},"bgcolor":"rgb(255,255,255)"},"showlegend":false,"titlefont":{"family":""},"paper_bgcolor":"rgb(255,255,255)"},"world_readable":true},"evals":[]}</script><!--/html_preserve-->

    #publish plotly plot to your plot.ly online account when you are happy with it
    #plotly_POST(droughtPlot.plotly)

#Need to remember where i got the data from. I have a feeling all could be 
accessed via the API!! but i can't remember how i found PDSI.

This is my order url - but it's expired.
http://www1.ncdc.noaa.gov/pub/orders/CDODiv5787606888799.txt

drought <- read.


#Challenge
Another dataset - import and plot
