#Projeto Repartir
###Scrip #7
###Objetivo: Preparar uma lista de nomes para ser usada no script de Python (aka whatsapp robot).
## --> Note que o resultado final será um arquivo .txt, com os nomes em uma lista. Dai é só copiar e colar no script de python, ajustar o script de python e enviar as mensagens.

rm(list = ls()) ##Clear workspace

# 0. Libraries ####
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 
library(here)
library(lubridate)

logistica_sheet <- "[Sheet_id omitted]"

routes <- range_read(logistica_sheet, sheet = "3.4.Routes")
#routes <- range_read(logistica_sheet, sheet = "3.2.Preencher")
#routes <- routes[is.na(routes$`Entregue?`),]
routes <- routes[!is.na(routes$ID),]


user_resp <- readline(prompt = "Enter 1 = list of names that don't yet have
                    sent their location. Enter 0 = list of  all names.")

if (user_resp == 1) { 

## Get names that have not sent their location

#Use this to message those that haven't send the link yet
    no_locations <- routes %>%
      filter(is.na(Link))
    
    no_locations_names <- as.data.frame(no_locations$Nome)
    colnames(no_locations_names)[1] <- "Name"
    no_locations_names$ID <- as.data.frame(no_locations$ID)
    no_locations_names$Name <- trimws(no_locations_names$Name)
    no_locations_names$Name <- gsub("  ", " ", no_locations_names$Name)
    
    python_names <- list()
    for (i in no_locations_names$Name) {
      py_partial <- paste0('"',i,'"',',')
      python_names <- append(python_names, py_partial)
    }

}
#Use this if you want to send a msg to the list of people abt to receive a basket

if (user_resp == 0) {

    msg_before_delivery <- routes
    
    msg_before_delivery <- as.data.frame(msg_before_delivery$Nome)
    colnames(msg_before_delivery)[1] <- "Name"
    #msg_before_delivery$ID <- as.data.frame(msg_before_delivery$ID)
    msg_before_delivery$Name <- trimws(msg_before_delivery$Name)
    msg_before_delivery$Name <- gsub("  ", " ", msg_before_delivery$Name)
    
    python_names <- list()
    for (i in msg_before_delivery$Name) {
      py_partial <- paste0('"',i,'"',',')
      python_names <- append(python_names, py_partial)
    }

}

python_names2 <- paste0(python_names, collapse = ",")

python_names2 <- gsub(',,',',',python_names2)
python_names2 <- gsub('\\', '',python_names2, fixed = TRUE)

pth <- paste0(here::here("src", "python_names"))

print(pth)

##DOWNLOAD

#setwd("/Users/mariosaraiva/Documents/IIR.NG/COVID19/src/python_names")

python_names_gr1 <- python_names2[1]

writeLines(python_names_gr1, paste0("python_names_", today(), ".txt", sep = ""))
