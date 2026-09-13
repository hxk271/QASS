*hyun woo kim, chungbuk national university, 2026



*importing external data files

	*importing CSV (comma-separated values) data file
	import delimited using "data/sociology.csv", clear rowrange(1) varname(1)
	gen monthly=daily(time, "YMD")
	format monthly %td
	tsset monthly
	tsline sociology
	save "data/sociology.dta", replace

	*importing SPSS data file (if it works in your Stata)
	import spss using "data/KGSS2018.sav", clear
	save "data/KGSS2018.dta", replace
	
	
	
	
*finding variables
	
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


	
	
	
*select a sub-sample

	tab age
	drop if age>40
	keep if age<=40
	keep happy marital sex incom0
	order marital sex happy incom0
	
	
	
	
	
	
*descriptive statistics (I)

	*summarize
	summarize happy
	summarize happy, detail
	
	*summarize a variable by another variable
	bysort marital: summarize happy

	*summarize a variable by another variable, with "if"
	bysort marital: su happy if sex==1   //male
	bysort marital: su happy if sex==2   //female



	
	
*tabulation and recoding
	
	*tabulate the variable of interest
	tabulate happy
	tab happy, nolabel
	
	*recode the variable of interest (I)
	generate happy1=.
	replace happy1=1 if happy==4
	replace happy1=2 if happy==3
	replace happy1=3 if happy==2
	replace happy1=4 if happy==1
	tab happy happy1
	
	*recode the variable of interest (II)
	recode happy (4=1) (3=2) (2=3) (1=4) (-8=.), gen(happy2)
	tab happy happy2

	*recode the variable of interest (III)
	revrs happy
	tab revhappy
	tab revhappy, nol
	replace revhappy=. if revhappy==5

	
	
	
	
*descriptive statistics (II)

	*create a new variable
	tab marital
	tab marital, nolabel
	gen together=marital==1 | marital==6
	replace together=. if marital==-8

	*assign a label to the new variable
	label define newmar 1 "같이" 0 "따로", replace
	label value together newmar
	label variable together "같이 혹은 따로"
	tab marital together
	tab marital together, miss

	*happy or not
	recode happy (1 2=1) (3 4=0) (-8=.), gen(happiness)
	label def hap 1 "행복" 0 "불행"
	label val happiness hap
	ta happy happiness

	*summarize a variable by another variable
	bysort together: su happiness
	bysort together: su happiness if sex==1   //male
	bysort together: su happiness if sex==2   //female


	
	
	
*generate descriptive tables

	*dtable command (i recommend this.)
	dtable i.marital i.revhappy i.together incom0, by(sex) ///
	         export("tables.xlsx", replace)
	
	*tabstat command
	tabstat marital happiness together incom0, by(sex) ///
	        statistics(n mean sd min max) columns(statistics)

			
			
			
			
*visualization
		
	*histogram
	histogram incom0, density addlabels
	
	*histogram, a bit prettier
	gen ln_inc=ln(incom0)
	histogram ln_inc, density normal bin(30) ///
					fcolor(gs13) lcolor(black) lwidth(thin) ///
					xtitle("Log of income") ytitle("Density") legend(off) ///
					ylabel(, angle(horizontal)) xlabel(, format(%9.0fc))

	
	*bar chart
	gen i=1
	graph bar (count) i, over(happiness) blabel(bar) //actually "i" is not necessary.
	graph bar (percent) i, over(happiness) by(sex)   //switch by() and over() if you want.
		
	*box-whisker's plot
	graph box ln_inc
	graph box ln_inc, by(together) noout
	
	*graph exportation
	graph export "box.png", replace
	
	
	
	
	
	

	
	
*cross-tabulation
	
	*two-way crosstab
	tab marital revhappy
	tab marital revhappy, mis
	
	*add numbers to labels
	de marital       //check what label name is. (labels8)
	label list labels8
	numlabel labels8, add        // "numlabel *, add" may takes really long time.
	tab marital
	
	
	
	
*standardization

	*standardized crosstab
	tab marital revhappy, row
	tab marital revhappy, col
	tab marital revhappy, cell
	
	*row only, no frequency
	tab marital revhappy, row nofreq
	
	
	
	
	

*table export

	*copy-and-paste
	tab marital revhappy, row nofreq
	
	*tabout
	findit tabout
	tabout marital revhappy using "tabout.csv", cells(row) style(csv) replace
	
	*estpost and esttab
	estpost tab marital revhappy
	ereturn list
	esttab using "esttab.csv", cell(rowpct) unstack noobs replace
	help estpost    //some researchers heavily use estpost
	

	
	
	
*table command

	*one-way
	tabulate revhappy          //table is different from tabulate
	table revhappy, statistic(frequency)
	table revhappy, statistic(percent)	
	help table
	
	*two-way
	tabulate marital revhappy
	table    marital revhappy
	
	tabulate marital revhappy, row nofreq
	table marital revhappy, statistic(percent, across(revhappy))

	tabulate marital revhappy, column nofreq
	table marital revhappy, statistic(percent, across(marital))
	
	tabulate marital revhappy, cell nofreq
	table marital revhappy, statistic(percent)
	
	*three-way
	bysort sex: tab marital revhappy, row nofreq
	table sex marital revhappy, stat(percent, across(revhappy)) nototal

	
	
	
*visualization of crosstab
	
	*horizontal bar chart (or so-called "likert plots")
	graph hbar (percent), over(revhappy) stack groupyvars ///
						by(together, cols(1) legend(pos(6))) ///
						blabel(bar, format(%3.1f) position(center))  ///
						yscale(range(0 100)) ytitle("")
	
	
	
	
	
	
*durkheim-style table of summary
	
	*online census data
	webuse census, clear
	
	*variable preparation
	gen urbanrate=popurban/pop
	su urbanrate, detail
	egen urbancat=cut(urbanrate), group(4)     //help egen
	replace divorce=divorce/1000     //No. of divorce per 1,000 couples
	
	*help table
	table region urbancat, statistic(mean divorce) nformat(%6.2f)
    
	*help tabulate summarize
	tab region urbancat, summarize(divorce) nofreq nostandard noobs
