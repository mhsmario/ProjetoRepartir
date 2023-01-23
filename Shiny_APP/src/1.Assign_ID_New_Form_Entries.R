#Projeto Repartir
###Scrip #1
###Objetivo: Dar um ID para cada resposta recebida. 

# 0. Libraries ####
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 

##1. Get data from GSheets####

 ## --> Esse aqui é o ID da planilha que recebe as respostas do formulário. 
 ## --> O ID sempre está no final do URL da planilha. Por exemplo, no URL:
 ## --> https://docs.google.com/spreadsheets/u/4/d/1QVX6E2c47wSE4prd1Vsiu7dV0YGmwksOtXQJuqKAdWI/edit?usp=drive_web&ouid=101894962937210078853
 ## --> O ID está depois do "https://docs.google.com/spreadsheets/u/4/d/"

Respostas <- "1GY2UKauV07TkhAmOPRYL_7xFXGVVEQll-SIGWDt-jP4"

form_replies <- range_read(Respostas, sheet = 1)

form_replies <- form_replies[,-c(17:ncol(form_replies))] ##Remove os termos do projeto (disclaimer)

missing <- which(is.na(form_replies$ID))

#2. Essa parte do codigo checa se recebemos alguma resposta nova ----
if (length(missing) > 0) {
  
  Step1_msg1 <- paste0("Encontrei novas respostas! ", "Para ser mais especifico foram ", length(missing), " respostas novas")
  print(a)
  
  for (i in missing) {
    
    last_id <- max(form_replies$ID, na.rm = T)
    
    form_replies$ID[i] <- last_id + 1
    
  }
  
  new_ids <- length(missing) + last_id
  
  #3. Agora é preciso escrever os IDs na planilha -----
  ### -->  "1. Projeto Repartir (III) - IIR Brasil (respostas)" usando o ID da planilha que colocamos lá no começo.
  
  ids <- as.data.frame(form_replies$ID)
  range_end <- nrow(ids) + 1
  
  range_write(Respostas, ids, sheet = 1,
              range = paste0("A2:A",range_end), col_names = FALSE)
  
  Step1_msg2 <- print("Respostas novas já receberam um ID :D")
  
  Step1_msg <- paste0(Step1_msg1, Step1_msg2, sep = " > > ")
} 

if (length(missing) == 0) {
  Step1_msg1 <- print("Tudo em ordem! Nenhuma resposta nova :) Vamos parar por aqui, ok?")
  Step1_msg2 <- "Atualizado. Script stopped!"
  
  Step1_msg <- paste0(Step1_msg1, Step1_msg2, sep = " > > ")
}

### --> Cada resposta deve receber um ID novo


