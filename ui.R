library(tidyverse)
library(data.table)
library(shiny)
library(DT)
library(rlang)

whisky <- fread("http://outreach.mathstat.strath.ac.uk/outreach/nessie/datasets/whiskies.txt", data.table = FALSE)
whisky$Longitude <- as.numeric(whisky$Longitude)
whisky$Latitude <- as.numeric(whisky$Latitude)


# whisky : Global Data (not including location data)
whisky <- whisky %>% select(Distillery:Floral)

# whisky.score : tidy whisky data
whisky.score <- whisky %>% 
  gather(key = Review.point, value = Score, Body:Floral)

fluidPage(
  titlePanel("Find tonight's whisky for you!!", windowTitle = "Whisky"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "FirstPref",
        label = "Select your 1st Preference:",
        choices = names(whisky %>% select(-Distillery)),
        selected = "Body"
      ),
      selectInput(
        inputId = "SecondPref",
        label = "Select your 2nd Preference:",
        choices = names(whisky %>% select(-Distillery)),
        selected = "Sweetness"
      ),
      selectInput(
        inputId = "ThirdPref",
        label = "Select your 3rd Preference:",
        choices = names(whisky %>% select(-Distillery)),
        selected = "Smoky"
      )),
    mainPanel(
      plotOutput(outputId = "score"),
      DT::dataTableOutput(outputId = "table"),
      tableOutput(outputId = "table2")
    )
  )
)