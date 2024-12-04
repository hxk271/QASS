*hyun woo kim, chungbuk national university, 2024


*mediation effect

	*data prep
	import delimited using "data/STARTUPS.csv", clear
	gen id=_n
	order id
	label var id "대학 아이디"
	label var startups "창업기업 수"
	label var research "대학 연구비 (100만 달러)"
	label var patents "특허 출원 수"
	label var duration "기술이전부서 연령(년)"
	compress
	
	*first regression
	reg startups duration research, beta
	
	*normalization of variables
	foreach i of varlist startups duration research {
		su `i'
		replace `i'=(`i'-r(mean))/r(sd)
		}
	
	*now betas are identical to raw coefficients
	reg startups duration research, beta
	
	*total effect of duration
	reg startups duration, beta
	scalar teff = _b[duration]
	di teff
	
	*direct effect of duration
	eststo: reg startups duration research, beta
	scalar deff = _b[duration]
	di deff
	
	*indirect effect of duration #2
	scalar ieff2 = _b[research]
	di ieff2
	
	*indirect effect of duration #1
	eststo: reg research duration, beta
	scalar ieff1 = _b[duration]
	di ieff1
	
	*total effect of duration
	di deff + (ieff1 * ieff2)
	di teff
	


	
	
	
	
*multiple mediators: not_smsa -> collgrad, union -> ln_wage
	
	*data prep
	webuse nlswork, clear
	keep if !missing(not_smsa, collgrad, union, ln_wage, south)
	est clear
	
	*normalization of variables
	foreach i of varlist not_smsa collgrad union ln_wage south {
		su `i'
		replace `i'=(`i'-r(mean))/r(sd)
		}
	
	*total effect
	eststo: reg ln_wage not_smsa south
	scalar teff=_b[not_smsa]
	
	*direct effect and two indirect effects
	eststo: reg ln_wage not_smsa collgrad union south
	scalar deff=_b[not_smsa]
	scalar ieff2_collgrad=_b[collgrad]      //via collgrad
	scalar ieff2_union=_b[union]            //via union  
	
	*the rest of two indirect effects
	eststo: reg collgrad not_smsa south
	scalar ieff1_collgrad=_b[not_smsa]      //via collgrad
	eststo: reg union not_smsa south
	scalar ieff1_union=_b[not_smsa]        //via union
	
	*total effect decomposition
	esttab, nogap                         //model 1 and 2 will suffice
	di (ieff1_collgrad*ieff2_collgrad) + (ieff1_union*ieff2_union) + deff
	di teff
	
	*percentages
	di deff/teff
	di (ieff1_collgrad*ieff2_collgrad)/teff
	di (ieff1_union*ieff2_union)/teff
	
	
	



*omitted variable bias

	*data prep
	webuse nlswork, clear
	drop if missing(age, race, nev_mar, c_city, collgrad, ln_wage, union, south)	

	*normalization of variables
	foreach i of varlist ln_wage union south {
		su `i'
		replace `i'=(`i'-r(mean))/r(sd)
		}
		
	*model specification: south (X) -> union (M) -> ln_wage (Y)
	global control "age c.age#c.age i.race nev_mar c_city collgrad"
	est clear

	*full model (with union)
	eststo: reg ln_wage union south $control	
	scalar b_f=_b[south]

	*reduced model (without union)
	eststo: reg ln_wage       south $control
	scalar b_r=_b[south]

	esttab, wide

	*omitted variable bias
	di b_r                 //total effect of south
	di b_f                 //direct effect of south via union
	di b_r - b_f           //indirect effect of south via union
	di (b_r - b_f) / b_r   //percentage

	
	
