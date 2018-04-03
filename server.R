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

function(input, output){
  selected_whisky <- reactive({
    req(input$FirstPref)
    req(input$SecondPref)
    req(input$ThirdPref)
    whisky %>% 
      group_by(Distillery) %>% 
      arrange(desc(UQ(sym(input$FirstPref))),
              desc(UQ(sym(input$SecondPref))),
              desc(UQ(sym(input$ThirdPref)))) %>% 
      head(5)
  })
  
  selected_whisky_score <- reactive({
    selected_whisky() %>% 
      gather(key = Review.point, value = Score, Body:Floral)
  })
  
  output$score <- renderPlot(
    
    selected_whisky_score() %>% 
      ggplot(aes(x=Review.point, y = Score, fill = Review.point)) + 
      geom_bar(stat = "identity") + 
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            strip.text = element_text(size=12)) + 
      facet_wrap(~ Distillery)
    
  )
  
  output$table2 <- renderTable(
    selected_whisky()
  )
}