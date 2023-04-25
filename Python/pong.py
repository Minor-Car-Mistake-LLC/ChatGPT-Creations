import pygame
import sys
import random

# Constants
WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
BALL_RADIUS = 10
PADDLE_WIDTH = 15
PADDLE_HEIGHT = 60
PADDLE_SPEED = 5
BALL_SPEED_X = 3
BALL_SPEED_Y = 3

# Colors
BLACK = pygame.Color('black')
WHITE = pygame.Color('white')

# Initialize Pygame
pygame.init()

# Set up window
window = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
pygame.display.set_caption('Pong')

# Set up clock
clock = pygame.time.Clock()

# Set up ball
ball = pygame.Rect(WINDOW_WIDTH // 2 - BALL_RADIUS, WINDOW_HEIGHT // 2 - BALL_RADIUS, BALL_RADIUS * 2, BALL_RADIUS * 2)
ball_speed_x = BALL_SPEED_X
ball_speed_y = BALL_SPEED_Y

# Set up paddles
paddle_a = pygame.Rect(0, WINDOW_HEIGHT // 2 - PADDLE_HEIGHT // 2, PADDLE_WIDTH, PADDLE_HEIGHT)
paddle_b = pygame.Rect(WINDOW_WIDTH - PADDLE_WIDTH, WINDOW_HEIGHT // 2 - PADDLE_HEIGHT // 2, PADDLE_WIDTH, PADDLE_HEIGHT)

# Set up fonts
font = pygame.font.Font(None, 36)

# Initialize scores
score_a = 0
score_b = 0

# Function to reset the game
def reset_game():
    global score_a, score_b
    ball.center = (WINDOW_WIDTH // 2, WINDOW_HEIGHT // 2)
    ball_speed_x = BALL_SPEED_X
    ball_speed_y = BALL_SPEED_Y
    score_a = 0
    score_b = 0

# Main game loop
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    # Update ball position
    ball.x += ball_speed_x
    ball.y += ball_speed_y

    # Check collision with paddles
    if ball.colliderect(paddle_a) or ball.colliderect(paddle_b):
        ball_speed_x *= -1

    # Check collision with top and bottom walls
    if ball.top <= 0 or ball.bottom >= WINDOW_HEIGHT:
        ball_speed_y *= -1

    # Check if ball goes off the screen
    if ball.left <= 0:
        # Player B scores
        score_b += 1
        reset_game()
    elif ball.right >= WINDOW_WIDTH:
        # Player A scores
        score_a += 1
        reset_game()

    # Update paddles
    keys = pygame.key.get_pressed()
    if keys[pygame.K_UP] and paddle_b.top > 0:
        paddle_b.y -= PADDLE_SPEED
    if keys[pygame.K_DOWN] and paddle_b.bottom < WINDOW_HEIGHT:
        paddle_b.y += PADDLE_SPEED

    # AI-controlled paddle for Player A
    # Paddle A will move towards the ball's y-coordinate
    if paddle_a.centery < ball.centery and paddle_a.bottom < WINDOW_HEIGHT:
        paddle_a.y += PADDLE_SPEED
    elif paddle_a.centery > ball.centery and paddle_a.top > 0:
        paddle_a.y -= PADDLE_SPEED

    # Clear screen
    window.fill(BLACK)

    # Draw ball
    pygame.draw.circle(window, WHITE, (ball.x + BALL_RADIUS, ball.y + BALL_RADIUS), BALL_RADIUS)

    # Draw paddles
    pygame.draw.rect(window, WHITE, paddle_a)
    pygame.draw.rect(window, WHITE, paddle_b)

    # Draw score
    score_text = font.render(f'{score_a} - {score_b}', True, WHITE)
    score_text_rect = score_text.get_rect()
    score_text_rect.center = (WINDOW_WIDTH // 2, 20)
    window.blit(score_text, score_text_rect)

    # Draw center line
    pygame.draw.aaline(window, WHITE, (WINDOW_WIDTH // 2, 0), (WINDOW_WIDTH // 2, WINDOW_HEIGHT))

    # Update display
    pygame.display.flip()

    # Limit frames per second
    clock.tick(60)