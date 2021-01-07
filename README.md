# CreateConceptSetDatasets

## Context
A *concept set* is a set of medical concepts (eg the concept set "Diabetes" may contain the two concepts "type 2 diabetes" and "type 1 diabetes"). Each concept can be projected to codes in multiple coding systems (for instance, "ICD10", or "ATC"). Each concept set is associated to a data domain in the medical field (eg "diagnosis" or "medication") ([Avillach et al, JAMIA 2013](https://pubmed.ncbi.nlm.nih.gov/22955495/)). 
CreateConceptSetDatasets is useful when records corresponding to a collection of concept sets must be retrieved from (at least) one data source containing multiple tables, each associated to several data domains, and each containing at least a column of medical codes. This is a circumstance that occurs regularly in the context of multi-database studies. Retrieving records corresponding to concept sets is the first steps in the process of creating study variables based on the data sources (Gini et al, eGEMS 2016), and is facilitated when the data sources are converted into a same common data model ([Gini et al, CPT 2020](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7484985/)).

## Purpose

The function CreateConceptSetDatasets inspects a set of input tables af data and creates a group of datasets, each corresponding to a concept set. Each dataset contains the records of the input tables that match the corresponding concept set and is named out of it. The data model of the input tables, the concept sets, their domains and the associated codes are listed as input in the format of multi-level lists.

