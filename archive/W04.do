*hyun woo kim, chungbuk national university, 2026



*file use

	*national longitudinal survey of young women
	webuse nlswork, clear
	
	*a cross-sectional subsample
	ta age year
	keep if year==88 & age==34
	count   //n=54
	
	
	
	
*one-sample test of the population mean: z-test

	*collect statistics
	su ln_wage
	return list              //list of available scalars or matrices
	
	*canned command
	ztest ln_wage==1.67, sd(`r(sd)')

	
	
	
	
*one-sample test of the population mean: t-test
	
	*collect statistics
	su ln_wage
	return list              //list of available scalars or matrices
	scalar xbar=r(mean)      //sample mean
	scalar n=r(N)            //sample size
	scalar sd=r(sd)          //sample standard deviation
	display xbar, n, sd
	
	*t statistic
	scalar se=sd/sqrt(n)
	scalar tval=(xbar-1.67)/se  //H0: mu_0=1.67
	di tval

	*p-value
	help t
	display t(n-1, tval)        //H0: mu>=1.67, Ha: mu<1.67
	display (1-t(n-1, tval))*2  //H0: mu==1.67, Ha: mu!=1.67
	display 1-t(n-1, tval)      //H0: mu<=1.67, Ha: mu>1.67

	*95% confidence interval (x = xbar +- 1.96 * se)
	help invt                                   //t.inv in excel
	scalar lcv = xbar + invt(n-1, .025) * se      //left critical value
	scalar rcv = xbar + invt(n-1, .975) * se      //right critical value 
	di lcv, rcv
	
	*canned command
	ttest ln_wage=1.67
	mean ln_wage, level(99)      //for empirical mean and confidence intervals
	

	
	
	
*mean comparison
		
	*t test for independent samples
	use "data/social_independent", clear
	bysort wave: summarize socialself
	ttest socialself, by(wave)

	*t test for paired samples
	use "data/social_paired", clear
	summarize socialself1 socialself2
	ttest socialself1==socialself2
		
	*t-test without the assumption of equal variance
	use "data/social_independent", clear
	ttest socialself, by(wave) unequal

	*present empirical means and their confidence intervals
	mean socialself, over(wave) level(99)

		
		

*proportion comparison

	*Bacterial pneumonia episodes data from CRT (Hayes and Moulton 2009)
	webuse "pneumoniacrt", clear
	summarize pneumonia

	*one-sample test of proportions
	prtest pneumonia==.15

	*independent sample test of proportions
	prtest pneumonia, by(vaccine)

	*present empirical means and their confidence intervals
	proportion pneumonia, over(vaccine)

	*normal approximation to the binomial
	ttest pneumonia==.15
	ttest pneumonia, by(vaccine)

	
	
	


*tables and figures for comparing means
  
	*web data
	webuse "nhanes2", clear
	keep sampl bmi bpsystol bpdiast tcresult diabetes
	ta diabetes, mis
	drop if diabetes==.
	
	*ttest
	ttest bmi, by(diabetes)
	ttest bpsystol, by(diabetes)
	ttest bpdiast, by(diabetes)
	ttest tcresult, by(diabetes)

	*iterated ttest
	foreach i of varlist bmi bpsystol bpdiast tcresult {
		quietly ttest `i', by(diabetes)
		display r(mu_1) " (" r(sd_1) ")  " r(mu_2) " (" r(sd_2) ")  " r(t) " (" r(p) ")"
		}
			
	*dtable
	dtable bmi bpsystol bpdiast tcresult, ///
	             by(diabetes, test) export(mytable.xlsx, replace)
					  
	*visualization 1
	graph bar bmi bpsystol bpdiast tcresult, by(diabetes)
	
	*visualization 2
	collapse (mean) bmi bpsystol bpdiast tcresult, by(diabetes)
	xpose, clear varname      //transposition
	drop in 1
	graph bar v1 v2, over(_var)
