*hyun woo kim, chungbuk national university, 2026


*one-sample test of variance

	*collect summary statistics
	webuse "stay", clear
	summarize lengthstay
	return list
	scalar var=r(Var)
	scalar n=r(N)

	*chi-square value
	help chi2
	scalar chisq=(n-1)*var/(10^2)     //H0: sd=10
	display chisq

	/* 95% confidence interval is meaningless here */
	
	*p-value (note that chi-sq is asymmetric)
	display chi2(n-1, chisq)    //H0: sd>=10, Ha: sd<10
	display chi2(n-1, chisq)*2  //H0: sd==10, Ha: sd!=10 (for convenience)
	display 1-chi2(n-1, chisq)  //H0: sd<=10, Ha: sd>10

	*replication
	sdtest lengthstay==10
	
	
	
	
	
	

	
*two-samples test of variance

	*collect summary statistics
	webuse "fuel2", clear
	summarize mpg if treat==0
	return list
	scalar xbar1=r(mean)
	scalar var1=r(Var)
	scalar n1=r(N)
	summarize mpg if treat==1
	scalar xbar2=r(mean)
	scalar var2=r(Var)
	scalar n2=r(N)

	*F value
	scalar s1=var1/(n1-1)                   // S1/S2
	scalar s2=var2/(n2-1)
	scalar fvalue=s1/s2
	display fvalue

	/*95% confidence interval is meaningless here */
		
	*p-value
	display F(n1-1, n2-1, fvalue)    //H0: ratio>=1, Ha: ratio<1
	display F(n1-1, n2-1, fvalue)*2  //H0: ratio==1, Ha: ratio!=1 (for convenience)
	display 1-F(n1-1, n2-1, fvalue)  //H0: ratio<=1, Ha: ratio>1
	
	*canned command
	sdtest mpg, by(treat)
	

	
	
	
	
*one-way ANOVA
	
	*1980 Census data by state
	webuse "census3", clear
	keep region state brate 
	sort region

	*collect the summary statistics
	ta region
	scalar ngroup=r(r)       //number of groups
	scalar nobs=r(N)         //number of individuals
	
	*sums of square
	egen grand_xbar=mean(brate)                //grand average brates
	egen group_xbar=mean(brate), by(region)    //average brates by regions
	gen bg=(group_xbar-grand_xbar)^2
	egen ss_bg=total(bg)                       //between group sum of square
	gen wg=(brate-group_xbar)^2
	egen ss_wg=total(wg)                       //within group sum of square
	gen tot=(brate-grand_xbar)^2
	egen ss_tot=total(tot)                     //total sum of square
		
	*means of square
	scalar ms_bg=ss_bg/(ngroup-1)                 //between group mean square
	scalar ms_wg=ss_wg/(nobs-ngroup)              //between group mean square
	scalar ms_tot=ss_tot/(nobs-1)                 //total mean square
	display ms_bg, ms_wg, ms_tot
	
	*f value
	scalar fval=ms_bg/ms_wg
	di fval
	
	*p-value
	di 1-F(ngroup-1, nobs-ngroup, fval)
	
	*replicate with anova command
	oneway brate region, tabulate
	anova brate region
	
	
	
*One-Way ANOVA in practice 1

	*city temperature data
	webuse "citytemp", clear
	oneway heatdd region, tabulate
	oneway cooldd region, tabulate
	
	*visualization
	graph bar (mean) heatdd cooldd, over(region)
	
	*better visualization
	graph bar (mean) cooldd heatdd, over(region) ///
			  blabel(bar, format(%5.1f)) ///
			  ytitle("Degree Days") ///
			  legend(label(1 "Cooling degree days") ///
			         label(2 "Heating degree days") ///
					 pos(6) col(2) size(small))
	graph export "figB4.png", replace
	

	
	
	
	
*One-Way ANOVA in practice 2

	*census data
	webuse "nlswork", clear
	
	label def ind_code ///
			1 "Agriculture, Hunting, Forestry, and Fishing" ///
			2 "Mining and Quarrying" ///
			3 "Manufacturing" ///
			4 "Electricity, Gas, Steam, and Water Supply" ///
			5 "Construction" ///
			6 "Wholesale and Retail Trade; Repair of Motor Vehicles" ///
			7 "Transport, Storage, and Communication" ///
			8 "Financial Intermediation, Insurance, and Banking" ///
			9 "Real Estate, Renting, and Business Activities" ///
			10 "Public Administration and Defense; Compulsory Social Security" ///
			11 "Education, Health, and Social Work" ///
			12 "Other Community, Social, and Personal Service Activities"
	label val ind_code ind_code
	oneway ln_wage ind_code, tabulate
	
	*visualization
	graph bar (mean) ln_wage, over(ind_code) horizontal
	
	*alternative presentation
	mean ln_wage, over(ind_code)
	marginsplot, recast(bar) horizontal ylabel(, labsize(vsmall))
	
	
	
	
	
	
*additional issues of ANOVA
				
	*sqrt(f)=t
	webuse "auto", clear
	ttest price, by(foreign)
	di r(t)^2
	oneway price foreign
	
	*probability of making at least an error in 10-time t-tests
	help binomial
	display 1-binomial(10, 0, 0.05)
	di 1- comb(10, 0) * (0.05 ^ 0) * (0.95 ^ (10-0))    //same above
	
	
	
	
*chi-square analysis
	
	*kgss data
	import spss using "data/2023_Data_Kor.sav", clear
	rename *, lower

	*age category
	recode age (min/30=1) (31/40=2) (41/50=3) (51/60=4) (61/70=5) (71/max=6), gen(agecat)
	ta age agecat, mis

	*observed and expected frequencies
	ta krproud, mis
	drop if krproud<1    // DK
	tab agecat krproud
	tab agecat krproud, exp
	
	*Pearson's chi-square and significance test
	tab agecat krproud, chi

	*instant chi-square analysis
	tabi 15 88 24 1 \ 18 133 28 0 \ 36 150 30 0 \ 44 203 37 1 \ 68 171 31 0 \ 58 69 14 0, expected chi
	
	
	