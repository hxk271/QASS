*hyun woo kim, chungbuk national university, 2024


*single princpal component

	*Scores by Roger de Piles for Renaissance painters
	webuse "renpainters", clear

	graph twoway (scatter composition expression) ///
	             (lfit composition expression)
	
	*factoring
	factor composition expression, pcf
	eret list
	mat list e(L)      //factor loadings
	di e(L)[1,1]^2 + e(L)[2,1]^2         //replication of eigenvalue

	*regression-based scoring
	predict pc
	mat list e(Ev)                      //eigenvalues
	di e(L)[1,1] / e(Ev)[1,1]
	di e(L)[2,1] / e(Ev)[1,1]
	
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
	
	*check if there are items to be deleted
	alpha composition drawing colour expression, item

	*normalization
	foreach i of varlist composition drawing colour expression {
		qui su `i'
		gen `i'_std=(`i'-r(mean))/r(sd)
		}
	alpha *_std, item

	*alpha with normalized items
	alpha composition drawing colour expression, std




	

		
*Bartlett test of sphericity and KMO
	
	pwcorr

	*make sure "ssc install factortest"
	factortest composition drawing colour expression
	
	estat kmo
	
	