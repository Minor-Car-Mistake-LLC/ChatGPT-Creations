package main

import (
	"fmt"
	"math/rand"
	"time"

	"github.com/nsf/termbox-go"
)

const (
	width  = 40
	height = 30
)

type point struct {
	x, y int
}

type direction int

const (
	dirUp direction = iota
	dirDown
	dirLeft
	dirRight
)

var (
	snake    []point
	food     point
	dir      direction
	gameOver bool
)

func main() {
	rand.Seed(time.Now().UnixNano())

	if err := termbox.Init(); err != nil {
		panic(err)
	}
	defer termbox.Close()

	snake = []point{{width / 2, height / 2}}
	food = randomPoint()
	dir = dirRight

	termbox.SetInputMode(termbox.InputEsc)
	termbox.SetOutputMode(termbox.Output256)

	gameLoop()
}

func gameLoop() {
	// set up game loop
	fps := 10
	interval := time.Second / time.Duration(fps)
	ticker := time.NewTicker(interval)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			update()
			render()

			if gameOver {
				return
			}

		case ev := <-eventQueue():
			switch ev.Type {
			case termbox.EventKey:
				switch ev.Key {
				case termbox.KeyArrowUp:
					dir = dirUp
				case termbox.KeyArrowDown:
					dir = dirDown
				case termbox.KeyArrowLeft:
					dir = dirLeft
				case termbox.KeyArrowRight:
					dir = dirRight
				case termbox.KeyEsc:
					gameOver = true
				}
			}

			if gameOver {
				return
			}
		}
	}
}

func update() {
	// move snake
	head := snake[len(snake)-1]
	switch dir {
	case dirUp:
		head.y--
	case dirDown:
		head.y++
	case dirLeft:
		head.x--
	case dirRight:
		head.x++
	}
	snake = append(snake, head)

	// check collision with wall
	if head.x < 0 || head.x >= width || head.y < 0 || head.y >= height {
		gameOver = true
		return
	}

	// check collision with self
	for i := 0; i < len(snake)-1; i++ {
		if head == snake[i] {
			gameOver = true
			return
		}
	}

	// check collision with food
	if head == food {
		food = randomPoint()
	} else {
		snake = snake[1:]
	}
}

func render() {
	termbox.Clear(termbox.ColorDefault, termbox.ColorDefault)

	// render snake
	for _, p := range snake {
		termbox.SetCell(p.x, p.y, ' ', termbox.ColorGreen, termbox.ColorDefault)
	}

	// render food
	termbox.SetCell(food.x, food.y, ' ', termbox.ColorRed, termbox.ColorDefault)

	termbox.Flush()
}

func randomPoint() point {
	return point{rand.Intn(width), rand.Intn(height)}
}

func eventQueue() chan termbox.Event {
	c := make(chan termbox.Event)
	go func() {
		for {
			c <- termbox.PollEvent()
		}
	}()
	return c
}
