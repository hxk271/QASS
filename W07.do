*hyun woo kim, chungbuk national university, 2024


*correlation analysis

	*Census data on birthrate, median age
	webuse "census4", clear
	
	*correlation coefficient
	correlate medage brate
	
	*covariance
	corr medage brate, cov
	
	*difference between correlation and covariance
	replace brate=brate/10
	corr medage brate, cov      //different
	corr medage brate           //same
	
	*replication
	corr medage brate, cov
	return list
	scalar cov=r(cov_12)
	su medage
	return list
	scalar s1=r(sd)
	su brate
	scalar s2=r(sd)
	di cov/(s1*s2)

	
	
	
*pairwise correlation analysis
	
	*1980 Census data by state
	webuse "census11", clear
	
	*pairwise correlation coefficient
	pwcorr poplt5 pop5_17 pop18p
	
	*significance test
	pwcorr poplt5 pop5_17 pop18p, sig
	
	*matrix returns
	pwcorr poplt5 pop5_17 pop18p, sig
	return list
	matrix list r(sig)
	
	*test statistic and p-value
	pwcorr mrgrate dvcrate, sig
	matrix list r(sig)
	scalar denom = (1-r(rho)^2) / (r(N)-2)
	scalar tval = r(rho)/sqrt(denom)
	scalar pval = 2*(1-t(r(N)-2, tval))
	di tval, pval
	

	
	
*scatterplot

	*Census data on birthrate, median age
	webuse "census4", clear
	
	*scatterplot
	graph twoway scatter medage brate	
	graph twoway lfit medage brate         //fitting line
	
	*scatterplot with a fitting line
	graph twoway (scatter medage brate)    ///
	             (lfit medage brate)
	
	*make it better
	graph twoway (scatter medage brate,    ///
	                      msymbol(Oh) mcolor(Black%40))    ///
	             (lfit medage brate,       ///
				          lcolor(Black)),                  ///
				 xlabel(100(25)300) xtitle("Birth rate") ///
				 ylabel(25(2)35)    ytitle("Median age") ///
				 legend(off)
	graph export "fig3.png", replace width(800) height(600)
	
  
	
	
	
*introduction to regression analysis

	*lung cancer data
	import delimited using "data/lungcancer.csv", clear
	reg cancer smoke
	graph twoway (scatter cancer smoke) (lfit cancer smoke)










*practice

	*cross-sectional labor force participation data
	webuse "mroz", clear

	*ols
	regress lwage educ

	*predicted y (or fitted value)
	predict yhat, xb
	
	*residuals
	predict res, residual
	
	
	
	
*significance tests

	*ols
	regress lwage fatheduc

	*table returns
	ret list
	mat list r(table)
	
	*estimation results
	ereturn list
	mat list e(b)
	mat list e(V)
	
	scalar tval = e(b)[1,1] / sqrt(e(V)[1,1])  //t-value
	scalar df = e(N) - e(df_m)                 //degree of freedom
	scalar pval = (1 - t(df, tval)) * 2         //t-value
	di tval, df, pval
	
	*e(sample)
	gen obs = e(sample)
	ta obs
	ed lwage fatheduc obs yhat res
	
	
	
	
*goodness-of-fit

	*ols
	regress lwage motheduc
	ereturn list
	
	*r2
	scalar r2 = e(mss) / (e(mss) + e(rss))
	di r2          //same with e(r2)

	*r2 as the squared correlation coefficient
	pwcorr lwage motheduc
	ret list
	di r(rho)^2
	
	*r(y, yhat)
	reg lwage motheduc
	di e(r2)
	predict yhat, xb
	pwcorr lwage yhat      //r(y, yhat)
	di r(rho)^2
	
	*r2 without constant?
	regress lwage motheduc, nocons
	
	*rmse
	scalar mse = e(rss) / e(df_r)
	di sqrt(mse)   //same with e(rmse)
	


	
	
	
*publication-quality tables

	*high school beyond data
	use "https://stats.idre.ucla.edu/stat/stata/notes/hsb2", clear
	
	*user-written command		
	findit estout

	*ols
	reg math read
	esttab
	esttab, se         //standard error (preferred)

	*serial models
	est clear
	eststo: reg math read
	eststo: reg math socst
	esttab, se

	*various options
	esttab, se scalar(F) r2
	esttab, se scalar(F) r2 wide nogap
	esttab, ci scalar(F) r2 wide nogap

	*export
	esttab using "model_example.csv", replace         ///
		nogap wide b(%4.3f) se scalar(F) r2 label     ///
		star(+ 0.1 * 0.05 ** 0.01 *** 0.001)          ///
		title("Bivariate Regression Models")          /// 
		mtitle("Reading Model" "Social Model")        /// 
		nonotes addnotes("standard errors in parentheses. * p<.05; ** p<.01; *** p<.001.")
		


	