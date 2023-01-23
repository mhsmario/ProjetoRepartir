#Projeto Repartir
###Scrip #6
###Objetivo: Atualizar a planilha central de contatos.

## --> Note que o objetivo é que novos contatos sejam adicionados no Google Contacts (por meio da conta do Projeto). Para isso certifique-se que 
## (1) os novos contatos foram devidamente atualizados na planilha "Contatos_Beneficiarios", 
## (2) baixe a planilha "Contatos_Beneficiarios" no formato CSV e faça o upload no Google Contacts (usando a conta iirbrasilsocial@gmail.com), 
## (3) no Google Contacs é preciso adicionar recentemente adicionados a sua lista de contatos de fato, 
## (4) o último passo é checar se os contatos foram devidamente autalizados no celular/whatsapp do projeto.


rm(list = ls()) ##Clear workspace

# 0. Libraries ####
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4)
library(stringr)

##1. Obter os dados das abas 2.2 e da planilha "Contatos_Beneficiarios" do google sheets ----
Master_Triagem <- "[Sheet_id omitted]"
Contatos <- "[Sheet_id omitted]"

triagem <- range_read(Master_Triagem, sheet = 2)
contacts <- range_read(Contatos, sheet = 1)

lastupdate <- nrow(contacts)
##2. Econtrar os IDs novos na aba 2.2 que ainda não estão planilha "Contatos_Beneficiarios" ----
contacts$Nickname <- as.numeric(contacts$Nickname)
#old_ids <- max(contacts$Nickname)

alreadyimported <- which(triagem$ID %in% contacts$Nickname)
triagem_new <- triagem[-alreadyimported, ]


### --> Parar o script se não houver novos pedidos 
if (nrow(triagem_new) > 0) {
  
  Step5_msg1 <- paste0("Encontrei IDs novos!", "Para ser mais especifico foram ", nrow(triagem_new), " IDs novos")
  #print(a)
  

##3. Adicionar novas fileiras ----

for (i in 1:nrow(triagem_new)) {
  
  #New Row
  k <- nrow(contacts) + 1
  
  contacts[k, 1] <- triagem_new[i,3] #Name
  contacts[k, 12] <- triagem_new[i,1] #Nickname
  contacts[k, 17] <- triagem_new[i,9] #Location
  contacts[k, 25] <- "Fase V" #Fase
  contacts[k, 31] <- triagem_new[i,4] #Phone1
  contacts[k, 32] <- triagem_new[i,5] #Phone2
}

  #Formatar os dados para que estejam no mesmo formato da planilha de contatos.
  ### --> Note que a planilha dos contatos esta no formato requerido para ser uploaded no Google Contacts. Por isso precisamos de alguns ajustes a mais.
  
  contacts <- contacts[!is.na(contacts[,31]),]
  contacts <- contacts[!duplicated(contacts[,1]),] #remove duplicated names
  contacts$Notes <- as.character(contacts$Notes)
  
  #Checar por dados (telefone ou nome) duplicados, se encontrar escreva uma nota a respeito 
  u_contacts <- contacts[!duplicated(contacts[,31]),]
  df_dups <- contacts[duplicated(contacts[,31]),]
  
  for (i in 1:nrow(df_dups)) {
    
    tel <- paste0(df_dups[i,31])
    
    h <- which(grepl(tel, u_contacts$`Phone 1 - Value`))
    
    notes <- paste0("Mesmo tel: ",df_dups$Name[i], "(ID = ", df_dups$Nickname[i], ") | ")
    
    u_contacts[h,26] <- paste0(paste0(u_contacts[h,26]), notes)
  }
  
  u_contacts$Notes <- gsub("NAMesmo", "Mesmo", u_contacts$Notes)
  u_contacts$Name <- str_to_title(tolower(u_contacts$Name))
  u_contacts[,1:32] <- lapply(u_contacts[,1:32], as.character)
  
##4. Adicione o resultado na aba 3.2.Preencher" ----  
  write_sheet(u_contacts, Contatos, sheet = 1)

  lastupdate2 <- lastupdate + 1
  
  #Downloadable file
  NovosContatos_csv <- u_contacts[lastupdate2:nrow(u_contacts),]

  Step5_msg2 <- paste0("Foram adicionados ", nrow(triagem_new), " novos contatos.")
  
  Step5_msg3 <- "Os novos IDs foram:"
  novos_ids <- triagem_new$ID
  #Loop to create a one character vector to print msg in Shiny App.
  for (i in novos_ids) {
    Step5_msg3 <- paste0(Step5_msg3, i, "; ")
  }
  
  
  Step5_msg4 <- "!!! Agora, por favor, faça o download da planilha no formato CSVP e manualmente faça o upload no Google Contacts."
#print(msg1)
# print(msg2)
# print(msg3)
# print(msg4)

  Step5_msg <- paste(Step5_msg1, Step5_msg2, Step5_msg3, Step5_msg4, sep = " > > ")
  
} 

if (nrow(triagem_new) < 0) {
  Step5_msg <- print("Tudo em ordem! Nenhum ID novo :) Vamos parar por aqui, ok?")
  #stop("Atualizado. Script stopped!")
}
