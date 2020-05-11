clear all
set more off
			
use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011v3", clear

*set survey mode
*svyset psu [pweight=per_weight], strata(strata) || hhid, strata(strata2)

*Differences in labor behavior between BF and other cadunico

********************************************************************************
****************************Independent Variable********************************
********************************************************************************

*********SUPPLY*********
*age
*race
*male
*educ
*skill approximated by wage real_wage_pct 

*********DEMAND*********
*state
*employee_firm_size_wk
*employeer_firm_size_wk
*urban

*****JOB MISSMATCHING***
*occ_wk2
*econ_act_wk2
*job_search_network
*mom_lives_in_hh
*hrs_wk_dom_aff_wk
*dom_aff_wk
*hh_nchild
*comm_time_wk
*born_uf and *uf_mun_born "uf or municipality where born otherwise"


********************************************************************************
********Differences in characteristics, employment and unemployment*************
********************************************************************************

*************Significantly difference between main characteristics**************

*% of pbf and other_caduni employed during wk of ref if they have working age
ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*% of pbf and other_caduni unemployed during wk of ref if they have working age
ttest unemployed_wk if (age>=18 & age<=64) & search_job_1m!=1, by(pbf_or_caduni) unequal level(95)

*If employed today, job duration
ttest job_duration_wk if (age>=18 & age<=64) & job_duration_wk<=180, by(pbf_or_caduni) unequal level(95)

*If employed but lost a job recently, job duration within 358 of previous job
ttest e_wk_job_duration_358 if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*If unemployed this past year, job duration of past year
ttest u_wk_358_job_duration_prev_365 if (age>=18 & age<=64) & u_wk_358_job_duration_prev_365<=180, by(pbf_or_caduni) unequal level(95)

*If employed today, what proportion lost job in past year
ttest e_wk_njobs_dismiss_358 if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*age
ttest age, by(pbf_or_caduni) unequal level(95)

*educ
ttest educ, by(pbf_or_caduni) unequal level(95)

*gender
ttest male, by(pbf_or_caduni) unequal level(95)

*urban
ttest urban, by(pbf_or_caduni) unequal level(95)

*experience
ttest exp, by(pbf_or_caduni) unequal level(95)

*Year at which they start working
ttest age_work, by(pbf_or_caduni) unequal level(95)

***Significantly difference between unemployement rate by diff. characteristics**

*Age_group
bysort age_group: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*educ_group
bysort educ_group: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*exp
bysort exp_group: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*gender
bysort male: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*race
bysort race: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*state
bysort state: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*urban
bysort urban: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*job_search_network
bysort job_search_network: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*hh_nchild
bysort hh_nchild_group: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*mom_lives_in_hh
bysort mom_lives_in_hh: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*dom_aff_wk
bysort dom_aff_wk: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

*hrs_wk_dom_aff_wk
bysort hrs_wk_dom_aff_wk: ttest unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1, by(pbf_or_caduni) unequal level(95)

****Significantly difference between employment rate by diff. characteristics***

*Age_group
bysort age_group: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*educ_group
bysort educ_group: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*exp_group
bysort exp_group: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*gender
bysort male: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*race
bysort race: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*state
bysort state: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*urban
bysort urban: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*job_search_network
bysort job_search_network: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*hh_nchild
bysort hh_nchild_group: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*mom_lives_in_hh
bysort mom_lives_in_hh: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*dom_aff_wk
bysort dom_aff_wk: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

*hrs_wk_dom_aff_wk
bysort hrs_wk_dom_aff_wk: ttest employed_wk if (age>=18 & age<=64), by(pbf_or_caduni) unequal level(95)

********************************************************************************
********************************Regressions*************************************
********************************************************************************

********************************************************************************
**********************************Stock*****************************************

********************************Unemployment************************************

*****************************BY PBF_OR_CADUNI***********************************

set more off 

