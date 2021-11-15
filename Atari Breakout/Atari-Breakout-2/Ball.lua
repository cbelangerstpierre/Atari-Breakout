Ball = Class{}

function Ball:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.dy = BALL_SPEED
    if math.random(-1, 1) < 0 then
        self.dx = math.random(-BALL_SPEED/2, -BALL_SPEED/4)
    else
        self.dx = math.random(BALL_SPEED/2, BALL_SPEED/4)
    end
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collides(object)
    if not object == platform then
        for i = 0, tablelength(object) - 1, 1
        do
            if not self.x > object[i].x + object[i].width or object[i].x > self.x + self.radius * 2 and not 
            self.y > object[i].y + object[i].height or object[i].y > self.y + self.radius * 2 then
                return true
            end
        end
    else
        if not (self.x > object.x + object.width or object.x > self.x + self.radius * 2) and not 
        (self.y > object.y + object.height or object.y > self.y + self.radius * 2) then
            return true
        end
    end
return false
end

function Ball:touchWall()
    --below
    if self.y >= VIRTUAL_HEIGHT then
        self:reset()
        score = score - 1
    --above
    elseif self.y <= 0 then
        self.y = self.y + self.radius * 2
        self.dy = -self.dy
    --left
    elseif self.x <= 0 then
        self.x = self.x + self.radius * 2
        self.dx = -self.dx
    --right
    elseif self.x >= VIRTUAL_WIDTH then
        self.x = self.x - self.radius * 2
        self.dx = -self.dx
    end
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2
    self.dy = BALL_SPEED
    if math.random(-1, 1) < 0 then
        self.dx = math.random(-BALL_SPEED/2, -BALL_SPEED/4)
    else
        self.dx = math.random(BALL_SPEED/2, BALL_SPEED/4)
    end
end

function Ball:render()
    love.graphics.setColor({1, 1, 1})
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
