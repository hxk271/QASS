*hyun woo kim, chungbuk national university, 2024


*one-sample t-test

	*collect statistics
	webuse "nlswork", clear
	su ln_wage
	return list              //list of available scalars or matrices
	scalar mu=r(mean)        //sample mean
	scalar n=r(N)            //sample size
	scalar sd=r(sd)          //sample standard deviation
	
	*t statistic
	scalar se=sd/sqrt(n)
	scalar tval=(mu-1.67)/se  //H0: mu_0=1.6
	di tval

	*95% confidence interval (x = mu +- 1.96 * se)
	help invt                                   //t.inv in excel
	scalar lcv = mu + invt(n-1, .025) * se      //left critical value
	scalar rcv = mu + invt(n-1, .975) * se      //right critical value 
	di lcv, rcv

	*p-value
	help t
	display t(n, tval)        //H0: mu>=1.67, Ha: mu<1.67
	display (1-t(n, tval))*2  //H0: mu==1.67, Ha: mu!=1.67
	display 1-t(n, tval)      //H0: mu<=1.67, Ha: mu>1.67
		
	*canned command
	ttest ln_wage=1.67
	

	
	
	
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


		

*proportion comparison

	*Bacterial pneumonia episodes data from CRT (Hayes and Moulton 2009)
	webuse "pneumoniacrt", clear
	summarize pneumonia

	*one-sample test of proportions
	prtest pneumonia==.15

	*independent sample test of proportions
	prtest pneumonia, by(vaccine)

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
		qui ttest `i', by(diabetes)
		display r(mu_1) " (" r(sd_1) ")  " r(mu_2) " (" r(sd_2) ")  " r(t) " (" r(p) ")"
		}
			
	*dtable
	dtable bmi bpsystol bpdiast tcresult, ///
	             by(diabetes, test) export(table1.xlsx, replace)					  
					  
	*visualization 1
	graph bar bmi bpsystol bpdiast tcresult, by(diabetes)
	
	*visualization 2
	collapse (mean) bmi bpsystol bpdiast tcresult, by(diabetes)
	xpose, clear varname
	drop in 1
	graph bar v1 v2, over(_var)
