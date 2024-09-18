*hyun woo kim, chungbuk national university, 2024

*file use
use "data/kor_data_20200064.dta" , clear


*descriptive statistics

	*variable shopping
	describe        //check how many variables and observations are in the data
	
	*tables for demographic variables
	dtable i.SQ1 i.SQ2_R i.SQ3 i.DQ1 i.DQ2 i.DQ3
	
	
	

*variable recoding: activities for social changes	

	*frequency distribution table
	tab1 A9_*, miss
	
	*composite variable
	gen act1=A9_1+A9_2+A9_3+A9_4+A9_5
	gen act2=A9_6+A9_7+A9_8+A9_9+A9_10

	*frequency distribution
	ta act1
	ta act2
	
	*histogram
	histogram act1
	histogram act2, density

	*scatterplot
	graph twoway scatter act1 SQ2, jitter(10)
	graph twoway lfit act1 SQ2
	graph twoway (scatter act1 SQ2, jitter(10)) (lfit act1 SQ2)
	graph twoway (scatter act2 SQ2, jitter(10)) (lfit act2 SQ2)

	
	
*variable recoding: political efficacy

	*external political efficacy
	tab A2_1
	tab A2_2
	gen extpoleff=(A2_1+A2_2)/2
	
	*internal political efficacy
	tab A2_3
	
		*reverse-coding 1
		gen     intpoleff=.
		replace intpoleff=1 if A2_3==7
		replace intpoleff=2 if A2_3==6
		replace intpoleff=3 if A2_3==5
		replace intpoleff=4 if A2_3==4
		replace intpoleff=5 if A2_3==3
		replace intpoleff=6 if A2_3==2
		replace intpoleff=7 if A2_3==1
		tab A2_3 intpoleff
		drop intpoleff
		
		*reverse-coding 2
		recode A2_3 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7), generate(intpoleff)
		tab A2_3 intpoleff
		drop intpoleff
		
		*reverse-coding 3
		gen intpoleff=8-A2_3
		tab A2_3 intpoleff
		drop intpoleff
		
		*reverse-coding 4       
		revrs A2_3, replace      // findit revrs
		tab A2_3
		tab A2_3, nolabel
		clonevar A2_3 intpoleff
	
	*visualization
	histogram extpoleff
	histogram intpoleff

	*average compared by gender
	bysort SQ1: su intpoleff
	bysort SQ1: su extpoleff

	*average compared by socio-economic status 
	bysort DQ4: su intpoleff
	bysort DQ4: su extpoleff
	
	*average compared by socio-economic status 
	bysort DQ2: su intpoleff
	bysort DQ2: su extpoleff
	
	
	
	

	
*World Values Survey

	*download the data from the official website
	use "data/wvs/WVS_Cross-National_Wave_7_stata_v4_0", clear

	*descriptive statistics
	describe        //check how many variables and observations are in the data
	lookfor material   //post-materialist value index
	de Q154 Q155
	summarize Q154 Q155

	*first and second choices
	tab Q154, miss
	tab Q154, nolabel
	tab Q155, miss
	tab Q155, nolabel

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
		
		
		
	

	
	
	
	
*World Bank GDP data

	*download the file from the WB website
	import delimited using "data/gdp.csv", clear rowrange(2) varnames(1)

	*descriptive statistics
	describe        //check how many variables and observations are in the data

	*transforming string to numerical and histogram
	destring yr2019, generate(gdp) force
	histogram gdp, bin(30)

	*save as new file
	save "data/wb_gdp", replace
		
		
		
		
	
	
	
*Merge the World Values Survey data with World Bank data
	
	*make sure you've the code above
	use "data/wb_gdp", clear
	de               //double check if country code is what you are looking for
	use "data/wvs_pmv", clear
	ren B_COUNTRY_ALPHA countrycode
	keep B_COUNTRY countrycode pmv
	
	*three dummy variables
	tab pmv, generate(value)
	describe pmv value*

	*aggregate value categories by country
	collapse (mean) value1 value2 value3, by(countrycode)

	*merging WVS data with WB data
	merge m:1 countrycode using "data/wb_gdp"      //non-matched n=1,390
	drop if _merge==1 | _merge==2

	*scatterplot of value types and national wealth
	graph twoway (scatter value1 gdp) (lfit value1 gdp)
	graph twoway (scatter value2 gdp) (lfit value2 gdp)
	graph twoway (scatter value3 gdp) (lfit value3 gdp)
	
	*improvement
	graph twoway (scatter value3 gdp, mcolor(blue) msize(medium) msymbol(circle)) ///
                 (lfit value3 gdp, lcolor(red) lwidth(medium)), ///
      title("Relationship between GDP and Value3", size(large)) ///
      subtitle("Scatter plot with fitted line", size(medium)) ///
      xlabel(, labsize(small)) ylabel(, labsize(small)) ///
      legend(off) ///
      graphregion(color(white)) bgcolor(white)

	 
