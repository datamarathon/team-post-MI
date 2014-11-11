select *,
case 
when dop_charttime<nor_charttime then 'DOP' 
when dop_charttime = nor_charttime then 'BOTH'
else 'NOR' 
end as "first_drug"
 from "USER7"."combine_pressers_table"
