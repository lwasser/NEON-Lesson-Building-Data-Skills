---
layout: post
title: "INTRO to  EML"
date:   2015-12-28
authors: []
contributors: [Leah A. Wasser]
dateCreated: 2015-10-22
lastModified: 2015-12-28
tags: [spatio-temporal, time-series, phenology]
mainTag: time-series
packagesLibraries: [eml]
category: 
description: "this lesson teaches you stuff. "
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/EML
comments: false
---

{% include _toc.html %}


    #install R EML tools
    #library("devtools")
    #install_github("ropensci/EML", build=FALSE, dependencies=c("DEPENDS", "IMPORTS"))
    
    #call package
    library("EML")

Next, read in the EML doc of interest. We are using data from the Harvard 
Forest LTER tower. This file documents multiple data products that can be downloaded.


    #import EML from Harvard Forest Met Data
    obj <- eml_read("http://harvardforest.fas.harvard.edu/data/eml/hf001.xml")
    
    #view size of object
    object.size(obj)

    ## 287015216 bytes

##Getting Started

An eml file seems to consist of

1. a **dataset** - this is similar to a NEON data product. A dataset may contain
one or more data tables associated with it that has different types of related
information. FOr the harvard data, we are looking at tower measurements, aggregated
at various time intervales (15 minute, daily, etc).
2. **data tables** these are the actual data that make up the dataset. At NEON
we call these sub products.

To begin, i'd like to quickly scan the EML file and understand the 
dataset and data table structure. Id like one output list that helps me understand
structure.




    #How many data tables are described / included in this dataset?
    length(obj@dataset@dataTable)

    ## [1] 11

    #what are the names of those tables?
    eml_get(obj,"csv_filepaths")

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

#view Attributes for a file of interest

I am interested in working with the monthly average-m csv. #4 in the list. 

I'd like to know the following

1. a list of fields (metrics measured or columns) contained in the file
2. i'd like to be able to query each column to determine attributes like units that
I will need to properly work with the data

The goal is moving towards a reproducible workflow.


    #view metadata for the 4th data table which should be monthly average metric
    obj@dataset@dataTable[[4]]

    ## entityName: hf001-04-monthly-m.csv
    ## entityDescription: monthly (metric) since 2001
    ## physical:
    ##   objectName: hf001-04-monthly-m.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM
    ##     .attrs: '1184531853051'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: average air temperature. Average of daily averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853081'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for average air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: number of daily measurements missing
    ##     .attrs: '1184531853091'
    ##   attribute:
    ##     attributeName: airtmax
    ##     attributeDefinition: average maximum air temperature. Average of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853101'
    ##   attribute:
    ##     attributeName: f.airtmax
    ##     attributeDefinition: flag for average maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: number of daily measurements missing
    ##     .attrs: '1184531853111'
    ##   attribute:
    ##     attributeName: airtmin
    ##     attributeDefinition: average minimum air temperature. Average of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853121'
    ##   attribute:
    ##     attributeName: f.airtmin
    ##     attributeDefinition: flag for average minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing
    ##     .attrs: '1184531853131'
    ##   attribute:
    ##     attributeName: airtmmx
    ##     attributeDefinition: extreme maximum air temperature. Maximum of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853141'
    ##   attribute:
    ##     attributeName: f.airtmmx
    ##     attributeDefinition: flag for extreme maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853151'
    ##   attribute:
    ##     attributeName: airtmmn
    ##     attributeDefinition: extreme minimum air temperature. Minimum of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853161'
    ##   attribute:
    ##     attributeName: f.airtmmn
    ##     attributeDefinition: flag for extreme minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853171'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: total precipitation. Includes water equivalent of snow. Sum
    ##       of daily totals.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: millimeter
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853181'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853191'
    ##   attribute:
    ##     attributeName: slrt
    ##     attributeDefinition: average total global solar radiation. Average of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: megajoulePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853201'
    ##   attribute:
    ##     attributeName: f.slrt
    ##     attributeDefinition: flag for average total global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853211'
    ##   attribute:
    ##     attributeName: part
    ##     attributeDefinition: average total photosynthetically active radiation. Average
    ##       of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: molePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853221'
    ##   attribute:
    ##     attributeName: f.part
    ##     attributeDefinition: flag for average total photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853231'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: average net radiation. Includes short and long wave. Corrected
    ##       for wind speeds above 5 m/s using Cambell Scientific equation. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853241'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for average net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853251'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: average horizontal scalar wind speed. Average of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853261'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for average horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853271'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: Average horizontal resultant vector wind speed. Vector average
    ##       of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853281'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for average horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853291'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: average horizontal vector wind direction. Measured in degrees
    ##       clockwise from true north. Vector average of daily values.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853301'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for average horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853311'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: extreme maximum gust speed. Maximum of daily maximums.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853321'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for extreme maximum gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853331'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: average soil temperature at 10cm depth. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853341'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for average soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853351'
    ## numberOfRecords: '170'
    ## .attrs:
    ## - hf001-04
    ## - document

    #is this the right data table? yes
    obj@dataset@dataTable[[4]]@entityName

    ## [1] "hf001-04-monthly-m.csv"

    #what information does this data table contain?
    obj@dataset@dataTable[[4]]@entityDescription

    ## [1] "monthly (metric) since 2001"

    obj@dataset@dataTable[[4]]@physical

    ## objectName: hf001-04-monthly-m.csv
    ## dataFormat:
    ##   textFormat:
    ##     numHeaderLines: '1'
    ##     recordDelimiter: \r\n
    ##     attributeOrientation: column
    ##     simpleDelimited:
    ##       fieldDelimiter: ','
    ## distribution:
    ##   online:
    ##     url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv

    #view table id
    obj@dataset@dataTable[[4]]@id

    ##         id 
    ## "hf001-04"

