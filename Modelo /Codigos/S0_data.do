cls
clear all

glo path 	"C:\Users\et396\Dropbox"
glo enaho 	"${path}\BASES\ENAHO"
glo disel 	"${enaho}\DISEL-MTPE"
glo output 	"${path}\Docencia\Educate\Indicadores\S1"

/// Parte I
///============================================
/* 
1. Procesamiento de datos
2. Uso de codigos para generar informacion 
3. Sistematizacion de codigos 
*/
///============================================

foreach i in 2023 {
	use "${enaho}/`i'/Final/sumaria-`i'.dta",clear
	
	do "${disel}/3.- rDpto y rDpto2.do"
	do "${disel}/2.- rArea.do"
	do "${disel}/r0.-rpobre.do"
	
	egen rhogar = concat(conglome vivienda hogar)
	g rfactor= factor07*mieperho
	g ryear=`i'
	rename (estrato conglome ) (restrato rconglome)
	keep r*
	order rhogar rpobre r* 
	saveold "${output}/S1_Data_`i'.dta",replace
}

/// Parte II
///============================================
/// Carga de data
	u "${output}/S1_Data_2023.dta", clear
	d
	svyset rconglome [pweight=rfactor], strata(restrato)
	
	/// Using svy
	/// =======================================

	svy: mean rpobre
	svy: mean rpobre, over(rArea)
	povdeco rg [w=rfactor], varpl (rlinea)
	
	/// Export word (esttab)
	/// =======================================	
	/// Opcion 1
	/// =======================================
	cls
	eststo clear
	eststo m0: svy: mean rpobre rbrecha rseveri
	esttab m0 using "${tabla}/Report_0.rtf", replace /// 
	cells("b(label(Promedio) fmt(3)) se(label(Error Estandar) fmt(3))") ///
	title("Pobreza Monetaria - 2023") ///
	nonum label noobs nogaps
	
	eststo m1: svy: mean rpobre , over(rArea) 
	esttab m1 using "${tabla}/Report_0.rtf", append cells("b(label(Promedio) fmt(3)) se(label(Error Estandar) fmt(3))") /// 
	nogaps nonum label nomtitle noobs collabels(none) ///
	coeflab(c.rpobre@1.rArea "Urbano" /// 
	c.rpobre@2.rArea "Rural" )

	
	/// Opcion 2
	/// =======================================
	label var rpobre "Pobreza"
	*label var rpobre "Pobreza"
	label var ryear "A\~{o}"
	
	svy : mean rpobre 
	outreg using "${tabla}\\Report_2004.doc", replace addrows("************") ///
	stat(b se ci) nosubstat bdec(4) varlabels ///
	ctitle("Variable","Porcentaje", "Error Estandar", "Intervalo 95%") ///
	title("Evolucion Monetaria Pobreza") ///
	note(""\"Fuente: ENAHO 2023")
	
	svy : mean rpobre , over(rArea)
	outreg using "${tabla}\\Report_2004.doc", append addrows("************")  ///
	stat(b se ci) nosubstat bdec(4) varlabels ///
	coeflab(c.rpobre@1bn.rArea "urbano" c.rpobre@2.rArea "Rural") ///
	ctitle("","Porcentaje", "Error Estandar", "Intervalo 95%") ///
	title("Evolucion Monetaria Pobreza") ///
	note(""\"Fuente: ENAHO 2023")
	
	svy : mean rpobre ,over(rDpto)
	outreg using "${tabla}\\Report_2004.doc", append  ///
	stat(b se ci) nosubstat bdec(4) varlabels ///
	ctitle("","Porcentaje", "Error Estandar", "Intervalo 95%") ///
	title("Evolucion Monetaria Pobreza") ///
	note(""\"Fuente: ENAHO 2023")	
	
	/// Parte III
	/// Patrones
	/// ===========================================
	
	preserve
	
	collapse (mean) rpobre rg ry [iw=rfactor], by(rDpto)
	scatter (rpobre rg), ///
	legend( label(1 "Pobreza (=1)") label(2 "Gasto Promedio (S/.)"))
	export "Fig1.png",replace
	
	restore
	
	/// Parte III
	/// Estadisticas significativas
	/// =============================================
	u "${output}//S1_Data.dta",clear
	tab ryear
	keep if ryear>2021
	g rdiff =(ryear>=2023)
	
	svyset rconglome [pweight=rfactor], strata(restrato)
	svy: reg rpobre rdiff
	
	
	