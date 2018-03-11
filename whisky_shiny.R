setwd("/Users/KokiAndo/Desktop/R/Shiny app/whisky")
library(tidyverse)
library(data.table)
library(shiny)
library(DT)


whisky <- fread("http://outreach.mathstat.strath.ac.uk/outreach/nessie/datasets/whiskies.txt", data.table = FALSE)
whisky$Longitude <- as.numeric(whisky$Longitude)
whisky$Latitude <- as.numeric(whisky$Latitude)


# whisky : Global Data (not including location data)
whisky <- whisky %>% select(Distillery:Floral)

# whisky.score : tidy whisky data
whisky.score <- whisky %>% 
  gather(key = Review.point, value = Score, Body:Floral)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
     selectInput(
       inputId = "FirstPref",
       label = "Select your 1st Preference:",
       choices = names(whisky %>% select(-Distillery))
       ),
     selectInput(
       inputId = "SecondPref",
       label = "Select your 2nd Preference:",
       choices = names(whisky %>% select(-Distillery))
       )),
    mainPanel(
      DT::dataTableOutput(outputId = "table")
    )
    )
)


server <- function(input, output){
  output$table <- renderDataTable({
    DT::datatable(
      data = whisky %>% 
        group_by(Distillery) %>% 
        arrange(desc(Body), desc(Sweetness), desc(Fruity)) %>% 
        head(5),
      option = 
        list(lengthMenu = c(5, 10, 50), 
             pageLength = 5),
      rownames = FALSE
    )
  })
}

shinyApp(ui = ui, server = server)
