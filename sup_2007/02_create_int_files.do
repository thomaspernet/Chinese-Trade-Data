cd /Users/Thomas/Downloads/Stata_translate/

local list : dir . files "*data2006_*.dta"
local n = 0
foreach f of local list {
	local n = `n' + 1
	use "`f'", clear
	gen i = _n
	gen sav = 1 == i <500000
	replace sav =2 if i >=500000 & i <1000000
	replace sav =3 if i >=1000000 
	save temp.dta, replace
	erase "`f'"
	foreach code in 1 2 3{
      		use temp.dta, clear
      		keep if sav == `code'
      		compress
      		save tradedata-2006-`n'-`code', replace
      		use temp.dta, clear
      		drop if sav == `code'
      		save temp.dta, replace
	}
}

echo "Done appending, saved now"