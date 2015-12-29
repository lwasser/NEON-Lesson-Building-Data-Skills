## ----install-EML-package, results="hide", warning=FALSE------------------
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

## ----read-eml------------------------------------------------------------
#import EML from Harvard Forest Met Data
eml_HARV <- eml_read("http://harvardforest.fas.harvard.edu/data/eml/hf001.xml")

#view size of object
object.size(eml_HARV)

#view the object class
class(eml_HARV)

## ----view-eml-content----------------------------------------------------
#view the contact name listed in the file
#this works well!
eml_get(eml_HARV,"contact")

#grab all keywords in the file
eml_get(eml_HARV,"keywords")

#figure out the extent & temporal coverage of the data
eml_get(eml_HARV,"coverage")


## ----view-dataset-eml----------------------------------------------------

#view dataset abstract (description)
eml_HARV@dataset@abstract

#the above might be easier to read if we force line breaks!
#we can use strwrap to do this
#write out abstract - forcing line breaks
strwrap(eml_HARV@dataset@abstract, width = 80)

## ----find-geographic-coverage--------------------------------------------
#view geographic coverage
eml_HARV@dataset@coverage@geographicCoverage


## ----map-location, warning=FALSE, message=FALSE--------------------------
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


## ----view-data-tables----------------------------------------------------


#we can view the data table name and description as follows
eml_HARV@dataset@dataTable[[1]]@entityName
eml_HARV@dataset@dataTable[[1]]@entityDescription
#view download path
eml_HARV@dataset@dataTable[[1]]@physical@distribution@online@url

## ----create-datatable-df-------------------------------------------------
#create an object that just contains dataTable level attributes
all.tables <- eml_HARV@dataset@dataTable

#use purrrr to generate a data.frame that contains the attrName and Def for each column
dataTable.desc <- purrr::map_df(all.tables, 
              function(x) data_frame(attribute = x@entityName, 
                        description = x@entityDescription,
                        download.path = x@physical@distribution@online@url))

#view table descriptions
dataTable.desc
#view just the paths (they are too long to render in the output above)
head(dataTable.desc[3])

#how many rows (data tables) are in the data_frame?
nrow(dataTable.desc)


## ----data-table-attr-----------------------------------------------------

#create an object that contains metadata for table 8 only
EML.hr.dataTable <- obj@dataset@dataTable[[8]]

#Check out the table's name - make sure it's the right table!
EML.hr.dataTable@entityName

#what information does this data table contain?
EML.hr.dataTable@entityDescription

#how is the text file delimited?
EML.hr.dataTable@physical

#view table id
EML.hr.dataTable@id

#this is the download URL for the file.
EML.hr.dataTable@physical@distribution@online@url

## ----view-15min-attr-list------------------------------------------------
#get list of measurements for the 10th data table in the EML file
EML.hr.attr <- EML.hr.dataTable@attributeList@attribute
#the first column is the date field
EML.hr.attr[[1]]

#view the column name and description for the first column
EML.hr.attr[[1]]@attributeName
EML.hr.attr[[1]]@attributeDefinition

## ----view-monthly-attrs--------------------------------------------------
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

EML.hr.attr.dt8

#view first 6 rows for each column 
head(EML.hr.attr.dt8$attribute)
head(EML.hr.attr.dt8$description)


## ----download-data-------------------------------------------------------

#view url
EML.hr.dataTable@physical@distribution@online@url

#Read in csv (data table 8)
month.avg.m.HARV <- read.csv(EML.hr.dataTable@physical@distribution@online@url,
                             stringsAsFactors = FALSE)

str(month.avg.m.HARV)

# view table structure
EML.hr.dataTable@physical

## ----EML-Structure-------------------------------------------------------
###THIS IS THE WRONG OUTPUT FOR SOME REASON??
#what are the names of those tables?
data.paths <- eml_get(obj,"csv_filepaths")
data.paths

data.paths[4]

