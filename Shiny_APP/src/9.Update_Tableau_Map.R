#Projeto Repartir
###Scrip #11
###Objetivo: Atualizar a planilha Tableau Dashboard Map - Ajuda durante a Covid19

rm(list = ls())

##0. Libraries####
library(here)
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 


##1. Obter os dados da aba 3.2 e planilha Cestas.Entregues do google sheets ----


Central_entregues <- "[Sheet_id omitted]"
central <- range_read(Central_entregues, sheet = "Dados_ONA")

tableau_map <- "[Sheet_id omitted]"
map <- range_read(tableau_map, sheet = "Map")

##2. Create dataframe

ids_map <- map$ID

not_in_map <- central[!central$ID %in% ids_map,]


if(nrow(not_in_map) == 0){
}
  Step9_msg <- paste0(" O mapa parece estar atualizado!")

if(nrow(not_in_map) > 0){

  new_to_map <- not_in_map[, c("ID", "(7) Região (bairro/cidade)",
                             "(8) CEP", "latitude",
                             "longitude", "A_cesta_foi_entregue","Fase")] 

  map_c_names <- names(map)
  
  new_to_map$`E.Localizacao?` <- ""
  new_to_map <- new_to_map[, c(1,2,3,8,4,5,6,7)]
  colnames(new_to_map) <- map_c_names
  
  #Append Sheet
  
  map_final <- rbind(map, new_to_map)
  
  ##Write results to googlesheets
  
  range_write(tableau_map, map_final, range = "A1", col_names = TRUE,
              sheet = "Map")

Step9_msg <- paste0("O mapa foi atualizado com", nrow(not_in_map), "entregas!")
} #end of if-statement
