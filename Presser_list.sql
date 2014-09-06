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
select distinct subject_id, charttime, itemid from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%'
union all
select distinct subject_id, charttime, ioitemid from "MIMIC2V26"."deliveries" AS "del_ev" 
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io"."LABEL" like '%Dopamine%' OR "d_io"."LABEL" like '%Levophed%')
order by charttime

---creating table of patients who receive dopamine
CREATE table "USER7"."dopamine_table" as 
(select * from
 (
select distinct subject_id, charttime, icustay_id 
from "MIMIC2V26"."medevents" a 
where itemid like '43' OR itemid like '307'
union all
select distinct subject_id, charttime, icustay_id from "MIMIC2V26"."deliveries" AS "del_ev" 
	join "MIMIC2V26"."d_ioitems" "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io"."LABEL" like '%Dopamine%'
union all
select distinct subject_id, charttime, icustay_id from "MIMIC2V26"."ioevents" AS "io_ev"
	join "MIMIC2V26"."d_ioitems" "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io"."LABEL" like '%Dopamine%'))

---Table for icu stays with first dopamine given
CREATE table "USER7"."uni_dop_table" as
(select distinct subject_id, icustay_id, min(charttime) as charttime
from "USER7"."dopamine_table"
group by icustay_id, subject_id)

---Viewing dopamine table--
select top 100 * from "USER7"."dopamine_table"

---creating table of patients who receive levophed
CREATE table "USER7"."norepi_table" as 
(select * from
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
where "d_io"."LABEL" like '%Levophed%'))

---Table for icu stays with first levophed given
CREATE table "USER7"."uni_nor_table" as
(select distinct subject_id, icustay_id, min(charttime) as charttime
from "USER7"."norepi_table"
group by icustay_id, subject_id)

---Viewing norepineephrine table--
select top 100 * from "USER7"."uni_nor_table"

---Create a combined dopamine, norepi table
create table "USER7"."combine_pressers_table" as 
( select a.subject_id as dop_subject_id, a.charttime as dop_charttime, a.icustay_id as dop_icustay_id, b.subject_id as nor_subject_id, b.charttime as nor_charttime, b.icustay_id as nor_icustay_id
from "USER7"."uni_dop_table" a
	join "USER7"."uni_nor_table" b on a.icustay_id=b.icustay_id)

---Viewing combined presser table--
select top 200 * from "USER7"."combine_pressers_table"

--Creating table with list of which drug first for patient give both
CREATE table "USER7"."drug_first_table" as
(select *,
case 
when dop_charttime<nor_charttime then 'DOP' 
when dop_charttime = nor_charttime then 'BOTH'
else 'NOR' 
end as "first_drug"
 from "USER7"."combine_pressers_table")

---Joining with HADM ID using icu_stay
CREATE table "USER7"."drug_first_w_HADM" as
(select a.*, b.hadm_id
from "USER7"."drug_first_table" a
	join "MIMIC2V26"."icustay_detail" b on a.dop_icustay_id = b.icustay_id)
	
COMMENT ON TABLE "USER7"."drug_first_w_HADM" IS 'Pt drug first list w HADM'