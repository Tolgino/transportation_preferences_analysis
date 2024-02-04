
libname c 'C:\Users\bbsstudent\Desktop';
proc import datafile='C:\Users\bbsstudent\Desktop\survey-new.xlsx' out = c.transport dbms =XLSX replace;
run;
proc contents data=c.transport;
run;
/*
proc princomp data=c.transport;
var Q1-Q10;
run;
proc princomp data=c.transport
out=c.coord;
var Q1-Q10;
run;
proc corr data=c.coord;
var prin1-prin10;
run;
data c.coord_1; set c.coord;
avg_i=.;
avg_i=mean(of Q1-Q10);
run;
proc corr data=c.coord_1;
var avg_i prin1;
run;
*/
data c.transport_adj; set c.transport;
avg_i=mean(of Q1-Q10);
min_i=min(of Q1-Q10);
max_i=max(of Q1-Q10);
array a Q1-Q10;
array b new_category1-new_category10;
do over b;
b=.;
if a>avg_i then b=(a-avg_i)/(max_i-avg_i);
if a<avg_i then b=(a-avg_i)/(avg_i-min_i);
if a=avg_i then b=0;
if a=. then b=0;
end;
label new_category1='transportation_options'; 
label new_category2='environmental_reasons';
label new_category3='sustainability';
label new_category4='active_transportation';
label new_category5='mobile_apps';
label new_category6='investment';
label new_category7='cost';
label new_category8='safety';
label new_category9='personal_vehicle';
label new_category10='parking';
run;

proc princomp data=c.transport_adj out=c.coord_adj;
var new_category1-new_category10;
run;

proc cluster data=c.coord_adj method=ward outtree=c.tree;
var prin1-prin4;*selected using eigenvalues structure analysis kaiser criteria eigenvalue>1.0;
id id;
run;
proc template ;
define statgraph dendrogram; 
begingraph;
	layout overlay;
		dendrogram nodeID=_name_ parentID=_parent_ clusterheight=_height_;
    endlayout;
  endgraph;
end; 
run;
proc sgrender data=c.tree template=dendrogram;
run;
proc tree data=c.tree ncl=5 out=c.cluster
noprint;
id id;
run;

proc sort data=c.coord_adj; by id; run;
proc sort data=c.cluster; by id; run;
data c.transport_1; merge c.coord_adj c.cluster;
by id;
run;
data c.transport_dummy; set c.transport_1;
cluster=6;
run;
data c.transport_append; set c.transport_1 c.transport_dummy;
run;

*analysis of cluster1;
proc ttest data=c.transport_append;
var new_category:;
class cluster;
where cluster=1 or cluster=6;
run;
*analysis of cluster2;
proc ttest data=c.transport_append;
var new_category:;
class cluster;
where cluster=2 or cluster=6;
run;

proc ttest data=c.transport_append;
var new_category:;
class cluster;
where cluster=3 or cluster=6;
run;

proc ttest data=c.transport_append;
var new_category:;
class cluster;
where cluster=4 or cluster=6;
run;

proc ttest data=c.transport_append;
var new_category:;
class cluster;
where cluster=5 or cluster=6;
run;

proc freq data=c.transport_1; *age 1;
table cluster*age / expected chisq;
run;
data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;


proc freq data=c.transport_spec;
table cluster_1 * age / expected chisq;
run;

 *age 2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * age / expected chisq;
run;

 *age 3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * age / expected chisq;
run;


 *age 4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * age / expected chisq;
run;

 *age 5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * age / expected chisq;
run;

proc freq data=c.transport_1; *sex1;
table cluster*sex / expected chisq;
run;
data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * sex / expected chisq;
run;

 *sex2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * sex / expected chisq;
run;

 *sex3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * sex / expected chisq;
run;


*sex4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * sex / expected chisq;
run;

*sex5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * sex / expected chisq;
run;


proc freq data=c.transport_1; *continent1;
table cluster*continent / expected chisq;
run;
data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * continent / expected chisq;
run;

 *continent2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * continent / expected chisq;
run;

 *continent3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * continent / expected chisq;
run;


 *continent4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * continent / expected chisq;
run;

 *continent5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * continent / expected chisq;
run;

proc freq data=c.transport_1; *work1;
table cluster*work / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * work / expected chisq;
run;

 *work2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * work / expected chisq;
