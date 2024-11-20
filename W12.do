*hyun woo kim, chungbuk national university, 2024


*Life expectancy, 1998
webuse "lifeexp", clear


*use of squared terms

	*variable inspection
	de lexp gnppc
	inspect lexp gnppc
	drop if missing(lexp, gnppc)
	
	*fit a linear model to data
	reg lexp gnppc
	
	*draw a straight fitting line
	graph twoway (scatter lexp gnppc) ///
				 (lfit lexp gnppc), legend(off)
	
	*draw a quadratic fitting line
	graph twoway (scatter lexp gnppc) ///
				 (qfit lexp gnppc), legend(off)
				 
	*generate the squared term of gnp per capita
	gen gnppc2=gnppc^2

	*regression model with a squared term
	reg lexp gnppc gnppc2
	reg lexp gnppc c.gnppc#c.gnppc
	reg lexp c.gnppc##c.gnppc
	
	*hierarchical regression models
	est clear
	eststo: reg lexp gnppc
	eststo: reg lexp c.gnppc##c.gnppc
	esttab, nogap stats(N r2 r2_a F)
	
	
	
	
*visualization

	*first fit the model with a squared term
	reg lexp c.gnppc##c.gnppc

	*predicted y
	su gnppc
	ret list
	margins, at(gnppc=(`r(min)'(100)`r(max)'))
	marginsplot, recast(line) recastci(rarea) ///
				 ytitle("Predicted life expectancy at birth")

	*addplot option
	marginsplot, recast(line) recastci(rarea) legend(off) ///
				 addplot(scatter lexp gnppc, msymbol(Oh) mcolor(black%50)) ///
				 ytitle("Predicted life expectancy at birth")

	
	


*use of squared terms, again

	*strong collinearity and mean-centering
	pwcorr gnppc gnppc2
	su gnppc
	gen gnppc_mc=gnppc-`r(mean)'
	gen gnppc_mc2=gnppc_mc^2
	pwcorr gnppc_mc gnppc_mc2
	
	*hierarchical regression models
	est clear	
	eststo: reg lexp gnppc gnppc2
	eststo: reg lexp gnppc_mc gnppc_mc2
	esttab, nogap stats(N r2 r2_a F)

	
	
	
	
*mean-centering of X

	*fit
	reg lexp gnppc_mc gnppc_mc2

	*impact of mean-centering on b1
	su gnppc
	scalar gnppc_mean=r(mean)
	di _b[gnppc_mc] + (-2 * _b[gnppc_mc2] * gnppc_mean)
	
	*impact of mean-centering on b0
	di _b[_cons] - (_b[gnppc_mc] * gnppc_mean) + (_b[gnppc_mc2] * gnppc_mean^2)
	
	*no mean-centering
	reg lexp gnppc gnppc2
	
	

*visualization

	*fit again
	reg lexp c.gnppc_mc##c.gnppc_mc
	
	*visualization
	su gnppc_mc
	margins, at(gnppc_mc=(`r(min)'(100)`r(max)'))
	marginsplot, recast(line) recastci(rarea) legend(off) ///
				 addplot(scatter lexp gnppc, msymbol(Oh) mcolor(black%50)) ///
				 ytitle("Predicted life expectancy at birth")
	
	
	
	
	
	
	
