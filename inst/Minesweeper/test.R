library(shiny)
library(shinyWidgets)
library(tidyr)
library(dplyr)
library(stringr)

grid_rows <- 8
grid_cols <- 10
n_mine <- 10

library(shiny)
library(shinyWidgets)
library(tidyr)
library(dplyr)
library(stringr)

grid_rows <- 8
grid_cols <- 10
n_mine <- 10

count_mines <- function(grid, row, col) {
  r_start <- max(row - 1, 1)
  r_end <- min(row + 1, nrow(grid))
  c_start <- max(col - 1, 1)
  c_end <- min(col + 1, ncol(grid))
  sum(grid[r_start:r_end, c_start:c_end] == 1) - as.numeric(grid[row, col] == 1)
}

genarate_minesweeper_grid <- function(grid_rows, grid_cols, n_mine) {
  mineland <- tidyr::expand_grid(row = 1:grid_rows, col = 1:grid_cols) %>%
    mutate(
      id = str_c("id", row, col),
      mine = sample(c(rep(1, n_mine), rep(0, grid_rows * grid_cols - n_mine)))
    )
  mine_matrix <- matrix(mineland$mine, nrow = grid_rows, ncol = grid_cols, byrow = TRUE)
  mineland$mine_count <- mapply(count_mines, grid = list(mine_matrix), row = mineland$row, col = mineland$col)
  mineland
}

mineland_grid <- genarate_minesweeper_grid(grid_rows, grid_cols, n_mine)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Add custom CSS style for buttons
  tags$head(tags$style(HTML("
        .btn {
            width: 50px;
            height: 50px;
            font-size: 14px;
        }
    "))),

  # Application title
  tags$h1("Minesweeper"),

  # Sidebar with a slider input for number of bins
  uiOutput("mineland")
)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Add custom CSS style for buttons
  tags$head(tags$style(HTML("
        .btn {
            width: 50px;
            height: 50px;
            font-size: 14px;
        }
    "))),

  # Application title
  tags$h1("Minesweeper"),

  # Sidebar with a slider input for number of bins
  uiOutput("mineland")
)

# Define server logic required to draw a histogram
# Define server logic required to draw a histogram
server <- function(input, output, session) {

  output$mineland <- renderUI({
    do.call(
      tagList,
      lapply(1:grid_rows, function(ind) {
        tmp <- mineland_grid %>% dplyr::filter(row == ind)
        fluidRow(
          actionGroupButtons(
            inputIds = tmp$id,
            labels = rep("", nrow(tmp))
          )
        )
      })
    )
  })

  observe({
    clicked <- reactiveValuesToList(input)

    for (cell_id in names(clicked)) {
      if (startsWith(cell_id, "id") && !is.null(clicked[[cell_id]]) && clicked[[cell_id]] > 0) {
        cell_info <- mineland_grid %>% dplyr::filter(id == cell_id)
        updateActionButton(session, cell_id, label = ifelse(cell_info$mine == 1, "💣", as.character(cell_info$mine_count)))
      }
    }
  })
}


# Run the application
shinyApp(ui = ui, server = server)


# Run the application
shinyApp(ui = ui, server = server)
