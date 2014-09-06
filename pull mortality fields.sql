-- NON working query that I (Andy Z.) was trying to form.
-- Andrew Ward's query works.
-- This one is basically a dead end.

select b.first_drug, a.*
from (
	select distinct subject_id, hadm_id, dod, hospital_admit_dt, icustay_intime, expire_flg, hospital_expire_flg,
	icustay_first_service, gender, dob, icustay_admit_age
	from "MIMIC2V26"."icustay_detail"
) as a
right join "USER7"."FINAL_PTNTS" as b
on a.subject_id = b.subject_id and a.hadm_id = b.hadm_id
order by subject_id
--what do we do with the following: icustay_intime icustay_first_service icustay_admit_age
