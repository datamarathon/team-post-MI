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

--343 notes that mention cardiogenic shock
select count(*) from "MIMIC2V26"."noteevents"
where TEXT LIKE '%CARDIOGENIC SHOCK%'

--2 patients had an ICD9 Dx for cardiogenic shock on the same hospital stay (but after) as an AMI
select distinct  a.subject_id
from "MIMIC2V26"."icd9" a
	join "MIMIC2V26"."icd9" b on a.subject_id=b.subject_id
	--	and a.hadm_id=b.hadm_id	--12 patients receive cardiogenic shock after an AMI, but on a different hospital stay
where a.code like '%401%'
	and b.code like '%785.51%'
	and a.sequence<b.sequence

--~6k distinct patients w/chart events for CO w/data / ~208k chart events for cardiac output that have values 
select count(distinct subject_id) --count(*) 
from "MIMIC2V26"."chartevents" a
	join "MIMIC2V26"."d_chartitems" b on a.itemid=b.itemid
where a.itemid  in ('90', '89', '1602', '2112')
	and value1num not like '%$%'

--~2.204k distinct patients w/chart events for PCWP w/data / ~20k chart events for PCWP that have values 
select count(distinct subject_id) --count(*) 
from "MIMIC2V26"."chartevents" a
	join "MIMIC2V26"."d_chartitems" b on a.itemid=b.itemid
where a.itemid  in ('504')
	and value1num not like '%$%'
	
--~2.2k distinct patients w/chart events for CO w/data / ~20k chart events for cardiac output that have values 
select count(distinct a.subject_id) 
from (
	select distinct subject_id--) --count(*) 
	from "MIMIC2V26"."chartevents" a
		join "MIMIC2V26"."d_chartitems" b on a.itemid=b.itemid
	where a.itemid  in ('90', '89', '1602', '2112')
	and value1num <4	) a
		join (select distinct subject_id--) --count(*) 
				from "MIMIC2V26"."chartevents" a
					join "MIMIC2V26"."d_chartitems" b on a.itemid=b.itemid
				where a.itemid  in ('504')
				and value1num not like '%$%') b on a.subject_id=b.subject_id	


select top 10* from "MIMIC2V26"."d_chartitems" where itemid like '%504%'

select top 10 CATEGORY, TEXT from "MIMIC2V26"."noteevents"
where --category='DISCHARGE_SUMMARY'
	TEXT LIKE '%CARDIOGENIC SHOCK%'	

select distinct category from "MIMIC2V26"."noteevents"
