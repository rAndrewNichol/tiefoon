# This is a shiny app to plot different statistics of player salaries by 
# NBA team. The bars are colored by the team colors of the teams they represent.

library(ggplot2)
library(shiny)
library(dplyr)

# ==============================================================================

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel(h3("Salary Statistics by Team", align = "center")),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "variable",
                     label = "Variable:",
                     choices = c("Total Payroll" = "total_payroll",
                       "Minimum" = "minimum",
                       "Maximum" = "maximum",
                       "First Quartile" = "first_quartile",
                       "Median" = "median",
                       "Third Quartile" = "third_quartile",
                       "Average" = "average",
                       "Interquartile Range" = "iqr",
                       "Standard Deviation" = "std_dev")
                     ),
        radioButtons(inputId = "order",
                     label = "Sort",
                     choices = c("Ascending" = "asc", 
                                 "Descending" = "desc"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        textOutput("text"), 
        plotOutput("barPlot")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
  df_salaries <- read.csv(file = "team-salaries.csv",
                           stringsAsFactors = FALSE)

  output$barPlot <- renderPlot({
    # draw the plot
    if(input$order == "asc"){
      team_colors <- df_salaries %>% 
                       arrange(desc(df_salaries[ , input$variable])) %>%
                       select(color) 
      ggplot(data = df_salaries, 
             aes(x = reorder(team, -df_salaries[ , input$variable]),
                 y = df_salaries[ , input$variable])) +
      geom_bar(stat = "identity", fill = team_colors$color) + 
      coord_flip() + 
      xlab("Team") + 
      ylab(input$variable)
    } else{
      team_colors <- df_salaries %>% 
                       arrange(df_salaries[ , input$variable]) %>%
                       select(color)
      ggplot(data = df_salaries, 
             aes(x = reorder(team, df_salaries[ , input$variable]),
                 y = df_salaries[ , input$variable])) +
      geom_bar(stat = "identity", fill = team_colors$color) +
      coord_flip() + 
      xlab("Team") + 
      ylab(input$variable)
    }
  })
})

# Run the application 
shinyApp(ui = ui, server = server)
