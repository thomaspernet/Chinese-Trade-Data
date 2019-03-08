cd /Users/Thomas/Downloads/Stata_translate
set more off

**2005-2005

** If year is 2005 or 2006, we change the strategy

local y = 2010
if `y' == 2005 | `y' ==2006 {

        	use paddr using data2010.dta, clear
			gen group = ceil(15 * _n/_N)
			tab group
     		save temp_address.dta, replace

     		foreach code in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
     			use temp_address if group == `code', clear
     			drop group
     			gen i = _n
				save address-`code', replace
      			use temp_address if group != `code', clear
      			*drop if group == `code'
      			save temp_address.dta, replace
			}

			erase temp_address.dta
			use exp_or_imp hs_id party_id company city companytype country shipment value quantity using data2010.dta, clear
			gen group = ceil(15 * _n/_N)
			tab group
			erase data2010.dta
			save temp.dta, replace


			foreach code in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
      			use temp.dta if group == `code', clear
      			gen i = _n
      			merge 1:1 i using address-`code' 
				keep if _merge == 3
				drop if exp_or_imp ==""
	  			drop if country ==""
	  			*drop if city ==""
	  			drop if quantity ==0
	  			drop if party_id ==""
	  			gen hs6=substr(hs_id, 1, 6)
	  			count if length(hs6)<6
	  			drop if hs6 >"980000"
				erase address-`code'.dta
				collapse (sum)value (sum)quantity, by(exp_or_imp hs6 party_id company paddr city companytype country shipment)
	  			gen Date = "2010"
	  			rename Date Date 
	  			rename exp_or_imp imp_exp
	  			rename hs6 HS
	  			rename value value
	  			rename quantity Quantity
	  			rename party_id ID
	  			rename company Company_name
	  			rename paddr address
	  			rename companytype Business_type
	  			rename country Origin_and_destination
	  			*rename port Port
	  			rename shipment Trade_type
	 		 	*rename rounting intermediate_country
      			save tradedata-`y'-`code', replace
      			*use temp.dta if group != `code', clear
      			*drop if sav == `code'
      			*save temp.dta, replace	
      			}
      		}

			else  {

 				use exp_or_imp hs_id party_id company city paddr companytype country shipment value quantity using data2010.dta, clear

				*split the file in 3 to collapse data faster 
				* add valperunit in following year

				gen group = ceil(15 * _n/_N)

				erase data2010.dta
				save temp.dta, replace
				local data temp.dta, clear
				foreach code in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
      				use temp.dta if group == `code', clear
	  				drop if exp_or_imp ==""
	  				drop if country ==""
	  				*drop if city ==""
	  				drop if quantity ==0
	  				drop if party_id ==""
	  				gen hs6=substr(hs_id, 1, 6)
	  				count if length(hs6)<6
	  				drop if hs6 >"980000"
	  				collapse (sum)value (sum)quantity, by(exp_or_imp hs6 party_id company paddr city companytype country shipment)
	  				gen Date = "2010"
	  				rename Date Date 
	  				rename exp_or_imp imp_exp
	  				rename hs6 HS
	  				rename value value
	  				rename quantity Quantity
	  				rename party_id ID
	  				rename company Company_name
	  				rename paddr address
	  				rename companytype Business_type
	 	 			rename country Origin_and_destination
	  				*rename port Port
	  				rename shipment Trade_type
	  				*rename rounting intermediate_country
      				save tradedata-`y'-`code', replace
      				*use temp.dta, clear
      				*drop if sav == `code'
      				*save temp.dta, replace
					}
 		}
 		



