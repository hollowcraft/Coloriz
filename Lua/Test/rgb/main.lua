local t = 0

function love.load()
    love.window.setMode(400, 400)
end

function love.update(dt)
    t = t + dt -- avance doucement avec le temps
end

function love.draw()
    -- sinus pour chaque canal avec un décalage de phase
    local r = (math.sin(t) + 1) / 2
    local g = (math.sin(t + 2*math.pi/3) + 1) / 2
    local b = (math.sin(t + 4*math.pi/3) + 1) / 2

    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", 0, 0, 400, 400)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(string.format("R: %.2f\nG: %.2f\nB: %.2f", r, g, b), 10, 10)
end
