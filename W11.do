*hyun woo kim, chungbuk national university, 2024



*linearity

	*transit data
	import delimited "data/transit.csv", clear
	graph twoway (scatter rider map) ///
	             (lfit    rider map) ///
				 (qfit    rider map)

	*scatterplot residues against y hat
	reg rider map
	predict res, residual
	predict yhat, xb
	graph twoway (scatter res yhat) ///
	             (lfit    res yhat) ///
				 (qfit    res yhat)
	rvfplot         //residual-vs-fitted plot

	*matrix scatterplot
	use "data/ATTEND.DTA", clear
	graph matrix termgpa priGPA ACT final atndrte hwrte, half
	reg termgpa priGPA ACT final atndrte hwrte
	predict res, res
	predict yhat, xb
	rvfplot
	
	
	
	
*full rank

	*perfect collinearity
	gen x3=x2				    //x3 is identical to x2
	reg y x1 x2 x3
	gen x4=0.5+(1.5*x2)         //x4 is a linear combination of x2
	reg y x1 x2 x4

	*eyeballing for multicollinearity
	webuse "bodyfat", clear
	corr triceps thigh midarm bodyfat
	est clear
	eststo: reg bodyfat tricep
	eststo: reg bodyfat        thigh
	eststo: reg bodyfat              midarm
	eststo: reg bodyfat tricep thigh
	eststo: reg bodyfat        thigh midarm
	eststo: reg bodyfat tricep       midarm
	eststo: reg bodyfat tricep thigh midarm
	esttab, r2

	*variance inflation factors
	reg bodyfat tricep thigh midarm
	vif
	reg tricep thigh midarm
	ereturn list
	scalar tolerance=1-e(r2)     //tricep's tolerance
	di 1/tolerance               //tricep's vif


	
	
	
*outlier detection
	
	*regress systolic blood pressure on covariates
	webuse "nhanes2", clear

	*(1) studentized residuals
	est clear
	eststo: reg bpsystol age sex i.race bmi
	predict rstudent, rstudent
	histogram rstudent
	eststo: reg bpsystol age sex i.race bmi if abs(rstudent)<5
	
	*(2) cook's distance
	quiet reg bpsystol age sex i.race bmi        //quietly!
	predict cook, cooksd
	histogram cook
	su
	return list
	eststo: reg bpsystol age sex i.race bmi if cook<4/`r(N)'
	esttab, r2

	*visualization
	lvr2plot
	
	
	
	
	
	
	
*zero conditional mean

	*transit data
	import delimited "data/transit.csv", clear
	reg rider map
	predict res, residual
	graph twoway (scatter res map) ///
	             (lfit    res map)

	*simulated data
	clear
	set obs 100
	set seed 1234
	help runform
	gen x1=runiform()*10
	help rnormal
	gen u=rnormal(0, 10)
	gen y=1.5*x1 - 2.5*(x1^2) + u
	
	*misspecified model
	reg y x1
	predict res1, res
	graph twoway (scatter res1 x1) ///
	             (lfit    res1 x1)
	
	*correctly specified model
	reg y c.x1##c.x1
	predict res2, res
	graph twoway (scatter res2 x1) ///
	             (lfit    res2 x1)
	
	

	
*homoscedasticity

	*simulated data
	clear
	set obs 1000
	set seed 1234
	gen x1=runiform()*10
	gen x2=runiform()*5*x1
	gen u=rnormal(0,10)
	gen y=1.5*x1 + 2.5*x2 + u

	*heteroscedasticity
	reg y x1        //mis-specified model
	predict res1, res
	graph twoway (scatter res1 x1) (lfit res1 x1)
	estat hettest   //breusch-pagan test
	
	*homoscedasticity
	reg y x1 x2
	predict res2, res
	graph twoway (scatter res2 x1) (lfit res2 x1)
	graph twoway (scatter res2 x2) (lfit res2 x2)
	estat hettest   //breusch-pagan test

	
	
	
*normality

	*
	webuse "nhanes2", clear
	reg bpsystol age sex i.race bmi
	predict res, res
	pnorm res    //pp plot