forvalues i = 0/1 {
	local t : label origin `i'
	display "`t'"

*I SUPPLY 
dprobit unemployed_wk educ age age2 male race_dummy1 race_dummy3 race_dummy4 race_dummy5  if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1 & pbf_or_caduni==`i' [pweight=per_weight]
	
outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_unemployed_wk_pbf_or_caduni==`t'.tex", label title("Likelihood of being unemployed for pbf_or_caduni==`t'") ctitle("Supply I") replace 

*II SUPPLY but with educ_groups + exp
dprobit unemployed_wk educ_group_dummy2 educ_group_dummy3 educ_group_dummy4 educ_group_dummy5 exp exp2 male race_dummy1 race_dummy3 race_dummy4 race_dummy5 if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1 & pbf_or_caduni==`i' [pweight=per_weight]

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_unemployed_wk_pbf_or_caduni==`t'.tex", label title("Likelihood of being unemployed for pbf_or_caduni==`t'") ctitle("Supply II") append

*III SUPPLY but with age_groups 
dprobit unemployed_wk educ age_group_dummy3 age_group_dummy4 male race_dummy1 race_dummy3 race_dummy4 race_dummy5 if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1 & pbf_or_caduni==`i' [pweight=per_weight]

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_unemployed_wk_pbf_or_caduni==`t'.tex", label title("Likelihood of being unemployed for pbf_or_caduni==`t'") ctitle("Supply III") append

*IV DEMAND 
dprobit unemployed_wk urban state_group_dummy2 state_group_dummy4 state_group_dummy5 state_group_dummy6 if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1 & pbf_or_caduni==`i' [pweight=per_weight]

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_unemployed_wk_pbf_or_caduni==`t'.tex", label title("Likelihood of being unemployed for pbf_or_caduni==`t'") ctitle("Demand I") append

*V JOB MATCHING with rest
dprobit unemployed_wk occ_3581_group_dummy3 occ_3581_group_dummy4 occ_3581_group_dummy5 occ_3581_group_dummy6 job_search_network_dummy1 job_search_network_dummy3 job_search_network_dummy4 job_search_network_dummy5 job_search_network_dummy6 job_search_network_dummy7 job_search_network_dummy8 job_search_network_dummy9 hh_nchild mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1 & pbf_or_caduni==`i' [pweight=per_weight]

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_unemployed_wk_pbf_or_caduni==`t'.tex", label title("Likelihood of being unemployed for pbf_or_caduni==`t'") ctitle("Job matching I") append

*VI ALL 
dprobit unemployed_wk educ exp exp2 male race_dummy1 race_dummy3 race_dummy4 race_dummy5 urban state_group_dummy2 state_group_dummy4 state_group_dummy5 state_group_dummy6 occ_3581_group_dummy3 occ_3581_group_dummy4 occ_3581_group_dummy5 occ_3581_group_dummy6 job_search_network_dummy1 job_search_network_dummy3 job_search_network_dummy4 job_search_network_dummy5 job_search_network_dummy6 job_search_network_dummy7 job_search_network_dummy8 job_search_network_dummy9 hh_nchild mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & out_of_LF_wk!=1 & pbf_or_caduni==`i' [pweight=per_weight]

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_unemployed_wk_pbf_or_caduni==`t'.tex", label title("Likelihood of being unemployed for pbf_or_caduni==`t'") ctitle("All I") append

}

*********************************Turnover***************************************

********************************************************************************
***********************************Duration*************************************
********************************************************************************


**********************************Until week************************************ 
twoway kdensity job_duration_wk if job_duration_wk<=60 [aw=per_weight], by(pbf_or_caduni, title("PBF are obtaining more jobs recenty than CadUni")) 
graph save "/Users/rodrigoquintana/Dropbox/PED 250Y - SYPA/PNAD/Results/Graphs/job_duration_wk_2011.gph", replace 

*****************************BY PBF_OR_CADUNI***********************************

set more off 

