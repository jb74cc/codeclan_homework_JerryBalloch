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

  # ADDING A TITLE TAG HERE - FIRST QUESTION
  titlePanel(tags$h2("January to March Workout Data")),
  
  HTML("<br>"),

  sidebarLayout(
    sidebarPanel(
      
      #textInput("txt", "Text input:", "text here"),
      # ADDING THE FORMATTING HERE - SECOND QUESTION
      # radioButtons("month_input",
      #              tags$i("Choose month?"),
      #              choices = c("Jan", "Feb", "Mar")
      # ),
      
      checkboxGroupInput("month_input", 
                         label = h4("Choose Month(s)"), 
                         choices = list("January" = "Jan", 
                                        "February" = "Feb", 
                                        "March" = "Mar"),
                         selected = "Jan"),
      
      
     

      selectInput("type_input",
                  tags$h4("Choose workout type:"),
                  choices = all_types
      )
    ),

    mainPanel(
      plotOutput("workout_plot"),

      # ADDING THE LINK HERE - QUESTION 3
      #tags$a("The Olympics website", href = "https://www.Olympic.org/")
    )
  )
)


server <- function(input, output) {
  
  output$workout_plot <- renderPlot({
    
    workout_data %>%
      filter(type == input$type_input) %>% 
      filter(month == input$month_input) %>% 
      ggplot(aes(x = duration, y = month, fill = month)) +
      geom_col() +
      #theme(legend.position="bottom") +
      #theme(axis.text.x = element_text(angle = 0,hjust=1)) +
      xlab("duration (hh:mm:ss)") +
      ylab("month") +
      scale_y_discrete(limits = c("Mar", "Feb", "Jan")) +
      theme_bw() +
      scale_fill_manual(values = c("Jan" = "#1A3873", 
                                   "Feb" = "#275D8C", 
                                   "Mar" = "#34A6BF")) +
      theme(legend.position = "none")
    
  })
  
}

shinyApp(ui = ui, server = server)

# olympics_overall_medals %>% 
#   filter(team == input$team_input) %>% 
#   filter(season == input$season_input) %>% 
#   ggplot() +
#   aes(x = medal, y = count, fill = medal) +
#   geom_col() 
