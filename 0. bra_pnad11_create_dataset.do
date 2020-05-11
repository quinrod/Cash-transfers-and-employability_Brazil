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
