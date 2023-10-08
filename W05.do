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
	scalar tval=(mu-1.67)/se
	di tval

	*95% confidence interval (x = mu +- 1.96 * se)
	help invt                                   //t.inv in excel
	scalar lcv = mu + invt(n-1, .025) * se      //left critical value
	scalar rcv = mu + invt(n-1, .975) * se      //right critical value 
	di lcv, rcv

	*p-value
	display t(n, tval)        //H0: mu>=1.67, Ha: mu<1.67
	display (1-t(n, tval))*2  //H0: mu==1.67, Ha: mu!=1.67
	display 1-t(n, tval)      //H0: mu<=1.67, Ha: mu>1.67
		
	*canned
	ttest ln_wage=1.6
	

	
	
	
*mean comparison

	*scalar command
	scalar se = 20/sqrt(29)
	scalar tval = (70-60) / se
	di tval
	
	*cumulative t-distribution function (cdf)
	help t
	di (1 - t(28, tval)) + (t(28, -tval))    //two-sided test
		
	*one-sample t test
	use "data/social", clear
	summarize socialself
	ttest socialself==29.88
		
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

	*unpair the paired samples
	use "data/social_paired", clear
	ttest socialself1==socialself2, unpaired
		

		

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



	
	

*one-sample test of variance

	*collect summary statistics
	use "data/social", clear
	summarize socialself
	return list
	scalar mu=r(mean)
	scalar var=r(Var)
	scalar n=r(N)

	*chi-square value
	help chi2
	scalar chisq=(n-1)*var/(5.1^2)
	display chisq

	/* 95% confidence interval is meaningless here */
	
	*p-value (note that chi-sq is asymmetric)
	display chi2(n-1, chisq)       //H0: sd>=5.1, Ha: sd<5.1
	display chi2(n-1, chisq)*2     //H0: sd==5.1, Ha: sd!=5.1 (for convenience)
	display chi2tail(n-1, chisq)   //H0: sd<=5.1, Ha: sd>5.1

	*replication
	sdtest socialself==5.1
	
	
	
	
	
	

	
*test of variance for independent samples

	*collect summary statistics
	webuse "fuel2", clear
	summarize mpg if treat==0
	return list
	scalar mu1=r(mean)
	scalar var1=r(Var)
	scalar n1=r(N)
	summarize mpg if treat==1
	scalar mu2=r(mean)
	scalar var2=r(Var)
	scalar n2=r(N)

	*F value
	scalar S1=var1/(n1-1)                   // S1/S2
	scalar S2=var2/(n2-1)
	scalar fvalue=S1/S2
	display fvalue

	/*95% confidence interval is meaningless here */
		
	*p-value
	display F(n1-1, n2-1, fvalue)    //H0: ratio>=1, Ha: ratio<1
	display F(n1-1, n2-1, fvalue)*2  //H0: ratio==1, Ha: ratio!=1 (for convenience)
	display 1-F(n1-1, n2-1, fvalue)  //H0: ratio<=1, Ha: ratio>1
	
	*canned command
	sdtest mpg, by(treat)
	


*two paired sample test of variance

	/* we do not discuss it */
	
	

	
	
	
	
	
*one-way ANOVA
	
	*1980 Census data by state
	webuse "census3", clear
	keep brate region
	sort region

	*collect the summary statistics
	tab region
	scalar ngroup=r(r)                   //number of groups
	scalar nobs=r(N)                     //number of individuals
	
	*sums of square
	egen total_mu=mean(brate)                //grand average brates
	egen group_mu=mean(brate), by(region)    //average brates by regions
	gen bg=(group_mu-total_mu)^2
	egen ss_bg=total(bg)                     //between group sum of square
	gen wg=(brate-group_mu)^2
	egen ss_wg=total(wg)                     //within group sum of square
	gen tot=(brate-total_mu)^2
	egen ss_tot=total(tot)                   //total sum of square
		
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
	
	
	
	
	
*additional issues

	*replicate with regression command
	reg brate i.region
				
	*sqrt(f)=t
	webuse "auto", clear
	ttest price, by(foreign)
	return list
	display abs(r(t))
	oneway price foreign
	return list
	display sqrt(r(F))
	
	*probability of making at least an error in 10-time t tests
	di 1- comb(10, 0) * (0.05 ^ 0) * (0.95 ^ (10-0))
	help binomial
	display 1-binomial(10, 0, 0.05)


	

