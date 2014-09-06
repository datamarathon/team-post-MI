select * from "MIMIC2V26"."d_labitems" where loinc_description like '%ropo%' limit 150

select * from "MIMIC2V26"."labevents" where itemid in (50189, 50188) and valuenum > 1 limit 150

select count(*) from(

select distinct subject_id
from "MIMIC2V26"."labevents" 
where itemid in (50189, 50188) and valuenum > 1 
order by subject_id

)
