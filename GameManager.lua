local cjson = require("json4lua.json.json") --https://gobyexample.com/json
local spaceship = spaceship or require 'spaceship'

screenwidth = love.graphics.getWidth()
screenheight = love.graphics.getHeight()

local GameManager = {}
GameManager.__index = GameManager
GameManager.new = function()
    print("GameManager.new")
    local self = {}
    setmetatable(self, GameManager)
    GameManager.theInstance = self

    self.id = math.random(100)
    
    self.missiles = {}
    self.spaceships = {}
    self.player1 = Player.new("foo")
    self.player2 = Player.new("bar")
    self.players = {}
    self.hero = self.player1
    self.players[1] = self.player1
    self.players[2] = self.player2
    print("%s\n", cjson.encode(self))

    self.wtf = function()
        print('hi from gamemanager')
    end

    self.print = function(s,...)
        return io.write("GameManager: " .. s:format(...))
    end

    self.getPlayer = function(n)
        return self.players[n]
    end

    self.print("%s\n", tostring(self.getPlayer(1)))
    self.print("%s\n", tostring(self.getPlayer(2)))
    self.print("%s\n", tostring(self.getPlayer(3)))

    self.getPlayerByName = function(name)
        self.print("getPlayer %s %s\n", name, self.id)
        for _,player in ipairs(self.players) do
            self.print("\t%s\n", player.name)
            if player.name == name then
                return player
            end
        end
        self.print("return nil\n")
    end

    self.reset = function()
        self.print("reset\n")
        for _,missile in ipairs(self.missiles) do
            missile.alive = false
        end
        self.missiles = {}
        self.spaceships = {}
    
        self.player1.spaceship = Spaceship.new(screenwidth / 5, screenheight / 2, math.pi)
        self.player2.spaceship = Spaceship.new(screenwidth * 4 / 5, screenheight / 2, 0)
    
        table.insert(self.spaceships, self.player1.spaceship)
        table.insert(self.spaceships, self.player2.spaceship)
    end    
    
    self.score = function(spaceship)
        for _,player in ipairs(self.players) do
            if player.spaceship == spaceship then
                player.score = player.score + 1
            end
        end
    end
    
    self.shootMissile = function(owner)
        missile = Missile.new(owner)
        table.insert(self.missiles, missile)
    end

    self.update = function(dt)
        missilescopy = {}
        for n, missile in ipairs(self.missiles) do
            missile.update(dt)
            if missile.alive then
                table.insert(missilescopy, missile)
            end
        end
        self.missiles = missilescopy
    
        for n, spaceship in ipairs(self.spaceships) do
            spaceship.update(dt)
        end
    end

    self.draw = function()
        for n, missile in ipairs(self.missiles) do
            missile.draw()
        end
    
        for n, spaceship in ipairs(self.spaceships) do
            spaceship.draw()
        end
    end
    
    self.reset()
    return self
end

GameManager.getInstance = function()
    return GameManager.theInstance
end

if not GameManager.theInstance then
    GameManager.new()
    if not GameManager.theInstance then
        print('WTF how can we not have an instance after calling new?')
    end
end

return GameManager.theInstance
