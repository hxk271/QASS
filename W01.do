*hyun woo kim, chungbuk national university, 2023



*basic commands

	*help
	help
	help help
	
	*update
	update
	
	*when you want to quit
	exit
	
	
	
	
*labels
 
	*one-line labels
	
	/* multi-line labels
	   can
	   come
	   here  */

	   
	   
	   
*ctrl-d to implement your code

	*
	help
	update
	

	
	
	
*keep your log

	*
	help log
	
	*
	log using mylog.smcl
	log close
	
	*
	log using mylog.smcl, replace
	log close
	
	*
	view mylog.smcl
	
	
	
*open file

	*log
	log using mylog.smcl, replace
	
	*current folder
	cd
	pwd
	
	*files in the current folder
	dir
	
	*
	webuse auto
	

	
	
	
*take a look at your data
	
	
	*
	edit
	edit make weight

	*variable description
	describe
	
	*
	set more off, permanently

	*
	list
	list rep78
	list make in 10/20
	
	
*recode your data


	*
	generate newvar=mpg+headroom
	rename newvar newvar2
	drop newvar2
	
	replace rep78=-9 if rep78==.
	edit
	
	replace rep78=-9
	edit
	
	*start it over
	webuse auto, clear
	replace rep78=-9 if rep78==.
	edit
	
	*
	ed, nolabel
	replace rep78=1 if rep78==-9 & foreign==1
	
	
	
*close your log and file

	*
	save auto2, replace

	log close
	
	