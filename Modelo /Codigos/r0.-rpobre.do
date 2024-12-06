***********************
* Calculo de pobreza
*	Brecha 
*	Severidad
*-------------------------------

	g rpond=factor07*mieperho 
	tab pobreza [iw=rpond]
	g rg=gashog2d/ mieperho/ 12
	* gasto
	label var rg "gasto mensual"
	g rlg= log(rg)
	label var rlg "ln gasto mensual"
	
	* ingreso 
	g ry = inghog2d / mieperho/ 12
	g rly= log(ry)
	label var rly "ln ingreso mensual"
	
	** ahorro
	g rahorro = (ry-rg)/ry
	label var rahorro "ahorro %"
	
	*g rnivelsocio= estrsocial
	
	g rpobre=(pobreza<=2)
	label var rpobre "Incidencia pobreza"
	label define rpobre 1 "Pobre" 0 "No Pobre"
	label values rpobre rpobre
*** Calculo de brecha de pobreza

	gen rbrecha=(linea-ry)/linea if rpobre==1
	replace rbrecha=0 if rpobre==0
	label variable rbrecha "Brecha de pobreza (%)"

*** Calculo de Severidad de pobreza total

	gen rseveri=rbrecha^2
	label variable rseveri "Severidad de la pobreza"
	
	g rmiembros= mieperho
	label variable rmiembros "Miembros del hogarr"
	
	g rlinea = linea
	label var rlinea "linea de pobreza total"
	