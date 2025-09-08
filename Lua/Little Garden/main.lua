--require ("index")
Cooldown = 0
↕ = 150
█ = {1, 1, 1}
plant = {}
grow = {}
for i = 1, 25 do
    plant[i] = {id = 0, grow = 0}
    grow[i] = 0
end
index = {
    {3,1,{1,1,1},name="Rice"},
    {4,2,{0.9,0.8,0.5},name="Wheat",texture={"assets/wheat.png",4},water = 0},
    {5,3,{0.6,0.6,0.6},name="Cotton",texture={"assets/cotton.png",5},water = 0},
}
money = 0
Pos = 1
UnlockedPlants = {1,1,1}
Selected = 0
LastTime = 0

function love.load()
    love.window.setTitle("Little Garden")
    love.window.setMode(8*↕, 6*↕)
    love.graphics.setDefaultFilter("nearest", "nearest")
    for i = 1, #plant do
        plant[i].id = math.random(0, #index)
    end
    dirt = love.graphics.newImage("assets/dirt.png")
end

function love.update(dt)
    if Cooldown > 60*5 then
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
            if Selected ~= 0 and plant[Pos].id == 0 and UnlockedPlants[Selected] == 1 then
                plant[Pos].id = Selected
                grow[Pos] = 0
            end
            if plant[Pos].id ~= 0 and grow[Pos] == index[plant[Pos].id][1] then
                grow[Pos] =  int(math.random(0, 5)/5)
                money = money + index[plant[Pos].id][2]
                local WhoGrowLongest = WhoGrowLongest()
                if LastTime >= 2*WhoGrowLongest then
                    Cooldown = 0
                end
                LastTime = 0
            end
        end
        for i = 1, #index do
            local x0 = 6*↕ + 100 * ((i-1) % 2)
            local y0 = ↕ * math.floor((i-1)/2)
            if x >= x0 and x <= x0 + ↕ and y >= y0 and y <= y0 + ↕ then
                if Selected == i then
                    Selected = 0
                else
                    Selected = i
                end
            end
        end
    end

    if button == 2 then
        local gX = math.floor((x - 50) / ↕) + 1
        local gY = math.floor((y - 50) / ↕) + 1
        if gX >= 1 and gX <= 5 and gY >= 1 and gY <= 5 then
            Pos = (gY - 1) * 5 + gX
            plant[Pos].id = 0
        end
    end
end

function love.draw()
    lgprint(money, 10, 10)
    lgprint(Cooldown, 10, 30)
    lgprint(grow[Pos], 10, 50)
    lgprint(plant[Pos].id, 10, 70)
    lgprint(Selected, 10, 90)
    lgprint(Pos, 10, 110)

    for i = 1, #grow do
        lgsetColor(█)
        love.graphics.draw(dirt, ((i-1) % 5) * ↕ + 50, math.floor((i-1) / 5) * ↕ + 50, 0, ↕/16, ↕/16)
        if plant[i].id ~= 0 and index[plant[i].id] then
            if index[plant[i].id].texture then
                local img = love.graphics.newImage(index[plant[i].id].texture[1])
                lgsetColor(█)
                -- définir la portion à afficher : ici 16 pixels de large par case
                local frame_width = 16
                local frame_height = img:getHeight()
                local x0 = (grow[i]-1) * 16 -- pixels horizontaux à prendre
                local quad = love.graphics.newQuad(x0, 0, frame_width, frame_height, img:getDimensions())

                -- dessiner la portion dans la case
                love.graphics.draw(
                    img,
                    quad,
                    ((i-1) % 5) * ↕ + 50,
                    math.floor((i-1) / 5) * ↕ + 50 - ↕*(img:getHeight()/16-1),
                    0,
                    ↕ / frame_width,  -- scale X
                    ↕ / frame_height *(img:getHeight()/16)  -- scale Y
                )
            else
                local progress = grow[i] / index[plant[i].id][1]
                local baseColor = index[plant[i].id][3]
                lgsetColor(
                    baseColor[1] * progress,
                    baseColor[2] * progress,
                    baseColor[3] * progress
                )
                local x = ((i-1) % 5) * ↕ + 50
                local y = math.floor((i-1) / 5) * ↕ + 50
                lgrectangle("fill", x, y, ↕, ↕)

                if grow[i] == index[plant[i].id][1] then
                    lgsetColor(0.3,0.2,0.5, 0.5)
                    lgrectangle("fill", x, y, ↕, ↕)
                end
            end
        end
    end

    lgsetColor(█)
    lgrectangle("line", 50, 50, 5*↕, 5*↕)
    
    for i = 1, 4 do
        lgline(50+↕*i, 50, 50+↕*i, 50+5*↕)
        lgline(50, 50+↕*i, 50+5*↕, 50+↕*i)
    end

    for i = 1, 3 do
        local y = ↕ * math.floor(i/2+0.5) - ↕
        local x = 6*↕ + ↕ * (i % 2)
        lgsetColor(index[i][3])
        lgrectangle("fill", x, y, ↕, ↕)
        lgsetColor(█)
        lgrectangle("line", x, y, ↕, ↕)
    end
    lgline(6*↕, 0, 6*↕, 6*↕)
end

function UpdatePlants()
    for i, v in pairs(grow) do
        local p = plant[i].id
        if p ~= 0 and index[p] then
            if grow[i] < index[p][1] then
                grow[i] = grow[i] + 1
                LastTime = LastTime + 1
            end
        end
    end
end



function lgline(x1, y1, x2, y2)
    love.graphics.line(x1, y1, x2, y2)
end
function lgrectangle(mode, x, y, width, height, rx, ry, segments)
    love.graphics.rectangle(mode, x, y, width, height, rx or 0, ry or 0, segments or 0)
end
function lgsetColor(r, g, b, a)
    love.graphics.setColor(r, g, b, a or 1)
end
function lgprint(text, x, y)
    love.graphics.print(text, x, y)
end
function int(n)
    return math.floor(n + 0.5)
end

function WhoGrowLongest()
    local longest = 0
    for i = 1, #plant do
        local id = plant[i].id
        if id ~= 0 then
            local remaining = index[id][1] - grow[i]
            if remaining > longest then
                longest = remaining
            end
        end
    end
    return longest
end