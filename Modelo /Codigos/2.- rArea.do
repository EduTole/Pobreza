
******************************
******  Variable rArea  ******
******************************

gen rArea=2-(estrato>=1 & estrato<=5)

label var rArea "Área geográfica"

label define rArea 1 "Urbano" 2 "Rural"
label values rArea rArea
