/*
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
*/

--CLEAN UP SUPLICATE HADM_ID X SUBJECT_ID
CREATE TABLE "USER7"."CLEAN_HIGH_TROP" AS (SELECT DISTINCT SUBJECT_ID, HADM_ID
FROM "USER7"."high_troponins")
--3,041

CREATE TABLE "USER7"."CLEAN_CS" AS (SELECT DISTINCT SUBJECT_ID, HADM_ID
FROM "USER7"."ALL_DET_CS_PTNTS")
--1,601

CREATE TABLE "USER7"."CLEAN_PRESSOR" AS (SELECT DISTINCT NOR_SUBJECT_ID, HADM_ID, "first_drug"
FROM "USER7"."drug_first_w_HADM")
--1,084

----*CREATE TABLE* SELECT ALL PATIENTS IN ANY OF OUR THREE STEPS OF ANALYSIS
CREATE TABLE "USER7"."ALL_PTNTS" AS (
select distinct subject_id, HADM_ID from "USER7"."CLEAN_HIGH_TROP"	
union
select distinct subject_id, HADM_ID from "USER7"."CLEAN_CS"
union
select distinct NOR_SUBJECT_ID, HADM_ID from "USER7"."CLEAN_PRESSOR" )
--4,701


--*VENN DIAGRAM*
SELECT DISTINCT 
CASE WHEN A.hadm_id IS NULL THEN NULL ELSE 'ALL' END AS "ALL",
CASE WHEN B.hadm_id IS NULL THEN NULL ELSE 'AMI' END AS "AMI",
CASE WHEN B1.hadm_id IS NULL THEN NULL ELSE 'CS' END AS "CS",
CASE WHEN B2.hadm_id IS NULL THEN NULL ELSE 'PRESSOR' END AS "PRESSOR",
COUNT(*) 
FROM "USER7"."ALL_PTNTS" A 
	LEFT OUTER JOIN "USER7"."CLEAN_HIGH_TROP" B ON A.SUBJECT_ID=B.SUBJECT_ID and a.hadm_id=b.hadm_id
	LEFT OUTER JOIN "USER7"."CLEAN_CS" B1 ON A.SUBJECT_ID=B1.SUBJECT_ID and a.hadm_id=b1.hadm_id
	LEFT OUTER JOIN "USER7"."CLEAN_PRESSOR" B2 ON A.SUBJECT_ID=B2.NOR_SUBJECT_ID and a.hadm_id=b2.hadm_id
GROUP BY 
CASE WHEN A.hadm_id IS NULL THEN NULL ELSE 'ALL' END ,
CASE WHEN B.hadm_id IS NULL THEN NULL ELSE 'AMI' END,
CASE WHEN B1.hadm_id IS NULL THEN NULL ELSE 'CS' END ,
CASE WHEN B2.hadm_id IS NULL THEN NULL ELSE 'PRESSOR' END
ORDER BY COUNT(*) DESC

create table "USER7"."FINAL_PTNTS" AS (
SELECT DISTINCT A.SUBJECT_ID, a.hadm_id, "first_drug"
FROM "USER7"."CLEAN_HIGH_TROP" A
	JOIN "USER7"."CLEAN_CS" B ON A.HADM_ID=B.HADM_ID and a.subject_id=b.subject_id
	join "USER7"."CLEAN_PRESSOR" b1 on a.hadm_id=b1.hadm_id  and a.subject_id=b1.nor_subject_id
)
--191

-- Next SELECT statement is the important one.
SELECT DISTINCT a.SUBJECT_ID, a.HADM_ID, GENDER, DOB, DOD, EXPIRE_FLG, HOSPITAL_ADMIT_DT, HOSPITAL_DISCH_DT,
HOSPITAL_EXPIRE_FLG, B."first_drug"
FROM "MIMIC2V26"."icustay_detail" A 
	JOIN "USER7"."FINAL_PTNTS" B ON A.SUBJECT_ID=B.SUBJECT_ID AND A.HADM_ID=B.HADM_ID
WHERE a.SUBJECT_ID IN (SELECT DISTINCT SUBJECT_ID FROM "USER7"."FINAL_PTNTS") 
	AND a.HADM_ID IN (SELECT DISTINCT HADM_ID FROM "USER7"."FINAL_PTNTS") 

TOP 10* FROM "MIMIC2V26"."icustay_detail"

SELECT A.*, B.SEX, B.DOB, DOD, HOSPITAL_EXPIRE_FLG
FROM BLANK A
	JOIN "MIMIC2V26"."d_patients" B ON A.SUBJECT_ID=B.SUBJECT_ID


SELECT TOP 10* FROM "MIMIC2V26"."d_patients"
