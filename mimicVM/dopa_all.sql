select distinct subject_id, charttime, icustay_id 
from "mimic2v26"."medevents"
where itemid = '43' OR itemid = '307'

union all

select distinct subject_id, charttime, icustay_id 
from "mimic2v26"."deliveries" AS "del_ev" 
join "mimic2v26"."d_ioitems" as "d_io" 
on "del_ev".ioitemid="d_io".itemid 
and "d_io"."label" like '%Dopamine%'

union all

select distinct subject_id, charttime, icustay_id 
from "mimic2v26"."ioevents" AS "io_ev"
join "mimic2v26"."d_ioitems" "d_io" 
on "io_ev".itemid= "d_io".itemid
where "d_io"."label" like '%Dopamine%'

limit 100

