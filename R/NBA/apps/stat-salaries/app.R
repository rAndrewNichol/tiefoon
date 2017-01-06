# This is a shiny app that creates a scatterplot between two user-selected
# variables and determines their correlation coefficient.
# The plot can also be commanded to color-coded by player position (and back).

library(shiny)
library(ggplot2)

# ==============================================================================

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel(h3("Variable Relations", align = "center")),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "x_variable",
                    label = "X Axis:",
                    choices = c("Efficiency Index" = "EFF",
                                "Points" = "points",
                                "Rebounds" = "total_rebounds",
                                "Assists" = "assists",
                                "Steals" = "steals",
                                "Blocks" = "blocks",
                                "Missed Field Goals" = "MFG",
                                "Missed Free Throws" = "MFT",
                                "Turnovers" = "TO",
                                "Games Played" = "games",
                                "Salary"  = "salary"
                                )
                    ),
        selectInput(inputId = "y_variable",
                    label = "Y Axis:",
                    choices = c("Salary" = "salary",
                                "Efficiency Index" = "EFF",
                                "Points" = "points",
                                "Rebounds" = "total_rebounds",
                                "Assists" = "assists",
                                "Steals" = "steals",
                                "Blocks" = "blocks",
                                "Missed Field Goals" = "MFG",
                                "Missed Free Throws" = "MFT",
                                "Turnovers" = "TO",
                                "Games Played" = "games"
                                )
                    ),
        actionButton("display_position", "Display by Position")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         textOutput("correlation")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   df <- read.csv(file = "eff-stats-salary.csv",
                                 stringsAsFactors = F, row.names = 1)
   output$correlation <- renderText({
     paste("r =", round(cor(df[ , input$x_variable],
                                           df[ , input$y_variable]), digits = 3))
   })
   output$distPlot <- renderPlot({
     if(input$display_position %% 2 == 1){
       ggplot(data = df,
             aes(x = df[ , input$x_variable], y = df[ , input$y_variable])) +
       geom_point(size = 2, aes(color = df$position)) +
       xlab(input$x_variable) + ylab(input$y_variable) +
       theme(legend.title=element_blank(), legend.position = "top")
     } else{
       ggplot(data = df,
              aes(x = df[ , input$x_variable], y = df[ , input$y_variable])) +
       geom_point(size = 2) +
       xlab(input$x_variable) + ylab(input$y_variable)
     }
   })

})

# Run the application 
shinyApp(ui = ui, server = server)

