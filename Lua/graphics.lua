-- Variables
local angle = 0
local consoleWidth = 80
local consoleHeight = 24
local rectangleWidth = 20
local rectangleHeight = 10

-- Function to clear the console
function clearConsole()
    if os.name == "windows" then
        os.execute("cls")
    else
        os.execute("clear")
    end
end

-- Function to draw the rectangle
function drawRectangle()
    -- Clear the console
    clearConsole()

    -- Calculate the center coordinates
    local centerX = math.floor(consoleWidth / 2)
    local centerY = math.floor(consoleHeight / 2)

    -- Rotate the rectangle
    local cos = math.cos(angle)
    local sin = math.sin(angle)

    -- Draw the rectangle
    for y = -rectangleHeight / 2, rectangleHeight / 2 do
        for x = -rectangleWidth / 2, rectangleWidth / 2 do
            local rotatedX = math.floor(x * cos - y * sin)
            local rotatedY = math.floor(x * sin + y * cos)
            if rotatedX == 0 and rotatedY == 0 then
                io.write("*")
            else
                io.write(" ")
            end
        end
        io.write("\n")
    end
end

-- Main loop
while true do
    -- Update the angle to make the rectangle spin
    angle = angle + 0.1

    -- Draw the rectangle
    drawRectangle()

    -- Wait for a short time to control the rotation speed
    os.execute("sleep 0.1")
end
