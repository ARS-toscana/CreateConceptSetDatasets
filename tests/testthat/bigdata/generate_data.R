# Function factory which create functions generating table of the ConcePTION CDM
ConcePTION_generator <- function(CDM_table) {

  ConcePTION_cols <- list()

  ConcePTION_cols[["VISIT_OCCURRENCE"]] <- c("person_id", "visit_occurrence_id", "visit_start_date", "visit_end_date",
                                             "specialty_of_visit", "specialty_of_visit_vocabulary", "status_at_discharge",
                                             "status_at_discharge_vocabulary", "meaning_of_visit", "origin_of_visit")

  ConcePTION_cols[["EVENTS"]] <- c("person_id", "start_date_record", "end_date_record", "event_code",
                                   "event_record_vocabulary", "text_linked_to_event_code", "event_free_text",
                                   "present_on_admission", "laterality_of_event", "meaning_of_event", "origin_of_event",
                                   "visit_occurrence_id")

  ConcePTION_cols[["MEDICINES"]] <- c("person_id", "medicinal_product_id", "medicinal_product_atc_code",
                                      "date_dispensing", "date_prescription", "disp_number_medicinal_product",
                                      "presc_quantity_per_day", "presc_quantity_unit", "presc_duration_days",
                                      "product_lot_number", "indication_code", "indication_code_vocabulary",
                                      "meaning_of_drug_record", "origin_of_drug_record", "prescriber_speciality",
                                      "prescriber_speciality_vocabulary", "visit_occurrence_id")

  ConcePTION_cols[["PROCEDURES"]] <- c("person_id", "procedure_date", "procedure_code", "procedure_code_vocabulary",
                                       "meaning_of_procedure", "origin_of_procedure", "visit_occurrence_id")

  ConcePTION_cols[["VACCINES"]] <- c("person_id", "vx_record_date", "vx_admin_date", "vx_atc", "vx_type", "vx_text",
                                     "medicinal_product_id", "vx_dose", "vx_manufacturer", "vx_lot_num",
                                     "meaning_of_vx_record", "origin_of_vx_record", "visit_occurrence_id")

  ConcePTION_cols[["MEDICAL_OBSERVATIONS"]] <- c("person_id", "mo_date", "mo_code", "mo_record_vocabulary",
                                                 "mo_source_table", "mo_source_column", "mo_source_value", "mo_unit",
                                                 "mo_meaning", "mo_origin", "visit_occurrence_id")

  ConcePTION_cols[["SURVEY_ID"]] <- c("person_id", "survey_id", "survey_date", "survey_meaning", "survey_origin")

  ConcePTION_cols[["SURVEY_OBSERVATIONS"]] <- c("person_id", "so_date", "so_source_table", "so_source_column",
                                                "so_source_value", "so_unit", "so_meaning", "so_origin", "survey_id")

  ConcePTION_cols[["PERSONS"]] <- c("person_id", "day_of_birth", "month_of_birth", "year_of_birth", "day_of_death",
                                    "month_of_death", "year_of_death", "sex_at_instance_creation", "race",
                                    "country_of_birth", "quality")

  ConcePTION_cols[["OBSERVATION_PERIODS"]] <- c("person_id", "op_start_date", "op_end_date", "op_meaning", "op_origin")

  ConcePTION_cols[["PERSON_RELATIONSHIPS"]] <- c("person_id", "related_id", "meaning_of_relationship",
                                                 "origin_of_relationship", "method_of_linkage")

  ConcePTION_cols[["PRODUCTS"]] <- c("medicinal_product_id", "medicinal_product_name", "unit_of_presentation_type",
                                     "unit_of_presentation_num", "administration_dose_form", "administration_route",
                                     "medicinal_product_atc_code", "subst1_atc_code", "subst2_atc_code",
                                     "subst3_atc_code", "subst1_amount_per_form", "subst2_amount_per_form",
                                     "subst3_amount_per_form", "subst1_amount_unit", "subst2_amount_unit",
                                     "subst3_amount_unit", "subst1_concentration", "subst2_concentration",
                                     "subst3_concentration", "subst1_concentration_unit", "subst2_concentration_unit",
                                     "subst3_concentration_unit", "concentration_total_content",
                                     "concentration_total_content_unit", "medicinal_product_manufacturer")

  table_cols <- ConcePTION_cols[[CDM_table]]
  rm(ConcePTION_cols)

  function(x) {

    new_cols <- setdiff(table_cols, colnames(x))

    x[, (new_cols) := character()]
    data.table::setcolorder(x, table_cols)

    return(x)

  }

}

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
codelist_without_TP <- event_codelist[!grepl("^TP_", concept_id) & coding_system == "ICD10"]
assigned_cardinality <- assign_cardinality_to_concepts(codelist_without_TP, total_number_records, number_datasets)

cleaned_codelist <- unique(codelist_without_TP[, .(code, coding_system, concept_id)])

