###################################################################
# ASSIGN PARAMETERS DESCRIBING THE DATA MODEL OF THE INPUT FILES
###################################################################

# assign -Example_CDM_tables-: it is a 2-level list describing the Example CDM tables, and will enter the function as the first parameter. the first level is the data domain (in the example: 'Diagnosis' and 'Medicines') and the second level is the list of tables that has a column pertaining to that data domain

Example_CDM_tables <- vector(mode="list")

files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^EVENTS"))  Example_CDM_tables[["Diagnosis"]][[(length(Example_CDM_tables[["Diagnosis"]]) + 1)]]<-files[i]
  else{if (str_detect(files[i],"^MEDICINES")) Example_CDM_tables[["Medicines"]][[(length(Example_CDM_tables[["Medicines"]]) + 1)]]<-files[i] }
}

#define tables for createconceptset
Example_CDM_EAV_tables <- vector(mode="list")
EAV_table<-c()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^SURVEY_OB")) { Example_CDM_EAV_tables[["Diagnosis"]][[(length(Example_CDM_EAV_tables[["Diagnosis"]]) + 1)]]<-list(list(files[i], "so_source_table", "so_source_column"))
  EAV_table<-append(EAV_table,files[i])
  }
  else{if (str_detect(files[i],"^MEDICAL_OB")){ Example_CDM_EAV_tables[["Diagnosis"]][[(length(Example_CDM_EAV_tables[["Diagnosis"]]) + 1)]]<-list(list(files[i], "mo_source_table", "mo_source_column"))
  EAV_table<-append(EAV_table,files[i])}
  }
}

# assign -Example_CDM_codvar- and -Example_CDM_coding_system_cols-: they are also 2-level lists, they encode from the data model the name of the column(s) of each table that contain, respectively the code and the coding system, corresponding to a data domain the table belongs to

alldomain<-unique(names(Example_CDM_tables))

Example_CDM_codvar <- vector(mode="list")
Example_CDM_coding_system_cols <-vector(mode="list")

for (dom in alldomain) {
  for (i in 1:(length(Example_CDM_EAV_tables[["Diagnosis"]]))){
    for (ds in append(Example_CDM_tables[[dom]],Example_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]])) {
      if (ds==Example_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]]) {
        if (str_detect(ds,"^SURVEY_OB"))  Example_CDM_codvar[["Diagnosis"]][[ds]]="so_source_value"
        if (str_detect(ds,"^MEDICAL_OB"))  Example_CDM_codvar[["Diagnosis"]][[ds]]="mo_source_value"
      }else{
        if (dom=="Medicines") Example_CDM_codvar[[dom]][[ds]]="product_ATCcode"
        if (dom=="Diagnosis") Example_CDM_codvar[[dom]][[ds]]="event_code"
      }
    }
  }
}

for (dom in alldomain) {
  for (ds in Example_CDM_tables[[dom]]) {
    if (dom=="Diagnosis") Example_CDM_coding_system_cols[[dom]][[ds]] = "event_record_vocabulary"
  }
}


# assign 2 more 2-level lists: -id- -date-. They encode from the data model the name of the column(s) of each data table that contain, respectively, the personal identifier and the date. Those 2 lists are to be inputted in the rename_col option of the function.
#NB: GENERAL  contains the names columns will have in the final datasets

person_id <- vector(mode="list")
date <- vector(mode="list")

for (dom in alldomain) {
  for (i in 1:(length(Example_CDM_EAV_tables[[dom]]))){
    for (ds in append(Example_CDM_tables[[dom]],Example_CDM_EAV_tables[[dom]][[i]][[1]][[1]])) {
      person_id [[dom]][[ds]] = "person_id"
    }
  }
}


for (dom in alldomain) {
  for (i in 1:(length(Example_CDM_EAV_tables[["Diagnosis"]]))){
    for (ds in append(Example_CDM_tables[[dom]],Example_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]])) {
      if (ds==Example_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]]) {
        if (str_detect(ds,"^SURVEY_OB")) date[["Diagnosis"]][[ds]]="so_date"
        if (str_detect(ds,"^MEDICAL_OB")) date[["Diagnosis"]][[ds]]="mo_date"
      }else{
        if (dom=="Medicines") date[[dom]][[ds]]="date_dispensing"
        if (dom=="Diagnosis") date[[dom]][[ds]]="start_date_record"
      }
    }
  }
}

Example_CDM_datevar<-vector(mode="list")

for (dom in alldomain) {
  for (i in 1:(length(Example_CDM_EAV_tables[["Diagnosis"]]))){
    for (ds in append(Example_CDM_tables[[dom]],Example_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]])) {
      if (ds==Example_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]]) {
        if (str_detect(ds,"^SURVEY_OB")) Example_CDM_datevar[["Diagnosis"]][[ds]]="so_date"
        if (str_detect(ds,"^MEDICAL_OB"))  Example_CDM_datevar[["Diagnosis"]][[ds]]="mo_date"
      }else{
        if (dom=="Medicines") Example_CDM_datevar[[dom]][[ds]]= list("date_dispensing","date_prescription")
        if (dom=="Diagnosis") Example_CDM_datevar[[dom]][[ds]]=list("start_date_record","end_date_record")
      }
    }
  }
}


Example_CDM_EAV_attributes<-vector(mode="list")

  for (dom in alldomain) {
    for (i in 1:(length(Example_CDM_EAV_tables[[dom]]))){
      for (ds in Example_CDM_EAV_tables[[dom]][[i]][[1]][[1]]) {
          if (dom=="Diagnosis") Example_CDM_EAV_attributes[[dom]][[ds]][["ICD9"]] <-  list(list("RMR","CAUSAMORTE"))
          Example_CDM_EAV_attributes[[dom]][[ds]][["ICD10"]] <-  list(list("RMR","CAUSAMORTE_ICDX"))
          Example_CDM_EAV_attributes[[dom]][[ds]][["SNOMED"]] <-  list(list("AP","COD_MORF_1"),list("AP","COD_MORF_2"),list("AP","COD_MORF_3"),list("AP","COD_TOPOG"))
        }
      }
    }



