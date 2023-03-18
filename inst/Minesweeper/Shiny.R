library(shiny)
source("mine_sweeper.R") 
ui <- fluidPage( 
  titlePanel("Mine Sweeper"),
  sidebarLayout(
    sidebarPanel(
      tags$style(HTML("body {background-color: green;}")),
      sliderInput("WidthInput", "Width", 5, 50, 10),  
      sliderInput("LengthInput", "Length", 5, 50, 10), 
      sliderInput("MinesInput", "Mines", 1, 100, 5), 
      actionButton("start", "Start",class = "btn-danger btn-lg")
      #      selectInput("restartOption", "Restart", c("SELECT CHOICE","YES","NO"))
    ),
    mainPanel(uiOutput("mine")) 
  )
)

server <- function(input, output) {
  actionstart <- eventReactive(input$start, { #trigger of starting button
    mine_sweeper(input$WidthInput, input$LengthInput, input$MinesInput)
  }
  )
  #action.restart <- eventReactive(input$restartOption, {
     #answer(input$restartOption)
     #}
   #)
  output$mine <- renderUI(
    #    if (input$restartOption == "SELECT CHOICE") {
    actionstart()
    #    } else action.restart()
  )#start the game
  
}

shinyApp(ui = ui, server = server)

