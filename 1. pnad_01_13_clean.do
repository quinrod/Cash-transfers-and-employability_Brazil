clear all
set more off

cd "/Users/rodrigoquintana/dropbox/PED 250Y - SYPA/PNAD/Data/Newdata"

use "PNAD_01_13.dta"

*Basic
rename v0101 year
label var year "year of survey"
rename v4609 pop
label var pop "population estimation"
rename v4618 psu
rename v4611 hh_weight
label var hh_weight "weight of the hh"
rename v4729 person_weight
label var person_weight "weight of hh_member"
rename v4732 fam_weight
label var fam_weight "weight of fam"
rename v4602 strata
label var strata "strata of municipality"
rename v4617 strata2
label var strata2 "strata of municipality 2"
rename v4605 prob_mun
label var prob_mun "probability of municipality"

*Geography
rename uf municipality
label var municipality "unidade da federacao"

*Income
rename v4614 m_hh_income
label var m_hh_income "monthly hh income"
rename v4621 m_income_pc
label var m_income_pc "monthly income per capita"

*HH socio-characteristics
rename v0401 hh_member
label var hh_member "reference in hh"
rename v0402 fam_member
label var fam_member "reference in family"
rename v0302 gender
label var gender "gender of hh_member"
rename v8005 age
label var age "age of hh_member"
rename v0404 race
label var race "race of hh_member"

*Education
rename v0601 literate
label var literate "knows how to read and write"
rename v0602 school
label var school "attends school frequently"
rename v6003 curr_school
label var curr_school "current level of schooling"
rename v6002 school_type
label var school_type "type of school attended"
rename v0606 school_past
label var school_past "attended school before"
rename v6007 educ
label var educ "level of schooling attained"
rename v0611 finish_school
label var finish_school "finished latest level attained"

*Migration
rename v0501 born_mun
label var born_mun "born in municipality"
rename v0502 born_uf
label var born_uf "born in unidade federal"
rename v5030 uf_mun_born
label var uf_mun_born "uf or municipality where born otherwise"

*Labor

*****************
***Week of ref***
*****************
rename v9001 employed_wk
label var employed_wk "employed wk of ref"
rename v9002 on_leave_wk
label var on_leave_wk "employed but temporarily on leave"
rename v9003 employed_prod_wk
label var employed_prod_wk "employed wk of ref but self-production"
rename v9004 employed_cons_wk
label var employed_cons_wk "employed wk of ref but self-construction"
rename v9005 employed_no_jobs_wk
label var employed_no_jobs_wk "if employed, how many jobs during wk of ref"
rename v9906 occ_wk 
label var occ_wk "occupation during wk of ref"
rename v9907 econ_act_wk 
label var econ_act_wk "economic activity during wk of ref"
rename v9008 pos_agri_wk
label var pos_agri_wk "agricultural position during wk of ref"
rename v9029 employee_pos_wk
label var employee_pos_wk "employee position during wk of ref"
rename v9032 employee_sector_wk
label var employee_sector_wk "employee sector of work during wk of ref"
rename v9039 domestic_days_month_wk
label var domestic_days_month "domestic how many days per month worked during wk of ref"
rename v9042 domestic_formal_wk
label var domestic_formal_wk "domestic formal during wk of ref"
rename v9040 employee_firm_size_wk
label var employee_firm_size_wk "firm size of employee during wk of ref"
rename v9041 employee_type_contract_wk
label var employee_type_contract_wk "type of contract of employee during wk of ref"
rename v9048 employeer_firm_size_wk
label var employeer_firm_size_wk "firm size of employeer during wk of ref"
rename v9532 employee_m_income_wk
label var employee_m_income_wk "monthly income of employee during wk of ref"
rename v9057 comm_time_wk
label var comm_time_wk "commuting time to workplace during wk of ref"
rename v9058 hrs_work_wk
label var hrs_work_wk "hours worked per week during wk of ref"
rename v9611 job_duration_m_wk
label var job_duration_m_wk "job duration in yrs during wk of ref"
rename v9612 job_duration_y_wk
label var job_duration_y_wk "job duration in months during wk of ref"

*****************
*****358 days****
*****************
rename v9062 job_dismiss_358 
label var job_dismiss_358 "left job within 358 days"
rename v9063 no_jobs_dismiss_358 
label var no_jobs_dismiss_358 "how many jobs dismissed within 358 days"
rename v9064 job_duration_m_358
label var job_duration_m_358 "job duration in months of prev. job within 358 days"
rename v9065 prev_job_formal_358
label var prev_job_formal_358 "formal of prev. job within 358 days"
rename v9066 ui_prev_job_358
label var ui_prev_job_358 "received unemp. ins. of prev. job within 358 days"
rename v9067 u_wk_employed_358
label var u_wk_employed_358 "for unemployed during wk, employed within 358 days"
rename v9068 u_wk_employed_prod_358
label var u_wk_employed_prod_358 "for unemployed during wk, employed self-production 358 days"
rename v9069 u_wk_employed_cons_358
label var u_wk_employed_cons_358 "for unemployed during wk, employed self-construction 358 days"
rename v9070 u_wk_no_jobs_dismiss_358 
label var u_wk_no_jobs_dismiss_358 "for unemployed during wk, how many jobs dismissed within 358 days"
rename v9971 occ_358
label var occ_358 "occupation during 358 days"
rename v9972 econ_act_358
label var econ_act_358 "economic activity during 358 days"
rename v9073 pos_agri_358
label var pos_agri_358 "agricultural position within 358 days"
rename v9077 employee_pos_358
label var employee_pos_358 "employee position within 358 days"
rename v9078 employee_sector_358
label var employee_sector_358 "employee sector of work within 358 days"
rename v9083 domestic_formal_358
label var domestic_formal_358 "domestic formal within 358 days"
rename v9084 unem_wk_ui_prev_job_358
label var unem_wk_ui_prev_job_358 "if unemployed during wk, received unemp. ins. of prev. job within 358 days"
rename v9861 unem_wk_job_duration_m_358
label var unem_wk_job_duration_m_358 "job duration in yrs within 358 days"
rename v9862 unem_wk_job_duration_y_358
label var unem_wk_job_duration_y_358 "job duration in months within 358 days"

