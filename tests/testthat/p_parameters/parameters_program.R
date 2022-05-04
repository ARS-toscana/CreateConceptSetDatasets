diroutput <- "g_output"
dirinput <- "i_input"
extension <- c(".csv")

###################################################################
# CREATE FOLDERS
###################################################################

suppressWarnings(if (!file.exists(diroutput)){
  setwd(file.path(diroutput))
})

