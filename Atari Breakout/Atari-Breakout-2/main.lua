WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PLATFORM_WIDTH = 30
PLATFORM_HEIGHT = 5
BRICK_WIDTH = 10
BRICK_HEIGHT = 5
BALL_RADIUS = 3
PLATFORM_SPEED = 400
BALL_SPEED = 200

push = require "push"

Class = require "class"
require "Platform"
require "Ball"

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.window.setTitle("Atari Breakout")

    smallFont = love.graphics.newFont("font.ttf", 8)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

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

    gameState = "start"
end

score = 0

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "play"
        else
            gameState = "start"
            ball:reset()
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
        ball:touchWall()
        if ball:collides(platform) then
            ball.dy = -ball.dy
            if ball.dx < 0 then
                ball.dx = -math.random(10, 150)
            else
                ball.dx = math.random(10,150)
            ball.y = ball.y - platform.height
            end
        end
        ball:update(dt)
    end
end

function love.draw()
    push:apply("start")
    love.graphics.clear(20/255, 20/255, 20/255, 255/255)
    love.graphics.printf("Atari Breakout", 0, 10, VIRTUAL_WIDTH, "center")
    
    love.graphics.printf(score, VIRTUAL_WIDTH*4/5, 10, VIRTUAL_WIDTH, "left")

    platform:render()
    ball:render()

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
