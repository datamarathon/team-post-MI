create table public.high_troponins as
(
select distinct subject_id, hadm_id, icustay_id from (
  select subject_id, hadm_id, icustay_id, charttime, valuenum
  from mimic2v26.labevents
  where itemid in (50189, 50188) and valuenum > 1
) as ht
)
--about 2 min on VM on MacBook
