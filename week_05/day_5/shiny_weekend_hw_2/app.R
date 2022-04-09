library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(shinythemes)
library(janitor)
library(here)
library(DT)
library(plotly)
library(lubridate)



# load in data and clean
workout_data <- read_csv(here::here("data/Workouts-2022-01-01-2022-04-01.csv"))
health_data <- read_csv(here::here("data/HealthAutoExport-2022-01-01-2022-04-01 Data.csv"))

workout_data <- clean_names(workout_data)
health_data <- clean_names(health_data)


# making a month column

health_data <- health_data %>% 
  mutate(month = months(date), .before = 1)

workout_data <- workout_data %>% 
  mutate(month = months(start), .before = 1) %>% 
  mutate(date = date(start), .before = 2)


# make groupings
all_types <- unique(workout_data$type)
all_months <- unique(workout_data$month)
all_dates <- unique(health_data$month)
all_steps <- health_data %>% na.omit(step_count_count) %>% sum(health_data$step_count_count)
exercise_mins <- health_data %>% na.omit(apple_exercise_time_min) %>% sum(health_data$apple_exercise_time_min)



ui <- fluidPage(
  useShinydashboard(),
  
  theme = shinytheme("flatly"),
  
  # Application title
  #titlePanel("January to March Workouts"),
  
  # Sidebar 
  sidebarLayout(

    sidebarPanel(
      
      img(src = "jb.gif", height = 95, width = 41),
      
      HTML("<br><br>"),
      
      checkboxGroupInput("month_input", 
                         tags$h4("Choose Month(s)"), 
                         choices = list("January" = "January", 
                                        "February" = "February", 
                                        "March" = "March"),
                         selected = "January"),
      
      
      selectInput("type_input",
                  tags$h4("Choose workout type:"),
                  choices = all_types
      ),
    ),
    
    
    
    # Main panel
    mainPanel(
     
       HTML("<br>"),
      
      valueBoxOutput("num_workouts", width = 4),
      valueBoxOutput("exercise_mins", width = 4),
      valueBoxOutput("steps_", width = 4),
      
      HTML("<br><br><br><br><br><br>"),
      
      plotlyOutput("workout_plot"),
      
      #HTML("<br><br>"),
      
      plotlyOutput("heart_plot"),
      
      
    )
  )
)

server <- function(input, output) {
  
  output$workout_plot <- renderPlotly({
    
    workout_data %>%
      filter(type == input$type_input) %>% 
      filter(month %in% input$month_input) %>% 
      ggplot(aes(x = duration, y = month, fill = month)) +
      geom_col() +
      #theme(legend.position="bottom") +
      xlab("duration (hh:mm:ss)") +
      ylab("month") +
      scale_y_discrete(limits = c("March", "February", "January")) +
      theme_bw() +
      scale_fill_manual(values = c("January" = "#1A3873", 
                                   "February" = "#275D8C", 
                                   "March" = "#34A6BF")) +
      #xlim(c(min(0), max(workout_data$duration))) +
      #scale_x_time(limits = c(min(0), max(workout_data$duration))) + # almost!
      theme(legend.position = "none")
    
  })
  
  output$heart_plot <- renderPlotly({
    
    workout_data %>%
      filter(type == input$type_input) %>% 
      filter(month %in% input$month_input) %>% 
      ggplot() +
      aes(x = date, y = max_heart_rate_bpm, colour = "Max HR") +
      geom_point() +
      #geom_line() +
      geom_point(aes(y = avg_heart_rate_bpm, colour = "average HR")) +
      xlab("Date") +
      ylab("Heart Rate bpm") +
      ylim(c(50,200)) +
      theme_bw() +
      theme(legend.position = "none")
    
  })
  
  
  output$num_workouts <- shinydashboard::renderValueBox({ 
    shinydashboard::valueBox(value = nrow(workout_data),
                             icon = icon("tint"),
                             subtitle = "Workouts completed",
    )
  })
  
  output$exercise_mins <- shinydashboard::renderValueBox({ 
    shinydashboard::valueBox(value = exercise_mins,
                             icon = icon("clock"),
                             subtitle = "Minutes excersied",
    )
  })
  
  
  output$steps_ <- shinydashboard::renderValueBox({ 
    shinydashboard::valueBox(value = all_steps,
                             icon = icon("fas fa-calendar"),
                             subtitle = "Steps this year",
    )
    
  })
  
}

shinyApp(ui, server)
