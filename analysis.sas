OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

ods html close;
ods listing;

data WORK.FIXEDDATES    ;
%let _EFIERR_ = 0;
   infile 'C:\Users\ch151634\Dropbox\fixeddates.csv' delimiter = ';' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat VAR1 best32. ;
   informat SUBJECT_ID comma32. ;
   informat HADM_ID comma32. ;
   informat GENDER $1. ;
   informat DOB DATE9. ;
   informat DOD DATE9. ;
   informat EXPIRE_FLG $1. ;
   informat HOSPITAL_ADMIT_DT DATE9. ;
   informat HOSPITAL_DISCH_DT DATE9. ;
   informat HOSPITAL_EXPIRE_FLG $1. ;
   informat first_drug1 $4. ;
   format VAR1 best12. ;
   format SUBJECT_ID comma12. ;
   format HADM_ID comma12. ;
   format GENDER $1. ;
   format DOB DATE9. ;
   format DOD DATE9. ;
   format EXPIRE_FLG $1. ;
   format HOSPITAL_ADMIT_DT DATE9. ;
   format HOSPITAL_DISCH_DT DATE9. ;
   format HOSPITAL_EXPIRE_FLG $1. ;
   format first_drug1 $4. ;
input
            VAR1
            SUBJECT_ID
            HADM_ID
            GENDER $
            DOB
            DOD $
            EXPIRE_FLG $
            HOSPITAL_ADMIT_DT
            HOSPITAL_DISCH_DT
            HOSPITAL_EXPIRE_FLG $
            first_drug1 $
;
if _ERROR_ then call symputx('_EFIERR_',1);  
run;

proc freq data=fixeddates(where=(first_drug ne 'BOTH'));
	table hospital_expire_flg * first_drug / norow chisq nopercent;
run;

proc freq data=fixeddates;
	table hospital_expire_flg * first_drug / norow chisq fisher nopercent;
run;

data has_timevar;
	set fixeddates;
	if expire_flg = "Y" then time = dod - hospital_admit_dt;
	if expire_flg = "N" then time = hospital_disch_dt - hospital_admit_dt;
	censor = (expire_flg eq "N");
	if hospital_expire_flg = "Y" then htime = dod - hospital_admit_dt;
	if hospital_expire_flg = "N" then htime = hospital_disch_dt - hospital_admit_dt;
	hcensor = (hospital_expire_flg eq "N");
run;

ods graphics on;

proc lifetest data=has_timevar(where=(first_drug1 ne "BOTH"));
	time time * censor(1);
	strata first_drug1;
run;

proc lifetest data=has_timevar(where=(first_drug1 ne "BOTH"));
	time htime * hcensor(1);
	strata first_drug1;
run;
