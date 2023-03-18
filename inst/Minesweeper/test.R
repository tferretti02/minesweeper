library(shiny)

ui <- fluidPage(
  fluidRow(
    tagList(
      tags$script(
        "$(function(){
        $(this).bind('contextmenu', function (e) {
          e.preventDefault()
          Shiny.setInputValue('plop', Math.random());
        });
      });"
      )
    ),
    column(width = 3,
           radioButtons("radio", "Choose a color:",
                        choices = list("Red" = "red",
                                       "Green" = "green",
                                       "Blue" = "blue"))),
    column(width = 9,
           plotOutput("plot", click = "plot_click"))
  )
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    plot(1:10, 1:10, col = input$radio)
  })
  
  observeEvent(input$plot_click, {
    click_loc <- input$plot_click
    print(paste("Clicked at", click_loc$x, click_loc$y))
  })
  
  observeEvent(input$plop , {
    print(paste("Clicked at", input$plop))
  })
  
  outputOptions(output, "plot", suspendWhenHidden = FALSE)
  
  output$script <- renderUI({
    tags$script(
      "$(function(){
        $(this).bind('contextmenu', function (e) {
          e.preventDefault()
          Shiny.setInputValue('plop', Math.random());
        });
      });"
    )
  })
}

shinyApp(ui, server)
