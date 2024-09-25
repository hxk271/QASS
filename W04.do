*hyun woo kim, chungbuk national university, 2024


*file use

	*kgss data
	import spss using "data/2023_Data_Kor.sav", clear
	count   //n=1,230
	rename *, lower

	
*cross-tab in practice

	*subjective health
	lookfor 건강
	tabulate health23
	tabulate health23, nolabel mis
	
	*happiness
	lookfor 행복
	tabulate happinss
	tabulate happinss, nolabel mis
	replace happinss=. if happinss<1   //missing values
		
	*add numbers to labels
	de health23 happinss       //check what label names are
	label list labels529 labels487
	numlabel labels529 labels487, add        // numlabel *, add	
	tab health23
	tab happinss

	
	
	
*cross-tabulation
	
	*crosstab
	tab health23 happinss, mis
	tab happinss health23, mis
	
	*drop if missing
	drop if missing(health23, happinss)

	
	
	
*standardization

	*standardized crosstab
	tab health23 happinss, row
	tab health23 happinss, col
	tab health23 happinss, cell
	
	*row only, no frequency
	tab health23 happinss, row nofreq
	
	
	
	
	

*table export

	*copy-and-paste
	tab health23 happinss, row nofreq
	
	*tabout
	findit tabout
	tabout health23 happinss using "tabout.csv", cells(row) style(csv) replace
	
	*estpost and esttab
	estpost tab health23 happinss
	ereturn list
	esttab using "esttab.csv", cell(rowpct) unstack noobs replace
	help estpost    //some researchers heavily use estpost
	

	
	
	
*table command

	*one-way
	tabulate health23
	table health23, statistic(frequency)
	table happinss, statistic(percent)	
	help table
	
	*two-way
	tabulate health23 happinss
	table    health23 happinss
	
	tabulate health23 happinss, row nofreq
	table health23 happinss, statistic(percent, across(happinss))

	tabulate health23 happinss, column nofreq
	table health23 happinss, statistic(percent, across(health23))
	
	tabulate health23 happinss, cell nofreq
	table health23 happinss, statistic(percent)
	
	*three-way
	bysort sex: tab health23 happinss, row nofreq
	table sex health23 happinss, stat(percent, across(happinss)) nototal
	
	
	
	
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
	
	
	
	
	
*chi-square analysis
	
	*kgss data
	import spss using "data/2023_Data_Kor.sav", clear
	rename *, lower

	*expected frequencies
	display 356*221/521

	*age category
	recode age (min/30=1) (31/40=2) (41/50=3) (51/60=4) (61/70=5) (71/max=6), gen(agecat)

	*observed and expected frequencies
	drop if krproud<1    //DK
	tab agecat krproud
	
	*options
	tab agecat krproud, expected nofreq
	
	*Pearson's chi-square and significance test
	tab agecat krproud, chi

	*instant chi-square analysis
	tabi 15 88 24 1 \ 18 133 28 0 \ 36 150 30 0 \ 44 203 37 1 \ 68 171 31 0 \ 58 69 14 0, expected chi
	
	
	
	
	
	


*visualization

	ta agecat krproud, row nofreq
	
	*collapse dummy variables into average values
	ta krproud, gen(proudcat)
	collapse (mean) proudcat*, by(agecat)
	
	*bar chart
	graph bar proud*, over(agecat) legend(off)

	