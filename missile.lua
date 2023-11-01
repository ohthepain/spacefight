Missile = {}
Missile.new = function(owner)
    local self = {}
    self.owner = owner
    self.x = owner.x
    self.y = owner.y
    self.r = owner.r
    self.v = 300
    self.image = love.graphics.newImage("assets/love-cursor.png")
    self.alive = true
    self.age = 0

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
            for i,spaceship in ipairs(spaceships) do
                if ((self.x - spaceship.x) * (self.x - spaceship.x) + (self.y - spaceship.y) * (self.y - spaceship.y) < 500) then
                    if self.owner ~= spaceship then
                        spaceship.alive = false
                    end
                end
            end

            if self.age > 3 then
                self.alive = false
            end
        end
    end

    return self
end
