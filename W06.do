*hyun woo kim, chungbuk national university, 2024


*one-sample test of variance

	*collect summary statistics
	webuse "stay", clear
	summarize lengthstay
	return list
	scalar mu=r(mean)
	scalar var=r(Var)
	scalar n=r(N)

	*chi-square value
	help chi2
	scalar chisq=(n-1)*var/(10^2)
	display chisq

	/* 95% confidence interval is meaningless here */
	
	*p-value (note that chi-sq is asymmetric)
	display chi2(n-1, chisq)         //H0: sd>=9.5, Ha: sd<9.5
	display chi2(n-1, chisq)*2       //H0: sd==9.5, Ha: sd!=9.5 (for convenience)
	display 1-chi2(n-1, chisq)       //H0: sd<=9.5, Ha: sd>9.5

	*replication
	sdtest lengthstay==10
	
	
	
	
	
	

	
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
	
	
	
*One-Way ANOVA in practice

	*city temperature data
	use "data/citytemp", clear
	oneway heatdd region, tabulate
	oneway cooldd region, tabulate
	
	*visualization
	graph bar (mean) heatdd cooldd, over(region)
	

	
	
*additional issues
				
	*sqrt(f)=t
	webuse "auto", clear
	ttest price, by(foreign)
	di r(t)^2
	oneway price foreign
	
	*probability of making at least an error in 10-time t tests
	di 1- comb(10, 0) * (0.05 ^ 0) * (0.95 ^ (10-0))
	help binomial
	display 1-binomial(10, 0, 0.05)


	

