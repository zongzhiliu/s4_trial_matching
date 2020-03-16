/***
 * master match: need modifying for each cancer type!!
Requires: trial_attribute_used
    _p_a_t_...
Results:
    master_match
*/

drop table if exists _master_match cascade;
create table _master_match as (
    select attribute_id, trial_id, person_id, match from _p_a_t_icd_rex
    union select attribute_id, trial_id, person_id, match from _p_a_t_icdo_rex
    union select attribute_id, trial_id, person_id, match from _p_a_t_rxnorm -- a view
    union select attribute_id, trial_id, person_id, match from _p_a_t_misc_measurement
    union select attribute_id, trial_id, person_id, match from _p_a_t_cat_measurement
    union select attribute_id, trial_id, person_id, match from _p_a_t_aof -- a view
    union select attribute_id, trial_id, person_id, match from _p_a_t_stage
    union select attribute_id, trial_id, person_id, match from _p_a_t_variant
    union select attribute_id, trial_id, person_id, match from _p_a_t_biomarker
)
;
/*
select attribute_id, attribute_name, code_type, count(distinct person_id)
from _master_match
join crit_attribute_used using (attribute_id)
group by attribute_id, attribute_name, code_type
order by attribute_id limit 99;
-- loinc, misc_meas, aof have less patients

-- make sure each trial, patient, attribute there is only one match
select count(*), count(distinct attribute_id||trial_id||person_id) from _master_match;

select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_icd_rex;
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_icdo_rex;
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_rxnorm;
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_misc_measurement;
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_cat_measurement; -- quickfix
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_aof;
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_stage; --quickfix
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_variant;
select count(*), count(distinct attribute_id||trial_id||person_id) from _p_a_t_biomarker; --quickfix
*/

-- set match as null by default for each patient
create view master_match as
select attribute_id, trial_id, person_id, match
from (trial_attribute_used
    cross join cohort)
left join _master_match using (attribute_id, trial_id, person_id)
;


