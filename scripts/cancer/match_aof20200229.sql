CREATE temporary TABLE _lab_w_normal_range AS
SELECT person_id, lab_test_name, loinc_code, m.unit
, normal_low, normal_high
, result_date, value_float
from latest_lab
join ct.lab_loinc_mapping m using (loinc_code)
;

drop table if exists _p_aof cascade;
create table _p_aof as
with como as (
    select person_id
    , bool_or(icd_code ~ '^(C787[.]7|197[.]7)') as livermet
    , bool_or(icd_code ~ '^(E80[.]4|277[.]4)') as gs
    from latest_icd
    group by person_id
), lab as (
    select person_id
    , bool_or(lab_test_name in ('ALT', 'AST') and value_float/normal_high <=2.5) as alst_low
    , bool_or(lab_test_name in ('ALT', 'AST') and value_float/normal_high <=5) as alst_mid
    , bool_or(lab_test_name='Total bilirubin' and value_float/normal_high <=1.5) as bili_low
    , bool_or(lab_test_name='Total bilirubin' and value_float/normal_high <=3) as bili_mid
    , bool_or(lab_test_name='Serum Creatinine' and value_float/normal_high <=1.5) as crea_ok
    --where lab_test_name='WBC' and not nvl(value_float>=2, true)
    , bool_or(lab_test_name='ANC' and value_float>=1) as anc_ok  --unit different
    , bool_or(lab_test_name='Platelets' and value_float>=50) as plat_ok--unit different
    , bool_or(lab_test_name='Hemoglobin' and value_float>=8) as hemo_ok
    from _lab_w_normal_range
    group by person_id
)
select person_id
, (alst_low or alst_mid and livermet)
    and (bili_low or bili_mid and gs)
    and anc_ok and plat_ok and hemo_ok
    as match
from lab left join como using (person_id)
;

/*
select match, count(*)
from _p_aof group by match;
*/
create view _p_a_t_aof as
select person_id, attribute_id, trial_id,
match
from _p_aof
cross join trial_attribute_used
join crit_attribute_used using (attribute_id)
where code='AOF20200229'
;
/*
select match, count(distinct person_id)
from _p_a_t_aof
group by match
;
*/
