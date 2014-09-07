OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

ods html close;
ods listing;

proc freq data=rawdata(where=(first_drug ne 'BOTH'));
	table hospital_expire_flg * first_drug / norow chisq nopercent;
run;
