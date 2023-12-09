*binary logistic regression

	*Hosmer & Lemeshow data
	webuse lbw, clear

	*scatterplot of low against bwt
	graph twoway (scatter low bwt) (lfit low bwt)

	graph twoway (scatter bwt lwt) (lfit bwt lwt)
	graph twoway (scatter low lwt) (lfit low lwt)


	*comparing ols and logit
	est clear
	eststo: reg   bwt lwt
	eststo: reg   low lwt
	eststo: logit low lwt
	esttab, nogap wide

	*odds interpretation
	di 100 * (exp(_b[lwt])-1)
	logit low lwt, or
	
	*visualization
	margins, at(lwt=(80(1)250))
	marginsplot

	
	
	
	
	
	
*model goodness-of-fit

	*comparing ols and logit
	est clear
	eststo: reg   bwt smoke age lwt ht
	eststo: reg   low smoke age lwt ht
	eststo: logit low smoke age lwt ht
	esttab, nogap wide

	*race
	est clear
	eststo: logit low smoke age lwt ht ui
	estat ic
	estat class
	eststo: logit low smoke age lwt ht ui i.race
	estat ic
	estat class
	lrtest est1 est2
	esttab, nogap wide


	*lrtest 
	est clear
	eststo: logit low lwt
	eststo: logit low smoke age lwt ht
	esttab, nogap wide
	lrtest est1 est2

	*cox-snell r2
	reg low smoke age lwt ht ui
	logit low smoke age lwt ht ui
	di 1-(e(ll) / e(ll_0))  //mcfadden
	di 1-(exp(e(ll_0))/exp(e(ll)))^(-(2/e(N)))

	*aic
	qui logit low age lwt ht
	estat ic
	qui logit low age lwt ui
	estat ic


	
	
	
*multinomial logistic regression
	
	*	
	import delimited using "data/alligator.csv", clear
	encode food, gen(af)
	
	*mlogit
	mlogit af length, base(3)

	*change the case category
	mlogit af length, base(2)

	*plot predicted probabilities
	mlogit af length, base(3)
	margins, at(length=(1.24(0.1)3.89))
	marginsplot, noci	
	
	
	
	
	
	
	
*ordered logistic regression

	*
	webuse nhanes2f, clear
	keep health female black age diabetes
	keep if !missing(health, black, female, age, diabetes)
	compress
	
	*ologit
	ologit health female black age
	
	*predicted probability and visualization
	su age
	margins, at(age=(20(1)74)) //predict(outcome(5))
	marginsplot

	*brant-wald test of parallel regression assumption
	ologit health female black age
	findit oparallel
	oparallel
	findit spost13_ado
	brant

	*gologit
	gologit2 health female black age
	mlogit health female black age, b(1)

	*model comparison
	est clear
	eststo: ologit health female black age
	eststo: ologit health female black age diabetes
	lrtest est1 est2
