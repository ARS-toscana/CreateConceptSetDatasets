# devtools::load_all()

# function(concept_set_names = "spam",
#          dataset = list(Diagnosis = list("EVENTS")),
#          codvar = list(Diagnosis = list(EVENTS = "event_code")),
#          concept_set_domains = list(spam = "Diagnosis"),
#          concept_set_codes =	list(spam = list(ICD9 = c("001.0", "999.9"))),
#          vocabulary = list(Diagnosis = list(EVENTS = "event_record_vocabulary")),
#          dirinput = tempdir(),
#          diroutput = tempdir(),
#          vocabularies_with_exact_search_not_dot = c("ICD9"))

# TODO modify unction to save concepts with correct rows
# test_that("concepts without codes are retrieved empty", {
#   create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
#                                "a"       ,"ICD9"                  ,"001.0")
#   expect_equal(simple_CCD(concept_set_names = "pippo",
#                               concept_set_codes =	list(spam = list(ICD9 = "001.0"))),
#                create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
# })

test_that("concepts without codes are retrieved empty", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD(concept_set_names = "pippo",
                          concept_set_codes =	list(spam = list(ICD9 = "001.0"))),
               data.table::data.table())
})

##%######################################################%##
#                                                          #
####                EXACT SEARCH NOT DOT                ####
#                                                          #
##%######################################################%##

test_that("simple retrieval (also not first)", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = c("999.9", "001.0"))),
                                        vocabularies_with_exact_search_not_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0"))
})

test_that("parent or child in codelist", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = c("001.00", "001"))),
                                        vocabularies_with_exact_search_not_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("parent or child in dataset", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001",
                               "b"       ,"ICD9"                  ,"001.00")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_exact_search_not_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is not a wildcard", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"00101")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_exact_search_not_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is removed in dataset", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "0010")),
                                        vocabularies_with_exact_search_not_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0"))
})

test_that("dot is removed in codelist", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"0010")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_exact_search_not_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"0010"))
})

##%######################################################%##
#                                                          #
####                      KEEP DOT                      ####
#                                                          #
##%######################################################%##

test_that("simple retrieval", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0",
                               "a"       ,"ICD9"                  ,"001.01")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0",
                                     "a"       ,"ICD9"                  ,"001.01"))
})

test_that("child in codelist", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = c("001.00", "001.01"))),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("parent in dataset", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is not a wildcard", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"00101")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is kept and not discarded in dataset", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "0010")),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is kept and not discarded in codelist", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"0010")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

##%######################################################%##
#                                                          #
####                    DOT WILDCARD                    ####
#                                                          #
##%######################################################%##

test_that("simple retrieval", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0",
                               "a"       ,"ICD9"                  ,"001.01",
                               "a"       ,"ICD9"                  ,"001001",
                               "a"       ,"ICD9"                  ,"001A0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_dot_wildcard = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0",
                                     "a"       ,"ICD9"                  ,"001.01",
                                     "a"       ,"ICD9"                  ,"001001",
                                     "a"       ,"ICD9"                  ,"001A0"))
})

test_that("parent in dataset/child in codelist", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_dot_wildcard = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is kept and not discarded in dataset", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "0010")),
                                        vocabularies_with_dot_wildcard = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is kept and not discarded in codelist", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"0010")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_dot_wildcard = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is not wildcard in dataset", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "00100")),
                                        vocabularies_with_dot_wildcard = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

##%######################################################%##
#                                                          #
####                    EXACT SEARCH                    ####
#                                                          #
##%######################################################%##


test_that("simple retrieval", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_exact_search = c("ICD9"),
                                        vocabularies_with_exact_search_not_dot = NULL),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0"))
})

