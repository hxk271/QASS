*hyun woo kim, chungbuk national university, 2024


*introduction to multiple regression model

	*National Longitudinal Survey of Young Women, 14-24 years old in 1968
	webuse "nlswork", clear
		
	*examine the variables
	edit
	su       ln_wage age ttl_exp
	codebook ln_wage age ttl_exp
	hist ln_wage
	hist age
	graph twoway (scatter ln_wage age)
	hist ttl_exp
	graph twoway (scatter ln_wage ttl_exp)
	sort age

	*fit regression models
	reg ln_wage age ttl_exp

	
	
	
	
	
*hierarchical regression models
		
	*fit hierarchical models
	est clear
	eststo: reg ln_wage age
	eststo: reg ln_wage age ttl_exp
	eststo: reg ln_wage age ttl_exp union
	esttab, nogap se stats(r2 N F) label
	
	*missing values
	drop if missing(ln_wage, age, ttl_exp, union)  //drop if missing any
	
	*fit hierarchical models, again
	eststo: reg ln_wage age
	eststo: reg ln_wage age ttl_exp
	eststo: reg ln_wage age ttl_exp union
	esttab, nogap se stats(r2 N F) label
	
	*prediction at means (I)
	egen age_mu=mean(age)
	egen ttl_exp_mu=mean(ttl_exp)
	display (age_mu * _b[age]) + (ttl_exp_mu * _b[ttl_exp]) + _b[_cons]
	margins, atmeans
	
	*prediction at means (II)
	su ln_wage ttl_exp
	margins, at(ttl_exp=(0(1)20)) atmeans
	marginsplot
	
	



	
	
*understanding the partial effect

	webuse "lifeexp", clear
	drop if missing(gnppc)

	*residuals of auxiliary regression
	reg gnppc popgrowth
	predict xtilde, res

	*coefficient
	corr lexp xtilde, cov
	ret list
	di r(cov_12) / r(Var_2)
		
	*fit multiple regression
	reg lexp gnppc popgrowth
		
		
		
		
	
*omitted variable bias

	*National Longitudinal Survey of Young Women, 14-24 years old in 1968
	webuse "nlswork", clear
	drop if missing(age, grade, wks_work, union)
	
	*y as the generated dependent variable
	gen y = -0.2*age + 0.1*grade + 0.45*wks_work + rnormal(0, 1)
	hist y
	
	*perfect model specification (or long regression)
	reg y age grade wks_work
	eret list
	matrix list e(b)
	matrix coef_long=e(b)
	di "b of age (long)=" coef_long[1,1]
	
	*imperfectly specified model (or short regression)
	reg y age grade
	matrix coef_short=e(b)
	di "b of age (short)=" coef_short[1,1]
	

	
	
	
	
	

*standardized beta coefficients

	*fit regression models
	reg ln_wage age ttl_exp grade, beta
	su ln_wage grade	  //check the standard deviations of variables

	*the identity of beta and correlation coefficients
	reg  ln_wage ttl_exp, beta
	mat list e(beta)
	corr ln_wage ttl_exp
	di r(rho)

	
	
	

	
	
*goodness of fit

	*generate random variables following the uniform distribution
	help runiform
	gen r1=runiform()
	gen r2=runiform()
	gen r3=runiform()
	ed
	hist r1
	pwcorr r1 r2 r3
		
	*check out R-squared and adj R-squared
	reg ln_wage age 
	reg ln_wage age r1 r2 r3
	
	
	
	
	