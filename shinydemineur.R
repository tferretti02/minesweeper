library(shiny)
source("C:/Users/Slama/Desktop/Demineur/codeDemineur.R") #load mine sweeper rscript
ui <- fluidPage( #set UI
  titlePanel("Mine Sweeper"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("WidthInput", "Width", 5, 50, 10),  #slider for width input
      sliderInput("LengthInput", "Length", 5, 50, 10), #slider for length input
      sliderInput("MinesInput", "Mines", 1, 100, 5), #slider for length input
      actionButton("start", "Start")
      #      selectInput("restartOption", "Restart", c("SELECT CHOICE","YES","NO"))
    ),
    mainPanel(uiOutput("mine")) #show the main game panel
  )
)

server <- function(input, output) {
  actionstart <- eventReactive(input$start, { #trigger of starting button
    mine_sweeper(input$WidthInput, input$LengthInput, input$MinesInput)
  }
  )
  #  action.restart <- eventReactive(input$restartOption, {
  #    answer(input$restartOption)
  #    }
  #  )
  output$mine <- renderUI(
    #    if (input$restartOption == "SELECT CHOICE") {
    actionstart()
    #    } else action.restart()
  )#start the game
  
}

shinyApp(ui = ui, server = server)

