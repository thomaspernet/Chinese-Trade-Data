cd /Users/Thomas/Downloads/Stata_translate
set more off

**2006-2007

use exp_or_imp hs_id party_id company city port companytype country shipment rounting value quantity using data2006.dta, clear

*split the file in 3 to collapse data faster 
* add valperunit in following year

gen i = _n
gen sav = 1 == i <1000000
replace sav =2 if i >=1000000 & i <2006000
replace sav =3 if i >=2006000 & i <3000000
replace sav =4 if i >=3000000 & i <4000000
replace sav =5 if i >=4000000 & i <5000000
replace sav =6 if i >=5000000 & i <6000000
replace sav =7 if i >=6000000 & i <7000000
replace sav =8 if i >=7000000 & i <8000000
replace sav =9 if i >=8000000 & i <9000000
replace sav =10 if i >=9000000 & i <10000000
replace sav =11 if i >=10000000 & i <11000000
replace sav =12 if i >=11000000 & i <12006002
replace sav =13 if i >=12006002 & i <13000000
replace sav =14 if i >=13000000 & i <14000000
replace sav =15 if i >=14000000 & i <15000000
replace sav =16 if i >=15000000 & i <16000000
replace sav =17 if i >=16000000 & i <17000000
replace sav =18 if i >=17000000 & i <18000000
replace sav =18 if i >=17000000 & i <18000000
replace sav =19 if i >=18000000 & i <19000000
replace sav =20 if i >=20060000 & i <21000000
replace sav =21 if i >=21000000 
erase data2006.dta
save temp.dta, replace

local data temp.dta, clear
foreach code in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21{
      use temp.dta, clear
      keep if sav == `code'
	  drop if exp_or_imp ==""
	  drop if country ==""
	  drop if city ==""
	  drop if quantity ==0
	  gen hs6=substr(hs_id, 1, 6)
	  count if length(hs6)<6
	  drop if hs6 >"980000"
	  collapse (sum)value (sum)quantity, by(exp_or_imp hs6 party_id company city port companytype country shipment rounting)
	  gen Date = "2006"
	  rename Date Date 
	  rename exp_or_imp  imp_exp
	  rename hs6 HS
	  rename value value
	  rename quantity Quantity
	  rename party_id ID
	  rename company Company_name
	  rename companytype Business_type
	  rename country Origin_and_destination
	  rename port Port
	  rename shipment Trade_type
	  rename rounting intermediate_country
      tab imp_exp
      save tradedata-2006-`code', replace
      use temp.dta, clear
      drop if sav == `code'
      save temp.dta, replace
}
