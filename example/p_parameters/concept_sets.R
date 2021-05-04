###################################################################
# DESCRIBE THE CONCEPT SETS
###################################################################

concept_sets_of_our_study <- c("INSULIN","DIABETES","OTHER_AED")

# -concept_set_domains- is a 2-level list encoding for each concept set the corresponding data domain

concept_set_domains <- vector(mode="list")

concept_set_domains[["INSULIN"]]="Medicines"
concept_set_domains[["DIABETES"]]="Diagnosis"
concept_set_domains[["OTHER_AED"]]="Medicines"


# -concept_set_codes_our_study- is a nested list, with 3 levels: foreach concept set, for each coding system of its data domain, the list of codes is recorded

concept_set_codes_our_study <- vector(mode="list")


concept_set_codes_our_study[["DIABETES"]][["ICD9"]]=c("2*0")
concept_set_codes_our_study[["DIABETES"]][["ICD10"]]=c("E10","E11")
concept_set_codes_our_study[["INSULIN"]][["ATC"]]= c("A10A")
concept_set_codes_our_study[["OTHER_AED"]][["ATC"]]=c("A10B")



concept_set_codes_our_study_excl<- vector(mode="list")
concept_set_codes_our_study_excl[["DIABETES"]][["ICD9"]]=c("25011")
