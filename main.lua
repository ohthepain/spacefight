require 'spaceship'
require 'missile'

screenwidth = love.graphics.getWidth()
screenheight = love.graphics.getHeight()
-- x, y = screenwidth / 2, screenheight / 2
-- xv, yv = 0, 0
-- r = 0
-- drag = 0.999

missiles = {}
spaceships = {}
hero = Spaceship.new(screenwidth / 5, screenheight / 2, math.pi)
enemy = Spaceship.new(screenwidth * 4 / 5, screenheight / 2, 0)
table.insert(spaceships, hero)
table.insert(spaceships, enemy)

function shootMissile(owner)
    missile = Missile.new(owner)
    table.insert(missiles, missile)
end

function love.load()
    image = love.graphics.newImage("assets/love-ball.png")
    h = 64
    w = 64
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
