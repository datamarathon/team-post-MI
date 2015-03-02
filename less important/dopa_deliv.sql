select distinct subject_id, charttime, icustay_id 
from "mimic2v26"."deliveries" AS "del_ev" 
join "mimic2v26"."d_ioitems" as "d_io" 
on "del_ev".ioitemid="d_io".itemid  
where "d_io".label like '%Dopamine%'

