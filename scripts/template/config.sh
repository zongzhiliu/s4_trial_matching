# Set up disease attribute, it may varies for different disease.
export disease=UC
export disease_icd="^(K51|556[.][2-6])"
export working_schema="ct_${disease}"
export last_visit_within=99 #years
export protocal_date=$(date +%Y-%m-%d)

# Set up working database and assign variable to reference table. 
# These settings remains the same unless change on reference table.
export dmsdw=dmsdw_2019q1
export ref_drug_mapping=ct.drug_mapping_cat_expn6
export ref_lab_mapping=ct.ref_lab_loinc_mapping
export ref_proc_mapping=ct.ref_proc_mapping_20200325
export ref_rx_mapping=ct.ref_rx_mapping_20200325

# Set up script environment
export working_dir="$HOME/Sema4/rdmsdw/${disease}"
export script_dir="$HOME/git/trial_matching/scripts"

# Adequate Organ Function(AOF) value config
# It varies for differet trials
export PLATELETS_MIN=100
export WBC_MIN=3
export IRN_MAX=99