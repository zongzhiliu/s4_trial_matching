/*
Requires: {dmsdw},  {disease_icd}
Results: demo, cohort
*/
drop table if exists _cohort;
create table _cohort as
select medical_record_number mrn, count(*) n_icd
from ${dmsdw}.D_PERSON
join ${dmsdw}.FACT using (person_key)
join ${dmsdw}.B_DIAGNOSIS using (diagnosis_group_key)
join ${dmsdw}.fd_DIAGNOSIS rd using (diagnosis_key)
where context_name like 'ICD%' and context_diagnosis_code ~ '${disease_icd}'
group by mrn
;
	--17K

drop table if exists demo cascade;
create table demo as

select mrn, mrn person_id
, TO_DATE(datepart(year, date_of_birth) || '-' || month_of_birth, 'yyyy-month') dob_low
, dob_low as date_of_birth
, last_day(dob_low) as dob_high

, datepart(year, dob_low) dob_year, datepart(month, dob_low) dob_month
, race race_raw, patient_ethnic_group ethnicity_raw
, case gender
	when 'Male' then 'male'
	when 'Female' then 'female'
	end as gender
, case deceased_indicator
	when 'Yes' then True
	when 'No' then False
	end as deceased
from _cohort
join ${dmsdw}.d_person on mrn=medical_record_number
where active_flag='Y'
	and (not deceased or deceased is null) -- already deceased
	and datediff(year, dob_low, current_date)<130 -- impossible birthdate
;

drop table if exists cohort;
create table cohort as
select distinct mrn, person_id
from demo;

drop table if exists _person;
create table _person as
select person_key, mrn
from cohort
join ${dmsdw}.d_person dp on medical_record_number=mrn
;

/*
select count(*), count(distinct mrn) 
--select *
from demo;
	-- 16712
*/

/*
drop view v_demo_w_zip;
create or replace view v_demo_w_zip as
select mrn as person_id, gender
, dob_low date_of_birth_truncated --, d.date_of_death::date
, nvl(c.race_name, 'Unknown') race_name
, d.ethnicity, d.address_zip
from demo_w_zipcode d
join cohort using (mrn)
left join ct.non_cancer_race_mapping c using (race)
order by person_id
;
*/

grant all on table demo to mingwei_zhang;
grant all on table cohort to mingwei_zhang;

