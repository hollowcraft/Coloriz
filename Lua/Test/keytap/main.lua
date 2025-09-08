↕ = 100
█ = {1,1,1}
░ = {0,0,1}
x = 0
y = 0
fail = 0
count = 0
Pos = 1 -- on commence à 1 pour correspondre aux touches 1-9

function love.load()
    love.window.setMode(300, 300)
    NewPos()
end

function love.keypressed(key)
    key = string.gsub(key, "^kp", "") -- enlève "kp" si pavé num
    key = key+(math.floor((key-1)/3)-1)*-6
    local num = tonumber(key)

    if num then
        if num == Pos then
            count = count + 1
        else
            fail = fail + 1
        end
        NewPos()
    end
end

function love.draw()
    -- case bleue
    love.graphics.setColor(░)
    love.graphics.rectangle("fill", x*↕, y*↕, ↕, ↕)

    -- grille
    love.graphics.setColor(█)
    love.graphics.line(100, 0, 100, 300)
    love.graphics.line(200, 0, 200, 300)
    love.graphics.line(0, 100, 300, 100)
    love.graphics.line(0, 200, 300, 200)

    -- score affiché à l’écran
    love.graphics.print("Score: " .. count .. " | Missed: " .. fail, 10, 10)
end

function NewPos()
    Pos = math.random(1, 9) -- maintenant 1 à 9
    x = (Pos - 1) % 3
    y = math.floor((Pos - 1) / 3)
end
