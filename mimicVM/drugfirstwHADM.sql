select a.*, b.hadm_id
from "USER7"."drug_first_table" a
	join "MIMIC2V26"."icustay_detail" b on a.dop_icustay_id = b.icustay_id
