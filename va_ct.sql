select * 
from mimic2v26.noteevents 
where (
    category like '%RADIO%'
    and text like '%spicula%'
    and text like '%CHEST%'
    and text like '% CT %'
    and (text like '%cancer%' or text like '%malign%')
)
limit 20;
