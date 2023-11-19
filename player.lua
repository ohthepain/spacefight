Player = {}
Player.new = function(name, spaceship)
    local self = {}

    self.name = name
    self.spaceship = spaceship
    self.score = 0

    return self
end
