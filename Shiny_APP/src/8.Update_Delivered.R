#Projeto Repartir
###Scrip #9
###Objetivo: Atualizar as planilhas 2 e 3 ultilizando os dados do formulario de entregas.


rm(list = ls())

##0. Libraries ####
  
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 
library(readr)

library(ona)
library(keyring)

#setwd("~/Documents/IIR - NG/COVID19")

##1. Obter os dados da aba 2.2 e da planilha "Dados_ONA" do google sheets ----

Central_entregues <- "[Sheet_id omitted]"
central <- range_read(Central_entregues, sheet = "Dados_ONA")

Master <- "[Sheet_id omitted]"
Triagem <- range_read(Master, sheet = "2.2.Triagem")

Logistics <- "[Sheet_id omitted]"

fase_do_repartir <- 5

##2. Obter os dados do ONA (site do formulario de entrega)----

## --> Coloca as informações de login do ONA

form_id <- "Repartir_form_phaseV"
account <- "[mitted]"
username <- "[omitted]"
## --> O passo a seguir precisa ser feito apenas na primeira vez que o script é rodado.
   ##Store your password securely in R :D
   #keyring_create("Onacredentials")
   #key_set("ona", keyring = "Onacredentials")

ona_respostas <- onaDownload(form_id, username, username, pass = "[Omitted]")
#                             key_get("ona", keyring = "Onacredentials"))
#keyring_lock("Onacredentials")

#ona_respostas <- read_csv("~/Documents/IIR.NG/Repartir_app/Repartir_form_phaseV_2022_06_24_17_54_46_786193.csv")

ona_respostas <- as.data.frame(ona_respostas)

ona_nao_entregues <- ona_respostas[ona_respostas$A_cesta_foi_entregue == "n_o_foi_poss_vel_entregar_a_ce",]

ona_respostas <- ona_respostas[ona_respostas$A_cesta_foi_entregue != "n_o_foi_poss_vel_entregar_a_ce",]

# 2.1 ONA Data integrity Check #####
dups <- which(duplicated(ona_respostas$Qual_o_ID_da_entrega))

dups2 <- ona_respostas$Qual_o_ID_da_entrega[dups]
for (i in dups2) {
  
  t <- ona_respostas[ona_respostas$Qual_o_ID_da_entrega == i,]
  keep <- t$A_cesta_foi_entregue[1] == t$A_cesta_foi_entregue[2]
  
  if (keep == F) {
    dups2 <- dups2[dups2 != i]
    ids_row <- which(grepl(i, ona_respostas$Qual_o_ID_da_entrega))
    ids_row <- ids_row[1]
    ona_respostas <- ona_respostas[-ids_row,]
  }
    
  }

