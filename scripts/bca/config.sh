export cancer_type=BCA
export cancer_type_icd="^(C50|17[45])"
export working_schema="ct_${cancer_type}"
export last_visit_within=99 #years
export ref_drug_mapping=ct.drug_mapping_cat_expn4_20200313
export ref_lab_mapping=ct.ref_lab_loinc_mapping

export working_dir="$HOME/Sema4/rimsdw/${cancer_type}"
export script_dir="$HOME/git/trial_matching/scripts"