# Function to generate EVENTS tables
create_EVENTS_table <- ConcePTION_generator("EVENTS")

for (i in 1:10) {
  temp_df <- data.table::copy(cleaned_codelist)[, .SD[sample(.N, assigned_cardinality[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"]
  temp_df[, person_id := sample(paste0("person_", 1:(total_number_records / number_datasets)), nrow(temp_df), replace = TRUE)]
  temp_df[, concept_id := NULL]
  data.table::setnames(temp_df, c("code", "coding_system"), c("event_code", "event_record_vocabulary"))
  temp_df[, start_date_record := sample(seq(lubridate::ymd(20200101), lubridate::ymd(20260101)), nrow(temp_df), replace = TRUE)]
  temp_df[, start_date_record := as.character(format(start_date_record, format = "%Y%m%d"))]
  temp_df[, meaning_of_event := sample(c("pc", "hospital_primary", "hospital_secondary", "hospital_overnight", "specialist"), nrow(temp_df), replace = TRUE)]

  create_EVENTS_table(temp_df)
}

# dir.create(file.path(folder, "i_input"), showWarnings = FALSE)
#
# fwrite(copy(final_df)[, .SD[sample(.N, assigned_prob[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"],
#        paste0(folder, "i_input", CDM_name, "_", i, ".csv"))

codelist_TP <- event_codelist[grepl("^TP_", concept_id), ]
assigned_cardinality <- assign_cardinality_to_concepts(codelist_TP, total_number_records, number_datasets)

cleaned_codelist <- unique(codelist_TP[coding_system == "ICD10",
                                       .(code, event_record_vocabulary = coding_system, concept_id)])

# Function to generate EVENTS tables
create_PROCEDURES_table <- ConcePTION_generator("PROCEDURES")

dfs_list <- lapply(1:10, function(x) {
  temp_df <- data.table::copy(cleaned_codelist)[, .SD[sample(.N, assigned_cardinality[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"]
  temp_df[, person_id := sample(paste0("person_", 1:(total_number_records / number_datasets)), nrow(temp_df), replace = TRUE)]
  temp_df[, concept_id := NULL]
  data.table::setnames(temp_df, c("code", "coding_system"), c("procedure_code", "procedure_code_vocabulary"))
  temp_df[, procedure_date := sample(seq(lubridate::ymd(20200101), lubridate::ymd(20260101)), nrow(temp_df), replace = TRUE)]
  temp_df[, procedure_date := as.character(format(procedure_date, format = "%Y%m%d"))]
  temp_df[, meaning_of_procedure := sample(c("pc", "hospital_primary", "hospital_secondary", "hospital_overnight", "specialist"), nrow(temp_df), replace = TRUE)]


  create_PROCEDURES_table(temp_df)
})

# dir.create(file.path(folder, "i_input"), showWarnings = FALSE)
#
# fwrite(copy(final_df)[, .SD[sample(.N, assigned_prob[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"],
#        paste0(folder, "i_input", CDM_name, "_", i, ".csv"))

codelist_medicines <- xlsx::read.xlsx(file.path(testthat::test_path(), "bigdata", "CVM_codelist_medicines.xlsx"),
                                      sheetName = "DrugProxies")
codelist_medicines <- unique(data.table::data.table(codelist_medicines)[, .(concept_id = Drug_proxie, code = ATC.codes)])
assigned_cardinality <- assign_cardinality_to_concepts(codelist_medicines, total_number_records, number_datasets)

cleaned_codelist <- codelist_medicines[, c(code = strsplit(code, ",")), by = concept_id]

# Function to generate EVENTS tables
create_MEDICINES_table <- ConcePTION_generator("MEDICINES")

dfs_list <- lapply(1:10, function(x) {
  temp_df <- data.table::copy(cleaned_codelist)[, .SD[sample(.N, assigned_cardinality[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"]
  temp_df[, person_id := sample(paste0("person_", 1:(total_number_records / number_datasets)), nrow(temp_df), replace = TRUE)]
  temp_df[, concept_id := NULL]
  data.table::setnames(temp_df, c("code"), c("medicinal_product_atc_code"))
  temp_df[, date_dispensing := sample(seq(lubridate::ymd(20200101), lubridate::ymd(20260101)), nrow(temp_df), replace = TRUE)]
  temp_df[, date_dispensing := as.character(format(date_dispensing, format = "%Y%m%d"))]
  temp_df[, meaning_of_drug_record := sample(c("pc", "hospital_primary", "hospital_secondary", "hospital_overnight", "specialist"), nrow(temp_df), replace = TRUE)]


  create_MEDICINES_table(temp_df)
})


# dir.create(file.path(folder, "i_input"), showWarnings = FALSE)
#
# fwrite(copy(final_df)[, .SD[sample(.N, assigned_prob[[unlist(.BY)]], replace = TRUE)], keyby = "concept_id"],
#        paste0(folder, "i_input", CDM_name, "_", i, ".csv"))
