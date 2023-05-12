import android.graphics.*
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    // Constants
    private val WINDOW_WIDTH = 640
    private val WINDOW_HEIGHT = 480
    private val BALL_RADIUS = 10
    private val PADDLE_WIDTH = 15
    private val PADDLE_HEIGHT = 60
    private val PADDLE_SPEED = 5
    private val BALL_SPEED_X = 3
    private val BALL_SPEED_Y = 3

    // Colors
    private val BLACK = Color.BLACK
    private val WHITE = Color.WHITE

    // Variables
    private var ballX = 0
    private var ballY = 0
    private var ballSpeedX = BALL_SPEED_X
    private var ballSpeedY = BALL_SPEED_Y
    private var paddleAY = 0
    private var paddleBY = 0
    private var scoreA = 0
    private var scoreB = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Set up ball
        ballX = WINDOW_WIDTH / 2 - BALL_RADIUS
        ballY = WINDOW_HEIGHT / 2 - BALL_RADIUS

        // Set up paddles
        paddleAY = WINDOW_HEIGHT / 2 - PADDLE_HEIGHT / 2
        paddleBY = WINDOW_HEIGHT / 2 - PADDLE_HEIGHT / 2

        // Set up scores
        scoreA = 0
        scoreB = 0

        // Set up game loop
        val gameLoop = object : Runnable {
            override fun run() {
                update()
                draw()
                view.postDelayed(this, 16) // Adjust delay for desired frame rate
            }
        }

        // Start game loop
        val view = findViewById<View>(R.id.gameView) // Replace with your actual game view
        view.post(gameLoop)
    }

    private fun update() {
        // Update ball position
        ballX += ballSpeedX
        ballY += ballSpeedY

        // Check collision with paddles
        if (ballX < PADDLE_WIDTH && ballY + BALL_RADIUS >= paddleAY && ballY <= paddleAY + PADDLE_HEIGHT) {
            ballSpeedX *= -1
        } else if (ballX > WINDOW_WIDTH - PADDLE_WIDTH - BALL_RADIUS && ballY + BALL_RADIUS >= paddleBY && ballY <= paddleBY + PADDLE_HEIGHT) {
            ballSpeedX *= -1
        }

        // Check collision with walls
        if (ballY <= 0 || ballY >= WINDOW_HEIGHT - BALL_RADIUS) {
            ballSpeedY *= -1
        }

        // Check if ball goes off the screen
        if (ballX <= 0) {
            scoreB++
            resetGame()
        } else if (ballX >= WINDOW_WIDTH - BALL_RADIUS) {
            scoreA++
            resetGame()
        }

        // Update paddle B (AI-controlled)
        if (paddleBY + PADDLE_HEIGHT / 2 < ballY && paddleBY + PADDLE_HEIGHT < WINDOW_HEIGHT) {
            paddleBY += PADDLE_SPEED
        } else if (paddleBY + PADDLE_HEIGHT / 2 > ballY && paddleBY > 0) {
            paddleBY -= PADDLE_SPEED
        }
    }

    private fun draw() {
        // Get the canvas to draw on
        val canvas = surfaceHolder.lockCanvas()

        // Clear the canvas
        canvas.drawColor(BLACK)

        // Draw the ball
        val ballRect = Rect(ballX, ballY, ballX + BALL_RADIUS * 2, ballY + BALL_RADIUS * 2)
        canvas.drawCircle(ballRect.exactCenterX(), ballRect.exactCenterY(), BALL_RADIUS.toFloat(), paint)

        // Draw the paddles
        val paddleARect = Rect(0, paddleAY, PADDLE_WIDTH, paddleAY + PADDLE_HEIGHT)
        val paddleBRect = Rect(WINDOW_WIDTH - PADDLE_WIDTH, paddleBY, WINDOW_WIDTH, paddleBY + PADDLE_HEIGHT)
        canvas.drawRect(paddleARect, paint)
        canvas.drawRect(paddleBRect, paint)

        // Draw the score
        val scoreText = "Score: $scoreA - $scoreB"
        val scoreTextSize = paint.textSize
        val scoreTextBounds = Rect()
        paint.getTextBounds(scoreText, 0, scoreText.length, scoreTextBounds)
        val scoreTextX = (WINDOW_WIDTH - scoreTextBounds.width()) / 2
        val scoreTextY = (WINDOW_HEIGHT + scoreTextBounds.height()) / 2
        canvas.drawText(scoreText, scoreTextX.toFloat(), scoreTextY.toFloat(), paint)

        // Unlock the canvas and update the surface
        surfaceHolder.unlockCanvasAndPost(canvas)
    }

    // Helper function to reset the game
    private fun resetGame() {
        ballX = WINDOW_WIDTH / 2 - BALL_RADIUS
        ballY = WINDOW_HEIGHT / 2 - BALL_RADIUS
        ballSpeedX = BALL_SPEED_X
        ballSpeedY = BALL_SPEED_Y
    }
}
