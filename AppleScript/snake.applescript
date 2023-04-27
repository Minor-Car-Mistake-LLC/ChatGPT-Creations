set initialSnakeLength to 3
set width to 20
set height to 10
set snakeSpeed to 0.2 -- in seconds

-- initialize the snake and the food
set snake to {}
repeat initialSnakeLength times
    set end of snake to {initialSnakeLength - it + 1, 5}
end repeat
set food to {random number from 1 to width, random number from 1 to height}

-- start the game loop
repeat
    -- clear the screen
    do shell script "clear"
    
    -- draw the game board
    repeat with y from height to 1 by -1
        repeat with x from 1 to width
            if {x, y} is in snake then
                set cell to "█"
            else if {x, y} = food then
                set cell to "$"
            else
                set cell to " "
            end if
            set gameBoard to (gameBoard & cell & " ")
        end repeat
        set gameBoard to (gameBoard & "\n")
    end repeat
    
    -- print the game board and the score
    set score to length of snake - initialSnakeLength
    display dialog (gameBoard & "\nScore: " & score) buttons {"Quit"} default button "Quit" cancel button "Quit" giving up after snakeSpeed
    
    -- get the user input
    set key to button returned of the result
    if key = "Quit" then
        exit repeat
    end if
    set newDirection to missing value
    if key = "up arrow" then
        set newDirection to {0, 1}
    else if key = "down arrow" then
        set newDirection to {0, -1}
    else if key = "left arrow" then
        set newDirection to {-1, 0}
    else if key = "right arrow" then
        set newDirection to {1, 0}
    end if
    
    -- update the snake direction
    if newDirection is not missing value then
        set head to item 1 of snake
        set newHead to {x of head + item 1 of newDirection, y of head + item 2 of newDirection}
        if newHead is in snake or x of newHead < 1 or x of newHead > width or y of newHead < 1 or y of newHead > height then
            display dialog "Game Over\nScore: " & score buttons {"Quit"} default button "Quit" cancel button "Quit"
            exit repeat
        end if
        if newHead = food then
            set food to {random number from 1 to width, random number from 1 to height}
        else
            set tail to item -1 of snake
            set snake to items 2 thru -1 of snake
        end if
        set snake to {newHead} & snake
    end if
    
    -- wait for the next frame
    delay snakeSpeed
end repeat
