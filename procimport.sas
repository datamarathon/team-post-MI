PROC IMPORT OUT= WORK.rawdata 
            DATAFILE= "C:\Users\ch151634\Dropbox\out.csv" 
            DBMS=DLM REPLACE;
     DELIMITER='3B'x; 
     GETNAMES=YES;
     DATAROW=2; 
RUN;
