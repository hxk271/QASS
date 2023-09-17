*Q5 (opposition to mask exports)

	*Mask and social distancing
	use "mask/dfile_2699.dta", clear
	
	*descriptive statistics
	describe        //check how many variables and observations are in the data
	summarize q5_n?
	
	*frequency distribution table
	tab1 q5_n?, miss
	
	*composite variable
	gen oppose=q5+q5_n2+q5_n3+q5_n4+q5_n5

	*histogram
	histogram oppose

	*scatterplot
	graph twoway scatter oppose sq3, jitter(10)
	graph twoway lfit oppose sq3
	graph twoway (scatter oppose sq3, jitter(10)) (lfit oppose sq3)

	
	

*Q4 (in favor of 5-day rotation policy)
	
	*descriptive statistics
	summarize q4 q4_n2 q4_n3

	*frequency distribution table
	tab1 q4 q4_n2 q4_n3, miss
	
	*reverse coding
	gen q4r=1 if q4==5
	replace q4r=2 if q4==4
	replace q4r=3 if q4==3
	replace q4r=4 if q4==2
	replace q4r=5 if q4==1	
	
	recode q4_n2 (5=1) (4=2) (3=3) (2=4) (1=5), generate(q4_n2r)
	
	gen q4_n3r=6-q4_n3
	
	*composite variable
	gen fdrp=q4r+q4_n2r+q4_n3r

	*histogram
	histogram fdrp

	
	
	

	
*World Values Survey

	*download the data from the official website
	use "wvs/WVS_Cross-National_Wave_7_stata_v4_0", clear

	*descriptive statistics
	describe        //check how many variables and observations are in the data
	summarize Q154 Q155

	*first and second choices
	tab Q154, miss
	tab Q154, nolabel
	tab Q155, miss
	tab Q155, nolabel

	*post-materialist values (3=post-materialist; 2=mixed; 1=materialist)
	gen pmv=0
	replace pmv=3 if (Q154==2 | Q154==4) & (Q155==2 | Q155==4)
	replace pmv=1 if (Q154==1 | Q154==3) & (Q155==1 | Q155==3)
	replace pmv=2 if (Q154==2 | Q154==4) & (Q155==1 | Q155==3)
	replace pmv=2 if (Q154==1 | Q154==3) & (Q155==2 | Q155==4)
	replace pmv=. if Q154<0 | Q155<0

	*histogram
	histogram pmv, bin(3)

	*check with the pre-existing variable
	tab pmv Y002, miss

	*save as new file
	save "wvs_pmv", replace
		
		
		
	

	 
*KELS 2005

	*
	cd "Data"
	import spss using "KELS2005/Y2_STD_EDU.SAV", clear
	describe        //check how many variables and observations are in the data
	ren *, lower
	
	*self-regulated learning (y2l3_1 y2l3_2 y2l3_3 y2l3_4)
	summarize y2l3_?
	tab1 y2l3_?, mis
	replace y2l3_1=. if y2l3_1==-1
	replace y2l3_2=. if y2l3_2==-1
	replace y2l3_3=. if y2l3_3==-1
	replace y2l3_4=. if y2l3_4==-1
	gen srl=y2l3_1+y2l3_2+y2l3_3+y2l3_4
	histogram srl, bin(13)
	
	*exam score (Y2KOR_S Y2ENG_S Y2MAT_S)
	summarize y2???_s
	tab1 y2???_s
	replace y2kor_s=. if y2kor_s==-1
	replace y2eng_s=. if y2eng_s==-1
	replace y2mat_s=. if y2mat_s==-1
	gen score=y2kor_s+y2eng_s+y2mat_s
	histogram score
	
	*more beautiful scatterplot
	graph twoway scatter score srl, jitter(30) msymbol(oh)
	graph twoway lfit score srl
	graph twoway (scatter score srl, jitter(10) msymbol(oh)) ///
	             (lfit score srl)
	graph twoway (scatter score srl, jitter(10) msymbol(oh)) ///
	             (lfit score srl),                           ///
				 xtitle("Self-regulated learning")           ///
				 ytitle("Exam score (total)") legend(off)
				 
				 
				 
				 
	
	
	
	
	
*World Bank GDP data

	*download the file from the WB website
	import delimited using "wb/gdp.csv", clear rowrange(2) varnames(1)

	*descriptive statistics
	describe        //check how many variables and observations are in the data

	*transforming string to numerical and histogram
	destring yr2019, generate(gdp) force
	histogram gdp, bin(30)

	*save as new file
	save "wb_gdp", replace
		
		
		
		
	
	
	
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
	 
	 
	 