***Union protection***
rename v9087 union
label var union "part of union"
rename v9088 type_union
label var type_union "type of union"

***Job experience*** 
rename v9892 age_work
label var age_work "age at which started working"

gen exp=(age-age_work)
label var exp "job experience"

*****************
*****365 days****
*****************
rename v9106 u_365_employed_prev
label var u_365_employed_prev "for unemployed within 365 days, employed before"
rename v9107 u_365_employed_prod_prev
label var u_365_employed_prod_prev "for unemployed within 365 days, employed self-production before"
rename v9108 u_365_employed_cons_prev
label var u_365_employed_cons_prev "for unemployed within 365 days, employed self-construction before"
rename v1091 job_duration_y_prev_365
label var job_duration_y_prev_365 "job duration in yrs in job previous 365 days"
rename v1092 job_duration_m_prev_365
label var job_duration_m_prev_365 "job duration in months in job previous 365 days"
rename v9910 occ_prev_365
label var occ_prev_365 "occupation in job previous 365 days"
 rename v9911 econ_act_prev_365
label var econ_act_prev_365 "economic activity in job previous 365 days"
rename v9112 employee_pos_prev_365
label var employee_pos_prev_365 "employee position in job previous 365 days"
rename v9114 prev_job_formal_365
label var prev_job_formal_365 "formal of ob previous 365 days"

*********************
*****unemployment****
*********************
rename v9115 unemployed1
label var unemployed1 "unemployed wk of ref"
rename v9116 unemployed2
label var unemployed2 "unemployed m before wk of ref"
rename v9117 unemployed3
label var unemployed3 "unemployed 2m before wk of ref"
rename v9118 unemployed4
label var unemployed4 "unemployed 10m before wk of ref"

************************
*****domestic chores****
************************
rename v0405 mom_alive 
label var mom_alive "mother is alive"
rename v0406 mom_lives_in
label var mom_lives_in "mother lives in hh"
rename v9121 dom_aff_wk
label var dom_aff_wk "looked after domestic affairs during wk of ref"
rename v9921 hrs_dom_aff_wk
label var hrs_dom_aff_wk "hrs per wk after domestic affairs during wk of ref"
rename v1141 male_child_hh
label var male_child_hh "male children living in hh"
rename v1142 female_child_hhe
label var female_child_hh "female children living in hh"
rename v1182 yr_child_born
label var yr_child_born "year in which last child was born"
gen age_last_child=(year-yr_child_born)
label var age_last_child "age of last child born"

*Connectivity
rename v9119 job_search_network
label var job_search_network "network used to search for job"

#delimit;

drop v01* v02* v20* v30* v4604 v4606 v4607 v4608 upa v4620 v4622 v4624 v9992 
	 v0403 v0407 v0604 v0605 v0608 v0609 v5126 v0612 v0716 v9126 v1115  v6020 
	 v90531 v90532 v90533 v9034 v9035 v9891 v9113  v1101  v1153 v1154 v1161 v1162 
	 v1163 v1164 v1107 v1181 v1109 v1110 v1111 v1112 v1113 v1114 v4801 v4802 v4735 
	 v4741 v9993 v0408 v0409  v0412 v6030 v6070 v4743 v4745 v0301 v4610 v0610
	 v0704 v0705 v7060 v7070 v0708 v7090 v7100 v0711 v7121 v7122 v7124 v7125 v7127 
	 v7128 v0713 v0410  v4746 v4747 v4748 v4749 v4750 v4112 v9009 v9010 v9011 v9012 
	 v9013 v9014 v9151 v9152 v9154 v9156 v9157 v9159 v9161 v9162 v9164 v9016 v9017 
	 v9018 v9019 v9201 v9202 v9204 v9206 v9207 v9209 v9211 v9212 v9214 v9021 v9022 
	 v9023 v9024 v9025 v9026 v9027 v9028 v9030 v9031 v9033 v9036 v9037 v9038
	 v9043 v9044 v9045 v9046 v9047 v9049 v9050 v9051 v9052 v9531 v9534 v9535 v9537
	 v9054 v9054 v9055 v9056 v9059 v9060 v9074 v9075 v9076 v9079 v9080 v9081
	 v9085 v9082 v9990 v9991 v9092 v9093 v9094 v9095 v9096 v9097 v9981 v9982 
	 v9984 v9985 v9987 v9099 v9100 v9101 v1021 v1022 v1024 v1025 v1027 v1028 
	 v9103 v9104 v9105 v9120 v1151 v1152 
 
; #delimit cr

#delimit;

order year municipality strata strata2 psu prob_mun pop hh_weight fam_weight person_weight 
	  m_hh_income m_income_pc hh_member fam_member gender age race mom_alive mom_lives_in 
	  born_mun born_uf uf_mun_born

; #delimit cr
