# one directory with every file the app needs
# app.R (you must use the exact name); or two file server.R and ui.R

# Shinyapps.io: free R server by RStudio
# my account is https://hybfc.shinyapps.io
# guide: https://www.shinyapps.io/admin/#/dashboard

# devtools::install_github --install from github
# rsconnect package enables you to deploy and manage your Shiny applications directly from your R console

library(shiny)

ui <- fluidPage(
  # *Input() functions
  sliderInput(inputId = "num", label = "choose sample size", value = 50, min= 10, max=1000),
  # *Output() functions
  plotOutput(outputId = "hist")
)

server <- function(input, output) {
  # Three rules to write server function
  # 1, save objects display to output$
  # 2, use render function to create the needed type of output
  #    (use {} to include multiple commands)
  # 3, use input values with input$
  output$hist <- renderPlot({
    hist(rnorm(input$num), main="")
    title("histogram")
    })
}

shinyApp(ui = ui, server = server)
