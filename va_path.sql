select count(*), category
from mimic2v26.noteevents group by category order by category;
-- where (
--     text like '%anaplas%'
-- )
--limit 20;


--  count  |     category      
-- --------+-------------------
--   31957 | DISCHARGE_SUMMARY
--   23285 | MD Notes
--  800004 | Nursing/Other
--  384431 | RADIOLOGY_REPORT



--next thing is look at : CHARTEVENTS, LABEVENTS, PROCEDUREEVENTS, and
--maybe more detail of NOTEEVENTS


