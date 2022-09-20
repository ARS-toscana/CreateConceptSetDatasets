rm(list=ls(all.names=TRUE))

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))


#load parameters
source(paste0(thisdir,"/p_parameters/parameters_program.R"))
source(paste0(thisdir,"/p_parameters/parameters_CDM.R"))
source(paste0(thisdir,"/p_parameters/concept_sets.R"))

CreateConceptSetDatasets(concept_set_names = concept_sets_of_our_study,
                         dataset = Example_CDM_tables,
                         codvar = Example_CDM_codvar,
                         datevar= Example_CDM_datevar,
                         dateformat= "YYYYmmdd",
                         rename_col = list(person_id=person_id,date=date,main_meaning=meaning),
                         #filter_expression = "main_meaning=='dispensing_in_hospital_pharmacy_for_home_use' & date>dmy('01012016')",
                         concept_set_domains = concept_set_domains,
                         concept_set_codes =	concept_set_codes_our_study,
                         concept_set_codes_excl = concept_set_codes_our_study_excl,
                         vocabulary = Example_CDM_coding_system_cols,
                         discard_from_environment = F,
                         dirinput = dirinput,
                         diroutput = diroutput,
                         vocabularies_with_dot_wildcard = c("READ"),
                         vocabularies_with_exact_search = "free_text",
                         use_qs = F,
                         add_conceptset_name=T)
                         #aggregate_concepts  #true/false o solo per concetti specifici??
