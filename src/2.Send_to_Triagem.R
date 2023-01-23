#Projeto Repartir
###Scrip #2
###Objetivo: Enviar as respostas novas para a aba Triagem.
 

# 0. Libraries ####
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 

rm(list = ls()) #Clear workspace

##1. Obter os dados das planilhas 1 e 2 do google sheets ----

###IDs de cada planilha. 
#### --> Note que as abas não tem um ID especifico, apenas a planilha tem.
Master <- "1JnO_oiTZNMxNepwwbmxV2LZA_ZvbVwW9iWfyZH8JBws"
Respostas <- "1GY2UKauV07TkhAmOPRYL_7xFXGVVEQll-SIGWDt-jP4"

#### --> Note que especificamos a aba que queremos usando 'sheet = [] '
respostas <- range_read(Respostas, sheet = 1)

triagem <- range_read(Master, sheet = "2.2.Triagem")

#2. Crie um DataFrame com os novo pedidos ----

last_id <- max(triagem$ID, na.rm = TRUE) #Encontrar o ultimo ID

novas_respostas <- respostas[respostas$ID > last_id,]

novas_respostas$`(6) Complemento` <- as.character(novas_respostas$`(6) Complemento`)

novas_respostas$`(6) Complemento` <- ifelse(is.na(novas_respostas$`(6) Complemento`), "0", novas_respostas$`(6) Complemento`)

### --> Parar o script se não houver novos pedidos 

if (nrow(novas_respostas) > 0) {
  Step2_msg1 <- paste0("Encontramos ", nrow(novas_respostas), " IDs novos! Vamos copiar essas respostas novas para a aba Triagem, ok?")
  #print(msg)

  #3. Adicione os novos pedidos a aba "2.2.Triagem" ----
  
  sheet_append(Master, novas_respostas, sheet = "2.2.Triagem")
  
  #### --> Mensagens de confirmação caso o script seja rodado como "source".
  Step2_msg2 <- paste0(nrow(novas_respostas), " foram copiados!")
  novos_ids <- novas_respostas$ID
  
  list_of_new_ids_to_print <- "Os novos IDs foram:"
  for (i in novos_ids) {
    
    list_of_new_ids_to_print <- paste0(list_of_new_ids_to_print, i, "; ")
  }
  
  Step2_msg3 <- list_of_new_ids_to_print
  
  #Gather all messages into one
  Step2_msg <- strwrap(paste0(Step2_msg1, Step2_msg2, Step2_msg3, sep = " >>" ))
  
  #print(Step2_msg2)
  #print(Step2_msg3)
  
  } 

if (nrow(novas_respostas) < 1) {
  Step2_msg <- print("Tudo em ordem! Nenhum pedido novo :) Vamos parar por aqui, ok?")
  #stop("Atualizado. Script stopped!")
}