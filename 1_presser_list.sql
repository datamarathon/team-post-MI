---creating table of patients who receive dopamine
CREATE table public.dopamine_table as 
(select * from
 (
select distinct subject_id, charttime, icustay_id 
from mimic2v26.medevents a 
where itemid = '43' OR itemid = '307'
union all
select distinct subject_id, charttime, icustay_id from mimic2v26.deliveries AS "del_ev" 
	join mimic2v26.d_ioitems "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io".LABEL like '%Dopamine%'
union all
select distinct subject_id, charttime, icustay_id from mimic2v26.ioevents AS "io_ev"
	join mimic2v26.d_ioitems "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io".LABEL like '%Dopamine%') as dt );

---Table for icu stays with first dopamine given
CREATE table public.uni_dop_table as
(select distinct subject_id, icustay_id, min(charttime) as charttime
from public.dopamine_table
group by icustay_id, subject_id);


---creating table of patients who receive levophed
CREATE table public.norepi_table as 
(select * from
 (
select distinct subject_id, charttime, icustay_id 
from mimic2v26.medevents a 
where itemid = '47' OR itemid = '120'
union all
select distinct subject_id, charttime, icustay_id from mimic2v26.deliveries AS "del_ev" 
	join mimic2v26.d_ioitems "d_io" on "del_ev".ioitemid="d_io".itemid 
where "d_io".LABEL like '%Levophed%'
union all
select distinct subject_id, charttime, icustay_id from mimic2v26.ioevents AS "io_ev"
	join mimic2v26.d_ioitems "d_io" on "io_ev".itemid= "d_io".itemid
where "d_io".LABEL like '%Levophed%') as nt );

---Table for icu stays with first levophed given
CREATE table public.uni_nor_table as
(select distinct subject_id, icustay_id, min(charttime) as charttime
from public.norepi_table
group by icustay_id, subject_id);



---Create a combined dopamine, norepi table
create table public.combine_pressers_table as 
( select a.subject_id as dop_subject_id, a.charttime as dop_charttime, a.icustay_id as dop_icustay_id, b.subject_id as nor_subject_id, b.charttime as nor_charttime, b.icustay_id as nor_icustay_id
from public.uni_dop_table a
	join public.uni_nor_table b on a.icustay_id=b.icustay_id);


--Creating table with list of which drug first for patient give both
CREATE table public.drug_first_table as
(select *,
case 
when dop_charttime<nor_charttime then 'DOP' 
when dop_charttime = nor_charttime then 'BOTH'
else 'NOR' 
end as "first_drug"
 from public.combine_pressers_table);

---Joining with HADM ID using icu_stay
CREATE table public.drug_first_w_HADM as
(select a.*, b.hadm_id
from public.drug_first_table a
	join mimic2v26.icustay_detail b on a.dop_icustay_id = b.icustay_id);
	
COMMENT ON TABLE public.drug_first_w_HADM IS 'Pt drug first list w HADM';
