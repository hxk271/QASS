*hyun woo kim, chungbuk national university, 2026


*correlation analysis

	*Census data on birthrate, median age
	webuse "census4", clear
	
	*correlation coefficient
	correlate medage brate
	
	*covariance
	corr medage brate, cov
	
	*difference between correlation and covariance
	replace brate=brate/10
	corr medage brate, cov      //covariance gives different results
	corr medage brate           //correlation coefficient gives same one
	
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
	return list
	matrix list r(sig)
	scalar df = r(N)-2
	scalar denom = (1-r(rho)^2) / df
	scalar tval = r(rho)/sqrt(denom)
	help t
	scalar pval = 2 * (1-t(df, tval))
	di tval, pval
	
	*correlation coefficient matrix
	global vars "pop poplt5 pop5_17 pop18p pop65p popurban medage death marriage divorce mrgrate dvcrate"
	corr $vars                     //pro: wide, con: no star
	pwcorr $vars, star(0.05)       //pro: star, con: no wide

	
	
	
	
	
	
	
	
	
	
*scatterplot

	*Census data on birthrate, median age
	webuse "census", clear
	
	*scatterplot
	graph twoway scatter medage marriage
	graph twoway lfit medage marriage         //fitting line
	
	*scatterplot with a fitting line
	graph twoway (scatter medage marriage)    ///
	             (lfit medage marriage)
	
	*make it better
	graph twoway (scatter medage marriage, ///
	                     msymbol(none) mlabel(state2) mlabcolor(black))    ///
	             (lfit medage marriage, lcolor(Black)),                    ///
				 xlabel(0(50000)220000, format(%4.0f)) ///
				 xtitle("Number of marriage") ///
				 ylabel(25(2)35, format(%4.0f)) ytitle("Median age") ///
				 legend(off) xsize(2) ysize(1.2)
	graph export "figA3.png", replace width(800) height(600)
	
  
	
	
	
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
	return list
	matrix list r(table)
	
	*estimation results
	ereturn list
	matrix list e(b)
	matrix list e(V)
	
	scalar tval = e(b)[1,1] / sqrt(e(V)[1,1])   //t-value
	scalar df = e(N) - e(df_m)                  //degree of freedom
	help t
	scalar pval = (1 - t(df, tval)) * 2         //t-value
	di tval, df, pval
	
	*e(sample)
	gen obs = e(sample)
	ta obs
	ed lwage fatheduc obs yhat res
	
	
	
	
	
*publication-quality tables

	*high school beyond data
	use "https://stats.idre.ucla.edu/stat/stata/notes/hsb2", clear
	
	*user-written command		
	findit estout

	*ols estimates table
	reg math read
	esttab                //t statistics in parentheses
	esttab, se            //standard errors in parentheses (preferred)
	esttab, ci level(99)  //confidence intervals in brackets

	*series of estimates
	est clear
	eststo: reg math read
	eststo: reg math socst
	esttab

	*various options
	esttab, scalar(F) r2
	esttab, se scalar(F) r2 nogap
	esttab, ci scalar(F) r2 wide

	*export
	esttab using "model_example.csv", replace         ///
		nogap wide b(%4.3f) se scalar(F) r2 label     ///
		star(+ 0.1 * 0.05 ** 0.01 *** 0.001)          ///
		title("Bivariate Regression Models")          /// 
		mtitle("Reading Model" "Social Model")        /// 
		nonotes addnotes("standard errors in parentheses. * p<.05; ** p<.01; *** p<.001.")
		


	