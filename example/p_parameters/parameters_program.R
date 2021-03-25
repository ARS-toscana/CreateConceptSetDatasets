#packages
if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("stringr")) install.packages("stringr")
library(stringr)


diroutput <- paste0(thisdir,"/g_output/")
dirinput <- paste0(thisdir,"/i_input/")
extension <- c(".csv")

setwd("..")
dirbase<-getwd()
source(paste0(dirbase,"/R/","CreateConceptSetDatasets.R"))

###################################################################
# CREATE FOLDERS
###################################################################

suppressWarnings(if (file.exists(diroutput)){
  setwd(file.path(diroutput))
} else {
  dir.create(file.path( diroutput))
  setwd(file.path(diroutput))
})

