/**** diagnosis
Requires:
    _person, dmsdw
Results:
    latest_icd
Note: We are getting latest icd to find the latest diagnosis
*/
-- All diagnosis extrated using ICD code.
drop table if exists _dx;
create table _dx as
select distinct mrn
, age_in_days_key as age_in_days
, DESCRIPTION
, context_diagnosis_code, context_name
, diagnosis_role, diagnosis_weighting_factor
from _person
join ${dmsdw}.fact using (person_key)
join ${dmsdw}.b_diagnosis using (diagnosis_group_key)
join ${dmsdw}.fd_diagnosis rd using (diagnosis_key)
where context_name in ('ICD-10', 'ICD-9')
;
/*  Latest diagnosis
    To acheive this, we divided diagnosis table into small tables where they contain the same mrn and diatnosis code.
    Then we order each table by the date and get the latest icd.
 */
drop table if exists latest_icd;
create table latest_icd as
select mrn, person_id
, context_diagnosis_code icd_code, context_name
, dateadd(day, age_in_days::int, dob_low)::date as dx_date
from (select *, row_number() over (
        partition by mrn, context_diagnosis_code
        order by -age_in_days, description)
    from _dx)
join demo using (mrn)
where row_number=1
;

--First time diagnose with disease using similar method
drop table if exists earliest_icd;
create table earliest_icd as
select mrn, person_id
, context_diagnosis_code icd_code, context_name
, dateadd(day, age_in_days::int, dob_low)::date as dx_date
from (select *, row_number() over (
        partition by mrn, context_diagnosis_code
        order by age_in_days, description)
    from _dx)
join demo using (mrn)
where row_number=1
;
