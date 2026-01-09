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

  function(...) {

    if (all(grepl("\\.\\.\\d{0,3}", as.list(match.call(expand.dots = TRUE)[-1])))) {
      x <- data.table::data.table()
    } else {
      x <- data.table::rowwiseDT(...)
    }

    new_cols <- setdiff(table_cols, colnames(x))

    x[, (new_cols) := character()]
    data.table::setcolorder(x, table_cols)

    return(x)

  }

}

# Function to generate EVENTS tables
create_EVENTS_table <- ConcePTION_generator("EVENTS")

# Function to generate and save EVENTS tables. The tables are temporary and removed at the end of a test
create_and_save_EVENTS_table <- function(...) {
  data.table::fwrite(create_EVENTS_table(...), withr::local_tempfile(.local_envir = parent.frame(), pattern = "EVENTS", fileext = ".csv"))
}

# Create a result file based on an EVENT table
create_EVENTS_results <- function(..., datevar = NULL) {
  x <- create_EVENTS_table(...)
  data.table::setnames(x, "event_code", "codvar")
  if (!is.null(datevar)) {
    if (nrow(x) > 0) {
      x[, (datevar) := lubridate::ymd(.SD), .SDcols = datevar]
    } else {
      x[, (datevar) := as.Date(integer(0))]
    }

  }
  x[, Col := "event_code"][, Table_cdm := "EVENTS"]
  return(x)
}

# Function to generate EVENTS tables
create_MEDICINES_table <- ConcePTION_generator("MEDICINES")

# Function to generate and save EVENTS tables. The tables are temporary and removed at the end of a test
create_and_save_MEDICINES_table <- function(...) {
  data.table::fwrite(create_MEDICINES_table(...), withr::local_tempfile(.local_envir = parent.frame(), pattern = "MEDICINES", fileext = ".csv"))
}

# Create a result file based on an EVENT table
create_MEDICINES_results <- function(...) {
  x <- create_MEDICINES_table(...)
  data.table::setnames(x, "medicinal_product_atc_code", "codvar")
  x[, Col := "medicinal_product_atc_code"][, Table_cdm := "MEDICINES"]
  return(x)
}