test_that("parent or child in codelist", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = c("001.00", "001"))),
                                        vocabularies_with_exact_search = c("ICD9"),
                                        vocabularies_with_exact_search_not_dot = NULL),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("parent or child in dataset", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001",
                               "b"       ,"ICD9"                  ,"001.00")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_exact_search = c("ICD9"),
                                        vocabularies_with_exact_search_not_dot = NULL),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is not a wildcard", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"00101")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_exact_search = c("ICD9"),
                                        vocabularies_with_exact_search_not_dot = NULL),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("dot is left as is", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"0010")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_exact_search = c("ICD9"),
                                        vocabularies_with_exact_search_not_dot = NULL),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

##%######################################################%##
#                                                          #
####               MULTIPLE VOCABULARIES                ####
#                                                          #
##%######################################################%##

test_that("two types of vocabularies", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD10"                 ,"A00.0",
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD(concept_set_codes =	list(spam = list(ICD9 = "001.0",
                                                               ICD10 = "A00.0"))),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD10"                 ,"A00.0",
                                     "a"       ,"ICD9"                  ,"001.0"))
})

test_that("two types of vocabularies", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD10"                 ,"A00.0",
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001", ICD10 = "A00")),
                                        vocabularies_with_exact_search_not_dot = c("ICD9"),
                                        vocabularies_with_keep_dot = c("ICD10")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD10"                 ,"A00.0"))
})





test_that("mismatched vocabulary", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD10"                  ,"001.0")
  expect_equal(simple_CCD(concept_set_codes =	list(spam = list(ICD9 = "001.0"))),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("mismatched vocabulary only one retrieval", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                 ,"001.0",
                               "a"       ,"ICD10"                  ,"001.0")
  expect_equal(simple_CCD(concept_set_codes =	list(spam = list(ICD9 = "001.0"))),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0"))
})

test_that("mismatched domains", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD(concept_set_domains = list(spam = "Medicine")),
               data.table::data.table())
})

test_that("search code in wrong existing column", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  x <- create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=)
  data.table::setnames(x, c("event_free_text", "codvar"), c("codvar", "event_code"))
  x[, event_code := as.numeric(event_code)]
  expect_equal(simple_CCD(codvar = list(Diagnosis = list(EVENTS = "event_free_text"))),
               x)
})

# TODO fail gracefully "search in wrong not existing column"
# TODO fail gracefully "no dataset for specified domain"
# TODO fail gracefully in case input folder is incorrect

# TODO change behaviour to add a warning/message if no vocabulary has been found in the entire file
test_that("search coding system in wrong existing column", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD(vocabulary = list(Diagnosis = list(EVENTS = "event_free_text"))),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

# TODO fail gracefully if wrong domain or dataset is setup in rename_col
test_that("rename_col really rename columns", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  result <- create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                  "a"       ,"ICD9"                  ,"001.0")
  data.table::setnames(result, c("person_id", "end_date_record"), c("who", "when"))
  expect_equal(simple_CCD(rename_col = list(who = list(Diagnosis = list(EVENTS = "person_id")),
                                            when = list(Diagnosis = list(EVENTS = "end_date_record")))),
               result)
})

test_that("Specifyng datevar works", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                               "a"       ,"ICD9"                  ,"001.0"    ,"20250101")
  result <- create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                                  "a"       ,"ICD9"                  ,"001.0"    ,"20250101", datevar = c("end_date_record"))
  expect_equal(simple_CCD(datevar = list(Diagnosis = list(EVENTS = "end_date_record")),
                          dateformat= "YYYYmmdd"),
               result)
})

test_that("filter_expression works when condition TRUE", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                               "a"       ,"ICD9"                  ,"001.0"    ,"20250101")
  result <- create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                                  "a"       ,"ICD9"                  ,"001.0"    ,"20250101", datevar = c("end_date_record"))
  expect_equal(simple_CCD(datevar = list(Diagnosis = list(EVENTS = "end_date_record")),
                          dateformat= "YYYYmmdd",
                          filter_expression = "polars::pl$col('person_id') == 'a' & polars::pl$col('end_date_record') > polars::pl$date(2020, 01, 01)"),
               result)
})

