---Searching d_meditems---
SELECT * FROM "MIMIC2V26"."d_meditems" AS "med_items" 
WHERE "med_items"."LABEL" like '%Dopamine%'

SELECT * FROM "MIMIC2V26"."d_meditems" AS "med_items"
WHERE "med_items"."LABEL" like '%Levophed%'

SELECT * FROM "MIMIC2V26"."d_ioitems" AS "io_items"
WHERE "io_items"."LABEL" like '%Dopamine%'

SELECT * FROM "MIMIC2V26"."d_ioitems" AS "io_items" 
WHERE "io_items"."LABEL" like '%levophed%'

SELECT COUNT(distinct subject_id) FROM "MIMIC2V26"."medevents" AS "med_ev", "MIMIC2V26"."deliveries" AS "del_ev"
WHERE "med_ev"."ITEMID" like '43' OR "del_ev"."IOITEMID" like 

---Find all patients with dopamine---
select count(distinct subject_id) from
 (
select distinct subject_id 
from "MIMIC2V26"."medevents" a 
where itemid like '43' OR itemid like '307'
union all
select distinct subject_id from "MIMIC2V26"."deliveries" AS "del_ev" 
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io"."LABEL" like '%Dopamine%'
union all
select distinct subject_id from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Dopamine%')

---Find all patients with Levophed---
select count(distinct subject_id) from
 (
select distinct subject_id 
from "MIMIC2V26"."medevents" a 
where itemid like '47' OR itemid like '120'
union all
select distinct subject_id from "MIMIC2V26"."deliveries" AS "del_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid
where "d_io"."LABEL" like '%Levophed%'
union all
select distinct subject_id from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Levophed%')

---Find all patients with both dopamine and levophed
select count(distinct subject_id) from
 (
select distinct subject_id 
from "MIMIC2V26"."medevents" a 
where itemid like '43' OR itemid like '307' OR (itemid like '47' OR itemid like '120')
union all
select distinct subject_id from "MIMIC2V26"."deliveries" AS "del_ev" 
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%'
union all
select distinct subject_id from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%')

---Count all patients with both dopamine and levophed
select COUNT(distinct subject_id)  from
 (
select distinct subject_id
from "MIMIC2V26"."medevents" a 
where itemid like '43' OR itemid like '307' OR (itemid like '47' OR itemid like '120')
union all
select distinct subject_id from "MIMIC2V26"."deliveries" AS "del_ev" 
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%'
union all
select distinct subject_id from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%')

---List all patients with both dopamine and levophed
select distinct subject_id, charttime, itemid  from
 (
select distinct subject_id, charttime, itemid 
from "MIMIC2V26"."medevents" a 
where itemid like '43' OR itemid like '307' OR (itemid like '47' OR itemid like '120')
union all
select distinct subject_id, charttime, ioitemid as itemid from "MIMIC2V26"."deliveries" AS "del_ev" 
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%'
union all
select distinct subject_id, charttime, itemid from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%')
order by charttime