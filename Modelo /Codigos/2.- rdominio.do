
******************************
******  Variable rdominio  ******
******************************

gen rdominio=.
replace rdominio=1 if dominio==8
replace rdominio=2 if dominio<=3
replace rdominio=3 if dominio>3 & dominio<=6
replace rdominio=4 if dominio>6 & dominio<=7

label var rdominio "Dominio geografico"
label define rdominio 1 "Lima" 2 "Costa" 3 "Sierra" 4 "Selva"
label values rdominio rdominio
