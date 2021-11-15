WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PLATFORM_WIDTH = 30
PLATFORM_HEIGHT = 5
BRICK_WIDTH = 27
BRICK_HEIGHT = 5
BALL_RADIUS = 3
PLATFORM_SPEED = 200
BALL_SPEED = 100
NUMBER_OF_BRICKS_WIDTH = VIRTUAL_WIDTH / BRICK_WIDTH
NUMBER_OF_BRICKS_HEIGHT = 4
NUMBER_OF_BRICKS = NUMBER_OF_BRICKS_HEIGHT * NUMBER_OF_BRICKS_WIDTH

push = require "push"

Class = require "class"
require "Platform"
require "Ball"
require "Brick"

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.window.setTitle("Atari Breakout")

    smallFont = love.graphics.newFont("font.ttf", 8)
    bigFont = love.graphics.newFont("font.ttf", 16)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    sounds = {
        ['platform_hit'] = love.audio.newSource('sounds/platform_hit.wav', 'static'),
        ['lose'] = love.audio.newSource('sounds/lose.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.mp3', 'static')
    }

    platform = Platform(
    (VIRTUAL_WIDTH - PLATFORM_WIDTH) / 2,
    VIRTUAL_HEIGHT - PLATFORM_HEIGHT - 20,
    PLATFORM_WIDTH,
    PLATFORM_HEIGHT
    )

    ball = Ball(
    VIRTUAL_WIDTH / 2,
    VIRTUAL_HEIGHT / 2,
    BALL_RADIUS
    )

    colors = {{255, 0, 0}, {255, 255, 0}, {0, 255, 0}, {0, 255, 255}}

    bricks = {}
    for i = 1,4,1
    do
        for j = 1,NUMBER_OF_BRICKS_WIDTH,1
        do
            bricks[(i - 1) * (NUMBER_OF_BRICKS_WIDTH) + j] = 
            Brick(
            (j - 1) * BRICK_WIDTH,
            (i - 1) * BRICK_HEIGHT + VIRTUAL_HEIGHT/4,
            BRICK_WIDTH,
            BRICK_HEIGHT,
            colors[i]
            )
        end
    end

    gameState = "start"
end

score = 0
newBall = 3
coeffecient = 1
message = ""

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if newBall > 0 then
            if gameState == "start" then
                newBall = newBall - 1
                gameState = "play"
            elseif gameState == "done" then
                newBall = newBall - 1
                gameState = "play"
            end
        else
            restart()
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        platform.dx = -PLATFORM_SPEED
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        platform.dx = PLATFORM_SPEED
    else
        platform.dx = 0
    end

    platform:update(dt)
    if gameState == "play" then
        message = ""
        ball:touchWall()
        if ball:collidesPlatform(platform) then
            ball.dy = -ball.dy * 1.03
            if ball.dx < 0 then
                ball.dx = -math.random(10, 150)
            else
                ball.dx = math.random(10,150)
            end
            ball.y = ball.y - PLATFORM_HEIGHT
        end
        if ball:collidesBricks(bricks) then
            ball.dy = -ball.dy
        end
        ball:update(dt)
    elseif gameState == "start" then
        message = "Press enter to start."
    end
    if newBall == 0 and ball.y >= VIRTUAL_HEIGHT then
        gameState = "done"
        message = "You lost... Press enter to restart."
    end

    counter = 0
    for i = 1, NUMBER_OF_BRICKS, 1
    do
        if bricks[i].x == -100 then
            counter = counter + 1
        end
    end
    if counter == NUMBER_OF_BRICKS then
        gameState = "done"
        message = "You won with " .. score .. " points! Press enter to restart."
    end
end

function love.draw()
    push:apply("start")
    love.graphics.clear(20/255, 20/255, 20/255, 255/255)
    love.graphics.setFont(bigFont)
    love.graphics.printf("Atari Breakout", 0, 5, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(smallFont)
    love.graphics.printf("New Ball(s): " .. newBall, 0, 20, VIRTUAL_WIDTH, "center")
    love.graphics.printf(message, 0, VIRTUAL_HEIGHT*2/3, VIRTUAL_WIDTH, "center")
    
    love.graphics.printf("Score: " .. score, VIRTUAL_WIDTH*4/5, 10, VIRTUAL_WIDTH, "left")

    platform:render()
    ball:render()
    for i = 1,NUMBER_OF_BRICKS,1
    do
        bricks[i]:render()
    end

    displayFPS()

    push:apply("end")
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function restart()
    gameState = "start"
    newBall = 3
    score = 0
    coeffecient = 1
    message = ""
    platform.x = (VIRTUAL_WIDTH - PLATFORM_WIDTH) / 2
    platform.y = VIRTUAL_HEIGHT - PLATFORM_HEIGHT - 20
    ball.x = VIRTUAL_WIDTH / 2
    ball.y = VIRTUAL_HEIGHT / 2
    for i = 1,4,1
    do
        for j = 1,NUMBER_OF_BRICKS_WIDTH,1
        do
            bricks[(i - 1) * (NUMBER_OF_BRICKS_WIDTH) + j] = 
            Brick(
            (j - 1) * BRICK_WIDTH,
            (i - 1) * BRICK_HEIGHT + VIRTUAL_HEIGHT/4,
            BRICK_WIDTH,
            BRICK_HEIGHT,
            colors[i]
            )
        end
    end
end
