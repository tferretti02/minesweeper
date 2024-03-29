import pygame
import random


def run_game(difficulty=1):
    print("run_game() called")
    pygame.init()

    # Define some colors
    BLACK = (0, 0, 0)
    GREEN = (0, 255, 0)
    GRAY = (128, 128, 128)
    WHITE = (255, 255, 255)
    ORANGE = (255, 165, 0)
    RED = (255, 0, 0)

    if difficulty == 1:
        num_rows = 8
        num_cols = 10
        number_mines = 10
    elif difficulty == 2:
        num_rows = 14
        num_cols = 18
        number_mines = 40
    elif difficulty == 3:
        num_rows = 20
        num_cols = 24
        number_mines = 99

    square_size = 30
    grid_padding = 5

    # Set up the screen
    width = num_cols * (square_size + grid_padding) + grid_padding
    height = num_rows * (square_size + grid_padding) + grid_padding + 40
    screen = pygame.display.set_mode((width, height))
    pygame.display.set_caption("Minesweeper")

    # Calculate the size of the grid surface
    grid_width = width
    grid_height = height - 40

    # Create the matrix
    matrix = [[0 for j in range(num_cols)] for i in range(num_rows)]

    game_won = False
    game_lost = False

    win_font = pygame.font.Font(None, 36)
    lose_font = pygame.font.Font(None, 36)

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
    flag_image = pygame.image.load("./flag.jpg")
    flag_size = (square_size, square_size)
    flag_image = pygame.transform.scale(flag_image, flag_size)

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

    def reveal_square(i, j, game_state):
        game_won = game_state["game_won"]
        game_lost = game_state["game_lost"]

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
            game_state["game_lost"] = True
        elif matrix[i][j] == 0:
            # Draw a white square for a zero
            pygame.draw.rect(grid_surface, WHITE, pygame.Rect(
                x, y, square_size, square_size))
            # Reveal neighboring squares
            for x in range(max(0, i - 1), min(num_rows, i + 2)):
                for y in range(max(0, j - 1), min(num_cols, j + 2)):
                    if not revealed[x][y]:
                        # Recursively reveal neighboring squares
                        reveal_square(x, y, game_state)
        else:
            # Draw a green square for a number
            pygame.draw.rect(grid_surface, GREEN, pygame.Rect(
                x, y, square_size, square_size))
            # Draw the number in the square
            text_surface = font.render(str(matrix[i][j]), True, BLACK)
            text_rect = text_surface.get_rect(
                center=(x + square_size / 2, y + square_size / 2))
            grid_surface.blit(text_surface, text_rect)
        # Check if the game has been won
        if all(all(revealed[i][j] or matrix[i][j] == -1 for j in range(num_cols)) for i in range(num_rows)):
            game_won = True

    # Initialize the timer
    timer = 0

    # Set up the font for the timer text
    timer_font = pygame.font.Font(None, 18)

    # Create a text surface for the timer
    timer_text = timer_font.render("Time: " + str(timer), True, WHITE)

    # Run the game loop
    revealed = [[False for j in range(num_cols)] for i in range(num_rows)]
    game_state = {"game_won": False, "game_lost": False, "game_over": False}
    while not (game_state["game_won"] or game_state["game_lost"] or game_state["game_over"]):
        num_flagged = number_mines
        for i in range(num_rows):
            for j in range(num_cols):
                if flagged[i][j]:
                    num_flagged -= 1
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                game_state["game_over"] = True
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
                            # Draw a flag
                            x = j * (square_size + grid_padding) + grid_padding
                            y = i * (square_size + grid_padding) + grid_padding
                            grid_surface.blit(flag_image, (x, y))
                            # Flag the square
                            flagged[i][j] = True
                    else:
                        # Check if the square is flagged
                        if not flagged[i][j]:
                            # Reveal the square and its neighbors
                            reveal_square(i, j, game_state)

        # Increment the timer
        timer = pygame.time.get_ticks()

        # change milliseconds into minutes, seconds
        counting_minutes = str(timer//60000).zfill(2)
        counting_seconds = str((timer % 60000)//1000).zfill(2)

        counting_string = "%s:%s" % (
            counting_minutes, counting_seconds)

        # Set up the font for the timer text
        timer_font = pygame.font.Font(None, 30)

        # Create a text surface for the updated timer value
        timer_text = timer_font.render(
            "Time: " + str(counting_string), True, WHITE)

        # Blit the grid surface to the screen
        screen.fill(BLACK)
        screen.blit(grid_surface, ((width - grid_width) //
                    2, (height - grid_height) // 2))

        # Blit the timer text onto the game screen
        screen.blit(timer_text, (grid_padding, grid_padding))

        # Set up the font for the flagged cell count
        flag_font = pygame.font.Font(None, 24)

        # Create a text surface for the flagged cell count
        flag_text = flag_font.render("Flags: " + str(num_flagged), True, WHITE)

        # Get the rect for the text surface
        flag_rect = flag_text.get_rect()

        # Set the position of the text surface
        flag_rect.topright = (width - grid_padding, grid_padding)

        # Blit the flagged cell count onto the screen
        screen.blit(flag_text, flag_rect)

        # Update the display
        pygame.display.update()

    if game_state["game_over"]:
        message = lose_font.render("Game closed.", True, RED)
    else:
        # Game over, show message
        if game_state["game_won"]:
            message = win_font.render("Congratulations, you won!", True, RED)
        elif game_state["game_lost"]:
            message = lose_font.render("Sorry, you lost.", True, RED)

        # Blit the message to the center of the screen
        message_rect = message.get_rect(center=(width // 2, height // 2))
        screen.blit(message, message_rect)

        # Update the display
        pygame.display.update()

        # Wait for a few seconds before quitting
        pygame.time.wait(3000)

        # Quit Pygame
        pygame.quit()
