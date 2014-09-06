select top 10* from "MIMIC2V26"."medevents"

select top 10* from "MIMIC2V26"."ioevents"

select top 10* from "MIMIC2V26"."d_meditems" where itemid='43'label like '%dopamine%'

create table "USER7"."PRESSOR_DOPE" AS (
select distinct subject_id, min(charttime) as "min_chart_time", icustay_id
from "MIMIC2V26"."medevents" a
	JOIN "MIMIC2V26"."d_meditems" b on a.itemid=b.itemid
where b.label like '%Dopamine%'
group by subject_id, icustay_id
union
select distinct subject_id, min(charttime) as "min_chart_time", icustay_id
from "MIMIC2V26"."ioevents" a
	JOIN "MIMIC2V26"."d_ioitems" b on a.itemid=b.itemid
where b.label like '%Dopamine%'
group by subject_id, icustay_id)
--3,966

----*CREATE TABLE* SELECT ALL PATIENTS IN ANY OF OUR THREE STEPS OF ANALYSIS
CREATE TABLE "USER7"."ALL_PTNTS" AS (
select distinct NOR_SUBJECT_ID, HADM_ID from "USER7"."drug_first_w_HADM" 
union
select distinct subject_id, HADM_ID from "USER7"."ALL_DET_CS_PTNTS"
union
select distinct subject_id, HADM_ID from "USER7"."high_troponins"	)
--4,701

--*VENN DIAGRAM*
SELECT DISTINCT 
CASE WHEN A.SUBJECT_ID IS NULL THEN NULL ELSE 'ALL' END AS "ALL",
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'PRESSOR' END AS "PRESSOR",
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'CS' END AS "CS",
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'AMI' END AS "AMI",
COUNT(*) 
FROM "USER7"."ALL_PTNTS" A 
	LEFT OUTER JOIN "USER7"."drug_first_w_HADM" B ON A.SUBJECT_ID=B.NOR_SUBJECT_ID
	LEFT OUTER JOIN "USER7"."ALL_DET_CS_PTNTS" B1 ON A.SUBJECT_ID=B1.SUBJECT_ID
	LEFT OUTER JOIN "USER7"."high_troponins" B2 ON A.SUBJECT_ID=B2.SUBJECT_ID
GROUP BY 
CASE WHEN A.SUBJECT_ID IS NULL THEN NULL ELSE 'ALL' END AS "ALL",
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'PRESSOR' END AS "PRESSOR",
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'CS' END AS "CS",
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'AMI' END AS "AMI",
ORDER BY COUNT(*) DESC

SELECT DISTINCT A.SUBJECT_ID,
FROM "USER7"."high_troponins" A
	JOIN "USER7"."ALL_DET_CS_PTNTS" B ON A.HADM_ID=B.HADM_ID
	



SELECT TOP 10* FROM "USER7"."drug_first_table"
select top 10* from "USER7"."ALL_DET_CS_PTNTS"
select top 10* from "USER7"."high_troponins"


select distinct first_drug, count(*)
FROM "USER7"."drug_first_table"
group by first_drug
order by count(*) desc

