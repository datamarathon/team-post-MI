create table "USER7"."deleteme_sub_had" as(
	select distinct * from(
		select subject_id, hadm_id
		from "MIMIC2V26"."icustay_detail"
		order by hadm_id desc
	)
	limit 150
)



select a.subject_id, a.icustay_id, a.hadm_id, a.dod, a.hospital_admit_dt, a.icustay_intime, a.expire_flg, a.hospital_expire_flg, a.icustay_first_service
from "MIMIC2V26"."icustay_detail" as a
right join "USER7"."deleteme_sub_had" as b
on a.subject_id = b.subject_id and a.hadm_id = b.hadm_id
