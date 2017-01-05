
library(ggplot2)
library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel(h2("What should you do?", align="center")),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      actionButton("plots", "KEEP CLICKING ME")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot1"),
      plotOutput("distPlot2"),
      textOutput("yes_no")
    )
  ))
)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  # H
  x_h <- runif(1000, min = 1.5, max = 2)
  x_h <- c(x_h, runif(500, min = 2, max = 3.5))
  x_h <- c(x_h, runif(1000, min = 3.5, max = 4))
  y_h <- runif(1000, min = .5, max = 5.5)
  y_h <- c(y_h, runif(500, min = 2.75, max = 3.5))
  y_h <- c(y_h, runif(1000, min = .5, max = 5.5))
  df_h <- data.frame(x_axis = x_h, y_axis = y_h)
  
  #I 
  x_i <- c(runif(600, min = 2.75, max = 3.25),
           runif(600, min = 2, max = 4),
           runif(600, min = 2, max = 4))
  y_i <- c(runif(600, min = 1.25, max = 4.75),
           runif(600, min = .5, max = 1.25),
           runif(600, min = 4.75, max = 5.5))
  df_i <- data.frame(x_axis = x_i, y_axis = y_i)
  
  #R
  x_r <- c(runif(1000, min = 1.5, max = 2),
           runif(500, min = 2, max = 3.5),
           runif(500, min = 2, max = 3.5),
           runif(300, min = 3, max = 3.5))
  x_append <- runif(500, min = 2.7, max = 3.8)
  x_r <- c(x_r, x_append)
  
  z_r = runif(500, min = 7.55, max = 8.55)
  y_r <- c(runif(1000, min = .5, max = 5.5),
           runif(500, min = 4.75, max = 5.5),
           runif(500, min = 2.75, max = 3.5),
           runif(300, min = 3.5, max = 4.75))
  y_r <- c(y_r, (-1.9)*x_append + z_r)
  df_r <- data.frame(x_axis = x_r, y_axis = y_r)
  
  #E
  x_e <- c(runif(1000, min = 1.5, max = 2),
           runif(500, min = 2, max = 3.1),
           runif(500, min = 2, max = 3.5),
           runif(500, min = 2, max = 3.5))
  y_e <- c(runif(1000, min = .5, max = 5.5),
           runif(500, min = 2.75, max = 3.5),
           runif(500, min = 4.75, max = 5.5),
           runif(500, min = .5, max = 1.25))
  df_e <- data.frame(x_axis = x_e, y_axis = y_e)
  
  #M
  x_m <- c(runif(1000, min = 1.5, max = 2))
  x_append1 <- runif(400, min = 2, max = 2.8)
  x_m <- c(x_m, x_append1)
  x_append2 <- runif(400, min = 2.8, max = 3.6)
  x_m <- c(x_m, x_append2)
  x_m <- c(x_m, runif(1000, min = 3.6, max = 4.1))
  
  z_m1 <- runif(400, min = 9.4, max = 10.7)
  z_m2 <- runif(400, min = -5.2, max = -3.9)
  
  y_m <- c(runif(1000, min = .5, max = 5.5))
  y_m <- c(y_m, (-2.6)*x_append1 + z_m1)
  y_m <- c(y_m, (2.6)*x_append2 + z_m2)
  y_m <- c(y_m, runif(1000, min = .5, max = 5.5))
  
  df_m <- data.frame(x_axis = x_m, y_axis = y_m)
  
  #!
  x_exc <- c(runif(200, min = 2.75, max = 3.25),
             runif(850, min = 2.75, max = 3.25))
  y_exc <- c(runif(200, min = .5, max = 1.25),
             runif(850, min = 1.6, max = 5.5))
  
  df_exc <- data.frame(x_axis = x_exc, y_axis = y_exc)
  
  
  
  # ==============================
  
  #output$yes_no <- renderText({
  #  print(input$plots)
  #})
  output$distPlot1 <- renderPlot({
    if(input$plots %% 8 == 1){
      ggplot(data = df_h, aes(x = df_h$x_axis, y = df_h$y_axis)) + 
        geom_point(color = "#1f437c") +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    } else if(input$plots %% 8 == 2){
      ggplot(data = df_i, aes(x = df_i$x_axis, y = df_i$y_axis)) + 
        geom_point(color = "#1f437c") +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    } else if(input$plots %% 8 == 3){
      ggplot(data = df_r, aes(x = df_r$x_axis, y = df_r$y_axis)) + 
        geom_point(color = "#1f437c") +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    } else if(input$plots %% 8 == 4){
      ggplot(data = df_e, aes(x = df_e$x_axis, y = df_e$y_axis)) +
        geom_point(color = "#1f437c") +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    } else if(input$plots %% 8 == 5){
      ggplot(data = NULL) +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    } else if(input$plots %% 8 == 6){
      ggplot(data = df_m, aes(x = df_m$x_axis, y = df_m$y_axis)) +
        geom_point(color = "#1f437c") +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    } else if(input$plots %% 8 == 7){
      ggplot(data = df_e, aes(x = df_e$x_axis, y = df_e$y_axis)) +
        geom_point(color = "#1f437c") +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    } else if (input$plots %% 8 == 0 & input$plots != 0){
      ggplot(data = df_exc, aes(x = df_exc$x_axis, y = df_exc$y_axis)) + 
        geom_point(color = "#6d0f1b") +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) + xlab("X-Axis") + ylab("Y-Axis")
    }
  })
  
})

# Run the application 
shinyApp(ui = ui, server = server)

