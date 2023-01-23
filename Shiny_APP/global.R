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


#Set up Credentials -------
# designate project-specific cache
options(gargle_oauth_cache = ".secrets")
# # check the value of the option, if you like
gargle::gargle_oauth_cache()
# # trigger auth on purpose to store a token in the specified cache
# # a broswer will be opened

# # see your token file in the cache, if you like
#list.files(".secrets/")

googlesheets4::gs4_auth(
  cache = ".secrets",
  email = "[...]@gmail.com"
)




