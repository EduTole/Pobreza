
cls
clear all

* ruta de carpetas 
glo path 		"C:\Users\et396\Dropbox"	
glo main 		"${path}/BASES/ENAHO"
glo disel		"${main}//DISEL-MTPE"
glo output 		"${main}//Salida_indicadores"	
glo codigo 		"${main}//Codigo_stata"



use "${output}\base_desigualdad_regiones.dta", clear

	preserve
	collapse (mean) rginidpto if rDpto==15, by(ryear)
	rename rginidpto ginilima
	tempfile base1
	saveold `base1',replace
	restore

	preserve
	collapse (mean) rginidpto, by(ryear)
	rename rginidpto gininacional
	tempfile base2
	saveold `base2',replace

	restore


	use `base1',clear
	merge 1:1 ryear using `base2',keep(match) nogen


	tw (line ginilima ryear ) (line gininacional ryear  ) , legend(label(1 "Lima") label(2 "Nacional") position(6) rows(1) cols(1)) xlabel(2010(1)2021) ylabel(0.25(0.05)0.4) xline(2012) ///
	xtitle("") ytitle("Desigualdad (Gini index)")
	
	use "${base}\base_desigualdad_regiones.dta", clear
	tab ryear
	
use "${output}\base_desigualdad_regiones.dta", clear
	
	/// Regresion 
	xtset rDpto ryear
	
	reg rginidpto L.rpbicrec  i.rDpto i.ryear, r	
	estimates store m1
	reg rginidpto L.rpbicrec  rinfo i.rDpto i.ryear, r	
	estimates store m2
	reg rginidpto L.rpbicrec rdesempleo rinfo i.rDpto i.ryear, r	
	estimates store m3
	
	estimates table m1 m2 m3, star b(%7.4f) stats(N ) ///
	keep(L.rpbicrec rdesempleo rinfo)