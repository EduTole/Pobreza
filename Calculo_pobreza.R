# 01----------------------------------
# Directori de archivos
setwd("D:/Dropbox/EcoMaster/RTaller/Diapositivas/Pobreza/Pobreza")

# 02 ---------------------------------
# Se carga las librerias
library(foreign)
library(tidyverse)

# 03 ---------------------------------
#cargar la informacion
sumaria <- read.dta("D:/Dropbox/BASES/ENAHO/2019/sumaria-2019.dta")
sumaria %>% str()

#calculo de las varables
pobreza <- sumaria %>% 
  mutate(ponderador=factor07*mieperho,
         pobre=ifelse(pobreza !="no pobre",1,0),
         dpto=str_sub(ubigeo,1,2))

# 04 ----------------------------------------
# libreria de factor de expansión
library(Hmisc)
library(plyr)

Pobreza_dpto <- ddply(pobreza, ~dpto,summarise,
                 pobreza=wtd.mean(pobre,ponderador,na.rm = TRUE))
#redondear valores
Pobreza_dpto <- Pobreza_dpto %>% 
  mutate(pobreza=round(pobreza,2))

