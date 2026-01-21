event_codelist <- data.table::fread(file.path(testthat::test_path(), "bigdata", "CVM_codelist_events.csv"))
event_codelist[, concept_id := paste(system, event_abbreviation, type, sep = "_")]

concept_id_event_list <- unique(event_codelist$concept_id)
concept_id_event_list_no_proc <- concept_id_event_list[!grepl("^TP_", concept_id_event_list)]

total_number_records <- 4000
number_datasets <- 10

assign_cardinality_to_concepts <- function(codelist, number_records, number_datasets) {

  concepts_names <- unique(codelist$concept_id)

  random_chi <- rchisq(length(concepts_names), 1)
  assigned_prob <- round(random_chi / sum(random_chi) * number_records / number_datasets, 0)
  names(assigned_prob) <- concepts_names

  return(assigned_prob)

}

set.seed(123)
codelist_without_TP <- data.table::copy(event_codelist)[!grepl("^TP_", concept_id)]
assigned_cardinality <- assign_cardinality_to_concepts(codelist_without_TP, total_number_records, number_datasets)

cleaned_codelist <- unique(codelist_without_TP[coding_system == "ICD10",
                                               .(code, event_record_vocabulary = coding_system, concept_id)])

dfs_list <- lapply(1:10, function(x) {
  data.table::copy(cleaned_codelist)[, .SD[sample(.N, assigned_cardinality[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"]
})

dir.create(file.path(folder, "i_input"), showWarnings = FALSE)

fwrite(copy(final_df)[, .SD[sample(.N, assigned_prob[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"],
       paste0(folder, "i_input", CDM_name, "_", i, ".csv"))

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

medicines_codelist <- xlsx::read.xlsx(file.path(testthat::test_path(), "bigdata", "CVM_codelist_medicines.xlsx"),
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
