library(shiny)
library(tidyverse)
library(shinythemes)
library(janitor)
library(here)

workout_data <- read_csv(here::here("data/workout_data.csv"))



all_types <- unique(workout_data$type)
all_months <- unique(workout_data$month)

ui <- fluidPage(
  
  theme = shinytheme("superhero"),
  
  titlePanel(tags$h2("January to March Workout Data")),
  
  HTML("<br>"),
  
  sidebarLayout(
    sidebarPanel(
      
      img(src = "jb.gif", height = 102, width = 47),
      
      HTML("<br><br>"),
      
      checkboxGroupInput("month_input", 
                         tags$h4("Choose Month(s)"), 
                         choices = list("January" = "Jan", 
                                        "February" = "Feb", 
                                        "March" = "Mar"),
                         selected = "Jan"),
      
      # when no activity is present for month selected the chart errors
      # need to find a way to prevent this
      
      
      selectInput("type_input",
                  tags$h4("Choose workout type:"),
                  choices = all_types
      )
    ),
    
    mainPanel(
      plotOutput("workout_plot"),
      
    )
  )
)


server <- function(input, output) {
  
  output$workout_plot <- renderPlot({
    
    workout_data %>%
      filter(type == input$type_input) %>% 
      filter(month %in% input$month_input) %>% 
      ggplot(aes(x = duration, y = month, fill = month)) +
      geom_col() +
      #theme(legend.position="bottom") +
      xlab("duration (hh:mm:ss)") +
      ylab("month") +
      scale_y_discrete(limits = c("Mar", "Feb", "Jan")) +
      theme_bw() +
      scale_fill_manual(values = c("Jan" = "#1A3873", 
                                   "Feb" = "#275D8C", 
                                   "Mar" = "#34A6BF")) +
      #xlim(c(min(0), max(workout_data$duration))) +
      scale_x_time(limits = c(min(0), max(workout_data$duration))) + # almost!
      theme(legend.position = "none")
    
  })
  
}

shinyApp(ui = ui, server = server)


