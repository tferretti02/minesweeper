# Minesweeper Game in R Shiny

This is a simple Minesweeper game built using the R Shiny web framework. The game is based on the classic Minesweeper game and can be played in a web browser using the shiny package.

## Installation

Before running the game, you need to make sure that you have the shiny and reticulate packages installed in R. You also need to have Python installed on your system, as the game uses the Python random module to generate the mine locations.

You can install the required packages using the following R commands:

```R
install.packages("shiny")
install.packages("reticulate")
```

You can download and install Python from the official website: (https://www.python.org/downloads/)

## Running the Game

To run the game, simply open the app.R file in RStudio and click the "Run App" button. This will launch the game in a new window in your web browser.

Alternatively, you can run the game using the following R command:

```R
shiny::runApp("path/to/app.R")
```

Replace path/to/app.R with the actual path to the app.R file on your system.

## How to Play

The objective of the game is to clear the board without detonating any mines. The board is a grid of squares, and each square can either be empty, contain a number indicating the number of adjacent mines, or contain a mine. To clear a square, simply click on it. If the square contains a mine, the game is over.

If you click on a square that does not contain a mine, the square will be cleared and the numbers on adjacent squares will be updated to reflect the number of adjacent mines. If you clear all the squares that do not contain mines, you win the game!
