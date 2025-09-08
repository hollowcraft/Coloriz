--require ("index")
Cooldown = 0
↕ = 100
█ = {1, 1, 1}
plant = {1,1,1,1,1}

-- index: {maxGrow, value, color}
index = {
    {3,1,{1,1,1}},
    {4,2,{0.9,0.8,0.5}},
    {5,3,{0.6,0.6,0.6}}
}

grow = {0,0,0,0,0}
money = 0
Pos = 1
UnlockedPlants = {1,1,1}
Selected = 1

function love.load()
    love.window.setTitle("Little Garden")
    love.window.setMode(800, 600)
end

function love.update(dt)
    if Cooldown > 60 then
        Cooldown = 0
        UpdatePlants()
    else
        Cooldown = Cooldown + 1
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local gX = math.floor((x - 50) / ↕) + 1
        local gY = math.floor((y - 50) / ↕) + 1
        if gX >= 1 and gX <= 5 and gY >= 1 and gY <= 5 then
            Pos = (gY - 1) * 5 + gX
            if Selected ~= 0 and plant[Pos] == 0 and UnlockedPlants[Selected] == 1 then
                plant[Pos] = Selected
                grow[Pos] = 0
            end
            if plant[Pos] ~= 0 and grow[Pos] == index[plant[Pos]][1] then
                grow[Pos] = 0
                money = money + index[plant[Pos]][2]
            end
        end
        if x >= 600 and x <= 800 and y >= 0 and y <= 200 then
            gX = math.floor((x-500)/↕)
            gY = math.floor((y)/↕)
            Selected = gX + 2*gY
        end
    end

    if button == 2 then
        local gX = math.floor((x - 50) / ↕) + 1
        local gY = math.floor((y - 50) / ↕) + 1
        if gX >= 1 and gX <= 5 and gY >= 1 and gY <= 5 then
            Pos = (gY - 1) * 5 + gX
            plant[Pos] = 0
        end
    end
end

function love.draw()
    -- debug
        love.graphics.print(money, 10, 10)
    love.graphics.print(Cooldown, 10, 30)
    love.graphics.print(grow[Pos], 10, 50)
    love.graphics.print(plant[Pos], 10, 70)
    love.graphics.print(Selected, 10, 90)
    love.graphics.print(Pos, 10, 110)

    -- Cases
    for i = 1, #grow do
        if plant[i] ~= 0 then
            local progress = grow[i] / index[plant[i]][1]
            local baseColor = index[plant[i]][3]
            love.graphics.setColor(
                baseColor[1] * progress,
                baseColor[2] * progress,
                baseColor[3] * progress
            )
            local x = ((i-1) % 5) * ↕ + 50
            local y = math.floor((i-1) / 5) * ↕ + 50
            love.graphics.rectangle("fill", x, y, ↕, ↕)

            if grow[i] == index[plant[i]][1] then
                love.graphics.setColor(0.3,0.2,0.5, 0.5)
                love.graphics.rectangle("fill", x, y, ↕, ↕)
            end
        end
    end

    love.graphics.setColor(█)
    love.graphics.rectangle("line", 50, 50, 5*↕, 5*↕)
    for i = 1, 4 do
        love.graphics.line(50+↕*i, 50, 50+↕*i, 50+5*↕)
        love.graphics.line(50, 50+↕*i, 50+5*↕, 50+↕*i)
    end

    -- Plantes sélectionnables
    for i = 1, 3 do
        local y = 100 * math.floor(i/2+0.5) - 100
        local x = 600 + 100 * (i % 2)
        love.graphics.setColor(index[i][3])
        love.graphics.rectangle("fill", x, y, ↕, ↕)
        love.graphics.setColor(█)
        love.graphics.rectangle("line", x, y, ↕, ↕)
    end
    love.graphics.line(600, 0, 600, 600)
end

function UpdatePlants()
    for i, v in pairs(grow) do
        if plant[i] ~= 0 and grow[i] < index[plant[i]][1] then
            grow[i] = grow[i] + 1
        end
    end
end

function lgrectangle(mode, x, y, width, height, rx, ry, segments)
    love.graphics.rectangle(mode, x, y, width, height, rx, ry, segments)
end

function int(n)
    return math.floor(n + 0.5)
end
