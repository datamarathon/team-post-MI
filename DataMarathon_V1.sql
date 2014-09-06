--Order distinct code/descriptions for ICD9 Dxs for AMIs by frequency of Dx
select distinct code, description, count(*) from "MIMIC2V26"."icd9"
where code like '%410%'
group by code, description
order by count(*) desc

--~11K ICD9 Dxs for patients with an AMI
select COUNT(*) from "MIMIC2V26"."icd9"
where CODE  like '%401%'

--~656 ICD9 Dxs for patients with cardiogenic shock
select  COUNT(*) from "MIMIC2V26"."icd9"
where CODE  like '%785.51%'

----*CREATE TABLE* SELECT ALL PATIENTS/HADM_ID WITH A CARDIOGENIC SHOCK IDC9 Dx
create table "USER7"."ICD9_CS_PNTS" AS (
	SELECT DISTINCT SUBJECT_ID, HADM_ID
		FROM "MIMIC2V26"."icd9"
		where CODE  like '%785.51%')
--656

--2 patients had an ICD9 Dx for cardiogenic shock on the same hospital stay (but after) as an AMI
select distinct  a.subject_id
from "MIMIC2V26"."icd9" a
	join "MIMIC2V26"."icd9" b on a.subject_id=b.subject_id
	--	and a.hadm_id=b.hadm_id	--12 patients receive cardiogenic shock after an AMI, but on a different hospital stay
where a.code like '%401%'
	and b.code like '%785.51%'
	and a.sequence<b.sequence

--131 notes that mention cardiogenic shock
select count(DISTINCT SUBJECT_ID) from "MIMIC2V26"."noteevents"
where TEXT LIKE '%CARDIOGENIC SHOCK%'

----*CREATE TABLE% SELECT ALL PATIENTS WITH CARDIOGENIC SHOCK LISTED IN THEIR NOTE EVENTS
create table "USER7"."NOTES_CS_PTNTS" AS (
	SELECT DISTINCT SUBJECT_ID, HADM_ID, ICUSTAY_ID
		from "MIMIC2V26"."noteevents"
		where TEXT LIKE '%CARDIOGENIC SHOCK%')
--145

--~3,081 distinct patients w/chart events for CO w/data that is less than 4L/min
select count(distinct subject_id) --count(*) 
from "MIMIC2V26"."chartevents" a
	--join "MIMIC2V26"."d_chartitems" b on a.itemid=b.itemid
where a.itemid  in ('90', '89', '1602', '2112')
	and value1num <4 AND value1num not like '%$%'

--~1,935 distinct patients w/chart events for PCWP w/data greater than 15
select count(distinct subject_id) --count(*) 
from "MIMIC2V26"."chartevents" a
--	join "MIMIC2V26"."d_chartitems" b on a.itemid=b.itemid
where a.itemid  in ('504')
	and value1num > 12
	
----*CREATE TABLE* SELECT ALL PATIENTS WITH LOW CO AND HIGH PCWP 
create table "USER7"."CHARTCOPCWP_CS_PTNTS" AS (
select distinct a.subject_iD, A.ICUSTAY_ID
from (
	select distinct A.subject_id, A.ICUSTAY_ID--, HADM_ID --count(*) 
		from "MIMIC2V26"."chartevents" a
			--JOIN "MIMIC2V26"."icustay_detail" B ON A.ICUSTAY_ID=B.ICUSTAY_ID
		where a.itemid  in ('90', '89', '1602', '2112')
		and value1num <4 AND value1num not like '%$%'	) a
			join (select distinct A.subject_id, A.ICUSTAY_ID--, HADM_ID --count(*) 
					from "MIMIC2V26"."chartevents" a
						--JOIN "MIMIC2V26"."icustay_detail" B ON A.ICUSTAY_ID=B.ICUSTAY_ID
					where a.itemid  in ('504')
						and value1num > 12) b on a.subject_id=b.subject_id	
)
--1,128

----*CREATE TABLE* SELECT ALL PATIENTS WHO THROUGH ONE TEST OR ANOTHER HAVE AN INDICATOR OF CARDIOGENIC SHOCK
CREATE TABLE "USER7"."ALL_CS_PTNTS" AS (
SELECT DISTINCT SUBJECT_ID, HADM_ID, NULL AS "ICUSTAY_ID"
FROM "USER7"."ICD9_CS_PNTS"
UNION 
SELECT DISTINCT SUBJECT_ID, HADM_ID, ICUSTAY_ID
FROM "USER7"."NOTES_CS_PTNTS"
UNION
SELECT DISTINCT a.SUBJECT_ID, b.hadm_id, a.ICUSTAY_ID
FROM "USER7"."CHARTCOPCWP_CS_PTNTS" a
	join "MIMIC2V26"."icustay_detail" b on a.icustay_id=b.icustay_id
)
--1,861

--*VENN DIAGRAM*
SELECT DISTINCT 
CASE WHEN A.SUBJECT_ID IS NULL THEN NULL ELSE 'ALL' END,
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'ICD9' END,
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'NOTES' END,
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'CHART' END,
COUNT(*) 
FROM "USER7"."ALL_CS_PTNTS" A 
	LEFT OUTER JOIN "USER7"."ICD9_CS_PNTS" B ON A.SUBJECT_ID=B.SUBJECT_ID
	LEFT OUTER JOIN "USER7"."NOTES_CS_PTNTS" B1 ON A.SUBJECT_ID=B1.SUBJECT_ID
	LEFT OUTER JOIN "USER7"."CHARTCOPCWP_CS_PTNTS" B2 ON A.SUBJECT_ID=B2.SUBJECT_ID
GROUP BY 
CASE WHEN A.SUBJECT_ID IS NULL THEN NULL ELSE 'ALL' END,
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'ICD9' END,
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'NOTES' END,
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'CHART' END
ORDER BY COUNT(*) DESC


----*CREATE TABLE* ALL PATIENTS THAT HAVE CARIOGENIC SHOCK PLUS THEIR SOURCE OF THIS INFORMATION
CREATE TABLE "USER7"."ALL_DET_CS_PTNTS" AS (
SELECT DISTINCT A.SUBJECT_ID, a.hadm_id, a.icustay_id,
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'ICD9' END AS "ICD9",
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'NOTES' END AS "NOTES",
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'CHART' END AS "CHART"
FROM "USER7"."ALL_CS_PTNTS" A 
	LEFT OUTER JOIN "USER7"."ICD9_CS_PNTS" B ON A.SUBJECT_ID=B.SUBJECT_ID
	LEFT OUTER JOIN "USER7"."NOTES_CS_PTNTS" B1 ON A.SUBJECT_ID=B1.SUBJECT_ID
	LEFT OUTER JOIN "USER7"."CHARTCOPCWP_CS_PTNTS" B2 ON A.SUBJECT_ID=B2.SUBJECT_ID
)
--1,861

