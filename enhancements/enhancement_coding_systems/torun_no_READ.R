rm(list=ls())

#set the directory where the script is saved as the working directory

if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#set directories for input and output

dirmyoutput <- paste0(thisdir,"/.")
dirmyinput <- paste0(thisdir,"/.")

source("CreateConceptSetDatasets_v10.R")

ConcePTION_CDM_tables <- vector(mode="list")
ConcePTION_CDM_tables[["Diagnosis"]] <- c("EVENTS_SDO")

ConcePTION_CDM_codvar <- vector(mode="list")
ConcePTION_CDM_codvar[["Diagnosis"]][["EVENTS_SDO"]]="event_code"

ConcePTION_CDM_coding_system_cols<- vector(mode="list")
ConcePTION_CDM_coding_system_cols[["Diagnosis"]][["EVENTS_SDO"]] = "event_record_vocabulary"

concept_sets_of_our_study <- c("A","B")

concept_set_domains<- vector(mode="list")
concept_set_domains[["A"]] = "Diagnosis"
concept_set_domains[["B"]] = "Diagnosis"

concept_set_codes_our_study<- vector(mode="list")
concept_set_codes_our_study[["A"]][["ICD9"]] <- c("242")
concept_set_codes_our_study[["A"]][["READ"]] <- c("F27sb","F27.b.")

concept_set_codes_our_study[["B"]][["ICD9"]] <- c("1534")
#concept_set_codes_our_study[["B"]][["READ"]] <- c("F24..")
concept_set_codes_our_study[["B"]][["READ"]] <- c("F2.4")

CreateConceptSetDatasets(dataset = ConcePTION_CDM_tables,
                         codvar = ConcePTION_CDM_codvar,
                         vocabulary = ConcePTION_CDM_coding_system_cols,
                         # datevar = ConcePTION_CDM_datevar,
                         # rename_col = list(person_id,date),
                         concept_set_domains = concept_set_domains,
                         concept_set_codes = concept_set_codes_our_study,
                         concept_set_names = concept_sets_of_our_study,
                         dirinput = dirmyinput,
                         diroutput = dirmyoutput,
                         extension = c("csv"),
                         vocabularies_with_dot_wildcard=c("READ")
)

