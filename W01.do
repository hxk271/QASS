*hyun woo kim, chungbuk national university, 2024



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
	   here.  */

	   
	   
	   
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
	
	*this will open data file on the web
	webuse auto
	

	
	
	
*take a look at your data
	
	
	*you can browse and edit your data file!
	edit
	edit make weight

	*variable description
	describe
	
	*this might help your headache!
	set more off, permanently

	*list of variables
	list
	list rep78
	list make in 10/20
	
	
	
	
*recode your data

	*generate a new variable!
	generate newvar=mpg+headroom
	rename newvar newvar2
	drop newvar2
	
	*replace missing values with -9 (Why?)
	replace rep78=-9 if rep78==.
	edit

	*think why this is wrong!
	replace rep78=-9
	edit
	
	*let us start it over
	webuse auto, clear
	replace rep78=-9 if rep78==.
	edit
	
	*recode variables with multiple conditions
	ed, nolabel
	replace rep78=1 if rep78==-9 & foreign==1
	
	
	
*close your log and file

	*save data file (and replace old one if any)
	save auto2, replace

	*now log will be closed
	log close
	
	