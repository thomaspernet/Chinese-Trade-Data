cd /Users/Thomas/Downloads/Stata_translate/inf_2007 

unicode encoding set gbk
set more off
local list : dir . files "*tradedata*.dta"

foreach f of local list {
	unicode analyze "`f'"
	unicode translate "`f'", invalid
	shell rm -rf "bak.stunicode"
}

exit, clear