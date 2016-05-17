### create merge
# notes-- requires mactex. download or install via
# brew cask -- brew cask install mactex

## load packages
library(knitr)
library(rmarkdown)
library(readr)

# set working dir
setwd("~/Documents/GitHub/NEON-Lesson-Building-Data-Skills/_posts/processing-code/MailMerge")
## load data
#apps-original <- read.csv("~/Documents/1_Summer-institute/Summer_Institute_Application_Form_2016__FINAL.csv", 
#                 na.strings=c(-99, 0, ""),
#                 stringsAsFactors = FALSE)

apps <- read.csv("~/Documents/1_Summer-institute/inst-2016-apps-flags.csv", 
                 na.strings=c(-99, 0, "", "NA"),
                 stringsAsFactors = FALSE)

# apps <- apps[with(apps, order(Q5)), ]

# add flags column to original data
# apps$flag <- NA
# apps$accept <- NA
# write_csv(apps,"~/Documents/1_Summer-institute/inst-2016-apps-flags.csv",na="NA")

# filter out Q17 (goals) == NA
inCompleteApps <- apps[is.na(apps$Q17),]

apps <- apps[!is.na(apps$Q17),]

## create loop
for (i in 2:nrow(apps)){
# for (i in 3:5){  
  # get contact info and background
  firstName <- apps$Q4[i]
  lastName <- apps$Q5[i]
  rmarkdown::render(input="app-review.Rmd",
              output_format="pdf_document",
              output_file = paste0(lastName,"-",firstName,"_", i,".pdf"),
              output_dir = "~/Documents/1_Summer-institute/r-mailmerge-aps")

}