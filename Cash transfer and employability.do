********************************************************************************
*****************Bolsa Familia: Building dataset for analysis ******************
********************************************************************************

/*
Build and analyze dataset from Brazilian household survey in 3 steps:
1. Clean and select variables from observations at individual and household level
2. Identify Bolsa Familia recipients from household survey
3. Ttests, dprobits, IVs and regressions 
*/

********************************************************************************
*1. Clean and select variables from observations at individual and household level

clear
clear matrix
set mem 400m
set more off

*Convert text into .dta format
cd "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata/PNAD_2011/data"

* Individuals
infile using "dict_2011_PES.txt", using ("PES2011.txt")
sort V0102 V0103
save "PES2011.dta", replace
count
duplicates report

* Households
clear
infile using "dict_2011_DOM.txt", using ("DOM2011.txt")
sort V0102 V0103
save "DOM2011.dta", replace
count
duplicates report

*merge both HH and Indiv
merge V0102 V0103 using "PES2011.dta"
ta   _merge
drop if _merge==1
drop _merge

*create lowercase v.
foreach var of varlist _all	{
				local x = lower("`var'")
				destring `var', replace force
				rename `var' `x'
				}

save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/bra_pnad11_raw.dta", replace

******************************************************************
clear all
set more off
******************************************************************
* Households
		* Identification and clean up 
			use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/bra_pnad11_raw.dta", clear
			gen double hhid=10000*v0102+v0103
			format hhid %16.0f
			sum v4742
			drop if v4742==r(max)|v0401>5

			egen indiv_id = concat(hhid v0401), format (%16.0f)
			destring indiv_id, replace
			format indiv_id %16.0f
			
			bysort indiv_id: gen id = _n
			egen indiv_idp = concat(indiv_id id), format (%16.0f)
			destring indiv_idp, replace
			format indiv_idp %16.0f
			
		* Variables for cluster
			gen telephone=cond(v2020==2,1,0,.)
			gen cellphone=cond(v0220==2,1,0,.)
			gen tvcolors=cond(v0226==2,1,0,.)
			gen computer=cond(v0231==1,1,0,.)
			gen washer=cond(v0230==2,1,0,.)
			gen wall=cond(v0203==1|v0203==2,1,0,.)
			gen roof=cond(v0204>=1&v0204<=3,1,0,.)
			gen toiletexc=cond(v0216==2,1,0,.)
			gen sewage=cond(v0217>=1&v0217<=3,1,0,.)
			gen garbage=cond(v0218==1|v0218==2,1,0,.)
			gen car=cond(inlist(v2032,2,4,6),1,0,.)
			gen urban=cond(v4105>=1&v4105<=3,1,0,.)
			gen areacens=v4107
			gen oven=cond(v0221==1|v0222==2,1,0,.)
			gen eletr=cond(v0219==1,1,0,.)
			gen double year=v0101 
			label var year "year of survey"
			
			keep year uf hhid indiv_id indiv_idp telephone-eletr
			sort year uf hhid indiv_id indiv_idp
			
		* Clean up and save (count = 358,919)
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/dom2011.dta", replace
******************************************************************

******************************************************************
* Individuals
		use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/bra_pnad11_raw.dta", clear
		
		* Identification and clean up
			gen double year=v0101 
			label var year "year of survey"
			
			gen double hhid=10000*v0102+v0103
			format hhid %16.0f
			sort hhid
			
			egen indiv_id = concat(hhid v0401), format (%16.0f)
			destring indiv_id, replace
			format indiv_id %16.0f
			
			bysort indiv_id: gen id = _n
			egen indiv_idp = concat(indiv_id id), format (%16.0f)
			destring indiv_idp, replace
			format indiv_idp %16.0f
			
			sum v4742
			drop if v4742==r(max)|v0401>5
			
			rename uf state
			label define state_label 11 "Rondnia" 12 "Acre" 13 "Amazonas" 14	"Roraima" /// 
					              15 "Para" 16	"Amapa" 17 "Tocantins" 21 "Maranho" ///
					              22 "Piau" 23	"Cear" 24	"Rio Grande do Norte" ///
					              25 "Paraba" 26 "Pernambuco" 27 "Alagoas" 28	"Sergipe" ///
					              29 "Bahia" 31	"Minas Gerais" 32 "Esprito Santo" ///
					              33 "Rio de Janeiro" 35 "Sao Paulo" 41	"Parana" ///
					              42 "Santa Catarina" 43 "Rio Grande do Sul" ///
					              50 "Mato Grosso do Sul" 51 "Mato Grosso" 52 "Goias" ///
					              53 "Distrito Federal"
			label value state state_label
			
			gen state_group if state=0
			replace state_group = 1 if state>10 & state<=19 
			replace state_group = 2 if state>20 & state<=29 
			replace state_group = 3 if state>30 & state<=39
			replace state_group = 4 if state>40 & state<=49 
			replace state_group = 5 if state>50 & state<=59 
			label define state_group_label 1 "North" 2 "Northeast" 3 "Southeast" 4 "South" 5 "Center-West" 
			label values state_group state_group_label
	
