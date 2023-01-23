# May 31, 2022
# This is the global source file for the Repartir Project app.
# The goal of this app is to faciliate the Repartir project management
# to non-r users allowing them to leverage the existing scripts.

#Core Libraries
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(googlesheets4) 
library(googledrive)

#Shiny libraries
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyEffects)
library(shinyBS) #for easier hover function
library(shinyWidgets)
library(shinycssloaders)

library(shinyFiles)

library(glue)
library(tidyverse)
#####0.Libraries####
#source("src/0. Preparando o RStudio.R")
#source("src/1.Assign_ID_New_Form_Entries.R")
# source("src/2.Send_to_Triagem.R")
# source("src/3.update_prayer_requests.R")
# source("src/4.Insert_IDs_Preencher_Transporte.R")
# source("src/6.Update_Contact_Info.R")
# source("src/7.Prepare_names_for_python.R")
# source("src/8.Drivers_sheet.R")
# source("src/9.Update_Delivered.R")
# source("src/11.Update_Tableau_Map.R")

#Set up Credentials -------
# designate project-specific cache
options(gargle_oauth_cache = ".secrets")
# # check the value of the option, if you like
gargle::gargle_oauth_cache()
# # trigger auth on purpose to store a token in the specified cache
# # a broswer will be opened
#googlesheets4::sheets_auth(email = "iirbrasilsocial@gmail.com")
# # see your token file in the cache, if you like
#list.files(".secrets/")

googlesheets4::gs4_auth(
  cache = ".secrets",
  email = "iirbrasilsocial@gmail.com"
)




