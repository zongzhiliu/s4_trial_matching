<<<<<<< HEAD
-- run on the pharma server
=======
/* run on the pharma server
 Requires: working_schema, logic_cols
    , v_crit_attribute_used_new, v_master_sheet_n
*/
>>>>>>> 6f6e4b23d63baa5ac94d790dbcfcddfb0d70d53b
use db_data_bridge;

create index i_${disease}_v_master_sheet_n__n
on ${disease}_v_master_sheet_n (new_attribute_id);
create index i_${disease}_v_master_sheet_n__n_t_p
on ${disease}_v_master_sheet_n (new_attribute_id, trial_id, person_id);
create index i_${disease}_v_crit_attribute__n
on ${disease}_v_crit_attribute_used_new (new_attribute_id);

create table ${disease}_master_sheet_new as
select new_attribute_id, old_attribute_id
, trial_id, person_id
, attribute_group, attribute_name, attribute_value
, attribute_match
, inclusion, exclusion
, mandatory
, logic_l1, logic_l2
from ${disease}_v_master_sheet_n m
join ${disease}_v_crit_attribute_used_new using (new_attribute_id)
order by person_id, trial_id, new_attribute_id
;
