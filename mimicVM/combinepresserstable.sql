select a.subject_id as dop_subject_id, a.charttime as dop_charttime, a.icustay_id as dop_icustay_id, b.subject_id as nor_subject_id, b.charttime as nor_charttime, b.icustay_id as nor_icustay_id
from "USER7"."uni_dop_table" a
	join "USER7"."uni_nor_table" b on a.icustay_id=b.icustay_id
