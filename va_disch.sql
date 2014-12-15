select * 
from mimic2v26.noteevents 
where (
    category like '%DISCHARGE%'
    and (text like '%heart fail%'
        or text like '%CHF%'
    	or text like '%diures%'	
	)
)
limit 20;
