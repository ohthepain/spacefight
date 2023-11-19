require 'spaceship'
require 'missile'
require 'player'
require 'request-manager'
require 'testrequest'

screenwidth = love.graphics.getWidth()
screenheight = love.graphics.getHeight()
-- x, y = screenwidth / 2, screenheight / 2
-- xv, yv = 0, 0
-- r = 0
-- drag = 0.999

missiles = {}
spaceships = {}
player1 = Player.new("foo")
player2 = Player.new("bar")
-- sendRequest()

function reset()
    hero = Spaceship.new(screenwidth / 5, screenheight / 2, math.pi)
    enemy = Spaceship.new(screenwidth * 4 / 5, screenheight / 2, 0)
    player1.spaceship = hero
    player2.spaceship = enemy
    for i,missile in ipairs(missiles) do
        missile.alive = false
    end
    missiles = {}
    spaceships = {}
    table.insert(spaceships, hero)
    table.insert(spaceships, enemy)
end    

function score(spaceship)
    if player1.spaceship == spaceship then
        player1.score = player1.score + 1
    else
        player2.score = player2.score + 1
    end
end

function shootMissile(owner)
    missile = Missile.new(owner)
    table.insert(missiles, missile)
end

function love.load()
    image = love.graphics.newImage("assets/love-ball.png")
    h = 64
    w = 64
    reset()

    requestManager = RequestManager.new("http://0.0.0.0:8080/api/")
    requestManager.sendObject("/spaceship/update", player1)
end

function love.keypressed(key)
    if key == 't' then
        enemy_speed = 15
    end
end

function love.keyreleased(key)
    if key == 't' then
        enemy_speed = 30 -- 't' key has been released
    end
end

function love.update(dt)

    missilescopy = {}
    for n, missile in ipairs(missiles) do
        missile.update(dt)
        if missile.alive then
            table.insert(missilescopy, missile)
        end
    end
    missiles = missilescopy

    for n, spaceship in ipairs(spaceships) do
        spaceship.update(dt)
    end

    if love.keyboard.isDown("left") then
        enemy.turn(-3 * dt)
    end
    if love.keyboard.isDown("right") then
        enemy.turn(3 * dt)
    end
    if love.keyboard.isDown("up") then
        enemy.accelerate(dt * 100)
    end
    if love.keyboard.isDown("down") then
        enemy.accelerate(dt * -100)
    end
    if love.keyboard.isDown(".") then
        enemy.shoot()
    end

    if love.keyboard.isDown("a") then
        hero.turn(-3 * dt)
    end
    if love.keyboard.isDown("d") then
        hero.turn(3 * dt)
    end
    if love.keyboard.isDown("w") then
        hero.accelerate(dt * 100)
    end
    if love.keyboard.isDown("s") then
        hero.accelerate(dt * -100)
    end
    if love.keyboard.isDown("q") then
        hero.shoot()
    end
end

function love.draw()
    for n, missile in ipairs(missiles) do
        missile.draw()
    end

    for n, spaceship in ipairs(spaceships) do
        spaceship.draw()
    end
end
