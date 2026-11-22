*hyun woo kim, chungbuk national university, 2024


*single princpal component

	*Scores by Roger de Piles for Renaissance painters
	webuse "renpainters", clear

	graph twoway (scatter composition expression) ///
	             (lfit composition expression)
	
	*factor
	factor composition expression, pcf
	eret list
	mat list e(L)      //factor loadings
	di e(L)[1,1]^2 + e(L)[2,1]^2         //eigenvalue

	*regression-based scoring
	predict pc
	mat list e(Ev)                      //eigenvalues
	di e(L)[1,1]/e(Ev)[1,1]
	di e(L)[2,1]/e(Ev)[1,1]
	
	egen z1=std(composition)
	egen z2=std(expression)
	gen pc_=(e(L)[1,1]/e(Ev)[1,1])*z1 + (e(L)[2,1]/e(Ev)[1,1])*z2
	drop z1 z2
	
	*factor loadings are correlation coefficients
	pwcorr pc composition expression

	
	
	
	
*two princpal components

	factor composition drawing colour expression, pcf
	
	*extracting the principal components
	screeplot, yline(1)
		
	*eigenvalues
	di e(L)[1,1]^2 + e(L)[2,1]^2 + e(L)[3,1]^2 + e(L)[4,1]^2
	
	*proportions
	di e(Ev)[1,1] / (e(Ev)[1,1] + e(Ev)[1,2] + e(Ev)[1,3] + e(Ev)[1,4])
	
	*communality and uniqueness
	scalar communal = e(L)[1,1]^2 + e(L)[1,2]^2
	di communal
	di 1 - communal
	
	*regression-based scoring
	predict pc1 pc2
	di e(L)[1,1]/e(Ev)[1,1]
	
	*factor loadings are correlation coefficients
	pwcorr pc1 composition drawing colour expression
	
	graph twoway (scatter pc2 pc1, mlabel(painter))

	

	
	
	
	
	
	
	
	
*rotation

	*orthogonal rotation
	factor composition drawing colour expression, pcf
	rotate
	rotate, blank(.4)
	predict pc1o pc2o
	pwcorr pc1o pc2o
	
	*oblique rotation
	factor composition drawing colour expression, pcf
	rotate, promax(3) blank(.4)
	predict pc1p pc2p
	pwcorr pc1p pc2p
	
	
	
	
	
		   
*reliability
		   
	*cronbach's alpha
	alpha composition drawing colour expression
	alpha composition drawing colour expression, asis
	
	*check if there are items to be deleted
	alpha composition drawing colour expression, item
	alpha composition drawing expression, item
	alpha composition expression, item

	*normalization
	foreach i of varlist composition drawing colour expression {
		qui su `i'
		gen `i'_std=(`i'-r(mean))/r(sd)
		}
	alpha *_std, item

	*alpha with normalized items
	alpha composition drawing colour expression, std




	
	
	

	
	
*practice

	import delimited using "data/candidates.csv", clear
	
	*first: run it anyway
	global pc1 "academicrecord appearance communication companyfit experience jobfit letter likeability organization potential resume selfconfidence"
	factor $pc1, pcf
	rotate, blank(.4)

	*second: sort by factor loadings
	global pc1 "potential experience academicrecord jobfit"
	global pc2 "organization communication companyfit"
	global pc3 "selfconfidence appearance likeability"
	global pc4 "letter resume "
	factor $pc1 $pc2 $pc3 $pc4, pcf
	rotate, blank(.4)

	*third: eliminate pcs with high cross-loadings
	global pc1 "experience potential academicrecord" //jobfit
	global pc2 "organization communication"  // companyfit
	global pc3 "selfconfidence appearance likeability"
	global pc4 "letter resume "
	factor $pc1 $pc2 $pc3 $pc4, pcf
	rotate, blank(.4)

	*fourth: eliminate a pc with high cross-loadings
	global pc1 "academicrecord potential experience" //jobfit
	global pc2 "organization communication"  // companyfit
	global pc3 "appearance likeability" //selfconfidence
	global pc4 "letter resume "
	factor $pc1 $pc2 $pc3 $pc4, pcf
	rotate, blank(.4)

	*fourth: eliminate a pc with high cross-loadings
	global pc1a "organization communication"  // companyfit
	global pc1b "appearance likeability" //selfconfidence 
	global pc2 "academicrecord potential experience" //jobfit
	global pc3 "letter resume "
	factor $pc1a $pc1b $pc2 $pc3, pcf
	rotate, blank(.4)
	predict pc1 pc2 pc3

	*internal consistency
	alpha $pc1a $pc1b, item
	alpha $pc2, item
	alpha $pc3, item

	*bartlett test of sphericity and kmo
	pwcorr
	factortest $pc1a $pc1b $pc2 $pc3     //ssc install factortest
	estat kmo
	
	