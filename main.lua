require 'missile'

screenwidth = love.graphics.getWidth()
screenheight = love.graphics.getHeight()
x, y = screenwidth / 2, screenheight / 2
xv, yv = 0, 0
r = 0
-- drag = 0.999

missiles = {}

function shoot()
    missile = Missile.new(50, 50, math.pi * 1.5)
    table.insert(missiles, missile)
end

function love.load()
    image = love.graphics.newImage("assets/love-ball.png")
    h = 64
    w = 64

    shoot()
end

function love.update(dt)
    for n, missile in ipairs(missiles) do
        missile.update(dt)
    end

    if love.keyboard.isDown("left") then
    	r = r - 3 * dt
    end
    if love.keyboard.isDown("right") then
    	r = r + 3 * dt
    end
    if love.keyboard.isDown("up") then
        xv = xv + dt * 100 * math.sin(r)
        yv = yv + dt * 100 * math.cos(r)
    end
    if love.keyboard.isDown("down") then
        xv = xv - dt * 100
        yv = yv - dt * 100
    end

    y = y + yv * dt
    x = x - xv * dt

    if x > screenwidth then
        x = 0
    elseif x < 0 then
        x = screenwidth
    end

    if y > screenheight then
        y = 0
    elseif y < 0 then
        y = screenheight
    end
end

function love.draw()
    love.graphics.draw(image, x, y, r, 1, 1, w/2, h/2)

    for n, missile in ipairs(missiles) do
        missile.draw()
    end
end

