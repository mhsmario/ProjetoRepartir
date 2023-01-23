#Projeto Repartir
###Scrip #4
###Objetivo: Escrever os IDs que estão na aba "3.1.Main.Transporte" para a aba
### "3.2.Preencher" 
## --> Note que a aba "3.1.Main.Transporte" é apenas um espelho da aba "2.3.Transporte_Master". Isso acontece para preservar a privacidade dos dados, assim permitindo criar uma camada de acesso diferente da planilha 2 e 3. 


rm(list = ls()) ##Clear workspace

# 0. Libraries ####
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 

##1. Obter os dados das abas 3.1 e 3.2 do google sheets ----

transporte_sheet <- "1vEQUpXUj48nV1zBYPc4S165hkaDBpiSbOWaBvt89ieo" #Sheet 3. Logistica

transporte <- range_read(transporte_sheet, sheet = "3.1.Main.Transporte")
preencher <- range_read(transporte_sheet, sheet = "3.2.Preencher")

#### --> Exluir linhas na coluna 'ID' que não tenham algum número de ID.
transporte <- transporte[!is.na(transporte$ID),]
preencher <- preencher[!is.na(preencher$ID),]

##2. Econtrar os IDs novos na aba 3.1 que ainda não estão na aba 3.2 ----

last_id <- max(preencher$ID, na.rm = T)

new_ids <- transporte[transporte$ID > last_id,]


### --> Parar o script se não houver novos pedidos 
if (nrow(new_ids) > 0) {
  
  Step4_msg1 <- paste0("Encontrei IDs novos!", "Para ser mais especifico foram ", nrow(new_ids), " IDs novos")
  ##3. Adicione o resultado na aba 3.2.Preencher"
  
  #Make sure you adjust the columns before writing.
  new_ids <- new_ids[,c(1:13)]
  
  range_start <- nrow(preencher) + 2 #Add +2 to account for column name and the next cell down in sheets 
  range_end <- range_start + nrow(new_ids)
  
  range_write(transporte_sheet, new_ids, 
              sheet = "3.2.Preencher", 
              range = paste0("A",range_start,":","M",range_end), 
              col_names = FALSE)
  
  
  Step4_msg2 <- "Tabela Preencher atualizada com novos ID :D"
  
  Step4_msg <- paste0(Step4_msg1, Step4_msg2, sep = " > > ")
} 

if (nrow(new_ids) == 0) {
  Step4_msg <- paste0("Tudo em ordem! Nenhum ID novo :) Vamos parar por aqui, ok?")
  #stop("Atualizado. Script stopped!")
}



