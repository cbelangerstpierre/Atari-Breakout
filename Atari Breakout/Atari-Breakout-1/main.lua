WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PLATFORM_WIDTH = 30
PLATFORM_HEIGHT = 5
BRICK_WIDTH = 10
BRICK_HEIGHT = 5
PLATFORM_SPEED = 200

push = require "push"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    bigFont = love.graphics.newFont("font.ttf", 16)
    love.graphics.setFont(bigFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

platformX = (VIRTUAL_WIDTH - PLATFORM_WIDTH) / 2
score = 0

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) then
        platformX = platformX - PLATFORM_SPEED * dt
    end
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) then
        platformX = platformX + PLATFORM_SPEED * dt
    end
end


function love.draw()
    push:apply("start")
    love.graphics.clear(20/255, 20/255, 20/255, 255/255)
    love.graphics.printf("Atari Breakout", 0, 10, VIRTUAL_WIDTH, "center")
    
    love.graphics.printf(score, VIRTUAL_WIDTH*4/5, 10, VIRTUAL_WIDTH, "left")

    love.graphics.setColor(20/255, 20/255, 255/255, 255/255)

    love.graphics.rectangle(
    "fill",
    platformX,
    VIRTUAL_HEIGHT - PLATFORM_HEIGHT - 20,
    PLATFORM_WIDTH,
    PLATFORM_HEIGHT)


    push:apply("end")
end
