# the workflow to create and populate ct_${cancer} schema
# requires:
# ct.py_contains, .ref_drug_mapping .ref_lab_mapping
# ct.ref_proc_mapping, ct.ref_rx_mapping

####
# need run config file here
# source ct_CD/config.sh
# source ct_UC/config.sh

<<<<<<< HEAD:scripts/cd/import_ibd.sh
source util/util.sh
pgsetup rdmsdw
=======
export script_dir="$HOME/git/trial_matching/scripts"
source util/util.sh
pgsetup ${db_conn}
>>>>>>> 6f6e4b23d63baa5ac94d790dbcfcddfb0d70d53b:scripts/ct_CD/import_ibd.sh
psql -c "create schema if not exists ${working_schema}"

# prepare reference tables as defined in config, then
psql_w_envs disease/prepare_reference.sql

# prepare attribute tables as csv (crit_attribute, trial_attribute)
ipython ct_CD/load_trial_attribute.ipy
ipython disease/load_crit_attribute.ipy
psql_w_envs cancer/prepare_attribute.sql

# prepare patient data
psql_w_envs disease/prepare_cohort.sql
psql_w_envs disease/prepare_demo_plus.sql
psql_w_envs disease/prepare_diagnosis.sql
psql_w_envs disease/prepare_vital.sql
#psql_w_envs disease/prepare_sochx.sql
psql_w_envs disease/prepare_procedure.sql
psql_w_envs disease/prepare_medication.sql
psql_w_envs disease/prepare_lab.sql
#psql_w_envs caregiver/icd_physician.sql

# perform the attribute matching
psql_w_envs disease/match_rxnorm.sql #> _p_a_t_rxnorm
psql_w_envs disease/match_loinc.sql #> _p_a_t_loinc
psql_w_envs cancer/match_aof20200327.sql #> _p_a_t_aof
psql_w_envs disease/match_diagnosis.sql #> _p_a_t_diagnosis
psql_w_envs disease/match_procedure.sql #> _p_a_t_procedure
psql_w_envs ct_CD/prepare_misc_measurement.sql
psql_w_envs cancer/match_misc_measurement.sql #> _p_a_t_misc_measurement

# compile the matches
psql_w_envs ct_CD/master_match.sql  #> master_match
psql_w_envs disease/master_sheet.sql  #> master_sheet
psql_w_envs disease/master_sheet_mapping.sql

# match to patients
psql_w_envs disease/master_patient.sql #> trial2patients

<<<<<<< HEAD:scripts/cd/import_ibd.sh

### delivery
cd "${working_dir}"
select_from_db_schema_table.py rdmsdw ${working_schema}.v_demo_w_zip > \
    ${disease}.v_demo_w_zip.csv
load_into_db_schema_some_csvs.py -d pharma db_data_bridge \
    ${disease}.v_demo_w_zip.csv

select_from_db_schema_table.py rdmsdw ${working_schema}.v_crit_attribute_used_new > \
    ${disease}.v_crit_attribute_used_new_$(today_stamp).csv
ln -sf ${disease}.v_crit_attribute_used_new_$(today_stamp).csv \
    ${disease}.v_crit_attribute_used_new.csv
load_into_db_schema_some_csvs.py pharma db_data_bridge \
    ${disease}.v_crit_attribute_used_new.csv

select_from_db_schema_table.py rdmsdw ${working_schema}.v_master_sheet_n > \
    ${disease}.v_master_sheet_n.csv
load_into_db_schema_some_csvs.py -d pharma db_data_bridge \
    ${disease}.v_master_sheet_n.csv
=======
# download and deliver
source cancer/download_master_sheet.sh
source cancer/deliver_master_sheet.sh
export logic_cols='logic_l1, logic_l2'
>>>>>>> 6f6e4b23d63baa5ac94d790dbcfcddfb0d70d53b:scripts/ct_CD/import_ibd.sh
mysql_w_envs disease/expand_master_sheet.sql
