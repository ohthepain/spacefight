local gameManager = nil

Missile = {}
Missile.new = function(owner)
    gameManager = gameManager or require 'GameManager'
    local self = {}
    self.owner = owner
    self.x = owner.x
    self.y = owner.y
    self.r = owner.r
    self.v = 300
    self.image = love.graphics.newImage("assets/love-cursor.png")
    self.alive = true
    self.age = 0
    self.screenwidth = love.graphics.getWidth()
    self.screenheight = love.graphics.getHeight()
    
    self.draw = function()
        if self.alive then
           love.graphics.draw(self.image, self.x, self.y, self.r, 1, 1, 13, 15)
        end
    end

    self.update = function(dt)
        if self.alive then
            self.x = self.x + self.v * dt * math.cos(self.r)
            self.y = self.y + self.v * dt * math.sin(self.r)
    
            self.age = self.age + dt

            -- collision detection
            for i,spaceship in ipairs(gameManager.spaceships) do
                if ((self.x - spaceship.x) * (self.x - spaceship.x) + (self.y - spaceship.y) * (self.y - spaceship.y) < 500) then
                    if self.owner ~= spaceship then
                        spaceship.alive = false
                        gameManager.score(spaceship)
                        gameManager.reset()
                    end
                end
            end

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

            if self.age > 3 then
                self.alive = false
            end
        end
    end

    return self
end

return Missile
