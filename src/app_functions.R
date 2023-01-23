#Important functions

#Fun: Create a button for each region----
my_btn <- function(inputId, label){
  
  fluidRow(width = 10, 
           actionButton(inputId = paste0(inputId),
                      label = label,
                      style = "color: #fff; 
                        background-color: #686868; 
                        border-color: #686868"),
           br(), br()
  )
}

#Fun: Create 2 infoboxes for each region----
reg_infobox <- function(n_reg_ob, n_reg_st, n_reg_so) {
  
  fluidRow(
    column(width = 4,
            h4("Number of countries in 'Step 1 - Obtain'"),

            box(width = 4, color = "aqua", fill = T,
                    shiny::icon("search", "fa-4x"),
                    tags$p(paste0(n_reg_ob), style = "font-size: 250%; color = #ffffff"))),
    column(width = 4,
            h4("Number of countries in 'Step 2 - Standardize'"),
            box(width = 4, color = "aqua", fill = TRUE,
                    icon("table", "fa-4x"),
                    tags$p(paste0(n_reg_st), style = "font-size: 250%;"))),
    column(width = 4,
            h4("Number of countries in 'Step 3 - Share with OCHA'"),
            box(width = 4, color = "aqua", fill = TRUE,
                    icon("share", "fa-4x"),
                    tags$p(paste0(n_reg_so), style = "font-size: 250%;")))
  )
              
}

#Fun: Create a button within a DataTable ----
buttonInput <- function(FUN, len, id,  ...) {
  inputs <- character(len)
  for (i in seq_len(len)) {
    inputs[i] <- as.character(FUN(paste0(id, i), ...))
  }
  inputs
}

maketables <- function(vals_data, rowgroupnumber) {
  if (grepl("obtain", paste0(vals_data))) {
      DT::renderDataTable(options = list(scrollX = T, pageLength = 1000),
        datatable(vals_data, escape = F, 
                  extensions = c('Buttons', 'RowGroup'),
                  options = list(dom = 'rtipB',
                                 buttons = c('copy', 'csv'),
                                 rowGroup = list(dataSrc =
                                                   rowgroupnumber),
                                 selection = 'none')
                  ) #end datatable
        %>% formatStyle(
           'OCHA_Classification', 'OCHA_Classification',
           backgroundColor = styleEqual(c("Preparedness","Operational"),
                                        c('white', '#FCAF58')))
         %>% formatStyle(
           'Range of Projections (END)', 'Range of Projections (END)',
           backgroundColor = styleEqual(c(none, outdated, acceptable),
                                        c(t_color1, t_color2, t_color3))
                                        )
      ) #End RenderDataTable
    } else {
      DT::renderDataTable(options = list(scrollX = T, pageLength = 1000),
                        datatable(vals_data, escape = F, 
                                  extensions = c('Buttons', 'RowGroup'),
                                  options = list(dom = 'rtipB',
                                                 buttons = c('copy', 'csv'),
                                                 rowGroup = list(dataSrc =
                                                                   rowgroupnumber),
                                                 selection = 'none')
                        ) #end datatable
                        %>% formatStyle(
                          'OCHA_Classification', 'OCHA_Classification',
                          backgroundColor = styleEqual(c("Preparedness","Operational"),
                                                       c('white', '#FCAF58')))
    ) #End RenderDataTable
  } #End if statement
} #End Function

Obtain_reg_full <- function(data) { 
  name_full <- left_join(data, CPM_2_LastAv[,c(1:3, 5:12)],
                              by = c("ID", "Code", "Country")) %>%
  left_join(CPM_3_Updates, 
            by = c("ID", "Code", "Country")) %>%
  left_join(CPM_4_Comments, 
            by = c("ID", "Code", "Country"))
  return(name_full)
  
}

Comment_button <- function(reg_name) {
  inputId <- paste0("Button_comment_id_", reg_name)
  label <- "Submit comment"
  actionBttn(inputId = inputId, label = label,
           style = "jelly", color = "primary")
}
