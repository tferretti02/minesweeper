library(shiny)
library(reticulate)
source("mine_sweeper.R")

ui <- fluidPage(
  titlePanel("Mine Sweeper"),
  tabsetPanel(
    tabPanel("X11", sidebarLayout(
      sidebarPanel(
        tags$style(HTML("body {background-color: green;}")),
        sliderInput("WidthInput", "Width", 5, 50, 10),
        sliderInput("LengthInput", "Length", 5, 50, 10),
        sliderInput("MinesInput", "Mines", 1, 100, 5),
        actionButton("startX11", "Start",class = "btn-danger btn-lg")
      ),
      mainPanel(uiOutput("mine"))
    )),
    tabPanel("Python",
             radioButtons("difficulty", "Difficulty:",
                          c("Easy" = 1,
                            "Medium" = 2,
                            "Hard" = 3)
             ),
             actionButton("startPython", "Start", class = "btn-danger btn-lg"))
  )
)


server <- function(input, output) {
  actionstart <- eventReactive(input$startX11, { #trigger of starting button
    mine_sweeper(input$WidthInput, input$LengthInput, input$MinesInput)
  })
  observeEvent(input$startPython, {
    print("loading")
    source_python("../../src/pygame_script.py")
    result <- run_game(difficulty=as.integer(input$difficulty))
    result
  })
  output$mine <- renderUI(
    actionstart()
  )#start the game

}

shinyApp(ui = ui, server = server)