if (length(dups2) > 1) {
  Step8_msg1 <- paste0("WARNING, WARNING, WARNING. Data integrity issue!")
  Step8_msg2 <- paste0("2+ formulários com o mesmo ID. São eles: ", dups2)
  Step8_msg3 <- paste0("Cheque as respostas de cestas entregues no site do ONA.io. E refaça esse passo. ")
  #print(msg)
  
  #stop("Will stop the script now. Please fix the issue and try again.")
  Step8_msg <- paste0(Step8_msg1, Step8_msg2, Step8_msg3, sep =  " >>" ) 
} 
# 2.1.2 - If-statement ----
if (length(dups) < 1) {
  Step8_msg1 <- "Tudo certo com os dados dos formulários de entrega! Data looks good, no issues found :)"


# 3. Identifique os IDs que receberam a(s) cesta(s) ----
ona_entregues <- ona_respostas[ona_respostas$A_cesta_foi_entregue == "sim__entregamos_a_cesta",]

ona_entregues$Quantas_cestas_foram_entregues <- gsub("_cesta|_cestas",
                                                     "", ona_entregues$Quantas_cestas_foram_entregues)

# 3.1 Identifique os IDs que NAO receberam a cesta(s) ----
#ona_nao_entregues <- ona_respostas[ona_respostas$A_cesta_foi_entregue != "sim__entregamos_a_cesta",]

###4. ENTREGUES ####
## --> Vamos atualizar: (1) a planilha central de entregas, 
   ## --> (2) a aba 2.4,
   ## --> (3) a aba 3.2,
   ## --> (4) a aba 2.3,

#4.1 Criar DF para ser anexada a tabela CENTRAL de entregas

ona_e <- ona_entregues[, c(8,10,11,12,13:17,18,20:24,25)]
colnames(ona_e) <- c("ID", names(central[9:23]))
##Ajustar a fase
ona_e$Fase <- fase_do_repartir

tri <- Triagem[, c(1:3,7,9,11,10,15)]
t <- left_join(tri, ona_e, by = "ID" )
t <- t[t$A_cesta_foi_entregue == "sim__entregamos_a_cesta",]
t <- t[!is.na(t$ID),]
ids_accounted <- which(t$ID %in% central$ID)
#new_ids <- t[-ids_accounted,]

new_ids <- t %>%
  filter(!ID %in% ids_accounted)

# 4.1.1 Else-statement ----
if (nrow(new_ids) == 0) {
  Step8_msg2 <- "Maneiro! Parece que já está tudo atualizado."
  #stop("Atualizado. Script stopped!")
  
  Step8_msg <- paste0(Step8_msg1, Step8_msg2, sep =  " >>" )
} 

if (nrow(new_ids) > 0) {

# 4.2. Write updated delivery data in CENTRAL Sheet ####
sheet_append(Central_entregues, new_ids, sheet = 1)
  Step8_msg2 <- "Planilha CENTRAL foi atualizada."

#4.3 Write updated delivery data na aba "2.4.Entregues" ####
central <- range_read(Central_entregues, sheet = "Dados_ONA")
central_fase <- central[central$Fase == fase_do_repartir,]
central_fase <- central_fase[!is.na(central_fase$ID),]
range_write(Master, central_fase, sheet = "2.4.Entregues",
            col_names = T,
            reformat = F)

Step8_msg2 <- "Planilha 2 (Master) aba 2.4.Entregues foi atualizada."
#4.4. Tick the checkbox na aba 3.2.Preencher----

Preencher <- range_read(Logistics, sheet = "3.2.Preencher")

for (i in new_ids$ID) {
  
  row_new <- which(grepl(i, new_ids$ID)) 
  row_p <- which(grepl(i, Preencher$ID)) 
  
  Preencher$`Entregue?`[row_p] <- paste0("Sim (",new_ids$Dia_e_hora_da_entrega[row_new],")")
  
}

Entregues <- as.data.frame(Preencher$`Entregue?`)

range_write(Logistics, Entregues, sheet = "3.2.Preencher",
            range = "U2", 
            col_names = F,
            reformat = F)

Step8_msg3 <- "Planilha 3 (Master) aba 3.2.Preencher foi atualizada."

#4.5. Limpar os IDs da aba 2.3.Transporte_Master ----

Transporte <- range_read(Master, sheet = "2.3.Transporte_Master")

for (i in new_ids$ID) {
  
  row_new <- which(grepl(i, new_ids$ID)) 
  row_p <- which(grepl(i, Transporte$ID)) 
  Transporte$ID[row_p] <- NA
}

clear_ids <- as.data.frame(Transporte$ID)

range_write(Master, clear_ids, sheet = "2.3.Transporte_Master",
            range = "A2", 
            col_names = F,
            reformat = F)

Step8_msg4 <- "Planilha 2 (Master) aba 2.3.Transporte_Master foi atualizada."

#8. Update Triagem IDs from Transporte sheet ####

Step8_msg5 <- paste0("Foram atualizadas ", nrow(new_ids), " entregas!")
Step8_msg6 <- paste0("O ID das novas entregas foram: ", new_ids$ID)

# print(msg)
# print(msg2)


#5. CESTAS NÃO ENTREGUES-----

ona_N_e <- ona_nao_entregues[, c(8,10,11,12,13:17,18,20:24,26)]
colnames(ona_N_e) <- c("ID", names(central[9:23]))
ona_N_e$Fase <- fase_do_repartir

t_nao <- left_join(tri, ona_N_e, by = "ID" )
t_nao <- t_nao[!is.na(t_nao$ID),]
t_nao <- t_nao[!is.na(t_nao$A_cesta_foi_entregue),]

ids_n_accounted <- which(t_nao$ID %in% central$ID)
if (length(ids_n_accounted) > 0) {
  new_nao_ids <- t_nao[-ids_accounted,]
}

if (length(ids_n_accounted) == 0) {
  new_nao_ids <- t_nao
}

#5.1 Atualizar a aba 3.2.Preencher
Preencher <- range_read(Logistics, sheet = "3.2.Preencher")

for (i in new_nao_ids$ID) {
  
  row_new <- which(grepl(i, new_nao_ids$ID)) 
  row_p <- which(grepl(i, Preencher$ID)) 
  
  Preencher$`Entregue?`[row_p] <- paste0("Não. Obs: ", new_nao_ids$Notes ," (" ,new_nao_ids$Dia_e_hora_da_entrega[row_new],")")
  
}

Entregues <- as.data.frame(Preencher$`Entregue?`)

range_write(Logistics, Entregues, sheet = "3.2.Preencher",
            range = "U2", 
            col_names = F,
            reformat = F)

Step8_msg7 <- "Planilha 3 aba 3.2.Preencher foi atualizada marcando alguma cesta(s) que tentamos entregar mas não deu certo."

Step8_msg <- strwrap(paste0(Step8_msg1, Step8_msg2, Step8_msg3,
                            Step8_msg4, Step8_msg5, Step8_msg6,
                            Step8_msg7, sep = " >>" ))


  } # End else-statement line 
} #End if-statement line 81