*polynomial function
				 
	*plot a fractional polynomial function
	graph twoway (scatter lexp gnppc) ///
				 (fpfit lexp gnppc, estopts(degree(3))), legend(off)
			 
	*regression
	reg lexp c.gnppc##c.gnppc##c.gnppc
	
	*predicted y
	su gnppc
	margins, at(gnppc=(`r(min)'(100)`r(max)'))
	marginsplot, recast(line) recastci(rarea) legend(off) ///
				 addplot(scatter lexp gnppc, msymbol(Oh) mcolor(black%50)) ///
				 ytitle("Predicted life expectancy at birth")

	*hierarchical regression models
	est clear	
	eststo: reg lexp c.gnppc
	eststo: reg lexp c.gnppc##c.gnppc
	eststo: reg lexp c.gnppc##c.gnppc##c.gnppc
	esttab, nogap stats(N r2 r2_a F)

	*anova testing if c.gnppc#c.gnppc=0
	reg lexp c.gnppc##c.gnppc
	test c.gnppc#c.gnppc=0
	di (_b[c.gnppc#c.gnppc]/_se[c.gnppc#c.gnppc])^2
	
	*nested regression
	nestreg: reg lexp c.gnppc##c.gnppc##c.gnppc

	*ramsey's reset
	ovtest







*use of step functions

	*house price data, 1978-1981
	use "http://qcpages.qc.cuny.edu/~rvesselinov/statadata/KIELMC.DTA", clear

	*scatterplot
	graph twoway (scatter price age) ///
	             (lfit price age)    ///
	             (qfit price age), legend(off)
	graph twoway (scatter price age) ///
				 (fpfit   price age, estopts(degree(3)))

	*regression with three power terms
	est clear
	eststo: reg price cbd i.year age
	eststo: reg price cbd i.year c.age##c.age
	eststo: reg price cbd i.year c.age##c.age##c.age
	esttab, nogap stats(N r2 r2_a F)
	
	*marginsplot
	su age
	margins, at(age=(`r(min)'(10)`r(max)'))
	marginsplot, addplot(scatter price age, msymbol(Oh) mcolor(black%50)) legend(off)

	*age as step function
	su age
	xtile age_step=age, nquantiles(10)      //quantile variable
	ta age_step
	reg price cbd i.year i.age_step
	margins, by(age_step)
	marginsplot
	



	
*interaction effects in combination of a squared term

	*house price data, 1978-1981
	use "http://qcpages.qc.cuny.edu/~rvesselinov/statadata/KIELMC.DTA", clear

	*interaction term only
	reg price i.y81 c.cbd i.y81#c.cbd
	su cbd
	margins, at(cbd=(1000(1000)35000)) by(y81)
	marginsplot

	*squared term only
	reg price c.cbd c.cbd#c.cbd
	margins, at(cbd=(1000(1000)35000))
	marginsplot

	*combined
	reg price i.y81 c.cbd##c.cbd c.cbd#i.y81
	margins, at(cbd=(1000(1000)35000)) by(y81)
	marginsplot, recast(line) recastci(rarea) ///
	             ytitle("Predicted price")


	*hierarchical regression analysis
	est clear
	eststo: reg price i.y81 c.cbd i.y81#c.cbd
	eststo: reg price       c.cbd             c.cbd#c.cbd
	eststo: reg price i.y81 c.cbd i.y81#c.cbd c.cbd#c.cbd
	eststo: reg price i.y81 c.cbd i.y81#c.cbd c.cbd#c.cbd i.y81#c.cbd#c.cbd
	esttab, nogap stats(N r2 r2_a F)
	
	


*log transformation

	*log transform the price
	hist price
	gen ln_price=ln(price)
	hist ln_price
	
	*scatterplot
	graph twoway (scatter ln_price age) (lfit ln_price age)
	graph twoway (scatter ln_price age) (qfit ln_price age)

	*regression with three power terms
	est clear
	eststo: reg ln_price i.y81 cbd age
	eststo: reg ln_price i.y81 cbd c.age##c.age
	esttab, nogap stats(N r2 r2_a F)
	
	*combined
	reg ln_price i.y81 c.cbd##c.cbd c.cbd#i.y81
	margins, at(cbd=(1000(1000)35000)) by(y81)
	marginsplot, recast(line) recastci(rarea) ///
	             ytitle("Predicted price")


	*handling ln(0)
	gen ln_age=ln(age+1)
	reg ln_price i.y81 age
	reg ln_price i.y81 ln_age

	*zero-skewness log transformation
	lnskew0 lnage=age
	pwcorr ln_age lnage
	

	
	
	
*interpretations

	*log-log model
	reg ln_price i.y81 cbd age larea

	*log-linear model
	reg ln_price i.y81 cbd age area
	
	*linear-log model
	reg price i.y81 cbd age larea
	
	
	
	
	
	
	