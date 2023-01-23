#Projeto Repartir
###Scrip #8
###Objetivo: Produzir o HTML para as entregas.
## --> Lembre-se de que o script ultilizará a coluna A (Regiao) para agrupar as rotas.

## --> Na seccao 4. não se esqueça de ajustar o "output_dir =" com o diretorio do seu computador para onde ira os HTMLs gerados.

## --> Esse script é o unico que depende de um outro script (TRANSPORTE.Rmd) para funcionar. É preciso que esse script esteja na mesma pasta que o script #8.

## --> Não se esqueça de atualizar o script TRANSPORTE.Rmd com o link do mapa das rotas e se preciso com o link do formulário de entrega.

#0. libraries####
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4)

library(knitr)
library(rmarkdown)
library(stringi)
library(here)

rm(list = ls())

##1. Obter os dados da aba "3.4.Routes" do google sheets ----
logistica_sheet <- "1vEQUpXUj48nV1zBYPc4S165hkaDBpiSbOWaBvt89ieo" #fase 5
routes <- range_read(logistica_sheet, sheet = "3.4.Routes")

routes$Região <- gsub(" ", "_", routes$Região)

routes <- routes[!is.na(routes$Região),]

# routes$`Ordem de entrega` <- as.character(routes$`Ordem de entrega`)
# routes$`Ordem de entrega` <- gsub("a","", routes$`Ordem de entrega`)
##2. Criar e separar os DataFrames usando a coluna A "Regiao" ----

if (ncol(routes) > 12) { 
  routes <- routes[, c(1:12)]
  }

colnames(routes) <- c("Equipe|Regiao","Bairro",	"Ordem.entrega",	"ID",	"Nome",
                      "Telefone",	"Endereco",	"Qtd",	"Ponto.de.Ref",	"Link",
                      "Latitude",	"Longitude")


routes$Link <- ifelse(grepl("https", routes$Link), 
                      paste("<a href='",routes$Link,"'>","Google Maps Link (ID=", 
                      routes$ID,") </a>", sep = ""),
                      paste("Missing link :(", sep = ""))

routes$Link <- ifelse(grepl("place", routes$Link), 
                      paste("Link muito largo. Use a Latitude e Longitude :(", sep = ""),
                      routes$Link)

##3. Ordenar os dados usando a coluna da ordem de entrega antes de separar os Dataframes ----
 
routes$Ordem.entrega <- as.numeric(routes$Ordem.entrega)

routes <- routes[order(routes$Ordem.entrega, routes$`Equipe|Regiao`),]
routes <- routes[routes$Bairro != "{vazio}",]
routes <- routes[!is.na(routes$ID),]
routes$Qtd <- as.numeric(as.character(routes$Qtd))
routes$Latitude <- as.numeric(as.character(routes$Latitude))
routes$Longitude <- as.numeric(as.character(routes$Longitude))

LDF <- split.data.frame(routes, routes$`Equipe|Regiao`)

number_dfs <- seq(1:length(LDF))

#setwd("~/Users/mariosaraiva/Documents/IIR - NG/COVID19/src")

# 4.Render DFs and export Driver's Delivery sheet.####

# for (i in number_dfs) {
#   title <- character()
#   subgroup <- LDF[i]
#   df_subgroup <- as.data.frame(subgroup[1])
# 
#   title <- df_subgroup[1,1]
# 
#   render("TRANSPORTE.rmd",
#          output_file = paste0('Entrega_', i,"_", title,"_", Sys.Date(),'.html'),
#          output_dir = "/Users/mariosaraiva/Documents/IIR.NG/COVID19/Routes")
# }
title <- list()
titles <- character()
for (i in number_dfs) {
  
  subgroup <- LDF[i]
  df_subgroup <- as.data.frame(subgroup[1])
  t <- df_subgroup[1,1]
  title <- paste0('Entrega_', i,"_", t, "_", Sys.Date(),'.html')
  titles <- append(titles, title)
}



##5. Brief report####
# link <- routes %>%
#   filter(Link == "Missing link :(")
# 
# link_rate <- round(1 - nrow(link)/nrow(routes), 2)
# 
# total_baskets <- sum(routes$Qtd)
# total_stops <- nrow(routes)
# 
# brief <- paste0("Driver sheets ready! ", "Total baskets needed: ", total_baskets,
#                 ". Total stops: ", total_stops)
# 
# print(brief)
