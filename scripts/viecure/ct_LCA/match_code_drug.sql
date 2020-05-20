-- set search_path to ct_lca;

DROP TABLE IF EXISTS _medication CASCADE;
CREATE TABLE _medication as
select person_id, rx_name
FROM viecure_ct.all_rx ar
JOIN cohort using (person_id)
GROUP BY person_id, rx_name;

select count(*) from medication;

--TODO: make rx_mapping_table of (drug_name, rx_name), then join using (drug_name)
drop TABLE if exists _p_a_drug cascade;
CREATE TABLE _p_a_drug AS
SELECT person_id, attribute_id
, bool_or(case code_type
    when 'drug_name' then drug_name=code
    when 'drug_modality' then modality=code
    when 'drug_moa_rex' then ct.py_contains(moa, code)
    end) as match
from _medication m
join crit_attribute_used on code_type like 'drug_%'
join ref_drug_mapping dm
    on ct.py_contains(lower(rx_name), lower(drug_name))
group by person_id, attribute_id
;

create view qc_match_drug as
with cau as (
    select * from crit_attribute_used
    where code_type like 'drug_%'
), matched as (
    SELECT attribute_id
    , count(distinct person_id) as patients
    from _p_a_drug
    where match
    group by attribute_id
)
select attribute_id, attribute_name, attribute_value
, nvl(patients, 0) matched_patients
from cau
left join matched using (attribute_id)
order by attribute_id
;
select * from qc_match_drug;

drop TABLE if exists _p_a_drug_improved cascade;
CREATE TABLE _p_a_drug_improved AS
SELECT person_id, attribute_id
, bool_or(case code_type
    when 'drug_name' then drug_name=code
    when 'drug_modality' then modality=code
    when 'drug_moa_rex' then ct.py_contains(moa, code)
    end) as match
from crit_attribute_used
join _medication on code_type like 'drug_%'
join _rx_drug using (rx_name)
join ref_drug_mapping using (drug_name)
group by person_id, attribute_id
;

create or replace view qc_match_drug_improved as
with cau as (
    select * from crit_attribute_used
    where code_type like 'drug_%'
), matched as (
    SELECT attribute_id
    , count(distinct person_id) as patients
    from _p_a_drug_improved
    where match
    group by attribute_id
)
select attribute_id, attribute_name, attribute_value
, nvl(patients, 0) matched_patients
from cau
left join matched using (attribute_id)
order by attribute_id
;
select * from qc_match_drug_improved;

select * from qc_match_drug                                                                   │
 join qc_match_drug_improved using(attribute_id, attribute_name, attribute_value)
 order by attribute_id;
/*
SELECT count(*) FROM "_p_a_drug_improved"
where match;
--2936
*/
