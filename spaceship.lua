local missile = missile or require 'missile'
local gameManager = nil

Spaceship = {}
Spaceship.new = function(x, y, r)
    local self = {}
    self.x = x
    self.y = y
    self.r = r
    self.xv = 0
    self.yv = 0
    self.image = love.graphics.newImage("assets/love-ball.png")
    self.h = 64
    self.w = 64
    self.alive = true
    self.screenwidth = love.graphics.getWidth()
    self.screenheight = love.graphics.getHeight()
    self.lastShotTime = love.timer.getTime()
    self.acceleration = 0
    self.polarVelocity = 0
    self.shooting = false
    self.missiles = {}
    self.maxMissiles = 5

    self.shoot = function()
        gameManager = gameManager or require 'GameManager'
        if love.timer.getTime() - self.lastShotTime > 0.2 then
            if self.getNumMissiles() < self.maxMissiles then
                gameManager.shootMissile(self)
            end
            self.lastShotTime = love.timer.getTime()
        end
    end

    self.draw = function()
        if self.alive then
           love.graphics.draw(self.image, self.x, self.y, self.r, 1, 1, self.w / 2, self.h / 2)
        end
    end

    self.getNumMissiles = function()
        local n = 0
        for _,missile in ipairs(self.missiles) do
            if missile.owner == self then
                n = n + 1
            end
        end

        return n
    end

    self.update = function(dt)
        if self.alive then
            if self.shooting then
                self.shoot()
            end

            self.accelerate(dt * self.acceleration)
            self.turn(dt * self.polarVelocity)

            self.y = self.y + self.yv * dt
            self.x = self.x - self.xv * dt
        
            if self.x > self.screenwidth then
                self.x = 0
            elseif self.x < 0 then
                self.x = self.screenwidth
            end
        
            if self.y > self.screenheight then
                self.y = 0
            elseif self.y < 0 then
                self.y = self.screenheight
            end
        end
    end

    self.turn = function(r)
    	self.r = self.r + r
    end

    self.accelerate = function(v)
        self.xv = self.xv - math.cos(self.r) * v
        self.yv = self.yv + math.sin(self.r) * v
    end
    
    return self
end

return Spaceship
