--2747 subjects have a trop over 1 at some point

select subject_id, hadm_id, icustay_id, charttime, valuenum
from "MIMIC2V26"."labevents" 
where itemid in (50189, 50188) and valuenum > 1 
