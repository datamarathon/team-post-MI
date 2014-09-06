--2747 subjects have a trop over 1 at some point                                                                                 \

select count(*) from ( --9038 trop measurements                                                                                   
select subject_id, hadm_id, icustay_id, charttime, valuenum
from "MIMIC2V26"."labevents"
where itemid in (50189, 50188) and valuenum > 1
)

select count(*) from ( --7900 nonmissing hadm                                                                                     
select subject_id, hadm_id, icustay_id, charttime, valuenum
from "MIMIC2V26"."labevents"
where itemid in (50189, 50188) and valuenum > 1 and hadm_id > 1
)

select count(*) from ( --5519 nonmissing icustay                                                                                  
select subject_id, hadm_id, icustay_id, charttime, valuenum
from "MIMIC2V26"."labevents"
where itemid in (50189, 50188) and valuenum > 1 and icustay_id > 1
)


select count(*) from( --3724 when distinct SUB HAD ICU                                                                            
  select distinct subject_id, hadm_id, icustay_id from (
    select subject_id, hadm_id, icustay_id, charttime, valuenum
    from "MIMIC2V26"."labevents"
    where itemid in (50189, 50188) and valuenum > 1
  )
)

select count(*) from(  --2747 when distinct SUB only                                                                              
  select distinct subject_id
  from "MIMIC2V26"."labevents"
  where itemid in (50189, 50188) and valuenum > 1
)
