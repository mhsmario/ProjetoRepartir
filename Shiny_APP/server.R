#Server

# source("1.Assign_ID_New_Form_Entries.R")

library(shiny)
library(shinyFiles)
library(lubridate)
library(dplyr)
library(shinycssloaders)
library(knitr)
library(rmarkdown)
library(glue)
library(tidyverse)

server <- function(input, output, session) {
  
  #Step 1. Assign_ID_New_Form_Entries.R----
  observeEvent(input$Step1, {
    insertUI("#Step1", "beforeBegin", immediate = T,
             shinycssloaders::withSpinner(
               textOutput("Step1_msg_out"), 
               type = 5, size = .5)
             ) #end inserUI
    
    source("1.Assign_ID_New_Form_Entries.R")
    
    output$Step1_msg_out <- renderText({paste0(Step1_msg)})
             })#end observe event
  
  #Step 2.Send_to_Triagem.R----  
  observeEvent(input$Step2, {
    
     insertUI("#Step2", "beforeBegin", immediate = T, 
             shinycssloaders::withSpinner(
               textOutput("Step2_msg_out"),
               type = 5, size = .5)
             )#end inserUI
    
    source("2.Send_to_Triagem.R") 
    
    output$Step2_msg_out <- renderText({paste0(Step2_msg)})
      
  })#end observe event
  
  #Step 3. Update_prayer_requests.R----  
  
  observeEvent(input$Step3, {
    
    insertUI("#Step3", "beforeBegin", immediate = T,
             shinycssloaders::withSpinner(
               textOutput("Step3_msg_out"),
               type = 5, size = .5)
             )#end inserUI
    
    source("3.update_prayer_requests.R") 
    
    output$Step3_msg_out <- renderText({paste0(Step3_msg)})

  })#end observe event
  
  #Step 4. Insert_IDs_Preencher_Transporte.R----  
  
    observeEvent(input$Step4, {
      insertUI("#Step4", "beforeBegin", immediate = T,
               shinycssloaders::withSpinner(
                 textOutput("Step4_msg_out"),
                 type = 5, size = .5)
      )#end inserUI
    
    source("4.Insert_IDs_Preencher_Transporte.R") 

    output$Step4_msg_out <- renderText({paste0(Step4_msg)})
    
    })#end observe event
  
#Step 5. Update_Contact_Info.R----
    observeEvent(input$Step5, {
      insertUI("#Step5", "beforeBegin", immediate = T,
               shinycssloaders::withSpinner(textOutput("Step5_msg_out"),
                                            type = 5, size = .5)
      )#end inserUI
      
      source("5.Update_Contact_Info.R") 
      
      output$Step5_msg_out <- renderText({str_wrap(paste0(Step5_msg))})
      
      output$downloadData <- downloadHandler({
        filename = function() {
          paste("Repartir_New_Contacts", Sys.Date(), ".csv", sep = "")
        }
        content = function(file) {
          write.csv(NovosContatos_csv, file, row.names = FALSE)
        }
      }) #end downloadHandler
      
      output$Step5_download_btn <- renderUI({
        if(nchar(Step5_msg) > 59) {
        downloadButton("downloadData", "Download_CSV_file")
        } else {
          p(":)")
        }
      })# end renderUi
    })#end observe event
    
# Step 6 - Names for Python ----
    observeEvent(input$Step6, {
      #source("6.Prepare_names_for_python.R") 
      insertUI("#Step6", "beforeBegin",
               p(">> Temporarily not working"))
    })#end observe event
    
    #observeEvent(input$Step7_maps_url)
    
### Step 7. Driver's sheet ----
    observeEvent(input$Step7, {
      source("7.Drivers_sheet.R") 
      
      output$downloadData <- downloadHandler(
        filename = function() {
          paste0("Drivers_Sheet", ".zip")
        },
        
        content = function(file) {
              k <- input$myTable1_rows_selected
              fs <- c()
              withProgress(message = 'Downloading',
                           detail = 'Vai dar tudo certo. Só confia.',
                           value = 0, {
                             
                             number_dfs <- seq(1:length(LDF))
                             
          for (i in number_dfs) {
            incProgress(1/max(number_dfs))
              title <- character()
              subgroup <- LDF[i]
              df_subgroup <- as.data.frame(subgroup[1])
              title <- df_subgroup[1,1]
              my_file = paste0('Entrega_', i,"_", 
                               title,"_", Sys.Date(),'.html')
              path <- my_file
              rmarkdown::render("transporte.Rmd", 
                                #rmarkdown::html_document(), 
                                output_file = path)
            fs <- c(fs, path)
          }
                             
          zip(file, fs)
                           })
        },
        contentType = "application/zip"
      ) #end of downloadHandler
       
      insertUI("#Step7", "beforeBegin",
               shinycssloaders::withSpinner(
                 downloadButton("downloadData", "Download"),
                 type = 5, size = .5))
      
      #output$myfiles  <- shinyDirChoose(input$thisfile, 'folder')
        
      
    })#end observe event
  
  #Step 8.Update_Delivered.R----  
  observeEvent(input$Step8, {
    
    insertUI("#Step8", "beforeBegin", immediate = T, 
             shinycssloaders::withSpinner(
               textOutput("Step8_msg_out"),
               type = 5, size = .5)
    )#end inserUI
    Step8_msg_out <- "Sorry this is not working at the moment. Please run this step manually."
    #source("8.Update_Delivered.R") 
    
    output$Step8_msg_out <- renderText({paste0(Step8_msg)})
    
  })#end observe event
  
  #Step 9.TableauMap----  
  observeEvent(input$Step9, {
    
    insertUI("#Step9", "beforeBegin", immediate = T, 
             shinycssloaders::withSpinner(
               textOutput("Step9_msg_out"),
               type = 5, size = .5)
    )#end inserUI
    
    source("9.Update_Tableau_Map.R") 
    
    output$Step9_msg_out <- renderText({paste0(Step9_msg)})
    
  })#end observe event
}