----*CREATE TABLE* SELECT ALL PATIENTS/HADM_ID WITH A CARDIOGENIC SHOCK IDC9 Dx
create table public.ICD9_CS_PNTS AS (
	SELECT DISTINCT SUBJECT_ID, HADM_ID
		FROM mimic2v26.icd9
		where CODE  like '%785.51%');
--656

----*CREATE TABLE% SELECT ALL PATIENTS WITH CARDIOGENIC SHOCK LISTED IN THEIR NOTE EVENTS
create table public.NOTES_CS_PTNTS AS (
	SELECT DISTINCT SUBJECT_ID, HADM_ID, ICUSTAY_ID
		from mimic2v26.noteevents
		where TEXT LIKE '%CARDIOGENIC SHOCK%');
--145

	
----*CREATE TABLE* SELECT ALL PATIENTS WITH LOW CO AND HIGH PCWP 
create table public.CHARTCOPCWP_CS_PTNTS AS (
select distinct a.subject_iD, A.ICUSTAY_ID
from (
	select distinct A.subject_id, A.ICUSTAY_ID--, HADM_ID --count(*) 
		from mimic2v26.chartevents a
			--JOIN mimic2v26."icustay_detail" B ON A.ICUSTAY_ID=B.ICUSTAY_ID
		where a.itemid  in ('90', '89', '1602', '2112')
		and value1num <4 AND value1num not like '%$%'	) a
			join (select distinct A.subject_id, A.ICUSTAY_ID--, HADM_ID --count(*) 
					from mimic2v26.chartevents a
						--JOIN mimic2v26."icustay_detail" B ON A.ICUSTAY_ID=B.ICUSTAY_ID
					where a.itemid  in ('504')
						and value1num > 12) b on a.subject_id=b.subject_id	
);
--1,128

----*CREATE TABLE* SELECT ALL PATIENTS WHO THROUGH ONE TEST OR ANOTHER HAVE AN INDICATOR OF CARDIOGENIC SHOCK
CREATE TABLE public.ALL_CS_PTNTS AS (
SELECT DISTINCT SUBJECT_ID, HADM_ID, NULL AS "ICUSTAY_ID"
FROM public.ICD9_CS_PNTS
UNION 
SELECT DISTINCT SUBJECT_ID, HADM_ID, ICUSTAY_ID
FROM public.NOTES_CS_PTNTS
UNION
SELECT DISTINCT a.SUBJECT_ID, b.hadm_id, a.ICUSTAY_ID
FROM public.CHARTCOPCWP_CS_PTNTS a
	join mimic2v26.icustay_detail b on a.icustay_id=b.icustay_id
);
--1,861

--*VENN DIAGRAM*
SELECT DISTINCT 
CASE WHEN A.SUBJECT_ID IS NULL THEN NULL ELSE 'ALL' END,
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'ICD9' END,
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'NOTES' END,
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'CHART' END,
COUNT(*) 
FROM public.ALL_CS_PTNTS A 
	LEFT OUTER JOIN public.ICD9_CS_PNTS B ON A.SUBJECT_ID=B.SUBJECT_ID
	LEFT OUTER JOIN public.NOTES_CS_PTNTS B1 ON A.SUBJECT_ID=B1.SUBJECT_ID
	LEFT OUTER JOIN public.CHARTCOPCWP_CS_PTNTS B2 ON A.SUBJECT_ID=B2.SUBJECT_ID
GROUP BY 
CASE WHEN A.SUBJECT_ID IS NULL THEN NULL ELSE 'ALL' END,
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'ICD9' END,
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'NOTES' END,
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'CHART' END
ORDER BY COUNT(*) DESC;


----*CREATE TABLE* ALL PATIENTS THAT HAVE CARIOGENIC SHOCK PLUS THEIR SOURCE OF THIS INFORMATION
CREATE TABLE public.ALL_DET_CS_PTNTS AS (
SELECT DISTINCT A.SUBJECT_ID, a.hadm_id, a.icustay_id,
CASE WHEN B.SUBJECT_ID IS NULL THEN NULL ELSE 'ICD9' END AS "ICD9",
CASE WHEN B1.SUBJECT_ID IS NULL THEN NULL ELSE 'NOTES' END AS "NOTES",
CASE WHEN B2.SUBJECT_ID IS NULL THEN NULL ELSE 'CHART' END AS "CHART"
FROM public.ALL_CS_PTNTS A 
	LEFT OUTER JOIN public.ICD9_CS_PNTS B ON A.SUBJECT_ID=B.SUBJECT_ID
	LEFT OUTER JOIN public.NOTES_CS_PTNTS B1 ON A.SUBJECT_ID=B1.SUBJECT_ID
	LEFT OUTER JOIN public.CHARTCOPCWP_CS_PTNTS B2 ON A.SUBJECT_ID=B2.SUBJECT_ID
);
--1,861

