*hyun woo kim, chungbuk national university, 2024


*dummy variable

	*highschool and beyond (200 cases)
	use "https://stats.idre.ucla.edu/stat/stata/notes/hsb2", clear

	*regression with a dummy variable
	hist write
	reg write female
	margins, by(female)        //predicted by gender
	bysort female: su write    //the means of writing score, by gender

	*regression with two dummy variable
	tab ses
	tab ses, nolabel
	bysort ses: su write    //the means of writing score, by ses
	tab ses, gen(ses)
	reg write ses1 ses3

	*use of factor variables
	reg write i.ses
	reg write b2.ses        //specify the base category
	margins, by(ses)

	*FYI: factor variable is also available in summarize command
	su write i.ses
	

	
	
	
*dummy variables in practice 1

	*National Longitudinal Survey, Young Women 14-26 years of age in 1968
	webuse "nlswork", clear
	drop if missing(ln_wage, union, race, grade, ttl_exp, c_city, south)

	*examine dependent and independent variables
	hist ln_wage
	tab union
	tab race
	tab race, gen(racecat)
	tab grade
	hist ttl_exp

	*is it correct?
	reg ln_wage union race grade ttl_exp

	*use of dummy variables
	reg ln_wage union racecat2 racecat3 grade ttl_exp

	*use of factor variables
	reg ln_wage i.union i.race grade ttl_exp
	reg ln_wage i.union b1.race grade ttl_exp    //specify the base category

	*hierarchical regression models
	est clear
	eststo: reg ln_wage grade ttl_exp
	eststo: reg ln_wage grade ttl_exp i.union
	eststo: reg ln_wage grade ttl_exp i.union b1.race
	esttab
	esttab, stats(r2) nogap

	
	
	
	
*dummy variables in practice 2

	*clear up
	est clear
	
	*union with 0 and 1
	eststo: reg ln_wage grade ttl_exp i.union b1.race

	*union with -1 and 1
	recode union (0=-1) (1=1), gen(union_rec)
	eststo: reg ln_wage grade ttl_exp union_rec b1.race     //factor variable is not available
	
	*comparison
	esttab, stats(r2 F rmse) nogap

	
	
	
	
*threshold effect

	*1 if college graduated
	tab grade
	tab grade collgrad
	
	*model comparison
	est clear
	eststo: reg ln_wage grade
	eststo: reg ln_wage collgrad
	eststo: reg ln_wage i.grade
	esttab, r2 label wide

	*post-estimation
	ta grade       //compare 12.grade with 13.grade
	reg ln_wage i.grade
	test 12.grade=13.grade


	
	
	
*exception handling

	gen disadv=c_city==0 & south==1 & race==2

	est clear
	eststo: reg ln_wage i.union i.race grade ttl_exp
	eststo: reg ln_wage i.union i.race grade ttl_exp disadv 
	esttab, r2 label wide

	*if dummy indicator is unique to an observation
	gen unique=(idcode==1 & year==70)
	ta unique
	
	est clear
	eststo: reg ln_wage grade ttl_exp unique
	drop if unique==1
	eststo: reg ln_wage grade ttl_exp
	esttab, r2 label wide

	
	
	
	
	
*interaction terms practice 1
		
	*National Longitudinal Survey, Young Women 14-26 years of age in 1968
	webuse "nlswork", clear
	drop if missing(ln_wage, union, south, tenure)

	*regression with an interaction term (dummy x numerical)
	gen unionXtenure=union*tenure
	reg ln_wage union tenure unionXtenure
	reg ln_wage i.union c.tenure i.union#c.tenure
	reg ln_wage i.union##c.tenure

	*margins
	margins, at(tenure=(0(1)29)) by(union)
	marginsplot

	
	
	
	
*interaction terms practice 2

	*regression with an interaction term (numerical x numerical)
	gen ttl_expXage=ttl_exp*age
	reg ln_wage ttl_exp age ttl_expXage
	reg ln_wage ttl_exp age c.ttl_exp#c.age
	reg ln_wage c.ttl_exp##c.age
	
	*margins
	su ttl_exp age
	margins, at(ttl_exp=(0(1)29) age=(30 40 50))
	marginsplot

	*hierarchical regression models
	est clear
	eststo: reg ln_wage c.ttl_exp c.age
	eststo: reg ln_wage c.ttl_exp c.age c.ttl_exp#c.age
	esttab
	
	
	
	
	
	
	
*interaction terms practice 3

	*regression with an interaction term (dummy x dummy)
	gen unionXsouth=union*south
	reg ln_wage union south unionXsouth
	reg ln_wage union south i.union#i.south
	reg ln_wage i.union##i.south
	
	*margins
	margins, by(union south)
	marginsplot, xdim(union south) recast(bar)