forvalues i = 0/1 {
	local t : label origin `i'
	display "`t'"

*I SUPPLY 
reg job_duration_wk educ age age2 male race_dummy1 race_dummy3 race_dummy4 race_dummy5 if (age>=18 & age<=64) & job_duration_wk<=180 & pbf_or_caduni==`i' [pweight=per_weight], r 
	
outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_job_duration_wk_pbf_or_caduni==`t'.tex", label title("Job duration if employed for pbf_or_caduni==`t'") ctitle("Supply I") replace 

*II SUPPLY but with educ_groups + exp
reg job_duration_wk educ_group_dummy2 educ_group_dummy3 educ_group_dummy4 educ_group_dummy5 exp exp2 male race_dummy1 race_dummy3 race_dummy4 race_dummy5 if (age>=18 & age<=64) & job_duration_wk<=180 & pbf_or_caduni==`i' [pweight=per_weight], r 

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_job_duration_wk_pbf_or_caduni==`t'.tex", label title("Job duration if employed for pbf_or_caduni==`t'") ctitle("Supply II") append

*III SUPPLY but with age_groups*male  
reg job_duration_wk educ age_group_dummy3 age_group_dummy4 male race_dummy1 race_dummy3 race_dummy4 race_dummy5 if (age>=18 & age<=64) & job_duration_wk<=180 & pbf_or_caduni==`i' [pweight=per_weight], r 

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_job_duration_wk_pbf_or_caduni==`t'.tex", label title("Job duration if employed for pbf_or_caduni==`t'") ctitle("Supply III") append

*IV DEMAND 
reg job_duration_wk urban state_group_dummy2 state_group_dummy4 state_group_dummy5 state_group_dummy6 if (age>=18 & age<=64) & job_duration_wk<=180 & pbf_or_caduni==`i' [pweight=per_weight], r  

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_job_duration_wk_pbf_or_caduni==`t'.tex", label title("Job duration if employed for pbf_or_caduni==`t'") ctitle("Demand I") append

*V JOB MATCHING 

reg job_duration_wk occ_3581_group_dummy3 occ_3581_group_dummy4 occ_3581_group_dummy5 occ_3581_group_dummy6 job_search_network_dummy1 job_search_network_dummy3 job_search_network_dummy4 job_search_network_dummy5 job_search_network_dummy6 job_search_network_dummy7 job_search_network_dummy8 job_search_network_dummy9 comm_time_wk_dummy2 comm_time_wk_dummy3 comm_time_wk_dummy4 hh_nchild mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=180 & pbf_or_caduni==`i' [pweight=per_weight], r  

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_job_duration_wk_pbf_or_caduni==`t'.tex", label title("Job duration if employed for pbf_or_caduni==`t'") ctitle("Job matching I") append

*VI ALL 
reg job_duration_wk educ exp exp2 male race_dummy1 race_dummy3 race_dummy4 race_dummy5 urban state_group_dummy2 state_group_dummy4 state_group_dummy5 state_group_dummy6 occ_3581_group_dummy3 occ_3581_group_dummy4 occ_3581_group_dummy5 occ_3581_group_dummy6 job_search_network_dummy1 job_search_network_dummy3 job_search_network_dummy4 job_search_network_dummy5 job_search_network_dummy6 job_search_network_dummy7 job_search_network_dummy8 job_search_network_dummy9 comm_time_wk_dummy2 comm_time_wk_dummy3 comm_time_wk_dummy4 hh_nchild mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=180 & pbf_or_caduni==`i' [pweight=per_weight], r 

outreg2 using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Results/Tables/reg_job_duration_wk_pbf_or_caduni==`t'.tex", label title("Job duration if employed for pbf_or_caduni==`t'") ctitle("All I") append
	
}

/********************************Employment**************************************

********A. PBF*************

*I SUPPLY 
reg employed_wk educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg employed_wk educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg employed_wk urban state if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg employed_wk educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg employed_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg employed_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg employed_wk educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg employed_wk educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg employed_wk educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg employed_wk educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg employed_wk urban state if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg employed_wk educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg employed_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg employed_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg employed_wk educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg employed_wk educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********C. Others*************

*I SUPPLY 
reg employed_wk educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg employed_wk educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg employed_wk urban state if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg employed_wk educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg employed_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg employed_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg employed_wk educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg employed_wk educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge */


/********************************************************************************
**********************************Flows*****************************************

*******************************Employed*****************************************

tab pbf_or_caduni employed_wk if (age>=18 & age<=64) [fw=per_weight], r nofreq

tab pbf_or_caduni u_wk_employed_358 if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) [fw=per_weight], r nofreq

********A. PBF*************

*I SUPPLY 
reg u_wk_employed_358 educ age age2 male race if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_employed_358 educ exp male race if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_employed_358 urban state if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_employed_358 educ age age2 state if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_employed_358  educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_employed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_employed_358 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_employed_358 educ exp male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg u_wk_employed_358 educ age age2 male race if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_employed_358 educ exp male race if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_employed_358 urban state if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_employed_358 age age2 state if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_employed_358 educ age age2 state job_search_network hh_nchild mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_employed_358 educ age age2 state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_employed_358 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_employed_358 educ exp male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********C. Others*************

*I SUPPLY 
reg u_wk_employed_358 educ age age2 male race if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_employed_358 educ exp male race if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_employed_358 urban state if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_employed_358 educ age age2 state if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_employed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_employed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_employed_358 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_employed_358 educ exp male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & (unemployed_wk==1 & out_of_LF_wk!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 





 
tab pbf_or_caduni u_365_employed_prev if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) [fw=per_weight], r nofreq 



********A. PBF*************

*I SUPPLY 
reg u_365_employed_prev educ age age2 male race if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*III DEMAND 
reg u_365_employed_prev urban state if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_365_employed_prev educ age age2 state if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_365_employed_prev  educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_365_employed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_365_employed_prev educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_365_employed_prev educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg u_365_employed_prev educ age age2 male race if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*III DEMAND 
reg u_365_employed_prev urban state if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_365_employed_prev educ age age2 state if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_365_employed_prev  educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_365_employed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_365_employed_prev educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_365_employed_prev educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge

********C. Others*************

*I SUPPLY 
reg u_365_employed_prev educ age age2 male race if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*III DEMAND 
reg u_365_employed_prev urban state if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_365_employed_prev educ age age2 state if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_365_employed_prev  educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_365_employed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_365_employed_prev educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_365_employed_prev educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & (u_wk_unemployed_358==1 & u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge

*******************************Unemployed***************************************

tab pbf_or_caduni unemployed_wk if (age>=18 & age<=64) & (occupied_wk!=1) & (search_job_1m==1) & (out_of_LF_wk!=1) [fw=per_weight], r nofreq





tab pbf_or_caduni u_wk_unemployed_358 if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) [fw=per_weight], r nofreq 


********A. PBF*************

*I SUPPLY 
reg u_wk_unemployed_358 educ age age2 male race if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels title(Unemployment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_unemployed_358 educ exp male race if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_unemployed_358 urban state if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_unemployed_358 educ age age2 state if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_unemployed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_unemployed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_unemployed_358 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_unemployed_358 educ exp male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg u_wk_unemployed_358 educ age age2 male race if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels title(Unemployment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_unemployed_358 educ exp male race if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_unemployed_358 urban state if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_unemployed_358 educ age age2 state if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_unemployed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_unemployed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_unemployed_358 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_unemployed_358 educ exp male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 


********C. Others*************

*I SUPPLY 
reg u_wk_unemployed_358 educ age age2 male race if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels title(Unemployment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_unemployed_358 educ exp male race if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_unemployed_358 urban state if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_unemployed_358 educ age age2 state if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_unemployed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_unemployed_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_unemployed_358 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_unemployed_358 educ exp male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (unemployed_wk==1) & (age>=18 & age<=64) & (u_wk_occupied_358!=1) & (search_job_1m==1) & (u_wk_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 




tab pbf_or_caduni u_365_unemployed_prev if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) [fw=per_weight], r nofreq


********A. PBF*************

*I SUPPLY 
reg u_365_unemployed_prev educ age age2 male race if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels title(Unemployment) ctitles("Variables", "Supply I") replace

*III DEMAND 
reg u_365_unemployed_prev urban state if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_365_unemployed_prev educ age age2 state if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_365_unemployed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_365_unemployed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_365_unemployed_prev educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_365_unemployed_prev educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg u_365_unemployed_prev educ age age2 male race if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels title(Unemployment) ctitles("Variables", "Supply I") replace

*III DEMAND 
reg u_365_unemployed_prev urban state if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_365_unemployed_prev educ age age2 state if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_365_unemployed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_365_unemployed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_365_unemployed_prev educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_365_unemployed_prev educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge  


********C. Others*************

*I SUPPLY 
reg u_365_unemployed_prev educ age age2 male race if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels title(Unemployment) ctitles("Variables", "Supply I") replace

*III DEMAND 
reg u_365_unemployed_prev urban state if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_365_unemployed_prev educ age age2 state if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_365_unemployed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_365_unemployed_prev educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_365_unemployed_prev educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_365_unemployed_prev educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (u_wk_unemployed_358==1) & (age>=18 & age<=64) & (u_365_occupied_prev!=1) & (search_job_1m==1) & (u_365_out_of_LF_358!=1) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge */







*********************************Turnover***************************************

********************************************************************************
***********************************Duration*************************************
********************************************************************************

**********************************Until week************************************ 
twoway kdensity job_duration_wk if job_duration_wk<=60 [aw=per_weight], by(pbf_or_caduni, title("PBF are obtaining more jobs recenty than CadUni")) 
graph save "/Users/rodrigoquintana/Dropbox/PED 250Y - SYPA/PNAD/Results/Graphs/job_duration_wk_2011.gph", replace 

********A. PBF*************

*I SUPPLY 
reg job_duration_wk educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg job_duration_wk educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg job_duration_wk urban state if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg job_duration_wk educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg job_duration_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg job_duration_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg job_duration_wk educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg job_duration_wk educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg job_duration_wk educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg job_duration_wk educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg job_duration_wk urban state if (age>=18 & age<=64) & pbf_or_caduni==0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg job_duration_wk educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg job_duration_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni=0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg job_duration_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg job_duration_wk educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg job_duration_wk educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********C. Others*************

*I SUPPLY 
reg job_duration_wk educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg job_duration_wk educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg job_duration_wk urban state if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg job_duration_wk educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg job_duration_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg job_duration_wk educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg job_duration_wk educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg job_duration_wk educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. & job_duration_wk<=60 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 



*For those who are employed right now but lost a job 358 days before, how long did that job lasted? 
*We shld observe worse for PBF
twoway kdensity e_wk_job_duration_358 if (age>=18 & age<=64) [aw=per_weight], by(pbf_or_caduni, title("Most pbf ben. lost a job more recently than caduni") ) yla(0(0.01)0.13) 
graph save "/Users/rodrigoquintana/Dropbox/PED 250Y - SYPA/PNAD/Results/Graphs/e_wk_job_duration_358.gph", replace 

********A. PBF*************

*I SUPPLY 
reg e_wk_job_duration_358 educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg e_wk_job_duration_358 educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg e_wk_job_duration_358 urban state if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg e_wk_job_duration_358 educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg e_wk_job_duration_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg e_wk_job_duration_358 educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg e_wk_job_duration_358 educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg e_wk_job_duration_358 educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg e_wk_job_duration_358 educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg e_wk_job_duration_358 urban state if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg e_wk_job_duration_358 educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg e_wk_job_duration_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni=0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg e_wk_job_duration_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg e_wk_job_duration_358 educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg e_wk_job_duration_358 educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********C. Others*************

*I SUPPLY 
reg e_wk_job_duration_358 educ age age2 male race if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg e_wk_job_duration_358 educ exp male race if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg e_wk_job_duration_358 urban state if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg e_wk_job_duration_358 educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg e_wk_job_duration_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg e_wk_job_duration_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg e_wk_job_duration_358 educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg e_wk_job_duration_358 educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 


*For those who only worked prior to 365 days, how long ago did you leave that job?
twoway kdensity u_wk_358_job_duration_prev_365 if u_wk_358_job_duration_prev_365<=300 [aw=per_weight], by(pbf_or_caduni, title("Other cadastro unico registrants obtained a job less recently")) yla(0 (0.004) 0.012) 
graph save "/Users/rodrigoquintana/Dropbox/PED 250Y - SYPA/PNAD/Results/Graphs/u_wk_358_job_duration_prev_365.gph", replace

********A. PBF*************