******************************************************************
			
			*count 20,179

			gen double per_weight=v4729
			gen double hh_weight=cond(v0401==1,v4729,0,.)
			gen double psu=v4618
			gen double strata=v4602
			label var strata "strata of municipality"
			gen double strata2=v4617
			label var strata2 "strata of municipality 2"
			gen double prob_mun=v4605 
			label var prob_mun "probability of municipality"
		
		* Household income (for PBF need to change benefit top)
			local vars v4719 v1252 v1255 v1258 v1261 v1264 v1267 v1270 v1273
			foreach var in `vars' { 
				replace `var'=0 if `var'==.
				egen x`var'=sum(`var'), by(hhid)
				replace x`var'=0 if v0401~=1
			}
			gen double incomepbf=cond(xv1273<=306,xv1273,0,.)
			replace xv1273=xv1273-incomepbf
			gen double incomeliq=xv4719+xv1252+xv1255+xv1258+xv1261+xv1264+xv1267+xv1270+xv1273
			gen double pbfpnad=cond(incomepbf>0,1,0,.)
		
		* Demographics 
			gen double pop=v4609 
			label var pop "population estimation"
			egen hh_size=count(state), by(hhid)
			label var hh_size "hh size"
			
			g double age=v8005 
			label var age "age of hh_member"
			
			*Age groups
			gen age_group if age=0
			replace age_group = 1 if age>18 & age<=29
			replace age_group = 2 if age>30 & age<=49 
			replace age_group = 3 if age>50 & age<=64
			label define age_group_label 1 "Age 18 - 29" 2 "Age 30 - 49" 3 "Age 50 - 64" 
			label values age_group age_group_label
			
			gen child06=(v8005<=6)
			gen child715=(v8005>=7&v8005<=15)
			gen child=cond(v8005<=15,1,0,.)
			gen adol=cond(v8005>=16&v8005<=17&v0602==2,1,0,.)
			gen adult=cond(v8005>=18|(v8005>=16&v0602~=2),1,0,.)
			
			gen double male=cond(v0302==2,1,0,.)
			label var male "dummy male"
			g double race=v0404
			label var race "race of hh_member"
			label define race_label 2 "white" 4 "black" 6 "asian descendant" ///
									8 "mulatto" 0 "indigenous"
			label value race race_label
			
			*heaf of hh
			gen hh_head_age=cond(v0401==1,v8005,0,.)
			gen hh_head_male=cond(v0401==1&v0302==2,1,0,.)
			gen hh_head_race=cond(v0401==1,v0404,.)
			label define hh_head_race_label 2 "white" 4 "black" 6 "asian descendant" ///
									8 "mulatto" 0 "indigenous"
			label value hh_head_race hh_head_race_label
			
		* Education 
			gen literate=cond(v0601==1,1,0,.)
			label var literate "knows how to read and write"
			gen educ=cond(v4803!=.,v4803,0)
			label var educ "years of schooling"
			
			*Schooling groups
			gen educ_group if educ=0
			replace educ_group =1 if educ>1 & educ<=5
			replace educ_group =2 if educ>6 & educ<=9
			replace educ_group =3 if educ>10 & educ<=12
			replace educ_group =4 if educ>13 & educ<=17
			label define educ_group_label 1 "primary" 2 "secondary" 3 "high school" 4 "college and post-grad"  
			label values educ_group educ_group_label
			
			gen temp=cond(v0301==1,educ,.)
			egen s_hh_head=max(temp), by(hhid)
			label var s_hh_head "highest level of schooling attained by hh_head"
						
			gen school_freq=cond(v0602==2,1,0,.)
			label var school "attends school frequently"
			gen school_past=cond(v0606==2,1,0,.)
			label var school_past "attended school before"
		
			gen wk_n_study=cond(v9001==1|v9002==2|v9003==1|v9004==2&v0602==2,1,0,.)
			label var wk_n_study "currently work and study"
			gen curr_school=v6003 
			label var curr_school "current level of schooling"
			
			* Labor
		*type of profiles
			*1. occ_wk=1
			*2. occ_wk=0
				*2.1 occ_wk=0; occ_358=1
			*3. occ_wk=1; occ_358=1
			*4. occ_wk=0; occ_358=0; occ_365=1
		
			********************************************************************
			**************************Week of ref*******************************
			********************************************************************
			
			g employed_wk=cond(v9001==1|v9002==2,1,0,.)
			label var employed_wk "employed during wk of ref"
			
			g occupied_wk=cond(v9003==1|v9004==2,1,0,.)
			label var occupied_wk "occupied wk of ref"
			
			g search_job_1m=cond(v9116==2,1,0,.) 
			label var search_job_1m "searching for jobs 1m before wk of ref"
			
			g out_of_LF_wk=cond(employed_wk!=1 & occupied_wk!=1 & search_job_1m!=1,1,0,.)
			label var out_of_LF_wk "out of the labor force during wk of ref"
			
			*wage
			g employee_montlhy_wage_wk=cond(v9532!=.,v9532,v9535) 
			label var employee_montlhy_wage_wk "monthly wage of employee during wk of ref" 
			
			g hrs_week_work_wk=v9058
			label var hrs_week_work_wk "hours worked per week during wk of ref"
			g hrs_month_work_wk=hrs_week_work_wk*4
			label var hrs_month_work_wk "hours worked per month during wk of ref"
			g hourly_wage_wk=employee_montlhy_wage_wk/hrs_month_work_wk 
			label var hourly_wage_wk "hourky wage during wk of ref"
			
			*Real wages (using October 2003 INPC Brazil as base year (look at simulacao_pbf.xlx in the literature)
			gen real_hourly_wage_wk = hourly_wage_wk/1.50180	
			sort real_hourly_wage_wk
			pctile real_hourly_wage_wk_pct=real_hourly_wage_wk if real_hourly_wage_wk!=. [aw=per_weight], nq(147489) genp(real_wage_pct)
			
			*Skill quartiles
			gen skill_quartile if real_wage_pct = 0
			replace skill_quartile = 1 if real_wage_pct>0 & real_wage_pct<=25
			replace skill_quartile = 2 if real_wage_pct>25 & real_wage_pct<=50
			replace skill_quartile = 3 if real_wage_pct>50 & real_wage_pct<=70
			replace skill_quartile = 4 if real_wage_pct>75 & real_wage_pct<=100
			label define skill_quartile_label 1 "1st quartile" 2 "2nd quartile" 3 "3rd quartile" 4 "4th quartile"  
			label values skill_quartile skill_quartile_label 
			
			g unemployed_wk=cond((employed_wk!=1 & occupied_wk!=1)|(employed_wk==1 & hrs_week_work_wk==1) & age>=18 & age<=64 & search_job_1m==1,1,0,.)
			label var unemployed_wk "unemployed wk of ref"
			
	
			*1. occ_wk=1
			
			
			/*g njobs_wk=v9005 
			label var njobs_wk "if employed, how many jobs during wk of ref"
			label define njobs_wk_label 1 "one" 2 "two" 3 "three or more" 		
			label values njobs_wk njobs_wk_label*/
			
			g part_time_wk=cond(v9012==2,1,0,.)
			label var part_time_wk "part time during wk of ref"
			
			g occ_wk=v9906  
			label var occ_wk "if employed, occupation during wk of ref"
			
			gen occ_wk4 = string(occ_wk,"%04.0f")
			gen occ_wk2 = substr(occ_wk4,1,2)
			gen occ_wk1 = substr(occ_wk4,1,1)
			destring occ_wk4 occ_wk2 occ_wk1, replace
			
			label define occ_wk1_label 1 "public service" 2 "arts and science" ///
									   3 "medium-level technician" 4 "administrative service" ///
									   5 "trade in stores" 6	"agriculture, forestry, hunting, fishing" ///
									   7 "production of industrial goods, service" 8 "production of industrial goods, service" ///
									   9 "repair and maintenance" 0	"public security"
			label value occ_wk1 occ_wk1_label 
			
			
			gen occ_wk1_group if occ_wk1=0
			replace occ_wk1_group = 1 if occ_wk1==6 | occ_wk1==9
			replace occ_wk1_group = 2 if occ_wk1==7 | occ_wk1==8 & occ_wk1==0
			replace occ_wk1_group = 3 if occ_wk1==5 | occ_wk1==2 
			replace occ_wk1_group = 4 if occ_wk1==3 | occ_wk1==4 
			replace occ_wk1_group = 5 if occ_wk1==1 
			label define occ_wk1_group_label 1 "other blue collar" 2 "skill-intensive blue collar" ///
											 3 "other white collar" 4 "technical and supervisory" ////
											 5 "Professional or Managerial Occupation"
		    label values occ_wk1_group occ_wk1_group_label
			
			label define occ_wk2_label 11 "public sector" ///
									   12 "corporate and organization official" ///
									   13 "manager" 20	"scientific professional" ///
									   21 "physical engineer" ///
									   22 "biologist/health professional" ///
									   23 "education official" 24 "lawyer" ///
									   25 "NGOs" 26 "communicator, artist, religious worker" ///
									   30 "polyvalent technician" 31 "chemical engineer" ///
									   32 "biochemical/health professional" 33 "high school professor" ///
									   34 "transport service" 35 "administrative service" 37 "culture and sports" ///
									   39 "other medium-level technician"  41 "bookkeeper" ///
									   42 "public service" 51 "service worker" ///
									   52 "trade service" 61	"agriculture" 62 "agriculture" ///
									   63 "forestry, hunting, fishing" 64 "agricultural/forestry machinery" ///
									   71 "extractive/constrution industry" 72 "metals, composites" ///
									   73 "electronics" 74	"appliance and instrument assambler" ///
									   75 "jewelery, glassware, ceramics" 76 "fabrics, visual arts" ///
									   77 "wood, furniture" 78	"cross-cutting functions" ///
									   81 "process industries" 82 "steel and construction materials" ///
									   83 "wood pulp, paper" 84	"food, beverages, tabacco" ///
									   86 "electricity, water, utilities" 87 "other industries" ///
									   91 "mechanic shop" 95 "housing/building maintenance" ///
									   99 "storage, maintenance, repair" 01	"aviation military" ///
									   02 "army military" 03 "naval military" 04	"police" ///
									   05 "fire fighters"
			label value occ_wk2 occ_wk2_label
			
			g econ_act_wk=v9907  
			label var econ_act_wk "if employed, economic activity during wk of ref"
			
			gen econ_act_wk5 = string(econ_act_wk, "%05.0f") 
			gen econ_act_wk2 = substr(econ_act_wk5,1,2)
			gen econ_act_wk1 = substr(econ_act_wk5,1,1)
			destring econ_act_wk5 econ_act_wk2 econ_act_wk1, replace
			
			label define econ_act_wk2_label 1 "agriculture, forestry, hunting, fishing" 2 "agriculture, forestry, hunting, fishing" 3 "agriculture, forestry, hunting, fishing" ///
			5 "extractive industry" 6 "extractive industry" 7 "extractive industry" 8  "extractive industry" 9 "extractive industry" 10 "processing industry" 11 "processing industry" 12 "processing industry" ///
			13 "processing industry" 14 "processing industry" 15 "processing industry" 16 "processing industry" 17 "processing industry" 18 "processing industry" ///
			19 "processing industry" 20 "processing industry" 21 "processing industry" 22 "processing industry" 23 "processing industry" 24 "processing industry" ///
			25 "processing industry" 26 "processing industry" 27 "processing industry" 28 "processing industry" 29 "processing industry" 30 "processing industry" ///
			31 "processing industry" 32 "processing industry" 33 "processing industry" 34 "processing industry" ///
			35 "electricity, gas" 36 "water, sewage" 37 "water, sewage" 38 "water, sewage" 39 "water, sewage" ///
			41 "construction" 42 "construction" 43 "construction" 45 "trade, repair" 46 "trade, repair" 47 "trade, repair" ///
			49 "transport, storage" 50 "transport, storage" 51 "transport, storage" 52 "transport, storage" 53 "transport, storage" 55 "housing, food" 56 "housing, food" ///
			58 "information, communication" 59 "information, communication" 60 "information, communication" 61 "information, communication" 62 "information, communication" 63 "information, communication" ///
			64 "finance, insurance" 65 "finance, insurance" 66 "finance, insurance" 68 "real estate" 69 "scientist, technician" 70 "scientist, technician" 71 "scientist, technician" ///
			72 "scientist, technician" 73 "scientist, technician" 74 "scientist, technician" 75	"scientist, technician" ///
			77 "administrative service" 78 "administrative service" 79 "administrative service" 80 "administrative service" ///
			81 "administrative service" 82 "administrative service" 84 "public, social, defense" ///
			85 "education" 86 "health, social services" 87 "health, social services" 88 "Shealth, social services" 90 "arts, culture, sports" 91 "arts, culture, sports" 92 "arts, culture, sports" 93 "arts, culture, sports" ///
			94 "other services" 95 "other services" 96 "other services" 97 "other services" 99 "international organizations" 67 "others" 40 "others"
			label value econ_act_wk2 econ_act_wk2_label
			
			gen econ_act_wk2_group if econ_act_wk2=0
			replace econ_act_wk2_group = 1 if econ_act_wk2>=1 & econ_act_wk2<=3 
			replace econ_act_wk2_group = 2 if econ_act_wk2>=5 & econ_act_wk2<=43 
			replace econ_act_wk2_group = 3 if econ_act_wk2>=45 & econ_act_wk2<=99

			label define econ_act_wk2_group_label 1 "agriculture" 2 "industry" 3 "service" 			   
		    label values econ_act_wk2_group econ_act_wk2_group_label
			
			g pos_agri_wk=v9008 
			label var pos_agri_wk "if employed, agricultural position during wk of ref"
			g employee_pos_wk=v9029 
			label var employee_pos_wk "if employed, employee position during wk of ref"
			g employee_sector_wk=v9032 
			label var employee_sector_wk "if employed, employee sector of work during wk of ref"
			
			*a. Service
			g domestic_days_month_wk=cond(v9038!=.,4*v9038,v9039)
			label var domestic_days_month_wk "domestic how many days per month worked during wk of ref"
			g domestic_formal_wk=cond(v9042==2,1,0,.) 
			label var domestic_formal_wk "domestic formal during wk of ref"
			
			*b. Firm size
			g employee_firm_size_wk=v9040 
			label var employee_firm_size_wk "firm size of employee during wk of ref"
			label define employee_firm_size_wk_label 2 "two" 4 "three to five" ///
													 6 "six to ten" 8 "eleven and more"
			label value employee_firm_size_wk employee_firm_size_wk_label
			
			g employee_type_contract_wk=v9041 
			label var employee_type_contract_wk "type of contract of employee during wk of ref"
			label define employee_type_contract_wk_label 1 "by day" 3 "by commission" ///
														 5 "by task" 7 "by day, commission or task" ///
														 8 "other"
			label value employee_type_contract_wk employee_type_contract_wk_label 						 
			
			g employeer_firm_size_wk=v9048 
			label var employeer_firm_size_wk "firm size of employeer during wk of ref"
			label define employeer_firm_size_wk_label 2 "one" 4 "two" ///
													 6 "three to five" 8 "six to ten" ///
													 0 "eleven and more"
			label value employeer_firm_size_wk employeer_firm_size_wk_label
			
			gen firm_size_wk = cond(employee_firm_size_wk!=.,employee_firm_size_wk,cond(employeer_firm_size_wk!=.,employeer_firm_size_wk,.))
			label var firm_size_wk "firm size during wk of ref"			
			
			*d.1. formality
			g formal_wk=cond(v90531==1|v90532==1|v90533==1,1,0,.)
			replace formal_wk=. if v90531==.&v90532==.&v90533==.
			label var formal_wk "for those employed during wk, formal of curr job during wk of ref"
			
			*e. job duration & turnover 1
			
			g job_duration_y_wk=v9611*12 
			label var job_duration_y_wk "job duration in yrs during wk of ref"
			g job_duration_m_wk=v9612 
			label var job_duration_m_wk "job duration in months during wk of ref"
			g job_duration_wk=job_duration_y_wk+job_duration_m_wk /* if less than a yr --> v9062*/
			label var job_duration_wk "job duration in months until wk of ref"
			g e_wk_jobs_dismiss_358=cond(v9062==2,1,0,.)  
			label var e_wk_jobs_dismiss_358 "for those employed during wk, dummy of job dismissal within 358 days"
			
			*e.1. high turnover_wk
			g high_turnover_wk=cond(job_duration_wk<=12&e_wk_jobs_dismiss_358==1,1,0,.)
			label var high_turnover_wk "high turnover for those whose job lasted less than a yr before wk of ref"
			g e_wk_njobs_dismiss_358=v9063 
			label var e_wk_njobs_dismiss_358 "for those employed during wk, how many jobs dismissed within 358 days"
			label define e_wk_njobs_dismiss_358_label 1 "one" 3 "two" 5 "three or more" 		
			label values e_wk_njobs_dismiss_358 e_wk_njobs_dismiss_358_label
			g e_wk_job_duration_358=v9064 
			label var e_wk_job_duration_358 "for those employed during wk, job duration in months of prev. job within 358 days"
			
			*d.2. formality
			g e_wk_prev_job_formal_358=cond(v9065==1,1,0,.)
			label var e_wk_prev_job_formal_358 "for those employed during wk, formal of prev. job within 358 days"
			
			*f, Labor protection
			g e_wk_ui_prev_job_358=cond(v9066==2,1,0,.) 
			label var e_wk_ui_prev_job_358 "if those employed during wk, received ui in prev. job within 358 days"
			
			
			********************************************************************
			************************** 358 days ********************************
			********************************************************************
			
			
			*2. occ_wk=0; occ_358=1 (referring to job dismissed in 358 days)

			
			g u_wk_employed_358=cond(v9067==1,1,0,.)
			label var u_wk_employed_358 "for those unoccupied during wk, employed within 358 days"
			
			g u_wk_occupied_358=cond(v9068==2|v9069==1,1,0,.)
			label var u_wk_occupied_358 "for those unoccupied during wk, occupied within 358 days"
			
			g u_wk_unemployed_358=cond((u_wk_employed_358!=1 & u_wk_occupied_358!=1)|(u_wk_employed_358==1 & hrs_week_work_wk==1) & (age>=18 & age<=64) & search_job_1m==1,1,0,.)
			label var u_wk_unemployed_358 "for those unoccupied during wk, unemployed within 358 days"
			
			g u_wk_out_of_LF_358=cond(u_wk_employed_358!=1 & u_wk_occupied_358!=1 & search_job_1m!=1,1,0,.)
			label var u_wk_out_of_LF_358 "for those unoccupied during wk, out of the labor force within 358 days"
			
			g u_wk_njobs_dismiss_358=v9070  
			label var u_wk_njobs_dismiss_358 "for those unoccupied during wk, how many jobs dismissed within 358 days"
			label define u_wk_njobs_dismiss_358_label 2 "one" 4 "two" 6 "three or more" 		
			label values u_wk_njobs_dismiss_358 u_wk_njobs_dismiss_358_label
			
			g occ_358=v9971 
			label var occ_358 "occupation during 358 days"
			
			gen occ_3584 = string(occ_358,"%04.0f")
			gen occ_3582 = substr(occ_3584,1,2)
			gen occ_3581 = substr(occ_3584,1,1)
			destring occ_3584 occ_3582 occ_3581, replace
			
			label define occ_3581_label 1 "public service" 2 "arts and science" ///
									   3 "medium-level technician" 4 "administrative service" ///
									   5 "trade in stores" 6	"agriculture, forestry, hunting, fishing" ///
									   7 "production of industrial goods, service" 8 "production of industrial goods, service" ///
									   9 "repair and maintenance" 0	"public security"
			label value occ_3581 occ_3581_label 
			
			gen occ_3581_group if occ_wk1=0
			replace occ_3581_group = 1 if occ_3581==6 | occ_3581==9
			replace occ_3581_group = 2 if occ_3581==7 | occ_3581==8 & occ_3581==0
			replace occ_3581_group = 3 if occ_3581==5 | occ_3581==2 
			replace occ_3581_group = 4 if occ_3581==3 | occ_3581==4 
			replace occ_3581_group = 5 if occ_3581==1 
			label define occ_3581_group_label 1 "other blue collar" 2 "skill-intensive blue collar" ///
											 3 "other white collar" 4 "technical and supervisory" ////
											 5 "Professional or Managerial Occupation"
		    label values occ_3581_group occ_3581_group_label
			
			
			
			
			label define occ_3582_label 11 "public sector" ///
									   12 "corporate and organization official" ///
									   13 "manager" 20	"scientific professional" ///
									   21 "physical engineer" ///
									   22 "biologist/health professional" ///
									   23 "education official" 24 "lawyer" ///
									   25 "NGOs" 26 "communicator, artist, religious worker" ///
									   30 "polyvalent technician" 31 "chemical engineer" ///
									   32 "biochemical/health professional" 33 "high school professor" ///
									   34 "transport service" 35 "administrative service" 37 "culture and sports" ///
									   39 "other medium-level technician"  41 "bookkeeper" ///
									   42 "public service" 51 "service worker" ///
									   52 "trade service" 61	"agriculture" 62 "agriculture" ///
									   63 "forestry, hunting, fishing" 64 "agricultural/forestry machinery" ///
									   71 "extractive/constrution industry" 72 "metals, composites" ///
									   73 "electronics" 74	"appliance and instrument assambler" ///
									   75 "jewelery, glassware, ceramics" 76 "fabrics, visual arts" ///
									   77 "wood, furniture" 78	"cross-cutting functions" ///
									   81 "process industries" 82 "steel and construction materials" ///
									   83 "wood pulp, paper" 84	"food, beverages, tabacco" ///
									   86 "electricity, water, utilities" 87 "other industries" ///
									   91 "mechanic shop" 95 "housing/building maintenance" ///
									   99 "storage, maintenance, repair" 01	"aviation military" ///
									   02 "army military" 03 "naval military" 04	"police" ///
									   05 "fire fighters"
			label value occ_3582 occ_3582_label
			
			g econ_act_358=v9972 
			label var econ_act_358 "economic activity during 358 days"
			
			gen econ_act_3585 = string(econ_act_358, "%05.0f") 
			gen econ_act_3582 = substr(econ_act_3585,1,2)
			gen econ_act_3581 = substr(econ_act_3585,1,1)
			destring econ_act_3585 econ_act_3582 econ_act_3581, replace
			
			label define econ_act_3582_label 1 "agriculture, forestry, hunting, fishing" 2 "agriculture, forestry, hunting, fishing" 3 "agriculture, forestry, hunting, fishing" ///
			5 "extractive industry" 6 "extractive industry" 7 "extractive industry" 8  "extractive industry" 9 "extractive industry" 10 "processing industry" 11 "processing industry" 12 "processing industry" ///
			13 "processing industry" 14 "processing industry" 15 "processing industry" 16 "processing industry" 17 "processing industry" 18 "processing industry" ///
			19 "processing industry" 20 "processing industry" 21 "processing industry" 22 "processing industry" 23 "processing industry" 24 "processing industry" ///
			25 "processing industry" 26 "processing industry" 27 "processing industry" 28 "processing industry" 29 "processing industry" 30 "processing industry" ///
			31 "processing industry" 32 "processing industry" 33 "processing industry" 34 "processing industry" ///
			35 "electricity, gas" 36 "water, sewage" 37 "water, sewage" 38 "water, sewage" 39 "water, sewage" ///
			41 "construction" 42 "construction" 43 "construction" 45 "trade, repair" 46 "trade, repair" 47 "trade, repair" ///
			49 "transport, storage" 50 "transport, storage" 51 "transport, storage" 52 "transport, storage" 53 "transport, storage" 55 "housing, food" 56 "housing, food" ///
			58 "information, communication" 59 "information, communication" 60 "information, communication" 61 "information, communication" 62 "information, communication" 63 "information, communication" ///
			64 "finance, insurance" 65 "finance, insurance" 66 "finance, insurance" 68 "real estate" 69 "scientist, technician" 70 "scientist, technician" 71 "scientist, technician" ///
			72 "scientist, technician" 73 "scientist, technician" 74 "scientist, technician" 75	"scientist, technician" ///
			77 "administrative service" 78 "administrative service" 79 "administrative service" 80 "administrative service" ///
			81 "administrative service" 82 "administrative service" 84 "public, social, defense" ///
			85 "education" 86 "health, social services" 87 "health, social services" 88 "Shealth, social services" 90 "arts, culture, sports" 91 "arts, culture, sports" 92 "arts, culture, sports" 93 "arts, culture, sports" ///
			94 "other services" 95 "other services" 96 "other services" 97 "other services" 99 "international organizations" 67 "others" 40 "others"
			label value econ_act_3582 econ_act_3582_label
				
			g pos_agri_358=v9073 
			label var pos_agri_358 "agricultural position within 358 days"
			g employee_pos_358=v9077 
			label var employee_pos_358 "employee position within 358 days"
			g employee_sector_358=v9078 
			label var employee_sector_358 "employee sector of work within 358 days"
			label define employee_sector_358_label 2 "private" 4 "public" 		
			label values employee_sector_358 employee_sector_358_label
			
			*a. service
			g domestic_formal_358=cond(v9083==1,1,0,.) 
			label var domestic_formal_358 "domestic formal within 358 days"
						
			*e. job duration and turnover 2 
			
			g u_wk_job_duration_y_358=v9861*12 
			label var u_wk_job_duration_y_358 "for unoccupied during wk, job duration in yrs within 358 days"
			g u_wk_job_duration_m_358=v9862 
			label var u_wk_job_duration_m_358 "for unoccupied during wk, job duration in months within 358 days"
			g u_wk_job_duration_358=u_wk_job_duration_y_358+u_wk_job_duration_m_358
			label var u_wk_job_duration_358 "for unoccupied during wk, job duration in months of prev. job within 358"

			*high turnover_358 (we know indiv already lost one job bc unocuppied during wk of ref)
			g high_turnover_358=cond(u_wk_job_duration_358<=12,1,0,.)
			label var high_turnover_wk "high turnover for those whose job lasted less than a during 358 days"
			
			*f. labor protection
			g u_wk_ui_prev_job_358=cond(v9084==2,1,0,.) 
			label var u_wk_ui_prev_job_358 "if unoccupied during wk, received unemp. ins. of prev. job within 358 days"
			
			
			*3. occ_wk=1; occ_358=1
			
			
			*Job experience
			/*rename v9892 age_work
			label var age_work "age at which started working"*/
			g exp=(v8005-v9892)
			label var exp "job experience"
			
			gen exp_group if exp=0
			replace exp_group = 1 if exp>=1 & exp<=5
			replace exp_group = 2 if exp>=6 & exp<=10
			replace exp_group = 3 if exp>=11 & exp<=20  
			replace exp_group = 4 if exp>21 
			
			label define exp_group_label 1 "Exp 1 - 5" 2 "Exp 6 - 10" 3 "Exp 11 - 20" 4 "Exp 21 and above" 
			label values exp_group exp_group_label

			
			*Age at which person started working
			g age_work=v9892
			label var age_work "age at which person started working"
			
			
			********************************************************************
			***************************Prior to 365 days************************
			********************************************************************
			
			
			*4. occ_wk=0;occ_358=0;occ_prev_365=1 (referring to previous job)
			
			
			g u_365_employed_prev=cond(v9106==2,1,0,.)
			label var u_365_employed_prev "for unoccupied within 365 days, employed before"
			
			g u_365_occupied_prev=cond(v9107==1|v9108==1,1,0,.)
			label var u_365_occupied_prev "for unoccupied within 365 days, occupied before"

			g u_365_unemployed_prev=cond((u_365_employed_prev!=1 & u_365_occupied_prev!=1)|(u_365_employed_prev==1 & hrs_week_work_wk==1) & (age>=18 & age<=64) & search_job_1m==1,1,0,.)
			label var u_365_unemployed_prev "for unoccupied within 365 days, unemployed before"
			
			g u_365_out_of_LF_358=cond(u_365_employed_prev!=1 & u_365_occupied_prev!=1 & search_job_1m!=1,1,0,.)
			label var u_365_out_of_LF_358 "for unoccupied within 365 days, out of the labor force before"
			
			g occ_prev_365=v9910 
			label var occ_prev_365 "occupation in job previous 365 days"
			
			gen occ_prev_3654 = string(occ_prev_365,"%04.0f")
			gen occ_prev_3652 = substr(occ_prev_3654,1,2)
			gen occ_prev_3651 = substr(occ_prev_3654,1,1)
			destring occ_prev_3654 occ_prev_3652 occ_prev_3651, replace
			
			label define occ_prev_3651_label 1 "public service" 2 "arts and science" ///
									   3 "medium-level technician" 4 "administrative service" ///
									   5 "trade in stores" 6	"agriculture, forestry, hunting, fishing" ///
									   7 "production of industrial goods, service" 8 "production of industrial goods, service" ///
									   9 "repair and maintenance" 0	"public security"
			label value occ_prev_3651 occ_prev_3651_label 
			
			gen occ_prev_3651_group if occ_prev_3651=0
			replace occ_prev_3651_group = 1 if occ_prev_3651==6 | occ_prev_3651==9
			replace occ_prev_3651_group = 2 if occ_prev_3651==7 | occ_prev_3651==8 & occ_prev_3651==0
			replace occ_prev_3651_group = 3 if occ_prev_3651==5 | occ_prev_3651==2 
			replace occ_prev_3651_group = 4 if occ_prev_3651==3 | occ_prev_3651==4 
			replace occ_prev_3651_group = 5 if occ_prev_3651==1 
			label define occ_prev_3651_group_label 1 "other blue collar" 2 "skill-intensive blue collar" ///
											 3 "other white collar" 4 "technical and supervisory" ////
											 5 "Professional or Managerial Occupation"
		    label values occ_prev_3651_group occ_prev_3651_group_label
			
			g econ_act_prev_365=v9911 
			label var econ_act_prev_365 "economic activity in job previous 365 days"
			g employee_pos_prev_365=v9112 
			label var employee_pos_prev_365 "employee position in job previous 365 days"
			g prev_job_formal_365=v9114 
			label var prev_job_formal_365 "formal of ob previous 365 days"		
			
			
			*job duration and turnover 3
			
			g job_duration_y_prev_365=v1091*12
			label var job_duration_y_prev_365 "job duration in yrs in job previous 365 days"
			g job_duration_m_prev_365=v1092 
			label var job_duration_m_prev_365 "job duration in months in job previous 365 days"
			g u_wk_358_job_duration_prev_365=job_duration_y_prev_365+job_duration_m_prev_365
			label var u_wk_358_job_duration_prev_365 "for unoccupied during wk and 358, job duration in months in job previous 365 days"
			
			**high turnover_365 (we know indiv already lost one job bc unoccupied during 365)
			g high_turnover_365=cond(u_wk_358_job_duration_prev_365<=12,1,0,.)
			label var high_turnover_wk "high turnover for those whose job lasted less than a yr during days previous to 365 days"

			
			********************************************************************
			*************************General************************************
			********************************************************************
			
			*Union
			g union_wk=cond(v9087==1,1,0,.) 
			label var union_wk "part of union during month of ref"
			g type_union=v9088 
			label var type_union "type of union"
			
			/*Searching for jobs
			g search_job_wk=cond(v9115==1,1,0,.) 
			label var search_job_wk "searching for jobs during wk of ref"
			g u3=cond(v9117==1,1,0,.)
			label var u3 "usearching for jobs 2m before wk of ref"
			g u4=cond(v9118==2,1,0,.)
			label var u4 "searching for jobs 10m before wk of ref"*/
			
			*network
			g job_search_network=v9119 
			label var job_search_network "network used to search for job"
			label define job_search_network_label  1 "ask employers" 2 "Participate interview process" ///
						 3 "aign up for interview process" 4 "ask agency/union" ///
						 5 "ask relative/friend/colleague" 6 "initiative to start business" ///
						 7 "alace/reply to job posting" 8 "other" 0 "none"
			label value job_search_network job_search_network_label 
			
			
			g mom_alive=cond(v0405==1,1,0,.) 
			label var mom_alive "mother is alive"
			g mom_lives_in_hh=cond(v0406==2,1,0,.) 
			label var mom_lives_in_hh "mother lives in hh"
			
			*domestic work
			g dom_aff_wk=cond(v9121==1,1,0,.)
			label var dom_aff_wk "looked after domestic affairs during wk of ref"
			g hrs_wk_dom_aff_wk=v9921 
			label var hrs_wk_dom_aff_wk "hrs per wk after domestic affairs during wk of ref"
			
			*Number of children in hh
			g hh_nchild=v1141+v1142
			label var hh_nchild "number of children living in hh"
				
			gen hh_nchild_group if hh_nchild=0
			replace hh_nchild_group = 1 if hh_nchild>=1 & hh_nchild<=5
			replace hh_nchild_group = 2 if hh_nchild>=6 & hh_nchild<=10
			replace hh_nchild_group = 3 if hh_nchild>10  
			
			label define hh_nchild_group_label 1 "Child 1 - 5" 2 "Child 6 - 10" 3 "Child 10 and above" 
			label values hh_nchild_group hh_nchild_group_label
	
			*commuting
			g comm_time_wk=v9057 
			label var comm_time_wk "commuting time to workplace during wk of ref"
			label define comm_time_wk_label 1 "<= 30 mins" 3 "31 - 60 mins" 5 "1 - 2 hrs" 7 ">2 hrs"
			label value comm_time_wk comm_time_wk_label
			
			*Migration
			g born_mun=cond(v0501==1,1,0,.) 
			label var born_mun "born in municipality"
			g born_state=cond(v0502==2,1,0,.) 
			label var born_state "born in unidade federal"
			g state_mun_born=v5030 
			label var state_mun_born "state or municipality where born otherwise"
			
		* Clean up 
		
   keep state year hhid indiv_id indiv_idp per_weight hh_weight psu strata strata2 prob_mun incomepbf ///
		incomeliq pbfpnad pop hh_size age child06 child715 child adol adult male ///
		race hh_head_age hh_head_male hh_head_race literate educ s_hh_head ///
		school_freq school_past wk_n_study curr_school employed_wk occupied_wk ///
		unemployed_wk part_time_wk occ_wk econ_act_wk pos_agri_wk employee_pos_wk ///
		employee_sector_wk domestic_days_month_wk domestic_formal_wk ///
		employee_firm_size_wk employee_type_contract_wk employeer_firm_size_wk ///
		employee_montlhy_wage_wk hrs_week_work_wk hrs_month_work_wk hourly_wage_wk formal_wk ///
		job_duration_y_wk job_duration_m_wk job_duration_wk e_wk_jobs_dismiss_358 ///
		high_turnover_wk e_wk_njobs_dismiss_358 e_wk_job_duration_358 ///
		e_wk_prev_job_formal_358 e_wk_ui_prev_job_358 u_wk_employed_358 ///
		u_wk_occupied_358 u_wk_unemployed_358 u_wk_njobs_dismiss_358 occ_358 ///
		econ_act_358 pos_agri_358 employee_pos_358 employee_sector_358 ///
		domestic_formal_358 u_wk_job_duration_y_358 u_wk_job_duration_m_358 ///
		u_wk_job_duration_358 high_turnover_358 u_wk_ui_prev_job_358 exp ///
		u_365_employed_prev u_365_occupied_prev u_365_unemployed_prev ///
		occ_prev_365 econ_act_prev_365 employee_pos_prev_365 prev_job_formal_365 ///
		job_duration_y_prev_365 job_duration_m_prev_365 u_wk_358_job_duration_prev_365 ///
		high_turnover_365 union_wk type_union job_search_network mom_alive mom_lives_in_hh ///
		dom_aff_wk hrs_wk_dom_aff_wk hh_nchild comm_time_wk born_mun born_state state_mun_born search_job_1m ///
		out_of_LF_wk u_365_out_of_LF_358 u_wk_out_of_LF_358 age_group educ_group occ_wk4 occ_wk2 occ_wk1 econ_act_wk5 /// 
		econ_act_wk2 econ_act_wk1 occ_3584 occ_3582 occ_3581 econ_act_3585 econ_act_3582 econ_act_3581 ///
		real_hourly_wage_wk real_hourly_wage_wk_pct real_wage_pct hh_nchild_group exp_group state_group occ_wk1_group econ_act_wk2_group ///
		occ_3581_group occ_prev_3654 occ_prev_3652 occ_prev_3651 occ_prev_3651_group age_work
		
		
		* Save (count 338,740)
		save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pes2011", replace

*Individuals 2
		use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pes2011", clear
		
		drop per_weight hh_weight incomeliq incomepbf pbfpnad child* hh_nchild adol adult ///
		     psu strata strata2 prob_mun hh_size
		
		sort year state hhid indiv_id indiv_idp
		
		*Save (count 338,740)
		save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pes2011v2", replace
		
*Households 2 (count 106,449)
		use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pes2011", clear
		
collapse (sum) per_weight hh_weight incomeliq incomepbf child* hh_nchild adol adult pbfpnad ///
		 (mean) state psu strata strata2 prob_mun hh_size year, by(hhid) 
		 
		 order year state hhid 
		 sort year state hhid 
		
		 merge 1:m hhid using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/dom2011.dta"
		 drop _m
		 
		 order year state hhid indiv_id indiv_idp pbfpnad incomepbf
		 sort year state hhid indiv_id indiv_idp pbfpnad incomepbf
		
		*save (count 338,740)
		save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/dom2011v2.dta", replace

********************************************************************************
*2. Identify Bolsa Familia recipients from household survey

*HH, individuals e merge (Those who are already in Bolsa Familia based on incomepbf - but some BF missing (numbers do not match with reality)
	use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pes2011v2", clear 
	merge 1:1 year state hhid indiv_id indiv_idp using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/dom2011v2.dta"
	keep if _m==3
	drop _m
	
	*save (count pbfpnad 19,993)
	save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011", replace

******************************************************************
* PNAD: (19,993 pbfpnad/106,449 hhs pnad) * 57,324,167 actual hhs 2010 =~10,518,317 familias; R$ 1 227 247 225
* SAGI/MDS, setembro/2011: 13,179,472 familias; R$ 1 573 687 473
* Faltam: 2,661,155 familias; 25.30% do total de identificadas
* Thus, we need to get 26% of hhs with high probability of being BF beneficiary
* Hot deck to contrast PBF in PNAD with actual number of beneficiaries from SAGI/MDS
clear all
set more off
		use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011", clear
		* Initial probit (predict those households who are likely to be in Bolsa Familia)
			gen lnincomepc=ln((incomepbf+incomeliq)/hh_size)
			xi: probit pbfpnad lnincomepc hh_size child hh_head_age telephone cellphone tvcolors computer ///
				washer wall roof toiletexc sewage garbage car urban i.areacens ///
				i.state oven eletr [w=per_weight]
			predict probolsa, p 
			drop lnincomepc
			
			gen selec=runiform() if pbfpnad==1 & probolsa~=.
			
			order probolsa pbfpnad selec
			sort selec
			
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hotdeck2011", replace
			
		* Hot deck - randomly select familias already in pbfpnad that represent 26% of sample... 	
			use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hotdeck2011", clear
			keep if selec>0&selec<=0.26
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hd_temp01", replace
			
		*...to match them with families not in pbfpnad that have similar probability (group that does not have pbf)
clear all
set more off		
		use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hotdeck2011", clear
			
			*keep only those not in pbfpnad but with probability of being therein
			keep if pbfpnad==0&probolsa~=.
			keep hhid indiv_id indiv_idp selec pbfpnad probolsa incomepbf
			gsort -pbfpnad -probolsa
			
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hd_temp02", replace
		
		* Merge (those with pbfpnad randomely selected with those wo pbfpnad)
			use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hd_temp01", clear
			sort hhid 
			merge 1:m hhid indiv_id indiv_idp using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hd_temp02"
			drop _m _I* 
			order year state hhid indiv_id indiv_idp
			sort year state hhid indiv_id indiv_idp

			*make sure pbfpnad=0
			gen sumselec=sum(selec)
			replace sumselec=. if pbfpnad~=1
			gen simpbf=cond(selec~=.,1,0)
			gen n=.
			ge orden=_n if sumselec~=.
			summ orden
			
			local min=r(min)
			local max=r(max)
			display "`min'"
			display "`max'"
			
			forvalues i=`min'/`max' {
				display "`i'"
				capture drop temporary temporary1
				ge temporary1=probolsa if orden==`i'
				egen temporary=max(temporary1) 
				gen double abs=abs(probolsa-temporary) if simpbf==0
				sum abs
				replace simpbf=1 if abs==r(min)
				replace n=`i' if abs==r(min)
				replace incomepbf=incomepbf[`i'] if abs==r(min)
				drop abs
			}
			
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011_clean", replace	

***From massive data
clear all
set more off
			use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011_clean", clear
			replace n=. if n==0
			keep if simpbf==1 & pbfpnad==0
			ren incomepbf pbfimp
			keep hhid indiv_id indiv_idp pbfimp simpbf
			sort hhid			
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hd_temp02v2", replace	
			
		* Merge
			use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hotdeck2011", clear
			sort hhid indiv_id indiv_idp
			merge m:1 hhid indiv_id indiv_idp using "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/hd_temp02v2"
			drop _m _I* 
		
		*Count (338,740)
		
		* Final variables
			gen catpbf=cond(pbfpnad==1,1,cond(simpbf==1,2,3))
			gen double incomeliqpc=incomeliq/hh_size
			replace incomepbf=pbfimp if incomepbf==0 & simpbf==1 & pbfpnad==0
			gen double incomepbfpc=incomepbf/hh_size
			gen double incomepc=(incomeliq+incomepbf)/hh_size				
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011_clean", replace		
******************************************************************		

******************************************************************
* Cluster to split "fake poor"
clear all
		use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011_clean", clear
		
		* Cluster analysis
			local varlist "s_hh_head hh_size telephone cellphone washer tvcolors computer sewage garbage car toiletexc wall roof oven eletr"
			cluster kmeans s_hh_head hh_size telephone cellphone washer tvcolors computer sewage garbage car toiletexc wall roof oven eletr if incomepc==0, k(2)
			
		* Replace income of those "false poor" for mean income
			sum incomepc [w=per_weight] 
			scalar incomemean=r(mean)
			sum s_hh_head [w=hh_weight] if _clus_1==1
			scalar s_hh_head_cl1=r(mean)
			sum s_hh_head [w=hh_weight] if _clus_1==2
			scalar s_hh_head_cl2=r(mean)
			if s_hh_head_cl1>s_hh_head_cl2 {
				replace incomepc=incomemean if _clus_1==1
				replace incomeliqpc=incomemean if _clus_1==1
				replace incomeliq=incomepc*hh_size if _clus_1==1
			}
			else {
				replace incomepc=incomemean if _clus_1==2
				replace incomeliqpc=incomemean if _clus_1==2
				replace incomeliq=incomepc*hh_size if _clus_1==2
			}	
		/* Output
			* Calculos
				foreach var in `varlist' { 
					tabstat `var' [w=hh_weight] if _clus_1~=., by(_clus_1) save nototal
					tabstatmat clus_`var'
				}
			* Log
				log using "$output\pnad_cluster_zero", replace
				set linesize 255
				monta_matriz, output(cluster) pre(clus_) suf(`varlist') dec(4) d
				table _clus_1 [w=per_weight], c(mean income mean incomeliq)
				qui log close*/			
		* Drop
			if "`drop'"~="" { 
				drop `varlist' _clus_1
			}
		* Save and clean
			save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011v2", replace
******************************************************************	

******************************************************************
* Imputation of incomepbf according to actual rules in 2011 
* Basic benefit = 70; Variable benefit for each child = 5 * 32; Variable benefit for youth = 2 * 38
clear all
set more off
use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011v2", clear
		* Variable benefit for each child (need to change benefits based on rules)
			gen double bvchild3=min(3,child)*32		
			gen double bvchild5=min(5,child)*32
			replace bvchild3=0 if catpbf==3
			replace bvchild5=0 if catpbf==3
		* Variable benefit for youth
			qui gen double bvy=min(2,adol)*38
			qui replace bvy=0 if catpbf==3
		* Basic benefit
			qui gen bfixed=0
			* For original pbf in pnad: 
				* Difference
					gen double difpbf=incomepbf-bvchild5-bvy if cat==1
				* Mark the percentiles with largest differences
					gsort -difpbf
					gen double temp=sum(hh_weight)
				
				*Need to change nq number base on line where diff is nonzero
				pctile pct=temp, nq(71067) genp(percent)
					sum hh_weight if cat==1
					
				*Need to change percentage according to rules
					replace bfixed=70 if percent<=85
					drop temp
			* For newly selected pbf not in pnad:
				* threesholds of liquid income + mark 
					gen tincomeliqpc=int(incomeliqpc/70)
					replace tincomeliqpc=10 if tincomeliqpc>10
					gen mark=(bfixed==70)
				* Select randomely keeping proportion in each threshold
					forvalues i=0/10 { 
						sum mark [w=hh_weight] if cat==1 & tincomeliqpc==`i'
						local mean=r(mean)
						gen rand=uniform()<=`mean' if cat==2 & tincomeliqpc==`i'
						replace bfixed=70 if rand==1 & cat==2 & tincomeliqpc==`i'
						replace mark=1 if rand==1 & cat==2 & tincomeliqpc==`i'
						drop rand
					}
		* Generate new PFB benefit, new hh income per capita	
			gen double incomepbf3=bvchild3+bfixed
			gen double incomepbf3y=bvchild3+bvy+bfixed			
			gen double incomepbf5y=bvchild5+bvy+bfixed			
			drop incomepc
			gen double incomepc3=(incomeliq+incomepbf3)/(child+adol+adult)
			gen double incomepc3y=(incomeliq+incomepbf3y)/(child+adol+adult)
			gen double incomepc5y=(incomeliq+incomepbf5y)/(child+adol+adult)
			drop incomepbfpc
			gen double incomepbfpc3=incomepbf3/(child+adol+adult)
			gen double incomepbfpc3y=incomepbf3/(child+adol+adult)
			gen double incomepbfpc5y=incomepbf5y/(child+adol+adult)
			
			g double income_hh3=incomeliq+incomepbf3
			g double income_hh3y=incomeliq+incomepbf3y
			g double income_hh5y=incomeliq+incomepbf5y
		* Output
			log using "$output\pnad_real_rules", replace
			gen pop1=1
			table catpbf [w=hh_weight] if cat~=3, c(sum pop mean incomepbf mean incomepbf3 mean incomepbf3y mean incomepbf5y) ///
				f(%12.0g) row			
			table catpbf [w=hh_weight] if cat~=3, c(mean mark sum bfixed sum bvchild5 sum bvy sum incomepbf5y) ///
				f(%12.0g) row
			log close

