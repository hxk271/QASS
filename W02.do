*


*Importing external data files

	*importing CSV (comma-separated values) data file
	import delimited using "data/sociology.csv", clear rowrange(4)
	save "data/sociology.dta", replace

	*importing SPSS data file (if it works in your Stata)
	import spss using "data/KGSS2018.sav", clear
	save "data/KGSS2018.dta", replace
	
	
	
	
*Finding variables
	
	*KGSS data
	use "data/KGSS2018.dta", replace
	
	*hunting for variables of interest
	describe
	describe HAP*
	describe HAP??
	describe *HAP*
	
	*if you are looking for something...
	lookfor 행복

	*rename variables
	rename MARITAL marital
	rename *, lower


	
	
	
*Select a sub-sample

	tab age
	drop if age>40
	keep if age<=40
	keep happy marital sex incom0
	order marital sex happy incom0
	
	
	
	
	
	
*Descriptive statistics (I)

	*summarize
	summarize happy
	summarize happy, detail
	
	*summarize a variable by another variable
	bysort marital: summarize happy

	*summarize a variable by another variable, with "if"
	bysort marital: summarize happy if sex==1   //male
	bysort marital: summarize happy if sex==2   //female



	
	
*Tabulation and recoding
	
	*tabulate the variable of interest
	tab happy
	tab happy, nolabel
	
	*recode the variable of interest (I)
	gen happy2=.
	replace happy2=1 if happy==4
	replace happy2=2 if happy==3
	replace happy2=3 if happy==2
	replace happy2=4 if happy==1
	tab happy happy2
	
	*recode the variable of interest (II)
	recode happy (4=1) (3=2) (2=3) (1=4) (-8=.), gen(happiness)
	tab happy happiness

	
	
	
	
	
	
*Descriptive statistics (II)

	*create a new variable
	tab marital
	tab marital, nolabel
	generate together=marital==1 | marital==6
	replace together=. if marital==-8

	*assign a label to the new variable
	label define newmar 1 "같이" 0 "따로", replace
	label value together newmar
	label variable together "같이 혹은 따로"
	tab marital together
	tab marital together, miss

	*summarize a variable by another variable
	bysort together: summarize happiness
	bysort together: summarize happiness if sex==1   //male
	bysort together: summarize happiness if sex==2   //female


	
	
	
*dtable

	dtable i.marital i.sex i.happiness i.together incom0
	tabstat marital sex happiness together incom0

	
	

	
	
	
	
	
	
	
	
*national longitudinal survey of young women

	webuse nlswork, clear
	
	
	
	
	
*one-sample test of the population mean

	*z-test
	su ln_wage
	return list     //list of stored scalars
	display `r(sd)'
	ztest ln_wage==1.67, sd(`r(sd)')
	
	*t-test
	ttest ln_wage==1.67
	
	
	/* let us replicate it with a small cross-sectional data set */
	
	
	*cross-sectional sample
	ta age year 
	keep if year==88 & age==34
	
	*z-test, again
	su ln_wage
	return list     //list of stored scalars
	display `r(sd)'
	ztest ln_wage==1.67, sd(`r(sd)')
	
	*t-test, again
	ttest ln_wage==1.67
	
	
	
	
	
	
*one-sample test of the population proportion

	*
	prtest union==.5        //union should be a dummy variable

	
	
	
	
*one-sample test of the population variance

	*it is actually test of the standard deviation in stata
	sdtest ttl_exp==3
