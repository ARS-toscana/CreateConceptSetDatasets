# CreateConceptSetDatasets

## Context
A *concept set* is a set of medical concepts (eg the concept set "Diabetes" may contain the two concepts "type 2 diabetes" and "type 1 diabetes"). Each concept can be projected to codes in multiple coding systems (for instance, "ICD10", or "ATC"). Each concept set is associated to a data domain in the medical field (eg "diagnosis" or "medication") ([Avillach et al, JAMIA 2013](https://pubmed.ncbi.nlm.nih.gov/22955495/)). 
CreateConceptSetDatasets is useful when records corresponding to a collection of concept sets must be retrieved from (at least) one data source containing multiple tables, each associated to several data domains, and each containing at least a column of medical codes. This is a circumstance that occurs regularly in the context of multi-database studies. Retrieving records corresponding to concept sets is the first steps in the process of creating study variables based on the data sources (Gini et al, eGEMS 2016), and is facilitated when the data sources are converted into a same common data model ([Gini et al, CPT 2020](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7484985/)).

## Purpose

The function CreateConceptSetDatasets inspects a set of input tables af data and creates a group of datasets, each corresponding to a concept set. Each dataset contains the records of the input tables that match the corresponding concept set and is named out of it. The data model of the input tables, the concept sets, their domains and the associated codes are listed as input in the format of multi-level lists.

## Structure of input data

Input is a set of data tables that contain healthcare data, each pertaining to one or more data domains. Each dataset must have at least one column containing codes in a coding system, such as ICD9 or ATC.

- **dataset** a 2-level list containing, for each domain, the names of the corresponding tables of data
- **codvar** a 2 level list containing, for each table of data, the name of the column containing the codes of interest
- **datevar** (optional): a 2-level list containing, for each input table of data, the name(s) of the column(s) containing dates (only if extension=”csv”), to be saved as dates in the output
- **numericvar** (optional): a 2-level list containing, for each input table of data, the name(s) of the column(s) containing numbers (only if extension=”csv”), to be saved as a number in the output
-	**EAVtables** (optional): a 2-level list specifying, for each domain, tables in a Entity-Attribute-Value structure; each table is listed with the name of two columns: the one contaning attributes and the one containing values
-	**EAVattributes** (optional): a 3-level list specifying, for each domain and table in a Entity-Attribute-Value structure, the attributes whose values should be browsed to retrieve codes belonging to that domain; each attribute is listed along with its coding system  
-	**dateformat** (optional): a string containing the format of the dates in the input tables of data (only if -datevar- is indicated); the string must be in one of the following:
- [x] YYMMDD
- [x] yymmdd
- [x] YYMMDD
- [x] DDMMYY
- [x] YYYYMMDD

-	**rename_col** (optional) this is a list of 3-level lists; each 3-level list contains acolumn name for each input table of data (associated to a data domain) to be renamed in the output (for instance: the personal identifier, or the date); in the output all the columns will be renamed with the name of the list.
-	**concept_set_domains* a 2-level list containing, for each concept set, the corresponding domain 
-	**concept_set_codes** a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as inclusion criteria for records: records must be included if the their code(s) starts with at least one string in this list; the match is executed ignoring points 
-	**concept_set_codes_excl** (optional) a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as exclusion criteria for records: records must be excluded if the their code(s) starts with at least one string in this list; the match is executed ignoring points
-	**concept_set_names** (optional) a vector containing the names of the concept sets to be processed; if this is missing, all the concept sets included in the previous lists are processed
- **vocabulary** (optional) a 3-level list containing, for each table of data and data domain, the name of the column containing the vocabulary of the column(s) -codvar-
-	**addtabcol** a logical parameter, by default set to TRUE: if so, the columns "Table_cdm" and "Col" are added to the output, indicating respectively from which original table and column the code is taken.
-	**verbose** a logical parameter, by default set to FALSE. If it is TRUE additional intermediate output datasets will be shown in the R environment
-	**discard_from_environment** (optional) a logical parameter, by default set to FALSE. If it is TRUE, the output datasets are removed from the global environment
-	**dirinput** (optional) the directory where the input tables of data are stored. If not provided the working directory is considered.
-	**diroutput** (optional) the directory where the output concept sets datasets will be saved. If not provided the working directory is considered.
-	**extension** the extension of the input tables of data (csv and dta are supported)

##	Structure of output

One dataset per concept set. The dataset of a concept set is the union of the selections of the input data tables which match the codes in the concept set. The data model of the output is the union of the data models of the input, except for the name of the columns listed in the option codvar and (optionally) in the option rename_col.

