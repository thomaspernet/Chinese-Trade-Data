cd /Users/Thomas/Downloads/Stata_translate
set more off
local list : dir . files "*tradedata*.dta"

foreach f of local list {
	use "`f'", clear
	display "`f'"
	keep imp_exp ID HS Company_name city Business_type Origin_and_destination Trade_type value Quantity Date address

	order Company_name, last
	order address, last
	export delimited using "`f'.csv", replace
	erase "`f'"	
}

exit, clear
shell echo "done changing name"