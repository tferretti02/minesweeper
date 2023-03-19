import pygame
import random

pygame.init()


# Define some colors
BLACK = (0, 0, 0)
GREEN = (0, 255, 0)
GRAY = (128, 128, 128)
WHITE = (255, 255, 255)
ORANGE = (255, 165, 0)
RED = (255, 0, 0)


# Set up the grid
num_rows = 8
num_cols = 10
square_size = 30
grid_padding = 5

# Set up the screen
width = num_cols * (square_size + grid_padding)
height = num_rows * (square_size + grid_padding)
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Color-changing Grid")

# Calculate the size of the grid surface
grid_width = num_cols * (square_size + grid_padding) + grid_padding
grid_height = num_rows * (square_size + grid_padding) + grid_padding

# Create the matrix
matrix = [[0 for j in range(num_cols)] for i in range(num_rows)]
number_mines = 10  # number of mines to place

# Place the mines randomly in the matrix
for i in range(number_mines):
    row = random.randint(0, num_rows - 1)
    col = random.randint(0, num_cols - 1)
    while matrix[row][col] == -1:
        # If a mine is already at this location, try again
        row = random.randint(0, num_rows - 1)
        col = random.randint(0, num_cols - 1)
    matrix[row][col] = -1

# Check the neighbors of each element and update the matrix
for i in range(num_rows):
    for j in range(num_cols):
        if matrix[i][j] != -1:
            # Count the number of neighboring mines
            count = 0
            for x in range(max(0, i - 1), min(num_rows, i + 2)):
                for y in range(max(0, j - 1), min(num_cols, j + 2)):
                    if matrix[x][y] == -1:
                        count += 1
            matrix[i][j] = count

# Set up the font
font = pygame.font.Font(None, 18)

# Create the grid surface
grid_surface = pygame.Surface((grid_width, grid_height))
grid_surface.fill(BLACK)

# Create the flagged matrix
flagged = [[False for j in range(num_cols)] for i in range(num_rows)]

# Draw the gray squares
for i in range(num_rows):
    for j in range(num_cols):
        x = j * (square_size + grid_padding) + grid_padding
        y = i * (square_size + grid_padding) + grid_padding
        pygame.draw.rect(grid_surface, GRAY, pygame.Rect(
            x, y, square_size, square_size))

# Blit the grid surface to the screen
screen.blit(grid_surface, (0, (height - grid_height) // 2))

# Update the display
pygame.display.update()

# Run the game loop
revealed = [[False for j in range(num_cols)] for i in range(num_rows)]
game_over = False


def reveal_square(i, j):
    # Reveal the square at (i, j)
    revealed[i][j] = True
    # Draw the appropriate square on the grid surface
    x = j * (square_size + grid_padding) + grid_padding
    y = i * (square_size + grid_padding) + grid_padding
    if matrix[i][j] == -1:
        # Draw an orange square for a mine
        pygame.draw.rect(grid_surface, ORANGE, pygame.Rect(
            x, y, square_size, square_size))
        # Game over
        global game_over
        game_over = True
    elif matrix[i][j] == 0:
        # Draw a white square for a zero
        pygame.draw.rect(grid_surface, WHITE, pygame.Rect(
            x, y, square_size, square_size))
        # Reveal neighboring squares
        for (x, y) in [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]:
            if (0 <= x < num_rows) and (0 <= y < num_cols) and not revealed[x][y]:
                # Recursively reveal neighboring squares
                reveal_square(x, y)
    else:
        # Draw a green square for a number
        pygame.draw.rect(grid_surface, GREEN, pygame.Rect(
            x, y, square_size, square_size))
        # Draw the number in the square
        text_surface = font.render(str(matrix[i][j]), True, BLACK)
        text_rect = text_surface.get_rect(
            center=(x + square_size / 2, y + square_size / 2))
        grid_surface.blit(text_surface, text_rect)


while not game_over:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            game_over = True
        elif event.type == pygame.MOUSEBUTTONDOWN:
            # Get the position of the mouse click
            pos = pygame.mouse.get_pos()
            # Convert to grid coordinates
            i = (pos[1] - (height - grid_height) // 2 -
                 grid_padding) // (square_size + grid_padding)
            j = (pos[0] - grid_padding) // (square_size + grid_padding)
            # Check if the square has already been revealed
            if not revealed[i][j]:
                # Check if the right mouse button was clicked
                if event.button == 3:
                    # Check if the square is already flagged
                    if flagged[i][j]:
                        # Remove the flag
                        flagged[i][j] = False
                        # Draw a gray square
                        x = j * (square_size + grid_padding) + grid_padding
                        y = i * (square_size + grid_padding) + grid_padding
                        pygame.draw.rect(grid_surface, GRAY, pygame.Rect(
                            x, y, square_size, square_size))
                    else:
                        # Draw a red square for a flag
                        x = j * (square_size + grid_padding) + grid_padding
                        y = i * (square_size + grid_padding) + grid_padding
                        pygame.draw.rect(grid_surface, RED, pygame.Rect(
                            x, y, square_size, square_size))
                        # Flag the square
                        flagged[i][j] = True
                else:
                    # Reveal the square and its neighbors
                    reveal_square(i, j)

    # Blit the grid surface to the screen
    screen.blit(grid_surface, (0, (height - grid_height) // 2))

    # Update the display
    pygame.display.update()

# Quit Pygame
pygame.quit()
