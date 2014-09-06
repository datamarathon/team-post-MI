select b.*, a.dod, a.hospital_admit_dt, a.icustay_intime, a.expire_flg, a.hospital_expire_flg, 
a.icustay_first_service, a.gender, a.dob, a.icustay_admit_age
from "MIMIC2V26"."icustay_detail" as a
right join "USER7"."FINAL_PTNTS" as b
on a.subject_id = b.subject_id and a.hadm_id = b.hadm_id
