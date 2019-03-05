cd /Users/Thomas/Downloads/Stata_translate
unicode encoding set gbk
set more off
local list : dir . files "*tradedata*.dta"

foreach f of local list {
	use "`f'", clear
	display "`f'"
	rename _日期 Date
	rename _进口或出口 imp_exp
	rename _税号编码 HS
	rename _企业编码 ID
	rename _经营单位 Company_name
	rename _消费地进口or生产地出口 city 
	rename _海关口岸 Port 
	rename _企业性质 Business_type 
	rename _起运国或目的国 Origin_and_destination 
	rename _贸易方式 Trade_type 
	rename _中转国 intermediate_country 
	rename _金额 value 
	rename _数量 Quantity
	keep Date imp_exp HS ID Company_name city Port Business_type Origin_and_destination Trade_type intermediate_country value Quantity
	*drop if imp_exp ==""
	drop if Origin_and_destination ==""
	drop if city ==""
	drop if Quantity ==0
	tostring HS, gen(hs6)
	drop HS
	rename hs6 HS
	gen hs6=substr(HS, 1, 6)
	count if length(hs6)<6
	drop if hs6 >"980000"
	drop HS
	rename hs6 HS
	gen x = "进口" if imp_exp == 1 & (Date == 2007 | Date == 2008 | Date == 2009 | Date == 2010)
	replace x  = "出口"  if imp_exp == 0 & (Date == 2007 | Date == 2008 |Date == 2009 | Date == 2010)
	foreach var of varlist x {
    	capture assert mi(`var')
     	if !_rc {
        	drop `var'
     		} 
 		else if _rc {
 			drop imp_exp 
 			rename `var' imp_exp
 			}
 		}
 	tab imp_exp
	export delimited using "`f'.csv", replace
	erase "`f'"
}

exit, clear
shell echo "done changing name"
