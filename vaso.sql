select count(*)
from
"MIMIC2V26"."medevents", "MIMIC2V26"."d_meditems"
where "MIMIC2V26"."medevents".itemid = "MIMIC2V26"."d_meditems".itemid
and trim(lower("MIMIC2V26"."d_meditems".label)) = 'vasopressin';
