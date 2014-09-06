create table "USER7"."high_troponins" as
(
select distinct subject_id, hadm_id, icustay_id from (
  select subject_id, hadm_id, icustay_id, charttime, valuenum
  from "MIMIC2V26"."labevents"
  where itemid in (50189, 50188) and valuenum > 1
)
)
