#UI
library(shiny)
library(shinyFiles)
library(shinycssloaders)
library(dplyr)
source("app_functions.R")

ui <- fluidPage(
  
  #CSS
  
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Yusei+Magic&display=swap');
      body {
        
      }
      h2 {
        font-family: 'Yusei Magic', sans-serif;
        background-color: 'white';
      }
      .shiny-input-container {
        color: #474747;
      }"))),
  
  #Background Image----
  setBackgroundImage(
    #src = "trianglify-lowres.png"
    src = "cool-background.png"
  ),
  
  column(12,
         div(style = "margin-top:10px; float: left;",
             a(href = 'https://iirbrasil.com.br/projetorepartir/',
               tags$img(width = "60%", height = "60%",
                        src = "LOGO.png"),
               target = "_blank")
         )#End of Div
  ), #End of Column
  
  fluidRow(
    
    column(width = 6,
           hr(),
#Part A ----
           h2("Parte A - Organizando os dados"),
           tags$b("Passo 1 - Dar um ID para cada resposta recebida."),
           my_btn("Step1", "Step 1 - Assign new IDs"),

           tags$b("Passo 2 - Copiar dados para aba '2.2.Triagem'."),
           my_btn("Step2", "Step 2 - Copy data to sheet 2.2"),
           
           tags$b("Passo 3 - Copiar dados para aba '2.6 Orações'."),
           my_btn("Step3", "Step 3 - Copy data to sheet 2.3"),
           
           tags$b("Passo 4 - Copiar IDs para aba '3.2 Preencher'."),
           my_btn("Step4", "Step 4 - Copy IDs to sheet 3.2") ,
           
           tags$b("Passo 5 - Atualizar planilha com novos contatos."),
           br(),
           my_btn("Step5", "Step 5 - Update contact info"),
           uiOutput("Step5_download_btn")
           # conditionalPanel(
           #   condition = "Step5_msg_out",
           #   downloadButton("downloadData", "Download_CSV_file"))
    ), # End of column
    
    column(width = 6,
           hr(),
#Part B ----
           h2("Parte B - Preparar para as entregas"),
              tags$b("Passo 6 - Formatar os nomes dos beneficiarios que 
                       serão contactados via WhatsApp (Python Script)."),
              br(),
              my_btn("Step6", "Step 6 - Atualizar contatos"),
              
              tags$b("Passo 7 - Gerar HTML com as informações de entrega."),
              br(),
              #textInput("Step7_maps_url", "Copie e cola o link do mapa das rotas"),
              my_btn("Step7", "Step 7 - Drivers HTML")

    ), # End of column
    column(width = 6,
           hr(),
           #Part C ----
           h2("Parte C - Entregas feitas. Vamos atualizar os dados no sistema."),
              tags$b("Passo 8 - Atualizar sistema com as cestas já entregues."),
              br(),
              my_btn("Step8", "Step 8 - Update after deliveries"),
              
              tags$b("Passo 9 - Atualizar planilha do mapa do site (Tableau)."),
              br(),
              my_btn("Step9", "Step 9 - Update Tableau sheet"),
              
           
    ), #End of column
    hr()
  ) #End of FluidRow
) #End UI Page
