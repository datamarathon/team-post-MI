create table public.deleteme as (

select distinct subject_id, charttime, icustay_id 
from "mimic2v26"."medevents"
where itemid = '43' OR itemid = '307'
limit 100
)
