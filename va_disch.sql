select category, text
from mimic2v26.noteevents 
where (
    category like '%DISCHARGE%'
    and (text like '%acute decompensated heart%'

	)
)
limit 20;
