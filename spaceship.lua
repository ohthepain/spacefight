require 'missile'

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

    self.shoot = function()
        if love.timer.getTime() - self.lastShotTime > 0.7 then
            shootMissile(self)
            self.lastShotTime = love.timer.getTime()
        end
    end

    self.draw = function()
        if self.alive then
           love.graphics.draw(self.image, self.x, self.y, self.r, 1, 1, self.w / 2, self.h / 2)
        end
    end

    self.update = function(dt)
        if self.alive then
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
