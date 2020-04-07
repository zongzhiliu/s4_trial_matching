export disease=UC
export working_schema="ct_UC"
export disease_icd="^(K51|556[.][2-6])"
export last_visit_within=99 #years
export protocal_date=$(date +%Y-%m-%d)

export dmsdw=dmsdw_2019q1
export ref_drug_mapping=ct.drug_mapping_cat_expn6
export ref_lab_mapping=ct.ref_lab_loinc_mapping
export ref_proc_mapping=ct.ref_proc_mapping_20200325
export ref_rx_mapping=ct.ref_rx_mapping_20200325
<<<<<<< HEAD:scripts/uc/config.sh

export working_dir="$HOME/Sema4/rdmsdw/${disease}"
export script_dir="$HOME/git/trial_matching/scripts"

# AOF value config
export PLATELETS_MIN=100
export WBC_MIN=3
export IRN_MAX=99
=======
>>>>>>> 6f6e4b23d63baa5ac94d790dbcfcddfb0d70d53b:scripts/ct_UC/config.sh
