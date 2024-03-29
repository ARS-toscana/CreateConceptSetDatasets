% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CreateConceptSetDatasets.R
\name{CreateConceptSetDatasets}
\alias{CreateConceptSetDatasets}
\title{CreateConceptSetDatasets}
\usage{
CreateConceptSetDatasets(
  dataset,
  codvar,
  datevar,
  EAVtables,
  EAVattributes,
  dateformat,
  rename_col,
  filter_expression,
  concept_set_domains,
  concept_set_codes,
  concept_set_codes_excl,
  concept_set_names,
  vocabulary,
  addtabcol = T,
  verbose = F,
  discard_from_environment = F,
  dirinput = getwd(),
  diroutput = getwd(),
  extension = F,
  vocabularies_with_dot_wildcard,
  vocabularies_with_keep_dot,
  vocabularies_with_exact_search,
  use_qs = F
)
}
\arguments{
\item{dataset}{a 2-level list containing, for each domain, the names of the corresponding input tables of data}

\item{codvar}{a 3-level list containing, for each input table of data and each domain, the name(s) of the column(s) containing the codes of interest}

\item{datevar}{(optional): a 2-level list containing, for each input table of data, the name(s) of the column(s) containing dates (only if extension=”csv”), to be saved as dates in the output}

\item{EAVtables}{(optional): a 2-level list specifying, for each domain, tables in a Entity-Attribute-Value structure; each table is listed with the name of two columns: the one contaning attributes and the one containing values}

\item{EAVattributes}{(optional): a 3-level list specifying, for each domain and table in a Entity-Attribute-Value structure, the attributes whose values should be browsed to retrieve codes belonging to that domain; each attribute is listed along with its coding system}

\item{dateformat}{(optional): a string containing the format of the dates in the input tables of data (only if -datevar- is indicated); the string must be in one of the following:}

\item{rename_col}{(optional) this is a list of 3-level lists; each 3-level list contains a column name for each input table of data (associated to a data domain) to be renamed in the output (for instance: the personal identifier, or the date); in the output all the columns will be renamed with the name of the list.}

\item{filter_expression}{(optional) this is a 2-level lists: this is a logical condition in the columns that are specified in -rename_col-. This conditions is to be used to filter the input datasets before starting to filter the concept sets}

\item{concept_set_domains}{a 2-level list containing, for each concept set, the corresponding domain}

\item{concept_set_codes}{a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as inclusion criteria for records: records must be included if the their code(s) starts with at least one string in this list; the match is executed ignoring points}

\item{concept_set_codes_excl}{(optional) a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as exclusion criteria for records: records must be excluded if the their code(s) starts with at least one string in this list; the match is executed ignoring points}

\item{concept_set_names}{(optional) a vector containing the names of the concept sets to be processed; if this is missing, all the concept sets included in the previous lists are processed}

\item{vocabulary}{(optional) a 3-level list containing, for each table of data and data domain, the name of the column containing the vocabulary of the column(s) -codvar-}

\item{addtabcol}{a logical parameter, by default set to TRUE: if so, the columns "Table_cdm" and "Col" are added to the output, indicating respectively from which original table and column the code is taken.}

\item{verbose}{a logical parameter, by default set to FALSE. If it is TRUE additional intermediate output datasets will be shown in the R environment}

\item{discard_from_environment}{(optional) a logical parameter, by default set to FALSE. If it is TRUE, the output datasets are removed from the global environment}

\item{dirinput}{(optional) the directory where the input tables of data are stored. If not provided the working directory is considered.}

\item{diroutput}{(optional) the directory where the output concept sets datasets will be saved. If not provided the working directory is considered.}

\item{extension}{(optional) the extension of the input tables of data (csv and dta are supported)}

\item{vocabularies_with_dot_wildcard}{a list containing the vocabularies in which treat the character dot in codes as wildcard}

\item{vocabularies_with_keep_dot}{a list containing the vocabularies in which treat the character dot in codes as itself}

\item{vocabularies_with_exact_search}{a list containing the vocabularies in which the codes must match exactly}

\item{use_qs}{use package qs to compress final datasets and decrease computation time}
}
\description{
The function CreateConceptSetDatasets inspects a set of input tables af data and creates a group of datasets, each corresponding to a concept set. Each dataset contains the records of the input tables that match the corresponding concept set and is named out of it.
}
\details{
A concept set is a set of medical concepts (eg the concept set "DIABETES" may contain the concepts "type 2 diabetes" and "type 1 diabetes") that may be recorded in the tables of data in some coding systems (for instance, "ICD10", or "ATC"). Each concept set is associated to a data domain (eg "diagnosis" or "medication") which is the topic of one or more tables of data. When calling CreateConceptSetDatasets, the concept sets, their domains and the associated codes are listed as input in the format of multi-level lists.
}
\seealso{
We open the table, add a column named "general" initially set to 0. For each concept set linked to the domain, we create a column named "Filter_conceptset" that takes the value 1 for each row that match the concept set codes. After checking for each concept set, the column general is updated and only the rows for which general=1 are kept. The dataset is saved locally as "FILTERED_table" (you will have these datasets in the global environment only if verbose=T).
We split each of the new FILTERED_table relying on the column "Filter_conceptset" and we create one dataset for each concept set and each dataset. (you will have these datasets in output only if verbose=T).
Finally we put together all the datasets related to the same concept set and we save it in the -dirtemp- given as input with the extenstion .R .


#'CHECK VOCABULARY
}
