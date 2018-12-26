# one directory with every file the app needs
# app.R (you must use the exact name); or two file server.R and ui.R

# Shinyapps.io: free R server by RStudio
# my account is https://hybfc.shinyapps.io

# devtools::install_github --install from github
# rsconnect package enables you to deploy and manage your Shiny applications directly from your R console

library(shiny)

ui <- fluidPage(
  # *Input() functions
  sliderInput(inputId = "num", label = "choose sample size", value = 50, min= 10, max=1000),
  textInput(inputId = "tit", label = 'name the histogram', value="Histogram of random sample"),
  
  actionButton(inputId = "click", label ="RUN"),
  
  # *Output() functions
  plotOutput(outputId = "hist"),
  
  actionButton(inputId = "normal", label = 'Normal'),
  actionButton(inputId = "uniform", label = "Uniform"),
  
  plotOutput(outputId = "hist2")
)

server <- function(input, output) {
  # Three rules to write server function
  # 1, save objects display to output$
  # 2, use render function to create the needed type of output
  #    (use {} to include multiple commands)
  # 3, use input values with input$

  # reactive() builds an object to use in downstream code
  # call a reactive expression like a function
  # reactive expression caches the value
  
  # isolate() builds non-reactive object. It prevents app to respond to any reactive value
  
  dat <- reactive({
    rnorm(input$num)
  })
  
  # trigger code ON SERVer SIDE based on input change
  # observeEvent: code is triggered when reactive value input$click changes
  # observe: code is triggered when every reactive value in code changes
  observeEvent(input$click, {print(as.numeric(input$num))})
  observe({print(as.numeric(input$num))
    print(as.numeric(input$click))
    })
  
  # eventReactive() builds an object that delays reaction
  # It specifies which reactive value invalidates the expression
  
  dat <- eventReactive(input$click, {rnorm(input$num)})
  
  
  output$hist <- renderPlot({
    hist(dat(), main="")
    title(isolate(input$tit))
  })
  
  # reactive value only reacts to user input
  # ! we can not change reactive value programatically
  observeEvent(input$normal, {dat <- reactive(rnorm(input$num))})
  observeEvent(input$uniform, {dat <- reactive(runif(input$num))})

  # reactiveValues() creates a list of reactive values
  # It is usually manipulated by observeEvent
  rv <- reactiveValues(dat = rnorm(100))
  observeEvent(input$normal, {rv$dat <- rnorm(input$num)})
  observeEvent(input$uniform, {rv$dat <- runif(input$num)})
  
  output$hist2 <- renderPlot({
    hist(rv$dat, main=input$tit)
    })
}

shinyApp(ui = ui, server = server)
