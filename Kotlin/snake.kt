package com.example.snake

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import android.widget.Toast
import java.util.*
import kotlin.concurrent.fixedRateTimer

class SnakeGameView(context: Context, attrs: AttributeSet?) : View(context, attrs) {
    private val gridSize = 50
    private var gameWidth = 0
    private var gameHeight = 0
    private var score = 0
    private var snake: LinkedList<Pair<Int, Int>> = LinkedList()
    private var food: Pair<Int, Int> = Pair(0, 0)
    private var direction = Direction.RIGHT
    private var running = false
    private var timer: Timer? = null

    init {
        setOnTouchListener { _, event ->
            handleTouchEvent(event)
            true
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        val width = MeasureSpec.getSize(widthMeasureSpec)
        val height = MeasureSpec.getSize(heightMeasureSpec)
        gameWidth = width / gridSize
        gameHeight = height / gridSize
        resetGame()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        canvas.drawColor(Color.BLACK)

        // draw food
        val paint = Paint().apply { color = Color.YELLOW }
        canvas.drawRect(food.first * gridSize.toFloat(), food.second * gridSize.toFloat(),
                (food.first + 1) * gridSize.toFloat(), (food.second + 1) * gridSize.toFloat(), paint)

        // draw snake
        paint.color = Color.WHITE
        for (segment in snake) {
            canvas.drawRect(segment.first * gridSize.toFloat(), segment.second * gridSize.toFloat(),
                    (segment.first + 1) * gridSize.toFloat(), (segment.second + 1) * gridSize.toFloat(), paint)
        }
    }

    private fun handleTouchEvent(event: MotionEvent) {
        if (event.action == MotionEvent.ACTION_DOWN) {
            if (!running) {
                startGame()
            } else {
                when (event.x < width / 2) {
                    true -> changeDirection(Direction.LEFT)
                    false -> changeDirection(Direction.RIGHT)
                }
            }
        }
    }

    private fun startGame() {
        resetGame()
        running = true
        timer = fixedRateTimer("gameTimer", false, 0L, 200L) {
            moveSnake()
            postInvalidate()
        }
    }

    private fun resetGame() {
        snake.clear()
        snake.add(Pair(gameWidth / 2, gameHeight / 2))
        generateFood()
        score = 0
        direction = Direction.RIGHT
    }

    private fun generateFood() {
        food = Pair((0 until gameWidth).random(), (0 until gameHeight).random())
    }

    private fun moveSnake() {
        val newHead = Pair(snake.first().first + direction.x, snake.first().second + direction.y)

        if (newHead.first < 0 || newHead.first >= gameWidth || newHead.second < 0 || newHead.second >= gameHeight) {
            gameOver()
            return
        }

        if (snake.contains(newHead)) {
            gameOver()
            return
        }

        snake.addFirst(newHead)

        if (newHead == food) {
            generateFood()
            score++
        } else {
            snake.removeLast()
        }
    }

    private fun gameOver() {
        running = false
        timer?.cancel()
        timer = null
