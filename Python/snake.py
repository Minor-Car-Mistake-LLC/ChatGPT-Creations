import pygame
import random

pygame.init()

# Set up screen dimensions
WIDTH = 400
HEIGHT = 400
GRID_SIZE = 20
GRID_WIDTH = WIDTH // GRID_SIZE
GRID_HEIGHT = HEIGHT // GRID_SIZE

# Set up colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)

# Set up game clock
clock = pygame.time.Clock()

# Set up game window
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Snake Game")

# Set up game state
snake = [(GRID_WIDTH // 2, GRID_HEIGHT // 2)]
snake_dir = (0, 0)
food = (random.randint(0, GRID_WIDTH - 1), random.randint(0, GRID_HEIGHT - 1))

# Main game loop
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP:
                snake_dir = (0, -1)
            elif event.key == pygame.K_DOWN:
                snake_dir = (0, 1)
            elif event.key == pygame.K_LEFT:
                snake_dir = (-1, 0)
            elif event.key == pygame.K_RIGHT:
                snake_dir = (1, 0)

    # Update snake position
    head = (snake[0][0] + snake_dir[0], snake[0][1] + snake_dir[1])
    snake.insert(0, head)

    # Check if snake collides with the food
    if snake[0] == food:
        food = (random.randint(0, GRID_WIDTH - 1), random.randint(0, GRID_HEIGHT - 1))
    else:
        snake.pop()

    # Check if snake collides with the walls
    if (head[0] < 0 or head[0] >= GRID_WIDTH or
            head[1] < 0 or head[1] >= GRID_HEIGHT):
        pygame.quit()
        sys.exit()

    # Check if snake collides with itself
    if head in snake[1:]:
        pygame.quit()
        sys.exit()

    # Clear screen
    screen.fill(BLACK)

    # Draw snake
    for segment in snake:
        pygame.draw.rect(screen, GREEN, pygame.Rect(segment[0] * GRID_SIZE, segment[1] * GRID_SIZE, GRID_SIZE, GRID_SIZE))

    # Draw food
    pygame.draw.rect(screen, RED, pygame.Rect(food[0] * GRID_SIZE, food[1] * GRID_SIZE, GRID_SIZE, GRID_SIZE))

    # Update display
    pygame.display.flip()

    # Limit frames per second
    clock.tick(10)
