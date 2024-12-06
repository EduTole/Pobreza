**************************************************
*PASO 1 : Extraccion de informacion
**************************************************

* Extraer informacion de internet
* Procesar la informacion en la carpetas
* 2020 -2023
*"/iinei/srienaho/descarga/STATA/737-Modulo77.zip"

cls
clear all
gl path "C:\Users\et396\Dropbox"
gl ubicacion "${path}\BASES\ENAHO" 
cd "${ubicacion}"
dir
cap mkdir "$ubicacion"
								
if 1==1{

	mat ENAHO=(737\759\784\906)
	mat MENAHO=J(4,31,0)
	mat MENAHO[1,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	mat MENAHO[2,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	mat MENAHO[3,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	mat MENAHO[4,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	
}
matlist ENAHO
matlist MENAHO

forvalues i=20/23{
	local year=2000
	local year=`year'+`i'
	local t=`i'-19
	
	cd "$ubicacion"
	cap mkdir `year'
	cd `year'
	
	cap mkdir "Download"
	cd "Download"
	
	
*Modulo 34 --> sumaria pobreza
	scalar r_enaho=ENAHO[`t',1]
		foreach j in  26 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local x=r_menaho
		display "`x'" " " "`year'" " " "`mod'"
		cap copy http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`mod'-Modulo`x'.zip  enaho_`year'_mod_`x'.zip 
		cap unzipfile enaho_`year'_mod_`x'.zip, replace
		cap erase enaho_`year'_mod_`x'.zip
		}		
}

/// PARTE II
/// Exportar hacia carpeta
* 1. Extraer base .dta
* 2. Colocarlo en una carpeta de nombre Final
*------------------------------------------------------		
global ubicacion "${path}\BASES\ENAHO" 


if 1==1{
	mat ENAHO=(737\759\784\906)
	mat MENAHO=J(4,7,0)
	mat TENAHO=J(4,7,0)
	
	mat MENAHO[1,1]=(1,2,3, 4,5, 77, 85)
	mat MENAHO[2,1]=(1,2,3, 4,5, 77, 85)
	mat MENAHO[3,1]=(1,2,3, 4,5, 77, 85)
	mat MENAHO[4,1]=(1,2,3, 4,5, 77, 85)
	
	mat TENAHO[1,1]=(100, 200, 300, 400, 500,77,34)
	mat TENAHO[2,1]=(100, 200, 300, 400, 500,77,34)
	mat TENAHO[3,1]=(100, 200, 300, 400, 500,77,34)
	mat TENAHO[4,1]=(100, 200, 300, 400, 500,77,34)
	
}

matlist MENAHO
matlist TENAHO

forvalues i=20/23{
	local year=2000
	local year=`year'+`i'
	local t=`i'-19

 if `year'<=2020{	
	
	cd "$ubicacion"
	cap mkdir `year'
	cd `year'
	global BaseFinal "${path}\BASES\ENAHO\\`year'\\Final"
	cap mkdir "$BaseFinal"
 
 
*Modulo 34 --> sumaria	
	scalar r_enaho=ENAHO[`t',1]
		foreach j in 7 {
		scalar r_menaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local x=r_menaho
		display "`x'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`x'\\sumaria-`year'.dta" "sumaria-`year'.dta"
		u "sumaria-`year'.dta",clear
		qui saveold "$BaseFinal\\sumaria-`year'.dta",replace
		}	
	}
		
	if `year'>=2021 {

	
	cd "$ubicacion"
	cap mkdir `year'
	cd `year'
	global BaseFinal "${path}\BASES\ENAHO\\`year'\\Final"
	cap mkdir "$BaseFinal"

*Modulo 34--> Sumaria	
	scalar r_enaho=ENAHO[`t',1]
		foreach j in 7 {
		scalar r_menaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_menaho
		local x=r_menaho
		display "`x'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`x'\\sumaria-`year'.dta" "sumaria-`year'.dta"
		u "sumaria-`year'.dta",clear
		qui saveold "$BaseFinal\\sumaria-`year'.dta",replace
		
		}
		
	}
		
 }
