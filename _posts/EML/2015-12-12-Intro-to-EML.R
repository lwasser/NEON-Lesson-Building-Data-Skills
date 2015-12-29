## ----install-EML-package-------------------------------------------------
#install R EML tools
#library("devtools")
#install_github("ropensci/EML", build=FALSE, dependencies=c("DEPENDS", "IMPORTS"))

#call package
library("EML")


## ----read-eml------------------------------------------------------------
#import EML from Harvard Forest Met Data
obj <- eml_read("http://harvardforest.fas.harvard.edu/data/eml/hf001.xml")

#view size of object
object.size(obj)

## ----EML-Structure-------------------------------------------------------

#How many data tables are described / included in this dataset?
length(obj@dataset@dataTable)

#what are the names of those tables?
eml_get(obj,"csv_filepaths")



## ----view-monthly-attrs--------------------------------------------------
#view metadata for the 4th data table which should be monthly average metric
obj@dataset@dataTable[[4]]

#is this the right data table? yes
obj@dataset@dataTable[[4]]@entityName

#what information does this data table contain?
obj@dataset@dataTable[[4]]@entityDescription

obj@dataset@dataTable[[4]]@physical

#view table id
obj@dataset@dataTable[[4]]@id


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


## ----view-XML-YAML-------------------------------------------------------
#view all elements in YAML format
obj

## ----eml-get-------------------------------------------------------------
#Get Attributes
#what is this returning?
eml_get(obj, "attributeList")


## ----download-data-------------------------------------------------------
#download in all data that the eml references
#store it in a data.frame format
#dat <- eml_get(obj, "data.frame")


## ----view-eml-content----------------------------------------------------
#view the contact name listed in the file
#this works well!
eml_get(obj,"contact")

#grab all keywords in the file
eml_get(obj,"keywords")

#figure out the extent & temporal coverage of the data
eml_get(obj,"coverage")

#view list of files that you can download as described in the EML object 
eml_get(obj,"csv_filepaths")

## ----get-id--------------------------------------------------------------
#not sure what this ID is
eml_get(obj,"id")

#not sure what this is doing either.
eml = eml_read("knb-lter-hfr.205.4")

eml@dataset@dataTable[[1]]@attributeList@attribute[[2]]

obj@dataset@dataTable