Next, id like a nice clean list of attribute names (column names) for just this
data table. i don't need all of the descriptive text just yet. Can i get that?


    #what are the attributes in the data?
    obj@dataset@dataTable[[4]]@attributeList

    ## attribute:
    ##   attributeName: date
    ##   attributeDefinition: date
    ##   measurementScale:
    ##     dateTime:
    ##       formatString: YYYY-MM
    ##   .attrs: '1184531853051'
    ## attribute:
    ##   attributeName: airt
    ##   attributeDefinition: average air temperature. Average of daily averages.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: celsius
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853081'
    ## attribute:
    ##   attributeName: f.airt
    ##   attributeDefinition: flag for average air temperature
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: number of daily measurements missing
    ##   .attrs: '1184531853091'
    ## attribute:
    ##   attributeName: airtmax
    ##   attributeDefinition: average maximum air temperature. Average of daily maximums.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: celsius
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853101'
    ## attribute:
    ##   attributeName: f.airtmax
    ##   attributeDefinition: flag for average maximum air temperature
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: number of daily measurements missing
    ##   .attrs: '1184531853111'
    ## attribute:
    ##   attributeName: airtmin
    ##   attributeDefinition: average minimum air temperature. Average of daily minimums.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: celsius
    ##       precision: '0.01'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853121'
    ## attribute:
    ##   attributeName: f.airtmin
    ##   attributeDefinition: flag for average minimum air temperature
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing
    ##   .attrs: '1184531853131'
    ## attribute:
    ##   attributeName: airtmmx
    ##   attributeDefinition: extreme maximum air temperature. Maximum of daily maximums.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: celsius
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853141'
    ## attribute:
    ##   attributeName: f.airtmmx
    ##   attributeDefinition: flag for extreme maximum air temperature
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853151'
    ## attribute:
    ##   attributeName: airtmmn
    ##   attributeDefinition: extreme minimum air temperature. Minimum of daily minimums.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: celsius
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853161'
    ## attribute:
    ##   attributeName: f.airtmmn
    ##   attributeDefinition: flag for extreme minimum air temperature
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853171'
    ## attribute:
    ##   attributeName: prec
    ##   attributeDefinition: total precipitation. Includes water equivalent of snow. Sum
    ##     of daily totals.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: millimeter
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853181'
    ## attribute:
    ##   attributeName: f.prec
    ##   attributeDefinition: flag for precipitation
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853191'
    ## attribute:
    ##   attributeName: slrt
    ##   attributeDefinition: average total global solar radiation. Average of daily totals.
    ##   measurementScale:
    ##     ratio:
    ##       unit:
    ##         customUnit: megajoulePerMeterSquared
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853201'
    ## attribute:
    ##   attributeName: f.slrt
    ##   attributeDefinition: flag for average total global solar radiation
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853211'
    ## attribute:
    ##   attributeName: part
    ##   attributeDefinition: average total photosynthetically active radiation. Average
    ##     of daily totals.
    ##   measurementScale:
    ##     ratio:
    ##       unit:
    ##         customUnit: molePerMeterSquared
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853221'
    ## attribute:
    ##   attributeName: f.part
    ##   attributeDefinition: flag for average total photosynthetically active radiation
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853231'
    ## attribute:
    ##   attributeName: netr
    ##   attributeDefinition: average net radiation. Includes short and long wave. Corrected
    ##     for wind speeds above 5 m/s using Cambell Scientific equation. Average of daily
    ##     averages.
    ##   measurementScale:
    ##     ratio:
    ##       unit:
    ##         customUnit: wattPerMeterSquared
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853241'
    ## attribute:
    ##   attributeName: f.netr
    ##   attributeDefinition: flag for average net radiation
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853251'
    ## attribute:
    ##   attributeName: wspd
    ##   attributeDefinition: average horizontal scalar wind speed. Average of daily averages.
    ##   measurementScale:
    ##     ratio:
    ##       unit:
    ##         standardUnit: metersPerSecond
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853261'
    ## attribute:
    ##   attributeName: f.wspd
    ##   attributeDefinition: flag for average horizonal scalar wind speed
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853271'
    ## attribute:
    ##   attributeName: wres
    ##   attributeDefinition: Average horizontal resultant vector wind speed. Vector average
    ##     of daily averages.
    ##   measurementScale:
    ##     ratio:
    ##       unit:
    ##         standardUnit: metersPerSecond
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853281'
    ## attribute:
    ##   attributeName: f.wres
    ##   attributeDefinition: flag for average horizonal resultant vector wind speed
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853291'
    ## attribute:
    ##   attributeName: wdir
    ##   attributeDefinition: average horizontal vector wind direction. Measured in degrees
    ##     clockwise from true north. Vector average of daily values.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: degree
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853301'
    ## attribute:
    ##   attributeName: f.wdir
    ##   attributeDefinition: flag for average horizonal vector wind direction
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853311'
    ## attribute:
    ##   attributeName: gspd
    ##   attributeDefinition: extreme maximum gust speed. Maximum of daily maximums.
    ##   measurementScale:
    ##     ratio:
    ##       unit:
    ##         standardUnit: metersPerSecond
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853321'
    ## attribute:
    ##   attributeName: f.gspd
    ##   attributeDefinition: flag for extreme maximum gust speed
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853331'
    ## attribute:
    ##   attributeName: s10t
    ##   attributeDefinition: average soil temperature at 10cm depth. Average of daily averages.
    ##   measurementScale:
    ##     interval:
    ##       unit:
    ##         standardUnit: celsius
    ##       precision: '0.1'
    ##       numericDomain:
    ##         numberType: real
    ##   .attrs: '1184531853341'
    ## attribute:
    ##   attributeName: f.s10t
    ##   attributeDefinition: flag for average soil temperature
    ##   measurementScale:
    ##     nominal:
    ##       nonNumericDomain:
    ##         enumeratedDomain:
    ##           codeDefinition:
    ##             code: M
    ##             definition: 10 or more daily measurements missing. Summary value not calculated.
    ##           codeDefinition:
    ##             code: 1-9
    ##             definition: Number of daily measurements missing.
    ##   .attrs: '1184531853351'

    #view one set of attributes - the first in the list
    obj@dataset@dataTable[[4]]@attributeList@attribute[[1]]

    ## attributeName: date
    ## attributeDefinition: date
    ## measurementScale:
    ##   dateTime:
    ##     formatString: YYYY-MM
    ## .attrs: '1184531853051'

    #for date fields i'd like to know the format and the timezone
    obj@dataset@dataTable[[4]]@attributeList@attribute[[1]]@measurementScale

    ## dateTime:
    ##   formatString: YYYY-MM

    obj@dataset@dataTable[[4]]@attributeList@attribute[[1]]@attributeName

    ## [1] "date"

    #view second attribute in the list - airt
    obj@dataset@dataTable[[4]]@attributeList@attribute[[2]]

    ## attributeName: airt
    ## attributeDefinition: average air temperature. Average of daily averages.
    ## measurementScale:
    ##   interval:
    ##     unit:
    ##       standardUnit: celsius
    ##     precision: '0.1'
    ##     numericDomain:
    ##       numberType: real
    ## .attrs: '1184531853081'

    #I am at the units with the string below
    #phew - long. what i really want is to be able to grab the unit programmatically
    obj@dataset@dataTable[[4]]@attributeList@attribute[[2]]@measurementScale

    ## interval:
    ##   unit:
    ##     standardUnit: celsius
    ##   precision: '0.1'
    ##   numericDomain:
    ##     numberType: real


#View metadata for a column

Next, i'd like to be able to view the units or other attributes for a field that
i might need for processing. For example i need to know the timezone for these
data in order to convert to a time field.

how do i do that?






**NOTE:** The imported object is fairly large - especially considering the XML itself is
quite small.

We can view all EML attributes in YAML format too.

    #view all elements in YAML format
    #note - i've hidden the output as it's too long
    obj