test_that("filter_expression works when condition FALSE", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                               "a"       ,"ICD9"                  ,"001.0"    ,"20250101")
  expect_equal(simple_CCD(datevar = list(Diagnosis = list(EVENTS = "end_date_record")),
                          dateformat= "YYYYmmdd",
                          filter_expression = "polars::pl$col('person_id') == 'b' & polars::pl$col('end_date_record') > polars::pl$date(2020, 01, 01)"),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,end_date_record=, datevar = c("end_date_record")))
})

test_that("filter_expression works when condition FALSE even for non-equi join", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                               "a"       ,"ICD9"                  ,"001.0"    ,"20250101")
  expect_equal(simple_CCD(datevar = list(Diagnosis = list(EVENTS = "end_date_record")),
                          dateformat= "YYYYmmdd",
                          filter_expression = "polars::pl$col('person_id') == 'a' & polars::pl$col('end_date_record') > polars::pl$date(2025, 06, 01)"),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,end_date_record=, datevar = c("end_date_record")))
})

# TODO test if filter_expression is done before the code extraction or not
test_that("filter_expression works even on renamed columns", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                               "a"       ,"ICD9"                  ,"001.0"    ,"20250101")
  result <- create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,end_date_record=,
                                  "a"       ,"ICD9"                  ,"001.0"    ,"20250101", datevar = c("end_date_record"))
  data.table::setnames(result, c("person_id", "end_date_record"), c("who", "when"))
  expect_equal(simple_CCD(rename_col = list(who = list(Diagnosis = list(EVENTS = "person_id")),
                                            when = list(Diagnosis = list(EVENTS = "end_date_record"))),
                          datevar = list(Diagnosis = list(EVENTS = "end_date_record")),
                          dateformat= "YYYYmmdd",
                          filter_expression = "polars::pl$col('who') == 'a' & polars::pl$col('when') > polars::pl$date(2020, 01, 01)"),
               result)
})

test_that("simple not retrieval", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0",
                               "a"       ,"ICD9"                  ,"001.01")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        concept_set_codes_excl =	list(spam = list(ICD9 = "001.01")),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0"))
})

# TODO add more exhaustive tests for all vocabularies types just like concept_set_codes

test_that("exclude same code as normal inclusion", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0",
                               "a"       ,"ICD9"                  ,"001.01")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = "001.0")),
                                        concept_set_codes_excl =	list(spam = list(ICD9 = "001.0")),
                                        vocabularies_with_keep_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=))
})

test_that("simple retrieval (also not first)", {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "b"       ,"ICD9"                  ,"999.9")
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0")
  expect_equal(simple_CCD(concept_set_codes =	list(spam = list(ICD9 = c("999.9", "001.0"))))[, Table_cdm := NULL][order(person_id), ],
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0",
                                     "b"       ,"ICD9"                  ,"999.9")[, Table_cdm := NULL][order(person_id), ])
})

# TODO add type of vocaulary missing case

# TODO rework dateformat using maybe anytime and another package for dates management
# TODO add tests for additional dates formats?
# TODO write codes for implementing option verbose. It should hides all messages. Useful for testing (if implemented remove current work around)

# TODO add test with Medicines
# TODO add TEST with mix Diagnoses and Medicines
# TODO add EAVtables support in testing

##%######################################################%##
#                                                          #
####                MISSING VOCABULARY                  ####
#                                                          #
##%######################################################%##

test_that('event_record_vocabulary as "" are excluded', {
  create_and_save_EVENTS_table(person_id=,event_record_vocabulary=,event_code=,
                               "a"       ,"ICD9"                  ,"001.0",
                               "a"       ,""                      ,"999.9")
  expect_equal(simple_CCD_no_vocab_type(concept_set_codes =	list(spam = list(ICD9 = c("001.0", "999.9"))),
                                        vocabularies_with_exact_search_not_dot = c("ICD9")),
               create_EVENTS_results(person_id=,event_record_vocabulary=,event_code=,
                                     "a"       ,"ICD9"                  ,"001.0"))
})
