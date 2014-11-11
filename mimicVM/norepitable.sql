select * from
 (
select distinct subject_id, charttime, icustay_id 
from "MIMIC2V26"."medevents" a 
where itemid like '47' OR itemid like '120'
union all
select distinct subject_id, charttime, icustay_id from "MIMIC2V26"."deliveries" AS "del_ev" 
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io"."LABEL" like '%Levophed%'
union all
select distinct subject_id, charttime, icustay_id from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Levophed%')
