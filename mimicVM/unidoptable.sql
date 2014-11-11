select distinct subject_id, icustay_id, min(charttime) as charttime
from "USER7"."dopamine_table"
group by icustay_id, subject_id
