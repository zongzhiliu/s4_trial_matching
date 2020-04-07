/*  Generate view for each kind of reference map. 
    So that even after we replace the mapping table with another one, we can still get the same result.
 */

drop view if exists ref_drug_mapping;
drop view if exists ref_lab_mapping;

create view ref_drug_mapping as
select * from ${ref_drug_mapping}
;

create view ref_lab_mapping as
select * from ${ref_lab_mapping}
;

drop view if exists ref_proc_mapping;
create view ref_proc_mapping as
select * from ${ref_proc_mapping}
;

drop view if exists ref_rx_mapping;
create view ref_rx_mapping as
select * from ${ref_rx_mapping}
;
