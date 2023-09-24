*hyun woo kim, chungbuk national university, 2023


*file use

	*kgss data
	use "2003-2021_KGSS_public_v3_20230210", clear
	rename *, lower

	*feeling healthy
	lookfor 건강
	tabulate healthy
	tabulate healthy, nolabel mis
	
	*happiness
	lookfor 행복
	tabulate happy
	tabulate happy, nolabel mis

	*year check
	ta year happy, mis
	ta year healthy, mis
	keep if year==2018

	*missing values
	replace healthy=. if healthy<1
	replace happy=. if happy<1
	
	*add numbers to labels
	label list revhealthy revhappy
	numlabel revhealthy revhappy, add        // numlabel *, add	
	tab revhealthy
	tab revhappy
	
	*remove numbers from labels
	numlabel revhealthy revhappy, remove
	tab revhealthy
	tab revhappy
	
	*reverse coding
	recode healthy (1=5) (2=4) (3=3) (4=2) (5=1), gen(healthy_rev)
	generate happy_rev=5-happy
	
	*user-written commands
	revrs healthy
	revrs happy
	
	
	
	
*cross-tabulation
	
	*crosstab
	tabulate healthy_rev happy_rev, mis
	tabulate revhealthy revhappy
	
	*drop if missing
	drop if missing(healthy, happy)

	
	
	
*standardization

	*standardized crosstab
	tabulate revhealthy revhappy, row
	tabulate revhealthy revhappy, col
	tabulate revhealthy revhappy, cell
	
	*row only, no frequency
	tabulate revhealthy revhappy, row nofreq
	
	
	

*table export

	*user-written command
	findit tabout
	tabout revhealthy revhappy using "crosstab.txt", cells(row) replace
	
	
	
*DO YOUR OWN CROSSTAB ANALYSIS HERE



	
	
	
*table command

	*one-way
	tabulate revhappy
	table revhappy, statistic(frequency)
	table revhappy, statistic(percent)	
	
	*two-way
	tabulate revhealthy revhappy
	table    revhealthy revhappy
	
	tabulate revhealthy revhappy, row nofreq
	table revhealthy revhappy, statistic(percent, across(revhappy))

	tabulate revhealthy revhappy, column nofreq
	table revhealthy revhappy, statistic(percent, across(revhealthy))
	
	tabulate revhealthy revhappy, cell nofreq
	table revhealthy revhappy, statistic(percent)
	
	
	
	
	
*durkheim-style table
	
	*online census data
	webuse census, clear
	
	*variable preparation
	gen urbanrate=popurban/pop
	su urbanrate, detail
	recode urbanrate (0/`r(p25)'=1) (`r(p25)'/`r(p50)'=2) (`r(p50)'/`r(p75)'=3) ///
					 (`r(p75)'/1=4)
	replace divorce=divorce/1000     //No. of divorce per 1,000 couples
	
	*help table
	table region urbanrate, statistic(mean divorce) nformat(%6.2f)
    
	*help tabulate summarize
	tab region urbanrate, summarize(divorce) nofreq nostandard noobs
	
	
	
	
	
	
	
*three-way cross-tab

	*crosstabs, conditional on q33_3
	bysort sex: tab revhealthy revhappy, row nofreq
	
	*using table command
	table revhealthy sex revhappy, stat(percent, across(revhappy)) nototal

	
	
	
	
	
	
	
	
	
	
	
	
*chi-square analysis
	
	*expected frequencies
	display 356*221/521

	*observed and expected frequencies
	tab revhealthy revhappy
	
	*options
	tab revhealthy revhappy, expected nofreq
	
	*Pearson's chi-square and significance test
	tab revhealthy revhappy, chi

	*instant chi-square analysis
	tabi 9 15 13 10 \ 7 46 92 22 \ 8 64 194 30 \ 1 36 251 68 \ 4 10 87 55, expected chi
	
	
	