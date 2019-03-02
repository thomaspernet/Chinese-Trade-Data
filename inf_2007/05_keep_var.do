cd /Users/Thomas/Downloads/Stata_translate
set more off
local list : dir . files "*tradedata*.dta"

foreach f of local list {
	use "`f'", clear
	display "`f'"
	keep imp_exp ID HS Company_name city Business_type Origin_and_destination Port Trade_type intermediate_country value Quantity Date

	tab imp_exp
	export delimited using "`f'.csv", replace
	erase "`f'"	
}

exit, clear
shell echo "done changing name"