*I SUPPLY 
reg u_wk_358_job_duration_prev_365 educ age age2 male race if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==1 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*III DEMAND 
reg u_wk_358_job_duration_prev_365 urban state if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==1 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_358_job_duration_prev_365 educ age age2 state if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==1 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_358_job_duration_prev_365 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==1 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_358_job_duration_prev_365 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==1 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_358_job_duration_prev_365 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==1 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_358_job_duration_prev_365 educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==1 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg u_wk_358_job_duration_prev_365 educ age age2 male race if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_358_job_duration_prev_365 educ male race if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_358_job_duration_prev_365 urban state if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_358_job_duration_prev_365 educ age age2 state if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_358_job_duration_prev_365 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_358_job_duration_prev_365 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_358_job_duration_prev_365 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_358_job_duration_prev_365 educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==0 & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********C. Others*************

*I SUPPLY 
reg u_wk_358_job_duration_prev_365 educ age age2 male race if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg u_wk_358_job_duration_prev_365 educ male race if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg u_wk_358_job_duration_prev_365 urban state if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg u_wk_358_job_duration_prev_365 educ age age2 state if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg u_wk_358_job_duration_prev_365 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r 

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg u_wk_358_job_duration_prev_365 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg u_wk_358_job_duration_prev_365 educ age age2 male race urban state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg u_wk_358_job_duration_prev_365 educ male race urban state job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=19 & age<=65) & u_wk_out_of_LF_358!=1 & pbf_or_caduni==. & u_wk_358_job_duration_prev_365<=300 [pweight=per_weight], r  

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 


*************************
******High turnover******
*************************

*Of those employed today, what proportion lost a job in less than past 12 months (i.e. how go re-integrated faster)
*We shld observe better for other_caduni; worse for pbf
tab pbf_or_caduni e_wk_jobs_dismiss_358 if job_duration_wk<=12 &  [fw=per_weight], r nofreq


********A. PBF*************

*I SUPPLY 
reg e_wk_jobs_dismiss_358 educ age age2 male race if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg e_wk_jobs_dismiss_358 educ exp male race if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg e_wk_jobs_dismiss_358 urban state if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg e_wk_jobs_dismiss_358 educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg e_wk_jobs_dismiss_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg e_wk_jobs_dismiss_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg e_wk_jobs_dismiss_358 educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg e_wk_jobs_dismiss_358 educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==1 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********B. CadUni*************

*I SUPPLY 
reg e_wk_jobs_dismiss_358 educ age age2 male race if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg e_wk_jobs_dismiss_358 educ exp male race if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg e_wk_jobs_dismiss_358 urban state if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg e_wk_jobs_dismiss_358 educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg e_wk_jobs_dismiss_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg e_wk_jobs_dismiss_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg e_wk_jobs_dismiss_358 educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg e_wk_jobs_dismiss_358 educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==0 [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 

********C. Others*************

*I SUPPLY 
reg e_wk_jobs_dismiss_358 educ age age2 male race if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels title(Employment) ctitles("Variables", "Supply I") replace

*II SUPPLY but with exp 
reg e_wk_jobs_dismiss_358 educ exp male race if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Supply II") merge

*III DEMAND 
reg e_wk_jobs_dismiss_358 urban state if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Demand I") merge 

*IV JOB MATCHING
xi: reg e_wk_jobs_dismiss_358 educ age age2 state i.occ_wk1 if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching I") merge 

*V JOB MATCHING

reg e_wk_jobs_dismiss_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching II") merge 

*VI JOB MATCHING 
reg e_wk_jobs_dismiss_358 educ age age2 state job_search_network hh_nchild  mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "Job Matching III") merge 

*VII ALL 
xi: reg e_wk_jobs_dismiss_358 educ age age2 male race urban state i.occ_wk1 job_search_network hh_nchild  mom_lives_in_hh dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All I") merge 

*VIII ALL
xi: reg e_wk_jobs_dismiss_358 educ exp male race urban state i.occ_wk1 job_search_network hh_nchild mom_lives_in_hh hrs_wk_dom_aff_wk if (age>=18 & age<=64) & job_duration_wk<=12 & pbf_or_caduni==. [pweight=per_weight], r

outreg using test.doc, varlabels ctitles("Variables", "All II") merge 


*SECONDARY*
tab pbf_or_caduni high_turnover_wk if job_duration_wk<=12, r nofreq
