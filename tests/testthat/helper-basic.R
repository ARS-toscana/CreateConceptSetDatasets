# TODO find source
# Usual match.call, however now picks up default argument too
match.call.defaults <- function(...) {
  call <- evalq(match.call(expand.dots = TRUE), parent.frame(1))
  formals <- evalq(formals(), parent.frame(1))

  for(i in setdiff(names(formals), names(call)))
    call[i] <- list( formals[[i]] )


  match.call(sys.function(sys.parent()), call)
}

# TODO add parquet
# Read an RData without attaching it directly in the main environment
load_result <- function(filename, dirout) {
  if ("RData" %in% sub(".*\\.", "", list.files(dirout))) {
    get(load(file.path(dirout, paste0(filename, ".RData")))[[1]])[, lapply(.SD, as.character)]
  } else if ("parquet" %in% sub(".*\\.", "", list.files(dirout))) {
    data.table::data.table(as.data.frame(pl$read_parquet(file.path(dirout, paste0(filename, ".parquet")))))
  }

}

# Simplified CreateConceptSetDatasets to set default argument useful for testing and define a temporary folder to store results different from the location of the inputs
simple_CCD <- function(concept_set_names = "spam",
                       dataset = list(Diagnosis = list("EVENTS")),
                       codvar = list(Diagnosis = list(EVENTS = "event_code")),
                       concept_set_domains = list(spam = "Diagnosis"),
                       concept_set_codes =	list(spam = list(ICD9 = c("001.0", "999.9"))),
                       vocabulary = list(Diagnosis = list(EVENTS = "event_record_vocabulary")),
                       dirinput = tempdir(),
                       diroutput = tempdir(),
                       vocabularies_with_exact_search_not_dot = c("ICD9"),
                       verbose = T,
                       ...) {
  if (length(concept_set_names) != 1) stop("Define a new function!")

  .args <- as.list(match.call.defaults()[-1])
  .args <- .args[names(.args) != "..."]

  dataset_list <- eval(.args$dataset)
  for (domains in names(dataset_list)) {
    all_input_files <- list.files(dirinput)
    all_input_files <- sub('\\..*$', '', basename(all_input_files))
    dataset_list[[domains]] <- as.list(all_input_files[grepl(dataset_list[[domains]], all_input_files)])
  }

  if (max(sapply(dataset_list, length)) > 1) {
    .args$dataset <- dataset_list

    codvar_list <- eval(.args$codvar)
    new_codvar_list <- list()
    for (domain in names(codvar_list)) {
      for (real_df in dataset_list[[domain]]) {
        new_codvar_list[[domain]][[real_df]] <- codvar_list[[domain]][[1]]
      }
    }
    .args$codvar <- new_codvar_list

    vocabulary_list <- eval(.args$vocabulary)
    new_vocabulary_list <- list()
    for (domain in names(vocabulary_list)) {
      for (real_df in dataset_list[[domain]]) {
        new_vocabulary_list[[domain]][[real_df]] <- vocabulary_list[[domain]][[1]]
      }
    }
    .args$vocabulary <- new_vocabulary_list
  }

  if (missing(diroutput)) .args$diroutput <- withr::local_tempdir(.local_envir = parent.frame())
  capture.output(do.call(CreateConceptSetDatasets, .args), file = nullfile())

  if (length(concept_set_names) == 1) {
    return(load_result(concept_set_names, .args$diroutput))
  } else {
    return(lapply(concept_set_names, load_result, .args$diroutput))
  }
}

# Simplified CreateConceptSetDatasets to set default argument useful for testing and define a temporary folder to store results different from the location of the inputs
simple_CCD_no_vocab_type <- function(concept_set_names = "spam",
                                     dataset = list(Diagnosis = list("EVENTS")),
                                     codvar = list(Diagnosis = list(EVENTS = "event_code")),
                                     concept_set_domains = list(spam = "Diagnosis"),
                                     concept_set_codes =	list(spam = list(ICD9 = c("001.0", "999.9"))),
                                     vocabulary = list(Diagnosis = list(EVENTS = "event_record_vocabulary")),
                                     dirinput = tempdir(),
                                     diroutput = tempdir(),
                                     vocabularies_with_exact_search_not_dot = c("ICD9"),
                                     verbose = T,
                                     ...) {

  if (length(concept_set_names) != 1) stop("Define a new function!")
  .args <- as.list(match.call.defaults()[-1])
  .args <- .args[names(.args) != "..."]

  if (missing(diroutput)) .args$diroutput <- withr::local_tempdir(.local_envir = parent.frame())

  capture.output(do.call(CreateConceptSetDatasets, .args), file = nullfile())

  return(load_result(concept_set_names, .args$diroutput))
}

