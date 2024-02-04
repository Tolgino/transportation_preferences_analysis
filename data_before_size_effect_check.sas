libname c 'C:\Users\bbsstudent\Desktop';
proc import datafile='C:\Users\bbsstudent\Desktop\survey-before.xlsx' out = c.transport dbms =XLSX replace;
run;
proc contents data=c.transport;
run;

proc princomp data=c.transport;
var Q1-Q15;
run;

proc princomp data=c.transport
out=c.coord;
var Q1-Q15;
run;
proc corr data=c.coord;
var prin1-prin15;
run;
data c.coord_1; set c.coord;
avg_i=.;
avg_i=mean(of Q1-Q15);
run;
proc corr data=c.coord_1;
var avg_i prin1;
run;