I am not sure what the "attributelist" element returns. This is curious.


    #Get Attributes
    #what is this returning?
    eml_get(obj, "attributeList")

    ## $attribute
    ## $attribute[[1]]
    ## [1] "date"
    ## 
    ## $attribute[[2]]
    ## [1] "date"
    ## 
    ## $attribute[[3]]
    ## [1] "YYYY-MM-DD"
    ## 
    ## 
    ## $attribute
    ## $attribute[[1]]
    ## [1] "notes"
    ## 
    ## $attribute[[2]]
    ## [1] "notes"
    ## 
    ## $attribute[[3]]
    ## [1] "notes"

##What does eml_get do below? it seems to try to download everything.

It hung up my mac processing. Would like to know more. 


    #download in all data that the eml references
    #store it in a data.frame format
    #dat <- eml_get(obj, "data.frame")

The code below works well.


    #view the contact name listed in the file
    #this works well!
    eml_get(obj,"contact")

    ## [1] "Emery Boose <boose@fas.harvard.edu>"

    #grab all keywords in the file
    eml_get(obj,"keywords")

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
    eml_get(obj,"coverage")

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

    #view list of files that you can download as described in the EML object 
    eml_get(obj,"csv_filepaths")

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

#get EML id?


    #not sure what this ID is
    eml_get(obj,"id")

    ## [1] "knb-lter-hfr.1.21"

    #not sure what this is doing either.
    eml = eml_read("knb-lter-hfr.205.4")
    
    eml@dataset@dataTable[[1]]@attributeList@attribute[[2]]

    ## attributeName: year
    ## attributeDefinition: year, 2012
    ## measurementScale:
    ##   dateTime:
    ##     formatString: YYYY
    ## .attrs: '1354213311471'

    obj@dataset@dataTable

    ## An object of class "ListOfdataTable"
    ## [[1]]
    ## entityName: hf001-01-station-log.csv
    ## entityDescription: station log
    ## physical:
    ##   objectName: hf001-01-station-log.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-01-station-log.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM-DD
    ##     .attrs: '1229538797871'
    ##   attribute:
    ##     attributeName: notes
    ##     attributeDefinition: notes
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           textDomain:
    ##             definition: notes
    ##     .attrs: '1229538797887'
    ## numberOfRecords: '170'
    ## .attrs:
    ## - hf001-01
    ## - document
    ## 
    ## [[2]]
    ## entityName: hf001-02-annual-m.csv
    ## entityDescription: annual (metric) since 2002
    ## physical:
    ##   objectName: hf001-02-annual-m.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-02-annual-m.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY
    ##     .attrs: '1185463194329'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: average air temperature. Average of daily averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194339'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for average air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194349'
    ##   attribute:
    ##     attributeName: airtmax
    ##     attributeDefinition: average maximum air temperature. Average of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194359'
    ##   attribute:
    ##     attributeName: f.airtmax
    ##     attributeDefinition: flag for average maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194379'
    ##   attribute:
    ##     attributeName: airtmin
    ##     attributeDefinition: average minimum air temperature. Average of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194389'
    ##   attribute:
    ##     attributeName: f.airtmin
    ##     attributeDefinition: flag for average minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194399'
    ##   attribute:
    ##     attributeName: airtmmx
    ##     attributeDefinition: extreme maximum air temperature. Maximum of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194409'
    ##   attribute:
    ##     attributeName: f.airtmmx
    ##     attributeDefinition: flag for extreme maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194419'
    ##   attribute:
    ##     attributeName: airtmmn
    ##     attributeDefinition: extreme minimum air temperature. Minimum of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194429'
    ##   attribute:
    ##     attributeName: f.airtmmn
    ##     attributeDefinition: flag for extreme minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194439'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: total precipitation. Includes water equivalent of snow. Sum
    ##       of daily totals.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: millimeter
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194449'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194459'
    ##   attribute:
    ##     attributeName: slrt
    ##     attributeDefinition: average total global solar radiation. Average of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: megajoulePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194469'
    ##   attribute:
    ##     attributeName: f.slrt
    ##     attributeDefinition: flag for average total global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194479'
    ##   attribute:
    ##     attributeName: part
    ##     attributeDefinition: average total photosynthetically active radiation. Average
    ##       of daily totals.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           customUnit: molePerMeterSquared
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194489'
    ##   attribute:
    ##     attributeName: f.part
    ##     attributeDefinition: flag for average total photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194499'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: average net radiation. Includes short and long wave. Corrected
    ##       for wind speeds above 5 m/s using Cambell Scientific equation. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194509'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for average net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194519'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: average horizontal scalar wind speed. Average of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194529'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for average horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194539'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: average horizontal resultant vector wind speed. Vector average
    ##       of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194549'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for average horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194560'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: average horizontal vector wind direction. Measured in degrees
    ##       clockwise from true north. Vector average of daily values.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194570'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for average horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194580'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: extreme maximum gust speed. Maximum of daily maximums.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194590'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for extreme maximum gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194600'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: average soil temperature at 10cm depth. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463194610'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for average soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463194620'
    ## numberOfRecords: '13'
    ## .attrs:
    ## - hf001-02
    ## - document
    ## 
    ## [[3]]
    ## entityName: hf001-03-annual-e.csv
    ## entityDescription: annual (english) since 2002
    ## physical:
    ##   objectName: hf001-03-annual-e.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-03-annual-e.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY
    ##     .attrs: '1185463947632'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: average air temperature. Average of daily averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947652'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for average air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947662'
    ##   attribute:
    ##     attributeName: airtmax
    ##     attributeDefinition: average maximum air temperature. Average of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947672'
    ##   attribute:
    ##     attributeName: f.airtmax
    ##     attributeDefinition: flag for average maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947682'
    ##   attribute:
    ##     attributeName: airtmin
    ##     attributeDefinition: average minimum air temperature. Average of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947692'
    ##   attribute:
    ##     attributeName: f.airtmin
    ##     attributeDefinition: flag for average minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947702'
    ##   attribute:
    ##     attributeName: airtmmx
    ##     attributeDefinition: extreme maximum air temperature. Maximum of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947712'
    ##   attribute:
    ##     attributeName: f.airtmmx
    ##     attributeDefinition: flag for extreme maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947723'
    ##   attribute:
    ##     attributeName: airtmmn
    ##     attributeDefinition: extreme minimum air temperature. Minimum of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947733'
    ##   attribute:
    ##     attributeName: f.airtmmn
    ##     attributeDefinition: flag for extreme minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947743'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: total precipitation. Includes water equivalent of snow. Sum
    ##       of daily totals.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: inch
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947753'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for total precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947763'
    ##   attribute:
    ##     attributeName: slrt
    ##     attributeDefinition: average total global solar radiation. Average of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: megajoulePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947773'
    ##   attribute:
    ##     attributeName: f.slrt
    ##     attributeDefinition: flag for average total global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947783'
    ##   attribute:
    ##     attributeName: part
    ##     attributeDefinition: average total photosynthetically active radiation. Average
    ##       of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: numberPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947793'
    ##   attribute:
    ##     attributeName: f.part
    ##     attributeDefinition: flag for average total photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947803'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: average net radiation. Includes short and long wave. Corrected
    ##       for wind speeds above 5 m/s using Cambell Scientific equation. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947813'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947823'
    ##   attribute:
    ##     attributeName: wpsd
    ##     attributeDefinition: average horizontal scalar wind speed. Average of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947833'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for average horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947843'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: average horizontal resultant vector wind speed. Vector average
    ##       of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947853'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for average horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing
    ##     .attrs: '1185463947863'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: average horizontal vector wind direction. Measured in degrees
    ##       clockwise from true north. Vector average of daily values.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947873'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for average horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947883'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: extreme maximum gust speed. Maximum of daily maximums.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947893'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for extreme maximum gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947903'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: average soil temperature at 10cm depth. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185463947913'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for average soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185463947923'
    ## numberOfRecords: '13'
    ## .attrs:
    ## - hf001-03
    ## - document
    ## 
    ## [[4]]
    ## entityName: hf001-04-monthly-m.csv
    ## entityDescription: monthly (metric) since 2001
    ## physical:
    ##   objectName: hf001-04-monthly-m.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM
    ##     .attrs: '1184531853051'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: average air temperature. Average of daily averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853081'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for average air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: number of daily measurements missing
    ##     .attrs: '1184531853091'
    ##   attribute:
    ##     attributeName: airtmax
    ##     attributeDefinition: average maximum air temperature. Average of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853101'
    ##   attribute:
    ##     attributeName: f.airtmax
    ##     attributeDefinition: flag for average maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: number of daily measurements missing
    ##     .attrs: '1184531853111'
    ##   attribute:
    ##     attributeName: airtmin
    ##     attributeDefinition: average minimum air temperature. Average of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853121'
    ##   attribute:
    ##     attributeName: f.airtmin
    ##     attributeDefinition: flag for average minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing
    ##     .attrs: '1184531853131'
    ##   attribute:
    ##     attributeName: airtmmx
    ##     attributeDefinition: extreme maximum air temperature. Maximum of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853141'
    ##   attribute:
    ##     attributeName: f.airtmmx
    ##     attributeDefinition: flag for extreme maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853151'
    ##   attribute:
    ##     attributeName: airtmmn
    ##     attributeDefinition: extreme minimum air temperature. Minimum of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853161'
    ##   attribute:
    ##     attributeName: f.airtmmn
    ##     attributeDefinition: flag for extreme minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853171'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: total precipitation. Includes water equivalent of snow. Sum
    ##       of daily totals.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: millimeter
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853181'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853191'
    ##   attribute:
    ##     attributeName: slrt
    ##     attributeDefinition: average total global solar radiation. Average of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: megajoulePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853201'
    ##   attribute:
    ##     attributeName: f.slrt
    ##     attributeDefinition: flag for average total global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853211'
    ##   attribute:
    ##     attributeName: part
    ##     attributeDefinition: average total photosynthetically active radiation. Average
    ##       of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: molePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853221'
    ##   attribute:
    ##     attributeName: f.part
    ##     attributeDefinition: flag for average total photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853231'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: average net radiation. Includes short and long wave. Corrected
    ##       for wind speeds above 5 m/s using Cambell Scientific equation. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853241'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for average net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853251'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: average horizontal scalar wind speed. Average of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853261'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for average horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853271'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: Average horizontal resultant vector wind speed. Vector average
    ##       of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853281'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for average horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853291'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: average horizontal vector wind direction. Measured in degrees
    ##       clockwise from true north. Vector average of daily values.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853301'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for average horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853311'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: extreme maximum gust speed. Maximum of daily maximums.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853321'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for extreme maximum gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853331'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: average soil temperature at 10cm depth. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531853341'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for average soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1184531853351'
    ## numberOfRecords: '170'
    ## .attrs:
    ## - hf001-04
    ## - document
    ## 
    ## [[5]]
    ## entityName: hf001-05-monthly-e.csv
    ## entityDescription: monthly (english) since 2001
    ## physical:
    ##   objectName: hf001-05-monthly-e.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-05-monthly-e.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM
    ##     .attrs: '1185462067128'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: average air temperature. Average of daily averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067138'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for average air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067148'
    ##   attribute:
    ##     attributeName: airtmax
    ##     attributeDefinition: average maximum air temperature. Average of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067158'
    ##   attribute:
    ##     attributeName: f.airtmax
    ##     attributeDefinition: flag for average maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067168'
    ##   attribute:
    ##     attributeName: airtmin
    ##     attributeDefinition: average minimum air temperature. Average of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067178'
    ##   attribute:
    ##     attributeName: f.airtmin
    ##     attributeDefinition: flag for average minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067188'
    ##   attribute:
    ##     attributeName: airtmmx
    ##     attributeDefinition: extreme maximum air temperature. Maximum of daily maximums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067198'
    ##   attribute:
    ##     attributeName: f.airtmmx
    ##     attributeDefinition: flag for extreme maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067208'
    ##   attribute:
    ##     attributeName: airtmmn
    ##     attributeDefinition: extreme minimum air temperature. Minimum of daily minimums.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067218'
    ##   attribute:
    ##     attributeName: f.airtmmn
    ##     attributeDefinition: flag for extreme minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067228'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: total precipitation. Includes water equivalent of snow. Sum
    ##       of daily totals.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: inch
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067238'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for total precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067249'
    ##   attribute:
    ##     attributeName: slrt
    ##     attributeDefinition: average total global solar radiation. Average of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: megajoulePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067259'
    ##   attribute:
    ##     attributeName: f.slrt
    ##     attributeDefinition: flag for average total global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067269'
    ##   attribute:
    ##     attributeName: part
    ##     attributeDefinition: average total photosynthetically active radiation. Average
    ##       of daily totals.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: molePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067279'
    ##   attribute:
    ##     attributeName: f.part
    ##     attributeDefinition: flag for average total photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067289'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: average net radiation. Includes short and long wave. Corrected
    ##       for wind speeds above 5 m/s using Cambell Scientific equation. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067299'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067309'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: average horizontal scalar wind speed. Average of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067319'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for average horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067329'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: average horizontal resultant vector wind speed. Vector average
    ##       of daily averages.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067339'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for average horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067349'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: average horizontal vector wind direction. Measured in degrees
    ##       clockwise from true north. Vector average of daily values.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067359'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for average horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067369'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: extreme maximum gust speed. Maximum of daily maximums.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067379'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for extreme maximum gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067389'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: average soil temperature at 10cm depth. Average of daily
    ##       averages.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1185462067399'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for average soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: 10 or more daily measurements missing. Summary value not
    ##                 calculated.
    ##             codeDefinition:
    ##               code: 1-9
    ##               definition: Number of daily measurements missing.
    ##     .attrs: '1185462067409'
    ## numberOfRecords: '170'
    ## .attrs:
    ## - hf001-05
    ## - document
    ## 
    ## [[6]]
    ## entityName: hf001-06-daily-m.csv
    ## entityDescription: daily (metric) since 2001
    ## physical:
    ##   objectName: hf001-06-daily-m.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-06-daily-m.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM-DD
    ##     .attrs: '1184529775684'
    ##   attribute:
    ##     attributeName: jd
    ##     attributeDefinition: Julian day
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: nominalDay
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: whole
    ##     .attrs: '1247211498476'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: average air temperature. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775704'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for average air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##     .attrs: '1184529775714'
    ##   attribute:
    ##     attributeName: airtmax
    ##     attributeDefinition: maximum air temperature. Maximum of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775734'
    ##   attribute:
    ##     attributeName: f.airtmax
    ##     attributeDefinition: flag for maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775744'
    ##   attribute:
    ##     attributeName: airtmin
    ##     attributeDefinition: minimum air temperature. Minimum of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775754'
    ##   attribute:
    ##     attributeName: f.airtmin
    ##     attributeDefinition: flag for minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775764'
    ##   attribute:
    ##     attributeName: rh
    ##     attributeDefinition: average relative humidity. Average of 1-second measurements.
    ##       (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775774'
    ##   attribute:
    ##     attributeName: f.rh
    ##     attributeDefinition: flag for average relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775784'
    ##   attribute:
    ##     attributeName: rhmax
    ##     attributeDefinition: maximum relative humidity. Maximum of 1-second measurements.
    ##       (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775794'
    ##   attribute:
    ##     attributeName: f.rhmax
    ##     attributeDefinition: flag for maximum relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775804'
    ##   attribute:
    ##     attributeName: rhmin
    ##     attributeDefinition: minimum relative humidity. Minimum of 1-second measurements.
    ##       (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775814'
    ##   attribute:
    ##     attributeName: f.rhmin
    ##     attributeDefinition: flag for minimum relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775824'
    ##   attribute:
    ##     attributeName: dewp
    ##     attributeDefinition: average dew point. Average of 1-second values calculated
    ##       from air temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775834'
    ##   attribute:
    ##     attributeName: f.dewp
    ##     attributeDefinition: flag for average dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775844'
    ##   attribute:
    ##     attributeName: dewpmax
    ##     attributeDefinition: maximum dew point. Maximum of 1-second values calculated
    ##       from air temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775854'
    ##   attribute:
    ##     attributeName: f.dewpmax
    ##     attributeDefinition: flag for maximum dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775864'
    ##   attribute:
    ##     attributeName: dewpmin
    ##     attributeDefinition: minimum dew point. Minimum of 1-second values calculated
    ##       from air temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775874'
    ##   attribute:
    ##     attributeName: f.dewpmin
    ##     attributeDefinition: flag for minimum dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##     .attrs: '1184529775884'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: total precipitation. Includes water equivalent of snow. Total
    ##       value for 1-day period. Measured in increments of 0.01 inch.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: millimeter
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775894'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for total precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##     .attrs: '1184529775904'
    ##   attribute:
    ##     attributeName: slrt
    ##     attributeDefinition: total global solar radiation. Total value for 1-day period.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: megajoulePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775914'
    ##   attribute:
    ##     attributeName: f.slrt
    ##     attributeDefinition: flag for total global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775924'
    ##   attribute:
    ##     attributeName: part
    ##     attributeDefinition: total photosynthetically active radiation. Total value for
    ##       1-day period.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: molePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775934'
    ##   attribute:
    ##     attributeName: f.part
    ##     attributeDefinition: flag for total photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775944'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: average net radiation. Includes short and long wave. Average
    ##       of 1-second measurements. Corrected for wind speeds above 5 m/s using Cambell
    ##       Scientific equation.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775954'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for average net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775964'
    ##   attribute:
    ##     attributeName: bar
    ##     attributeDefinition: average barometric pressure. Corrected for elevation. Average
    ##       of hourly measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: millibar
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775974'
    ##   attribute:
    ##     attributeName: f.bar
    ##     attributeDefinition: flag for barometric pressure
    ##     measurementScale:
    ##       ordinal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529775984'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: average horizontal scalar wind speed. Average of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529775994'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for average horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776004'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: average horizontal resultant vector wind speed. Vector average
    ##       of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529776014'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for average horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776024'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: average horizontal vector wind direction. Vector average
    ##       of 1-second measurements. Measured in degrees clockwise from true north.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529776034'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for average horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776044'
    ##   attribute:
    ##     attributeName: wdev
    ##     attributeDefinition: standard deviation of wind direction. Calculated from 1-second
    ##       measurements using Campbell Scientific equation.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529776054'
    ##   attribute:
    ##     attributeName: f.wdev
    ##     attributeDefinition: flag for standard deviation of wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776064'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: gust speed. Maximum of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529776074'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: '# Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.'
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776084'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: average soil temperature at 10cm depth. Average of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529776094'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for average soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776104'
    ##   attribute:
    ##     attributeName: s10tmax
    ##     attributeDefinition: maximum soil temperature at 10cm depth. Maximum of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529776114'
    ##   attribute:
    ##     attributeName: f.s10tmax
    ##     attributeDefinition: flag for maximum soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776124'
    ##   attribute:
    ##     attributeName: s10tmin
    ##     attributeDefinition: minimum soil temperature at 10cm depth. Minimum of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184529776134'
    ##   attribute:
    ##     attributeName: f.s10tmin
    ##     attributeDefinition: flag for minimum soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184529776144'
    ## numberOfRecords: '5192'
    ## .attrs:
    ## - hf001-06
    ## - document
    ## 
    ## [[7]]
    ## entityName: hf001-07-daily-e.csv
    ## entityDescription: daily (english) since 2001
    ## physical:
    ##   objectName: hf001-07-daily-e.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-07-daily-e.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: date
    ##     attributeDefinition: date
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM-DD
    ##     .attrs: '1184531089252'
    ##   attribute:
    ##     attributeName: jd
    ##     attributeDefinition: Julian day
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: nominalDay
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: whole
    ##     .attrs: '1267214493426'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: average air temperature. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089273'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for average air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##     .attrs: '1184531089283'
    ##   attribute:
    ##     attributeName: airtmax
    ##     attributeDefinition: maximum air temperature. Maximum of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089293'
    ##   attribute:
    ##     attributeName: f.airtmax
    ##     attributeDefinition: flag for maximum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089303'
    ##   attribute:
    ##     attributeName: airtmin
    ##     attributeDefinition: minimum air temperature. Minimum of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089313'
    ##   attribute:
    ##     attributeName: f.airtmin
    ##     attributeDefinition: flag for minimum air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089323'
    ##   attribute:
    ##     attributeName: rh
    ##     attributeDefinition: average relative humidity. Average of 1-second measurements.
    ##       (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089333'
    ##   attribute:
    ##     attributeName: f.rh
    ##     attributeDefinition: flag for average relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089343'
    ##   attribute:
    ##     attributeName: rhmax
    ##     attributeDefinition: maximum relative humidity. Maximum of 1-second measurements.
    ##       (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089353'
    ##   attribute:
    ##     attributeName: f.rhmax
    ##     attributeDefinition: flag for maximum relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089363'
    ##   attribute:
    ##     attributeName: rhmin
    ##     attributeDefinition: minimum relative humidity. Minimum of 1-second measurements.
    ##       (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089373'
    ##   attribute:
    ##     attributeName: f.rhmin
    ##     attributeDefinition: flag for minimum relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089383'
    ##   attribute:
    ##     attributeName: dewp
    ##     attributeDefinition: average dew point. Average of 1-second values calculated
    ##       from air temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089393'
    ##   attribute:
    ##     attributeName: f.dewp
    ##     attributeDefinition: flag for average dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089403'
    ##   attribute:
    ##     attributeName: dewpmax
    ##     attributeDefinition: maximum dew point. Maximum of 1-second values calculated
    ##       from air temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089413'
    ##   attribute:
    ##     attributeName: f.dewpmax
    ##     attributeDefinition: flag for maximum dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089423'
    ##   attribute:
    ##     attributeName: dewpmin
    ##     attributeDefinition: minimum dew point. Minimum of 1-second values calculated
    ##       from air temperature and relative humidity.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089433'
    ##   attribute:
    ##     attributeName: f.dewpmin
    ##     attributeDefinition: flag for minimum dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##     .attrs: '1184531089443'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: Total precipitation. Includes water equivalent of snow. Total
    ##       value for 1-day period. Measured in increments of 0.01 inch.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: inch
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089453'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for total precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##     .attrs: '1184531089463'
    ##   attribute:
    ##     attributeName: slrt
    ##     attributeDefinition: Total global solar radiation. Total value for 1-day period.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: megajoulePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089473'
    ##   attribute:
    ##     attributeName: f.slrt
    ##     attributeDefinition: flag for total global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089483'
    ##   attribute:
    ##     attributeName: part
    ##     attributeDefinition: total photosynthetically active radiation. Total value for
    ##       1-day period.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: molePerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089493'
    ##   attribute:
    ##     attributeName: f.part
    ##     attributeDefinition: flag for total photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089503'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: average net radiation. Includes short and long wave. Average
    ##       of 1-second measurements. Corrected for wind speeds above 5 m/s using Cambell
    ##       Scientific equation.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089513'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for average net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089523'
    ##   attribute:
    ##     attributeName: bar
    ##     attributeDefinition: average barometric pressure. Corrected for elevation. Average
    ##       of hourly measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: inchOfMercury
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089533'
    ##   attribute:
    ##     attributeName: f.bar
    ##     attributeDefinition: flag for barometric pressure
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089543'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: average horizontal scalar wind speed. Average of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089553'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for average horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089563'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: average horizontal resultant vector wind speed. Vector average
    ##       of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089573'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for average horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089583'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: average horizontal vector wind direction. Vector average
    ##       of 1-second measurements. Measured in degrees clockwise from true north.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089593'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for average horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089603'
    ##   attribute:
    ##     attributeName: wdev
    ##     attributeDefinition: standard deviation of wind direction. Calculated from 1-second
    ##       measurements using Campbell Scientific equation.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089613'
    ##   attribute:
    ##     attributeName: f.wdev
    ##     attributeDefinition: flag for standard deviation of wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089623'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: Gust speed. Maximum of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089633'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089643'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: average soil temperature at 10cm depth. Average of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089653'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for average soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089663'
    ##   attribute:
    ##     attributeName: s10tmax
    ##     attributeDefinition: maximum soil temperature at 10cm depth. Maximum of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089673'
    ##   attribute:
    ##     attributeName: f.s10tmax
    ##     attributeDefinition: flag for maximum soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089683'
    ##   attribute:
    ##     attributeName: s10tmin
    ##     attributeDefinition: minimum soil temperature at 10cm depth. Minimum of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184531089693'
    ##   attribute:
    ##     attributeName: f.s10tmin
    ##     attributeDefinition: flag for minimum soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184531089703'
    ## numberOfRecords: '5192'
    ## .attrs:
    ## - hf001-07
    ## - document
    ## 
    ## [[8]]
    ## entityName: hf001-08-hourly-m.csv
    ## entityDescription: hourly (metric) 2001-2004
    ## physical:
    ##   objectName: hf001-08-hourly-m.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-08-hourly-m.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: datetime
    ##     attributeDefinition: date and time at end of sampling period
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM-DDThh:mm
    ##     .attrs: '1184527243653'
    ##   attribute:
    ##     attributeName: jd
    ##     attributeDefinition: Julian day
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: nominalDay
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: whole
    ##     .attrs: '1267213493466'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: air temperature. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243673'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243683'
    ##   attribute:
    ##     attributeName: rh
    ##     attributeDefinition: relative humidity. Average of 1-second measurements. (percent)
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243703'
    ##   attribute:
    ##     attributeName: f.rh
    ##     attributeDefinition: flag for relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243713'
    ##   attribute:
    ##     attributeName: dewp
    ##     attributeDefinition: dew point. Average of 1-second values calculated from air
    ##       temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243723'
    ##   attribute:
    ##     attributeName: f.dewp
    ##     attributeDefinition: flag for dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243733'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: precipitation. Includes water equivalent of snow. Total value
    ##       for 1-hour period. Measured in increments of 0.01 inch.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: millimeter
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243743'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243753'
    ##   attribute:
    ##     attributeName: slrr
    ##     attributeDefinition: global solar radiation. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243763'
    ##   attribute:
    ##     attributeName: f.slrr
    ##     attributeDefinition: flag for global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243773'
    ##   attribute:
    ##     attributeName: parr
    ##     attributeDefinition: photosynthetically active radiation. Average of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: micromolePerMeterSquaredPerSecond
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243783'
    ##   attribute:
    ##     attributeName: f.parr
    ##     attributeDefinition: flag for photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243793'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: net radiation. Includes short and long wave. Average of 1-second
    ##       measurements. Corrected for wind speeds above 5 m/s using Cambell Scientific
    ##       equation.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243803'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243813'
    ##   attribute:
    ##     attributeName: bar
    ##     attributeDefinition: barometric pressure. Corrected for elevation. Sampled once
    ##       per hour.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: millibar
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243823'
    ##   attribute:
    ##     attributeName: f.bar
    ##     attributeDefinition: flag for barometric pressure
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243833'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: horizontal scalar wind speed. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243843'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243853'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: horizontal resultant vector wind speed. Vector average of
    ##       1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243863'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243873'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: horizontal vector wind direction. Vector average of 1-second
    ##       measurements. Measured in degrees clockwise from true north.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243883'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243893'
    ##   attribute:
    ##     attributeName: wdev
    ##     attributeDefinition: standard deviation of wind direction. Calculated from 1-second
    ##       measurements using Campbell Scientific equation.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243903'
    ##   attribute:
    ##     attributeName: f.wdev
    ##     attributeDefinition: flag for standard deviation of wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243913'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: gust speed. Maximum of 1-second measurements. (metersPerSecond)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243923'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243933'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: Soil temperature at 10cm depth. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184527243943'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184527243953'
    ## numberOfRecords: '34080'
    ## .attrs:
    ## - hf001-08
    ## - document
    ## 
    ## [[9]]
    ## entityName: hf001-09-hourly-e.csv
    ## entityDescription: hourly (english) 2001-2004
    ## physical:
    ##   objectName: hf001-09-hourly-e.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-09-hourly-e.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: datetime
    ##     attributeDefinition: date and time at end of sampling period
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM-DDThh:mm
    ##     .attrs: '1184528116238'
    ##   attribute:
    ##     attributeName: jd
    ##     attributeDefinition: Julian day
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: nominalDay
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: whole
    ##     .attrs: '1267611413476'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: Air temperature. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116268'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116278'
    ##   attribute:
    ##     attributeName: rh
    ##     attributeDefinition: relative humidity. Average of 1-second measurements. (percent)
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116288'
    ##   attribute:
    ##     attributeName: f.rh
    ##     attributeDefinition: flag for relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116298'
    ##   attribute:
    ##     attributeName: dewp
    ##     attributeDefinition: dew point. Average of 1-second values calculated from air
    ##       temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116308'
    ##   attribute:
    ##     attributeName: f.dewp
    ##     attributeDefinition: flag for dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116318'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: precipitation. Includes water equivalent of snow. Total value
    ##       for 1-hour period. Measured in increments of 0.01 inch.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: inch
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116328'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116338'
    ##   attribute:
    ##     attributeName: slrr
    ##     attributeDefinition: global solar radiation. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116348'
    ##   attribute:
    ##     attributeName: f.slrr
    ##     attributeDefinition: flag for global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116358'
    ##   attribute:
    ##     attributeName: parr
    ##     attributeDefinition: photosynthetically active radiation. Average of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: micromolePerMeterSquaredPerSecond
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116368'
    ##   attribute:
    ##     attributeName: f.parr
    ##     attributeDefinition: flag for photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116378'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: net radiation. Includes short and long wave. Average of 1-second
    ##       measurements. Corrected for wind speeds above 5 m/s using Cambell Scientific
    ##       equation.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116388'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116398'
    ##   attribute:
    ##     attributeName: bar
    ##     attributeDefinition: barometric pressure. Corrected for elevation. Sampled once
    ##       per hour.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           customUnit: inchOfMercury
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116408'
    ##   attribute:
    ##     attributeName: f.bar
    ##     attributeDefinition: flag for barometric pressure
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116418'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: horizontal scalar wind speed. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116428'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for horizontal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116438'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: horizontal resultant vector wind speed. Vector average of
    ##       1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116448'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116458'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: horizontal vector wind direction. Vector average of 1-second
    ##       measurements. Measured in degrees clockwise from true north.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116468'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116478'
    ##   attribute:
    ##     attributeName: wdev
    ##     attributeDefinition: standard deviation of wind direction. Calculated from 1-second
    ##       measurements using Campbell Scientific equation.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116488'
    ##   attribute:
    ##     attributeName: f.wdev
    ##     attributeDefinition: flag for standard deviation of wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116498'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: gust speed. Maximum of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116508'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116518'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: soil temperature at 10cm depth. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184528116528'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184528116538'
    ## numberOfRecords: '34080'
    ## .attrs:
    ## - hf001-09
    ## - document
    ## 
    ## [[10]]
    ## entityName: hf001-10-15min-m.csv
    ## entityDescription: 15-minute (metric) since 2005
    ## physical:
    ##   objectName: hf001-10-15min-m.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-10-15min-m.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: datetime
    ##     attributeDefinition: date and time at end of sampling period
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM-DDThh:mm
    ##     .attrs: '1184525159897'
    ##   attribute:
    ##     attributeName: jd
    ##     attributeDefinition: Julian day
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: nominalDay
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: whole
    ##     .attrs: '1267311493436'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: air temperature. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525159917'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525159927'
    ##   attribute:
    ##     attributeName: rh
    ##     attributeDefinition: relative humidity. Average of 1-second measurements. (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525159937'
    ##   attribute:
    ##     attributeName: f.rh
    ##     attributeDefinition: flag for relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525159947'
    ##   attribute:
    ##     attributeName: dewp
    ##     attributeDefinition: dew point. Average of 1-second values calculated from air
    ##       temperature and relative humidity.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525159957'
    ##   attribute:
    ##     attributeName: f.dewp
    ##     attributeDefinition: flag for dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525159967'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: precipitation. Includes water equivalent of snow. Total value
    ##       for 15-minute period. Measured in increments of 0.01 inch.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: millimeter
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525159977'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525159987'
    ##   attribute:
    ##     attributeName: slrr
    ##     attributeDefinition: global solar radiation. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525159997'
    ##   attribute:
    ##     attributeName: f.slrr
    ##     attributeDefinition: flag for global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160007'
    ##   attribute:
    ##     attributeName: parr
    ##     attributeDefinition: photosynthetically active radiation. Average of 1-second
    ##       measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           customUnit: micromolePerMeterSquaredPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160017'
    ##   attribute:
    ##     attributeName: f.parr
    ##     attributeDefinition: flag for photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160027'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: net radiation. Includes short and long wave. Average of 1-second
    ##       measurements. Corrected for wind speeds above 5 m/s using Cambell Scientific
    ##       equation.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160037'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160047'
    ##   attribute:
    ##     attributeName: bar
    ##     attributeDefinition: barometric pressure. Corrected for elevation. Average of
    ##       1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: millibar
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160057'
    ##   attribute:
    ##     attributeName: f.bar
    ##     attributeDefinition: flag for barometric pressure
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160067'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: horizontal scalar wind speed. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160077'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160087'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: horizontal resultant vector wind speed. Vector average of
    ##       1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160097'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160107'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: horizontal vector wind direction. Vector average of 1-second
    ##       measurements. Measured in degrees clockwise from true north.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160117'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160127'
    ##   attribute:
    ##     attributeName: wdev
    ##     attributeDefinition: standard deviation of wind direction. Calculated from 1-second
    ##       measurements using Campbell Scientific equation.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160137'
    ##   attribute:
    ##     attributeName: f.wdev
    ##     attributeDefinition: flag for standard deviation of wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160147'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: gust speed. Maximum of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: metersPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160157'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160167'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: soil temperature at 10cm depth. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: celsius
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184525160177'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184525160187'
    ## numberOfRecords: '362112'
    ## .attrs:
    ## - hf001-10
    ## - document
    ## 
    ## [[11]]
    ## entityName: hf001-11-15min-e.csv
    ## entityDescription: 15-minute (english) since 2005
    ## physical:
    ##   objectName: hf001-11-15min-e.csv
    ##   dataFormat:
    ##     textFormat:
    ##       numHeaderLines: '1'
    ##       recordDelimiter: \r\n
    ##       attributeOrientation: column
    ##       simpleDelimited:
    ##         fieldDelimiter: ','
    ##   distribution:
    ##     online:
    ##       url: http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-11-15min-e.csv
    ## attributeList:
    ##   attribute:
    ##     attributeName: datetime
    ##     attributeDefinition: date and time at end of sampling period
    ##     measurementScale:
    ##       dateTime:
    ##         formatString: YYYY-MM-DDThh:mm
    ##     .attrs: '1184526122501'
    ##   attribute:
    ##     attributeName: jd
    ##     attributeDefinition: Julian day
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: nominalDay
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: whole
    ##     .attrs: '1277211403476'
    ##   attribute:
    ##     attributeName: airt
    ##     attributeDefinition: air temperature. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122521'
    ##   attribute:
    ##     attributeName: f.airt
    ##     attributeDefinition: flag for air temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122531'
    ##   attribute:
    ##     attributeName: rh
    ##     attributeDefinition: relative humidity. Average of 1-second measurements. (percent)
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: number
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122541'
    ##   attribute:
    ##     attributeName: f.rh
    ##     attributeDefinition: flag for relative humidity
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122551'
    ##   attribute:
    ##     attributeName: dewp
    ##     attributeDefinition: dew point. Average of 1-second values calculated from air
    ##       temperature and relative humidity
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122561'
    ##   attribute:
    ##     attributeName: f.dewp
    ##     attributeDefinition: flag for dew point
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122571'
    ##   attribute:
    ##     attributeName: prec
    ##     attributeDefinition: precipitation. Includes water equivalent of snow. Total value
    ##       for 15-minute period. Measured in increments of 0.01 inch.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: inch
    ##         precision: '0.01'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122581'
    ##   attribute:
    ##     attributeName: f.prec
    ##     attributeDefinition: flag for precipitation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122591'
    ##   attribute:
    ##     attributeName: slrr
    ##     attributeDefinition: global solar radiation. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122601'
    ##   attribute:
    ##     attributeName: f.slrr
    ##     attributeDefinition: flag for global solar radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122611'
    ##   attribute:
    ##     attributeName: parr
    ##     attributeDefinition: photosynthetically active radation. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: micromolePerMeterSquaredPerSecond
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122621'
    ##   attribute:
    ##     attributeName: f.parr
    ##     attributeDefinition: flag for photosynthetically active radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122631'
    ##   attribute:
    ##     attributeName: netr
    ##     attributeDefinition: net radiation. Includes short and long wave. Average of 1-second
    ##       measurements. Corrected for wind speeds above 5 m/s using Cambell Scientific
    ##       equation.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           customUnit: wattPerMeterSquared
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122641'
    ##   attribute:
    ##     attributeName: f.netr
    ##     attributeDefinition: flag for net radiation
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122651'
    ##   attribute:
    ##     attributeName: bar
    ##     attributeDefinition: barometric pressure. Corrected for elevation. Average of
    ##       1-second measurments.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           customUnit: inchOfMercury
    ##         precision: '0.001'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122661'
    ##   attribute:
    ##     attributeName: f.bar
    ##     attributeDefinition: flag for barometric pressure
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122671'
    ##   attribute:
    ##     attributeName: wspd
    ##     attributeDefinition: horizontal scalar wind speed. Average of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122681'
    ##   attribute:
    ##     attributeName: f.wspd
    ##     attributeDefinition: flag for horizonal scalar wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122691'
    ##   attribute:
    ##     attributeName: wres
    ##     attributeDefinition: horizontal resultant vector wind speed. Vector average of
    ##       1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122701'
    ##   attribute:
    ##     attributeName: f.wres
    ##     attributeDefinition: flag for horizonal resultant vector wind speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122711'
    ##   attribute:
    ##     attributeName: wdir
    ##     attributeDefinition: horizontal vector wind direction. Vector average of 1-second
    ##       measurements. Measured in degrees clockwise from true north.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122721'
    ##   attribute:
    ##     attributeName: f.wdir
    ##     attributeDefinition: flag for horizonal vector wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122731'
    ##   attribute:
    ##     attributeName: wdev
    ##     attributeDefinition: standard deviation of wind direction. Calculated from 1-second
    ##       measurements using Campbell Scientific equation.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: degree
    ##         precision: '1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122741'
    ##   attribute:
    ##     attributeName: f.wdev
    ##     attributeDefinition: flag for standard deviation of wind direction
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122751'
    ##   attribute:
    ##     attributeName: gspd
    ##     attributeDefinition: gust speed. Maximum of 1-second measurements.
    ##     measurementScale:
    ##       ratio:
    ##         unit:
    ##           standardUnit: milesPerHour
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122761'
    ##   attribute:
    ##     attributeName: f.gspd
    ##     attributeDefinition: flag for gust speed
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122771'
    ##   attribute:
    ##     attributeName: s10t
    ##     attributeDefinition: soil temperature at 10cm depth. Average of 1-second measurements.
    ##     measurementScale:
    ##       interval:
    ##         unit:
    ##           standardUnit: fahrenheit
    ##         precision: '0.1'
    ##         numericDomain:
    ##           numberType: real
    ##     .attrs: '1184526122781'
    ##   attribute:
    ##     attributeName: f.s10t
    ##     attributeDefinition: flag for soil temperature
    ##     measurementScale:
    ##       nominal:
    ##         nonNumericDomain:
    ##           enumeratedDomain:
    ##             codeDefinition:
    ##               code: M
    ##               definition: Missing. Instrument not installed, instrument not working
    ##                 correctly, or measured value out of range.
    ##             codeDefinition:
    ##               code: Q
    ##               definition: Questionable. Possible problem with instrument.
    ##             codeDefinition:
    ##               code: E
    ##               definition: Estimated. Value estimated from incomplete measurements
    ##                 or from other sources.
    ##     .attrs: '1184526122791'
    ## numberOfRecords: '362112'
    ## .attrs:
    ## - hf001-11
    ## - document