run;

 *work3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * work / expected chisq;
run;


 *work4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * work / expected chisq;
run;

 *work5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * work / expected chisq;
run;


proc freq data=c.transport_1; *primary_transport1;
table cluster*primary_transportation / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * primary_transportation / expected chisq;
run;

*primarytransport2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * primary_transportation / expected chisq;
run;

 *primarytransport3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * primary_transportation / expected chisq;
run;


 *primarytransport4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * primary_transportation / expected chisq;
run;

 *primarytransport5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * primary_transportation / expected chisq;
run;

proc freq data=c.transport_1; *distance1;
table cluster*distance / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * distance / expected chisq;
run;

 *distance2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * distance / expected chisq;
run;

 *distance3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * distance / expected chisq;
run;


 *distance4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * distance / expected chisq;
run;

 *distance5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * distance / expected chisq;
run;

proc freq data=c.transport_1; *time1;
table cluster*time / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * time / expected chisq;
run;

 *time2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * time / expected chisq;
run;

 *time3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * time / expected chisq;
run;

 *time4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * time / expected chisq;
run;

 *time5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_4=1;
if cluster ne 5 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * time / expected chisq;
run;

proc freq data=c.transport_1; *vehicle1;
table cluster*vehicle / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * vehicle / expected chisq;
run;

 *vehicle2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * vehicle / expected chisq;
run;

 *vehicle3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * vehicle / expected chisq;
run;


 *vehicle4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * vehicle / expected chisq;
run;

 *vehicle5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * vehicle / expected chisq;
run;


proc freq data=c.transport_1; *preference1;
table cluster*preference / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * preference / expected chisq;
run;

 *preference2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * preference / expected chisq;
run;

 *preference3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * preference / expected chisq;
run;

 *preference4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * preference / expected chisq;
run;

 *preference5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * preference / expected chisq;
run;

proc freq data=c.transport_1; *improvement1;
table cluster*improvement / expected chisq;
run;
data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * improvement / expected chisq;
run;

 *improvement2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * improvement / expected chisq;
run;

 *improvement3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * improvement / expected chisq;
run;

 *improvement4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * improvement / expected chisq;
run;

*improvement5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * improvement / expected chisq;
run;

proc freq data=c.transport_1; *sharing1;
table cluster*sharing / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * sharing / expected chisq;
run;

 *sharing2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * sharing / expected chisq;
run;

*sharing3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * sharing / expected chisq;
run;

*sharing4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * sharing / expected chisq;
run;

*sharing5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * sharing / expected chisq;
run;

proc freq data=c.transport_1; *mode1;
table cluster*mode / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * mode / expected chisq;
run;

 *mode2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * mode / expected chisq;
run;

*mode3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * mode / expected chisq;
run;

*mode4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * mode / expected chisq;
run;

*mode5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * mode / expected chisq;
run;

proc freq data=c.transport_1; *environment1;
table cluster*environment / expected chisq;
run;

data c.transport_spec; set c.transport_1;
cluster_1=.;
if cluster=1 then cluster_1=1;
if cluster ne 1 then cluster_1=0;
run;

proc freq data=c.transport_spec;
table cluster_1 * environment / expected chisq;
run;

 *environment2;

data c.transport_spec; set c.transport_1;
cluster_2=.;
if cluster=2 then cluster_2=1;
if cluster ne 2 then cluster_2=0;
run;

proc freq data=c.transport_spec;
table cluster_2 * environment / expected chisq;
run;

*environment3;

data c.transport_spec; set c.transport_1;
cluster_3=.;
if cluster=3 then cluster_3=1;
if cluster ne 3 then cluster_3=0;
run;

proc freq data=c.transport_spec;
table cluster_3 * environment / expected chisq;
run;

*environment4;

data c.transport_spec; set c.transport_1;
cluster_4=.;
if cluster=4 then cluster_4=1;
if cluster ne 4 then cluster_4=0;
run;

proc freq data=c.transport_spec;
table cluster_4 * environment / expected chisq;
run;

*environment5;

data c.transport_spec; set c.transport_1;
cluster_5=.;
if cluster=5 then cluster_5=1;
if cluster ne 5 then cluster_5=0;
run;

proc freq data=c.transport_spec;
table cluster_5 * environment / expected chisq;
run;
