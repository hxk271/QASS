*hyun woo kim, chungbuk national university, 2026




	
*world bank gdp data

	*download the file from the wb website
	import delimited using "data/gdp.csv", clear rowrange(2) varnames(1)
	drop if seriesname==""

	*transforming string to numerical and histogram
	destring yr*, replace force     //the force option will ignore ".."
	histogram yr1960, bin(20) name(g1, replace)
	histogram yr2024, bin(20) name(g2, replace)
	graph combine g1 g2, xcommon ycommon

	*descriptive statistics
	de
	su

	*reshape from wide to long
	gen i=_n
	reshape long yr, i(i) j(j)
	h reshape long 
	
	*tidy up as a panel data set
	ren i ccode
	ren j year
	ren yr gdp
	xtset ccode year                       //declare as panel
	xtline gdp, overlay legend(off)	
	
	*histogram, again
	histogram gdp, bin(50)
	gen lngdp=ln(gdp)
	hist lngdp              //awkwardly two-peaked
	drop lngdp
	
	*reshape from long to wide
	reshape wide gdp, i(ccode) j(year)
	
	*save as new file
	compress
	keep countryname countrycode seriesname seriescode gdp2019
	save "data/wb_gdp", replace
		
		
		
		
		
	

	
*world values survey data

	*download the data from the official website
	use "data/WVS_Cross-National_Wave_7_stata_v6_0", clear
	describe
	
	*post-materialist value index (see questionnaire)
	lookfor material
	de Q154 Q155
	su Q154 Q155
	numlabel Q154 Q155, add
	
	*first and second choices
	table Q154, mis
	table Q155, mis
	
	*post-materialist values (3=post-materialist; 2=mixed; 1=materialist)
	gen pmv=.
	replace pmv=3 if (Q154==2 | Q154==4) & (Q155==2 | Q155==4)
	replace pmv=1 if (Q154==1 | Q154==3) & (Q155==1 | Q155==3)
	replace pmv=2 if (Q154==2 | Q154==4) & (Q155==1 | Q155==3)
	replace pmv=2 if (Q154==1 | Q154==3) & (Q155==2 | Q155==4)
	replace pmv=. if Q154<0 | Q155<0

	*check with the pre-existing variable
	tab pmv Y002, miss

	*save as new file
	save "data/wvs_pmv", replace
		
		
		
		
		
	
	
	
*Merge the World Values Survey data with World Bank data
	
	*make sure you've the code above
	use "data/wb_gdp", clear
	de               //double check if country code is what you are looking for
	use "data/wvs_pmv", clear
	ren B_COUNTRY_ALPHA countrycode
	keep B_COUNTRY countrycode pmv
	
	*generate three dummy variables
	tab pmv, generate(value)
	describe pmv value*

	*aggregate value categories by country
	collapse (mean) value1 value2 value3, by(countrycode)

	*merging WVS data with WB data
	merge m:1 countrycode using "data/wb_gdp"      //non-matched n=203
	drop if _merge==1 | _merge==2

	*scatterplot of value types and national wealth
	graph twoway (scatter value1 gdp) (lfit value1 gdp), name(g1, replace) legend(off)
	graph twoway (scatter value2 gdp) (lfit value2 gdp), name(g2, replace) legend(off)
	graph twoway (scatter value3 gdp) (lfit value3 gdp), name(g3, replace) legend(off)
	graph combine g1 g2, name(g4, replace) 
	graph combine g4 g3, col(1) xsize(2) ysize(2)
