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
obj <- eml_read("http://harvardforest.fas.harvard.edu/data/eml/hf001.xml")

#view size of object
object.size(obj)

#get list of measurements for the 4th data table in the EML file
stuff <- obj@dataset@dataTable[[4]]@attributeList@attribute
#the first column is the date field
stuff[[1]]

slotNames(stuff[1])

#view the column name and description for the first column
stuff[[1]]@attributeName
stuff[[1]]@attributeDefinition

## ----view-eml-content----------------------------------------------------
#view the contact name listed in the file
#this works well!
eml_get(obj,"contact")

#grab all keywords in the file
eml_get(obj,"keywords")

#figure out the extent & temporal coverage of the data
eml_get(obj,"coverage")



## ----EML-Structure-------------------------------------------------------

#How many data tables are described / included in this dataset?
length(obj@dataset@dataTable)

#what are the names of those tables?
data.paths <- eml_get(obj,"csv_filepaths")

data.paths

data.paths[4]

## ----view-data-tables----------------------------------------------------

#we can view the data table name and description as follows
obj@dataset@dataTable[[1]]@entityName
obj@dataset@dataTable[[1]]@entityDescription

#create an object that just contains dataTable level attributes
all.tables <- obj@dataset@dataTable

#use purrrr to generate a data.frame that contains the attrName and Def for each column
dataTable.desc <- purrr::map_df(all.tables, 
              function(x) 
                data.frame(attribute = x@entityName, 
                                     description = x@entityDescription))
#view table descriptions
dataTable.desc


## ----data-table-attr-----------------------------------------------------

#create an object that contains metadata for table 4 only
month.avg.desc <- obj@dataset@dataTable[[4]]

#Check out the table's name - make sure it's the right table!
month.avg.desc@entityName

#what information does this data table contain?
month.avg.desc@entityDescription

#how is the text file delimited?
month.avg.desc@physical

#view table id
month.avg.desc@id

#this is the download URL for the file.
month.avg.desc@physical@distribution@online@url

## ----view-monthly-attrs--------------------------------------------------

#view attributes for the 4th data table - monthly average
month.avg.desc@attributeList

#create an object that only contains attribute values for the month av data
month.avg.desc.attr <- month.avg.desc@attributeList

# use a split-apply-combine approach to parse the attribute data
# and create a data.frame with only the attribute name and description

#dplyr approach
do.call(rbind, 
        lapply(stuff, function(x) data.frame(column.name = x@attributeName, 
                                             definition = x@attributeDefinition)))

#use purrrr to generate a data.frame that contains the attrName and Def for each column
tbl4.clms <- purrr::map_df(stuff, 
              function(x) 
                data.frame(attribute = x@attributeName, 
                                     description = x@attributeDefinition))

head(tbl4.clms)

## ----download-data-------------------------------------------------------

#tried to subset out the dataTable component of the eml obj
dat <- eml_get(obj@dataset@dataTable[[4]], "data.frame")

#in theory the code below should work but it throws a URL error
library(RCurl)
x <- getURL(data.paths[4])
y <- read.csv(text = x)

#the url below does work, why can't R access it but my browser can?
url <- month.avg.desc@physical@distribution@online@url
getURL(url)

y
#x <- getURL("http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv")

#the url below works.
#http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv


## ----view-attr-list------------------------------------------------------
#what are the attributes in the data?
obj@dataset@dataTable[[4]]@attributeList

#view one set of attributes - the first in the list
obj@dataset@dataTable[[4]]@attributeList@attribute[[1]]

#for date fields i'd like to know the format and the timezone
obj@dataset@dataTable[[4]]@attributeList@attribute[[1]]@measurementScale
obj@dataset@dataTable[[4]]@attributeList@attribute[[1]]@attributeName


#view second attribute in the list - airt
obj@dataset@dataTable[[4]]@attributeList@attribute[[2]]

#I am at the units with the string below
#phew - long. what i really want is to be able to grab the unit programmatically
obj@dataset@dataTable[[4]]@attributeList@attribute[[2]]@measurementScale


## ----view-units----------------------------------------------------------


## ----view-XML-YAML, results="hide"---------------------------------------
#view all elements in YAML format
#note - i've hidden the output as it's too long
obj

## ----download-data2------------------------------------------------------
#download in all data that the eml references
#store it in a data.frame format
#dat <- eml_get(obj, "data.frame")


## ----get-id--------------------------------------------------------------
#not sure what this ID is
eml_get(obj,"id")

#not sure what this is doing either.
eml = eml_read("knb-lter-hfr.205.4")

eml@dataset@dataTable[[1]]@attributeList@attribute[[2]]

obj@dataset@dataTable


