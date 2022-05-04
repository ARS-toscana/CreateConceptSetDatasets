
#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))


#load parameters
source(paste0(thisdir,"/p_parameters/parameters_program.R"))
source(paste0(thisdir,"/p_parameters/parameters_CDM.R"))
source(paste0(thisdir,"/p_parameters/concept_sets.R"))

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName" & ls() != "concept"])
}

CreateConceptSetDatasets(concept_set_names = concept_sets_of_our_study,
                         dataset = Example_CDM_tables,
                         codvar = Example_CDM_codvar,
                         datevar= Example_CDM_datevar,
                         dateformat= "YYYYmmdd",
                         rename_col = list(person_id=person_id,date=date),
                         concept_set_domains = concept_set_domains,
                         concept_set_codes =	concept_set_codes_our_study,
                         concept_set_codes_excl = concept_set_codes_our_study_excl,
                         vocabulary = Example_CDM_coding_system_cols,
                         discard_from_environment = T,
                         dirinput = dirinput,
                         diroutput = diroutput,
                         vocabularies_with_dot_wildcard = c("READ"),
                         vocabularies_with_exact_search = "free_text",
                         use_qs = F)

files <- list.files(file.path(thisdir,"g_output"), full.names = T)
files <- files[grep("\\.RData$", files)]
for (single_file in files) {
  load(single_file)
}

files <- list.files(file.path(thisdir,"g_output - Expected"), full.names = T)
files <- files[grep("\\.RData$", files)]
for (single_file in files) {
  assign(paste0("expected_",
                sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(single_file))), loadRData(single_file))
}

