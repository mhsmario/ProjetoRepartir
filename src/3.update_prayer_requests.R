#Projeto Repartir
###Scrip #3
###Objetivo: Enviar novos pedidos de oração para a aba "2.6 Oração" (na planilha 2)


# 0. Libraries ####
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 

##1. Obter os dados da planilha 2 do google sheets ----
Master <- "1JnO_oiTZNMxNepwwbmxV2LZA_ZvbVwW9iWfyZH8JBws"

#### --> Note que especificamos a aba que queremos usando 'sheet = [] '
triagem <- range_read(Master, sheet = "2.2.Triagem")

oracao <- range_read(Master, sheet = "2.6.Oracoes")

#2. Crie um DataFrame com os novo pedidos de oração----

pedidos_oracao <-  triagem[which(grepl("oração", triagem$`(11) Como a IIR pode te servir nesse momento?`)),]

last_id_prayer <- max(oracao$ID, na.rm = T)

new_prayer_requests <- pedidos_oracao[pedidos_oracao$ID > last_id_prayer,]

### --> Parar o script se não houver novos pedidos 
count_unique <- nrow(new_prayer_requests)
if (count_unique > 0) {
  Step3_msg1 <- paste0("Temos ", count_unique," pedido(s) novo de oração")
  #print(msg1)

  ### --> Algumas formatacoes necessarias do DataFrame 
  ora <- oracao[!is.na(oracao$ID),]
  
  pedidos_old_new <- as.data.frame(ora$ID)
  newrequests <- as.data.frame(new_prayer_requests$ID)
  colnames(pedidos_old_new) <- "ID"
  colnames(newrequests) <- "ID"
  pedidos_old_new <- rbind(pedidos_old_new, newrequests)
  
  #3. Adicione os novos pedidos a aba "2.6.Oracoes" ----
  
  range_end <- nrow(ora)  + nrow(pedidos_old_new) + 1
  
  range_write(Master, pedidos_old_new, sheet = "2.6.Oracoes", 
              range = paste0("A2:A",range_end), col_names = FALSE)
  
  Step3_msg2 <- paste0("A aba de orações foi atualizada.")
  
  Step3_msg <- paste0(Step3_msg1, Step3_msg2, sep = " > > ")
} 

if (count_unique < 0) {
  Step3_msg1 <- print("Tudo em ordem! Nenhum pedido novo :) Vamos parar por aqui, ok?")
  #stop("Atualizado. Script stopped!")
}