*Identification of cadastro unico
g caduni=cond(incomepc3<=270|incomepc3y<=270|incomepc5y<=270,1,income_hh3<=1620|income_hh3y<=1620|income_hh5y<=1620,0)
g pbf=cond(caduni==1&(catpbf==1|catpbf==2),1,0)
g other_caduni=cond(caduni==1&pbf==0,1,0) 
gen pbf_or_caduni=cond(pbf==1,1,cond(other_caduni==1,0,.))
gen age2 = age^2
gen exp2 = exp^2

tab race, gen(race_dummy)
tab occ_3581_group, gen(occ_3581_group_dummy)
tab age_group, gen(age_group_dummy)
tab state_group, gen(state_group_dummy)
tab job_search_network, gen(job_search_network_dummy)
tab educ_group, gen(educ_group_dummy)
tab comm_time_wk, gen(comm_time_wk_dummy)

decode employee_firm_size_wk, gen(employee_firm_size)
decode employeer_firm_size_wk, gen(employeer_firm_size)

gen firm_size=employeer_firm_size+employee_firm_size

drop employeer_firm_size employee_firm_size

label variable state "state"
label variable hhid "household id"
label variable indiv_id "individual id"
label variable state_group "region"
label variable age_group "age strata"
label variable educ_group "levels of schooling"
label variable real_hourly_wage_wk "real hourly wage if currently working"
label variable occ_wk4 "occupations if working - 4 digits"
label variable occ_wk2 "occupations if working - 2 digits"
label variable occ_wk1 "occupations if working - 1 digit"
label variable occ_wk1_group "occupations strata - 5 types"
label variable econ_act_wk5 "economic activity strata - 5 digits"
label variable econ_act_wk2 "economic activity strata - 2 digits"
label variable econ_act_wk1 "economic activity strata - 1 digit"
label variable econ_act_wk2_group "economic activity - 3 types"
label variable occ_3584 "occupations 358 days before - 4 digits"
label variable occ_3582 "occupations 358 days before - 2 digits"
label variable occ_3581 "occupations 358 days before - 1 digit"
label variable pbf_or_caduni "1 if pbf; 0 if caduni"
			
*Save
save "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011v3", replace

********************************************************************************
*3. Ttests, dprobits, IVs and regressions 
clear all
set more off
			
use "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Rawdata_stata/pnad2011v3", clear

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


