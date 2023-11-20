local _ENV = require 'strict.lib.std.strict' (_G)
local cjson = require("json4lua.json.json") --https://gobyexample.com/json
require 'player'
require 'missile'
require 'spaceship'
requestManager = require 'request-manager'
gameManager = require 'GameManager'

printf = function(s,...)
    return io.write(s:format(...))
end

function love.load()
    local rooms = requestManager.get("rooms")
    printf('get rooms dunn: %s\n', table.concat(rooms))
    for key, roomString in ipairs(rooms) do
        printf("::::rooms: %s -> %s\n", key, roomString)
        local room = cjson.decode(roomString)
        for roomId, v in pairs(room) do
            printf("::::::::room: %s -> %s\n", roomId, v.roomId)
            local url = string.format("room/join?roomid=%s", roomId)
            local rooms = requestManager.postObject(url, gameManager.hero)
            break
        end
    end
    -- local key, roomString = pairs(rooms)(rooms)
    -- printf("choose room: key <%s>\nchoose roomString: <%s>\n", key, roomString)
    -- local room = cjson.decode(roomString, 1)
    -- printf('choose room dunn: %s\n', table.concat(room))
    -- local roomid = room.Uuid
    -- printf("roomid %s\n", roomid)
end

function love.quit()
    print("we are exiting")
end

function checkKeys()
    gameManager.getPlayer(1).spaceship.shooting = love.keyboard.isDown("q")
    gameManager.getPlayer(2).spaceship.shooting = love.keyboard.isDown(".")
end

function love.keypressed(key)
    checkKeys()

    if key == 'up' then
        gameManager.getInstance().getPlayer(2).spaceship.acceleration = 100
    elseif key == 'down' then
        gameManager.getInstance().getPlayer(2).spaceship.acceleration = -100
    end

    if key == 'w' then
        gameManager.getInstance().getPlayer(1).spaceship.acceleration = 100
    elseif key == 's' then
        gameManager.getInstance().getPlayer(1).spaceship.acceleration = -100
    end

    if key == 'left' then
        gameManager.getInstance().getPlayer(2).spaceship.polarVelocity = -3
    elseif key == 'right' then
        gameManager.getInstance().getPlayer(2).spaceship.polarVelocity = 3
    end

    if key == 'a' then
        gameManager.getInstance().getPlayer(1).spaceship.polarVelocity = -3
    elseif key == 'd' then
        gameManager.getInstance().getPlayer(1).spaceship.polarVelocity = 3
    end

    local request = {}
    request.player = gameManager.getInstance().getPlayer(1)
    request.missiles = {}
    for _,missile in ipairs(gameManager.getInstance().missiles) do
        if missile.owner == request.player and missile.alive then
            table.insert(request.missiles, missile)
        end
    end

    requestManager.postObject("player/update", request)
end

function love.keyreleased(key)
    checkKeys()
    -- printf('key up %s\n', key)

    if key == 'up' or key == 'down' then
        printf('kill accel %s\n', key)
        gameManager.getInstance().getPlayer(2).spaceship.acceleration = 0
    end
    if key == 'left' or key == 'right' then
        gameManager.getInstance().getPlayer(2).spaceship.polarVelocity = 0
    end

    if key == 'w' or key == 's' then
        gameManager.getInstance().getPlayer(1).spaceship.acceleration = 0
    end
    if key == 'a' or key == 'd' then
        gameManager.getInstance().getPlayer(1).spaceship.polarVelocity = 0
    end

    requestManager.postObject("player/update", gameManager.getInstance().getPlayer(1))
end

function love.update(dt)
    if gameManager.theInstance then
        gameManager.update(dt)
    end
end

function love.draw()
    gameManager.draw()
end
