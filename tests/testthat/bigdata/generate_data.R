event_codelist <- data.table::fread(file.path("CVM_codelist_events.csv"))
event_codelist[, concept_id := paste(system, event_abbreviation, type, sep = "_")]

concept_id_event_list <- unique(event_codelist$concept_id)
concept_id_event_list_no_proc <- concept_id_event_list[!grepl("^TP_", concept_id_event_list)]

total_number_records <- 4000
number_datasets <- 10

set.seed(123)
random_chi <- rchisq(length(concept_id_event_list_no_proc), 1)
assigned_prob <- round(random_chi / sum(random_chi) * total_number_records / number_datasets, 0)
names(assigned_prob) <- concept_id_event_list_no_proc

cleaned_event_codelist <- event_codelist[concept_id %in% concept_id_event_list_no_proc & coding_system == "ICD10", ]
events <- unique(cleaned_event_codelist[, .(code, event_record_vocabulary = coding_system, concept_id)])

for (i in 1:10) {

  fwrite(copy(events)[, .SD[sample(.N, assigned_prob[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"],
         paste0("EVENTS_", i, ".csv"))

}

concept_id_event_list_proc <- concept_id_event_list[grepl("^TP_", concept_id_event_list)]

set.seed(123)
random_chi <- rchisq(length(concept_id_event_list_proc), 1)
assigned_prob <- round(random_chi / sum(random_chi) * total_number_records / number_datasets, 0)
names(assigned_prob) <- concept_id_event_list_proc

cleaned_event_codelist <- event_codelist[concept_id %in% concept_id_event_list_proc & coding_system == "ICD10", ]
events <- unique(cleaned_event_codelist[, .(code, event_record_vocabulary = coding_system, concept_id)])

for (i in 1:10) {

  fwrite(copy(events)[, .SD[sample(.N, assigned_prob[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"],
         paste0("PROCEDURES_", i, ".csv"))

}

medicines_codelist <- xlsx::read.xlsx(file.path(thisdir, "p_parameters" ,"CVM_codelist_medicines.xlsx"),
                                      sheetName = "DrugProxies")
medicines_codelist <- unique(data.table::data.table(medicines_codelist)[, .(concept_id = Drug_proxie, code = ATC.codes)])
medicines_codelist <- medicines_codelist[, c(code = strsplit(code, ",")), by = "concept_id"]

concept_id_medicines_list <- unique(medicines_codelist$concept_id)

set.seed(123)
random_chi <- rchisq(length(concept_id_medicines_list), 1)
assigned_prob <- round(random_chi / sum(random_chi) * total_number_records / number_datasets, 0)
names(assigned_prob) <- concept_id_medicines_list

cleaned_medicines_codelist <- medicines_codelist[concept_id %in% concept_id_medicines_list, ]
medicines <- unique(cleaned_medicines_codelist[, .(code, concept_id)])

for (i in 1:10) {

  fwrite(copy(medicines)[, .SD[sample(.N, assigned_prob[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"],
         paste0("EVENTS_", i, ".csv"))

}
